import 'package:flutter/material.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/utils/responsive_helper.dart';

import '../../constants/app_data.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_text.dart';


class FilterPopup extends StatefulWidget {
  final ScrollController? scrollController;
  const FilterPopup({Key? key, this.scrollController}) : super(key: key);

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  // Example filter state
  Set<String> selectedPriorities = {'Low'};
  Set<String> selectedStatuses = {'Assigned'};
  Set<String> selectedTypes = {'OCC'};
  String? selectedDepartment;
  String? selectedLocation;
  String? selectedShowData = 'All';
  DateTime? selectedDate;
  bool serviceAffected = false;

  final List<String> priorities = ['Low', 'Medium', 'High', 'Very High'];
  final List<String> statuses = ['Assigned', 'Reassigned'];
  final List<String> types = ['OCC', 'Station'];
  final List<String> showDataOptions = ['All', 'Created', 'Reassigned', 'Resolved', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Rounded top corners for the sheet itself are handled by the caller or this container effectively
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustText(
                  name: 'All Filters',
                  size: 2,
                  color: AppColors.textColor,
                  fontWeightName: FontWeight.w600,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const Divider(),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Priority
                  _buildSectionLabel('Priority'),
                  Wrap(
                    spacing: 8,
                    children: priorities.map((p) => ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedPriorities.contains(p))
                            Icon(Icons.check, color: AppColors.textColor3, size: ResponsiveHelper.spacing(context, 16)),
                          if (selectedPriorities.contains(p))
                            const SizedBox(width: 4), // Decrease this for less gap
                          Text(
                            p,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 14),
                              color: selectedPriorities.contains(p) ? AppColors.textColor3 : AppColors.textColor,
                              fontWeight: selectedPriorities.contains(p) ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      selected: selectedPriorities.contains(p),
                      selectedColor: AppColors.textColor3.withOpacity(0.1),
                      onSelected: (_) {
                        setState(() {
                          if (selectedPriorities.contains(p)) {
                            selectedPriorities.remove(p);
                          } else {
                            selectedPriorities.add(p);
                          }
                        });
                      },
                      backgroundColor: Colors.white,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedPriorities.contains(p) ? AppColors.textColor3 : Colors.grey.shade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Assign Status
                  _buildSectionLabel('Assign Status'),
                  Wrap(
                    spacing: 8,
                    children: statuses.map((s) => ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedStatuses.contains(s))
                            Icon(Icons.check, color: AppColors.textColor3, size: ResponsiveHelper.spacing(context, 16)),
                          if (selectedStatuses.contains(s))
                            const SizedBox(width: 4),
                          Text(
                            s,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 14),
                              color: selectedStatuses.contains(s) ? AppColors.textColor3 : AppColors.textColor,
                              fontWeight: selectedStatuses.contains(s) ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      selected: selectedStatuses.contains(s),
                      selectedColor: AppColors.textColor3.withOpacity(0.1),
                      onSelected: (_) {
                        setState(() {
                          if (selectedStatuses.contains(s)) {
                            selectedStatuses.remove(s);
                          } else {
                            selectedStatuses.add(s);
                          }
                        });
                      },
                      backgroundColor: Colors.white,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedStatuses.contains(s) ? AppColors.textColor3 : Colors.grey.shade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Creation Type
                  _buildSectionLabel('Creation Type'),
                  Wrap(
                    spacing: 8,
                    children: types.map((t) => ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedTypes.contains(t))
                            Icon(Icons.check, color: AppColors.textColor3, size: ResponsiveHelper.spacing(context, 16)),
                          if (selectedTypes.contains(t))
                            const SizedBox(width: 4),
                          Text(
                            t,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 14),
                              color: selectedTypes.contains(t) ? AppColors.textColor3 : AppColors.textColor,
                              fontWeight: selectedTypes.contains(t) ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      selected: selectedTypes.contains(t),
                      selectedColor: AppColors.textColor3.withOpacity(0.1),
                      onSelected: (_) {
                        setState(() {
                          if (selectedTypes.contains(t)) {
                            selectedTypes.remove(t);
                          } else {
                            selectedTypes.add(t);
                          }
                        });
                      },
                      backgroundColor: Colors.white,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedTypes.contains(t) ? AppColors.textColor3 : Colors.grey.shade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown("Department",'Select Department', departmentListValue, (val) {
                    setState(() => selectedDepartment = val);
                  }),
                  const SizedBox(height: 16),
                  // Location Dropdown
                  _buildDropdown('Location','Select Location', stationListValue, (val) {
                    setState(() => selectedLocation = val);
                  }),
                  const SizedBox(height: 16),
                  // Show Data Dropdown
                  CustDropdown(
                    label: 'Show Data',
                    hint: 'Select',
                    items: showDataOptions,
                    selectedValue: selectedShowData,
                    onChanged: (val) {
                      setState(() => selectedShowData = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  CustDateTimePicker(
                    label: 'Failure Occurrence Date',
                    hint: 'Select Date',
                    pickerType: CustDateTimePickerType.date,
                    selectedDateTime: selectedDate,
                    onDateTimeSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Checkbox(
                        value: serviceAffected,
                        onChanged: (val) {
                          setState(() => serviceAffected = val ?? false);
                        },
                        activeColor: AppColors.textColor3,
                      ),
                      CustText(
                        name: 'Passengers Affected',
                        size: 1.5,
                        fontWeightName: FontWeight.w500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Apply filter logic
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textColor3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: CustText(
                      name: 'Apply Filters',
                      size: 1.5,
                      color: Colors.white,
                      fontWeightName: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Clear logic
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.textColor3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: CustText(
                      name: 'Clear',
                      size: 1.5,
                      color: AppColors.textColor3,
                      fontWeightName: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(context, 20))
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) => Align(
    alignment: Alignment.centerLeft,
    child: CustText(
      name: label,
      size: 1.8,
      fontWeightName: FontWeight.w500,
    ),
  );

  Widget _buildDropdown(String label, String hint, List<String> value, ValueChanged<String?> onChanged) {
    return CustDropdown(label: label, hint: hint, items: value, onChanged: onChanged);
  }
}