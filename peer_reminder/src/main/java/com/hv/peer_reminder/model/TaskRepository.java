package com.hv.peer_reminder.model;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.hv.peer_reminder.model.Task;

import java.util.List;
import java.util.Optional;

// work like DAO
@Repository("taskRepository")
public interface TaskRepository extends JpaRepository<Task, Long>, JpaSpecificationExecutor<Task>{
    // Find
    List<Task> findAll();
    Optional<Task> findTaskById(Long id);
    Task findTaskByTaskName(String taskName);
    Page<Task> findAll(Pageable paging);
    Page<Task> findAll(Specification<Task> spec, Pageable paging);

    // Remove
    long removeById(Long id);
    long removeByTaskName(String taskName);
    long removeByEmail(String email);

    // Exists
    boolean existsByTaskName(String taskName);
}
