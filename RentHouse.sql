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
    block_id    INT IDENTITY(1,1) PRIMARY KEY,
    block_name  NVARCHAR(100) NOT NULL
);
GO

/* =========================
   2) ROOM  (NO room_image anymore)
========================= */
CREATE TABLE dbo.[ROOM] (
    room_id         INT IDENTITY(1,1) PRIMARY KEY,
    block_id        INT NOT NULL,
    room_number     NVARCHAR(20) NOT NULL,
    area            DECIMAL(10,2) NULL,
    price           DECIMAL(18,2) NOT NULL,
    [status]        NVARCHAR(20) NOT NULL,  -- AVAILABLE/OCCUPIED/MAINTENANCE/INACTIVE...
    floor           INT NULL,
    max_tenants     INT NULL,
    is_mezzanine    BIT NOT NULL CONSTRAINT DF_ROOM_is_mezzanine DEFAULT(0),
    has_air_conditioning BIT NOT NULL CONSTRAINT DF_ROOM_has_ac DEFAULT(0),
    [description]   NVARCHAR(255) NULL,

    CONSTRAINT FK_ROOM_BLOCK
        FOREIGN KEY (block_id) REFERENCES dbo.[BLOCK](block_id),

    CONSTRAINT UQ_ROOM_Block_RoomNumber
        UNIQUE (block_id, room_number),

    CONSTRAINT CK_ROOM_status
        CHECK ([status] IN ('AVAILABLE','OCCUPIED','MAINTENANCE','INACTIVE')),

    CONSTRAINT CK_ROOM_price_nonnegative
        CHECK (price >= 0),

    CONSTRAINT CK_ROOM_area_nonnegative
        CHECK (area IS NULL OR area >= 0),

    CONSTRAINT CK_ROOM_max_tenants_positive
        CHECK (max_tenants IS NULL OR max_tenants > 0)
);
GO

CREATE INDEX IX_ROOM_block_id ON dbo.[ROOM](block_id);
GO

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
    staff_role      NVARCHAR(20) NOT NULL,   -- MANAGER/ADMIN
    password_hash   VARCHAR(64) NOT NULL,
    avatar          NVARCHAR(255) NULL,
    [status]        NVARCHAR(20) NOT NULL,   -- ACTIVE/INACTIVE
    created_at      DATETIME2(0) NOT NULL CONSTRAINT DF_STAFF_created_at DEFAULT(SYSDATETIME()),
    updated_at      DATETIME2(0) NOT NULL CONSTRAINT DF_STAFF_updated_at DEFAULT(SYSDATETIME()),

    CONSTRAINT UQ_STAFF_email UNIQUE (email),
    CONSTRAINT UQ_STAFF_phone UNIQUE (phone_number),

    CONSTRAINT CK_STAFF_role CHECK (staff_role IN ('MANAGER','ADMIN')),
    CONSTRAINT CK_STAFF_status CHECK ([status] IN ('ACTIVE','INACTIVE')),
    CONSTRAINT CK_STAFF_gender CHECK (gender IS NULL OR gender IN (0,1))
);
GO

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
    password_hash       VARCHAR(64) NULL,
    must_set_password   BIT NOT NULL CONSTRAINT DF_TENANT_must_set_password DEFAULT(1),

    created_at          DATETIME2(0) NOT NULL CONSTRAINT DF_TENANT_created_at DEFAULT(SYSDATETIME()),
    updated_at          DATETIME2(0) NOT NULL CONSTRAINT DF_TENANT_updated_at DEFAULT(SYSDATETIME()),

    CONSTRAINT UQ_TENANT_email UNIQUE (email),
    CONSTRAINT UQ_TENANT_phone UNIQUE (phone_number),

    CONSTRAINT CK_TENANT_account_status CHECK (account_status IN ('LOCKED','ACTIVE','PENDING')),
    CONSTRAINT CK_TENANT_gender CHECK (gender IS NULL OR gender IN (0,1))
);
GO

