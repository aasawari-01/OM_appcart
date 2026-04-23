import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../model/lost_found_table_record.dart';
import '../service/lost_found_service.dart';
import '../../../view/widgets/custom_snackbar.dart';
import '../service/lost_found_cache_service.dart';

class LostAndFoundListController extends GetxController {
  final LostFoundService _service = LostFoundService();

  var isLoading = true.obs;
  var isMoreLoading = false.obs;
  var lostFoundItems = <LostFoundTableRecord>[].obs;
  var errorMessage = ''.obs;
  final LostFoundCacheService _cacheService = LostFoundCacheService();
  var isOfflineMode = false.obs;

  int _skip = 0;
  final int _limit = 10;
  var hasMore = true.obs;
  
  var expandedItemId = RxnInt();
  
  final ScrollController scrollController = ScrollController();
  var isFabExtended = true.obs;

  void toggleExpansion(int id) {
    if (expandedItemId.value == id) {
      expandedItemId.value = null;
    } else {
      expandedItemId.value = id;
    }
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchItems();
  }

  void _onScroll() {
    // FAB visibility logic
    if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (isFabExtended.value) isFabExtended.value = false;
    } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!isFabExtended.value) isFabExtended.value = true;
    }

    // Pagination logic
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      loadMoreItems();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchItems({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        _skip = 0;
        hasMore(true);
      } else {
        isLoading(true);
      }
      
      errorMessage('');
      final response = await _service.getLostFoundTable(skip: 0, limit: _limit);
      
      if (response.status) {
        lostFoundItems.assignAll(response.data);
        _skip = response.data.length;
        if (response.data.length < _limit) {
          hasMore(false);
        }
      } else {
        errorMessage(response.message);
        CustomSnackBar.show(title: 'Error', message: response.message);
      }
    } catch (e) {
      String msg = e.toString();
      
      // Handle offline case
      if (msg.contains('SocketException') || msg.contains('TimeoutException') || msg.contains('Timeout')) {
        final cachedItems = await _cacheService.getCachedItems();
        if (cachedItems.isNotEmpty) {
          lostFoundItems.assignAll(cachedItems);
          isOfflineMode(true);
          CustomSnackBar.show(
            title: 'Offline Mode', 
            message: 'Showing cached data. Connection failed.',
          );
          return;
        }
      }

      if (msg.contains('TimeoutException') || msg.contains('Timeout')) {
        msg = 'Connection timed out. Please try again.';
      } else if (msg.contains('SocketException')) {
        msg = 'No internet connection or server unreachable.';
      } else {
        msg = msg.replaceAll('Exception: ', '');
      }
      errorMessage(msg);
      CustomSnackBar.show(title: 'Error', message: msg);
    } finally {
      isLoading(false);
      // Cache the first page if successful and online
      if (isRefresh && !isOfflineMode.value && lostFoundItems.isNotEmpty) {
        _cacheService.saveItems(lostFoundItems.take(_limit).toList());
      }
    }
  }

  Future<void> loadMoreItems() async {
    if (isMoreLoading.value || !hasMore.value) return;

    try {
      isMoreLoading(true);
      final response = await _service.getLostFoundTable(skip: _skip, limit: _limit);
      
      if (response.status) {
        if (response.data.isEmpty) {
          hasMore(false);
        } else {
          lostFoundItems.addAll(response.data);
          _skip += response.data.length;
          if (response.data.length < _limit) {
            hasMore(false);
          }
        }
      }
    } catch (e) {
      errorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isMoreLoading(false);
    }
  }

  void refreshItems() {
    isOfflineMode(false);
    fetchItems(isRefresh: true);
  }

  Future<bool> deleteItem(int id) async {
    try {
      isLoading(true);
      final response = await _service.bulkSoftDelete([id]);
      
      if (response['status'] == true) {
        lostFoundItems.removeWhere((item) => item.id == id);
        CustomSnackBar.show(
          title: 'Success',
          message: response['message'] ?? 'Item deleted successfully',
        );
        return true;
      } else {
        CustomSnackBar.show(
          title: 'Error',
          message: response['message'] ?? 'Failed to delete item',
        );
        return false;
      }
    } catch (e) {
      String msg = e.toString().replaceAll('Exception: ', '');
      CustomSnackBar.show(title: 'Error', message: msg);
      return false;
    } finally {
      isLoading(false);
    }
  }
}
