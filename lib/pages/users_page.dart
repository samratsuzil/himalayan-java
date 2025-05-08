import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipe_book/components/user_card.dart';
import 'package:recipe_book/components/skeletons/user_card_skeleton.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/pages/recipes_page.dart';
import 'package:recipe_book/services/user_service.dart';
import 'package:recipe_book/widgets/user_search_delegate.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  UsersPageState createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage> {
  List<User> authors = [];
  bool isAuthorsLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchAuthors();
  }

  Future<void> fetchAuthors({String? searchQuery}) async {
    setState(() => isAuthorsLoading = true);
    try {
      final fetchedUsers =
          await UserService.fetchUsers(searchQuery: searchQuery);

      setState(() {
        authors = fetchedUsers;
      });
    } catch (e) {
      log('Error fetching authors: $e');
    } finally {
      setState(() => isAuthorsLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chefs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch<String>(
                context: context,
                delegate: AuthorSearchDelegate(),
              );
              if (result != null && result.isNotEmpty) {
                setState(() {
                  searchQuery = result;
                });
                fetchAuthors(
                  searchQuery: searchQuery,
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Filters',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: 8),
                        if (searchQuery.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text("Search: $searchQuery"),
                              deleteIcon: const Icon(Icons.cancel, size: 20),
                              onDeleted: () {
                                setState(() {
                                  searchQuery = '';
                                });
                                fetchAuthors();
                              },
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: RefreshIndicator(
                  onRefresh: () => fetchAuthors(
                    searchQuery: searchQuery,
                  ),
                  child: isAuthorsLoading
                      ? GridView.builder(
                          itemCount: 120,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? 1
                                    : 2,
                            childAspectRatio: 5 / 1,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (_, __) => const UserCardSkeleton(),
                        )
                      : authors.isEmpty
                          ? Text("No authors found. Try another search.")
                          : GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: authors.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).orientation ==
                                            Orientation.portrait
                                        ? 1
                                        : 2,
                                childAspectRatio: 5 / 1,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) {
                                final author = authors[index];
                                return UserCard(
                                  user: author,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => RecipesPage(
                                                authorId: author.id,
                                              ))),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