/* =========================
   5) ROOM_IMAGE
========================= */
CREATE TABLE dbo.ROOM_IMAGE (
  image_id   INT IDENTITY(1,1) PRIMARY KEY,
  room_id    INT NOT NULL,
  image_url  NVARCHAR(255) NOT NULL,
  is_cover   BIT NOT NULL CONSTRAINT DF_ROOM_IMAGE_is_cover DEFAULT(0),
  sort_order INT NOT NULL CONSTRAINT DF_ROOM_IMAGE_sort DEFAULT(0),

  CONSTRAINT FK_ROOM_IMAGE_ROOM
    FOREIGN KEY (room_id) REFERENCES dbo.ROOM(room_id)
);
GO

CREATE INDEX IX_ROOM_IMAGE_room_id ON dbo.ROOM_IMAGE(room_id);
GO

-- mỗi phòng chỉ có tối đa 1 ảnh cover
CREATE UNIQUE INDEX UX_ROOM_IMAGE_one_cover
ON dbo.ROOM_IMAGE(room_id)
WHERE is_cover = 1;
GO

/* =========================
   6) UTILITY
========================= */
CREATE TABLE dbo.[UTILITY] (
    utility_id      INT IDENTITY(1,1) PRIMARY KEY,
    utility_name    NVARCHAR(100) NOT NULL,
    unit            NVARCHAR(20) NULL,
    standard_price  DECIMAL(18,2) NULL,
    is_active       BIT NOT NULL CONSTRAINT DF_UTILITY_is_active DEFAULT(1),
    [status]        NVARCHAR(20) NOT NULL CONSTRAINT DF_UTILITY_status DEFAULT('ACTIVE'),
    created_at      DATETIME2(0) NOT NULL CONSTRAINT DF_UTILITY_created_at DEFAULT(SYSDATETIME()),
    updated_at      DATETIME2(0) NOT NULL CONSTRAINT DF_UTILITY_updated_at DEFAULT(SYSDATETIME()),

    CONSTRAINT UQ_UTILITY_name UNIQUE (utility_name),
    CONSTRAINT CK_UTILITY_status CHECK ([status] IN ('ACTIVE','INACTIVE')),
    CONSTRAINT CK_UTILITY_standard_price_nonnegative CHECK (standard_price IS NULL OR standard_price >= 0)
);
GO

/* =========================
   7) CONTRACT
========================= */
CREATE TABLE dbo.[CONTRACT] (
    contract_id         INT IDENTITY(1,1) PRIMARY KEY,
    room_id             INT NOT NULL,
    tenant_id           INT NOT NULL,
    created_by_staff_id INT NOT NULL,
    start_date          DATE NOT NULL,
    end_date            DATE NULL,
    monthly_rent        DECIMAL(18,2) NOT NULL,
    deposit             DECIMAL(18,2) NOT NULL,
    payment_qr_data     NVARCHAR(400) NULL,
    [status]            NVARCHAR(20) NOT NULL,
    created_at          DATETIME2(0) NOT NULL CONSTRAINT DF_CONTRACT_created_at DEFAULT(SYSDATETIME()),
    updated_at          DATETIME2(0) NOT NULL CONSTRAINT DF_CONTRACT_updated_at DEFAULT(SYSDATETIME()),

    CONSTRAINT FK_CONTRACT_ROOM
        FOREIGN KEY (room_id) REFERENCES dbo.[ROOM](room_id),

    CONSTRAINT FK_CONTRACT_TENANT
        FOREIGN KEY (tenant_id) REFERENCES dbo.[TENANT](tenant_id),

    CONSTRAINT FK_CONTRACT_STAFF_CREATEDBY
        FOREIGN KEY (created_by_staff_id) REFERENCES dbo.[STAFF](staff_id),

    CONSTRAINT CK_CONTRACT_status CHECK ([status] IN ('PENDING','ACTIVE','ENDED','CANCELLED')),
    CONSTRAINT CK_CONTRACT_money_nonnegative CHECK (monthly_rent >= 0 AND deposit >= 0),
    CONSTRAINT CK_CONTRACT_end_after_start CHECK (end_date IS NULL OR end_date > start_date)
);
GO

