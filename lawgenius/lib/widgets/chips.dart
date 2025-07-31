// import 'package:flutter/material.dart';
// import 'package:lawgenius/core/constants/app_colors.dart';
// import 'package:lawgenius/models/surprise_product_and_services_model.dart';

// class ChipDataSet extends StatelessWidget {
//   final List<ChipsData> chipData;
//   final int selectedIndex;
//   final Function(int) onChipSelected;

//   const ChipDataSet({
//     super.key,
//     required this.chipData,
//     required this.selectedIndex,
//     required this.onChipSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: SizedBox(
//         height: 40,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: chipData.length,
//           itemBuilder: (context, index) {
//             final chip = chipData[index];
//             final isSelected = selectedIndex == index;

//             return GestureDetector(
//               onTap: () => onChipSelected(index),
//               child: Container(
//                 margin: EdgeInsets.only(left: index == 0 ? 6 : 4, right: 8),
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? AppColors.primary
//                       : AppColors.primary.withValues(alpha: 0.05),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(chip.icon, size: 20, color: chip.color),
//                     const SizedBox(width: 8),
//                     Text(
//                       chip.text,
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : AppColors.primary,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
