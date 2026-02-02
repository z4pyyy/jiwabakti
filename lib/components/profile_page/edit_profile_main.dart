import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jiwa_bakti/components/common/custom_divider.dart';
import 'package:jiwa_bakti/components/common/rounded_text_button.dart';
import 'package:jiwa_bakti/components/common/rounded_text_form_field.dart';
import 'package:jiwa_bakti/enums/status.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/services/api_service.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:jiwa_bakti/utils/show_toast.dart';
import 'package:jiwa_bakti/utils/validation_helpers.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class EditProfileMain extends StatefulWidget {
  const EditProfileMain({super.key});

  @override
  State<EditProfileMain> createState() => EditProfileMainState();
}

class EditProfileMainState extends State<EditProfileMain> {
  final _firstNameTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _ageTextEditingController = TextEditingController();
  final _countryTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();

  final _firstNameFieldKey = GlobalKey<FormFieldState>();
  final _lastNameFieldKey = GlobalKey<FormFieldState>();
  final _ageFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  late FocusNode firstNameFocusNode;
  late FocusNode lastNameFocusNode;
  late FocusNode ageFocusNode;

  bool buttonAllowed = false;
  bool firstNameValidated = false;
  bool lastNameValidated = false;
  bool ageValidated = false;
  bool _isSaving = false;

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

  void checkButtonAllowed() {
    buttonAllowed = firstNameValidated && lastNameValidated && ageValidated;
  }

  void firstNameOnChange() {
    setState(() {
      firstNameValidated = false;
      if (_firstNameFieldKey.currentState!.validate()) {
        firstNameValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void lastNameOnChange() {
    setState(() {
      lastNameValidated = false;
      if (_lastNameFieldKey.currentState!.validate()) {
        lastNameValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void ageOnChange() {
    setState(() {
      ageValidated = false;
      if (_ageFieldKey.currentState!.validate()) {
        ageValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void initializeFocusNode() {
    firstNameFocusNode = FocusNode();
    firstNameFocusNode.addListener(() {
      setState(() {
        if (!firstNameFocusNode.hasFocus) {
          if (_firstNameFieldKey.currentState!.validate()) {
            firstNameValidated = true;
          } else {
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
          if (_lastNameFieldKey.currentState!.validate()) {
            lastNameValidated = true;
          } else {
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
          if (_ageFieldKey.currentState!.validate()) {
            ageValidated = true;
          } else {
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

    final user = GetIt.I<User>();
    _firstNameTextEditingController.text = user.firstName ?? "";
    _lastNameTextEditingController.text = user.lastName ?? "";
    _emailTextEditingController.text = user.email ?? "";
    _countryTextEditingController.text = _currentSelectedCountry;
    if (user.age != null) {
      _ageTextEditingController.text = user.age.toString();
    }
    if (user.state != null && selectState.contains(user.state)) {
      _currentSelectedState = user.state!;
    }

    firstNameValidated =
        validateStringNotEmpty(_firstNameTextEditingController.text, "first name") ==
            null;
    lastNameValidated =
        validateStringNotEmpty(_lastNameTextEditingController.text, "last name") ==
            null;
    ageValidated = validateAge(_ageTextEditingController.text) == null;
    checkButtonAllowed();
  }

  @override
  void dispose() {
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    ageFocusNode.dispose();
    _firstNameTextEditingController.dispose();
    _lastNameTextEditingController.dispose();
    _ageTextEditingController.dispose();
    _countryTextEditingController.dispose();
    _emailTextEditingController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) return;
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      setState(() => checkButtonAllowed());
      return;
    }

    final apiService = GetIt.I<ApiService>();
    final user = GetIt.I<User>();
    final userId = user.userId ?? user.id;

    if (userId == null) {
      showFToast(
        context: context,
        status: Status.error,
        message: "Unable to update profile. Please sign in again.",
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final data = {
        "user_id": userId,
        "id": user.id ?? userId,
        "email": _emailTextEditingController.text,
        "first_name": _firstNameTextEditingController.text,
        "last_name": _lastNameTextEditingController.text,
        "age": int.parse(_ageTextEditingController.text),
        "country": _currentSelectedCountry,
        "state": _currentSelectedState,
      };

      final response = await apiService.editProfile(data);
      final status = response is Map ? response['status']?.toString() : null;

      if (status == "success") {
        user.firstName = _firstNameTextEditingController.text;
        user.lastName = _lastNameTextEditingController.text;
        user.age = int.tryParse(_ageTextEditingController.text);
        user.state = _currentSelectedState;
        user.country = _currentSelectedCountry;
        if (_emailTextEditingController.text.isNotEmpty) {
          user.email = _emailTextEditingController.text;
        }

        if (mounted) {
          showFToast(
            context: context,
            status: Status.success,
            message: "Profil dikemaskini.",
          );
          context.pop();
        }
      } else {
        final message = response is Map && response['message'] != null
            ? response['message'].toString()
            : "Failed to update profile.";
        if (mounted) {
          showFToast(
            context: context,
            status: Status.error,
            message: message,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showFToast(
          context: context,
          status: Status.error,
          message: "Failed to update profile. Please try again.",
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    final dropdownTextStyle = TextStyle(
      fontSize: 16,
      color: themeOptions.textColor,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            "Edit Profil",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Kemaskini maklumat akaun anda.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          const CustomDivider(),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nama diberi",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
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
                    validator: (value) => validateStringNotEmpty(value, "first name"),
                    showTick: firstNameValidated,
                    onChanged: (value) {
                      firstNameOnChange();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Nama keluarga",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
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
                    validator: (value) => validateStringNotEmpty(value, "last name"),
                    showTick: lastNameValidated,
                    onChanged: (value) {
                      lastNameOnChange();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Umur",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
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
                    keyboardType: TextInputType.number,
                    showTick: ageValidated,
                    onChanged: (value) {
                      ageOnChange();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Negara",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  child: RoundedTextFormField(
                    enable: false,
                    label: "",
                    isDense: true,
                    borderRadius: BorderRadius.circular(5.sp),
                    controller: _countryTextEditingController,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Negeri",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(),
                          errorStyle:
                              const TextStyle(color: Colors.redAccent, fontSize: 16),
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
                            style: dropdownTextStyle,
                            onChanged: (String? value) {
                              setState(() {
                                if (value != null) {
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
                                  style: dropdownTextStyle,
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  child: RoundedTextFormField(
                    enable: false,
                    label: "",
                    isDense: true,
                    borderRadius: BorderRadius.circular(5.sp),
                    controller: _emailTextEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      return validateEmail(value);
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: SizedBox(
                    width: user.textSizeScale < 1.2
                        ? 35.w
                        : user.textSizeScale < 1.5
                            ? 45.w
                            : 60.w,
                    child: RoundedTextButton(
                      text: Text(
                        _isSaving ? "Menyimpan..." : "Kemaskini",
                        style: TextStyle(
                          color: themeOptions.textColorOnSecondary,
                          fontSize: user.textSizeScale * themeOptions.textSize2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: !buttonAllowed || _isSaving ? null : _submit,
                      foregroundColor: buttonAllowed
                          ? themeOptions.primaryColor
                          : themeOptions.secondaryColor,
                      backgroundColor: buttonAllowed
                          ? themeOptions.primaryColor
                          : themeOptions.secondaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