CREATE INDEX IX_CONTRACT_room_id ON dbo.[CONTRACT](room_id);
CREATE INDEX IX_CONTRACT_tenant_id ON dbo.[CONTRACT](tenant_id);
CREATE INDEX IX_CONTRACT_created_by_staff_id ON dbo.[CONTRACT](created_by_staff_id);
GO

-- Business rule: mỗi phòng chỉ có tối đa 1 CONTRACT đang PENDING/ACTIVE
CREATE UNIQUE INDEX UX_CONTRACT_room_active
ON dbo.[CONTRACT](room_id)
WHERE [status] IN ('PENDING','ACTIVE');
GO

/* =========================
   8) BILL
========================= */
CREATE TABLE dbo.[BILL] (
    bill_id             INT IDENTITY(1,1) PRIMARY KEY,
    contract_id         INT NOT NULL,
    bill_month          DATE NOT NULL,
    due_date            DATE NOT NULL,
    [status]            NVARCHAR(20) NOT NULL,
    note                NVARCHAR(255) NULL,

    old_electric_number INT NULL,
    new_electric_number INT NULL,
    old_water_number    INT NULL,
    new_water_number    INT NULL,

    CONSTRAINT FK_BILL_CONTRACT
        FOREIGN KEY (contract_id) REFERENCES dbo.[CONTRACT](contract_id),

    CONSTRAINT UQ_BILL_contract_month UNIQUE (contract_id, bill_month),

    CONSTRAINT CK_BILL_status CHECK ([status] IN ('UNPAID','PAID','OVERDUE','CANCELLED')),

    CONSTRAINT CK_BILL_meter_nonnegative CHECK (
        (old_electric_number IS NULL OR old_electric_number >= 0) AND
        (new_electric_number IS NULL OR new_electric_number >= 0) AND
        (old_water_number IS NULL OR old_water_number >= 0) AND
        (new_water_number IS NULL OR new_water_number >= 0)
    ),

    CONSTRAINT CK_BILL_electric_new_ge_old CHECK (
        old_electric_number IS NULL OR new_electric_number IS NULL OR new_electric_number >= old_electric_number
    ),

    CONSTRAINT CK_BILL_water_new_ge_old CHECK (
        old_water_number IS NULL OR new_water_number IS NULL OR new_water_number >= old_water_number
    )
);
GO

CREATE INDEX IX_BILL_contract_id ON dbo.[BILL](contract_id);
GO

/* =========================
   9) BILL_DETAIL
========================= */
CREATE TABLE dbo.[BILL_DETAIL] (
    bill_detail_id   INT IDENTITY(1,1) PRIMARY KEY,
    bill_id          INT NOT NULL,
    utility_id       INT NULL,
    item_name        NVARCHAR(150) NOT NULL,
    unit             NVARCHAR(20) NULL,
    quantity         DECIMAL(18,2) NOT NULL CONSTRAINT DF_BILL_DETAIL_qty DEFAULT(1),
    unit_price       DECIMAL(18,2) NOT NULL,
    charge_type      NVARCHAR(20) NOT NULL,

    CONSTRAINT FK_BILL_DETAIL_BILL
        FOREIGN KEY (bill_id) REFERENCES dbo.[BILL](bill_id),

    CONSTRAINT FK_BILL_DETAIL_UTILITY
        FOREIGN KEY (utility_id) REFERENCES dbo.[UTILITY](utility_id),

    CONSTRAINT CK_BILL_DETAIL_charge_type
        CHECK (charge_type IN ('RENT','UTILITY','OTHER')),

    CONSTRAINT CK_BILL_DETAIL_qty_price CHECK (quantity > 0 AND unit_price >= 0),

    CONSTRAINT CK_BILL_DETAIL_utility_consistency
        CHECK (
            (charge_type = 'UTILITY' AND utility_id IS NOT NULL)
            OR
            (charge_type <> 'UTILITY' AND utility_id IS NULL)
        )
);
GO

