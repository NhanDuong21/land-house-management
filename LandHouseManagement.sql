CREATE DATABASE LandHouseManagement;
GO
USE LandHouseManagement;
GO

/* =========================
   1. ACCOUNT
   ========================= */
CREATE TABLE Account (
    account_id INT IDENTITY PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) UNIQUE,
    avatar NVARCHAR(255),
    role NVARCHAR(20) NOT NULL,
    status NVARCHAR(20) NOT NULL,
    CONSTRAINT CK_Account_Role
        CHECK (role IN ('ADMIN', 'MANAGER', 'TENANT')),
    CONSTRAINT CK_Account_Status
        CHECK (status IN ('ACTIVE', 'INACTIVE', 'BANNED'))
);

/* =========================
   2. HOUSE 
   ========================= */
CREATE TABLE House (
    house_id INT IDENTITY PRIMARY KEY,
    house_name NVARCHAR(100) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    status NVARCHAR(20) NOT NULL,
    CONSTRAINT CK_House_Status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);

/* =========================
   3. ROLE TABLES
   ========================= */
CREATE TABLE Admin (
    admin_id INT IDENTITY PRIMARY KEY,
    account_id INT NOT NULL UNIQUE,
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

CREATE TABLE Manager (
    manager_id INT IDENTITY PRIMARY KEY,
    account_id INT NOT NULL UNIQUE,
    house_id INT NOT NULL UNIQUE, -- 1 khu chỉ có 1 manager
    full_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    FOREIGN KEY (account_id) REFERENCES Account(account_id),
    FOREIGN KEY (house_id) REFERENCES House(house_id)
);

CREATE TABLE Tenant (
    tenant_id INT IDENTITY PRIMARY KEY,
    account_id INT NOT NULL UNIQUE,
    full_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    identity_code NVARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

/* =========================
   4. ROOM
   ========================= */
CREATE TABLE Room (
    room_id INT IDENTITY PRIMARY KEY,
    house_id INT NOT NULL,
    room_number NVARCHAR(20) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    status NVARCHAR(20) NOT NULL,
    room_image NVARCHAR(255),
    description NVARCHAR(255),
    FOREIGN KEY (house_id) REFERENCES House(house_id),
    CONSTRAINT CK_Room_Status CHECK (status IN ('AVAILABLE', 'OCCUPIED', 'MAINTENANCE')),
    CONSTRAINT UQ_Room_House_RoomNumber UNIQUE (house_id, room_number)
);


/* =========================
   5. UTILITY
   ========================= */
CREATE TABLE Utility (
    utility_id INT IDENTITY PRIMARY KEY,
    utility_name NVARCHAR(50) NOT NULL UNIQUE,
    utility_price DECIMAL(18,2) NOT NULL,
    unit NVARCHAR(20) NOT NULL
);

/* =========================
   6. ROOM_UTILITY
   ========================= */
CREATE TABLE Room_Utility (
    room_utility_id INT IDENTITY PRIMARY KEY,
    room_id INT NOT NULL,
    utility_id INT NOT NULL,
    initial_index DECIMAL(18,2),
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    FOREIGN KEY (utility_id) REFERENCES Utility(utility_id),
    CONSTRAINT UQ_RoomUtility UNIQUE (room_id, utility_id, start_date)
);

/* =========================
   7. CONTRACT
   ========================= */
CREATE TABLE Contract (
    contract_id INT IDENTITY PRIMARY KEY,
    manager_id INT NOT NULL,
    tenant_id INT NOT NULL,
    room_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    deposit DECIMAL(18,2) NOT NULL,
    status NVARCHAR(20) NOT NULL,
    FOREIGN KEY (manager_id) REFERENCES Manager(manager_id),
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    CONSTRAINT CK_Contract_Status
        CHECK (status IN ('ACTIVE', 'EXPIRED', 'TERMINATED')),
    CONSTRAINT CK_Contract_Dates
        CHECK (end_date IS NULL OR end_date > start_date)
);

/* =========================
   8. BILL
   ========================= */
CREATE TABLE Bill (
    bill_id INT IDENTITY PRIMARY KEY,
    contract_id INT NOT NULL,
    bill_month DATE NOT NULL,
    due_date DATE NOT NULL,
    total_amount DECIMAL(18,2) NOT NULL,
    payment_status NVARCHAR(20) NOT NULL,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
);

/* =========================
   9. BILL_DETAIL
   ========================= */
CREATE TABLE Bill_Detail (
    bill_detail_id INT IDENTITY PRIMARY KEY,
    bill_id INT NOT NULL,
    utility_id INT NOT NULL,
    old_index DECIMAL(18,2) NULL,
    new_index DECIMAL(18,2) NULL,
    quantity DECIMAL(18,2) NOT NULL,
    unit_price DECIMAL(18,2) NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES Bill(bill_id),
    FOREIGN KEY (utility_id) REFERENCES Utility(utility_id),
    CONSTRAINT CK_BillDetail_Indexes
        CHECK ((old_index IS NULL AND new_index IS NULL) OR (old_index IS NOT NULL AND new_index IS NOT NULL AND new_index >= old_index))
        -- accept 1 trong 2 case ( block input ngay từ đầu )
);

/* =========================
   10. MAINTENANCE_REQUEST
   ========================= */
CREATE TABLE Maintenance_Request (
    request_id INT IDENTITY PRIMARY KEY,
    tenant_id INT NOT NULL,
    manager_id INT,
    room_id INT NOT NULL,
    request_date DATE NOT NULL,
    description NVARCHAR(500) NOT NULL,
    status NVARCHAR(20) NOT NULL,
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id),
    FOREIGN KEY (manager_id) REFERENCES Manager(manager_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
);
GO

/*
        -- DB đã validate -- 
    - role account hợp lệ
    - status account
    - status house
    - status room
    - unique trong cùng house
    - room_utility check duplicate mapping ( check utitlity )
    - status contract
    - block ngày hợp đồng ko hợp lệ
    - bill_detail block dữ liệu từ đầu

*/
