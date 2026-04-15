SELECT 
    e.first_name,
    e.last_name,
    TIMESTAMPDIFF(YEAR, e.birth_date, CURDATE()) AS age,
    TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS years_of_service,
    e.hire_date AS joined_date
FROM employees e
WHERE 
    TIMESTAMPDIFF(YEAR, e.birth_date, CURDATE()) > 50
    AND TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) > 10
