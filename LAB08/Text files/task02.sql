SELECT DISTINCT e.emp_no, e.first_name, e.last_name
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
JOIN titles t ON e.emp_no = t.emp_no
WHERE e.sex = 'F'
  AND t.title = 'Senior Engineer';
