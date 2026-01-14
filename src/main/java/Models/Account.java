package Models;

import java.time.LocalDateTime;

/**
 * Author: Duong Thien Nhan - CE190741 Created on: 2026-01-12
 */
public class Account {

    private Integer accountId;
    private String username;
    private String passwordHash;
    private String email;
    private int status; // 0=inactive, 1=active, 2=locked
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt; 
}
