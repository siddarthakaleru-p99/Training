// src/main/java/P99Soft/demo/service/StudentService.java
package P99Soft.demo.service;

import P99Soft.demo.entity.Student;
import java.util.List;

public interface StudentService {
    List<Student> getAllStudents();
    Student getStudentById(Long id);
    Student saveStudent(Student student);
    void deleteStudent(Long id);
}