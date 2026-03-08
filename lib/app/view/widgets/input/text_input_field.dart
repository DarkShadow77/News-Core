import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../styles/text_styles.dart';

class TextInputField extends StatefulWidget {
  const TextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.isDropdown = false,
    this.errorBool = false,
    this.enabled = true,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.length = 999,
    this.border = 1,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.prefix,
    this.suffix,
    this.color,
    this.hintColor,
    this.inputFormatters,
    this.validator,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool isDropdown;
  final bool errorBool;
  final bool enabled;
  final int length;
  final int border;
  final int maxLines;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final Color? color;
  final Color? hintColor;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final AutovalidateMode? autoValidateMode;
  final Function()? onTap;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool hidePassword = true;
  late FocusNode _focusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = widget.color ?? AppColors.dynamic05;
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: widget.enabled ? mainColor : AppColors.dynamic20,
        border: Border.all(
          width: widget.border.w,
          color: !widget.enabled
              ? AppColors.dynamic10
              : widget.errorBool
              ? AppColors.error
              : isFocused
              ? AppColors.primary50
              : AppColors.dynamic05,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.suffix != null) ...[widget.suffix!, SizedBox(width: 10.w)],
          Expanded(
            child: TextFormField(
              maxLines: widget.maxLines,

              focusNode: _focusNode,
              controller: widget.controller,
              enabled: widget.enabled,
              readOnly: widget.isDropdown ? true : false,
              obscureText: widget.isPassword ? hidePassword : false,
              obscuringCharacter: '●',
              keyboardType: widget.textInputType,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              autovalidateMode: widget.autoValidateMode,
              validator: widget.validator,
              inputFormatters: [
                if (widget.inputFormatters != null) ...widget.inputFormatters!,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyles.normalRegular14(context).copyWith(
                  color: widget.hintColor ?? AppColors.dynamic30,
                  letterSpacing: .5.sp,
                ),
                errorStyle: const TextStyle(fontSize: 0, height: -2),
                border: InputBorder.none,
              ),
              style: TextStyles.normalRegular14(context).copyWith(
                color: widget.enabled ? dynamicColor() : AppColors.dynamic50,
                letterSpacing: widget.isPassword ? 3.sp : null,
              ),
              onChanged: widget.onChanged,
              onTap: widget.onTap,
            ),
          ),
          widget.prefix ??
              (widget.isPassword
                  ? GestureDetector(
                      onTap: () => setState(() => hidePassword = !hidePassword),
                      behavior: HitTestBehavior.opaque,
                      child: Icon(
                        hidePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 16.sp,
                        color: dynamicColor(),
                      ),
                    )
                  : widget.isDropdown
                  ? Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16.sp,
                      color: dynamicColor(),
                    )
                  : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
