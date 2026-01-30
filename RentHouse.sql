/* =========================================================
   DROP & RECREATE DATABASE
========================================================= */
USE master;
GO

IF DB_ID(N'RentHouse') IS NOT NULL
BEGIN
    ALTER DATABASE [RentHouse] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [RentHouse];
END
GO

CREATE DATABASE [RentHouse];
GO

USE [RentHouse];
GO

/* =========================
   1) BLOCK
   ========================= */
CREATE TABLE dbo.[BLOCK] (
    block_id        INT IDENTITY(1,1) PRIMARY KEY,
    block_name      NVARCHAR(100) NOT NULL
);

/* =========================
   2) ROOM
   ========================= */
CREATE TABLE dbo.[ROOM] (
    room_id         INT IDENTITY(1,1) PRIMARY KEY,
    block_id        INT NOT NULL,
    room_number     NVARCHAR(20) NOT NULL,
    area            DECIMAL(10,2) NULL,
    price           DECIMAL(18,2) NOT NULL,
    [status]        NVARCHAR(20) NOT NULL,  -- AVAILABLE/OCCUPIED/MAINTENANCE...
    floor           INT NULL,
    max_tenants     INT NULL,
    is_mezzanine    BIT NOT NULL CONSTRAINT DF_ROOM_is_mezzanine DEFAULT(0),
    room_image      NVARCHAR(255) NULL,
    [description]   NVARCHAR(255) NULL,

    CONSTRAINT FK_ROOM_BLOCK
        FOREIGN KEY (block_id) REFERENCES dbo.[BLOCK](block_id),

    CONSTRAINT UQ_ROOM_Block_RoomNumber
        UNIQUE (block_id, room_number)
);

/* =========================
   3) STAFF
   ========================= */
CREATE TABLE dbo.[STAFF] (
    staff_id        INT IDENTITY(1,1) PRIMARY KEY,
    full_name       NVARCHAR(120) NOT NULL,
    phone_number    NVARCHAR(20) NOT NULL,
    email           NVARCHAR(255) NOT NULL,
    identity_code   NVARCHAR(20) NULL,
    date_of_birth   DATE NULL,
    gender          TINYINT NULL,
    staff_role      NVARCHAR(20) NOT NULL,  -- MANAGER/ADMIN
    password_hash   VARCHAR(64) NOT NULL,
    avatar          NVARCHAR(255) NULL,
    [status]        NVARCHAR(20) NOT NULL,  -- ACTIVE/INACTIVE...
    created_at      DATETIME2(0) NOT NULL CONSTRAINT DF_STAFF_created_at DEFAULT(SYSDATETIME()),
    updated_at      DATETIME2(0) NOT NULL CONSTRAINT DF_STAFF_updated_at DEFAULT(SYSDATETIME()),

    CONSTRAINT UQ_STAFF_email UNIQUE (email),
    CONSTRAINT UQ_STAFF_phone UNIQUE (phone_number),

    CONSTRAINT CK_STAFF_role CHECK (staff_role IN ('MANAGER','ADMIN'))
);

/* =========================
   4) TENANT
   ========================= */
CREATE TABLE dbo.[TENANT] (
    tenant_id           INT IDENTITY(1,1) PRIMARY KEY,
    full_name           NVARCHAR(120) NOT NULL,
    identity_code       NVARCHAR(20) NULL,
    phone_number        NVARCHAR(20) NOT NULL,
    email               NVARCHAR(255) NOT NULL,
    [address]           NVARCHAR(255) NULL,
    date_of_birth       DATE NULL,
    gender              TINYINT NULL,
    avatar              NVARCHAR(255) NULL,

    account_status      NVARCHAR(20) NOT NULL, -- LOCKED/ACTIVE
    password_hash       VARCHAR(64) NULL,      -- nullable trước khi set password
    must_set_password   BIT NOT NULL CONSTRAINT DF_TENANT_must_set_password DEFAULT(1),

    created_at          DATETIME2(0) NOT NULL CONSTRAINT DF_TENANT_created_at DEFAULT(SYSDATETIME()),
    updated_at          DATETIME2(0) NOT NULL CONSTRAINT DF_TENANT_updated_at DEFAULT(SYSDATETIME()),

    CONSTRAINT UQ_TENANT_email UNIQUE (email),
    CONSTRAINT UQ_TENANT_phone UNIQUE (phone_number),

    CONSTRAINT CK_TENANT_account_status CHECK (account_status IN ('LOCKED','ACTIVE'))
);


/* =========================
   5) UTILITY
   ========================= */
