-- Mpepo Kitchen POS Database Schema
-- Created for CCS3142 Mobile Application Development Assignment

-- Products Table
CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    price REAL NOT NULL,
    image_url TEXT,
    category TEXT DEFAULT 'General',
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed Data
INSERT INTO products (name, description, price, category) VALUES
('Chicken Burger', 'Juicy grilled chicken with fresh veggies', 12.99, 'Burgers'),
('Vegetable Pizza', 'Fresh vegetable pizza with mozzarella cheese', 15.99, 'Pizza'), 
('French Fries', 'Crispy golden fries with seasoning', 5.99, 'Sides'),
('Caesar Salad', 'Fresh salad with Caesar dressing', 8.99, 'Salads');

-- Transactions Table (for future use)
CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    receipt_number TEXT UNIQUE NOT NULL,
    total_amount REAL NOT NULL,
    tax_amount REAL NOT NULL,
    discount_amount REAL DEFAULT 0,
    payment_method TEXT DEFAULT 'Cash',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transaction Items Table
CREATE TABLE IF NOT EXISTS transaction_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaction_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES transactions (id),
    FOREIGN KEY (product_id) REFERENCES products (id)
);