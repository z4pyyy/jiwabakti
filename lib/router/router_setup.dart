import 'package:go_router/go_router.dart';
import 'package:jiwa_bakti/pages/archive_detail_page.dart';
import 'package:jiwa_bakti/pages/archive_page.dart';
import 'package:jiwa_bakti/pages/category_page.dart';
import 'package:jiwa_bakti/pages/edit_profile_page.dart';
import 'package:jiwa_bakti/pages/profile_page.dart';
import 'package:jiwa_bakti/pages/saved_news_page.dart';
import 'package:jiwa_bakti/pages/search_page.dart';
import 'package:jiwa_bakti/pages/signin_page.dart';
import 'package:jiwa_bakti/pages/signup_option_page.dart';
import 'package:jiwa_bakti/pages/signup_page.dart';
import 'package:jiwa_bakti/pages/support_and_legal_page.dart';
import 'package:jiwa_bakti/pages/terkini_page.dart';
import 'package:jiwa_bakti/pages/text_size_page.dart';
import '../pages/category_detail_page.dart';
import 'package:jiwa_bakti/models/social_signup_data.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TerkiniPage()),
    GoRoute(
      path: '/category',
      builder: (context, state) => const CategoryPage(),
    ),
    GoRoute(path: '/archive', builder: (context, state) => const ArchivePage()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/support-and-legal',
      builder: (context, state) => const SupportAndLegalPage(),
    ),
    GoRoute(
      path: '/text-size',
      builder: (context, state) => const TextSizePage(),
    ),
    GoRoute(path: '/signin', builder: (context, state) => const SigninPage()),
    GoRoute(
      path: '/signup/:option',
      builder: (context, state) {
        final option = state.pathParameters['option'] ?? "email";

        return SignupPage(
          option: option,
          socialData: state.extra as SocialSignupData?,
        );
      },
    ),

    GoRoute(
      path: '/saved-news',
      builder: (context, state) => const SavedNewsPage(),
    ),
    GoRoute(
      path: '/signup-option',
      builder: (context, state) => const SignupOptionPage(),
    ),
    GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
    GoRoute(
      path: '/category/:category',
      builder: (context, state) {
        final category = state.pathParameters['category'];
        final categoryId = int.parse(category!);
        return CategoryDetailPage(categoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/archive/:year/:month',
      builder: (context, state) {
        final year = int.parse(state.pathParameters['year']!);
        final month = int.parse(state.pathParameters['month']!);
        return ArchiveDetailPage(year: year, month: month);
      },
    ),
    GoRoute(
      path: '/news/:id',
      name: 'news',
      builder: (context, state) {
        final idStr = state.pathParameters['id']!;
        final openId = int.tryParse(idStr);
        return TerkiniPage(openArticleId: openId);
      },
    ),
  ],
);
