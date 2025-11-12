/* Practice Questions */

/* 1. Extract the year from all patient arrival dates.*/
SELECT patient_id, EXTRACT(YEAR from arrival_date) AS arrival_year FROM patients;
/* 2. Calculate the length of stay for each patient (departure_date - arrival_date).*/
SELECT patient_id,name, departure_date-arrival_date AS stay FROM patients;
/* 3. Find all patients who arrived in a specific month.*/
SELECT 
    EXTRACT(MONTH FROM arrival_date) AS arrived_month,
    COUNT(*) AS total_patients
FROM patients
GROUP BY arrived_month
ORDER BY arrived_month;


/* Question: Calculate the average length of stay (in days) for each service, showing only
services where the average stay is more than 7 days. Also show the count of patients and order by average stay descending.*/
SELECT 
    service,
    COUNT(patient_id) AS total_patients,
    ROUND(AVG(departure_date - arrival_date), 2) AS avg_stay_days
FROM patients
GROUP BY service
HAVING AVG(departure_date - arrival_date) > 7
ORDER BY avg_stay_days DESC;
