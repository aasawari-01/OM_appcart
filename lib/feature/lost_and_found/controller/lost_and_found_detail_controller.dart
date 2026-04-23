import 'package:get/get.dart';
import '../model/lost_found_table_record.dart';
import '../service/lost_found_service.dart';
import '../../../view/widgets/custom_snackbar.dart';

class LostAndFoundDetailController extends GetxController {
  final LostFoundService _service = LostFoundService();
  late String uniqueCode;

  var isLoading = true.obs;
  var record = Rxn<LostFoundTableRecord>();
  var errorMessage = ''.obs;

  // Expansion states
  var isMatchStatusExpanded = true.obs;
  var isMatchedExpanded = true.obs;
  var isBasicDetailsExpanded = true.obs;
  var isItemDetailsExpanded = true.obs;
  var isFoundAttachmentsExpanded = true.obs;
  var isVerificationExpanded = true.obs;
  var isHandoverExpanded = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      uniqueCode = args['uniqueCode'] ?? '';
      if (args['record'] != null) {
        record.value = args['record'];
      }
    } else if (args != null && args is String) {
      uniqueCode = args;
    }
    
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _service.getSingleLostFoundData(uniqueCode);
      if (response.status && response.data != null) {
        record.value = response.data;
      } else {
        errorMessage(response.message);
      }
    } catch (e) {
      String msg = e.toString();
      bool isNetworkError = msg.contains('SocketException') || msg.contains('TimeoutException') || msg.contains('Timeout');
      
      if (msg.contains('TimeoutException') || msg.contains('Timeout')) {
        msg = 'Connection timed out.';
      } else if (msg.contains('SocketException')) {
        msg = 'No internet connection.';
      } else {
        msg = msg.replaceAll('Exception: ', '');
      }

      errorMessage(msg);
      
      // Only show snackbar if we don't have initial data to show
      if (record.value == null || !isNetworkError) {
        CustomSnackBar.show(title: 'Error', message: msg);
      }
    } finally {
      isLoading(false);
    }
  }
}