CREATE INDEX IX_BILL_DETAIL_bill_id ON dbo.[BILL_DETAIL](bill_id);
CREATE INDEX IX_BILL_DETAIL_utility_id ON dbo.[BILL_DETAIL](utility_id) WHERE utility_id IS NOT NULL;
GO

/* =========================
   10) OTP_CODE
========================= */
CREATE TABLE dbo.[OTP_CODE] (
    otp_id       INT IDENTITY(1,1) PRIMARY KEY,
    tenant_id    INT NOT NULL,
    purpose      NVARCHAR(30) NOT NULL,
    receiver     NVARCHAR(255) NOT NULL,
    otp_hash     VARCHAR(64) NOT NULL,
    expires_at   DATETIME2(0) NOT NULL,
    used_at      DATETIME2(0) NULL,

    CONSTRAINT FK_OTP_TENANT
        FOREIGN KEY (tenant_id) REFERENCES dbo.[TENANT](tenant_id)
);
GO

CREATE INDEX IX_OTP_CODE_tenant_expires ON dbo.[OTP_CODE](tenant_id, expires_at);
GO

/* =========================
   11) MAINTENANCE_REQUEST
========================= */
CREATE TABLE dbo.[MAINTENANCE_REQUEST] (
    request_id            INT IDENTITY(1,1) PRIMARY KEY,
    tenant_id             INT NOT NULL,
    room_id               INT NOT NULL,

    issue_category        NVARCHAR(20) NOT NULL,
    utility_id            INT NULL,

    handled_by_staff_id   INT NULL,
    [description]         NVARCHAR(MAX) NOT NULL,
    image_url             NVARCHAR(255) NULL,
    [status]              NVARCHAR(20) NOT NULL,
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

    CONSTRAINT CK_MR_status
        CHECK ([status] IN ('PENDING','IN_PROGRESS','DONE','CANCELLED')),

    CONSTRAINT CK_MR_issue_category
        CHECK (issue_category IN ('ELECTRIC','WATER','OTHER')),

    CONSTRAINT CK_MR_issue_utility
        CHECK (
            (issue_category = 'OTHER' AND utility_id IS NULL)
            OR
            (issue_category IN ('ELECTRIC','WATER') AND utility_id IS NOT NULL)
        )
);
GO

CREATE INDEX IX_MR_tenant_id ON dbo.[MAINTENANCE_REQUEST](tenant_id);
CREATE INDEX IX_MR_room_id ON dbo.[MAINTENANCE_REQUEST](room_id);
CREATE INDEX IX_MR_issue_category ON dbo.[MAINTENANCE_REQUEST](issue_category);
CREATE INDEX IX_MR_utility_id ON dbo.[MAINTENANCE_REQUEST](utility_id) WHERE utility_id IS NOT NULL;
CREATE INDEX IX_MR_handled_by_staff_id ON dbo.[MAINTENANCE_REQUEST](handled_by_staff_id) WHERE handled_by_staff_id IS NOT NULL;
GO

