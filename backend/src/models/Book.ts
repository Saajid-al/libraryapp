import mongoose, { Schema, Document } from 'mongoose';

// Book interface
export interface IBook extends Document {
    title: string;
    author: string;
    publicationDate: string;
    quantity: number;
}

// Book schema
const BookSchema: Schema = new Schema({
    title: { type: String, required: true },
    author: { type: String, required: true },
    publicationDate: { type: String, required: true },
    quantity: { type: Number, required: true },
    },
    { collection: 'books' }
);

export const Book = mongoose.model<IBook>('Book', BookSchema);
