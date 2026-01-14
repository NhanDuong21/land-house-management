/* =========================
   DROP & RECREATE DATABASE
   ========================= */
USE master;
GO

IF DB_ID(N'LandHouseManagement') IS NOT NULL
BEGIN
    ALTER DATABASE LandHouseManagement SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LandHouseManagement;
END
GO

CREATE DATABASE LandHouseManagement;
GO
USE LandHouseManagement;
GO


/* =========================
   1. ACCOUNTS (Tài khoản hệ thống)
   status: 0=inactive, 1=active, 2=locked
   ========================= */
CREATE TABLE ACCOUNTS (
    account_id     INT IDENTITY(1,1) PRIMARY KEY,
    username       NVARCHAR(50)  NOT NULL UNIQUE,
    password_hash  NVARCHAR(255) NOT NULL,
    email          NVARCHAR(120) NOT NULL UNIQUE,
    status         TINYINT       NOT NULL CONSTRAINT CK_ACCOUNTS_status CHECK (status IN (0,1,2)),
    created_at     DATETIME2(0)  NOT NULL CONSTRAINT DF_ACCOUNTS_created DEFAULT SYSDATETIME(),
    updated_at     DATETIME2(0)  NULL
);
GO

/* =========================
   2. USER_PROFILES (Thông tin cá nhân)
   gender: 0=unknown, 1=male, 2=female, 3=other
   ========================= */
CREATE TABLE USER_PROFILES (
    profile_id     INT IDENTITY(1,1) PRIMARY KEY,
    account_id     INT NOT NULL UNIQUE,
    full_name      NVARCHAR(100) NOT NULL,
    identity_code NVARCHAR(20) NOT NULL CONSTRAINT UQ_USER_PROFILES_identity UNIQUE,
    phone_number   NVARCHAR(20)  NULL,
    address        NVARCHAR(255) NULL,
    date_of_birth  DATE          NULL,
    gender         TINYINT       NULL CONSTRAINT CK_USER_PROFILES_gender CHECK (gender IN (0,1,2,3)),
    avatar         NVARCHAR(500) NULL, 
    CONSTRAINT FK_USER_PROFILES_account FOREIGN KEY (account_id) REFERENCES ACCOUNTS(account_id) ON DELETE CASCADE -- delete account => delete luôn profile
);
GO

/* =========================
   3. PHÂN QUYỀN (ROLES & PERMISSIONS)
   ========================= */