/* =========================
   12) PAYMENT
========================= */
CREATE TABLE dbo.[PAYMENT] (
    payment_id     INT IDENTITY(1,1) PRIMARY KEY,
    contract_id    INT NULL,
    bill_id        INT NULL,
    method         NVARCHAR(20) NOT NULL,
    amount         DECIMAL(18,2) NOT NULL,
    paid_at        DATETIME2(0) NOT NULL,
    [status]       NVARCHAR(20) NOT NULL,
    note           NVARCHAR(255) NULL,

    CONSTRAINT FK_PAYMENT_CONTRACT
        FOREIGN KEY (contract_id) REFERENCES dbo.[CONTRACT](contract_id),

    CONSTRAINT FK_PAYMENT_BILL
        FOREIGN KEY (bill_id) REFERENCES dbo.[BILL](bill_id),

    CONSTRAINT CK_PAYMENT_status CHECK ([status] IN ('PENDING','CONFIRMED','REJECTED')),
    CONSTRAINT CK_PAYMENT_method CHECK (method IN ('BANK','CASH')),
    CONSTRAINT CK_PAYMENT_amount CHECK (amount > 0),

    CONSTRAINT CK_PAYMENT_one_parent
        CHECK (
            (contract_id IS NOT NULL AND bill_id IS NULL)
            OR
            (contract_id IS NULL AND bill_id IS NOT NULL)
        )
);
GO

CREATE INDEX IX_PAYMENT_contract_id ON dbo.[PAYMENT](contract_id) WHERE contract_id IS NOT NULL;
CREATE UNIQUE INDEX UX_PAYMENT_bill_id ON dbo.[PAYMENT](bill_id) WHERE bill_id IS NOT NULL;
GO

/* =========================================================
   SEED DATA
========================================================= */
SET NOCOUNT ON;
GO

/* =========================
   1) BLOCK
========================= */
INSERT INTO dbo.[BLOCK](block_name) VALUES (N'Khu A');
INSERT INTO dbo.[BLOCK](block_name) VALUES (N'Khu B');
GO

/* =========================
   2) ROOM (more data for Home)
========================= */
INSERT INTO dbo.[ROOM](block_id, room_number, area, price, [status], floor, max_tenants, is_mezzanine, has_air_conditioning, [description])
VALUES
-- Khu A
(1, N'A101', 18.00, 2500000, 'OCCUPIED',    1, 2, 0, 1, N'Phòng sạch, có cửa sổ'),
(1, N'A102', 20.00, 2800000, 'AVAILABLE',   1, 2, 0, 0, N'Phòng thoáng, gần cầu thang'),
(1, N'A103', 22.00, 3200000, 'AVAILABLE',   1, 2, 0, 1, N'Phòng sáng, cửa sổ lớn'),
(1, N'A104', 25.00, 3500000, 'AVAILABLE',   1, 3, 1, 1, N'Có gác lửng, rộng rãi'),
(1, N'A201', 18.00, 2700000, 'AVAILABLE',   2, 2, 0, 0, N'View thoáng, tầng 2'),
(1, N'A202', 30.00, 4200000, 'AVAILABLE',   2, 4, 1, 1, N'Gác lửng, phù hợp nhóm bạn'),
(1, N'A203', 16.00, 2400000, 'MAINTENANCE', 2, 1, 0, 0, N'Đang sửa chữa nhỏ'),

-- Khu B
(2, N'B101', 20.00, 2900000, 'AVAILABLE',   1, 2, 0, 1, N'Gần thang máy, tiện đi lại'),
(2, N'B102', 24.00, 3400000, 'AVAILABLE',   1, 3, 1, 1, N'Có gác lửng, bếp rộng'),
(2, N'B103', 15.00, 2200000, 'AVAILABLE',   1, 1, 0, 0, N'Phòng nhỏ gọn, tiết kiệm'),
(2, N'B201', 16.00, 2300000, 'AVAILABLE',   2, 2, 0, 0, N'Phòng nhỏ gọn, yên tĩnh'),
(2, N'B202', 22.00, 3000000, 'MAINTENANCE', 2, 3, 1, 1, N'Đang sửa điện nước'),
(2, N'B203', 18.00, 2600000, 'AVAILABLE',   2, 2, 0, 0, N'Yên tĩnh, phù hợp học tập'),
(2, N'B204', 28.00, 4000000, 'OCCUPIED',    2, 3, 1, 1, N'Đang có người thuê');
GO

