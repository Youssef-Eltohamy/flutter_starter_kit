import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nemo/core/themer.dart';
import 'package:nemo/res/app_colors.dart';

// ignore: must_be_immutable
class AppTextFormField extends StatefulWidget {
  final String? hintText;
  final String? helperText;
  final String? initialValue;
  final bool obscure;
  final bool enable;
  final void Function(String?) onSaved;
  final void Function(String?)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final int maxLines;
  final int? maxLength;
  final String? customCounterText;
  final Widget? prefixIcon;
  final String? prefixText;
  Color? enableBorderColor;
  FocusNode? focusNode;
  Iterable<String>? autofillHints;

  final List<TextInputFormatter>? inputFormatters;

  AppTextFormField({
    Key? key,
    required this.hintText,
    required this.onSaved,
    this.helperText,
    this.onChanged,
    this.initialValue,
    this.onFieldSubmitted,
    this.textInputAction,
    this.obscure = false,
    this.enable = true,
    this.maxLines = 1,
    this.maxLength,
    this.textInputType,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.customCounterText,
    this.enableBorderColor,
    this.focusNode,
    this.autofillHints,
    this.prefixText,
    this.prefixIcon,
  }) : assert(initialValue == null || controller == null),
       super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> with Themer {
  bool obscure = true;
  bool setObscure = false;

  @override
  Widget build(BuildContext context) {
    initThemer(context);
    if (!setObscure) {
      obscure = widget.obscure;
      setObscure = true;
    }
    return TextFormField(
      enabled: widget.enable,
      initialValue: widget.initialValue,
      obscureText: obscure,
      style: textTheme.bodyMedium,
      controller: widget.controller,
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        prefixText: widget.prefixText,
        prefixIcon: widget.prefixIcon,
        prefixStyle: textTheme.bodyMedium,
        prefixIconConstraints: const BoxConstraints(maxWidth: 80, minWidth: 35),
        helperText: widget.helperText,
        isDense: true,
        counterText: widget.customCounterText,
        hintText: widget.hintText,
        fillColor: AppColors.appFormFieldFill,
        filled: true,
        hintStyle: textTheme.labelMedium,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                widget.enableBorderColor ?? AppColors.enabledAppFormFieldBorder,
            width: 1,
          ),
        ),
        border: const OutlineInputBorder(),
        suffixIcon:
            widget.obscure
                ? IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    obscure ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                )
                : null,
      ),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      validator: widget.validator,
      maxLines: widget.maxLines,
      textInputAction: widget.textInputAction,
      keyboardType: widget.textInputType,
      maxLength: widget.maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    );
  }
}
