import express from 'express';
import mongoose from 'mongoose';
import bookRoutes from './routes/bookRoutes';
import cors from 'cors';

const app = express();
const port = 3000;
//MongoDB connection
const mongoURI = 'mongodb://127.0.0.1:27017/LibraryDB'; // using local connection
mongoose.connect(mongoURI)
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('MongoDB connection error:', err));

app.use(cors());
app.use(express.json());
app.use('/api', bookRoutes)

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