/* =========================
   3) ROOM_IMAGE (seed multiple images, safe by room_number)
========================= */
INSERT INTO dbo.ROOM_IMAGE(room_id, image_url, is_cover, sort_order)
SELECT r.room_id, v.image_url, v.is_cover, v.sort_order
FROM (VALUES
  -- A102
  (N'Khu A', N'A102', N'a102_1.jpg', 1, 1),
  (N'Khu A', N'A102', N'a102_2.jpg', 0, 2),
  (N'Khu A', N'A102', N'a102_3.jpg', 0, 3),

  -- A103
  (N'Khu A', N'A103', N'a103_1.jpg', 1, 1),
  (N'Khu A', N'A103', N'a103_2.jpg', 0, 2),

  -- A104
  (N'Khu A', N'A104', N'a104_1.jpg', 1, 1),
  (N'Khu A', N'A104', N'a104_2.jpg', 0, 2),
  (N'Khu A', N'A104', N'a104_3.jpg', 0, 3),

  -- A201
  (N'Khu A', N'A201', N'a201_1.jpg', 1, 1),

  -- A202
  (N'Khu A', N'A202', N'a202_1.jpg', 1, 1),
  (N'Khu A', N'A202', N'a202_2.jpg', 0, 2),

  -- B101
  (N'Khu B', N'B101', N'b101_1.jpg', 1, 1),
  (N'Khu B', N'B101', N'b101_2.jpg', 0, 2),

  -- B102
  (N'Khu B', N'B102', N'b102_1.jpg', 1, 1),
  (N'Khu B', N'B102', N'b102_2.jpg', 0, 2),

  -- B103
  (N'Khu B', N'B103', N'b103_1.jpg', 1, 1),

  -- B201
  (N'Khu B', N'B201', N'b201_1.jpg', 1, 1),
  (N'Khu B', N'B201', N'b201_2.jpg', 0, 2),

  -- B203
  (N'Khu B', N'B203', N'b203_1.jpg', 1, 1),
  (N'Khu B', N'B203', N'b203_2.jpg', 0, 2)
) AS v(block_name, room_number, image_url, is_cover, sort_order)
JOIN dbo.[BLOCK] b ON b.block_name = v.block_name
JOIN dbo.[ROOM]  r ON r.block_id = b.block_id AND r.room_number = v.room_number
WHERE NOT EXISTS (
  SELECT 1 FROM dbo.ROOM_IMAGE i
  WHERE i.room_id = r.room_id AND i.image_url = v.image_url
);
GO

/* =========================
   AUTO SET COVER: room có ảnh nhưng chưa có cover
   Rule: chọn ảnh có sort_order nhỏ nhất
========================= */
UPDATE i
SET is_cover = 1
FROM dbo.ROOM_IMAGE i
JOIN (
    SELECT room_id, MIN(sort_order) AS min_sort
    FROM dbo.ROOM_IMAGE
    WHERE room_id NOT IN (SELECT room_id FROM dbo.ROOM_IMAGE WHERE is_cover = 1)
    GROUP BY room_id
) m ON m.room_id = i.room_id AND m.min_sort = i.sort_order
WHERE i.room_id NOT IN (SELECT room_id FROM dbo.ROOM_IMAGE WHERE is_cover = 1);
GO

/* =========================
   4) STAFF
   MD5 demo: "test" = e10adc3949ba59abbe56e057f20f883e
========================= */
INSERT INTO dbo.[STAFF](full_name, phone_number, email, identity_code, date_of_birth, gender, staff_role, password_hash, avatar, [status])
VALUES
(N'Trần Minh Khoa', N'0901000001', N'khoa.tran@renthouse.test', N'012345678901', '1996-04-12', 1, 'MANAGER',
 'e10adc3949ba59abbe56e057f20f883e', NULL, 'ACTIVE');

INSERT INTO dbo.[STAFF](full_name, phone_number, email, identity_code, date_of_birth, gender, staff_role, password_hash, avatar, [status])
VALUES
(N'Phạm Thảo Nguyên', N'0901000002', N'nguyen.pham@renthouse.test', N'012345678902', '1998-09-10', 0, 'ADMIN',
 'e10adc3949ba59abbe56e057f20f883e', NULL, 'ACTIVE');