CREATE TABLE dbo.[UTILITY] (
    utility_id      INT IDENTITY(1,1) PRIMARY KEY,
    utility_name    NVARCHAR(100) NOT NULL,
    unit            NVARCHAR(20) NULL,          -- kWh, m3, month...
    standard_price  DECIMAL(18,2) NULL,
    is_active       BIT NOT NULL CONSTRAINT DF_UTILITY_is_active DEFAULT(1),
    [status]        NVARCHAR(20) NOT NULL CONSTRAINT DF_UTILITY_status DEFAULT('ACTIVE'),
    created_at      DATETIME2(0) NULL,
    updated_at      DATETIME2(0) NULL,

    CONSTRAINT UQ_UTILITY_name UNIQUE (utility_name)
);

/* =========================
   6) CONTRACT
   ========================= */
CREATE TABLE dbo.[CONTRACT] (
    contract_id         INT IDENTITY(1,1) PRIMARY KEY,
    room_id             INT NOT NULL,
    tenant_id           INT NOT NULL,
    created_by_staff_id INT NOT NULL,           -- manager tạo/ký
    start_date          DATE NOT NULL,
    end_date            DATE NULL,
    monthly_rent        DECIMAL(18,2) NOT NULL,
    deposit             DECIMAL(18,2) NOT NULL,
    payment_qr_data     NVARCHAR(400) NULL,
    [status]            NVARCHAR(20) NOT NULL,  -- PENDING/ACTIVE/ENDED/CANCELLED
    created_at          DATETIME2(0) NOT NULL CONSTRAINT DF_CONTRACT_created_at DEFAULT(SYSDATETIME()),
    updated_at          DATETIME2(0) NOT NULL CONSTRAINT DF_CONTRACT_updated_at DEFAULT(SYSDATETIME()),

    CONSTRAINT FK_CONTRACT_ROOM
        FOREIGN KEY (room_id) REFERENCES dbo.[ROOM](room_id),

    CONSTRAINT FK_CONTRACT_TENANT
        FOREIGN KEY (tenant_id) REFERENCES dbo.[TENANT](tenant_id),

    CONSTRAINT FK_CONTRACT_STAFF_CREATEDBY
        FOREIGN KEY (created_by_staff_id) REFERENCES dbo.[STAFF](staff_id),

    CONSTRAINT CK_CONTRACT_status CHECK ([status] IN ('PENDING','ACTIVE','ENDED','CANCELLED'))
);

/* =========================
   7) BILL  (gắn CONTRACT)
   ========================= */
CREATE TABLE dbo.[BILL] (
    bill_id             INT IDENTITY(1,1) PRIMARY KEY,
    contract_id         INT NOT NULL,
    bill_month          DATE NOT NULL,          -- lưu ngày 1 của tháng (ví dụ 2026-01-01)
    due_date            DATE NOT NULL,
    [status]            NVARCHAR(20) NOT NULL,  -- UNPAID/PAID/...
    note                NVARCHAR(255) NULL,

    old_electric_number INT NULL,
    new_electric_number INT NULL,
    old_water_number    INT NULL,
    new_water_number    INT NULL,

    CONSTRAINT FK_BILL_CONTRACT
        FOREIGN KEY (contract_id) REFERENCES dbo.[CONTRACT](contract_id),

    CONSTRAINT UQ_BILL_contract_month UNIQUE (contract_id, bill_month)
);

/* =========================
   8) BILL_DETAIL (charge_type + optional utility_id)
   ========================= */
CREATE TABLE dbo.[BILL_DETAIL] (
    bill_detail_id   INT IDENTITY(1,1) PRIMARY KEY,
    bill_id          INT NOT NULL,
    utility_id       INT NULL,                 -- chỉ dùng khi charge_type='UTILITY'
    item_name        NVARCHAR(150) NOT NULL,
    unit             NVARCHAR(20) NULL,
    quantity         DECIMAL(18,2) NOT NULL CONSTRAINT DF_BILL_DETAIL_qty DEFAULT(1),
    unit_price       DECIMAL(18,2) NOT NULL,
    charge_type      NVARCHAR(20) NOT NULL,    -- RENT/UTILITY/OTHER

    CONSTRAINT FK_BILL_DETAIL_BILL
        FOREIGN KEY (bill_id) REFERENCES dbo.[BILL](bill_id),

    CONSTRAINT FK_BILL_DETAIL_UTILITY
        FOREIGN KEY (utility_id) REFERENCES dbo.[UTILITY](utility_id),

    CONSTRAINT CK_BILL_DETAIL_charge_type
        CHECK (charge_type IN ('RENT','UTILITY','OTHER')),

    -- Nếu là UTILITY thì phải có utility_id
    CONSTRAINT CK_BILL_DETAIL_utility_required
        CHECK (
            (charge_type = 'UTILITY' AND utility_id IS NOT NULL)
            OR
            (charge_type <> 'UTILITY')
        )
);

