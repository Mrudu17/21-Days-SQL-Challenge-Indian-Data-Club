/*Question: Create a comprehensive hospital performance dashboard using CTEs. Calculate: 
1) Service-level metrics (total admissions, refusals, avg satisfaction), 
2) Staff metrics per service (total staff, avg weeks present), 
3) Patient demographics per service (avg age, count). 
Then combine all three CTEs to create a final report showing service name, all calculated metrics,
and an overall performance score (weighted average of admission rate and satisfaction). Order by performance score descending.*/

WITH 
service_metrics AS (
    SELECT s.service,
        SUM(s.patients_admitted) AS total_admissions,
        SUM(s.patients_refused) AS total_refusals,
        ROUND(AVG(p.satisfaction),2) AS avg_satisfaction FROM services_weekly s, patients p
    GROUP BY s.service),
staff_metrics AS (
    SELECT st.service,
        COUNT(DISTINCT st.staff_id) AS total_staff,
        ROUND(AVG(sw.week),2) AS avg_weeks_present FROM staff st, services_weekly sw
    GROUP BY st.service),
patient_demographics AS (
    SELECT p.service,
        ROUND(AVG(p.age),2) AS avg_age,
        COUNT(p.patient_id) AS total_patients FROM patients p
    GROUP BY p.service),
final_dashboard AS (
    SELECT sm.service,sm.total_admissions,sm.total_refusals,sm.avg_satisfaction,stm.total_staff,stm.avg_weeks_present,
           pd.avg_age,pd.total_patients,
        ( 0.6 * (sm.total_admissions::FLOAT / NULLIF((sm.total_admissions + sm.total_refusals),0)) +
			0.4 * (sm.avg_satisfaction / 100)
        ) AS performance_score FROM service_metrics sm
    LEFT JOIN staff_metrics stm ON sm.service = stm.service
    LEFT JOIN patient_demographics pd ON sm.service = pd.service)
SELECT *
FROM final_dashboard
ORDER BY performance_score DESC;
