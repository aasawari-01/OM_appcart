import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../constants/colors.dart';
import 'cust_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? actions;
  final bool showDrawer;
  final bool isForm;
  final int? currentStep;
  final int? totalSteps;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onLeadingPressed,
    this.actions,
    this.showDrawer = false,
    this.isForm = false,
    this.currentStep,
    this.totalSteps,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white1,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.04),
        //     blurRadius: 6,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: (actions != null && actions!.isNotEmpty) ? 1 : 16,
            top: 8,
            bottom: 8,
          ),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onLeadingPressed ?? () {
                  if (showDrawer) {
                    Scaffold.of(context).openDrawer();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    showDrawer ? Icons.menu : Icons.arrow_back,
                    color: AppColors.blue.withOpacity(0.8),
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustText(
                  name: title,
                  size: 2.0,
                  color: AppColors.textColor5,
                  fontWeightName: FontWeight.w500,
                ),
              ),
              if (actions != null && actions!.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: actions!,
                )

              else if (isForm)
                if (currentStep != null && totalSteps != null && totalSteps! > 1)
                  CustText(
                    name: '${currentStep! + 1}/$totalSteps',
                    size: 2.0,
                    color: AppColors.blue,
                    fontWeightName: FontWeight.w600,
                  )
                else
                  const SizedBox.shrink()
              else
                Icon(
                  TablerIcons.filter,
                  color: AppColors.blue,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}