import 'package:get/get.dart';
import '../service/station_service.dart';
import '../feature/lost&found/model/lost_found_table_record.dart';

class StationController extends GetxController {
  final StationService _service = StationService();

  var stations = <Station>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStations();
  }

  Future<void> fetchStations() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _service.getStations();
      if (response.status) {
        stations.assignAll(response.data);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<String> get stationNames => stations.map((s) => s.name).toList();

  int? getStationIdByName(String? name) {
    if (name == null || name.trim().isEmpty) return null;
    try {
      final normalizedInput = name.trim().toLowerCase();
      return stations.firstWhere((s) => s.name.trim().toLowerCase() == normalizedInput).id;
    } catch (_) {
      return null;
    }
  }

  String? getStationNameById(int? id) {
    if (id == null) return null;
    try {
      return stations.firstWhere((s) => s.id == id).name;
    } catch (_) {
      return null;
    }
  }
}
