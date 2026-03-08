import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../app/view/widgets/input/search_text_input.dart';
import '../../../../core/constants/app_colors.dart';

Future plainListModal({
  required String title,
  required List<String> list,
  bool showSearch = false,
  required Function(String) onPressed,
}) {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    PlainListModal(
      title: title,
      list: list,
      showSearch: showSearch,
      onPressed: onPressed,
    ),
  );
}

class PlainListModal extends StatefulWidget {
  const PlainListModal({
    super.key,
    required this.title,
    required this.list,
    required this.showSearch,
    required this.onPressed,
  });

  final String title;
  final List<String> list;
  final bool showSearch;
  final Function(String) onPressed;

  @override
  State<PlainListModal> createState() => _PlainListModalState();
}

class _PlainListModalState extends State<PlainListModal> {
  final TextEditingController _inputController = TextEditingController();

  String searchText = "";

  List<String> searchData = [];

  @override
  void initState() {
    super.initState();
    search();
  }

  void search() {
    searchData.clear();

    if (searchText.isEmpty) {
      searchData.addAll(widget.list);
    } else {
      searchData.addAll(
        widget.list
            .where(
              (element) =>
                  element.toLowerCase().contains(searchText.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowModalSheet(
      maxHeight: 600.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: widget.title,
                      style: TextStyles.titleSemiBold20(context),
                    ),
                  ),
                ),
                Container(
                  height: 32.r,
                  width: 32.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.dynamic10,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedCancel01,
                      color: AppColors.dynamic,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            if (widget.showSearch)
              SearchTextInput(
                hintText: "Search ${widget.title}",
                controller: _inputController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                  search();
                },
              ),
            Flexible(
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([SizedBox(height: 24.h)]),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: searchData.length * 2,
                      (ctx, idx) {
                        if (idx.isOdd) {
                          return SizedBox(height: 14.h);
                        }
                        final itemIndex = idx ~/ 2;

                        if (itemIndex > searchData.length) {
                          return null;
                        }

                        final data = searchData[itemIndex];
                        return GestureDetector(
                          onTap: () {
                            widget.onPressed(data);
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.dynamic025,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: RichText(
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: data.capitalize,
                                style: TextStyles.normalSemibold14(context),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(
                        height: 20.h + MediaQuery.of(context).padding.bottom,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
