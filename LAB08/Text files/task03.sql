SELECT d.dept_name, t.title, COUNT(*) AS employee_count
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN titles t ON e.emp_no = t.emp_no
WHERE s.salary > 115000
GROUP BY d.dept_name, t.title;
