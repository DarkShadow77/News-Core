import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../styles/text_styles.dart';

class TextAreaField extends StatefulWidget {
  const TextAreaField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorBool = false,
    this.enabled = true,
    this.onChanged,
    this.length = 2000,
    this.border = 1,
    this.maxLines = 3,
    this.textCapitalization = TextCapitalization.sentences,
    this.color,
    this.hintColor,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hintText;
  final bool errorBool;
  final bool enabled;
  final Function(String)? onChanged;
  final int length;
  final int border;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final Color? color;
  final Color? hintColor;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<TextAreaField> createState() => _TextAreaFieldState();
}

class _TextAreaFieldState extends State<TextAreaField> {
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
    final color = widget.color ?? AppColors.dynamic05;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: widget.enabled ? color : AppColors.dynamic20,
        border: Border.all(
          width: widget.border.w,
          color: !widget.enabled
              ? AppColors.dynamic20
              : widget.errorBool
              ? AppColors.error
              : isFocused
              ? AppColors.primary50
              : Colors.transparent,
        ),
      ),
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: TextFormField(
        focusNode: _focusNode,
        minLines: 3,
        maxLines: widget.maxLines,
        controller: widget.controller,
        enabled: widget.enabled,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        textCapitalization: widget.textCapitalization,
        inputFormatters: [
          if (widget.inputFormatters != null) ...widget.inputFormatters!,
          LengthLimitingTextInputFormatter(widget.length),
        ],
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyles.normalRegular14(
            context,
          ).copyWith(color: widget.hintColor ?? AppColors.dynamic40),
          errorStyle: const TextStyle(fontSize: 0, height: -2),
          border: InputBorder.none,
        ),
        style: TextStyles.normalRegular14(context).copyWith(
          color: widget.enabled ? dynamicColor() : AppColors.dynamic50,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
