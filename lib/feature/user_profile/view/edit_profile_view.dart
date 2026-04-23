import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:om_appcart/view/widgets/cust_loader.dart';
import 'package:om_appcart/view/widgets/full_image_viewer.dart';
import '../../../utils/app_date_utils.dart';

import '../../../constants/colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/strings.dart';
import '../../failure/controller/station_controller.dart';
import '../../../service/network_service/app_urls.dart';
import '../../../utils/responsive_helper.dart';
import '../../../utils/string_utils.dart';
import '../../../view/widgets/cust_text.dart';
import '../../../view/widgets/cust_textfield.dart';
import '../../../view/widgets/cust_dropdown.dart';
import '../../../view/widgets/custom_app_bar.dart';
import '../../../view/widgets/cust_button.dart';
import '../../../view/widgets/accordion_card.dart';
import '../../../view/widgets/cust_date_time_picker.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<EditProfileController>()) {
      Get.put(EditProfileController());
    }

    return Scaffold(
      backgroundColor: AppColors.white1,
      appBar: CustomAppBar(
        title: AppStrings.editProfile,
        showDrawer: false,
        isForm: true,
        onLeadingPressed: () => Get.back(),
        actions: const [],
      ),
      body: Obx(() => Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context),
                  _buildTabs(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.spacing(context, AppConstants.horizontalPadding), 
                        vertical: ResponsiveHelper.spacing(context, AppConstants.verticalPadding)
                      ),
                      child: Column(
                        children: [
                          _buildPersonalDetailsSection(context),
                          SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
                          _buildEmployeeDetailsSection(context),
                          SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
                          _buildFinanceDetailsSection(context),
                          SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)), // Extra space at bottom
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (controller.profileController.isLoading.value)
                CustLoader()
            ],
          )),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.spacing(context, 16.0)),
          child: Obx(() => CustButton(
                name: AppStrings.update,
                onSelected: (_) => controller.handleUpdate(),
                isLoading: controller.profileController.isLoading.value,
              )),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.spacing(context, 16)),
      child: Center(
        child: GestureDetector(
          onTap: () => _showImagePickerOptions(context),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.hintColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Obx(() {
                  final imageFile = controller.profileController.selectedImage.value;
                  final profilePicUrl = controller.profileController.profileData.value?.profilePic;

                  Widget imageWidget;
                  if (imageFile != null) {
                    imageWidget = Image.file(imageFile, fit: BoxFit.cover, width: 100, height: 100);
                  } else if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
                    imageWidget = Image.network(
                      profilePicUrl.startsWith('http') ? profilePicUrl : "${AppUrls.baseUrl}$profilePicUrl", 
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.person, size: 50, color:AppColors.iconColor)),
                    );
                  } else {
                    imageWidget = const Center(child: Icon(Icons.person, size: 50, color: AppColors.iconColor));
                  }

                  return Hero(
                    tag: 'profile_pic_edit',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageWidget,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(ResponsiveHelper.spacing(context, 16)),
        decoration: const BoxDecoration(
          color: AppColors.white1,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustText(name: AppStrings.selectProfilePhoto, size: 1.8, fontWeightName: FontWeight.w600),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(context, Icons.visibility, AppStrings.viewPhoto, null),
                _buildPickerOption(context, Icons.camera_alt, AppStrings.camera, ImageSource.camera),
                _buildPickerOption(context, Icons.photo_library, AppStrings.gallery, ImageSource.gallery),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption(BuildContext context, IconData icon, String label, ImageSource? source) {
    return InkWell(
      onTap: () {
        Get.back();
        if (source == null) {
          final imageFile = controller.profileController.selectedImage.value;
          final profilePicUrl = controller.profileController.profileData.value?.profilePic;
          final provider = imageFile != null
              ? FileImage(imageFile)
              : (profilePicUrl != null && profilePicUrl.isNotEmpty
                  ? NetworkImage(profilePicUrl.startsWith('http') ? profilePicUrl : "${AppUrls.baseUrl}$profilePicUrl")
                  : const AssetImage('assets/images/drawer/profile_pic.png')) as ImageProvider;
          FullImageViewer.show(context, imageProvider: provider, heroTag: 'profile_pic_edit');
        } else {
          controller.profileController.pickAndCropImage(source);
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.spacing(context, AppConstants.cardPadding)),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.blue, size: 30),
          ),
          SizedBox(height: ResponsiveHelper.spacing(context, 8)),
          CustText(name: label, size: 1.4),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.dividerColor2, width: 1)),
      ),
      child: TabBar(
        controller: controller.tabController,
        labelColor: AppColors.blue,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        unselectedLabelColor: AppColors.textColor4,
        indicatorColor: AppColors.blue,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
        unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w400, fontSize: 16),
        onTap: (index) => controller.scrollToSection(index),
        tabs: const [
          Tab(text: AppStrings.personalDetails),
          Tab(text: AppStrings.employeeDetails),
          Tab(text: AppStrings.financeDetails),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsSection(BuildContext context) {
    return Container(
      key: controller.personalKey,
      child: AccordionCard(
        title: AppStrings.personalDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustText.sectionHeader(AppStrings.personalDetails),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            Row(
              children: [
                Expanded(child: CustomTextField(controller: controller.firstNameController, label: AppStrings.firstName, hintText: AppStrings.firstName, textCapitalization: TextCapitalization.words)),
                SizedBox(width: ResponsiveHelper.width(context, AppConstants.elementSpacing)),
                Expanded(child: CustomTextField(controller: controller.lastNameController, label: AppStrings.lastName, hintText: AppStrings.lastName, textCapitalization: TextCapitalization.words)),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(controller: controller.empNoController, label: AppStrings.employeeNumber, hintText: AppStrings.enterEmployeeNumber,keyboardType: TextInputType.number,),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(controller: controller.contactNoController, label: AppStrings.contactNumber, hintText: AppStrings.enterContactNumber, keyboardType: TextInputType.phone, maxLength: 10,),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(controller: controller.altContactNoController, label: AppStrings.altContactNumber, hintText: AppStrings.enterAltContactNumber, keyboardType: TextInputType.phone, maxLength: 10),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(controller: controller.emailController, label: AppStrings.email, hintText: AppStrings.enterEmail, keyboardType: TextInputType.emailAddress),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _buildGenderSelection(context),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustDateTimePicker(
              label: AppStrings.dateOfBirth,
              hint: AppStrings.dateFormat,
              selectedDateTime: controller.dobController.text.isEmpty ? null : AppDateUtils.parseDate(controller.dobController.text),
              pickerType: CustDateTimePickerType.date,
              onDateTimeSelected: (date) {
                if (date != null) {
                  controller.dobController.text = AppDateUtils.formatDate(date);
                }
              },
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            CustDropdown(
              label: AppStrings.bloodGroup, 
              hint: AppStrings.selectBloodGroup, 
              items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
              selectedValue: controller.bloodGroupController.text.isEmpty ? null : controller.bloodGroupController.text,
              onChanged: (v) => controller.bloodGroupController.text = v ?? '',
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(controller: controller.birthPlaceController, label: AppStrings.birthPlace, hintText: AppStrings.enterBirthPlace, textCapitalization: TextCapitalization.words),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
            CustText.sectionHeader(AppStrings.verificationDetails),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(
              controller: controller.panCardController, 
              label: AppStrings.panCardNo, 
              hintText: AppStrings.enterPanCardNo, 
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(text: newValue.text.toUpperCase());
                }),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(controller: controller.aadharCardController, label: AppStrings.aadharCardNo, hintText: AppStrings.enterAadharCardNo,keyboardType: TextInputType.number,maxLength: 12,),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
            CustText.sectionHeader(AppStrings.currentAddress),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _buildAddressFields(
              context,
              controller.resHouseNoController, controller.localityController, controller.pincodeController, 
              controller.cityController, controller.stateController, controller.countryController
            ),

            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
            CustText.sectionHeader(AppStrings.permanentAddress),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() => Checkbox(
                  value: controller.sameAsCurrent.value,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  onChanged: (val) => controller.toggleSameAsCurrent(val),
                  activeColor: AppColors.blue,
                )),
                SizedBox(width: ResponsiveHelper.width(context, 8)),
                CustText(name: AppStrings.sameAsCurrentAddress, size: 1.2, color: AppColors.textColor4),
              ],
            ),
            Obx(() => _buildAddressFields(
              context,
              controller.pResHouseNoController, controller.pLocalityController, controller.pPincodeController, 
              controller.pCityController, controller.pStateController, controller.pCountryController,
              enabled: !controller.sameAsCurrent.value
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeDetailsSection(BuildContext context) {
    return Container(
      key: controller.employeeKey,
      child: AccordionCard(
        title: AppStrings.employeeDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustText.sectionHeader(AppStrings.employeeDetails),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustDateTimePicker(
              label: AppStrings.dateOfJoining,
              hint: AppStrings.dateFormat,
              selectedDateTime: controller.dojController.text.isEmpty ? null : AppDateUtils.parseDate(controller.dojController.text),
              pickerType: CustDateTimePickerType.date,
              onDateTimeSelected: (date) {
                if (date != null) {
                  controller.dojController.text = AppDateUtils.formatDate(date);
                }
              },
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            Obx(() => CustDropdown(
              label: AppStrings.city, 
              hint: AppStrings.selectCity, 
              items: controller.profileController.cities.map((e) => e.name.toTitle()).toList(), 
              selectedValue: controller.empCityController.text.isEmpty ? null : controller.empCityController.text,
              onChanged: (v) => controller.empCityController.text = v ?? '',
            )),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            Obx(() => CustDropdown(
              label: AppStrings.department, 
              hint: AppStrings.selectDepartment, 
              items: controller.profileController.departmentTypes.map((e) => e.name.toTitle()).toList(), 
              selectedValue: controller.deptController.text.isEmpty ? null : controller.deptController.text,
              onChanged: (v) => controller.deptController.text = v ?? '',
            )),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            Obx(() {
              final stationControllerLayer = Get.find<StationController>();
              final items = stationControllerLayer.stations.map((s) => s.name.toTitle()).toList();
              return CustDropdown(
                label: AppStrings.station,
                hint: AppStrings.enterStation,
                items: items.isEmpty ? controller.stationListValue.map((e) => e.toTitle()).toList() : items,
                selectedValue: controller.selectedStation.value!.isNotEmpty ? controller.selectedStation.value : null,
                validator: (value) => value == null || value.isEmpty ? AppStrings.pleaseSelectStation : null,
                onChanged: (value) => controller.selectedStation.value = value,
              );
            }),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            Obx(() => CustDropdown(
              label: AppStrings.role, 
              hint: AppStrings.selectRole, 
              items: controller.profileController.roles.map((e) => e.name.toTitle()).toList(), 
              selectedValue: controller.roleController.text.isEmpty ? null : controller.roleController.text,
              onChanged: (v) => controller.roleController.text = v ?? '',
            )),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            Obx(() => CustDropdown(
              label: AppStrings.designation, 
              hint: AppStrings.selectDesignation, 
              items: controller.profileController.designations.map((e) => e.name.toTitle()).toList(), 
              selectedValue: controller.designationController.text.isEmpty ? null : controller.designationController.text,
              onChanged: (v) => controller.designationController.text = v ?? '',
            )),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _buildShiftSelection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceDetailsSection(BuildContext context) {
    return Container(
      key: controller.financeKey,
      child: AccordionCard(
        title: AppStrings.financeDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustText.sectionHeader(AppStrings.financeDetails),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(controller: controller.bankNameController, label: AppStrings.bankName, hintText: AppStrings.enterBankName, textCapitalization: TextCapitalization.words),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(controller: controller.accountNoController, label: AppStrings.accountNumber, hintText: AppStrings.enterAccountNumber, keyboardType: TextInputType.number),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(controller: controller.ifscController, label: AppStrings.ifscCode, hintText: AppStrings.enterIfscCode, textCapitalization: TextCapitalization.characters),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            CustomTextField(controller: controller.branchController, label: AppStrings.branchName, hintText: AppStrings.enterBranchName, textCapitalization: TextCapitalization.words),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressFields(
    BuildContext context, TextEditingController house, TextEditingController locality, TextEditingController pin,
    TextEditingController city, TextEditingController state, TextEditingController country,
    {bool enabled = true}
  ) {
    if (country.text.isEmpty) country.text = 'India';
    return Column(
      children: [
        CustomTextField(controller: house, label: AppStrings.resHouseNo, hintText: AppStrings.hintResHouseNo, enabled: enabled, textCapitalization: TextCapitalization.words),
        SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
        CustomTextField(controller: locality, label: AppStrings.localityTownVillage, hintText: AppStrings.localityTownVillage, enabled: enabled, textCapitalization: TextCapitalization.words),
        SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
        CustomTextField(controller: pin, label: AppStrings.pincode, hintText: AppStrings.enterPincode, keyboardType: TextInputType.number, enabled: enabled, maxLength: 6,),
        SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
        CustomTextField(controller: city, label: AppStrings.city, hintText: AppStrings.enterCity, enabled: enabled, textCapitalization: TextCapitalization.words),
        SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
        CustomTextField(controller: state, label: AppStrings.state, hintText: AppStrings.enterState, enabled: enabled, textCapitalization: TextCapitalization.words),
        SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
        CustomTextField(controller: country, label: AppStrings.country, hintText: AppStrings.enterCountry, enabled: enabled, textCapitalization: TextCapitalization.words),
      ],
    );
  }

  Widget _buildGenderSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustText.formLabel(AppStrings.gender),
        SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.labelSpacing)),
        Row(
          children: [
            _genderButton(context, AppStrings.male, "assets/images/man.png"),
            SizedBox(width: ResponsiveHelper.width(context, 8)),
            _genderButton(context, AppStrings.female,"assets/images/woman.png"),
            SizedBox(width: ResponsiveHelper.width(context, 8)),
            _genderButton(context, AppStrings.others, "assets/images/star.png"),
          ],
        ),
      ],
    );
  }

  Widget _genderButton(BuildContext context, String label, String image) {
    return Expanded(
      child: Obx(() {
        bool isSelected = controller.selectedGender.value == label;
        return InkWell(
          onTap: () => controller.selectedGender.value = label,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.spacing(context, 10)),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? AppColors.blue : AppColors.dividerColor2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image, height: ResponsiveHelper.height(context, 20), width: ResponsiveHelper.width(context, 20)),
                SizedBox(width: ResponsiveHelper.width(context, 8)),
                CustText.formLabel(label,color:  isSelected ? AppColors.blue : AppColors.textColor4)
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShiftSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustText(name: AppStrings.dutyShift, size: 1.4, fontWeightName: FontWeight.w500, color: AppColors.textColor4),
        SizedBox(height: ResponsiveHelper.spacing(context, 8)),
        Row(
          children: [
            _shiftButton(context, AppStrings.morning),
            SizedBox(width: ResponsiveHelper.width(context, 4)),
            _shiftButton(context, AppStrings.evening),
            SizedBox(width: ResponsiveHelper.width(context, 4)),
            _shiftButton(context, AppStrings.night),
            SizedBox(width: ResponsiveHelper.width(context, 4)),
            _shiftButton(context, AppStrings.general),
          ],
        ),
      ],
    );
  }

  Widget _shiftButton(BuildContext context, String label) {
    return Expanded(
      child: Obx(() {
        bool isSelected = controller.selectedShift.value == label;
        return InkWell(
          onTap: () => controller.selectedShift.value = label,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.spacing(context, 10)),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue.withOpacity(0.1) : AppColors.white1,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? AppColors.blue : AppColors.dividerColor2),
            ),
            child: Center(
              child: CustText(
                name: label, 
                size: 1.1, 
                color: isSelected ? AppColors.blue : AppColors.textColor4,
                fontWeightName: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }),
    );
  }
}
