CREATE TABLE Patients (
    patient_id        INT PRIMARY KEY,
    full_name         VARCHAR2(100),
    age               INT,
    mobile            VARCHAR2(20),
    blood_group       VARCHAR2(10),
    gender            VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    email             VARCHAR2(100),
    address           VARCHAR2(100),
    patient_type      VARCHAR2(20) CHECK (patient_type IN ('Inpatient', 'Outpatient')),
    pt_username       VARCHAR2(50) UNIQUE,
    pt_password       VARCHAR2(100), -- Store hashed/encrypted password in future
    patient_history   CLOB
);
--password_hash

CREATE OR REPLACE PROCEDURE insert_patient(
    p_id IN INT,
    p_name IN VARCHAR2,
    p_age IN INT,
    p_mobile IN VARCHAR2,
    p_blood_group IN VARCHAR2,
    p_gender IN VARCHAR2,
    p_email IN VARCHAR2,
    p_address IN VARCHAR2,
    p_type IN VARCHAR2,
    p_username IN VARCHAR2,
    p_password_raw IN VARCHAR2,
    p_history IN CLOB
)
IS
    hashed_pw VARCHAR2(64);
BEGIN
    hashed_pw := STANDARD_HASH(p_password_raw, 'SHA256');

    INSERT INTO Patients (
        patient_id, full_name, age, mobile, blood_group, gender,
        email, address, patient_type, pt_username, pt_password, patient_history
    ) VALUES (
        p_id, p_name, p_age, p_mobile, p_blood_group, p_gender,
        p_email, p_address, p_type, p_username, hashed_pw, p_history
    );

    DBMS_OUTPUT.PUT_LINE('Patient inserted with hashed password.');