CREATE TABLE ROLES (
    role_id    INT IDENTITY(1,1) PRIMARY KEY,
    role_name  NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE PERMISSIONS (
    permission_id    INT IDENTITY(1,1) PRIMARY KEY,
    permission_name  NVARCHAR(255) NOT NULL UNIQUE,
    description      NVARCHAR(255) NULL
);
GO

CREATE TABLE ACCOUNT_ROLES (
    account_id   INT NOT NULL,
    role_id      INT NOT NULL,
    granted_date DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
    is_active    BIT NOT NULL DEFAULT 1, -- role active của account đó
    CONSTRAINT PK_ACCOUNT_ROLES PRIMARY KEY (account_id, role_id),
    CONSTRAINT FK_ACCOUNT_ROLES_acc FOREIGN KEY (account_id) REFERENCES ACCOUNTS(account_id) ON DELETE CASCADE,
    CONSTRAINT FK_ACCOUNT_ROLES_role FOREIGN KEY (role_id) REFERENCES ROLES(role_id) ON DELETE CASCADE
);
GO

CREATE TABLE ROLE_PERMISSIONS (
    role_id        INT NOT NULL,
    permission_id  INT NOT NULL,
    assigned_date  DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
    is_enabled     BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_ROLE_PERMISSIONS PRIMARY KEY (role_id, permission_id),
    CONSTRAINT FK_ROLE_PERMISSIONS_role FOREIGN KEY (role_id) REFERENCES ROLES(role_id) ON DELETE CASCADE,
    CONSTRAINT FK_ROLE_PERMISSIONS_perm FOREIGN KEY (permission_id) REFERENCES PERMISSIONS(permission_id) ON DELETE CASCADE
);
GO

/* =========================
   5. TẠO BẢNG NHÀ TRỌ
    status: 0=unavailable, 1=available, 2=occupied, 3=maintenance
   ========================= */
CREATE TABLE HOUSES (
    house_id      INT IDENTITY(1,1) PRIMARY KEY,
    house_name    NVARCHAR(255) NOT NULL,
    city          NVARCHAR(100)  NULL,
    address       NVARCHAR(255) NOT NULL,
    num_of_rooms  INT           NULL,
    description   NVARCHAR(500) NULL,
    status        TINYINT       NOT NULL DEFAULT 0 CONSTRAINT CK_HOUSES_status CHECK (status IN (0,1,2,3)) 
);
GO

/* =========================
   6. QUẢN LÝ PHÒNG (ROOMS)
   status: 0=unavailable, 1=available, 2=occupied, 3=maintenance
   ========================= */
CREATE TABLE ROOMS (
    room_id       INT IDENTITY(1,1) PRIMARY KEY,
    house_id      INT NOT NULL,
    room_number   NVARCHAR(20)  NOT NULL,
    area          DECIMAL(10,2)  NULL,
    floor         INT           NULL,
    max_tenants   INT           NULL,
    price         DECIMAL(12,2) NOT NULL,
    room_image    NVARCHAR(500) NULL,
    is_mezzanine  BIT           NOT NULL DEFAULT 0,
    description   NVARCHAR(500) NULL,
    status        TINYINT       NOT NULL DEFAULT 0 CONSTRAINT CK_ROOMS_status CHECK (status IN (0,1,2,3)),
    CONSTRAINT FK_ROOMS_house FOREIGN KEY (house_id) REFERENCES HOUSES(house_id) ON DELETE CASCADE
);
GO

/* =========================
   7. DỊCH VỤ (UTILITIES)
   ========================= */
CREATE TABLE UTILITIES (
    utility_id     INT IDENTITY(1,1) PRIMARY KEY,
    utility_name   NVARCHAR(255)  NOT NULL UNIQUE,
    unit           NVARCHAR(20)  NOT NULL,
    standard_price DECIMAL(12,2) NOT NULL
);
GO

-- Bảng trung gian Đăng ký dịch vụ cho từng phòng
CREATE TABLE ROOM_UTILITY (
    room_id       INT NOT NULL,
    utility_id    INT NOT NULL,
    start_date    DATE NOT NULL,
    custom_price  DECIMAL(12,2) NULL, 
    description   NVARCHAR(255) NULL,
    CONSTRAINT PK_ROOM_UTILITY PRIMARY KEY (room_id, utility_id, start_date),
    CONSTRAINT FK_ROOM_UTILITY_room FOREIGN KEY (room_id) REFERENCES ROOMS(room_id) ON DELETE CASCADE, 
    CONSTRAINT FK_ROOM_UTILITY_util FOREIGN KEY (utility_id) REFERENCES UTILITIES(utility_id) ON DELETE CASCADE
);
GO

/* =========================
   8. HỢP ĐỒNG (CONTRACTS)
   status: 0 = Draft, 1 = Active, 2 = Expired, 3 = Terminated
   ========================= */
CREATE TABLE CONTRACTS (
    contract_id            INT IDENTITY(1,1) PRIMARY KEY,
    room_id                INT NOT NULL,
    start_date             DATE NOT NULL,
    end_date               DATE NULL,
    deposit                DECIMAL(18,2) NOT NULL DEFAULT 0,
    monthly_rent           DECIMAL(18,2) NOT NULL,
    start_water_index      INT NULL,
    start_electricity_index INT NULL,
    status                 TINYINT NOT NULL DEFAULT 0 CONSTRAINT CK_CONTRACTS_status CHECK (status IN (0,1,2,3)),
    note                   NVARCHAR(500) NULL,
    CONSTRAINT FK_CONTRACTS_room FOREIGN KEY (room_id) REFERENCES ROOMS(room_id)
);
GO

CREATE TABLE CONTRACT_TENANTS (
    record_id      INT IDENTITY(1,1) PRIMARY KEY,
    contract_id    INT NOT NULL,
    profile_id     INT NOT NULL,
    move_in_date   DATE NOT NULL,
    move_out_date  DATE NULL,
    tenant_role    TINYINT NOT NULL CONSTRAINT CK_CONTRACT_TENANTS_role CHECK (tenant_role IN (1,2)), -- 1= Leader, 2= Member
    CONSTRAINT FK_CONTRACT_TENANTS_con FOREIGN KEY (contract_id) REFERENCES CONTRACTS(contract_id) ON DELETE CASCADE,
    CONSTRAINT FK_CONTRACT_TENANTS_pro FOREIGN KEY (profile_id) REFERENCES USER_PROFILES(profile_id)
);
GO

/* =========================
   9. HÓA ĐƠN (BILL & BILL_DETAIL)
   ========================= */
CREATE TABLE BILL (
    bill_id        INT IDENTITY(1,1) PRIMARY KEY,
    room_id        INT NOT NULL, -- 
    bill_month     INT NOT NULL, -- yyyymm
    due_date       DATE NOT NULL,
    payment_date   DATE NULL,
    total_amount   DECIMAL(18,2) NOT NULL DEFAULT 0,
    status         TINYINT NOT NULL DEFAULT 0 CONSTRAINT CK_BILL_status CHECK (status IN (0,1,2,3)),  -- 0 = Unpaid ,1 = Paid, 2 = Overdue, 3 = Terminated
    note           NVARCHAR(500) NULL,
    CONSTRAINT UQ_BILL_room_month UNIQUE (room_id, bill_month),
    CONSTRAINT FK_BILL_room FOREIGN KEY (room_id) REFERENCES ROOMS(room_id) ON DELETE CASCADE
);
GO

CREATE TABLE BILL_DETAIL (
    bill_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    bill_id        INT NOT NULL,
    utility_id     INT NOT NULL,
    old_index      INT NULL,
    new_index      INT NULL,
    quantity       DECIMAL(12,3) NOT NULL DEFAULT 0,
    unit_price     DECIMAL(12,2) NOT NULL,
    sub_total      AS (ROUND(quantity * unit_price, 2)), -- vd tính điện thì 150KWh * 4500 lm tròn 2 số thập phân
    CONSTRAINT FK_BILL_DETAIL_bill FOREIGN KEY (bill_id) REFERENCES BILL(bill_id) ON DELETE CASCADE,
    CONSTRAINT FK_BILL_DETAIL_util FOREIGN KEY (utility_id) REFERENCES UTILITIES(utility_id)
);
GO

/* =========================
   10. BẢO TRÌ (MAINTENANCE_REQUESTS)
   status: 0 = Submitted, 1 = In Progress, 2 = Completed, 3 = Rejected
   ========================= */
CREATE TABLE MAINTENANCE_REQUEST (
    request_id     INT IDENTITY(1,1) PRIMARY KEY,
    room_id        INT NOT NULL,
    submitted_by_profile_id INT NOT NULL,
    handled_by_account_id   INT NULL,
    description    NVARCHAR(1000) NOT NULL,
    image_url      NVARCHAR(500)  NULL,
    status         TINYINT NOT NULL DEFAULT 0 CONSTRAINT CK_MAINT_status CHECK (status IN (0,1,2,3)),
    created_at     DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
    completed_at   DATETIME2(0) NULL,
    CONSTRAINT FK_MAINT_room FOREIGN KEY (room_id) REFERENCES ROOMS(room_id),
    CONSTRAINT FK_MAINT_sub  FOREIGN KEY (submitted_by_profile_id) REFERENCES USER_PROFILES(profile_id),
    CONSTRAINT FK_MAINT_hand FOREIGN KEY (handled_by_account_id) REFERENCES ACCOUNTS(account_id)
);
GO



/* =========================
   INSERT DATA
   ========================= */

-- ROLES
INSERT INTO ROLES(role_name) VALUES
(N'ADMIN'), (N'MANAGER'), (N'TENANT');
GO

-- PERMISSIONS (optional demo)
INSERT INTO PERMISSIONS(permission_name, description) VALUES
(N'ROOM_EDIT',    N'Sửa phòng'),
(N'BILL_CREATE',  N'Tạo hóa đơn'),
(N'MAINT_HANDLE', N'Xử lý bảo trì');
GO

-- ACCOUNTS
INSERT INTO ACCOUNTS(username, password_hash, email, status) VALUES
(N'admin',   N'123456', N'admin@gmail.com',   1),
(N'manager', N'123456', N'manager@gmail.com', 1),
(N'tenant01',N'123456', N'tenant01@gmail.com',1),
(N'tenant02',N'123456', N'tenant02@gmail.com',1);
GO

-- USER_PROFILES
-- account_id 1..4 tương ứng với 4 account vừa insert
INSERT INTO USER_PROFILES(account_id, full_name, identity_code, phone_number, address, date_of_birth, gender, avatar) VALUES
(1, N'Admin Demo',   N'012345678901', N'0900000001', N'Hồ Chí Minh', '1995-01-01', 1, NULL),
(2, N'Manager Demo', N'012345678902', N'0900000002', N'Hà Nội',      '1997-02-02', 2, NULL),
(3, N'Tenant One',   N'012345678903', N'0900000003', N'Hồ Chí Minh', '2000-03-03', 1, NULL),
(4, N'Tenant Two',   N'012345678904', N'0900000004', N'Hà Nội',      '2001-04-04', 2, NULL);
GO

-- ACCOUNT_ROLES
-- role_id: 1=ADMIN, 2=MANAGER, 3=TENANT
INSERT INTO ACCOUNT_ROLES(account_id, role_id, is_active) VALUES
(1, 1, 1),  -- admin -> ADMIN
(2, 2, 1),  -- manager -> MANAGER
(3, 3, 1),  -- tenant01 -> TENANT
(4, 3, 1);  -- tenant02 -> TENANT
GO

-- HOUSES (2 nhà: HCM + Hà Nội)
INSERT INTO HOUSES(house_name, city, address, num_of_rooms, description, status) VALUES
(N'Nhà trọ Q1',     N'Hồ Chí Minh', N'123 Nguyễn Huệ, Q1', 10, N'Nhà trọ demo HCM', 1),
(N'Nhà trọ Cầu Giấy',N'Hà Nội',     N'88 Trần Thái Tông, Cầu Giấy', 12, N'Nhà trọ demo Hà Nội', 1);
GO

-- ROOMS (house_id = 1,2)
INSERT INTO ROOMS(house_id, room_number, area, floor, max_tenants, price, room_image, is_mezzanine, description, status) VALUES
(1, N'101', 22.5, 1, 2, 3500000, NULL, 0, N'Phòng 101 - HCM', 1),
(1, N'102', 28.0, 1, 3, 4500000, NULL, 1, N'Phòng 102 gác lửng - HCM', 2),
(2, N'201', 20.0, 2, 2, 3200000, NULL, 0, N'Phòng 201 - Hà Nội', 1),
(2, N'202', 30.0, 2, 3, 4800000, NULL, 1, N'Phòng 202 gác lửng - Hà Nội', 1);
GO

-- UTILITIES
INSERT INTO UTILITIES(utility_name, unit, standard_price) VALUES
(N'Điện', N'kWh', 4500),
(N'Nước', N'm3', 18000),
(N'Internet', N'tháng', 100000);
GO

-- ROOM_UTILITY (đăng ký dịch vụ cho phòng 102 và 202)
INSERT INTO ROOM_UTILITY(room_id, utility_id, start_date, custom_price, description) VALUES
(2, 1, '2026-01-01', NULL,  N'Giá chuẩn'),
(2, 2, '2026-01-01', 20000, N'Giá nước tùy chỉnh'),
(2, 3, '2026-01-01', NULL,  N'Wifi'),

(4, 1, '2026-01-01', NULL,  N'Giá chuẩn'),
(4, 2, '2026-01-01', NULL,  N'Giá chuẩn'),
(4, 3, '2026-01-01', NULL,  N'Wifi');
GO

-- CONTRACTS (phòng 102 có hợp đồng active)
INSERT INTO CONTRACTS(room_id, start_date, end_date, deposit, monthly_rent, start_water_index, start_electricity_index, status, note) VALUES
(2, '2026-01-01', '2026-12-31', 2000000, 4500000, 10, 120, 1, N'Hợp đồng demo phòng 102');
GO

-- CONTRACT_TENANTS (tenant01 leader, tenant02 member) -> contract_id = 1 nếu DB mới tinh
INSERT INTO CONTRACT_TENANTS(contract_id, profile_id, move_in_date, move_out_date, tenant_role) VALUES
(1, 3, '2026-01-01', NULL, 1),
(1, 4, '2026-01-01', NULL, 2);
GO

-- BILL (bill_id = 1) cho phòng 102 tháng 202601
INSERT INTO BILL(room_id, bill_month, due_date, payment_date, total_amount, status, note) VALUES
(2, 202601, '2026-01-10', NULL, 0, 0, N'Hóa đơn tháng 01/2026 - phòng 102');
GO

-- BILL_DETAIL
INSERT INTO BILL_DETAIL(bill_id, utility_id, old_index, new_index, quantity, unit_price) VALUES
(1, 1, 120, 270, 150, 4500),
(1, 2, 10,  16,  6, 20000),
(1, 3, NULL, NULL, 1, 100000);
GO

-- Update total_amount
UPDATE BILL
SET total_amount = (SELECT SUM(sub_total) FROM BILL_DETAIL WHERE bill_id = 1)
WHERE bill_id = 1;
GO

-- MAINTENANCE_REQUEST (1 cái HCM - submitted, 1 cái HN - in progress)
INSERT INTO MAINTENANCE_REQUEST(room_id, submitted_by_profile_id, handled_by_account_id, description, image_url, status) VALUES
(2, 3, NULL, N'Bóng đèn hành lang bị hỏng', NULL, 0),
(4, 4, 2,    N'Vòi nước bị rò rỉ',         NULL, 1);
GO
