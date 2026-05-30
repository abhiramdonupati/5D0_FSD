create database 5D0_cognizant;
use 5D0_cognizant;

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL
);

-- 2. Events table
CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    city VARCHAR(100) NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    status ENUM('upcoming','completed','cancelled'),
    organizer_id INT,
    FOREIGN KEY (organizer_id) REFERENCES Users(user_id)
);

-- 3. Sessions table
CREATE TABLE Sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    title VARCHAR(200) NOT NULL,
    speaker_name VARCHAR(100) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- 4. Registrations table
CREATE TABLE Registrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    registration_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- 5. Feedback table
CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- 6. Resources table
CREATE TABLE Resources (
    resource_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    resource_type ENUM('pdf','image','link'),
    resource_url VARCHAR(255) NOT NULL,
    uploaded_at DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);






-- 1. Users
INSERT INTO Users (user_id, full_name, email, city, registration_date) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'New York', '2024-12-01'),
(2, 'Bob Smith', 'bob@example.com', 'Los Angeles', '2024-12-05'),
(3, 'Charlie Lee', 'charlie@example.com', 'Chicago', '2024-12-10'),
(4, 'Diana King', 'diana@example.com', 'New York', '2025-01-15'),
(5, 'Ethan Hunt', 'ethan@example.com', 'Los Angeles', '2025-02-01');

-- 2. Events
INSERT INTO Events (event_id, title, description, city, start_date, end_date, status, organizer_id) VALUES
(1, 'Tech Innovators Meetup', 'A meetup for tech enthusiasts.', 'New York', '2025-06-10 10:00:00', '2025-06-10 16:00:00', 'upcoming', 1),
(2, 'AI & ML Conference', 'Conference on AI and ML advancements.', 'Chicago', '2025-05-15 09:00:00', '2025-05-15 17:00:00', 'completed', 3),
(3, 'Frontend Development Bootcamp', 'Hands-on training on frontend tech.', 'Los Angeles', '2025-07-01 10:00:00', '2025-07-03 16:00:00', 'upcoming', 2);

-- 3. Sessions
INSERT INTO Sessions (session_id, event_id, title, speaker_name, start_time, end_time) VALUES
(1, 1, 'Opening Keynote', 'Dr. Tech', '2025-06-10 10:00:00', '2025-06-10 11:00:00'),
(2, 1, 'Future of Web Dev', 'Alice Johnson', '2025-06-10 11:15:00', '2025-06-10 12:30:00'),
(3, 2, 'AI in Healthcare', 'Charlie Lee', '2025-05-15 09:30:00', '2025-05-15 11:00:00'),
(4, 3, 'Intro to HTML5', 'Bob Smith', '2025-07-01 10:00:00', '2025-07-01 12:00:00');

-- 4. Registrations
INSERT INTO Registrations (registration_id, user_id, event_id, registration_date) VALUES
(1, 1, 1, '2025-05-01'),
(2, 2, 1, '2025-05-02'),
(3, 3, 2, '2025-04-30'),
(4, 4, 2, '2025-04-28'),
(5, 5, 3, '2025-06-15');

-- 5. Feedback
INSERT INTO Feedback (feedback_id, user_id, event_id, rating, comments, feedback_date) VALUES
(1, 3, 2, 4, 'Great insights!', '2025-05-16'),
(2, 4, 2, 5, 'Very informative.', '2025-05-16'),
(3, 2, 1, 3, 'Could be better.', '2025-06-11');

-- 6. Resources
INSERT INTO Resources (resource_id, event_id, resource_type, resource_url, uploaded_at) VALUES
(1, 1, 'pdf', 'https://portal.com/resources/tech_meetup_agenda.pdf', '2025-05-01 10:00:00'),
(2, 2, 'image', 'https://portal.com/resources/ai_poster.jpg', '2025-04-20 09:00:00'),
(3, 3, 'link', 'https://portal.com/resources/html5_docs', '2025-06-25 15:00:00');



SELECT * FROM users AS u,events AS e,registrations AS r WHERE (u.user_id=r.user_id AND e.event_id=r.event_id)
AND u.city=e.city AND e.status='upcoming' ORDER BY r.registration_date;

SELECT 
    event_id,
    AVG(rating) AS average_rating,
    COUNT(*) AS total_feedbacks
FROM Feedback 
GROUP BY event_id
HAVING COUNT(*) >= 10
ORDER BY average_rating DESC limit 1;

SELECT * FROM Users u WHERE NOT EXISTS (
    SELECT 1
    FROM Registrations r
    WHERE r.user_id = u.user_id
      AND r.registration_date >= CURDATE() - INTERVAL 90 DAY
);

SELECT COUNT(s.session_id) AS session_count FROM Events e
JOIN Sessions s ON e.event_id = s.event_id WHERE TIME(e.start_date) = '10:00:00' AND TIME(e.end_date) = '12:00:00';

SELECT u.city,COUNT(DISTINCT r.user_id) AS total_registered_users FROM Users u JOIN Registrations r
ON u.user_id = r.user_id GROUP BY u.city ORDER BY total_registered_users DESC LIMIT 5;

SELECT COUNT(e.event_id) AS Total_resources FROM Events e JOIN Resources r ON e.event_id=r.event_id GROUP BY e.event_id,r.resource_type ORDER BY
e.event_id,r.resource_type;

SELECT u.full_name,e.title,f.comments FROM Users u JOIN Events e JOIN Feedback f WHERE u.city=e.city AND e.event_id=f.event_id
and f.rating <3;

SELECT e.title,e.status,COUNT(s.session_id) as Count_Sessions FROM Events e JOIN Sessions s
WHERE e.event_id=s.event_id  AND e.status='Upcoming' GROUP BY e.event_id;

SELECT e.organizer_id,COUNT(e.event_id) AS NO_OF_Events,e.status FROM Events e GROUP BY e.event_id;

SELECT e.event_id,e.title FROM Events e JOIN Registrations r ON e.event_id = r.event_id  LEFT JOIN Feedback f
ON e.event_id = f.event_id WHERE f.event_id IS NULL GROUP BY e.event_id, e.title;

SELECT registration_date,COUNT(DISTINCT user_id) AS total_users FROM Registrations 
WHERE registration_date >= CURDATE() - INTERVAL 7 DAY GROUP BY registration_date 
ORDER BY registration_date;