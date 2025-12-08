import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class RoundedTextFormField extends StatefulWidget {
  final bool readonly;
  final String label;
  final bool isPasswordField;
  final bool isDense;
  final TextEditingController? controller;
  final Function(String?)? validator;
  final Icon? prefixIcon;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final BorderRadius? borderRadius;
  final EdgeInsets? contentPadding;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool enable;
  final Function()? onTap;
  final Function(String)? onChanged;
  final bool? floatingLabel;
  final FocusNode? focusNode;
  final Key? formFieldKey;
  final bool showTick;
  final bool obscureText;

  const RoundedTextFormField({
    Key? key,
    this.readonly = false,
    required this.label,
    this.controller,
    this.validator,
    this.isPasswordField = false,
    this.isDense = false,
    this.prefixIcon,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.borderRadius,
    this.contentPadding,
    this.keyboardType,
    this.hintText,
    this.enable = true,
    this.onTap,
    this.onChanged,
    this.floatingLabel,
    this.focusNode,
    this.formFieldKey,
    this.showTick = false,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RoundedTextFormFieldState();
}

class _RoundedTextFormFieldState extends State<RoundedTextFormField> {
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: widget.readonly,
      key: widget.formFieldKey,
      focusNode: widget.focusNode,
      onTap: () => widget.onTap?.call(),
      onChanged: (value) => widget.onChanged?.call(value),
      enabled: widget.enable,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      validator: (value) => widget.validator?.call(value),
      obscureText: _isObscured,
      minLines: widget.minLines ?? 1,
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxLength,
      style: TextStyle(
        fontSize: 16
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPasswordField
            ? IconButton(
                iconSize: 16.sp,
                icon: _isObscured
                    ? Icon(
                        Icons.visibility_off,
                        color: Colors.black.withOpacity(0.6),
                      )
                    : Icon(
                        Icons.visibility,
                        color: Colors.black.withOpacity(0.6),
                      ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : widget.showTick
              ? const Icon(
                  Icons.check,
                  size: 24,
                  color: Colors.green,
                )
              : null,
        isDense: widget.isDense,
        contentPadding: widget.contentPadding,
        enabledBorder: widget.enable
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.showTick ? Colors.green : Colors.grey,
                  width: 1.2.sp,
                ),
                borderRadius:
                widget.borderRadius ?? BorderRadius.circular(24.sp),
              )
            : null,
        border: widget.enable
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.showTick ? Colors.green : const Color(0xFFD24C00),
                  width: 0.5.sp,
                ),
                borderRadius:
                    widget.borderRadius ?? BorderRadius.circular(24.sp),
              )
            : null,
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.showTick ? Colors.green : Colors.grey,
            width: 1.2.sp,
          ),
          borderRadius:
          widget.borderRadius ?? BorderRadius.circular(24.sp),
        ),
        hintText: widget.hintText,
        floatingLabelBehavior: widget.floatingLabel == true
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.never,
      ),
    );
  }
}
