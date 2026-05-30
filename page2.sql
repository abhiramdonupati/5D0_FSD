SELECT e.event_id, e.title, COUNT(s.session_id) AS session_count FROM Events e
JOIN Sessions s ON e.event_id = s.event_id GROUP BY e.event_id, e.title ORDER BY session_count DESC LIMIT 1;

SELECT e.city, AVG(f.rating) AS average_rating FROM Events e JOIN Feedback f
ON e.event_id = f.event_id GROUP BY e.city;

SELECT e.event_id,e.title,COUNT(r.registration_id) AS total_registrations FROM Events e JOIN Registrations r
ON e.event_id = r.event_id GROUP BY e.event_id, e.title ORDER BY total_registrations DESC LIMIT 3;

SELECT s1.event_id, s1.session_id, s2.session_id FROM Sessions s1, Sessions s2
WHERE s1.event_id = s2.event_id AND s1.session_id < s2.session_id AND s1.end_time > s2.start_time;

SELECT u.user_id, u.full_name, u.email FROM Users u JOIN Registrations r
ON u.user_id = r.user_id WHERE u.registration_date >= CURDATE() - INTERVAL 30 DAY AND r.user_id IS NULL;

SELECT speaker_name, COUNT(*) AS total_sessions FROM Sessions GROUP BY speaker_name HAVING COUNT(*) > 1;

SELECT e.event_id, e.title FROM Events e JOIN Resources r ON e.event_id = r.event_id WHERE r.resource_id IS NULL;

SELECT e.event_id, e.title, COUNT(DISTINCT r.registration_id) AS total_registrations,AVG(f.rating) AS average_rating
FROM Events e JOIN Registrations r JOIN Feedback f ON  e.event_id = r.event_id AND e.event_id = f.event_id
WHERE e.status = 'completed' GROUP BY e.event_id, e.title;

SELECT u.user_id,u.full_name,COUNT(DISTINCT r.event_id) AS events_attended, COUNT(DISTINCT f.feedback_id) AS feedbacks_submitted
FROM Users u  LEFT JOIN Registrations r ON u.user_id = r.user_id   LEFT JOIN Feedback f ON u.user_id = f.user_id
GROUP BY u.user_id, u.full_name;

SELECT u.full_name , COUNT(f.feedback_id) FROM Users u JOIN Feedback f ON u.user_id=f.user_id GROUP BY u.user_id  ORDER BY u.user_id DESC LIMIT 5;

SELECT user_id,event_id,COUNT(*) AS registration_count FROM Registrations GROUP BY user_id, event_id HAVING COUNT(*) > 1;

SELECT DATE_FORMAT(registration_date, '%Y-%m') AS month,COUNT(*) AS registration_count FROM Registrations
WHERE registration_date >= CURDATE() - INTERVAL 12 MONTH GROUP BY DATE_FORMAT(registration_date, '%Y-%m')
ORDER BY month;

SELECT event_id,ROUND(AVG(TIMESTAMPDIFF(MINUTE, start_time, end_time)), 2) AS avg_duration_minutes FROM Sessions
GROUP BY event_id;

SELECT e.event_id,e.title FROM Events e JOIN Sessions s ON e.event_id = s.event_id WHERE s.session_id IS NULL;