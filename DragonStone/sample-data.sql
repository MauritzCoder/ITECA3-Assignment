USE ministore;

-- seed admin (password = admin123)
INSERT INTO users (name,email,password_hash,role)
VALUES ('Admin','admin@example.com',
        '$2y$10$h9PtHSBkOTo3caEvmjlJIud4yhIAnaiQHuppkNDWJxaYWZwoABoSm', -- bcrypt for 'admin123'
        'admin')
ON DUPLICATE KEY UPDATE email=email;

INSERT INTO products (name,price,img,description) VALUES
('Canvas Tote',199.00,'https://picsum.photos/seed/tote/320/200','Durable everyday tote.'),
('Water Bottle',149.00,'https://picsum.photos/seed/bottle/320/200','BPA-free stainless steel.'),
('Notebook',79.00,'https://picsum.photos/seed/note/320/200','Dotted A5 notebook.');
