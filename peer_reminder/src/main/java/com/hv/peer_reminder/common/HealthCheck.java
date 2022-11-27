package com.hv.peer_reminder.common;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthCheck {
    @GetMapping("/health")
    public String getHealthCheck() {
        return "ok";
    }
}
