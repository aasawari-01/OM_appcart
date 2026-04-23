import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/view/widgets/cust_button.dart';
import 'package:om_appcart/view/widgets/custom_app_bar.dart';
import 'package:om_appcart/view/widgets/custom_update_dialog.dart';
import 'package:om_appcart/view/widgets/cust_loader.dart';

import '../controller/lost_and_found_form_controller.dart';
import 'widgets/registration_step.dart';
import 'widgets/item_details_step.dart';
import 'widgets/match_status_step.dart';
import 'widgets/additional_steps.dart';

class LostAndFoundScreen extends GetView<LostAndFoundFormController> {
  const LostAndFoundScreen({Key? key}) : super(key: key);

  List<Widget> _getSteps() {
    List<Widget> steps = [
      LFRegistrationStep(controller: controller),
      LFItemDetailsStep(controller: controller),
    ];

    if (controller.registerAs.value == 'Found') {
      steps.add(LFFoundAttachmentsStep(controller: controller));
    }

    if (controller.mode == 'edit') {
      int matchStatus = controller.initialRecord?.matchStatus ?? 0;
      if (controller.registerAs.value == 'Lost') {
        steps.add(LFMatchStatusStep(controller: controller, scrollController: controller.stepScrollController));
        if (matchStatus >= 3) {
          steps.add(LFVerificationStep(controller: controller));
          steps.add(LFHandoverStep(controller: controller));
        }
      }
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized (though Get.to arguments should have handled it if using lazyPut)
    if (!Get.isRegistered<LostAndFoundFormController>()) {
      Get.put(LostAndFoundFormController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 40),
        child: Obx(() {
          final steps = _getSteps();
          return CustomAppBar(
            title: controller.mode == 'edit' ? 'Edit Lost & Found' : 'Add Lost & Found',
            showDrawer: false,
            isForm: true,
            currentStep: controller.currentStep.value,
            totalSteps: steps.length,
            onLeadingPressed: () => Get.back(),
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustLoader());
        }

        final steps = _getSteps();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: steps[controller.currentStep.value.clamp(0, steps.length - 1)],
            ),
            _buildNavigationButtons(context, steps),
          ],
        );
      }),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, List<Widget> steps) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (controller.currentStep.value > 0)
            CustOutlineButton(
              name: 'Back',
              onSelected: (_) => controller.previousStep(),
            ),
          const Spacer(),
          if (controller.currentStep.value < steps.length - 1)
            CustButton(
              name: 'Next',
              onSelected: (_) => controller.nextStep(),
            )
          else
            CustButton(
              name: controller.mode == 'edit' ? 'Update' : 'Submit',
              onSelected: (_) {
                if (controller.mode == 'edit') {
                  CustomUpdateDialog.show(
                    onConfirm: (remark) => controller.submitForm(updateRemark: remark),
                  );
                } else {
                  controller.submitForm();
                }
              },
            ),
        ],
      ),
    );
  }
}
