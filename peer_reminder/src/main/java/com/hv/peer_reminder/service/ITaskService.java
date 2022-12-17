package com.hv.peer_reminder.service;

import com.hv.peer_reminder.model.Task;
import com.hv.peer_reminder.model.TaskDTO;

import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

public interface ITaskService {
    // Find
    List<Task> findAll();
    Page<Task> findAll(Pageable paging);
    Page<Task> findAll(Specification<Task> spec, Pageable paging);
    Task findTaskById(long id);
    Task findTaskByTaskName(String taskName);

    // Delete
    long removeById(Long id);
    long removeByTaskName(String taskName);

    // Add
    Task addTask(TaskDTO taskDTO);
    List<Task> addTasks(List<TaskDTO> taskDTOList);

    // Exists
    boolean isTaskNameExist(String taskName);
}
