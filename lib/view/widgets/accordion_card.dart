import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'cust_text.dart';

class AccordionCard extends StatelessWidget {
  final String title;
  final Widget? child;
  final Widget? headerTrailing;

  const AccordionCard({
    Key? key,
    required this.title,
    this.child,
    this.headerTrailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.white1,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
                Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        title==''?SizedBox.shrink():
                        Container(
                          margin: const EdgeInsets.only(left: 15, bottom: 0),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: CustText(
                            name: title,
                            size: 1.4,
                            color: AppColors.textColor3,
                            fontWeightName: FontWeight.w500,
                          ),
                        ),
                        if (headerTrailing != null) ...[
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 15,top: 15,),
                            child: headerTrailing!,
                          ),
                        ],
                      ],
                    ),
                  ),
              // : Container(
              //     color: Colors.transparent,
              //     padding: const EdgeInsets.symmetric(horizontal: 0),
              //     child: Row(
              //       children: [
              //         title==''?SizedBox.shrink():
              //         Container(
              //           margin: const EdgeInsets.only(left: 15, bottom: 10),
              //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //           decoration: BoxDecoration(
              //             color: Colors.blue.shade50.withOpacity(0.5),
              //             borderRadius: const BorderRadius.only(
              //               bottomRight: Radius.circular(20),
              //               bottomLeft: Radius.circular(20),
              //             ),
              //           ),
              //           child: CustText(
              //             name: title,
              //             size: 2.0,
              //             color: AppColors.textColor3,
              //             fontWeightName: FontWeight.w500,
              //           ),
              //         ),
              //         if (headerTrailing != null) ...[
              //           const Spacer(),
              //           Padding(
              //             padding: const EdgeInsets.only(right: 15),
              //             child: headerTrailing!,
              //           ),
              //         ],
              //       ],
              //     ),
              //   ),
          if (child != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: child,
              ),
            ),
        ],
      ),
    );
  }
}