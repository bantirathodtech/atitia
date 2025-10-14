// // lib/features/owner_dashboard/foods/view/widgets/owner_menu_day_tab.dart
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../common/styles/spacing.dart';
// import '../../data/models/owner_food_menu.dart';
// import '../../viewmodel/owner_food_viewmodel.dart';
// import '../screens/owner_menu_edit_screen.dart';
//
// /// World-class UI for displaying day's menu with premium design
// class OwnerMenuDayTab extends StatelessWidget {
//   final String dayLabel;
//   const OwnerMenuDayTab({required this.dayLabel, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<OwnerFoodViewModel>(context);
//     final OwnerFoodMenu? menu = vm.getMenuByDay(dayLabel);
//
//     if (menu == null) {
//       return _buildEmptyState(context);
//     }
//
//     return Stack(
//       children: [
//         // Main Content
//         CustomScrollView(
//           slivers: [
//             // Day Header
//             SliverToBoxAdapter(
//               child: _buildDayHeader(context),
//             ),
//
//             // Photo Gallery
//             if (menu.hasPhotos)
//               SliverToBoxAdapter(
//                 child: _buildPhotoGallery(context, menu.photoUrls),
//               ),
//
//             // Breakfast
//             SliverToBoxAdapter(
//               child: _buildPremiumMealSection(
//                 context,
//                 'BREAKFAST',
//                 '7:00 AM - 10:00 AM',
//                 menu.breakfast,
//                 menu.photoUrls,
//                 const LinearGradient(
//                   colors: [Color(0xFFFF6B6B), Color(0xFFFFB347)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 Icons.wb_sunny_outlined,
//               ),
//             ),
//
//             // Lunch
//             SliverToBoxAdapter(
//               child: _buildPremiumMealSection(
//                 context,
//                 'LUNCH',
//                 '12:00 PM - 3:00 PM',
//                 menu.lunch,
//                 menu.photoUrls,
//                 const LinearGradient(
//                   colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 Icons.restaurant_outlined,
//               ),
//             ),
//
//             // Dinner
//             SliverToBoxAdapter(
//               child: _buildPremiumMealSection(
//                 context,
//                 'DINNER',
//                 '7:00 PM - 10:00 PM',
//                 menu.dinner,
//                 menu.photoUrls,
//                 const LinearGradient(
//                   colors: [Color(0xFF5C6BC0), Color(0xFF7E57C2)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 Icons.nightlight_outlined,
//               ),
//             ),
//
//             // Bottom Spacing
//             const SliverToBoxAdapter(
//               child: SizedBox(height: 100),
//             ),
//           ],
//         ),
//
//         // Floating Edit Button
//         Positioned(
//           right: 20,
//           bottom: 20,
//           child: FloatingActionButton.extended(
//             heroTag: 'edit_menu_$dayLabel', // Unique tag for each day
//             onPressed: () => _editDayMenu(context, menu),
//             backgroundColor: Theme.of(context).primaryColor,
//             icon: const Icon(Icons.edit_outlined, color: Colors.white),
//             label: const Text(
//               'Edit Menu',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15,
//               ),
//             ),
//             elevation: 6,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDayHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Theme.of(context).primaryColor.withOpacity(0.1),
//             Theme.of(context).primaryColor.withOpacity(0.05),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               Icons.calendar_today,
//               color: Theme.of(context).primaryColor,
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 dayLabel.toUpperCase(),
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w800,
//                   color: Theme.of(context).primaryColor,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 'Today\'s Complete Menu',
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.grey.shade50,
//             Colors.white,
//           ],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(40),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Theme.of(context).primaryColor.withOpacity(0.1),
//                       Theme.of(context).primaryColor.withOpacity(0.05),
//                     ],
//                   ),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Theme.of(context).primaryColor.withOpacity(0.1),
//                       blurRadius: 30,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.restaurant_menu_outlined,
//                   size: 80,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               const Text(
//                 'No Menu Available',
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF2D3436),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 'Create a delicious menu with\nbreakfast, lunch, and dinner items',
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.grey.shade600,
//                   height: 1.5,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),
//               ElevatedButton.icon(
//                 onPressed: () => _editDayMenu(context, null),
//                 icon: const Icon(Icons.add_circle_outline, size: 26),
//                 label: const Text(
//                   'Add Menu',
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 18,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 8,
//                   shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPhotoGallery(BuildContext context, List<String> photoUrls) {
//     return Container(
//       height: 280,
//       margin: const EdgeInsets.all(16),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: PageView.builder(
//           itemCount: photoUrls.length,
//           itemBuilder: (context, index) {
//             return Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.network(
//                   photoUrls[index],
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Container(
//                       color: Colors.grey.shade200,
//                       child: const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                   },
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: Colors.grey.shade200,
//                       child: Icon(
//                         Icons.broken_image,
//                         size: 60,
//                         color: Colors.grey.shade400,
//                       ),
//                     );
//                   },
//                 ),
//                 // Gradient overlay
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.4),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Photo counter
//                 if (photoUrls.length > 1)
//                   Positioned(
//                     bottom: 16,
//                     right: 16,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.7),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(
//                             Icons.photo_library,
//                             color: Colors.white,
//                             size: 16,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             '${index + 1} / ${photoUrls.length}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPremiumMealSection(
//     BuildContext context,
//     String mealName,
//     String timeRange,
//     List<String> items,
//     List<String> photoUrls,
//     Gradient gradient,
//     IconData icon,
//   ) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Premium Header with Gradient
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: gradient,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.25),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Icon(icon, color: Colors.white, size: 28),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         mealName,
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.white,
//                           letterSpacing: 0.8,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.access_time,
//                             color: Colors.white,
//                             size: 14,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             timeRange,
//                             style: const TextStyle(
//                               fontSize: 13,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.25),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.restaurant,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         '${items.length}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Food Items with Premium Design
//           if (items.isEmpty)
//             Padding(
//               padding: const EdgeInsets.all(32),
//               child: Center(
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.restaurant_menu_outlined,
//                       size: 48,
//                       color: Colors.grey.shade300,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'No ${mealName.toLowerCase()} items',
//                       style: TextStyle(
//                         color: Colors.grey.shade400,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           else
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: items.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final item = entry.value;
//                   final gradientColors = (gradient as LinearGradient).colors;
//
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: Colors.grey.shade100,
//                         width: 2,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: gradientColors.first.withOpacity(0.08),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(14),
//                       child: Row(
//                         children: [
//                           // Number Badge
//                           Container(
//                             width: 38,
//                             height: 38,
//                             decoration: BoxDecoration(
//                               gradient: gradient,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: gradientColors.first.withOpacity(0.3),
//                                   blurRadius: 6,
//                                   offset: const Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child: Text(
//                                 '${index + 1}',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 14),
//
//                           // Food Name
//                           Expanded(
//                             child: Text(
//                               item,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF2D3436),
//                                 height: 1.4,
//                               ),
//                             ),
//                           ),
//
//                           // Check Icon
//                           Container(
//                             padding: const EdgeInsets.all(6),
//                             decoration: BoxDecoration(
//                               gradient: gradient,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.check,
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   void _editDayMenu(BuildContext context, OwnerFoodMenu? menu) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => OwnerMenuEditScreen(
//           dayLabel: dayLabel,
//           existingMenu: menu,
//         ),
//       ),
//     );
//   }
// }
//
// lib/features/owner_dashboard/foods/view/widgets/owner_menu_day_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../common/styles/colors.dart';
import '../../data/models/owner_food_menu.dart';
import '../../viewmodel/owner_food_viewmodel.dart';
import '../screens/owner_menu_edit_screen.dart';

/// Premium Day Tab with World-Class UI/UX
class OwnerMenuDayTab extends StatelessWidget {
  final String dayLabel;
  final Color dayColor;
  final IconData dayIcon;

  const OwnerMenuDayTab({
    required this.dayLabel,
    required this.dayColor,
    required this.dayIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OwnerFoodViewModel>(context);
    final OwnerFoodMenu? menu = vm.getMenuByDay(dayLabel);

    if (menu == null) {
      return _buildEmptyState(context);
    }

    return Stack(
      children: [
        // Background Pattern
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  dayColor.withOpacity(0.02),
                  dayColor.withOpacity(0.005),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Main Content
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Day Header with Enhanced Design
            SliverToBoxAdapter(
              child: _buildPremiumHeader(context, menu),
            ),

            // Photo Gallery Section
            if (menu.hasPhotos)
              SliverToBoxAdapter(
                child: _buildPhotoGallerySection(context, menu.photoUrls),
              ),

            // Meal Sections
            SliverToBoxAdapter(
              child: _buildMealSection(
                context,
                menu,
                'BREAKFAST',
                '7:00 AM - 10:00 AM',
                menu.breakfast,
                Icons.breakfast_dining_rounded,
                [
                  AppColors.breakfast,  // Reusable breakfast color
                  AppColors.breakfast.withOpacity(0.7),
                ],
                0,
              ),
            ),

            SliverToBoxAdapter(
              child: _buildMealSection(
                context,
                menu,
                'LUNCH',
                '12:00 PM - 3:00 PM',
                menu.lunch,
                Icons.lunch_dining_rounded,
                [
                  AppColors.lunch,  // Reusable lunch color
                  AppColors.lunch.withOpacity(0.7),
                ],
                1,
              ),
            ),

            SliverToBoxAdapter(
              child: _buildMealSection(
                context,
                menu,
                'DINNER',
                '7:00 PM - 10:00 PM',
                menu.dinner,
                Icons.dinner_dining_rounded,
                [
                  AppColors.dinner,  // Reusable dinner color
                  AppColors.dinner.withOpacity(0.7),
                ],
                2,
              ),
            ),

            // Bottom Spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),

        // Floating Action Button
        Positioned(
          right: 20,
          bottom: 20,
          child: _buildFloatingEditButton(context, menu),
        ),
      ],
    );
  }

  Widget _buildPremiumHeader(BuildContext context, OwnerFoodMenu menu) {
    final theme = Theme.of(context);
    final textSecondary = theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            dayColor.withOpacity(0.1),
            dayColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: dayColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      dayColor,
                      dayColor.withOpacity(0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: dayColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  dayIcon, 
                  color: AppColors.textOnPrimary,  // White icon on colored bg
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayLabel.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: dayColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Menu Created • ${menu.formattedUpdatedAt}',
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildMenuStats(menu, context),
                  ],
                ),
              ),
            ],
          ),
          // ✏️ EDIT MENU BUTTON - Makes it clear the menu is editable
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToEditScreen(context, dayLabel, menu),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text(
                'Edit Menu',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: dayColor,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuStats(OwnerFoodMenu menu, BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildStatItem(
          '${menu.breakfast.length}',
          'Breakfast',
          Icons.breakfast_dining_rounded,
          context,
        ),
        _buildStatItem(
          '${menu.lunch.length}',
          'Lunch',
          Icons.lunch_dining_rounded,
          context,
        ),
        _buildStatItem(
          '${menu.dinner.length}',
          'Dinner',
          Icons.dinner_dining_rounded,
          context,
        ),
        _buildStatItem(
          '${menu.photoUrls.length}',
          'Photos',
          Icons.photo_library_rounded,
          context,
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkCard.withOpacity(0.8)  // Dark mode stat background
            : AppColors.textOnPrimary.withOpacity(0.7),  // Light mode stat background (white)
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? AppColors.textOnPrimary.withOpacity(0.2)  // Subtle white border in dark
              : AppColors.textOnPrimary.withOpacity(0.5),  // Semi-transparent white in light
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: dayColor),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: dayColor,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: dayColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGallerySection(
      BuildContext context, List<String> photoUrls) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surface;
    
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: PageView.builder(
        itemCount: photoUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)  // Darker shadow in dark mode
                      : Colors.black.withOpacity(0.1),  // Light shadow in light mode
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    photoUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: isDarkMode 
                            ? AppColors.darkCard  // Dark shimmer base
                            : AppColors.surfaceVariant,  // Light shimmer base
                        highlightColor: isDarkMode
                            ? AppColors.darkInputFill  // Dark shimmer highlight
                            : AppColors.surface,  // Light shimmer highlight
                        child: Container(
                          color: surfaceColor,  // Theme-aware background
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDarkMode 
                            ? AppColors.darkCard  // Dark error background
                            : AppColors.surfaceVariant,  // Light error background
                        child: Icon(
                          Icons.broken_image_rounded,
                          size: 50,
                          color: isDarkMode
                              ? AppColors.textTertiary  // Light icon in dark mode
                              : AppColors.textSecondary,  // Medium icon in light mode
                        ),
                      );
                    },
                  ),
                  // Gradient Overlay (for better text visibility on images)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),  // Subtle dark overlay on bottom
                        ],
                      ),
                    ),
                  ),
                  // Photo Counter with theme-aware background
                  if (photoUrls.length > 1)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.darkCard.withOpacity(0.9)  // Dark mode counter bg
                              : Colors.black.withOpacity(0.7),  // Light mode counter bg
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.textOnPrimary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${index + 1}/${photoUrls.length}',
                          style: TextStyle(
                            color: AppColors.textOnPrimary,  // White text on dark bg
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealSection(
    BuildContext context,
    OwnerFoodMenu menu,
    String mealName,
    String timeRange,
    List<String> items,
    IconData icon,
    List<Color> gradientColors,
    int sectionIndex,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surface;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,  // Theme-aware card background
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.2)  // Darker shadow in dark mode
                : Colors.black.withOpacity(0.05),  // Light shadow in light mode
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Meal Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon, 
                    color: AppColors.textOnPrimary,  // White icon on gradient
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textOnPrimary,  // White text on gradient
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: AppColors.textOnPrimary,  // White icon
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            timeRange,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textOnPrimary,  // White text
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.restaurant_menu_rounded,
                        color: AppColors.textOnPrimary,  // White icon
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${items.length}',
                        style: TextStyle(
                          color: AppColors.textOnPrimary,  // White text
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Food Items
          if (items.isEmpty)
            _buildEmptyMealState(mealName, context)
          else
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return _buildFoodItem(
                    context,
                    item,
                    index + 1,
                    gradientColors.first,
                    sectionIndex * 100 + index,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(
    BuildContext context,
    String item,
    int number,
    Color color,
    int uniqueKey,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surface;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final dividerColor = theme.dividerColor;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surfaceColor,  // Theme-aware card background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode 
              ? AppColors.darkDivider  // Dark mode border
              : AppColors.outline,  // Light mode border
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Number Badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,  // White number on colored badge
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Food Name - CRITICAL: This must be theme-aware for visibility!
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,  // ✅ THEME-AWARE TEXT - Now visible in both modes!
                      height: 1.4,
                    ),
                  ),
                ),

                // Check Icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: color,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMealState(String mealName, BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary = theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final textTertiary = AppColors.textTertiary;
    
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu_rounded,
            size: 50,
            color: textTertiary,  // Theme-aware muted color
          ),
          const SizedBox(height: 12),
          Text(
            'No $mealName items',
            style: TextStyle(
              color: textSecondary,  // Theme-aware
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add delicious $mealName items to complete your menu',
            style: TextStyle(
              color: textTertiary,  // Theme-aware muted text
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final textPrimary = theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: dayColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                size: 50,
                color: dayColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Menu for $dayLabel',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: textPrimary,  // Theme-aware
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create a beautiful menu for $dayLabel to get started',
              style: TextStyle(
                fontSize: 15,
                color: textSecondary,  // Theme-aware
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _navigateToEditScreen(context, dayLabel);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: dayColor,
                foregroundColor: AppColors.textOnPrimary,  // White text
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 8,
                shadowColor: dayColor.withOpacity(0.3),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Create Menu',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingEditButton(BuildContext context, OwnerFoodMenu menu) {
    return FloatingActionButton(
      heroTag: 'edit_menu_$dayLabel', // Unique hero tag for each day
      onPressed: () => _navigateToEditScreen(context, dayLabel, menu),  // Pass menu for editing
      backgroundColor: dayColor,
      foregroundColor: AppColors.textOnPrimary,  // White text
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              dayColor,
              dayColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: dayColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(Icons.edit_rounded, size: 24),
      ),
    );
  }

  /// Navigate to edit screen with existing menu data for editing
  void _navigateToEditScreen(BuildContext context, String day, [OwnerFoodMenu? existingMenu]) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            OwnerMenuEditScreen(
              dayLabel: day,
              existingMenu: existingMenu,  // ✅ Pass existing menu for editing
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
