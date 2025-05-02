import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.asset(
                  'assets/images/pizza.jpg',
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Positioned(
                top: 40,
                right: 16,
                child: Icon(Icons.bookmark_border, color: Colors.white),
              ),
              const Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  'Recipe Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Pizza Palace',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.yellow[700],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              '5.0',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      const Text('20 mins'),
                      const SizedBox(width: 16),
                      const Icon(Icons.local_fire_department, size: 16),
                      const SizedBox(width: 4),
                      const Text('Medium'),
                      const SizedBox(width: 16),
                      const Icon(Icons.whatshot, size: 16),
                      const SizedBox(width: 4),
                      const Text('100 Cal'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: AssetImage('assets/images/user.jpg'),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Kadin Curtis',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      IngredientItem(
                        iconPath: 'assets/images/p1.webp',
                        title: 'Dough',
                        subtitle: '1 Pet',
                      ),
                      IngredientItem(
                        iconPath: 'assets/images/p2.webp',
                        title: 'Sauce',
                        subtitle: '5 Seeds',
                      ),
                      IngredientItem(
                        iconPath: 'assets/images/p3.webp',
                        title: 'Pepperoni',
                        subtitle: '3 Seeds',
                      ),
                      IngredientItem(
                        iconPath: 'assets/images/p4.webp',
                        title: 'Cheese',
                        subtitle: 'Enough',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Handcrafted pizzas made with the freshest ingredients and baked to perfection. From classic Margherita to bold gourmet flavors, we serve a variety of mouthwatering options.',
                    style: TextStyle(
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.play_circle_fill),
              label: const Text(
                'Watch Videos',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class IngredientItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;

  const IngredientItem({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFF2F2F2),
          child: Image.asset(
            iconPath,
            width: 32,
            height: 32,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
