import { Router } from 'express';
import { listAllBooks, addBooks, searchBooks } from '../controllers/bookController';

const router = Router();

// Here is where we can call the router to list all of our books
//list all our books
router.get('/books', listAllBooks);
//add our new books
router.post('/books', addBooks);
//search for our books
router.get('/books/search', searchBooks);

export default router;
