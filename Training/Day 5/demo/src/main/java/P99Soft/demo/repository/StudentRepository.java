// src/main/java/P99Soft/demo/repository/StudentRepository.java
package P99Soft.demo.repository;

import P99Soft.demo.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
}