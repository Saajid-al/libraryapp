import 'package:flutter/material.dart';
import 'apiService.dart';

class EditBookDialog extends StatefulWidget {
  final Map<String, dynamic> bookDetails;
  final Function refreshBooks;

  const EditBookDialog({
    Key? key,
    required this.bookDetails,
    required this.refreshBooks,
  }) : super(key: key);

  @override
  _EditBookDialogState createState() => _EditBookDialogState();
}

class _EditBookDialogState extends State<EditBookDialog> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  late Map<String, String> updatedBookData; // To hold updated book data
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    updatedBookData = {
      'title': widget.bookDetails['title'] ?? '',
      'author': widget.bookDetails['author'] ?? '',
      'publicationDate': widget.bookDetails['publicationDate'] ?? '',
      'quantity': widget.bookDetails['quantity']?.toString() ?? '0',
    };
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Book'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: updatedBookData['title'],
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => updatedBookData['title'] = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                initialValue: updatedBookData['author'],
                decoration: const InputDecoration(labelText: 'Author'),
                onSaved: (value) => updatedBookData['author'] = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Author is required'
                    : null,
              ),
              TextFormField(
                initialValue: updatedBookData['publicationDate'],
                decoration:
                    const InputDecoration(labelText: 'Publication Date'),
                onSaved: (value) =>
                    updatedBookData['publicationDate'] = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Date is required' : null,
              ),
              TextFormField(
                initialValue: updatedBookData['quantity'],
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onSaved: (value) => updatedBookData['quantity'] = value ?? '0',
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
          onPressed: () => Navigator.pop(context), // Close the dialog
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
                      await apiService.updateBook(
                        widget.bookDetails['_id'], // Book ID
                        {
                          'title': updatedBookData['title']!,
                          'author': updatedBookData['author']!,
                          'publicationDate':
                              updatedBookData['publicationDate']!,
                          'quantity': int.parse(updatedBookData['quantity']!),
                        },
                      );
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
                          content: Text('Failed to update book: $e'),
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
              : const Text('Save'),
        ),
      ],
    );
  }
}
