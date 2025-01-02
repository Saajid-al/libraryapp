import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.2.36:3000/api';

  // Searching for books by criteria and keyword
  Future<List<dynamic>> searchBooks(String criteria, String keyword) async {
    final response = await http.get(
      Uri.parse('$baseUrl/books/search?criteria=$criteria&keyword=$keyword'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['books'];
    } else if (response.statusCode == 404) {
      throw Exception('No books found');
    } else {
      throw Exception('Failed to search for books');
    }
  }

  // Fetch all books
  Future<List<dynamic>> listAllBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['books'];
    } else {
      throw Exception('Failed to load any books');
    }
  }

  // Add a new book
  Future<void> addBook(Map<String, dynamic> bookData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/books'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bookData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add book');
    }
  }

  Future<Map<String, dynamic>> getBookDetails(String bookId) async {
    final url = '$baseUrl/books/$bookId';
    print('Making API call to: $url'); // Debug the API URL

    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}'); // Debug response status
    print('Response body: ${response.body}'); // Debug response body

    if (response.statusCode == 200) {
      final book = jsonDecode(response.body)['book'];
      print('Parsed book details: $book'); // Debug parsed book details
      return book;
    } else if (response.statusCode == 404) {
      throw Exception('Book not found.');
    } else {
      throw Exception('Failed to fetch book details.');
    }
  }

  Future<void> updateBook(
      String bookId, Map<String, dynamic> updatedData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/books/$bookId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update book.');
    }
  }

  Future<void> deleteBook(String bookId) async {
    final response = await http.delete(Uri.parse('$baseUrl/books/$bookId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete book.');
    }
  }
}
