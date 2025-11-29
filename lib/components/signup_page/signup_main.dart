//signup_page/signup_main.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jiwa_bakti/components/common/custom_divider.dart';
import 'package:jiwa_bakti/components/common/rounded_text_button.dart';
import 'package:jiwa_bakti/components/common/rounded_text_form_field.dart';
import 'package:jiwa_bakti/components/signup_page/signup_description.dart';
import 'package:jiwa_bakti/enums/status.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/services/api_service.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:jiwa_bakti/utils/show_toast.dart';
import 'package:jiwa_bakti/utils/validation_helpers.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';
import 'package:jiwa_bakti/models/google.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
class SignupMain extends StatefulWidget {
  final String option;
  final GoogleSignupData? googleData;

  const SignupMain({
    super.key,
    required this.option,
    this.googleData,
  });

  @override
  State<SignupMain> createState() => SignupMainState();
}

class SignupMainState extends State<SignupMain> {
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _firstNameTextEditingController = TextEditingController();
  final _confirmPasswordTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _ageTextEditingController = TextEditingController();

  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _confirmFieldKey = GlobalKey<FormFieldState>();
  final _firstNameFieldKey = GlobalKey<FormFieldState>();
  final _lastNameFieldKey = GlobalKey<FormFieldState>();
  final _ageFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode firstNameFocusNode;
  late FocusNode confirmPasswordFocusNode;
  late FocusNode lastNameFocusNode;
  late FocusNode ageFocusNode;

  bool buttonAllowed = false;
  bool emailValidated = false;
  bool passwordValidated = false;
  bool firstNameValidated = false;
  bool confirmPasswordValidated = false;
  bool lastNameValidated = false;
  bool ageValidated = false;

  late String option;
  bool isEmail = false;
  bool isChecked = false;

