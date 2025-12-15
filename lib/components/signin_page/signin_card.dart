//singin_card.dart
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jiwa_bakti/components/common/rounded_text_button.dart';
import 'package:jiwa_bakti/components/common/rounded_text_form_field.dart';
import 'package:jiwa_bakti/enums/status.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/services/api_service.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:jiwa_bakti/utils/show_toast.dart';
import 'package:jiwa_bakti/utils/validation_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jiwa_bakti/models/social_signup_data.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SigninCard extends StatefulWidget {
  const SigninCard({super.key});

  @override
  State<SigninCard> createState() => SigninCardState();
}

class SigninCardState extends State<SigninCard> {
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  bool buttonAllowed = false;
  bool emailValidated = false;
  bool passwordValidated = false;
  bool _isLoading = false;

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  bool get _isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256OfString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _redirectToSocialSignup({
    required fb.User firebaseUser,
    required String provider,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    if (!mounted) return;

    context.push(
      "/signup/$provider",
      extra: SocialSignupData(
        uid: firebaseUser.uid,
        email: email,
        name: displayName,
        photo: photoUrl,
        provider: provider,
      ),
    );
  }

  Future<void> _processSocialSignIn({
    required fb.User firebaseUser,
    required String provider,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    final apiService = GetIt.I<ApiService>();
    final user = GetIt.I<User>();

    final signInData = {
      "username": email,
      "password": firebaseUser.uid,
    };

    debugPrint("---------- TRYING $provider SIGN-IN (as email/password)");
    debugPrint("---------- DATA: $signInData");

    try {
      final response = await apiService.signIn(signInData);

      debugPrint("---------- SIGN-IN RESPONSE: $response");

      if (response['status'] == 'success') {
        debugPrint("---------- LOGIN SUCCESS, SAVING DATA");

        final token = response['token']?.toString();
        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          debugPrint("---------- TOKEN SAVED: $token");
        }

        debugPrint("---------- REMEMBERING LOGIN");
        await user.rememberLogin(email, firebaseUser.uid);

        if (response['details'] != null &&
            response['details'] is List &&
            (response['details'] as List).isNotEmpty) {
          debugPrint("---------- LOGGING IN USER");
          await user.login(response['details'][0], email);
          debugPrint(
            "---------- USER LOGGED IN: ${user.firstName} ${user.lastName}",
          );
        }

        if (mounted) {
          debugPrint("---------- SHOWING SUCCESS TOAST");
          showFToast(
            context: context,
            status: Status.success,
            message: "Welcome back!",
          );

          await Future.delayed(const Duration(milliseconds: 500));

          if (mounted) {
            debugPrint("---------- NAVIGATING TO HOME");
            context.go('/');
          }
        }
      } else {
        debugPrint("---------- USER NOT FOUND, REDIRECTING TO SIGNUP");
        await _redirectToSocialSignup(
          firebaseUser: firebaseUser,
          provider: provider,
          email: email,
          displayName: displayName,
          photoUrl: photoUrl,
        );
      }
    } catch (e, stackTrace) {
      debugPrint("---------- SIGN-IN ERROR: $e");
      debugPrint("---------- STACK TRACE: $stackTrace");
      debugPrint("---------- REDIRECTING TO SIGNUP");

      await _redirectToSocialSignup(
        firebaseUser: firebaseUser,
        provider: provider,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
      );
    }
  }

  /// Google Sign-In Method - Try sign-in first, then signup if needed
  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      fb.UserCredential creds;

      if (kIsWeb) {
        final provider = fb.GoogleAuthProvider()
          ..addScope('email')
          ..setCustomParameters({'prompt': 'select_account'});

        creds = await fb.FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.signOut(); // force chooser
        final gUser = await googleSignIn.signIn();

        if (gUser == null) {
          setState(() => _isLoading = false);
          return;
        }

        final gAuth = await gUser.authentication;

        final credential = fb.GoogleAuthProvider.credential(
          idToken: gAuth.idToken,
          accessToken: gAuth.accessToken,
        );

        creds = await fb.FirebaseAuth.instance.signInWithCredential(credential);
      }

      final firebaseUser = creds.user;

      if (firebaseUser != null) {
        final email = firebaseUser.email;

        if (email == null || email.isEmpty) {
          throw Exception("Google account did not return an email.");
        }

        await _processSocialSignIn(
          firebaseUser: firebaseUser,
          provider: "google",
          email: email,
          displayName: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
        );
      }
    } catch (e, stackTrace) {
      debugPrint("---------- GOOGLE SIGN-IN OUTER ERROR: $e");
      debugPrint("---------- OUTER STACK TRACE: $stackTrace");

      if (mounted) {
        showFToast(
          context: context,
          status: Status.error,
          message: "Google sign-in failed. Please try again.",
        );
      }
    } finally {
      if (mounted) {
        debugPrint("---------- CLEANING UP");
        setState(() => _isLoading = false);
      }
    }
  }

  /// Apple Sign-In Method - Mirrors Google flow
  Future<void> _signInWithApple() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      fb.UserCredential creds;
      String? appleEmail;
      String? appleDisplayName;

      if (kIsWeb) {
        final provider = fb.AppleAuthProvider()
          ..addScope('email')
          ..addScope('name');

        creds = await fb.FirebaseAuth.instance.signInWithPopup(provider);

        final profile = creds.additionalUserInfo?.profile;
        if (profile case final Map<String, dynamic> profileMap) {
          final givenName =
              (profileMap['given_name'] ?? profileMap['firstName']) as String?;
          final familyName = (profileMap['family_name'] ?? profileMap['lastName'])
              as String?;
          final parts = <String>[];

          if (givenName != null && givenName.trim().isNotEmpty) {
            parts.add(givenName.trim());
          }
          if (familyName != null && familyName.trim().isNotEmpty) {
            parts.add(familyName.trim());
          }

          if (parts.isNotEmpty) {
            appleDisplayName = parts.join(" ");
          }
        }
      } else {
        final rawNonce = _generateNonce();
        final nonce = _sha256OfString(rawNonce);

        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: const [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        appleEmail = appleCredential.email;
        final appleNames = [
          appleCredential.givenName,
          appleCredential.familyName,
        ].whereType<String>().where((value) => value.trim().isNotEmpty).toList();

        if (appleNames.isNotEmpty) {
          appleDisplayName = appleNames.join(" ").trim();
        }

        final oauthCredential = fb.OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );

        creds =
            await fb.FirebaseAuth.instance.signInWithCredential(oauthCredential);
      }

      final firebaseUser = creds.user;

      if (firebaseUser != null) {
        final email = firebaseUser.email ?? appleEmail;

        if (email == null || email.isEmpty) {
          throw Exception("Apple sign-in did not return an email.");
        }

        final resolvedName = (appleDisplayName?.isNotEmpty ?? false)
            ? appleDisplayName
            : firebaseUser.displayName;

        await _processSocialSignIn(
          firebaseUser: firebaseUser,
          provider: "apple",
          email: email,
          displayName: resolvedName,
          photoUrl: firebaseUser.photoURL,
        );
      }
    } on SignInWithAppleAuthorizationException catch (e, stackTrace) {
      debugPrint("---------- APPLE SIGN-IN AUTH ERROR: $e");
      debugPrint("---------- STACK TRACE: $stackTrace");

      if (e.code != AuthorizationErrorCode.canceled && mounted) {
        showFToast(
          context: context,
          status: Status.error,
          message: "Apple sign-in failed. Please try again.",
        );
      }
    } catch (e, stackTrace) {
      debugPrint("---------- APPLE SIGN-IN OUTER ERROR: $e");
      debugPrint("---------- OUTER STACK TRACE: $stackTrace");

      if (mounted) {
        showFToast(
          context: context,
          status: Status.error,
          message: "Apple sign-in failed. Please try again.",
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  void checkButtonAllowed(){
    if(emailValidated && passwordValidated){
      buttonAllowed = true;
    }else{
      buttonAllowed = false;
    }
  }

  void onEmailChange(){
    setState(() {
      if(_emailFieldKey.currentState!.validate()){
        emailValidated = true;
      }else{
        emailValidated = false;
      }
      checkButtonAllowed();
    });
  }

  void onPasswordChange(){
    setState(() {
      if(_passwordFieldKey.currentState!.validate()){
        passwordValidated = true;
      }else{
        passwordValidated = false;
      }
      checkButtonAllowed();
    });
  }

  void initializeFocusNode(){
    emailFocusNode = FocusNode();
    emailFocusNode.addListener(() {
      setState(() {
        if (!emailFocusNode.hasFocus) {
          if(_emailFieldKey.currentState!.validate()){
            emailValidated = true;
          }else{
            emailValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
    passwordFocusNode = FocusNode();
    passwordFocusNode.addListener(() {
      setState(() {
        if (!passwordFocusNode.hasFocus) {
          if(_passwordFieldKey.currentState!.validate()){
            passwordValidated = true;
          }else{
            passwordValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
  }

  @override
  void initState(){
    super.initState();
    initializeFocusNode();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    final apiService = GetIt.I<ApiService>();

    return Form(
      key: _formKey,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(210, 210, 210, 1.0),
              spreadRadius: 0,
              blurRadius: 10),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "E-mel",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              child: RoundedTextFormField(
                focusNode: emailFocusNode,
                formFieldKey: _emailFieldKey,
                label: "",
                isDense: true,
                borderRadius: BorderRadius.circular(5.sp),
                controller: _emailTextEditingController,
                validator: validateEmail,
                showTick: emailValidated,
                onChanged: (value){
                  onEmailChange();
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Kata laluan",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              child: RoundedTextFormField(
                focusNode: passwordFocusNode,
                formFieldKey: _passwordFieldKey,
                label: "",
                isPasswordField: true,
                isDense: true,
                borderRadius: BorderRadius.circular(5.sp),
                controller: _passwordTextEditingController,
                validator: validatePassword,
                onChanged: (value){
                  onPasswordChange();
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: user.textSizeScale < 1.2
                    ? 30.w
                    : user.textSizeScale < 1.5
                      ? 35.w
                      : 40.w,
                child: RoundedTextButton(
                  text: const Text(
                    "Daftar Masuk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: !buttonAllowed || _isLoading
                      ? (){
                          print("---------- BUTTON NOT ALLOWED");
                        }
                      : () async{
                          print("---------- BUTTON ALLOWED");
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            print("---------- VALIDATED");
                            setState(() => _isLoading = true);
                            
                            try {
                              final user = GetIt.I<User>();
                              String email = _emailTextEditingController.text;
                              String password = _passwordTextEditingController.text;
                              Map<String, dynamic> data = {
                                "username" : email,
                                "password" : password,
                              };
                              print("---------- SENDING TO API");
                              await apiService.signIn(data).then((response) {
                                print("---------- API RESPONDED");
                                String responseMessage = response['message'];
                                bool loginSuccess = response['status'] == "success";
                                showFToast(
                                  context: context,
                                  status: loginSuccess
                                      ? Status.success
                                      : Status.error,
                                  message: responseMessage,
                                );
                                if(loginSuccess){
                                  user.rememberLogin(email, password);
                                  user.login(response['details'][0], email);
                                  context.go("/");
                                }
                              });
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
                          }
                        },
                  foregroundColor: buttonAllowed && !_isLoading
                      ? themeOptions.primaryColor
                      : themeOptions.secondaryColor,
                  backgroundColor: buttonAllowed && !_isLoading
                      ? themeOptions.primaryColor
                      : themeOptions.secondaryColor,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                "Atau",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (_isIOS) ...[
              Center(
                child: SizedBox(
                  width: 70.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: _isLoading ? null : _signInWithApple,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(FontAwesomeIcons.apple, size: 24),
                              const SizedBox(width: 12),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Continue with Apple",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            if (_isAndroid) ...[
              Center(
                child: SizedBox(
                  width: 70.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(FontAwesomeIcons.google, size: 20),
                              const SizedBox(width: 12),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Continue with Google",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
            // Center(
            //   child: InkWell(
            //     onTap: (){
            //       context.push("/forgot-password");
            //     },
            //     child: const Text(
            //       "Lupa kata laluan?",
            //       style: TextStyle(
            //         fontSize: 16,
            //         decoration: TextDecoration.underline,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
