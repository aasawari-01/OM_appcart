// import 'package:flutter/material.dart';
// import '../../constants/colors.dart'; // adjust import path as needed
//
// class ThemeSettingsScreen extends StatefulWidget {
//   const ThemeSettingsScreen({super.key});
//
//   @override
//   State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
// }
//
// class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
//   late int _selectedIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     // Find the current active color's index
//     _selectedIndex = kPrimaryColors.indexWhere(
//           (c) => c.color.value == ThemeManager.current.color.value,
//     );
//     if (_selectedIndex == -1) _selectedIndex = 0;
//   }
//
//   Future<void> _onColorTap(int index) async {
//     setState(() => _selectedIndex = index);
//     await ThemeManager.setPrimaryColor(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
//           color: AppColors.textColor,
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Theme Settings',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textColor,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 8),
//
//             // ── Subtitle ──────────────────────────────────────────────────
//             const Text(
//               'Choose a primary color',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Color(0xFF9E9E9E),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//
//             const SizedBox(height: 28),
//
//             // ── Color Cards ───────────────────────────────────────────────
//             ...List.generate(kPrimaryColors.length, (index) {
//               final item = kPrimaryColors[index];
//               final isSelected = index == _selectedIndex;
//
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: _ColorOptionCard(
//                   item: item,
//                   isSelected: isSelected,
//                   onTap: () => _onColorTap(index),
//                 ),
//               );
//             }),
//
//             const SizedBox(height: 28),
//
//             // ── Preview banner ────────────────────────────────────────────
//             _PreviewBanner(color: kPrimaryColors[_selectedIndex]),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Color option card
// // ─────────────────────────────────────────────────────────────────────────────
// class _ColorOptionCard extends StatelessWidget {
//   final AppPrimaryColor item;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const _ColorOptionCard({
//     required this.item,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeOut,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: isSelected ? item.lightTint : const Color(0xFFF8F8F8),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isSelected ? item.color : const Color(0xFFE8E8E8),
//             width: isSelected ? 1.8 : 1.0,
//           ),
//         ),
//         child: Row(
//           children: [
//             // Color circle
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: item.color,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: item.color.withOpacity(0.35),
//                     blurRadius: 8,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16),
//
//             // Name
//             Expanded(
//               child: Text(
//                 item.name,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                   color: isSelected ? item.color : AppColors.textColor,
//                 ),
//               ),
//             ),
//
//             // Checkmark
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 200),
//               child: isSelected
//                   ? Container(
//                 key: const ValueKey('check'),
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: item.color,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check_rounded,
//                   color: Colors.white,
//                   size: 15,
//                 ),
//               )
//                   : const SizedBox(key: ValueKey('empty'), width: 24, height: 24),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Small live preview showing how the color looks in common UI elements
// // ─────────────────────────────────────────────────────────────────────────────
// class _PreviewBanner extends StatelessWidget {
//   final AppPrimaryColor color;
//
//   const _PreviewBanner({required this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Preview',
//           style: TextStyle(
//             fontSize: 13,
//             color: Color(0xFF9E9E9E),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF8F8F8),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: const Color(0xFFEEEEEE)),
//           ),
//           child: Row(
//             children: [
//               // Icon button preview
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: color.lightTint,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(Icons.edit_rounded, color: color.color, size: 18),
//               ),
//               const SizedBox(width: 14),
//
//               // Text link preview
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Edit Profile',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: color.color,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'rohansharma@example.com',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: color.color.withOpacity(0.7),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Filled button preview
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: color.color,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Text(
//                   'Save',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../view/widgets/custom_app_bar.dart'; // adjust import path as needed

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = kPrimaryColors.indexWhere(
          (c) => c.color.value == ThemeManager.current.color.value,
    );
    if (_selectedIndex == -1) _selectedIndex = 0;
  }

  Future<void> _onApply() async {
    await ThemeManager.setPrimaryColor(_selectedIndex);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = kPrimaryColors[_selectedIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar(
        title: 'Change Theme',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // ── Section title ──────────────────────────────────────
                  const Text(
                    'Change Account Theme',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Set a new account password to login in to application.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Phone mockup preview ───────────────────────────────
                  _PhoneMockup(primaryColor: selectedColor.color),

                  const SizedBox(height: 28),

                  // ── Default Theme label ────────────────────────────────
                  const Text(
                    'Default Theme',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // First color = default (index 0), shown alone
                  _ColorCircle(
                    color: kPrimaryColors[0].color,
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),

                  const SizedBox(height: 24),

                  // ── All Themes label ───────────────────────────────────
                  const Text(
                    'All Themes',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // All 5 colors in a row
                  Row(
                    children: List.generate(kPrimaryColors.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _ColorCircle(
                          color: kPrimaryColors[index].color,
                          isSelected: _selectedIndex == index,
                          onTap: () => setState(() => _selectedIndex = index),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Apply button ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedColor.color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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

// ─────────────────────────────────────────────────────────────────────────────
// Color circle selector
// ─────────────────────────────────────────────────────────────────────────────
class _ColorCircle extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorCircle({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          border: isSelected
              ? Border.all(color: Colors.white, width: 3)
              : null,
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 0,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone mockup preview
// Replace the dummy content with Image.asset once you have your real image.
// ─────────────────────────────────────────────────────────────────────────────
class _PhoneMockup extends StatelessWidget {
  final Color primaryColor;

  const _PhoneMockup({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Container(
          width: 160,
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(
            children: [


              // Profile row mock
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: primaryColor, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 7,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8D8D8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAEAEA),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Two card blocks
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _mockCard(70, 50),
                    const SizedBox(width: 8),
                    _mockCard(50, 50),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Highlighted bar (primary color tint)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 20,
                  width: 80,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),

              const Spacer(),

              // Bottom action bar (primary color)
              Container(
                height: 36,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // ── TO USE YOUR OWN IMAGE instead of the dummy mockup above ───────────
    // Delete the Container above and uncomment this:
    //
    // return Container(
    //   width: double.infinity,
    //   height: 260,
    //   decoration: BoxDecoration(
    //     color: const Color(0xFFF2F2F2),
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    //   child: Center(
    //     child: Image.asset(
    //       'assets/images/theme_preview.png',
    //       height: 230,
    //       fit: BoxFit.contain,
    //     ),
    //   ),
    // );
  }

  Widget _mockCard(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}