  final selectState = [
    "Johor",
    "Kedah",
    "Kelantan",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Penang",
    "Perak",
    "Perlis",
    "Sabah",
    "Sarawak",
    "Selangor",
    "Terengganu"
  ];
  String _currentSelectedState = "Sarawak";
  final String _currentSelectedCountry = "Malaysia";
  String errorMessage = "";
  /// Sign in after successful signup
/// Sign in after successful signup
Future<void> _signInAfterSignup(ApiService apiService, User user) async {
  try {
    Map<String, dynamic> signInData;

    if (option == "google" && widget.googleData != null) {
      // For Google users, sign in with email and firebase_uid as password
      signInData = {
        "username": widget.googleData!.email,
        "password": widget.googleData!.uid,
      };
      
      debugPrint("---------- GOOGLE SIGN-IN DATA (as email/password): $signInData");
    } else {
      // Email sign-in
      signInData = {
        "username": _emailTextEditingController.text,
        "password": _passwordTextEditingController.text,
      };
      
      debugPrint("---------- EMAIL SIGN-IN DATA: $signInData");
    }

    debugPrint("---------- SIGNING IN AFTER SIGNUP");
    final response = await apiService.signIn(signInData);
    
    debugPrint("---------- SIGN-IN RESPONSE: $response");

    if (response['status'] == 'success') {
      // Save token if provided
      final token = response['token']?.toString();
      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        debugPrint("---------- TOKEN SAVED");
      }

      // Remember login
      if (option == "google" && widget.googleData != null) {
        user.rememberLogin(widget.googleData!.email, widget.googleData!.uid);
      } else {
        user.rememberLogin(
          _emailTextEditingController.text,
          _passwordTextEditingController.text
        );
      }

      // Update user session
      if (response['details'] != null && response['details'].isNotEmpty) {
        await user.login(
          response['details'][0], 
          option == "google" 
            ? widget.googleData!.email 
            : _emailTextEditingController.text
        );
        debugPrint("---------- USER LOGGED IN");
      }

      // Navigate to home
      if (mounted) {
        showFToast(
          context: context,
          status: Status.success,
          message: "Welcome to JiwaBakti!",
        );
        context.go('/');
      }
    } else {
      debugPrint("Sign-in after signup failed: ${response['message']}");
      
      if (mounted) {
        showFToast(
          context: context,
          status: Status.error,
          message: "Signup successful, but auto sign-in failed. Please sign in manually.",
        );
        context.go('/signin');
      }
    }
  } catch (e, stackTrace) {
    debugPrint("---------- SIGN-IN EXCEPTION: $e");
    debugPrint("---------- STACK TRACE: $stackTrace");
    
    if (mounted) {
      showFToast(
        context: context,
        status: Status.error,
        message: "Signup successful, but auto sign-in failed. Please sign in manually.",
      );
      context.go('/signin');
    }
  }
}
  void checkButtonAllowed() {
  if (option == "google") {
    // Google SIGNUP — email field is readonly, no password needed
    if (firstNameValidated &&
        lastNameValidated &&
        ageValidated &&
        isChecked) {
      buttonAllowed = true;
      return;
    } else {
      // Build Google-specific error message
      errorMessage = "";
      if (!firstNameValidated || !lastNameValidated) {
        errorMessage += "- Please fill in a valid name\n";
      }
      if (!ageValidated) {
        errorMessage += "- Please fill in a valid age\n";
      }
      if (!isChecked) {
        errorMessage += "- Please check the T&C box";
      }
      buttonAllowed = false;
      return;
    }
  }

  // NORMAL EMAIL SIGNUP
  if (emailValidated &&
      passwordValidated &&
      confirmPasswordValidated &&
      firstNameValidated &&
      lastNameValidated &&
      ageValidated &&
      isChecked) {
    buttonAllowed = true;
  } else {
    errorMessage = "";
    if (!emailValidated) errorMessage += "- Please fill in a valid email\n";
    if (!passwordValidated || !confirmPasswordValidated) {
      errorMessage += "- Please fill in a valid password\n";
    }
    if (!firstNameValidated || !lastNameValidated) {
      errorMessage += "- Please fill in a valid name\n";
    }
    if (!ageValidated) errorMessage += "- Please fill in a valid age\n";
    if (!isChecked) errorMessage += "- Please agree to the T&C";
    buttonAllowed = false;
  }

  
}


  Future<void> _launchUrl(String stringUrl) async {
    final Uri url = Uri.parse(stringUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void emailOnChange(){
    setState(() {
      emailValidated = false;
      if(_emailFieldKey.currentState!.validate()){
        emailValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void passwordOnChange(){
    setState(() {
      passwordValidated = false;
      if(_passwordFieldKey.currentState!.validate()){
        passwordValidated = true;
      }
      confirmPasswordValidated = false;
      if(_confirmFieldKey.currentState!.validate()){
        confirmPasswordValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void firstNameOnChange(){
    setState(() {
      firstNameValidated = false;
      if(_firstNameFieldKey.currentState!.validate()) {
        firstNameValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void lastNameOnChange(){
    setState(() {
      lastNameValidated = false;
      if(_lastNameFieldKey.currentState!.validate()){
        lastNameValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void ageOnChange(){
    setState(() {
      ageValidated = false;
      if(_ageFieldKey.currentState!.validate()){
        ageValidated = true;
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
        if (!confirmPasswordFocusNode.hasFocus) {
          if(_confirmFieldKey.currentState!.validate()){
            confirmPasswordValidated = true;
          }else{
            confirmPasswordValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
    confirmPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode.addListener(() {
      setState(() {
        if (!passwordFocusNode.hasFocus) {
          if(_passwordFieldKey.currentState!.validate()){
            passwordValidated = true;
          }else{
            passwordValidated = false;
          }
        }
        if (!confirmPasswordFocusNode.hasFocus) {
          if(_confirmFieldKey.currentState!.validate()){
            confirmPasswordValidated = true;
          }else{
            confirmPasswordValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
    firstNameFocusNode = FocusNode();
    firstNameFocusNode.addListener(() {
      setState(() {
        if (!firstNameFocusNode.hasFocus) {
          if(_firstNameFieldKey.currentState!.validate()){
            firstNameValidated = true;
          }else{
            firstNameValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
    lastNameFocusNode = FocusNode();
    lastNameFocusNode.addListener(() {
      setState(() {
        if (!lastNameFocusNode.hasFocus) {
          if(_lastNameFieldKey.currentState!.validate()){
            lastNameValidated = true;
          }else{
            lastNameValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
    ageFocusNode = FocusNode();
    ageFocusNode.addListener(() {
      setState(() {
        if (!ageFocusNode.hasFocus) {
          if(_ageFieldKey.currentState!.validate()){
            ageValidated = true;
          }else{
            ageValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
  }

@override
void initState() {
  super.initState();
  initializeFocusNode();
  option = widget.option.toLowerCase();

  if (option == "google" && widget.googleData != null) {
    isEmail = false; // Google email cannot be edited
    _emailTextEditingController.text = widget.googleData!.email;

    // Try to split display name into first/last
    final parts = (widget.googleData!.name ?? "").split(" ");
    _firstNameTextEditingController.text = parts.isNotEmpty ? parts.first : "";
    _lastNameTextEditingController.text = parts.length > 1 ? parts.sublist(1).join(" ") : "";
  } 
  else if (option == "email") {
    isEmail = true;
  }
}


  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const SignupDescription(),
                const SizedBox(height: 10),
                const CustomDivider(),
                const SizedBox(height: 10),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Signup Method",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: 100.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.sp), // Rounded border
                              side: const BorderSide(color: Colors.grey, width: 1.5), // Optional border
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          onPressed: (){},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: 30,
                                child: Icon(
                                  option == "apple"
                                    ? FontAwesomeIcons.apple
                                    : option == "email"
                                      ? Icons.mail_outline_rounded
                                      : FontAwesomeIcons.google,
                                  size: option == "apple" ? 30 : 26,),
                              ),
                              const SizedBox(width: 10,),
                              Text(
                                option == "apple"
                                  ? "Apple"
                                  : option == "email"
                                    ? "Email"
                                    : "Google",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Nama diberi",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        child: RoundedTextFormField(
                          focusNode: firstNameFocusNode,
                          formFieldKey: _firstNameFieldKey,
                          label: "",
                          isDense: true,
                          borderRadius: BorderRadius.circular(5.sp),
                          controller: _firstNameTextEditingController,
                          validator: (value) =>
                              validateStringNotEmpty(value, "first name"),
                          showTick: firstNameValidated,
                          onChanged: (value){
                            firstNameOnChange();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Nama keluarga",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        child: RoundedTextFormField(
                          focusNode: lastNameFocusNode,
                          formFieldKey: _lastNameFieldKey,
                          label: "",
                          isDense: true,
                          borderRadius: BorderRadius.circular(5.sp),
                          controller: _lastNameTextEditingController,
                          validator: (value) =>
                              validateStringNotEmpty(value, "last name"),
                          showTick: lastNameValidated,
                          onChanged: (value){
                            lastNameOnChange();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Umur",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        child: RoundedTextFormField(
                          focusNode: ageFocusNode,
                          formFieldKey: _ageFieldKey,
                          label: "",
                          isDense: true,
                          borderRadius: BorderRadius.circular(5.sp),
                          controller: _ageTextEditingController,
                          validator: validateAge,
                          showTick: ageValidated,
                          onChanged: (value){
                            ageOnChange();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Negara",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(),
                                errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                hintText: 'Select Country',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.5.sp,
                                  ),
                                  borderRadius: BorderRadius.circular(5.sp),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _currentSelectedCountry,
                                  isDense: true,
                                  onChanged: null,
                                  items: ["Malaysia"].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 12.sp), // set your desired font size here
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Negeri",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(),
                                errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16),
                                hintText: 'Select State',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.5.sp,
                                  ),
                                  borderRadius: BorderRadius.circular(5.sp),
                                ),
                              ),
                              isEmpty: _currentSelectedState == '',
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _currentSelectedState,
                                  isDense: true,
                                  onChanged: (String? value) {
                                    setState(() {
                                      if(value != null) {
                                        _currentSelectedState = value;
                                        state.didChange(value);
                                      }
                                    });
                                  },
                                  items: selectState.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 12.sp), // set your desired font size here
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "Alamat E-mel",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                      child: RoundedTextFormField(
                        enable: option == "email",
                        label: "",
                        focusNode: emailFocusNode,
                        formFieldKey: _emailFieldKey,
                        controller: _emailTextEditingController,
                        validator: validateEmail,
                        showTick: emailValidated,
                        onChanged: (value){
                          emailOnChange();
                        },
                      ),
                    ),
                      const SizedBox(height: 20),
                      if(isEmail)...[
                                              ] else ...[
                        // GOOGLE SIGNUP → No password fields
                      ],
                      // =====================================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: isChecked,
                              checkColor: const Color(0xFFD24C00),
                              activeColor: const Color(0xFFF9C2A1),
                              onChanged: (bool? value) {
                                setState(() {
                                  if(value != null) {
                                    isChecked = value;
                                    checkButtonAllowed();
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "Saya telah membaca dan bersetuju dengan ",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Terma & Syarat ",
                                    style: const TextStyle(
                                      color: Color(0xFFD24C00),
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () async{
                                      await _launchUrl("https://utusansarawak.com.my/terms-and-conditions/");
                                    },
                                  ),
                                  const TextSpan(
                                    text: "dan ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Penafian JiwaBakti",
                                    style: const TextStyle(
                                      color: Color(0xFFD24C00),
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () async {
                                      await _launchUrl("https://utusansarawak.com.my/disclaimer/");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: 30.w,
                          child: RoundedTextButton(
                            text: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: themeOptions.textColorOnSecondary,
                                fontSize: user.textSizeScale * themeOptions.textSize2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: !buttonAllowed
    ? () {
        setState(() => checkButtonAllowed());
        showFToast(
          message: errorMessage,
          context: context,
          maxLine: 6,
          toastSeconds: 4,
          status: Status.error,
        );
      }
    : () async {
        FocusScope.of(context).unfocus();

        if (_formKey.currentState!.validate()) {
          final apiService = GetIt.I<ApiService>();
          final user = GetIt.I<User>();

          Map<String, dynamic> data;

          if (option == "google" && widget.googleData != null) {
            data = {
              "firebase_uid": widget.googleData!.uid,
              "email": widget.googleData!.email,
              "first_name": _firstNameTextEditingController.text,
              "last_name": _lastNameTextEditingController.text,
              "age": int.parse(_ageTextEditingController.text),
              "country": "Malaysia",
              "state": _currentSelectedState,
              "provider": "google",
              "password": widget.googleData!.uid
            };
          } else {
            data = {
              "email": _emailTextEditingController.text,
              "password": _passwordTextEditingController.text,
              "first_name": _firstNameTextEditingController.text,
              "last_name": _lastNameTextEditingController.text,
              "age": int.parse(_ageTextEditingController.text),
              "country": _currentSelectedState,
            };
          }

          try {
            print("================= SIGNUP REQUEST =================");
            print("PAYLOAD: $data");

            final response = await apiService.signup(data);

            print("================= SIGNUP RESPONSE =================");
            print("RESPONSE RAW: $response");
            print("STATUS: ${response['status']}");
            print("MESSAGE: ${response['message']}");
            print("DETAILS: ${response['details']}");

            if (response['status'] == "success") {
              // Show success message
              showFToast(
                context: context,
                status: Status.success,
                message: response['message'] ?? "Signup successful",
              );

              // Now sign in the user automatically
              await _signInAfterSignup(apiService, user);
            } else {
              // Check if email already exists
              if (response['message']?.toString().contains('email') == true &&
                  response['message']?.toString().contains('used') == true) {
                
                showFToast(
                  context: context,
                  status: Status.success,
                  message: "Email already registered. Signing you in...",
                );
                
                // Try to sign in
                await _signInAfterSignup(apiService, user);
              } else {
                showFToast(
                  context: context,
                  status: Status.error,
                  maxLine: 6,
                  message: "SIGNUP FAILED: ${response['message'] ?? 'Unknown error'}",
                );
              }
            }
          } catch (e, stack) {
            print("================= SIGNUP EXCEPTION ===============");
            print("ERROR: $e");
            print("STACK: $stack");

            showFToast(
              context: context,
              status: Status.error,
              maxLine: 6,
              message: "EXCEPTION: $e",
            );
          }
        }
      },
                            foregroundColor: buttonAllowed ? themeOptions.primaryColor : themeOptions.secondaryColor,
                            backgroundColor: buttonAllowed ? themeOptions.primaryColor : themeOptions.secondaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
