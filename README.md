# Library Management System

A full-stack library management application built with Node.js, TypeScript, MongoDB, and Flutter. This system allows librarians to manage their book collection efficiently through a web application.

## Features

### Backend (Node.js + TypeScript)
- Complete CRUD operations for book management
- RESTful API endpoints for all operations
- MongoDB integration with optimized queries using indexes
- Type-safe implementation using TypeScript

### Frontend (Flutter)
- Book listing with search functionality
- Detailed book view
- Book management interface for librarians
- Cross-platform compatibility

## Tech Stack

- **Backend**:
  - Node.js
  - TypeScript
  - MongoDB
  - Express.js

- **Frontend**:
  - Flutter
  - HTTP package for API integration
  - State management solution

## API Endpoints

### Create Operations
- `POST /books` - Add a new book
  ```json
  {
    "title": "Harry Potter",
    "author": "J.K. Rowling",
    "publicationDate": "1997-06-26",
    "quantity": 5
  }
  ```

### Read Operations
- `GET /books` - List all books
- `GET /books/search?criteria=title&keyword=Harry Potter` - Search books by criteria
- `GET /books/{bookId}` - Get specific book details

### Update Operations
- `PUT /books/{bookId}` - Update book details
  ```json
  {
    "title": "Harry Potter and the Chamber of Secrets",
    "author": "J.K. Rowling",
    "publicationDate": "1998-07-02",
    "quantity": 10
  }
  ```

### Delete Operations
- `DELETE /books/{bookId}` - Remove a book

## Getting Started

### Prerequisites
- Node.js
- MongoDB
- Flutter SDK
- TypeScript

### Backend Setup
1. Clone the repository
2. Navigate to the backend directory:
   ```bash
   cd backend
   ```
3. Install dependencies:
   ```bash
   npm install
   ```
4. Create a `.env` file with your MongoDB connection string:
   ```
   MONGODB_URI=your_mongodb_connection_string
   PORT=3000
   ```
5. Start the development server:
   ```bash
   npm run dev
   ```

### Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Update the API base URL in the configuration file
4. Run the application:
   ```bash
   flutter run
   ```


```

## Database Schema

### Book Collection
```typescript
interface Book {
  _id: ObjectId;
  title: string;
  author: string;
  publicationDate: Date;
  quantity: number;
  createdAt: Date;
  updatedAt: Date;
}
```

