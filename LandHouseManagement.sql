/* =========================================================
   DROP & RECREATE DATABASE
========================================================= */
USE master;
GO

IF DB_ID(N'LandHouseManagement') IS NOT NULL
BEGIN
    ALTER DATABASE [LandHouseManagement] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [LandHouseManagement];
END
GO

CREATE DATABASE [LandHouseManagement];
GO

USE [LandHouseManagement];
GO

/* =========================================================
   DROP TABLES ( optional )
========================================================= */
-- DROP TABLE IF EXISTS MAINTENANCE_REQUEST;
-- DROP TABLE IF EXISTS BILL_DETAIL;
-- DROP TABLE IF EXISTS BILL;
-- DROP TABLE IF EXISTS ROOM_UTILITY;
-- DROP TABLE IF EXISTS UTILITY;
-- DROP TABLE IF EXISTS CONTRACT_TENANTS;
-- DROP TABLE IF EXISTS CONTRACTS;
-- DROP TABLE IF EXISTS STAFF;
-- DROP TABLE IF EXISTS TENANTS;
-- DROP TABLE IF EXISTS ROOMS;
-- DROP TABLE IF EXISTS HOUSES;
-- GO

/* =========================================================
   1) HOUSES
========================================================= */
CREATE TABLE HOUSES (
    house_id     INT IDENTITY(1,1) PRIMARY KEY,
    house_name   NVARCHAR(255) NOT NULL,
    city         NVARCHAR(100) NULL,
    address      NVARCHAR(255) NOT NULL,
    description  NVARCHAR(500) NULL,
    status       TINYINT NOT NULL CONSTRAINT DF_HOUSES_status DEFAULT 1,
    num_of_rooms INT NULL,

    CONSTRAINT CK_HOUSES_status CHECK (status IN (0,1,2,3)) 
    -- 0=unavailable, 1=available, 2=occupied, 3=maintenance
);
GO

/* =========================================================
   2) ROOMS  (HOUSES 1-N ROOMS)
========================================================= */
CREATE TABLE ROOMS (
    room_id       INT IDENTITY(1,1) PRIMARY KEY,
    house_id      INT NOT NULL,
    room_number   NVARCHAR(50) NOT NULL,
    price         DECIMAL(12,2) NOT NULL,          -- giá niêm yết
    area          DECIMAL(8,2) NULL,
    floor         INT NULL,
    max_tenants   INT NULL,
    is_mezzanine  BIT NOT NULL CONSTRAINT DF_ROOMS_is_mezzanine DEFAULT 0,
    room_image    NVARCHAR(500) NULL,
    status        TINYINT NOT NULL CONSTRAINT DF_ROOMS_status DEFAULT 1,
    description   NVARCHAR(500) NULL,

    CONSTRAINT FK_ROOMS_HOUSES
        FOREIGN KEY (house_id) REFERENCES HOUSES(house_id),

    CONSTRAINT CK_ROOMS_status CHECK (status IN (0,1,2,3)),
    -- 0=unavailable, 1=available, 2=occupied, 3=maintenance

    CONSTRAINT CK_ROOMS_price CHECK (price >= 0),
    CONSTRAINT CK_ROOMS_area  CHECK (area IS NULL OR area >= 0),
    CONSTRAINT CK_ROOMS_max_tenants CHECK (max_tenants IS NULL OR max_tenants >= 0)
);
GO

-- Unique: 1 nhà không có 2 phòng cùng số
CREATE UNIQUE INDEX UX_ROOMS_house_roomnumber
ON ROOMS(house_id, room_number);
GO

