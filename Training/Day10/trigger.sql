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

CREATE TABLE employees_insert_log (
    log_id SERIAL PRIMARY KEY,
    emp_id INT,
    inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_employee_insert()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO employees_insert_log (emp_id) VALUES (NEW.emp_id);
    RETURN NEW;
END;
$$;

CREATE TRIGGER after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW EXECUTE FUNCTION log_employee_insert();

INSERT INTO employees (first_name, last_name, department, salary) VALUES ('Siddartha', 'Kaleru', 'HR', 60000);

SELECT * FROM employees_insert_log;


CREATE OR REPLACE FUNCTION prevent_invalid_insert()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.salary < 0 THEN
        RAISE EXCEPTION 'Salary cannot be negative';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER before_employee_insert_validation
BEFORE INSERT ON employees
FOR EACH ROW EXECUTE FUNCTION prevent_invalid_insert();

INSERT INTO employees (first_name, last_name, department, salary) VALUES ('Bad', 'Data', 'IT', -500);

CREATE OR REPLACE FUNCTION restrict_employee_delete()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Deletion of employee records is strictly restricted.';
END;
$$;

CREATE TRIGGER before_employee_delete
BEFORE DELETE ON employees
FOR EACH ROW EXECUTE FUNCTION restrict_employee_delete();

DELETE FROM employees;

CREATE TABLE employees_update_audit (
    audit_id SERIAL PRIMARY KEY,
    emp_id INT,
    old_salary NUMERIC(10, 2),
    new_salary NUMERIC(10, 2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION audit_employee_update()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.salary IS DISTINCT FROM NEW.salary THEN
        INSERT INTO employees_update_audit (emp_id, old_salary, new_salary)
        VALUES (OLD.emp_id, OLD.salary, NEW.salary);
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER after_employee_update
AFTER UPDATE ON employees
FOR EACH ROW EXECUTE FUNCTION audit_employee_update();


UPDATE employees SET salary = 65000 WHERE first_name = 'Siddartha';

SELECT * FROM employees_update_audit;