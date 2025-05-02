// import 'package:flutter/material.dart';
// import 'package:recipe_book/components/procedure_item.dart';
// import 'package:recipe_book/components/ingredient_item.dart';
// import 'package:recipe_book/components/video_player.dart';
// // import 'package:video_player/video_player.dart';

// class RecipeDetailPage extends StatefulWidget {
//   const RecipeDetailPage({super.key});

//   @override
//   State<RecipeDetailPage> createState() => _RecipeDetailPageState();
// }

// class _RecipeDetailPageState extends State<RecipeDetailPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       body: Column(
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(24),
//                   bottomRight: Radius.circular(24),
//                 ),
//                 child: Image.asset(
//                   'assets/images/pizza.webp',
//                   width: double.infinity,
//                   height: 260,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               // overlay
//               Positioned.fill(
//                 child: Opacity(
//                   opacity: 0.5,
//                   child: Container(
//                     color: const Color(0xFF000000),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 20,
//                 left: 16,
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//               const Positioned(
//                 top: 40,
//                 right: 16,
//                 child: Icon(Icons.bookmark_border, color: Colors.white),
//               ),
//               const Positioned(
//                 bottom: 16,
//                 left: 16,
//                 child: Text(
//                   'Recipe Details',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               )
//             ],
//           ),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               child: ListView(
//                 children: [
//                   Row(
//                     children: [
//                       const Expanded(
//                         child: Text(
//                           'Capucinno',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.yellow[700],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Row(
//                           children: [
//                             Icon(Icons.star, size: 16, color: Colors.white),
//                             SizedBox(width: 4),
//                             Text(
//                               '5.0',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Icon(Icons.access_time, size: 16),
//                       const SizedBox(width: 4),
//                       const Text('20 mins'),
//                       const SizedBox(width: 16),
//                       const Icon(Icons.local_fire_department, size: 16),
//                       const SizedBox(width: 4),
//                       const Text('Medium'),
//                       const SizedBox(width: 16),
//                       const Icon(Icons.whatshot, size: 16),
//                       const SizedBox(width: 4),
//                       const Text('100 Cal'),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Ingredients',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SingleChildScrollView(
//                     physics: ScrollPhysics(),
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         IngredientItem(
//                           iconPath:
//                               'https://fastly.picsum.photos/id/731/200/300.jpg?hmac=Fx9GInoTSfdH0XzB-TGwIOkNAM6ULVS-SQbuWn9q8nY',
//                           title: 'Dough',
//                           subtitle: '1 Pet',
//                         ),
//                         IngredientItem(
//                           iconPath:
//                               'https://fastly.picsum.photos/id/731/200/300.jpg?hmac=Fx9GInoTSfdH0XzB-TGwIOkNAM6ULVS-SQbuWn9q8nY',
//                           title: 'Sauce',
//                           subtitle: '5 Seeds',
//                         ),
//                         IngredientItem(
//                           iconPath:
//                               'https://fastly.picsum.photos/id/731/200/300.jpg?hmac=Fx9GInoTSfdH0XzB-TGwIOkNAM6ULVS-SQbuWn9q8nY',
//                           title: 'Pepperoni',
//                           subtitle: '3 Seeds',
//                         ),
//                         IngredientItem(
//                           iconPath:
//                               'https://fastly.picsum.photos/id/731/200/300.jpg?hmac=Fx9GInoTSfdH0XzB-TGwIOkNAM6ULVS-SQbuWn9q8nY',
//                           title: 'Pepperoni',
//                           subtitle: '3 Seeds',
//                         ),
//                         IngredientItem(
//                           iconPath:
//                               'https://fastly.picsum.photos/id/731/200/300.jpg?hmac=Fx9GInoTSfdH0XzB-TGwIOkNAM6ULVS-SQbuWn9q8nY',
//                           title: 'Pepperoni',
//                           subtitle: '3 Seeds',
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Procedures',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ProcedureItem(
//                           iconPath:
//                               'https://fastly.picsum.photos/id/731/200/300.jpg?hmac=Fx9GInoTSfdH0XzB-TGwIOkNAM6ULVS-SQbuWn9q8nY',
//                           title: 'Cheese',
//                           subtitle: '1 pound',
//                         ),
//                         ProcedureItem(
//                           iconPath:
//                               'https://fastly.picsum.photos/id/731/200/300.jpg?hmac=Fx9GInoTSfdH0XzB-TGwIOkNAM6ULVS-SQbuWn9q8nY',
//                           title: 'Cheese',
//                           subtitle: '1 pound',
//                         ),
//                         ProcedureItem(
//                           iconPath:
//                               'https://fastly.picsum.photos/id/731/200/300.jpg?hmac=Fx9GInoTSfdH0XzB-TGwIOkNAM6ULVS-SQbuWn9q8nY',
//                           title: 'Cheese',
//                           subtitle: '1 pound',
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Container(
//                   //     height: 200,
//                   //     width: double.infinity,
//                   //     color: Colors.grey[300],
//                   //     child: Text('asd'))
//                 ],
//               ),
//             ),
//           ),
//           // Padding(
//           //   padding: const EdgeInsets.all(20.0),
//           //   child: ElevatedButton.icon(
//           //     onPressed: () {
//           //       // Handle action
//           //     },
//           //     style: ElevatedButton.styleFrom(
//           //       backgroundColor: Colors.green[600],
//           //       minimumSize: const Size(double.infinity, 52),
//           //       shape: RoundedRectangleBorder(
//           //         borderRadius: BorderRadius.circular(20),
//           //       ),
//           //     ),
//           //     icon: const Icon(Icons.play_circle_fill,
//           //         size: 20, color: Colors.white),
//           //     label: const Text(
//           //       'Watch Video',
//           //       style: TextStyle(
//           //           fontWeight: FontWeight.w500,
//           //           fontSize: 16,
//           //           color: Colors.white),
//           //     ),
//           //   ),
//           // )
//         ],
//       ),
//     );
//   }
// }
