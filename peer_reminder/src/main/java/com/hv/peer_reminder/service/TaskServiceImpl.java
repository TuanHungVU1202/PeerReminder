package com.hv.peer_reminder.service;

import com.hv.peer_reminder.common.Utils;
import com.hv.peer_reminder.model.Task;
import com.hv.peer_reminder.model.TaskDTO;
import com.hv.peer_reminder.model.TaskRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class TaskServiceImpl implements  ITaskService{
    private static final Logger logger = LoggerFactory.getLogger(TaskServiceImpl.class);

    @Autowired
    TaskRepository taskRepository;

    @Override
    public List<Task> findAll() {
        return taskRepository.findAll();
    }

    @Override
    public Page<Task> findAll(Pageable paging) {
        return taskRepository.findAll(paging);
    }

    @Override
    public Page<Task> findAll(Specification<Task> spec, Pageable paging) {
        return taskRepository.findAll(spec, paging);
    }

    @Override
    public Task findTaskById(long id) {
        Optional<Task> task = taskRepository.findTaskById(id);
        return task.orElse(null);
    }

    @Override
    public Task findTaskByTaskName(String taskName) {
        return taskRepository.findTaskByTaskName(taskName);
    }

    @Transactional
    @Override
    public long removeById(Long id) {
        return taskRepository.removeById(id);
    }

    @Transactional
    @Override
    public long removeByTaskName(String taskName) {
        return taskRepository.removeByTaskName(taskName);
    }

    @Transactional
    @Override
    public Task addTask(TaskDTO taskDTO) {
        Date[] startEndDateTime = null;
        Task newTask = new Task();

        // Receive taskDTO with init id from Flutter but do not parse from the beginning
        newTask.setTaskName(taskDTO.getTaskName());

        try {
            startEndDateTime = getStartAndEndDate(taskDTO);
        } catch (ParseException pe) {
            logger.error("TaskServiceImpl::addTask() error: ", pe);
        }

        assert startEndDateTime != null;
        newTask.setStartDateTime(startEndDateTime[0]);
        newTask.setEndDateTime(startEndDateTime[1]);

        newTask.setTaskNote(taskDTO.getTaskNote());
        newTask.setEmail(taskDTO.getEmail());
        newTask.setPhoneNo(taskDTO.getPhoneNo());
        newTask.setTaskCategory(taskDTO.getTaskCategory());
        newTask.setTaskStatus(taskDTO.getTaskStatus());

        // saving new task
        taskRepository.save(newTask);
        return newTask;
    }

    @Transactional
    @Override
    // TODO: partially update only?
    public Task updateTask(TaskDTO taskDTO, long id) {
        Task task = taskRepository.getOne(id);

        task.setTaskName(taskDTO.getTaskName());

        Date[] startEndDateTime = null;
        try {
            startEndDateTime = getStartAndEndDate(taskDTO);
        } catch (ParseException pe) {
            logger.error("TaskServiceImpl::updateTask() error: ", pe);
        }

        assert startEndDateTime != null;
        task.setStartDateTime(startEndDateTime[0]);
        task.setEndDateTime(startEndDateTime[1]);

        task.setTaskNote(taskDTO.getTaskNote());
        task.setEmail(taskDTO.getEmail());
        task.setPhoneNo(taskDTO.getPhoneNo());
        task.setTaskCategory(taskDTO.getTaskCategory());
        task.setTaskStatus(taskDTO.getTaskStatus());

        taskRepository.save(task);
        return task;
    }

    @Override
    public boolean isTaskNameExist(String taskName) {
        return taskRepository.existsByTaskName(taskName);
    }

    // ------------------------------------------------------
    // Private utils
    private Date[] getStartAndEndDate(TaskDTO taskDTO) throws ParseException {
        Date startDateTime = Utils.dateTimeStrtoDate(taskDTO.getStartDate(), taskDTO.getStartTime());
        Date endDateTime = Utils.dateTimeStrtoDate(taskDTO.getEndDate(), taskDTO.getEndTime());
        return new Date[] {startDateTime, endDateTime};
    }
}
