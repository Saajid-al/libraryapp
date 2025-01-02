import 'package:flutter/material.dart';
import 'apiService.dart'; // Import your API service
import 'button.dart';
import 'editBookDialog.dart'; // Import your custom button widget

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService(); // Initialize API service
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> books = []; // Array to hold books
  bool isLoading = false; // Check if books are being loaded
  String errorMessage = ''; // Hold our error message

  // Fetch books from the API
  Future<void> fetchBooks() async {
    setState(() {
      isLoading = true; // Show loading indicator
      errorMessage = '';
    });

    try {
      final data = await apiService.listAllBooks(); // Call API to fetch books
      setState(() {
        books = data; // Update the book list
        isLoading = false; // Stop loading indicator
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching books: $e'; // Set error message
        isLoading = false; // Stop loading indicator
      });
    }
  }

  // Search books by title
  Future<void> searchBooks({required String criteria}) async {
    final keyword = _searchController.text.trim(); // Get the search keyword
    if (keyword.isEmpty) {
      setState(() {
        errorMessage = 'Search keyword is required.';
      });
      return;
    }

    setState(() {
      isLoading = true; // Show loading spinner
      errorMessage = '';
    });

    try {
      final data = await apiService.searchBooks(
          criteria, keyword); // Search by the given criteria
      setState(() {
        books = data; // Update the book list with search results
        isLoading = false; // Stop loading spinner
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // Show error message
        isLoading = false; // Stop loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        title: const Center(child: Text("Library Database")),
      ),
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // Search Bar with Search Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Books',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: customButtonOne(
                    buttonText: "By Title", // Search by Title button
                    onPressed: () {
                      searchBooks(
                          criteria: 'title'); // Call searchBooks with "title"
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: customButtonOne(
                    buttonText: "By Author", // Search by Author button
                    onPressed: () {
                      searchBooks(
                          criteria: 'author'); // Call searchBooks with "author"
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 40,
                  child: customButtonOne(
                    buttonText: "Add",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AddBookDialog(refreshBooks: fetchBooks),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: customButtonOne(
                    buttonText: "List",
                    onPressed: fetchBooks, // Fetch books when List is pressed
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Books Section
            if (isLoading)
              const Center(
                  child: CircularProgressIndicator()) // Show loading spinner
            else if (errorMessage.isNotEmpty)
              Center(child: Text(errorMessage)) // Show error message
            else if (books.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(book['title']), // Display book title
                        subtitle: Text(
                            "Author: ${book['author']}"), // Display book author
                        onTap: () async {
                          print(
                              'Book ID being passed: ${book['_id']}'); // Debug the book ID

                          try {
                            final bookDetails = await apiService.getBookDetails(
                                book['_id']); // Fetch book details
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                    bookDetails['title'] ?? 'Unknown Title'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Author: ${bookDetails['author'] ?? 'Unknown Author'}'),
                                    Text(
                                        'Publication Date: ${bookDetails['publicationDate'] ?? 'Unknown Date'}'),
                                    Text(
                                        'Quantity: ${bookDetails['quantity'] ?? 'Unknown Quantity'}'),
                                    Text('Book ID: ${bookDetails['_id']}'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                        context), // Close the dialog
                                    child: const Text('Close'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the current dialog
                                      showDialog(
                                        context: context,
                                        builder: (context) => EditBookDialog(
                                          bookDetails: bookDetails,
                                          refreshBooks: fetchBooks,
                                        ),
                                      );
                                    },
                                    child: const Text('Edit'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the current dialog
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            DeleteConfirmationDialog(
                                          bookId: bookDetails['_id'],
                                          refreshBooks: fetchBooks,
                                        ),
                                      );
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content:
                                    Text('Failed to load book details: $e'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                  child: Text("No books available")), // Show empty state
          ],
        ),
      ),
    );
  }
}

class AddBookDialog extends StatefulWidget {
  final Function refreshBooks;

  const AddBookDialog({Key? key, required this.refreshBooks}) : super(key: key);

  @override
  _AddBookDialogState createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> bookData = {
    'title': '',
    'author': '',
    'publicationDate': '',
    'quantity': '0',
  };
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Book'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => bookData['title'] = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Author'),
                onSaved: (value) => bookData['author'] = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Author is required'
                    : null,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Publication Date'),
                onSaved: (value) => bookData['publicationDate'] = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Date is required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onSaved: (value) => bookData['quantity'] = value ?? '0',
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                        ? 'Valid quantity is required'
                        : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close the popup
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isSubmitting
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      isSubmitting = true;
                    });

                    try {
                      await apiService.addBook({
                        'title': bookData['title']!,
                        'author': bookData['author']!,
                        'publicationDate': bookData['publicationDate']!,
                        'quantity': int.parse(bookData['quantity']!),
                      });
                      widget.refreshBooks(); // Refresh the book list
                      Navigator.pop(context); // Close the dialog
                    } catch (e) {
                      setState(() {
                        isSubmitting = false;
                      });
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: Text('Failed to add book: $e'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
          child: isSubmitting
              ? const CircularProgressIndicator()
              : const Text('Add Book'),
        ),
      ],
    );
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final String bookId;
  final Function refreshBooks;

  const DeleteConfirmationDialog({
    Key? key,
    required this.bookId,
    required this.refreshBooks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Book'),
      content: const Text('Are you sure you want to delete this book?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close the dialog
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final ApiService apiService = ApiService();
              await apiService.deleteBook(bookId); // Call the delete API
              refreshBooks(); // Refresh the book list
              Navigator.pop(context); // Close the dialog
            } catch (e) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text('Failed to delete book: $e'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
