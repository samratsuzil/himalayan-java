import 'package:flutter/material.dart';

class RecipeSearchDelegate extends SearchDelegate<String> {
  RecipeSearchDelegate();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close the search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Close search and return the query when Enter is pressed
    // Delay calling setState to avoid the error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      close(context, query); // Close the search and pass the query
    });
    return Container(); // You can show a loading spinner or results here if needed
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions as user types (search query here)
    return ListView(
      children: [
        ListTile(
          title: Text('Search for "$query"'),
          onTap: () {
            // Close search and return the selected suggestion
            close(context, query);
          },
        ),
      ],
    );
  }
}
