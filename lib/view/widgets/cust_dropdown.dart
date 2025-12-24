import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../constants/colors.dart';
import '../../utils/size_config.dart';
import 'cust_text.dart';


class CustDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CustDropdown({
    Key? key,
    required this.label,
    required this.hint,
    required this.items,
    this.selectedValue,
    required this.onChanged,
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
            size: 1.8,
            fontWeightName: FontWeight.w500,
          ),
          SizedBox(height: 1 * SizeConfig.heightMultiplier),
          SizedBox(
            height: 5.5 * SizeConfig.heightMultiplier,
            child: DropdownSearch<String>(
              selectedItem: selectedValue,
              onChanged: onChanged,
              items: (filter, loadProps) => items,
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
              //     style: GoogleFonts.workSans(fontSize: 1.5 * SizeConfig.textMultiplier),
              //   ),
              // ),
              popupProps: PopupProps.modalBottomSheet(
                showSearchBox: true,
                fit: FlexFit.loose,
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
                      name: item,
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
                    hintText: 'Search...',
                  ),
                  style: GoogleFonts.workSans(fontSize: 1.5 * SizeConfig.textMultiplier),
                ),
              ),
             dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem ?? "",
                  style:GoogleFonts.workSans(color:AppColors.textColor4,fontSize: 1.6 * SizeConfig.textMultiplier),
                  textScaler: const TextScaler.linear(1.0),
                );
              },
              suffixProps: DropdownSuffixProps(
                dropdownButtonProps:DropdownButtonProps(
                  iconClosed: const Icon(TablerIcons.chevron_down, size: 24.0, color: AppColors.textColor4),
                  iconOpened:const Icon(TablerIcons.chevron_up, size: 24.0, color: AppColors.textColor4)
                  ),
                  ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.workSans(color:AppColors.textColor4,fontSize: 1.6 * SizeConfig.textMultiplier),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.5 * SizeConfig.widthMultiplier),
                      borderSide: BorderSide(color: AppColors.textFieldColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.5 * SizeConfig.widthMultiplier),
                      borderSide: BorderSide(color: AppColors.textFieldColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.5 * SizeConfig.widthMultiplier),
                      borderSide: BorderSide(color: AppColors.textFieldColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.5 * SizeConfig.widthMultiplier),
                      borderSide: BorderSide(color: AppColors.textFieldColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12.0,
                    ),
                  fillColor: AppColors.white1,
                  filled: true,
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 30,
                    minWidth: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
