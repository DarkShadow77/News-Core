import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../styles/text_styles.dart';

class InputTitle extends StatelessWidget {
  const InputTitle({super.key, required this.text, this.spacing, this.child});

  final String text;
  final double? spacing;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: (spacing ?? 20).w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: text,
                style: TextStyles.bodyMedium16(context),
              ),
            ),
            if (child != null) child!,
          ],
        ),
        SizedBox(height: 4.h),
      ],
    );
  }
}
