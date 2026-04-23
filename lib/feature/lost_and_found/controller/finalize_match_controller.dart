import 'package:get/get.dart';
import '../service/lost_found_service.dart';
import '../../../view/widgets/custom_snackbar.dart';

class FinalizeMatchController extends GetxController {
  final LostFoundService _service = LostFoundService();
  
  late int lostID;
  late List<dynamic> matchData;
  
  var isLoading = false.obs;
  var selectedIndices = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      lostID = args['lostID'] ?? 0;
      matchData = args['matchData'] ?? [];
    }
  }

  void toggleSelection(int index) {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
    } else {
      // Single selection logic for finalize API as per current implementation
      selectedIndices.clear();
      selectedIndices.add(index);
    }
  }

  Future<void> submitFinalize() async {
    if (selectedIndices.isEmpty) {
      CustomSnackBar.show(title: 'Selection Required', message: 'Please select a found item.');
      return;
    }
    
    final int selectedIndex = selectedIndices.first;
    final match = matchData[selectedIndex];
    final int foundID = match['found_id'];

    try {
      isLoading(true);
      final response = await _service.finalizeMatch(lostID, foundID);
      if (response['status'] == true) {
        Get.back(result: match);
        CustomSnackBar.show(title: 'Success', message: 'Match finalized successfully.', isError: false);
      }
    } catch (e) {
      String msg = e.toString().replaceAll('Exception: ', '');
      if (msg.contains('TimeoutException')) {
        msg = 'Connection timed out.';
      }
      CustomSnackBar.show(title: 'Error', message: msg);
    } finally {
      isLoading(false);
    }
  }
}
