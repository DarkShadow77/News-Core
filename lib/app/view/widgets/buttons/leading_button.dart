import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/helpers.dart';

class LeadingButton extends StatelessWidget {
  const LeadingButton({super.key, this.color});

  final Color? color;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
      },
      icon: Icon(
        Icons.chevron_left_rounded,
        color: color ?? dynamicColor(),
        size: 32.sp,
      ),
    );
  }
}