GO

/* =========================
   5) TENANT
========================= */
INSERT INTO dbo.[TENANT](full_name, identity_code, phone_number, email, [address], date_of_birth, gender, avatar,
                         account_status, password_hash, must_set_password)
VALUES
(N'Võ Gia Hân',   N'079201000001', N'0912000001', N'han.vo@tenant.test',   N'TP. Hồ Chí Minh', '2002-01-15', 0, NULL,
 'ACTIVE', 'e10adc3949ba59abbe56e057f20f883e', 0);

INSERT INTO dbo.[TENANT](full_name, identity_code, phone_number, email, [address], date_of_birth, gender, avatar,
                         account_status, password_hash, must_set_password)
VALUES
(N'Đặng Quốc Bảo', N'079201000002', N'0912000002', N'bao.dang@tenant.test', N'Bình Dương',     '2000-07-22', 1, NULL,
 'ACTIVE', NULL, 1);

INSERT INTO dbo.[TENANT](full_name, identity_code, phone_number, email, [address], date_of_birth, gender, avatar,
                         account_status, password_hash, must_set_password)
VALUES
(N'Lê Nhật Linh',  N'079201000003', N'0912000003', N'linh.le@tenant.test',  N'Đồng Nai',       '2001-11-03', 0, NULL,
 'LOCKED', NULL, 1);
GO

/* =========================
   6) UTILITY
========================= */
INSERT INTO dbo.[UTILITY](utility_name, unit, standard_price, is_active, [status])
VALUES
(N'Electric', N'kWh', 3500, 1, 'ACTIVE');

INSERT INTO dbo.[UTILITY](utility_name, unit, standard_price, is_active, [status])
VALUES
(N'Water', N'm3', 18000, 1, 'ACTIVE');

INSERT INTO dbo.[UTILITY](utility_name, unit, standard_price, is_active, [status])
VALUES
(N'Internet', N'month', 100000, 1, 'ACTIVE');
GO

/* =========================
   7) CONTRACT
   NOTE: IDENTITY assumption based on insert order above:
   - Room A101 is first => room_id = 1
   - This is safe if seed order is not changed
========================= */
INSERT INTO dbo.[CONTRACT](room_id, tenant_id, created_by_staff_id, start_date, end_date, monthly_rent, deposit, payment_qr_data, [status])
VALUES
(1, 1, 1, '2026-01-01', '2026-12-31', 2500000, 2500000, NULL, 'ACTIVE');

INSERT INTO dbo.[CONTRACT](room_id, tenant_id, created_by_staff_id, start_date, end_date, monthly_rent, deposit, payment_qr_data, [status])
VALUES
(2, 2, 1, '2026-02-01', '2027-01-31', 2800000, 2800000, NULL, 'PENDING');
GO

/* =========================
   8) BILL (for contract_id = 1)
========================= */
INSERT INTO dbo.[BILL](contract_id, bill_month, due_date, [status], note,
                       old_electric_number, new_electric_number, old_water_number, new_water_number)
VALUES
(1, '2026-01-01', '2026-01-05', 'UNPAID', N'Hóa đơn tháng 01/2026',
 120, 150, 30, 35);

INSERT INTO dbo.[BILL](contract_id, bill_month, due_date, [status], note,
                       old_electric_number, new_electric_number, old_water_number, new_water_number)
VALUES
(1, '2026-02-01', '2026-02-05', 'PAID', N'Hóa đơn tháng 02/2026',
 150, 175, 35, 40);
GO

/* =========================
   9) BILL_DETAIL
========================= */
INSERT INTO dbo.[BILL_DETAIL](bill_id, utility_id, item_name, unit, quantity, unit_price, charge_type)
VALUES (1, NULL, N'Tiền phòng tháng 01/2026', N'month', 1, 2500000, 'RENT');

