CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary NUMERIC(10, 2)
);

CREATE OR REPLACE PROCEDURE insert_employee(
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_department VARCHAR,
    p_salary NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employees (first_name, last_name, department, salary)
    VALUES (p_first_name, p_last_name, p_department, p_salary);
END;
$$;

CALL insert_employee('John', 'Doe', 'IT', 75000.00);
CALL insert_employee('Jane', 'Smith', 'HR', 65000.00);
CALL insert_employee('Alice', 'Johnson', 'Finance', 85000.00);
CALL insert_employee('Bob', 'Williams', 'IT', 72000.00);
CALL insert_employee('Charlie', 'Brown', 'Sales', 60000.00);

SELECT * FROM employees;

CREATE OR REPLACE PROCEDURE delete_employee(
    p_emp_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM employees WHERE emp_id = p_emp_id) THEN
        RAISE EXCEPTION 'Validation Failed: Employee ID % does not exist.', p_emp_id;
    END IF;

    DELETE FROM employees WHERE emp_id = p_emp_id;
END;
$$;

CALL delete_employee(5);

CREATE OR REPLACE FUNCTION fetch_employees_by_dept(
    p_department VARCHAR
)
RETURNS TABLE (
    emp_id INT,
    first_name VARCHAR,
    last_name VARCHAR,
    department VARCHAR,
    salary NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT e.emp_id, e.first_name, e.last_name, e.department, e.salary
    FROM employees e
    WHERE e.department = p_department;
END;
$$;

SELECT * FROM fetch_employees_by_dept('IT');