import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

interface EmployeeOperations {
    void addEmployee(Employee emp);
    void displayEmployees();
    void deleteEmployee(int id);
}

abstract class Employee {
    private int id;
    private String name;

    public Employee(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId() { return id; }
    public String getName() { return name; }

    public abstract String getDetails();

    @Override
    public String toString() {
        return "ID: " + id + " | Name: " + name + " | " + getDetails();
    }
}

class Employee1 extends Employee {
    private double salary;

    public Employee1(int id, String name, double salary) {
        super(id, name);
        this.salary = salary;
    }

    @Override
    public String getDetails() {
        return "Employee Salary: $" + salary;
    }
}

class EmployeeManager implements EmployeeOperations {
    private List<Employee> employees = new ArrayList<>();

    @Override
    public void addEmployee(Employee emp) {
        employees.add(emp);
        System.out.println("Employee added successfully.");
    }

    @Override
    public void displayEmployees() {
        if (employees.isEmpty()) {
            System.out.println("No employees found.");
            return;
        }
        for (Employee emp : employees) {
            System.out.println(emp.toString());
        }
    }

    @Override
    public void deleteEmployee(int id) {
        boolean removed = employees.removeIf(emp -> emp.getId() == id);
        if (removed) {
            System.out.println("Employee deleted successfully.");
        } else {
            System.out.println("Employee with ID " + id + " not found.");
        }
    }
}

public class Project {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        EmployeeOperations system = new EmployeeManager();

        while (true) {
            System.out.println("\n--- Employee Management System ---");
            System.out.println("1. Add Employee");
            System.out.println("2. Display All Employees");
            System.out.println("3. Delete Employee");
            System.out.println("4. Exit");
            System.out.print("Enter your choice: ");

            int choice;
            try {
                choice = Integer.parseInt(scanner.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("Invalid input. Please enter a number.");
                continue;
            }

            switch (choice) {
                case 1:
                    System.out.print("Enter ID: ");
                    int ftId = Integer.parseInt(scanner.nextLine());
                    System.out.print("Enter Name: ");
                    String ftName = scanner.nextLine();
                    System.out.print("Enter Salary: ");
                    double salary = Double.parseDouble(scanner.nextLine());
                    system.addEmployee(new Employee1(ftId, ftName, salary));
                    break;
                case 2:
                    system.displayEmployees();
                    break;
                case 3:
                    System.out.print("Enter Employee ID to delete: ");
                    int delId = Integer.parseInt(scanner.nextLine());
                    system.deleteEmployee(delId);
                    break;
                case 4:
                    System.out.println("Exiting System...");
                    scanner.close();
                    System.exit(0);
                default:
                    System.out.println("Invalid choice. Try again.");
            }
        }
    }
}