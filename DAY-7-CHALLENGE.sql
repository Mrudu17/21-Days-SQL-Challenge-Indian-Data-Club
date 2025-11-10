/*Practice Question */

/* 1. Find services that have admitted more than 500 patients in total.*/
SELECT service,count(*) FROM patients GROUP BY service HAVING Count(patients)>100;
/* 2. Show services where average patient satisfaction is below 75.*/
SELECT service,AVG(satisfaction) FROM patients GROUP BY service HAVING AVG(satisfaction) < 75;
/* 3. List weeks where total staff presence across all services was less than 50.*/
SELECT week,SUM(present)as staff_present FROM staff_schedule GROUP BY week HAVING SUM(present)<50;

/* Question: Identify services that refused more than 100 patients in total and had an average patient satisfaction below 80. 
Show service name, total refused, and average satisfaction.*/
SELECT 
    service,
    SUM(patients_refused) AS total_refused,
    ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction
FROM 
    services_weekly
GROUP BY 
    service
HAVING 
    SUM(patients_refused) > 100
    AND AVG(patient_satisfaction) < 80;
