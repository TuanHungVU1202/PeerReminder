package com.hv.peer_reminder.controller;

import com.hv.peer_reminder.model.Task;
import com.hv.peer_reminder.model.TaskDTO;
import com.hv.peer_reminder.service.ITaskService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/task")
public class TaskListController {
    private static final Logger logger = LoggerFactory.getLogger(TaskListController.class);

    @Autowired
    ITaskService taskService;

    // ------------------------------------------------------
    // GET
    @GetMapping
    public ResponseEntity<List<Task>> getAllTask() {
        List<Task> tasks = taskService.findAll();
        return new ResponseEntity<>(tasks, HttpStatus.OK);
    }

    // ------------------------------------------------------
    // POST
    @PostMapping(headers = "Accept=application/json")
    public ResponseEntity<?> addTask(@Valid @RequestBody TaskDTO taskDTO) throws Exception {
        try {
            Task task = taskService.addTask(taskDTO);
            return new ResponseEntity<>(task, HttpStatus.CREATED);
        } catch (Exception e) {
            logger.error("TaskListController::addTask() error: ", e);
            return ResponseEntity.status(HttpStatus.GONE)
                    .body(e.getMessage());
        }
    }

    // ------------------------------------------------------
    // PUT
    @PutMapping(value = "/{id}", headers = "Accept=application/json")
    public ResponseEntity<?> updateTask(@PathVariable long id, @Valid @RequestBody TaskDTO taskDTO) throws Exception {
        try {
            Task task = taskService.updateTask(taskDTO, id);
            return new ResponseEntity<>(task, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("TaskListController::updateTask() error: ", e);
            return ResponseEntity.status(HttpStatus.GONE)
                    .body(e.getMessage());
        }
    }

    // ------------------------------------------------------
    // DELETE
    @DeleteMapping(value = "/{id}", headers = "Accept=application/json")
    public ResponseEntity<?> deleteTask(@PathVariable long id) throws Exception {
        try {
            long taskId = taskService.removeById(id);
            System.out.println(taskId);
            return new ResponseEntity<>(taskId, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("TaskListController::deleteTask() error: ", e);
            return ResponseEntity.status(HttpStatus.GONE)
                    .body(e.getMessage());
        }
    }
}