/* =========================
   9) OTP_CODE (gắn TENANT)
   ========================= */
CREATE TABLE dbo.[OTP_CODE] (
    otp_id       INT IDENTITY(1,1) PRIMARY KEY,
    tenant_id    INT NOT NULL,
    purpose      NVARCHAR(30) NOT NULL,        -- FIRST_LOGIN/RESET_PASSWORD...
    receiver     NVARCHAR(255) NOT NULL,       -- email/phone
    otp_hash     VARCHAR(64) NOT NULL,
    expires_at   DATETIME2(0) NOT NULL,
    used_at      DATETIME2(0) NULL,

    CONSTRAINT FK_OTP_TENANT
        FOREIGN KEY (tenant_id) REFERENCES dbo.[TENANT](tenant_id)
);

/* =========================
   10) MAINTENANCE_REQUEST
   ========================= */
CREATE TABLE dbo.[MAINTENANCE_REQUEST] (
    request_id            INT IDENTITY(1,1) PRIMARY KEY,
    tenant_id             INT NOT NULL,
    room_id               INT NOT NULL,
    utility_id            INT NOT NULL,
    handled_by_staff_id   INT NULL,            -- manager xử lý (nullable lúc chưa assign)
    [description]         NVARCHAR(MAX) NOT NULL,
    image_url             NVARCHAR(255) NULL,
    [status]              NVARCHAR(20) NOT NULL,  -- PENDING/IN_PROGRESS/DONE/CANCELLED
    created_at            DATETIME2(0) NOT NULL CONSTRAINT DF_MR_created_at DEFAULT(SYSDATETIME()),
    completed_at          DATETIME2(0) NULL,

    CONSTRAINT FK_MR_TENANT
        FOREIGN KEY (tenant_id) REFERENCES dbo.[TENANT](tenant_id),

    CONSTRAINT FK_MR_ROOM
        FOREIGN KEY (room_id) REFERENCES dbo.[ROOM](room_id),

    CONSTRAINT FK_MR_UTILITY
        FOREIGN KEY (utility_id) REFERENCES dbo.[UTILITY](utility_id),

    CONSTRAINT FK_MR_STAFF
        FOREIGN KEY (handled_by_staff_id) REFERENCES dbo.[STAFF](staff_id),

    CONSTRAINT CK_MR_status CHECK ([status] IN ('PENDING','IN_PROGRESS','DONE','CANCELLED'))
);

/* =========================
   11) PAYMENT
   - Dùng cho: payment theo CONTRACT (cọc/ban đầu) hoặc theo BILL (bill tháng)
   - CHECK: chỉ 1 trong 2 FK được set
   - UNIQUE bill_id: 1 bill chỉ có 1 payment
   ========================= */
CREATE TABLE dbo.[PAYMENT] (
    payment_id     INT IDENTITY(1,1) PRIMARY KEY,
    contract_id    INT NULL,
    bill_id        INT NULL,
    method         NVARCHAR(20) NOT NULL,       -- BANK/CASH
    amount         DECIMAL(18,2) NOT NULL,
    paid_at        DATETIME2(0) NOT NULL,
    [status]       NVARCHAR(20) NOT NULL,       -- PENDING/CONFIRMED/REJECTED
    note           NVARCHAR(255) NULL,

    CONSTRAINT FK_PAYMENT_CONTRACT
        FOREIGN KEY (contract_id) REFERENCES dbo.[CONTRACT](contract_id),

    CONSTRAINT FK_PAYMENT_BILL
        FOREIGN KEY (bill_id) REFERENCES dbo.[BILL](bill_id),

    CONSTRAINT CK_PAYMENT_status CHECK ([status] IN ('PENDING','CONFIRMED','REJECTED')),

    -- Chỉ được gắn 1 trong 2: contract hoặc bill
    CONSTRAINT CK_PAYMENT_one_parent
        CHECK (
            (contract_id IS NOT NULL AND bill_id IS NULL)
            OR
            (contract_id IS NULL AND bill_id IS NOT NULL)
        )
);

CREATE UNIQUE INDEX UX_PAYMENT_bill_id
ON dbo.[PAYMENT](bill_id)
WHERE bill_id IS NOT NULL;