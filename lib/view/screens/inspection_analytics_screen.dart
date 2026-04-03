import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../constants/colors.dart';
import '../widgets/cust_text.dart';

class InspectionAnalyticsScreen extends StatefulWidget {
  const InspectionAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<InspectionAnalyticsScreen> createState() => _InspectionAnalyticsScreenState();
}

class _InspectionAnalyticsScreenState extends State<InspectionAnalyticsScreen> {
  // Mock data for the chart
  final List<double> chartValues = [40, 30, 30]; // Created, Pending, Closed
  final List<Color> chartColors = [
    AppColors.blue2, // Created - Blue
    AppColors.yellow, // Pending - Orange/Yellow
    AppColors.barColor4, // Closed - Green
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopStats(),
          const SizedBox(height: 16),
          _buildStatusCards(),
          const SizedBox(height: 24),
          const CustText(
            name: 'Inspection by Departments',
            size: 1.7,
            fontWeightName: FontWeight.w600,
          ),
          const SizedBox(height: 16),
          _buildChartSection(),
          const SizedBox(height: 24),
          _buildFrequentInspections(),
        ],
      ),
    );
  }

  Widget _buildTopStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total\nScheduled',
            count: '40',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Total\nUnscheduled',
            count: '60',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String count}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustText(
            name: title,
            size: 1.2,
            color: AppColors.textColor4,
            maxLines: 2,
          ),
          CustText(
            name: count,
            size: 1.8,
            color: AppColors.textColor5,
            fontWeightName: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            label: 'Created',
            count: '40',
            color: AppColors.textColor3,
            bgColor: AppColors.cardBg,
            icon: TablerIcons.license,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatusCard(
            label: 'Pending',
            count: '30',
            color: AppColors.analyticText,
            bgColor: AppColors.cardBg2,
            icon: TablerIcons.history_toggle, // Or a clock icon
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatusCard(
            label: 'Closed',
            count: '30',
            color: AppColors.analyticText2,
            bgColor: AppColors.cardBg3,
            icon: TablerIcons.circle_check,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String label,
    required String count,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: CustText(
                  name: label,
                  size: 1.2,
                  color: color,
                  fontWeightName: FontWeight.w500,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustText(
            name: count,
            size: 1.8,
            color: AppColors.textColor5,
            fontWeightName: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const CustText(name: 'All', size: 1.6,color: AppColors.black,),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 18),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Transform.translate(
                    offset: const Offset(0, 25),
                    child: PieChart(
                      PieChartData(
                        startDegreeOffset: 180,
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 4, // Space between sections
                        centerSpaceRadius: 70,
                        sections: [
                          PieChartSectionData(
                            color: AppColors.piechart1,
                            value: 40,
                            title: '40',
                            radius: 40,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: AppColors.analyticText,
                            value: 30,
                            title: '30',
                            radius: 40,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: AppColors.analyticText2,
                            value: 30,
                            title: '30',
                            radius: 40,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          // Invisible section to make it a semi-circle
                          PieChartSectionData(
                            color: Colors.transparent,
                            value: 100,
                            title: '',
                            radius: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0, 5), // Adjusted for new center
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CustText(
                            name: 'Total',
                            size: 1.4,
                            color: AppColors.textColor4,
                          ),
                          CustText(
                            name: '100',
                            size: 2.0,
                            fontWeightName: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(AppColors.blue2, 'Created'),
              const SizedBox(width: 16),
              _buildLegendItem(AppColors.yellow, 'Pending'),
              const SizedBox(width: 16),
              _buildLegendItem(AppColors.barColor4, 'Closed'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        CustText(name: label, size: 1.1, color: AppColors.textColor5),
      ],
    );
  }

  Widget _buildFrequentInspections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustText(
          name: 'Frequent Inspections',
          size: 1.7,
          fontWeightName: FontWeight.w600,
        ),
        CustText(
          name: 'Most 5 frequent inspections type by %',
          size: 1.6,
          color: AppColors.textColor4,
        ),
        const SizedBox(height: 12),
        _buildFrequentItem(
          type: 'Footplate',
          department: 'Civil',
          percentage: '68%',
        ),
        _buildFrequentItem(
          type: 'OCC',
          department: 'Signaling',
          percentage: '70%',
        ),
        _buildFrequentItem(
          type: 'Footplate',
          department: 'Civil',
          percentage: '65%',
        ),
      ],
    );
  }

  Widget _buildFrequentItem({
    required String type,
    required String department,
    required String percentage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Inspection Type : ',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,

                      ),
                    ),
                    TextSpan(
                      text: type,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Department : ',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: department,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.percentBgColor, // Light red bg for percentage
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustText(
              name: percentage,
              size: 1.5,
              color: AppColors.red, // Red text
              fontWeightName: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
