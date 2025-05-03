import 'package:flutter/material.dart';
import 'package:recipe_book/components/food_card.dart';
import 'package:recipe_book/components/suggested_dish.dart';

class HomePage extends StatelessWidget {
  final categories = ['All', 'Breakfast', 'Lunch', 'Dinner'];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border), label: 'Save'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=3'), // Example image
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Welcome Back!', style: TextStyle(fontSize: 12)),
                      Text('Wilson Dias',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.search),
                  const SizedBox(width: 12),
                  Icon(Icons.notifications_outlined),
                ],
              ),
              const SizedBox(height: 24),

              // Categories
              const Text('Categories',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: categories
                    .map((cat) => Chip(
                          label: Text(cat),
                          backgroundColor:
                              cat == 'All' ? Colors.black : Colors.grey[200],
                          labelStyle: TextStyle(
                              color:
                                  cat == 'All' ? Colors.white : Colors.black),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Popular Now
              const Text('Popular Now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),

              FoodCard(
                imageUrl:
                    'https://fastly.picsum.photos/id/730/200/300.jpg?hmac=Xa_29B3ZIok8lz4JGLZUBU_ARxJew0twrMWMHEy_T1I',
                title: 'Pizza Palace',
              ),
              const SizedBox(height: 12),
              FoodCard(
                imageUrl:
                    'https://fastly.picsum.photos/id/730/200/300.jpg?hmac=Xa_29B3ZIok8lz4JGLZUBU_ARxJew0twrMWMHEy_T1I',
                title: 'Green Bowl',
              ),

              const SizedBox(height: 24),
              const Text('You May Also Like',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              // You can continue with a horizontal ListView or additional cards here

              const SizedBox(height: 24),

              SuggestedDish(
                imageUrl:
                    'https://fastly.picsum.photos/id/730/200/300.jpg?hmac=Xa_29B3ZIok8lz4JGLZUBU_ARxJew0twrMWMHEy_T1I',
                title: 'Spaghetti Carbonara Updated',
                rating: '4.5',
              ),
              Divider(),
              SuggestedDish(
                imageUrl:
                    'https://fastly.picsum.photos/id/730/200/300.jpg?hmac=Xa_29B3ZIok8lz4JGLZUBU_ARxJew0twrMWMHEy_T1I',
                title: 'Penne Arrabbiata',
                rating: '4.0',
              ),
              SuggestedDish(
                imageUrl:
                    'https://fastly.picsum.photos/id/730/200/300.jpg?hmac=Xa_29B3ZIok8lz4JGLZUBU_ARxJew0twrMWMHEy_T1I',
                title: 'Penne Arrabbiata',
                rating: '4.0',
              ),
              SuggestedDish(
                imageUrl:
                    'https://fastly.picsum.photos/id/730/200/300.jpg?hmac=Xa_29B3ZIok8lz4JGLZUBU_ARxJew0twrMWMHEy_T1I',
                title: 'Penne Arrabbiata',
                rating: '4.0',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