INSERT INTO dbo.[BILL_DETAIL](bill_id, utility_id, item_name, unit, quantity, unit_price, charge_type)
VALUES (1, 1, N'Tiền điện tháng 01/2026', N'kWh', 30, 3500, 'UTILITY');

INSERT INTO dbo.[BILL_DETAIL](bill_id, utility_id, item_name, unit, quantity, unit_price, charge_type)
VALUES (1, 2, N'Tiền nước tháng 01/2026', N'm3', 5, 18000, 'UTILITY');

INSERT INTO dbo.[BILL_DETAIL](bill_id, utility_id, item_name, unit, quantity, unit_price, charge_type)
VALUES (1, 3, N'Internet tháng 01/2026', N'month', 1, 100000, 'UTILITY');

INSERT INTO dbo.[BILL_DETAIL](bill_id, utility_id, item_name, unit, quantity, unit_price, charge_type)
VALUES (2, NULL, N'Tiền phòng tháng 02/2026', N'month', 1, 2500000, 'RENT');

INSERT INTO dbo.[BILL_DETAIL](bill_id, utility_id, item_name, unit, quantity, unit_price, charge_type)
VALUES (2, 1, N'Tiền điện tháng 02/2026', N'kWh', 25, 3500, 'UTILITY');

INSERT INTO dbo.[BILL_DETAIL](bill_id, utility_id, item_name, unit, quantity, unit_price, charge_type)
VALUES (2, 2, N'Tiền nước tháng 02/2026', N'm3', 5, 18000, 'UTILITY');

INSERT INTO dbo.[BILL_DETAIL](bill_id, utility_id, item_name, unit, quantity, unit_price, charge_type)
VALUES (2, 3, N'Internet tháng 02/2026', N'month', 1, 100000, 'UTILITY');
GO

/* =========================
   10) PAYMENT
========================= */
INSERT INTO dbo.[PAYMENT](contract_id, bill_id, method, amount, paid_at, [status], note)
VALUES
(NULL, 2, 'BANK', 2787500, '2026-02-03 10:30:00', 'CONFIRMED', N'Đã thanh toán hóa đơn tháng 02');
GO

/* =========================
   11) OTP_CODE
========================= */
INSERT INTO dbo.[OTP_CODE](tenant_id, purpose, receiver, otp_hash, expires_at, used_at)
VALUES
(2, 'FIRST_LOGIN', N'bao.dang@tenant.test', 'e10adc3949ba59abbe56e057f20f883e', DATEADD(MINUTE, 10, SYSDATETIME()), NULL);
GO

/* =========================
   12) MAINTENANCE_REQUEST
========================= */
INSERT INTO dbo.[MAINTENANCE_REQUEST](tenant_id, room_id, issue_category, utility_id, handled_by_staff_id,
                                      [description], image_url, [status], created_at, completed_at)
VALUES
(1, 1, 'ELECTRIC', 1, NULL, N'Đèn phòng bị chập chờn, nhờ kiểm tra giúp.', NULL, 'PENDING', SYSDATETIME(), NULL);

INSERT INTO dbo.[MAINTENANCE_REQUEST](tenant_id, room_id, issue_category, utility_id, handled_by_staff_id,
                                      [description], image_url, [status], created_at, completed_at)
VALUES
(1, 1, 'WATER', 2, 1, N'Vòi nước rò rỉ nhẹ, cần thay ron.', NULL, 'IN_PROGRESS', SYSDATETIME(), NULL);

INSERT INTO dbo.[MAINTENANCE_REQUEST](tenant_id, room_id, issue_category, utility_id, handled_by_staff_id,
                                      [description], image_url, [status], created_at, completed_at)
VALUES
(1, 1, 'OTHER', NULL, 1, N'Cửa phòng bị kẹt, mở khó.', NULL, 'DONE', SYSDATETIME(), SYSDATETIME());
GO