/* ====================
   3) TENANTS  (login)  
======================= */
CREATE TABLE TENANTS (
    tenant_id     INT IDENTITY(1,1) PRIMARY KEY,
    username      NVARCHAR(80)  NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,  
    full_name     NVARCHAR(200) NOT NULL,
    phone_number  NVARCHAR(30)  NOT NULL,
    email         NVARCHAR(120) NULL,
    identity_code NVARCHAR(30)  NOT NULL,
    address       NVARCHAR(300) NOT NULL,
    gender        TINYINT NULL,
    date_of_birth DATE NULL,
    avatar        NVARCHAR(500) NULL,
    status        TINYINT NOT NULL CONSTRAINT DF_TENANTS_status DEFAULT 1,
    created_at    DATETIME2 NOT NULL CONSTRAINT DF_TENANTS_created_at DEFAULT SYSDATETIME(),
    updated_at    DATETIME2 NULL,

    CONSTRAINT UQ_TENANTS_username UNIQUE(username),
    CONSTRAINT UQ_TENANTS_phone    UNIQUE(phone_number),
    CONSTRAINT UQ_TENANTS_identity UNIQUE(identity_code),

    CONSTRAINT CK_TENANTS_status CHECK (status IN (0,1,2)),
    -- 0=inactive, 1=active, 2=locked

    CONSTRAINT CK_TENANTS_gender CHECK (gender IS NULL OR gender IN (0,1,2,3))
    -- 0=unknown, 1=male, 2=female, 3=other
);
GO

CREATE UNIQUE INDEX UX_TENANTS_email 
ON TENANTS(email) WHERE email IS NOT NULL;
GO

/* =========================================================
   4) STAFF (login) 
========================================================= */
CREATE TABLE STAFF (
    staff_id      INT IDENTITY(1,1) PRIMARY KEY,
    username      NVARCHAR(80)  NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    full_name     NVARCHAR(200) NOT NULL,
    phone_number  NVARCHAR(30)  NOT NULL,
    email         NVARCHAR(120) NULL,
    identity_code NVARCHAR(30)  NULL,
    staff_role    TINYINT NOT NULL,        -- 1=admin, 2=manager
    status        TINYINT NOT NULL CONSTRAINT DF_STAFF_status DEFAULT 1,
    created_at    DATETIME2 NOT NULL CONSTRAINT DF_STAFF_created_at DEFAULT SYSDATETIME(),
    updated_at    DATETIME2 NULL,
    avatar        NVARCHAR(500) NULL,
    gender        TINYINT NULL,
    date_of_birth DATE NULL,

    -- optional: staff phụ trách 1 house
    house_id      INT NULL,

    CONSTRAINT FK_STAFF_HOUSES
        FOREIGN KEY (house_id) REFERENCES HOUSES(house_id)
        ON DELETE SET NULL,

    CONSTRAINT UQ_STAFF_username UNIQUE(username),
    CONSTRAINT UQ_STAFF_phone    UNIQUE(phone_number),

    CONSTRAINT CK_STAFF_role   CHECK (staff_role IN (1,2)),
    CONSTRAINT CK_STAFF_status CHECK (status IN (0,1,2)),
    CONSTRAINT CK_STAFF_gender CHECK (gender IS NULL OR gender IN (0,1,2,3))
);
GO

CREATE UNIQUE INDEX UX_STAFF_email 
ON STAFF(email) WHERE email IS NOT NULL;
GO

