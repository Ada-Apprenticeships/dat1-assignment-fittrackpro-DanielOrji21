-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members

SELECT 
    member_id,
    first_name,
    last_name,
    email,
    phone_number,
    date_of_birth,
    join_date,
    emergency_contact_name,
    emergency_contact_phone
FROM 
    members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information

UPDATE members
SET email = 'emily.jones@email.com',
    phone_number = '555-9879'
WHERE member_id = 5;

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members

SELECT COUNT(*) AS total_members
FROM members;

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations

SELECT m.member_id, m.first_name, m.last_name, COUNT(c.class_attendance_id) AS registration_count
FROM members m
JOIN class_attendance c ON m.member_id = c.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count DESC
LIMIT 1;

-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations

SELECT m.member_id, m.first_name, m.last_name, COALESCE(COUNT(c.class_attendance_id), 0) AS registration_count
FROM members m
LEFT JOIN class_attendance c ON m.member_id = c.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count ASC
LIMIT 1;

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class

SELECT
  (SELECT COUNT(DISTINCT member_id) FROM class_attendance WHERE attendance_status = 'Attended') * 100.0 / 
  (SELECT COUNT(*) FROM members) AS percentage_attended;