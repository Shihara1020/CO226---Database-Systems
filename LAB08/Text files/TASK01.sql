SELECT d.dept_name, COUNT(*) AS engineer_count
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE t.title = 'Engineer'
GROUP BY d.dept_name;
