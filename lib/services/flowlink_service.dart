import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';
import 'package:http/http.dart' as http;

class FlowLinkService {
  FlowLinkService._();
  static final FlowLinkService _instance = FlowLinkService._();
  factory FlowLinkService() => _instance;

  // Temporary base until flip to flow.jiwabakti.com
  static const String _base =
      'https://webnyou-flow-link-webnyou-jiwa-bakti-flowlinks.web.app';

  static Uri get _createUrl => Uri.parse('$_base/api/links');
  static Uri _resolveUrl(String code) => Uri.parse('$_base/api/resolve/$code');

  // Add AppLinks instance
  final AppLinks _appLinks = AppLinks();
  StreamSubscription? _sub;
  
  // Prevent double-handling of the same code (cold-start + foreground)
  final Set<String> _handledCodes = <String>{};
  bool _isInit = false;

  // change the signature
  static Future<String?> createFlowLink({
    required String link,
    String? type,
    Object? id,
    Map<String, dynamic>? meta,
  }) async {
    try {
      final body = <String, dynamic>{
        'link': link,
        if (type != null) 'type': type,
        if (id != null) 'id': id.toString(),
        if (meta != null) 'meta': meta,
      };
      final res = await http.post(
        _createUrl,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (res.statusCode != 200) return null;
      return (jsonDecode(res.body) as Map)['shortLink'] as String?;
    } catch (_) {
      return null;
    }
  }

  // and let the helper accept int or String
  static Future<String?> createNewsLink(Object articleId) {
    return createFlowLink(
      link: 'https://jiwabakti.com/news/$articleId',
      type: 'news',
      id: articleId,
    );
  }

  Future<void> init(GoRouter router) async {
    if (_isInit) return;
    _isInit = true;

    debugPrint('🚀 Initializing FlowLinks listener…');

    // Foreground links (while the app is running)
    _sub = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleIncomingUri(uri, router);
        }
      },
      onError: (err) => debugPrint('❌ FlowLinks listener error: $err'),
    );

    // Cold start link (app launched from a link)
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        _handleIncomingUri(initial, router);
      } else {
        debugPrint('ℹ No FlowLink detected on cold start.');
      }
    } catch (e) {
      debugPrint('❌ Failed to handle initial URI: $e');
    }

    debugPrint('✅ FlowLinks initialized');
  }

  /// Handle incoming deep link URI
  Future<void> _handleIncomingUri(Uri uri, GoRouter router) async {
    debugPrint('🌐 Received URI: $uri');

    // A) Custom scheme: jiwabakti://news/<code>
    if (uri.scheme == 'jiwabakti' && uri.host == 'news') {
      final code = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      if (code != null && code.isNotEmpty) {
        if (_handledCodes.contains(code)) {
          debugPrint('⏭ already handled code $code');
          return;
        }
        _handledCodes.add(code);

        final payload = await _resolve(code);
        if (payload == null) {
          debugPrint('⚠ resolve returned null for $code');
          return;
        }
        _routeFromPayload(payload, router);
      } else {
        debugPrint('⚠ Missing code in custom-scheme URI');
      }
      return; // ← stop here, we handled custom scheme
    }

    // B) HTTPS from our hosts
    const hosts = <String>{
      'webnyou-flow-link-webnyou-jiwa-bakti-flowlinks.web.app',
      'webnyou-flow-link-webnyou-jiwa-bakti-flowlinks.firebaseapp.com',
      // 'flow.jiwabakti.com',
    };
    if (!hosts.contains(uri.host)) {
      debugPrint('↪ ignoring host ${uri.host}');
      return;
    }

    // B1) Short code at root: https://host/<code>
    if (uri.pathSegments.length == 1 &&
        RegExp(r'^[A-Za-z0-9_-]{4,12}$').hasMatch(uri.pathSegments.first)) {
      final code = uri.pathSegments.first;
      if (_handledCodes.contains(code)) {
        debugPrint('⏭ already handled code $code');
        return;
      }
      _handledCodes.add(code);

      final payload = await _resolve(code);
      if (payload == null) {
        debugPrint('⚠ resolve returned null for $code');
        return;
      }
      _routeFromPayload(payload, router);
      return;
    }

    // B2) Legacy: https://host/news?id=123
    if (uri.path == '/news') {
      final newsId = uri.queryParameters['id'];
      if (newsId != null && newsId.isNotEmpty) {
        debugPrint('➡ Navigating to /news/$newsId (https deep link)');
        router.go('/news/$newsId');
      } else {
        debugPrint('⚠ Missing news ID in FlowLink');
      }
      return;
    }

    debugPrint('⚠ Unknown FlowLink path: ${uri.path}');
  }

  Future<Map<String, dynamic>?> _resolve(String code) async {
    try {
      final res = await http.get(_resolveUrl(code));
      if (res.statusCode != 200) {
        debugPrint('❌ resolve $code -> ${res.statusCode}: ${res.body}');
        return null;
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      debugPrint('✅ Resolved $code -> $data');
      return data;
    } catch (e, st) {
      debugPrint('❌ Exception resolving code $code: $e\n$st');
      return null;
    }
  }

  void _routeFromPayload(Map<String, dynamic> data, GoRouter router) {
    final type = data['type']?.toString();
    final idStr = data['id']?.toString();
    final link = data['link']?.toString();

    if (type == 'news' && idStr != null && idStr.isNotEmpty) {
      debugPrint('➡ Navigating to /news/$idStr (resolved)');
      router.go('/news/$idStr');
      return;
    }

    if (link != null && link.isNotEmpty) {
      debugPrint('ℹ No in-app route; external link: $link');
      // Optionally launch externally with url_launcher.
    } else {
      debugPrint('⚠ Unknown payload: $data');
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    _handledCodes.clear();
    _isInit = false;
  }
}