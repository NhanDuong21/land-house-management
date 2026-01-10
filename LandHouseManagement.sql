CREATE DATABASE LandHouseManagement;
GO

USE LandHouseManagement;
GO

CREATE TABLE Admin (
    admin_id INT IDENTITY PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    email    NVARCHAR(255) NOT NULL UNIQUE
);


CREATE TABLE Room (
    room_id     INT IDENTITY PRIMARY KEY,
    room_number NVARCHAR(20) NOT NULL UNIQUE,
    price       DECIMAL(18,2) NOT NULL,
    status      NVARCHAR(20) NOT NULL,
    description NVARCHAR(500),
    room_image  NVARCHAR(500)
);

CREATE TABLE Utility (
    utility_id    INT IDENTITY PRIMARY KEY,
    utility_name  NVARCHAR(50) NOT NULL UNIQUE,
    utility_price DECIMAL(18,2) NOT NULL,
    unit          NVARCHAR(20) NOT NULL
);

CREATE TABLE Manager (
    manager_id  INT IDENTITY PRIMARY KEY,
	--FK connect to Admin table
    admin_id    INT NOT NULL,
	
    username    NVARCHAR(50) NOT NULL UNIQUE,
    password    NVARCHAR(255) NOT NULL,
    full_name   NVARCHAR(100) NOT NULL,
    email       NVARCHAR(255) NOT NULL UNIQUE,
    phone       NVARCHAR(20),
    is_disabled BIT NOT NULL DEFAULT 0, -- xem trạng thái tài khoản, ( map với use case )

    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id) -- ràng buộc FK
);

CREATE TABLE Tenant (
    tenant_id     INT IDENTITY PRIMARY KEY,
    admin_id      INT NOT NULL,

    full_name     NVARCHAR(100) NOT NULL,
    phone         NVARCHAR(20),
    email         NVARCHAR(255) UNIQUE,
    identity_code NVARCHAR(30) NOT NULL UNIQUE,

    is_active     BIT NOT NULL DEFAULT 1,

    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

CREATE TABLE Bill (
    bill_id INT IDENTITY PRIMARY KEY,

    room_id INT NOT NULL,

    bill_month DATE NOT NULL,        -- quy ước: year-month-01 ví dụ (2025-07-01 )
    electricity_usage DECIMAL(18,2) NOT NULL,
    water_usage       DECIMAL(18,2) NOT NULL,

    total_amount DECIMAL(18,2) NOT NULL,
    due_date DATE NOT NULL, -- hạn đóng tiền ví dụ ( 2025-07-05)
    payment_status NVARCHAR(20) NOT NULL,

    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    UNIQUE (room_id, bill_month)  -- Mỗi phòng chỉ có 1 hóa đơn cho mỗi tháng
);

CREATE TABLE Maintenance_Request (
    request_id   INT IDENTITY PRIMARY KEY,

    tenant_id    INT NOT NULL,
    manager_id   INT NULL,

    request_date DATE NOT NULL,
    description  NVARCHAR(500) NOT NULL,
    status       NVARCHAR(20) NOT NULL,

    FOREIGN KEY (tenant_id)  REFERENCES Tenant(tenant_id),
    FOREIGN KEY (manager_id) REFERENCES Manager(manager_id)
);

CREATE TABLE Room_Uses_Utility (
    room_id    INT NOT NULL,
    utility_id INT NOT NULL,

    PRIMARY KEY (room_id, utility_id),
	-- Khóa chính kép, đảm bảo 1 phòng không bị gán trùng 1 tiện ích nhiều lần

    FOREIGN KEY (room_id)    REFERENCES Room(room_id), -- FK chỉ cho phép room_id tồn tại trong bảng Room
    FOREIGN KEY (utility_id) REFERENCES Utility(utility_id) -- Fk chỉ cho phép utility_id tồn tại trong bảng Utility
);

CREATE TABLE Contract (
    contract_id INT IDENTITY PRIMARY KEY,

    manager_id  INT NOT NULL,
    tenant_id   INT NOT NULL,
    room_id     INT NOT NULL,

    start_date  DATE NOT NULL,
    end_date    DATE NULL, -- Có thể gia hạn
    deposit     DECIMAL(18,2) NOT NULL,
    status      NVARCHAR(20) NOT NULL,

    FOREIGN KEY (manager_id) REFERENCES Manager(manager_id),
    FOREIGN KEY (tenant_id)  REFERENCES Tenant(tenant_id),
    FOREIGN KEY (room_id)    REFERENCES Room(room_id)
);

