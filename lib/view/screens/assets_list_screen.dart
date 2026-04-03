import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:om_appcart/constants/colors.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/list_item_card_type2.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/cust_fab.dart';
import 'asset_register_form.dart';
import 'package:flutter/rendering.dart';

class AssetsListScreen extends StatefulWidget {
  const AssetsListScreen({Key? key}) : super(key: key);

  @override
  State<AssetsListScreen> createState() => _AssetsListScreenState();
}

class _AssetsListScreenState extends State<AssetsListScreen> {
  bool _isLoading = false;
  bool _isFabExtended = true;

  @override
  void initState() {
    super.initState();
    // Show skeleton loader for 3 seconds to demonstrate
    _simulateLoading();
  }

  void _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });
    
    // Wait 3 seconds to show skeleton loader
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, String>> assets = [
    {
      'assetNo': 'A-001',
      'description': 'Escalator',
      'quantity': '2',
      'modelNo': 'ESC-2022',
      'station': 'Khapri',
      'assetIdFI': 'FI-1001',
      'assetId': 'AST-0001',
      'modification': 'None',
      'modRemarks': '-',
      'date': '01-01-2024',
    },
    {
      'assetNo': 'A-002',
      'description': 'Lift',
      'quantity': '1',
      'modelNo': 'LFT-2021',
      'station': 'Airport',
      'assetIdFI': 'FI-1002',
      'assetId': 'AST-0002',
      'modification': 'Replaced',
      'modRemarks': 'Replaced motor',
      'date': '15-02-2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: 'Asset Register List',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? _buildSkeletonLoader()
          : assets.isEmpty
              ? Center(
                  child: CustText(
                    name: 'No data available in table',
                    size: 1.6,
                    color: AppColors.textColor4,
                  ),
                )
              : NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    if (notification.direction == ScrollDirection.forward) {
                      if (!_isFabExtended) setState(() => _isFabExtended = true);
                    } else if (notification.direction == ScrollDirection.reverse) {
                      if (_isFabExtended) setState(() => _isFabExtended = false);
                    }
                    return true;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      final asset = assets[index];

                    void _showBottomSheet() {
                      CustomBottomSheet.show(
                        context: context,
                        title: "Asset No : ${asset['assetNo'] ?? ''}",
                        options: [
                          CustomBottomSheetOption(
                            title: 'Edit',
                            icon: Icons.edit,
                            iconColor: AppColors.gradientEnd,
                            onTap: () {
                              // TODO: Implement edit logic
                            },
                          ),
                          CustomBottomSheetOption(
                            title: 'Delete',
                            icon: Icons.delete,
                            iconColor: Colors.red,
                            onTap: () {
                              // TODO: Implement delete logic
                            },
                          ),
                        ],
                      );
                    }

                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          assets.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Asset deleted'), duration: Duration(seconds: 2)),
                        );
                      },
                      child: ListItemCardType2(
                        onMenuPressed: _showBottomSheet,
                      leftColumnItems: [
                        CardFieldItem(label: 'Asset No:', value: asset['assetNo'] ?? ''),
                        CardFieldItem(label: 'Model No:', value: asset['modelNo'] ?? ''),
                        CardFieldItem(label: 'Asset Id:', value: asset['assetId'] ?? ''),
                      ],
                      rightColumnItems: [
                        CardFieldItem(label: 'Station:', value: asset['station'] ?? ''),
                        CardFieldItem(label: 'Asset Id created by FI:', value: asset['assetIdFI'] ?? ''),
                        CardFieldItem(label: 'Date:', value: asset['date'] ?? ''),
                      ],
                    ),
                    );
                  },
                ),
              ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustFab(
        label: 'Add Asset',
        icon: Icons.add,
        isExtended: _isFabExtended,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AssetRegisterForm()),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SkeletonLoader.card(height: 120),
      ),
    );
  }
} 