END;
/
--create department table
CREATE TABLE Departments (
    department_id     INT PRIMARY KEY,
    department_name   VARCHAR2(100),
    department_head   VARCHAR2(100)
);
-- create doctor table
CREATE TABLE Doctors (
    doctor_id           INT PRIMARY KEY,
    full_name           VARCHAR2(100),
    age                 INT,
    mobile              VARCHAR2(20),
    qualification       VARCHAR2(100),
    gender              VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    email               VARCHAR2(100),
    specialization      VARCHAR2(100),
    experience          INT,
    department_id       INT,
    dr_username         VARCHAR2(50) UNIQUE,
    dr_password         VARCHAR2(64),  -- Hashed using STANDARD_HASH
    shift               VARCHAR2(10) CHECK (shift IN ('Morning', 'Evening', 'Night')),
    consultation_fees   DECIMAL(10,2),
    availability_status VARCHAR2(20) CHECK (availability_status IN ('Available', 'Busy', 'On Leave')),

    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
--passhash_doctor
CREATE OR REPLACE PROCEDURE insert_doctor(
    p_id                IN INT,
    p_name              IN VARCHAR2,
    p_age               IN INT,
    p_mobile            IN VARCHAR2,
    p_qualification     IN VARCHAR2,
    p_gender            IN VARCHAR2,
    p_email             IN VARCHAR2,
    p_specialization    IN VARCHAR2,
    p_experience        IN INT,
    p_department_id     IN INT,
    p_username          IN VARCHAR2,
    p_password_raw      IN VARCHAR2,
    p_shift             IN VARCHAR2,
    p_fees              IN DECIMAL,
    p_status            IN VARCHAR2
)
IS
    hashed_pw VARCHAR2(64);
BEGIN
    hashed_pw := STANDARD_HASH(p_password_raw, 'SHA256');

    INSERT INTO Doctors (
        doctor_id, full_name, age, mobile, qualification, gender, email,
        specialization, experience, department_id, dr_username,
        dr_password, shift, consultation_fees, availability_status
    )
    VALUES (
        p_id, p_name, p_age, p_mobile, p_qualification, p_gender, p_email,
        p_specialization, p_experience, p_department_id, p_username,
        hashed_pw, p_shift, p_fees, p_status
    );

    DBMS_OUTPUT.PUT_LINE('Doctor inserted successfully with hashed password.');
END;
/
-- create appointment 
CREATE TABLE Appointment (
    appointment_id       INT PRIMARY KEY,
    patient_id           INT,
    doctor_id            INT,
    booking_date         DATE,
    appointment_date     DATE,
    appointment_time     VARCHAR2(20),
    appointment_status   VARCHAR2(20) CHECK (appointment_status IN ('Scheduled', 'Completed', 'Cancelled')),
    problem_description   VARCHAR2(255),
    booking_type         VARCHAR2(20) CHECK (booking_type IN ('Online', 'Walk-in')),

    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

--create room table
CREATE TABLE Room (
    room_id          INT PRIMARY KEY,
    room_number      VARCHAR2(10) UNIQUE,
    room_type        VARCHAR2(50) CHECK (room_type IN ('ICU', 'General', 'Private', 'Semi-Private')),
    room_status      VARCHAR2(20) CHECK (room_status IN ('Available', 'Occupied', 'Cleaning')),
    room_charge      DECIMAL(10, 2),
    appointment_id   INT,

    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

-- login _ audit monitor the user login
CREATE TABLE Login_Audit (
    log_id        INT PRIMARY KEY,
    user_type     VARCHAR2(20),
    username      VARCHAR2(50),
    login_time    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status        VARCHAR2(20) CHECK (status IN ('Success', 'Failed'))
);

--room assign table 
CREATE TABLE Room_Assignment (
    assignment_id     INT PRIMARY KEY,
    room_id           INT,
    patient_id        INT,
    appointment_id    INT,
    assign_date       DATE,
    discharge_date    DATE,

    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

--create staff table
CREATE TABLE Staffs (
    staff_id         INT PRIMARY KEY,
    full_name        VARCHAR2(100),
    age              INT,
    mobile           VARCHAR2(20),
    gender           VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    staff_role       VARCHAR2(50) CHECK (staff_role IN ('Receptionist', 'Nurse', 'Lab Assistant', 'Admin')),
    salary           DECIMAL(10,2),
    staff_username   VARCHAR2(50) UNIQUE,
    staff_password   VARCHAR2(64),  -- Hashed password
    department_id    INT,

    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
-- staff pass_hash
CREATE OR REPLACE PROCEDURE insert_staff(
    p_id            IN INT,
    p_name          IN VARCHAR2,
    p_age           IN INT,
    p_mobile        IN VARCHAR2,
    p_gender        IN VARCHAR2,
    p_role          IN VARCHAR2,
    p_salary        IN DECIMAL,
    p_username      IN VARCHAR2,
    p_password_raw  IN VARCHAR2,
    p_dept_id       IN INT
)
IS
    hashed_pw VARCHAR2(64);
BEGIN
    hashed_pw := STANDARD_HASH(p_password_raw, 'SHA256');

    INSERT INTO Staffs (
        staff_id, full_name, age, mobile, gender, staff_role,
        salary, staff_username, staff_password, department_id
    ) VALUES (
        p_id, p_name, p_age, p_mobile, p_gender, p_role,
        p_salary, p_username, hashed_pw, p_dept_id
    );

    DBMS_OUTPUT.PUT_LINE('Staff inserted successfully.');
END;
/

-- inventory
CREATE TABLE Inventory (
    item_id         INT PRIMARY KEY,
    item_name       VARCHAR2(100) UNIQUE,
    item_type       VARCHAR2(50) CHECK (item_type IN ('Medicine', 'Equipment', 'Syringe', 'IV', 'Other')),
    quantity        INT,
    unit_price      DECIMAL(10, 2),
    expiry_date     DATE,
    alert_status    VARCHAR2(10) DEFAULT 'OK' CHECK (alert_status IN ('OK', 'LOW'))
);
--trigger for low stock
CREATE OR REPLACE TRIGGER check_stock_level
BEFORE UPDATE ON Inventory
FOR EACH ROW
BEGIN
    IF :NEW.quantity < 10 THEN
        :NEW.alert_status := 'LOW';
        DBMS_OUTPUT.PUT_LINE('⚠️ Low stock: ' || :NEW.item_name || ' — only ' || :NEW.quantity || ' left.');
    ELSE
        :NEW.alert_status := 'OK';
    END IF;
END;
/

--servies table 
CREATE TABLE Services (
    service_id       INT PRIMARY KEY,
    service_name     VARCHAR2(100) UNIQUE,
    service_charge   DECIMAL(10, 2)
);
--create table billing 
CREATE TABLE Billing (
    bill_id           INT PRIMARY KEY,
    appointment_id    INT,
    bill_date         DATE,
    total_amount      DECIMAL(10, 2),
    paid_amount       DECIMAL(10, 2),
    due_amount        DECIMAL(10, 2),
    payment_status    VARCHAR2(20) CHECK (payment_status IN ('Paid', 'Unpaid', 'Pending')),

    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);
--create a bill_detail
CREATE TABLE Billing_Details (
    bill_detail_id    INT PRIMARY KEY,
    bill_id           INT,
    service_id        INT,
    quantity          INT,
    amount            DECIMAL(10, 2),

    FOREIGN KEY (bill_id) REFERENCES Billing(bill_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);
--update total bill amount
CREATE OR REPLACE PROCEDURE update_total_bill_amount (
    p_bill_id IN INT
)
IS
    v_service_total   DECIMAL(10,2) := 0;
    v_medicine_total  DECIMAL(10,2) := 0;
    v_total           DECIMAL(10,2) := 0;
BEGIN
    -- Sum of service charges
    SELECT NVL(SUM(amount), 0)
    INTO v_service_total
    FROM Billing_Details
    WHERE bill_id = p_bill_id;

    -- Sum of medicine charges
    SELECT NVL(SUM(amount), 0)
    INTO v_medicine_total
    FROM Medicine_Billing
    WHERE bill_id = p_bill_id;

    -- Total = services + medicines
    v_total := v_service_total + v_medicine_total;

    -- Update Billing table
    UPDATE Billing
    SET total_amount = v_total,
        due_amount = v_total  -- paid_amount = 0 initially
    WHERE bill_id = p_bill_id;

    DBMS_OUTPUT.PUT_LINE('✅ Total bill updated: ' || v_total || ' for Bill ID: ' || p_bill_id);
END;
/
-- medicine_billing 
CREATE TABLE Medicine_Billing (
    med_bill_id     INT PRIMARY KEY,
    bill_id         INT,
    item_id         INT,
    quantity        INT,
    amount          DECIMAL(10,2),

    FOREIGN KEY (bill_id) REFERENCES Billing(bill_id),
    FOREIGN KEY (item_id) REFERENCES Inventory(item_id)
);


-- cal_ pay bill and due amount   
CREATE OR REPLACE PROCEDURE pay_bill (
    p_bill_id      IN INT,
    p_payment_amt  IN DECIMAL
)
IS
    v_paid_amount   DECIMAL(10,2);
    v_total_amount  DECIMAL(10,2);
    v_new_paid      DECIMAL(10,2);
    v_new_due       DECIMAL(10,2);
BEGIN
    -- Get current paid and total amount
    SELECT paid_amount, total_amount INTO v_paid_amount, v_total_amount
    FROM Billing WHERE bill_id = p_bill_id;

    -- Add new payment
    v_new_paid := v_paid_amount + p_payment_amt;
    v_new_due := v_total_amount - v_new_paid;

    -- Update billing record
    UPDATE Billing
    SET paid_amount = v_new_paid,
        due_amount = v_new_due,
        payment_status = CASE 
                            WHEN v_new_due = 0 THEN 'Paid'
                            ELSE 'Pending'
                         END
    WHERE bill_id = p_bill_id;

    DBMS_OUTPUT.PUT_LINE('✅ Payment recorded. Paid: ' || v_new_paid || ', Due: ' || v_new_due);
END;
/
--  Pay bill partially or fully
BEGIN
    pay_bill(101, 5000);
END;
/
--Room Charges + Doctor Fee to Billing
CREATE OR REPLACE PROCEDURE update_total_bill_amount (
    p_bill_id IN INT
)
IS
    v_service_total   DECIMAL(10,2) := 0;
    v_medicine_total  DECIMAL(10,2) := 0;
    v_room_charge     DECIMAL(10,2) := 0;
    v_doctor_fee      DECIMAL(10,2) := 0;
    v_total           DECIMAL(10,2) := 0;
    v_appointment_id  INT;
    v_room_id         INT;
    v_doctor_id       INT;
BEGIN
    -- Get appointment_id from bill
    SELECT appointment_id INTO v_appointment_id
    FROM Billing WHERE bill_id = p_bill_id;

    -- Get room_id and doctor_id from appointment
    SELECT ra.room_id, a.doctor_id
    INTO v_room_id, v_doctor_id
    FROM Room_Assignment ra
    JOIN Appointment a ON ra.appointment_id = a.appointment_id
    WHERE ra.appointment_id = v_appointment_id;

    -- Get doctor fee
    SELECT consultation_fees  INTO v_doctor_fee
    FROM Doctors WHERE doctor_id = v_doctor_id;

    -- Get room charge
    SELECT room_charge INTO v_room_charge
    FROM Room WHERE room_id = v_room_id;

    -- Get service total
    SELECT NVL(SUM(amount), 0) INTO v_service_total
    FROM Billing_Details WHERE bill_id = p_bill_id;

    -- Get medicine total
    SELECT NVL(SUM(amount), 0) INTO v_medicine_total
    FROM Medicine_Billing WHERE bill_id = p_bill_id;

    -- Final total
    v_total := v_service_total + v_medicine_total + v_room_charge + v_doctor_fee;

    -- Update billing
    UPDATE Billing
    SET total_amount = v_total,
        due_amount = v_total
    WHERE bill_id = p_bill_id;

    DBMS_OUTPUT.PUT_LINE('✅ Total Updated. Room: ' || v_room_charge || ', Doctor: ' || v_doctor_fee ||
                         ', Services: ' || v_service_total || ', Medicines: ' || v_medicine_total ||
                         ', Final: ' || v_total);
END;
/
--  Recalculate total with all charges
BEGIN
    update_total_bill_amount(101);
END;
/
-- billing history view
CREATE OR REPLACE VIEW Billing_History_View AS
SELECT
    b.bill_id,
    a.appointment_id,
    p.patient_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    d.specialization,
    r.room_type,
    s.service_name,
    bd.quantity AS service_qty,
    bd.amount   AS service_amount,
    i.item_name AS medicine_name,
    mb.quantity AS medicine_qty,
    mb.amount   AS medicine_amount,
    b.total_amount,
    b.paid_amount,
    b.due_amount,
    b.payment_status,
    b.bill_date
FROM Billing b
JOIN Appointment a ON b.appointment_id = a.appointment_id
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
LEFT JOIN Room_Assignment ra ON a.appointment_id = ra.appointment_id
LEFT JOIN Room r ON ra.room_id = r.room_id
LEFT JOIN Billing_Details bd ON b.bill_id = bd.bill_id
LEFT JOIN Services s ON bd.service_id = s.service_id
LEFT JOIN Medicine_Billing mb ON b.bill_id = mb.bill_id
LEFT JOIN Inventory i ON mb.item_id = i.item_id;

-- use this query to view the view SELECT * FROM Billing_History_View WHERE patient_id = 101;
-- create discharge summary
CREATE TABLE Discharge_Summary (
    summary_id         INT PRIMARY KEY,
    appointment_id     INT UNIQUE,
    discharge_date     DATE,
    diagnosis          CLOB,
    treatment_given    CLOB,
    follow_up_advice   CLOB,
    doctor_remarks     CLOB,

    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);
-- discharge view 
CREATE OR REPLACE VIEW Discharge_View AS
SELECT
    ds.summary_id,
    ds.discharge_date,
    p.patient_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    r.room_id,
    r.room_type,
    ds.diagnosis,
    ds.treatment_given,
    ds.follow_up_advice,
    ds.doctor_remarks
FROM Discharge_Summary ds
JOIN Appointment a ON ds.appointment_id = a.appointment_id
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
LEFT JOIN Room_Assignment ra ON a.appointment_id = ra.appointment_id
LEFT JOIN Room r ON ra.room_id = r.room_id;

-- query SELECT * FROM Discharge_View WHERE patient_id = 101;

-------------------------------------------------------------------------------------------

----< Patient_Dashboard_View >---
CREATE OR REPLACE VIEW Patient_Dashboard_View AS
SELECT
    p.patient_id,
    p.full_name AS patient_name,
    a.appointment_id,
    a.appointment_date,
    a.appointment_status,
    b.bill_id,
    b.total_amount,
    b.paid_amount,
    b.due_amount,
    b.payment_status,
    s.service_name,
    bd.amount AS service_cost,
    i.item_name AS medicine_name,
    mb.amount AS medicine_cost
FROM Patients p
JOIN Appointment a ON p.patient_id = a.patient_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
LEFT JOIN Billing_Details bd ON b.bill_id = bd.bill_id
LEFT JOIN Services s ON bd.service_id = s.service_id
LEFT JOIN Medicine_Billing mb ON b.bill_id = mb.bill_id
LEFT JOIN Inventory i ON mb.item_id = i.item_id;
----SELECT * FROM Patient_Dashboard_View WHERE patient_id = 101;

--Doctor_Dashboard_View
CREATE OR REPLACE VIEW Doctor_Dashboard_View AS
SELECT
    d.doctor_id,
    d.full_name AS doctor_name,
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    a.appointment_status,
    p.patient_id,
    p.full_name AS patient_name,
    p.gender,
    p.age,
    a.problem_description,
    ds.discharge_date,
    r.room_id,
    r.room_type
FROM Doctors d
JOIN Appointment a ON d.doctor_id = a.doctor_id
JOIN Patients p ON a.patient_id = p.patient_id
LEFT JOIN Discharge_Summary ds ON a.appointment_id = ds.appointment_id
LEFT JOIN Room_Assignment ra ON a.appointment_id = ra.appointment_id
LEFT JOIN Room r ON ra.room_id = r.room_id;

---SELECT * FROM Doctor_Dashboard_View WHERE doctor_id = 201;
--Staff_Dashboard_View
CREATE OR REPLACE VIEW Staff_Dashboard_View AS
SELECT
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    a.appointment_status,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    r.room_id,
    r.room_type,
    b.total_amount,
    b.paid_amount,
    b.due_amount,
    ds.discharge_date
FROM Appointment a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
LEFT JOIN Room_Assignment ra ON a.appointment_id = ra.appointment_id
LEFT JOIN Room r ON ra.room_id = r.room_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
LEFT JOIN Discharge_Summary ds ON a.appointment_id = ds.appointment_id;

--SELECT * FROM Staff_Dashboard_View WHERE appointment_status = 'Scheduled';
-- Admin_Overview_View --
CREATE OR REPLACE VIEW Admin_Overview_View AS
SELECT
    (SELECT COUNT(*) FROM Patients) AS total_patients,
    (SELECT COUNT(*) FROM Doctors) AS total_doctors,
    (SELECT COUNT(*) FROM Staffs) AS total_staffs,
    (SELECT COUNT(*) FROM Appointment) AS total_appointments,
    (SELECT COUNT(*) FROM Room WHERE room_status = 'Available') AS available_rooms,
    (SELECT SUM(total_amount) FROM Billing) AS total_revenue,
    (SELECT SUM(due_amount) FROM Billing) AS total_due
FROM dual;


---Cursor---
-- cursor for staff using find the patient have due date 
DECLARE
    CURSOR due_bills IS
        SELECT p.full_name, b.total_amount, b.paid_amount, b.due_amount
        FROM Patients p
        JOIN Appointment a ON p.patient_id = a.patient_id
        JOIN Billing b ON a.appointment_id = b.appointment_id
        WHERE b.due_amount > 0;

    v_name      VARCHAR2(100);
    v_total     NUMBER;
    v_paid      NUMBER;
    v_due       NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Patients with DUE Bills ---');
    OPEN due_bills;
    LOOP
        FETCH due_bills INTO v_name, v_total, v_paid, v_due;
        EXIT WHEN due_bills%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Name: ' || v_name || ' | Due: ₹' || v_due);
    END LOOP;
    CLOSE due_bills;
END;
/
-----  admin cursor for Low Stock Alert
SET SERVEROUTPUT ON;
DECLARE
    CURSOR low_stock IS
        SELECT item_name, quantity
        FROM Inventory
        WHERE quantity < 10;  -- alert threshold

    v_name  Inventory.item_name%TYPE;
    v_qty   Inventory.quantity%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- LOW STOCK ALERT ---');
    OPEN low_stock;
    LOOP
        FETCH low_stock INTO v_name, v_qty;
        EXIT WHEN low_stock%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Item: ' || v_name || ' | Remaining Qty: ' || v_qty);
    END LOOP;
    CLOSE low_stock;
END;
/
----Auto Room Assignment Procedure (Cursor-Based)
CREATE SEQUENCE room_assign_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE Auto_Assign_Room(p_appointment_id IN INT) IS
    CURSOR available_rooms IS
        SELECT room_id FROM Room WHERE room_status = 'Available' AND ROWNUM = 1;

    v_room_id Room.room_id%TYPE;
    v_patient_id Appointment.patient_id%TYPE;
BEGIN
    -- Get the first available room
    OPEN available_rooms;
    FETCH available_rooms INTO v_room_id;
    CLOSE available_rooms;

    -- Get the patient_id for this appointment
    SELECT patient_id INTO v_patient_id
    FROM Appointment
    WHERE appointment_id = p_appointment_id;

    IF v_room_id IS NOT NULL THEN
        -- Insert into Room_Assignment table
        INSERT INTO Room_Assignment (
            assignment_id, room_id, patient_id, appointment_id, assign_date, discharge_date
        )
        VALUES (
            room_assign_seq.NEXTVAL, v_room_id, v_patient_id, p_appointment_id, SYSDATE, NULL
        );

        -- Update the room status
        UPDATE Room
        SET room_status = 'Occupied'
        WHERE room_id = v_room_id;

        DBMS_OUTPUT.PUT_LINE('✅ Room ' || v_room_id || ' assigned to appointment ' || p_appointment_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('❌ No available rooms to assign.');
    END IF;
END;
/

--BEGIN
    --Auto_Assign_Room(1001);  -- replace with a real appointment_id
--END;

-------Reset_User_Password
CREATE OR REPLACE PROCEDURE Reset_User_Password (
    p_user_type     IN VARCHAR2,  -- 'Doctor', 'Staff', 'Patient'
    p_username      IN VARCHAR2,
    p_new_password  IN VARCHAR2
) IS
BEGIN
    IF UPPER(p_user_type) = 'DOCTOR' THEN
        UPDATE Doctors
        SET dr_password = STANDARD_HASH(p_new_password, 'SHA256')
        WHERE dr_username = p_username;

    ELSIF UPPER(p_user_type) = 'STAFF' THEN
        UPDATE Staffs
        SET staff_password = STANDARD_HASH(p_new_password, 'SHA256')
        WHERE staff_username = p_username;

    ELSIF UPPER(p_user_type) = 'PATIENT' THEN
        UPDATE Patients
        SET pt_password = STANDARD_HASH(p_new_password, 'SHA256')
        WHERE pt_username = p_username;

    ELSE
        DBMS_OUTPUT.PUT_LINE('❌ Invalid user type. Use Doctor, Staff, or Patient.');
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE('✅ Password updated for ' || p_user_type || ' : ' || p_username);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('❌ No such user found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: ' || SQLERRM);
END;
/


--BEGIN
   -- Reset_User_Password('Doctor', 'dr_arun', 'newsecure123');
--END;
--- Discharge patient room
CREATE OR REPLACE PROCEDURE Discharge_Patient_Room(p_appointment_id IN INT) IS
    v_room_id Room.room_id%TYPE;
BEGIN
    -- Get the room_id from Room_Assignment
    SELECT room_id INTO v_room_id
    FROM Room_Assignment
    WHERE appointment_id = p_appointment_id AND discharge_date IS NULL;

    -- Update Room_Assignment with discharge_date
    UPDATE Room_Assignment
    SET discharge_date = SYSDATE
    WHERE appointment_id = p_appointment_id AND room_id = v_room_id;

    -- Set the room status back to Available
    UPDATE Room
    SET room_status = 'Available'
    WHERE room_id = v_room_id;

    DBMS_OUTPUT.PUT_LINE('✅ Patient discharged and room ' || v_room_id || ' is now available.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('❌ No active room assignment found for appointment ID: ' || p_appointment_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: ' || SQLERRM);
END;
/

---BEGIN
    --Discharge_Patient_Room(1001);  -- Replace with actual appointment_id
--END;

---
CREATE OR REPLACE VIEW Monthly_Revenue_View AS
SELECT
    TO_CHAR(bill_date, 'YYYY-MM') AS month_year,
    COUNT(*) AS total_bills,
    SUM(total_amount) AS total_revenue,
    SUM(paid_amount) AS total_paid,
    SUM(due_amount) AS total_due
FROM Billing
GROUP BY TO_CHAR(bill_date, 'YYYY-MM')
ORDER BY TO_CHAR(bill_date, 'YYYY-MM');

--query SELECT * FROM Monthly_Revenue_View;
--Validate_Login
CREATE OR REPLACE PROCEDURE Validate_Login (
    p_user_type   IN VARCHAR2,
    p_username    IN VARCHAR2,
    p_password    IN VARCHAR2
) IS
    v_count  INT := 0;
    v_status VARCHAR2(20);
BEGIN
    IF UPPER(p_user_type) = 'PATIENT' THEN
        SELECT COUNT(*) INTO v_count
        FROM Patients
        WHERE pt_username = p_username
          AND pt_password = STANDARD_HASH(p_password, 'SHA256');

    ELSIF UPPER(p_user_type) = 'DOCTOR' THEN
        SELECT COUNT(*) INTO v_count
        FROM Doctors
        WHERE dr_username = p_username
          AND dr_password = STANDARD_HASH(p_password, 'SHA256');

    ELSIF UPPER(p_user_type) = 'STAFF' THEN
        SELECT COUNT(*) INTO v_count
        FROM Staffs
        WHERE staff_username = p_username
          AND staff_password = STANDARD_HASH(p_password, 'SHA256');

    ELSE
        DBMS_OUTPUT.PUT_LINE('❌ Invalid user type');
        RETURN;
    END IF;

    -- Determine login status
    IF v_count > 0 THEN
        v_status := 'Success';
        DBMS_OUTPUT.PUT_LINE('✅ Login successful');
    ELSE
        v_status := 'Failed';
        DBMS_OUTPUT.PUT_LINE('❌ Invalid username or password');
    END IF;

    -- Insert audit log
    INSERT INTO Login_Audit (
        log_id, user_type, username, login_time, status
    ) VALUES (
        login_audit_seq.NEXTVAL, p_user_type, p_username, SYSTIMESTAMP, v_status
    );
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: ' || SQLERRM);
        INSERT INTO Login_Audit (
            log_id, user_type, username, login_time, status
        ) VALUES (
            login_audit_seq.NEXTVAL, p_user_type, p_username, SYSTIMESTAMP, 'Error'
        );
END;
/
-SELECT * FROM Login_Audit ORDER BY login_time DESC;


--BEGIN
    --Validate_Login('Patient', 'pt_ravi', 'pass@123');
--END;
--Low_Stock_View
CREATE OR REPLACE VIEW Low_Stock_View AS
SELECT
    item_id,
    item_name,
    item_type,
    quantity,
    unit_price,
    expiry_date,
    CASE
        WHEN quantity < 10 THEN 'LOW'
        ELSE 'OK'
    END AS alert_level
FROM Inventory
WHERE quantity < 10;
--SELECT * FROM Low_Stock_View;

----Room_Usage_History_View
CREATE OR REPLACE VIEW Room_Usage_History_View AS
SELECT
    ra.assignment_id,
    r.room_number,
    r.room_type,
    r.room_charge,
    p.patient_id,
    p.full_name AS patient_name,
    a.appointment_id,
    ra.assign_date,
    ra.discharge_date,
    (ra.discharge_date - ra.assign_date) AS total_days,
    (r.room_charge * (ra.discharge_date - ra.assign_date)) AS total_room_charge
FROM Room_Assignment ra
JOIN Room r ON ra.room_id = r.room_id
JOIN Patients p ON ra.patient_id = p.patient_id
JOIN Appointment a ON ra.appointment_id = a.appointment_id
ORDER BY ra.assign_date DESC;


----Generate_Bill
CREATE OR REPLACE PROCEDURE Generate_Bill(p_appointment_id IN INT) IS
    v_bill_id         INT;
    v_service_total   NUMBER := 0;
    v_medicine_total  NUMBER := 0;
    v_room_total      NUMBER := 0;
    v_doctor_fee      NUMBER := 0;
    v_total           NUMBER := 0;
    v_doctor_id       INT;
BEGIN
    -- Get bill ID
    SELECT bill_id INTO v_bill_id
    FROM Billing
    WHERE appointment_id = p_appointment_id;

    -- Service total
    SELECT NVL(SUM(amount), 0) INTO v_service_total
    FROM Billing_Details
    WHERE bill_id = v_bill_id;

    -- Medicine total
    SELECT NVL(SUM(amount), 0) INTO v_medicine_total
    FROM Medicine_Billing
    WHERE bill_id = v_bill_id;

    -- Room charges total (per day × charge)
    SELECT NVL(SUM(r.room_charge * (ra.discharge_date - ra.assign_date)), 0)
    INTO v_room_total
    FROM Room_Assignment ra
    JOIN Room r ON ra.room_id = r.room_id
    WHERE ra.appointment_id = p_appointment_id;

    -- Doctor fee (single fee per appointment)
    SELECT d.consultation_fees INTO v_doctor_fee
    FROM Appointment a
    JOIN Doctors d ON a.doctor_id = d.doctor_id
    WHERE a.appointment_id = p_appointment_id;

    -- Total bill
    v_total := v_service_total + v_medicine_total + v_room_total + v_doctor_fee;

    -- Update Billing table
    UPDATE Billing
    SET total_amount = v_total,
        due_amount = v_total - NVL(paid_amount, 0)
    WHERE bill_id = v_bill_id;

    DBMS_OUTPUT.PUT_LINE('🧾 Final Bill Generated');
    DBMS_OUTPUT.PUT_LINE('💊 Medicine  : ' || v_medicine_total);
    DBMS_OUTPUT.PUT_LINE('🛠️ Services : ' || v_service_total);
    DBMS_OUTPUT.PUT_LINE('🛏️ Room      : ' || v_room_total);
    DBMS_OUTPUT.PUT_LINE('👨‍⚕️ Doctor    : ' || v_doctor_fee);
    DBMS_OUTPUT.PUT_LINE('💰 Total     : ' || v_total);
END;
/

--BEGIN
   -- Generate_Bill(101); -- 101 = appointment_id
--END;
---trg_room_set_occupied
CREATE OR REPLACE TRIGGER trg_room_set_occupied
AFTER INSERT ON Room_Assignment
FOR EACH ROW
BEGIN
    UPDATE Room
    SET room_status = 'Occupied'
    WHERE room_id = :NEW.room_id;
END;
/
---trg_room_set_available
CREATE OR REPLACE TRIGGER trg_room_set_available
AFTER UPDATE OF discharge_date ON Room_Assignment
FOR EACH ROW
WHEN (NEW.discharge_date IS NOT NULL)
BEGIN
    UPDATE Room
    SET room_status = 'Available'
    WHERE room_id = :NEW.room_id;
END;
/
-- Sequence
CREATE SEQUENCE login_audit_seq START WITH 1 INCREMENT BY 1;
--create view  login_audit_summary
CREATE OR REPLACE VIEW Login_Audit_Summary AS
SELECT
    user_type,
    username,
    COUNT(*) AS total_logins,
    SUM(CASE WHEN status = 'Success' THEN 1 ELSE 0 END) AS successful_logins,
    SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) AS failed_logins
FROM Login_Audit
GROUP BY user_type, username;
