-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support

PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors

SELECT 
    c.class_id,
    c.name AS class_name,
    s.first_name || ' ' || s.last_name AS instructor_name
FROM 
    classes c
JOIN 
    class_schedule cs ON c.class_id = cs.class_id
JOIN 
    staff s ON cs.staff_id = s.staff_id;

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

SELECT 
    c.class_id,
    c.name,
    cs.start_time AS start_date,
    cs.end_time AS end_date,
    c.capacity - COUNT(ca.member_id) AS available_spots
FROM 
    classes c
JOIN 
    class_schedule cs ON c.class_id = cs.class_id
LEFT JOIN 
    class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE 
    cs.start_time BETWEEN '2025-02-01 00:00:00' AND '2025-02-28 23:59:59'
GROUP BY 
    c.class_id, c.name, cs.start_time, cs.end_time, c.capacity
HAVING 
    available_spots > 0;

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

INSERT INTO class_schedule (class_id, staff_id, start_time, end_time)
VALUES (3, 1, '2025-02-01 10:00:00', '2025-02-01 11:00:00');

INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
SELECT 
    cs.schedule_id, 11, 'Registered'
FROM 
    class_schedule cs
WHERE 
    cs.class_id = 3 AND DATE(cs.start_time) = '2025-02-01';

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

DELETE FROM class_attendance
WHERE schedule_id = 7 AND member_id = 2;

-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes

SELECT 
    c.class_id,
    c.name,
    COUNT(ca.member_id) AS registration_count
FROM 
    classes c
JOIN 
    class_schedule cs ON c.class_id = cs.class_id
JOIN 
    class_attendance ca ON cs.schedule_id = ca.schedule_id
GROUP BY 
    c.class_id, c.name
ORDER BY 
    registration_count DESC
LIMIT 5;

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member

SELECT 
    AVG(class_count) AS avg_classes_per_member
FROM (
    SELECT 
        member_id,
        COUNT(*) AS class_count
    FROM 
        class_attendance
    GROUP BY 
        member_id
) AS member_classes;

