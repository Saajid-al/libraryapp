import { Router } from 'express';
import { listAllBooks, addBooks, searchBooks, bookId, editBook,deleteBook } from '../controllers/bookController';

const router = Router();

// Here is where we can call the router to list all of our books
//list all our books
router.get('/books', listAllBooks);
//add our new books
router.post('/books', addBooks);
//search for our books
router.get('/books/search', searchBooks);
//getting book with book ID
router.get('/books/:bookId', bookId);
//editing our book, that exists with ID
router.put('/books/:bookId', editBook);
//delete our book, that exists with ID
router.delete('/books/:bookId', deleteBook)

export default router;
