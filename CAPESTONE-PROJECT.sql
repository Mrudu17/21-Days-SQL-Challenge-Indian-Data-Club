/* 1. Identify where and when the crime happened */
SELECT 
    room,description,found_time
FROM evidence
WHERE room = 'CEO Office'
AND DATE(found_time)='2025-10-15'
ORDER BY found_time;
/* 2. Analyze who accessed critical areas at the time*/
SELECT 
    e.employee_id,
    e.name,
    k.room,
    k.entry_time,
    k.exit_time
FROM keycard_logs k
JOIN employees e 
    ON k.employee_id = e.employee_id
WHERE 
    k.entry_time BETWEEN '2025-10-15 20:45' AND '2025-10-15 21:05'
    OR
    k.exit_time BETWEEN '2025-10-15 20:45' AND '2025-10-15 21:05';

/* 3. Cross-check alibis with actual logs*/
SELECT 
    a.employee_id,
    e.name,
    a.claimed_location,
    a.claim_time,
    COALESCE(k.room, 'NO MATCH') AS actual_room
FROM alibis a
JOIN employees e 
    ON a.employee_id = e.employee_id
LEFT JOIN keycard_logs k
    ON k.employee_id = a.employee_id
   AND a.claim_time BETWEEN k.entry_time AND k.exit_time;


/* 4. Investigate suspicious calls made around the time*/
SELECT 
    c.call_id,
    c.call_time,
    c.duration_sec,
    caller.name AS caller_name,
    receiver.name AS receiver_name
FROM calls c
JOIN employees caller 
    ON c.caller_id = caller.employee_id
JOIN employees receiver 
    ON c.receiver_id = receiver.employee_id
WHERE c.call_time BETWEEN '2025-10-15 20:40' AND '2025-10-15 21:10'
ORDER BY c.call_time;

/* 5. Match evidence with movements and claims*/
SELECT 
    e.employee_id,
    e.name,
    e.department,
    e.role,
    k.room AS location_during_crime,
    k.entry_time,
    k.exit_time,
    a.claimed_location,
    a.claim_time,
    c.call_time,
    c.duration_sec,
    caller.name AS caller_name,
    receiver.name AS receiver_name
FROM employees e
LEFT JOIN keycard_logs k 
    ON k.employee_id = e.employee_id
    AND k.entry_time <= '2025-10-15 21:00'
    AND k.exit_time >= '2025-10-15 21:00'
LEFT JOIN alibis a 
    ON a.employee_id = e.employee_id
    AND a.claim_time BETWEEN '2025-10-15 20:50' AND '2025-10-15 21:00'
LEFT JOIN calls c 
    ON (c.caller_id = e.employee_id OR c.receiver_id = e.employee_id)
    AND c.call_time BETWEEN '2025-10-15 20:50' AND '2025-10-15 21:00'
LEFT JOIN employees caller 
    ON caller.employee_id = c.caller_id
LEFT JOIN employees receiver 
    ON receiver.employee_id = c.receiver_id
WHERE 
    a.claimed_location IS NOT NULL
    AND (k.room IS NULL OR a.claimed_location <> k.room);

/* 6. Combine all findings to identify the killer*/
WITH a AS (SELECT employee_id,claimed_location,claim_time FROM alibis),
k AS (SELECT employee_id,room,entry_time,exit_time FROM keycard_logs),
c AS (SELECT caller_id,receiver_id,call_time FROM calls),
evi AS (SELECT evidence_id,description,room,found_time FROM evidence),
sus AS (
SELECT DISTINCT
e.employee_id,e.name,a.claimed_location,a.claim_time,
k.room AS actual_location,k.entry_time,k.exit_time,
c.call_time,ev.description AS evidence_description,
ev.room AS evidence_room,ev.found_time
FROM employees e
JOIN a ON a.employee_id=e.employee_id
LEFT JOIN k ON k.employee_id=e.employee_id
LEFT JOIN c ON (c.caller_id=e.employee_id OR c.receiver_id=e.employee_id)
AND c.call_time BETWEEN '2025-10-15 20:50' AND '2025-10-15 21:10'
LEFT JOIN evi ev ON ev.room=k.room
)
SELECT *
FROM sus
WHERE actual_location='CEO Office'
AND entry_time<='2025-10-15 21:00'
AND exit_time>='2025-10-15 21:00'
ORDER BY employee_id;

/* FINAL CASE SOLVED QUERY */
--- The murder done by DAVID KUMAR and the evidences combined ---
WITH 
a AS (SELECT employee_id, claimed_location, claim_time FROM alibis), 
k AS (SELECT employee_id, room, entry_time, exit_time FROM keycard_logs), 
c AS (SELECT caller_id, receiver_id, call_time FROM calls), 
evi AS (SELECT room FROM evidence WHERE room = 'CEO Office' AND DATE(found_time) = '2025-10-15'), 
sus AS (
    SELECT DISTINCT 
        e.employee_id, 
        e.name, 
        k.room AS actual_location, 
        k.entry_time, 
        k.exit_time
    FROM employees e
    JOIN a ON a.employee_id = e.employee_id
    LEFT JOIN k ON k.employee_id = e.employee_id 
        AND k.entry_time <= '2025-10-15 21:00' 
        AND k.exit_time >= '2025-10-15 21:00'
    WHERE k.room = 'CEO Office'
)
SELECT DISTINCT name 
FROM sus
ORDER BY name;
