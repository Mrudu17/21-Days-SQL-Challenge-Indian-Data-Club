/* Practice Questions*/

/* 1. Find patients who are in services with above-average staff count.*/
SELECT p.patient_id, p.name, p.service 
FROM patients p 
JOIN (SELECT service FROM staff GROUP BY service HAVING COUNT(*) > (SELECT AVG(staff_count) 
FROM (SELECT COUNT(*) AS staff_count FROM staff GROUP BY service) t)) x 
ON p.service = x.service;

/* 2. List staff who work in services that had any week with patient satisfaction below 70.*/
SELECT DISTINCT s.staff_id, s.staff_name, s.service 
FROM staff s 
JOIN services_weekly sw ON s.service = sw.service 
WHERE sw.patient_satisfaction < 70;

/* 3. Show patients from services where total admitted patients exceed 1000.*/
SELECT p.patient_id, p.name, p.service 
FROM patients p 
JOIN (SELECT service FROM services_weekly GROUP BY service HAVING SUM(patients_admitted) > 1000) x 
ON p.service = x.service


/* Question:** Find all patients who were admitted to services that had at least one week where patients were refused 
AND the average patient satisfaction for that service was below the overall hospital average satisfaction. 
Show patient_id, name, service, and their personal satisfaction score.*/
SELECT 
    p.patient_id,
    p.name,
    p.service,
    p.satisfaction
FROM patients p
WHERE p.service IN (
    SELECT sw.service
    FROM services_weekly sw
    WHERE sw.patients_refused > 0
    GROUP BY sw.service
    HAVING AVG(sw.patient_satisfaction) < (
        SELECT AVG(patient_satisfaction)
        FROM services_weekly
    )
);












