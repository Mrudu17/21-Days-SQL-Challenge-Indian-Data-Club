/* Daily Challenge */

/* Question: For each service, rank the weeks by patient satisfaction score (highest first).
Show service, week, patient_satisfaction, patients_admitted, and the rank. Include only the top 3 weeks per service. */
SELECT 
    service,
    week,
    patient_satisfaction,
    patients_admitted,
    rnk
FROM (
    SELECT 
        service,
        week,
        patient_satisfaction,
        patients_admitted,
        RANK() OVER (
            PARTITION BY service
            ORDER BY patient_satisfaction DESC
        ) AS rnk
    FROM services_weekly
) t
WHERE rnk <= 3
ORDER BY service, rnk, week;