/* =========================================================
   5) CONTRACTS (ROOMS 1-N CONTRACTS)
========================================================= */
CREATE TABLE CONTRACTS (
    contract_id             INT IDENTITY(1,1) PRIMARY KEY,
    room_id                 INT NOT NULL,
    start_date              DATE NOT NULL,
    end_date                DATE NULL,
    deposit                 DECIMAL(12,2) NULL,
    monthly_rent            DECIMAL(12,2) NOT NULL,
    start_water_index       INT NULL,
    start_electricity_index INT NULL,
    status                  TINYINT NOT NULL CONSTRAINT DF_CONTRACTS_status DEFAULT 1,
    note                    NVARCHAR(500) NULL,

    CONSTRAINT FK_CONTRACTS_ROOMS
        FOREIGN KEY (room_id) REFERENCES ROOMS(room_id),

    CONSTRAINT CK_CONTRACTS_dates CHECK (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT CK_CONTRACTS_money CHECK ((deposit IS NULL OR deposit >= 0) AND monthly_rent >= 0),
    CONSTRAINT CK_CONTRACTS_status CHECK (status IN (0,1,2))
    -- 0=inactive, 1=active, 2=terminated 
);
GO


/* =========================================================
   6) CONTRACT_TENANTS 
========================================================= */
CREATE TABLE CONTRACT_TENANTS (
    record_id     INT IDENTITY(1,1) PRIMARY KEY,
    contract_id   INT NOT NULL,
    tenant_id     INT NOT NULL,
    move_in_date  DATE NOT NULL,
    move_out_date DATE NULL,
    note          NVARCHAR(500) NULL,

    CONSTRAINT FK_CT_CONTRACTS
        FOREIGN KEY (contract_id) REFERENCES CONTRACTS(contract_id)
        ON DELETE CASCADE,

    CONSTRAINT FK_CT_TENANTS
        FOREIGN KEY (tenant_id) REFERENCES TENANTS(tenant_id),

    CONSTRAINT CK_CT_dates CHECK (move_out_date IS NULL OR move_out_date >= move_in_date)
);
GO


-- tránh tenant bị add trùng vào 1 hợp đồng cùng ngày vào ở
CREATE UNIQUE INDEX UX_CT_unique
ON CONTRACT_TENANTS(contract_id, tenant_id, move_in_date);
GO

/* =========================================================
   7) UTILITY
========================================================= */
CREATE TABLE UTILITY (
    utility_id     INT IDENTITY(1,1) PRIMARY KEY,
    utility_name   NVARCHAR(200) NOT NULL,
    unit           NVARCHAR(30)  NOT NULL,      -- kWh, m3, tháng...
    standard_price DECIMAL(12,2) NOT NULL,
    status         TINYINT NOT NULL CONSTRAINT DF_UTILITY_status DEFAULT 1,

    CONSTRAINT UQ_UTILITY_name UNIQUE(utility_name),
    CONSTRAINT CK_UTILITY_price  CHECK (standard_price >= 0),
    CONSTRAINT CK_UTILITY_status CHECK (status IN (0,1,2))
    -- 0=discontinued, 1=active, 2=maintenance
);
GO

/* =========================================================
   8) ROOM_UTILITY  (ROOMS M-N UTILITY theo thời gian)
========================================================= */
CREATE TABLE ROOM_UTILITY (
    room_id      INT NOT NULL,
    utility_id   INT NOT NULL,
    start_date   DATE NOT NULL,
    end_date     DATE NULL,
    custom_price DECIMAL(12,2) NULL,
    description  NVARCHAR(500) NULL,

    CONSTRAINT PK_ROOM_UTILITY PRIMARY KEY (room_id, utility_id, start_date),
	-- start_date PK để save lịch sử đổi giá utility

    CONSTRAINT FK_RU_ROOMS
        FOREIGN KEY (room_id) REFERENCES ROOMS(room_id) ON DELETE CASCADE,

    CONSTRAINT FK_RU_UTILITY
        FOREIGN KEY (utility_id) REFERENCES UTILITY(utility_id),

    CONSTRAINT CK_RU_dates CHECK (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT CK_RU_price CHECK (custom_price IS NULL OR custom_price >= 0)
);


/* =========================================================
   9) BILL - chỉ số điện/nước nằm ở bill
========================================================= */
CREATE TABLE BILL (
    bill_id             INT IDENTITY(1,1) PRIMARY KEY,
    room_id             INT NOT NULL,
    bill_month          INT NOT NULL, -- yyyymm
    due_date            DATE NOT NULL,
    payment_date        DATE NULL,
    status              TINYINT NOT NULL CONSTRAINT DF_BILL_status DEFAULT 0,
    note                NVARCHAR(500) NULL,

    old_water_number    INT NULL,
    new_water_number    INT NULL,
    old_electric_number INT NULL,
    new_electric_number INT NULL,

    CONSTRAINT FK_BILL_ROOMS
        FOREIGN KEY (room_id) REFERENCES ROOMS(room_id),

    CONSTRAINT CK_BILL_status CHECK (status IN (0,1,2,3)), -- 0 = Unpaid ,1 = Paid, 2 = Overdue, 3 = Terminated
    CONSTRAINT CK_BILL_month CHECK (
        bill_month BETWEEN 100001 AND 999912 
        AND (bill_month % 100) BETWEEN 1 AND 12 -- lấy mm làm tháng 
    ),
    CONSTRAINT CK_BILL_water CHECK (
        old_water_number IS NULL OR new_water_number IS NULL OR new_water_number >= old_water_number
    ),
    CONSTRAINT CK_BILL_electric CHECK (
        old_electric_number IS NULL OR new_electric_number IS NULL OR new_electric_number >= old_electric_number
    ),
    CONSTRAINT CK_BILL_numbers_nonneg CHECK (
        (old_water_number IS NULL OR old_water_number >= 0) AND
        (new_water_number IS NULL OR new_water_number >= 0) AND
        (old_electric_number IS NULL OR old_electric_number >= 0) AND
        (new_electric_number IS NULL OR new_electric_number >= 0)
    )
);
GO

-- 1 phòng 1 tháng chỉ có 1 bill
CREATE UNIQUE INDEX UX_BILL_room_month
ON BILL(room_id, bill_month);
GO

/* =========================================================
   10) BILL_DETAIL
========================================================= */
CREATE TABLE BILL_DETAIL (
    bill_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    bill_id        INT NOT NULL,
    item_name      NVARCHAR(200) NOT NULL,  --"electricity", "water", "internet"...
    unit           NVARCHAR(30)  NOT NULL,
    quantity       DECIMAL(12,3) NOT NULL,
    unit_price     DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_BILL_DETAIL_BILL
        FOREIGN KEY (bill_id) REFERENCES BILL(bill_id)
        ON DELETE CASCADE,

    CONSTRAINT CK_BD_quantity CHECK (quantity >= 0),
    CONSTRAINT CK_BD_unit_price CHECK (unit_price >= 0)
);
GO

/* =========================================================
   11) MAINTENANCE_REQUEST (TENANTS gửi, STAFF xử lý, gắn ROOMS)
========================================================= */
CREATE TABLE MAINTENANCE_REQUEST (
    request_id           INT IDENTITY(1,1) PRIMARY KEY,
    room_id              INT NOT NULL,
    tenant_id            INT NOT NULL,
    handled_by_staff_id  INT NULL,
    description          NVARCHAR(800) NOT NULL,
    image_url            NVARCHAR(500) NULL,
    status               TINYINT NOT NULL CONSTRAINT DF_MR_status DEFAULT 0,
    created_at           DATETIME2 NOT NULL CONSTRAINT DF_MR_created_at DEFAULT SYSDATETIME(),
    completed_at         DATETIME2 NULL,

    CONSTRAINT FK_MR_ROOMS
        FOREIGN KEY (room_id) REFERENCES ROOMS(room_id),

    CONSTRAINT FK_MR_TENANTS
        FOREIGN KEY (tenant_id) REFERENCES TENANTS(tenant_id),

    CONSTRAINT FK_MR_STAFF
        FOREIGN KEY (handled_by_staff_id) REFERENCES STAFF(staff_id)
        ON DELETE SET NULL,

    CONSTRAINT CK_MR_status CHECK (status IN (0,1,2,3)),
    -- 0 = Submitted, 1 = In Progress, 2 = Completed, 3 = Rejected

    CONSTRAINT CK_MR_dates CHECK (completed_at IS NULL OR completed_at >= created_at)
);
GO
ALTER TABLE TENANTS ALTER COLUMN phone_number NVARCHAR(30) NULL;
GO
ALTER TABLE TENANTS ALTER COLUMN identity_code NVARCHAR(30) NULL;
GO
ALTER TABLE TENANTS ALTER COLUMN address NVARCHAR(300) NULL;
GO

/* =========================================================
   1. INSERT HOUSES
========================================================= */
INSERT INTO HOUSES (house_name, city, address, description, num_of_rooms, status)
VALUES 
(N'Chung Cư Mini Sunshine', N'Hà Nội', N'123 Đường Láng, Đống Đa', N'Gần các trường đại học lớn, an ninh tốt', 10, 1),
(N'Căn Hộ Dịch Vụ GreenLeaf', N'TP.Hồ Chí Minh', N'456 Lê Văn Sỹ, Quận 3', N'Full nội thất, giờ giấc tự do', 15, 1);
GO

/* =========================================================
   2. INSERT ROOMS
========================================================= */
INSERT INTO ROOMS (house_id, room_number, price, area, floor, max_tenants, is_mezzanine, status, description)
VALUES 
-- Nhà 1 (Hà Nội)
(1, N'P101', 3500000, 25.5, 1, 2, 0, 1, N'Phòng tầng 1, tiện đi lại'),
(1, N'P201', 4000000, 30.0, 2, 3, 1, 1, N'Có gác lửng, ban công thoáng'),
-- Nhà 2 (HCM)
(2, N'A101', 5000000, 35.0, 1, 2, 0, 1, N'Studio cao cấp'),
(2, N'A102', 5500000, 40.0, 1, 4, 1, 1, N'Phòng rộng, ở được nhóm bạn');
GO

/* =========================================================
   3. INSERT UTILITY
========================================================= */
INSERT INTO UTILITY (utility_name, unit, standard_price, status)
VALUES 
(N'Điện', N'kWh', 3500, 1),
(N'Nước sinh hoạt', N'Khối', 20000, 1),
(N'Internet', N'Tháng', 100000, 1),
(N'Vệ sinh chung', N'Người/Tháng', 50000, 1);
GO

/* =========================================================
   4. INSERT ROOM_UTILITY
========================================================= */
INSERT INTO ROOM_UTILITY (room_id, utility_id, start_date, custom_price)
VALUES 
(1, 1, '2025-01-01', 3500),   -- Điện (ID 1)
(1, 2, '2025-01-01', 20000),  -- Nước (ID 2)
(1, 3, '2025-01-01', 100000); -- Mạng (ID 3)
GO

/* =========================================================
   5. INSERT STAFF
========================================================= */
INSERT INTO STAFF (username, password_hash, full_name, phone_number, email, identity_code, staff_role, status, house_id)
VALUES 
-- Admin tổng (Role 1)
(N'admin', N'123456', N'Nguyễn Quản Trị', N'0901111111', N'admin@sys.com', N'001090000001', 1, 1, NULL),
-- Manager Hà Nội (Role 2)
(N'manager_hn', N'123456', N'Trần Quản Lý HN', N'0902222222', N'manager.hn@sys.com', N'001090000002', 2, 1, 1),
-- Manager HCM (Role 2)
(N'manager_hcm', N'123456', N'Lê Quản Lý HCM', N'0903333333', N'manager.hcm@sys.com', N'001090000003', 2, 1, 2);
GO

/* =========================================================
   6. INSERT TENANTS
========================================================= */
INSERT INTO TENANTS (username, password_hash, full_name, phone_number, email, identity_code, address, gender, date_of_birth, status)
VALUES 
(N'tenant_hn', N'123456', N'Phạm Văn Khách', N'0988888888', N'khach.hn@gmail.com', N'034090000888', N'Quê Thái Bình', 1, '1998-05-20', 1),
(N'tenant_hcm', N'123456', N'Nguyễn Thị Thuê', N'0977777777', N'khach.hcm@gmail.com', N'079090000777', N'Quê Long An', 0, '2000-10-15', 1);
GO

/* =========================================================
   7. INSERT CONTRACTS
========================================================= */
INSERT INTO CONTRACTS (room_id, start_date, end_date, deposit, monthly_rent, status, note)
VALUES 
(1, '2025-01-01', '2025-12-31', 3500000, 3500000, 1, N'Hợp đồng 1 năm, cọc 1 tháng');
GO

/* =========================================================
   8. INSERT CONTRACT_TENANTS (ĐÃ SỬA: tenant_role -> note)
========================================================= */
INSERT INTO CONTRACT_TENANTS (contract_id, tenant_id, move_in_date, note)
VALUES 
(1, 1, '2025-01-01', N'Vai trò: Chủ hợp đồng chính');
GO

/* =========================================================
   9. INSERT BILL
========================================================= */
INSERT INTO BILL (room_id, bill_month, due_date, status, old_water_number, new_water_number, old_electric_number, new_electric_number)
VALUES 
(1, 202501, '2025-02-05', 0, 100, 105, 500, 550); 
GO

/* =========================================================
   10. INSERT BILL_DETAIL
========================================================= */
INSERT INTO BILL_DETAIL (bill_id, item_name, unit, quantity, unit_price)
VALUES 
(1, N'Tiền phòng tháng 01', N'Tháng', 1, 3500000),      
(1, N'Tiền điện', N'kWh', 50, 3500),                    
(1, N'Tiền nước', N'Khối', 5, 20000),                   
(1, N'Tiền mạng', N'Tháng', 1, 100000);                 
GO

/* =========================================================
   11. INSERT MAINTENANCE_REQUEST
========================================================= */
INSERT INTO MAINTENANCE_REQUEST (room_id, tenant_id, handled_by_staff_id, description, status)
VALUES 
(1, 1, NULL, N'Điều hòa không mát, kêu to', 0);
GO