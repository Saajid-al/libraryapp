import { Request, Response } from 'express';
import { Book } from '../models/Book'; // Import the Mongoose model
import { error } from 'console';

// Mock data for now, eventually, replace this with MongoDB -- We replaced it with MONGODB. 
//Commented out code is for testing purposes in near future
/*
const mockBooks = [
    { id: '1', title: 'Harry Potter', author: 'J.K. Rowling', publicationDate: '1997-06-26', quantity: 5 },
    { id: '2', title: 'The Hobbit', author: 'J.R.R. Tolkien', publicationDate: '2001-02-26', quantity: 3 },
];
*/

// Function to list all books
export const listAllBooks = async (req: Request, res: Response) => {

    try {
        const books = await Book.find();
        res.json({
            message: 'Books retrieved successfully!',
            books,
        });
    } catch (err) { 
        const error = err as Error;
        res.status(500).json({
            error: "Failed to retrieve any books",
            details: error.message
        })
    }



    /*
    res.json({
        message: 'Books retrieved successfully!',
        books: mockBooks,
    });
    */
};

export const addBooks = async (req: Request, res: Response) => {
    try {
        const { title, author, publicationDate, quantity } = req.body;

        // Create a new book instance using the Mongoose model
        const newBook = new Book({
            title,
            author,
            publicationDate,
            quantity,
        });

        // Saving book to database
        const savedBook = await newBook.save();

        // book is saved successfully
        res.status(201).json({
            message: 'Book added successfully!',
            book: savedBook,
        });
    } catch (err) {
        const error = err as Error; 
        res.status(500).json({
            error: 'Failed to add book',
            details: error.message,
        });
    }
};


// Other functions remain unchanged for now

export const searchBooks = async (req: Request, res: Response): Promise<void> => {
  try {
    // Extract criteria and keyword from query parameters
    const criteria = req.query.criteria as string;
    const keyword = req.query.keyword as string;

    // Validate input
    if (!criteria || !keyword) {
      res.status(400).json({
        message: 'Missing search criteria or keyword',
      });
      return;
    }

    // Validate criteria
    if (!['title', 'author'].includes(criteria)) {
      res.status(400).json({
        message: 'Invalid search criteria. Use "title" or "author".',
      });
      return;
    }

    // Build query based on criteria
    const query: { [key: string]: string } = {};
    query[criteria] = keyword;

    // Search for books matching the criteria
    const books = await Book.find(query);

    // If no books are found, return a 404 status
    if (books.length === 0) {
      res.status(404).json({
        message: `No books found matching ${criteria}: "${keyword}"`,
      });
      return;
    }

    // Return the list of books
    res.json({
      message: `Books matching ${criteria}: "${keyword}" retrieved successfully!`,
      books,
    });
  } catch (err) {
    const error = err as Error;
    res.status(500).json({
      error: 'Failed to search for books',
      details: error.message,
    });
  }
};


export const bookId = async (req: Request, res: Response): Promise<void> => {
    try {
      // Extract the book ID from request parameters
      const { bookId } = req.params;
  
      // Validate that bookId is provided
      if (!bookId) {
        res.status(400).json({
          message: 'Book ID is required.',
        });
        return;
      }
  
      // Search for the book in the database by ID
      const book = await Book.findById(bookId);
  
      // If the book is not found, return a 404 status
      if (!book) {
        res.status(404).json({
          message: `Book with ID ${bookId} not found.`,
        });
        return;
      }
  
      // If the book is found, return its details
      res.json({
        message: 'Book details retrieved successfully.',
        book,
      });
    } catch (err) {
      const error = err as Error;
      res.status(500).json({
        message: 'Failed to retrieve book details.',
        error: error.message,
      });
    }
  };
  

  export const editBook = async (req: Request, res: Response): Promise<void> => {
    try {
      const { bookId } = req.params; // Extract book ID from request parameters
      const { title, author, publicationDate, quantity } = req.body; // Extract updated fields from request body
  
      // Validate bookId
      if (!bookId) {
        res.status(400).json({ message: 'Book ID is required.' });
        return;
      }
  
      // Validate input
      if (!title && !author && !publicationDate && !quantity) {
        res.status(400).json({ message: 'No fields provided for update.' });
        return;
      }
  
      // Update the book in the database
      const updatedBook = await Book.findByIdAndUpdate(
        bookId,
        { title, author, publicationDate, quantity },
        { new: true } // Return the updated document
      );
  
      // If book is not found, return an error
      if (!updatedBook) {
        res.status(404).json({ message: `Book with ID ${bookId} not found.` });
        return;
      }
  
      // Respond with the updated book
      res.json({
        message: 'Book updated successfully.',
        book: updatedBook,
      });
    } catch (err) {
      const error = err as Error;
      res.status(500).json({
        message: 'Failed to update book.',
        error: error.message,
      });
    }

    /*
    const { bookId } = req.params;
    const { title, author, publicationDate, quantity } = req.body;

    const book = mockBooks.find((b) => b.id === bookId);

    if (!book) {
        res.status(404).json({
            message: `Book with ID ${bookId} not found.`,
        });
        return;
    }

    if (title) book.title = title;
    if (author) book.author = author;
    if (publicationDate) book.publicationDate = publicationDate;
    if (quantity !== undefined) book.quantity = quantity;

    res.json({
        message: 'Book has been updated!',
        book,
    });
    */
};

export const deleteBook = async (req: Request, res: Response): Promise<void> => {
  try {
    const { bookId } = req.params; // Extract book ID from request parameters

    // Validate that bookId is provided
    if (!bookId) {
      res.status(400).json({
        message: 'Book ID is required.',
      });
      return;
    }

    // Attempt to delete the book by ID
    const deletedBook = await Book.findByIdAndDelete(bookId);

    // If no book is found, return a 404 error
    if (!deletedBook) {
      res.status(404).json({
        message: `Book with ID ${bookId} not found.`,
      });
      return;
    }

    // Respond with success message
    res.json({
      message: 'Book deleted successfully.',
      book: deletedBook, // Optionally return the deleted book details
    });
  } catch (err) {
    const error = err as Error;
    res.status(500).json({
      message: 'Failed to delete book.',
      error: error.message,
    });
  }
};


