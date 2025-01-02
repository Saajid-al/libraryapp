import 'package:flutter/material.dart';
import 'views/homePage/apiService.dart';

class BookListTest extends StatefulWidget {
  @override
  _BookListTestState createState() => _BookListTestState();
}

class _BookListTestState extends State<BookListTest> {
  final ApiService apiService = ApiService();
  List<dynamic> books = [];
  bool isLoading = true; // use this to test our fture
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBooks(); // we want to fetch our book while its loading
  }

  Future<void> fetchBooks() async {
    try {
      final data =
          await apiService.listAllBooks(); // Call the listAllBooks method
      setState(() {
        books = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching books: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book List Test')),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage)) // Show error message
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return ListTile(
                      title: Text(book['title']),
                      subtitle: Text('Author: ${book['author']}'),
                    );
                  },
                ),
    );
  }
}
