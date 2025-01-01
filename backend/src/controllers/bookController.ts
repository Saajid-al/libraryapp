import exp from 'constants';
import { Request, Response } from 'express';

// Mock data for now, eventually, replace this with MongoDB
const mockBooks = [
    { id: '1', title: 'Harry Potter', author: 'J.K. Rowling', quantity: 5 },
    { id: '2', title: 'The Hobbit', author: 'J.R.R. Tolkien', quantity: 3 },
];

// Function to list all books
export const listAllBooks = (req: Request, res: Response) => {
    res.json({
        message: 'Books retrieved successfully!',
        books: mockBooks,
    });
};

// Function to add a new book
export const addBooks = (req: Request, res: Response) => {
    const { title, author, quantity } = req.body;

    // Create a new book object
    const newBook = {
        id: Date.now().toString(), // Temporary  ID
        title,
        author,
        quantity,
    };

    // Add the new book to the mockBooks array
    mockBooks.push(newBook);

    // Respond with the new book and success message
    res.status(201).json({
        message: 'Book added successfully!',
        book: newBook,
    });
};

export const searchBooks = (req: Request, res: Response): void => {
    // ensure we get a string
    const criteria = typeof req.query.criteria === 'string' ? req.query.criteria : undefined;
    const keyword = typeof req.query.keyword === 'string' ? req.query.keyword : undefined;

    // if we don't have criteria or a keyword
    if (!criteria || !keyword) {
        res.status(400).json({
            message: 'Book not found, please add search criteria and keyword',
        });
        return; // Exit the function
    }

    // Finding if we have a book or not
    const foundBooks = mockBooks.filter((book) => {
        if (criteria === 'title') return book.title.toLowerCase().includes(keyword.toLowerCase());
        if (criteria === 'author') return book.author.toLowerCase().includes(keyword.toLowerCase());
        return false;
    });

    // there are no books, return function
    if (foundBooks.length === 0) {
        res.status(404).json({
            message: 'No books with matching criteria',
        });
        return; // Exit the function
    }

    // If books exist
    res.json({
        message: 'Books found!',
        books: foundBooks,
    });
};
