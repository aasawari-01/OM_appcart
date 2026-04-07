import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/string_utils.dart';
import 'cust_text.dart';


class CustDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CustDropdown({
    Key? key,
    required this.label,
    required this.hint,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustText(
           name: label,
            size: 1.6,
            fontWeightName: FontWeight.w500,
          ),
          SizedBox(height: ResponsiveHelper.spacing(context, 4)),
          DropdownSearch<String>(
            selectedItem: selectedValue,
            onChanged: onChanged,
            validator: validator,
            items: (filter, loadProps) => items.map((e) => e.toTitleCase()).toList(),
              // popupProps: PopupProps.menu(
              //   showSearchBox: true,
              //   fit: FlexFit.loose,
              //   menuProps: MenuProps(
              //   backgroundColor: AppColors.red),
              //   containerBuilder: (ctx, popupWidget) {
              //     return MediaQuery(
              //       data: MediaQuery.of(ctx).copyWith(
              //         textScaler: const TextScaler.linear(1.0),
              //       ),
              //       child: popupWidget,
              //     );
              //   },
              //   itemBuilder:  (context, item, isDisabled, isSelected) {
              //      return Padding(
              //        padding: const EdgeInsets.all(12.0),
              //        child: CustText(
              //         name: item,
              //         color: AppColors.textColor4,
              //         size: 1.6 ,
              //        ),
              //      );
              //   },
              //   searchFieldProps: TextFieldProps(
              //     decoration: InputDecoration(
              //       isDense: true,
              //       // contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(6),
              //         borderSide: BorderSide(color: AppColors.textFieldColor),
              //       ),
              //       hintText: 'Search...',
              //     ),
              //     style: GoogleFonts.outfit(fontSize: 1.5 * SizeConfig.textMultiplier),
              //   ),
              // ),
              popupProps: PopupProps.modalBottomSheet(
                showSearchBox: true,
                fit: FlexFit.loose,
                modalBottomSheetProps: const ModalBottomSheetProps(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: CustText(
                    name: label,
                    size: 2.0,
                    fontWeightName: FontWeight.w600,
                    color: AppColors.textColor4,
                  ),
                ),
                containerBuilder: (ctx, popupWidget) {
                  return MediaQuery(
                    data: MediaQuery.of(ctx).copyWith(
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    child: popupWidget,
                  );
                },
                itemBuilder:  (context, item, isDisabled, isSelected) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CustText(
                      name: item.toTitleCase(),
                      color: AppColors.textColor4,
                      size: 1.6 ,
                    ),
                  );
                },
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppColors.textFieldColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: AppColors.black),
                    ),
                    hintText: 'Search...',
                  ),
                  style: GoogleFonts.outfit(fontSize: ResponsiveHelper.fontSize(context, 14)),
                ),
              ),
              suffixProps: const DropdownSuffixProps(
                dropdownButtonProps: DropdownButtonProps(isVisible: false),
                clearButtonProps: ClearButtonProps(isVisible: false),
              ),
              decoratorProps: DropDownDecoratorProps(
                baseStyle: GoogleFonts.outfit(color: AppColors.textColor4, fontSize: ResponsiveHelper.fontSize(context, 14)),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.outfit(color: AppColors.hintColor, fontSize: ResponsiveHelper.fontSize(context, 14)),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, 10)),
                      borderSide: BorderSide(color: AppColors.textFieldColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, 10)),
                      borderSide: BorderSide(color: AppColors.textFieldColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, 10)),
                      borderSide: BorderSide(color: AppColors.textFieldColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, 10)),
                      borderSide: const BorderSide(color: AppColors.black),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
                  fillColor: Colors.white,
                  filled: true,
                  prefix: const SizedBox(width: 12),
                  errorStyle: GoogleFonts.outfit(
                    fontSize: ResponsiveHelper.fontSize(context, 10),
                    height: 1.0,
                  ),
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(TablerIcons.chevron_down, size: 20.0, color: AppColors.iconColor),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 24,
                    minWidth: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
