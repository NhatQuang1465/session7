CREATE TABLE lesson1.book (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(100),
    genre VARCHAR(50),
    price DECIMAL(10,2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SELECT * FROM lesson1.book WHERE genre = 'Fantasy';
SELECT * FROM lesson1.book WHERE author ILIKE '%Rowling%';
EXPLAIN ANALYZE
SELECT * FROM lesson1.book WHERE genre = 'Fantasy';
CREATE INDEX idx_book_genre
ON lesson1.book(genre);

CREATE INDEX idx_book_description_gin
ON book
USING GIN(to_tsvector('english', description));
CLUSTER book USING idx_book_genre;