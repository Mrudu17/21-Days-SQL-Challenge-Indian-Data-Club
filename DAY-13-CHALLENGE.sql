/* Practice Questions:*/

/* 1. Join patients and staff based on their common service field (show patient and staff who work in same service).*/
SELECT p.patient_id,
    p.name AS patient_name,
    p.service,
    s.staff_name
    FROM patients p
INNER JOIN staff s ON p.service = s.service
ORDER BY p.service, p.name;

/* 2. Join services_weekly with staff to show weekly service data with staff information.*/
SELECT st.staff_id, st.staff_name,st.role,st.service, se.week
FROM staff st
INNER JOIN services_weekly se ON se.service = st.service;

/* 3. Create a report showing patient information along with staff assigned to their service.*/
SELECT p.patient_id,
    p.name AS patient_name,
    p.service,
	s.staff_id,
    s.staff_name,
	s.role
    FROM patients p
INNER JOIN staff s ON p.service = s.service
ORDER BY p.service, p.name;

/* DAILY CHALLENGE */

/* Question: Create a comprehensive report showing patient_id, patient name, age, service, 
and the total number of staff members available in their service. Only include patients from services 
that have more than 5 staff members. Order by number of staff descending, then by patient name.*/
SELECT 
    p.patient_id,p.name,p.age,p.service,COUNT(s.staff_id) AS total_staff
FROM patients p
INNER JOIN staff s 
    ON p.service = s.service
GROUP BY 
    p.patient_id,p.name,p.age,p.service
HAVING 
    COUNT(s.staff_id) > 5
ORDER BY 
    total_staff DESC,p.name;
