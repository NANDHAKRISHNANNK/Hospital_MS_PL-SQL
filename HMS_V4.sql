-- Sequence for Patient ID
CREATE SEQUENCE patient_seq 
START WITH 1001 INCREMENT BY 1;
 
-- Modified Patients Table
CREATE TABLE Patients (
    patient_id        INT PRIMARY KEY,
    full_name         VARCHAR2(100) NOT NULL,
    age               INT NOT NULL CHECK (age > 0),
 -- Constraint to validate Indian mobile number format
    mobile            VARCHAR2(20) NOT NULL CHECK (REGEXP_LIKE(mobile, '^(\+91)?[6-9][0-9]{9}$')),
    blood_group       VARCHAR2(10) NOT NULL CHECK (blood_group IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    gender            VARCHAR2(10) NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),
    email             VARCHAR2(100) CHECK (
  REGEXP_LIKE(
    email,
    '^' ||                  -- Start of string
    '[A-Za-z0-9._%+-]+' ||  -- Local part: one or more letters, digits, dot, underscore, percent, plus, hyphen
    '@gmail\.com$'          -- Must end with '@gmail.com' (escaped dot)
  )
),
    address           VARCHAR2(100) NOT NULL,
    patient_type      VARCHAR2(20) NOT NULL CHECK (patient_type IN ('Inpatient', 'Outpatient')),
    pt_username       VARCHAR2(50) UNIQUE NOT NULL CHECK (
  REGEXP_LIKE(
    username, '^[A-Za-z]+$'           -- Entire string must be only letters from start (^) to end ($)
  )
) ,
    pt_password       VARCHAR2(100) NOT NULL CHECK (
        LENGTH(password) BETWEEN 8 AND 20 AND
        REGEXP_LIKE(password, '.*[A-Z].*') AND       -- At least one uppercase
        REGEXP_LIKE(password, '.*[a-z].*') AND       -- At least one lowercase
        REGEXP_LIKE(password, '.*[0-9].*') AND       -- At least one digit
        REGEXP_LIKE(password, '.*[!@#$%^&*()].*')    -- At least one special char
    ),
    patient_history   VARCHAR2(500)
);
 --patient prodecure
 CREATE OR REPLACE PROCEDURE insert_patient(
    p_name          IN VARCHAR2,
    p_age           IN INT,
    p_mobile        IN VARCHAR2,
    p_blood_group   IN VARCHAR2,
    p_gender        IN VARCHAR2,
    p_email         IN VARCHAR2,
    p_address       IN VARCHAR2,
    p_type          IN VARCHAR2,
    p_username      IN VARCHAR2,
    p_password_raw  IN VARCHAR2,
    p_history       IN VARCHAR2 
)
IS
    v_patient_id  INT := patient_seq.NEXTVAL;
BEGIN
    INSERT INTO Patients (
        patient_id, full_name, age, mobile, blood_group, gender,
        email, address, patient_type, pt_username, pt_password, patient_history
    ) VALUES (
        v_patient_id, p_name, p_age, p_mobile, p_blood_group, p_gender,
        p_email, p_address, p_type, p_username, p_password_raw, p_history
    );
 
    DBMS_OUTPUT.PUT_LINE('✅ Patient inserted. ID: ' || v_patient_id);
END;
/
--insert patient
BEGIN
    insert_patient('Ravi Kumar', 28, '9876543210', 'A+', 'Male', 'ravi@example.com', 'Chennai', 'Outpatient', 'pt_ravi', 'pass@123', 'No major illness');
    insert_patient('Priya Sharma', 35, '9876543211', 'B+', 'Female', 'priya@example.com', 'Coimbatore', 'Inpatient', 'pt_priya', 'pass@456', 'Allergic to penicillin');
    insert_patient('John Das', 40, '9876543212', 'O-', 'Male', 'john@example.com', 'Madurai', 'Outpatient', 'pt_john', 'pass@789', 'Diabetic');
    insert_patient('Meena Iyer', 52, '9876543213', 'AB+', 'Female', 'meena@example.com', 'Trichy', 'Inpatient', 'pt_meena', 'pass@321', 'Hypertension');
    insert_patient('Arjun Rao', 19, '9876543214', 'B-', 'Male', 'arjun@example.com', 'Salem', 'Outpatient', 'pt_arjun', 'pass@654', 'Fracture - Right Hand');
END;
/

--- sequ department
CREATE SEQUENCE department_seq
    START WITH 1
    INCREMENT BY 1;
    --create a department 
 CREATE TABLE Departments (
    department_id     INT PRIMARY KEY,
    department_name   VARCHAR2(100) NOT NULL,
    department_head   VARCHAR2(100) NOT NULL
);
---- inserft department
CREATE OR REPLACE PROCEDURE insert_department (
    p_name IN VARCHAR2,
    p_head IN VARCHAR2
)
IS
    v_dept_id INT := department_seq.NEXTVAL;
BEGIN
    INSERT INTO Departments (
        department_id, department_name, department_head
    ) VALUES (
        v_dept_id, p_name, p_head
    );
 
    DBMS_OUTPUT.PUT_LINE(' Department inserted. ID: ' || v_dept_id);
END;
/
--insert_department data 
BEGIN
    insert_department('Cardiology', 'Dr. Rajesh Kumar');
    insert_department('Neurology', 'Dr. Meera Iyer');
    insert_department('Orthopedics', 'Dr. Karan Malhotra');
    insert_department('Pediatrics', 'Dr. Anitha Menon');
    insert_department('Dermatology', 'Dr. Faisal Rahman');
END;
/
--seq doct
CREATE SEQUENCE doctor_seq  
    START WITH 1  
    INCREMENT BY 1  
    NOCACHE  
    NOCYCLE;
   
--doctor 
CREATE TABLE Doctors (  
    doctor_id           INT PRIMARY KEY,  
    full_name           VARCHAR2(100) NOT NULL,  
    age                 INT CHECK (age BETWEEN 25 AND 80) NOT NULL,  
    mobile              VARCHAR2(20) NOT NULLCHECK (REGEXP_LIKE(mobile, '^(\+91)?[6-9][0-9]{9}$')),,  
    qualification       VARCHAR2(100) NOT NULL,  
    gender              VARCHAR2(10) NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),  
    email               VARCHAR2(100) NOT NULL CHECK (
  REGEXP_LIKE(
    email,
    '^' ||                  -- Start of string
    '[A-Za-z0-9._%+-]+' ||  -- Local part: one or more letters, digits, dot, underscore, percent, plus, hyphen
    '@gmail\.com$'          -- Must end with '@gmail.com' (escaped dot)
  )
),  
    specialization      VARCHAR2(100) NOT NULL,  
    experience          INT NOT NULL CHECK (experience >= 0),  
    department_id       INT NOT NULL,  
    dr_username         VARCHAR2(50) UNIQUE NOT NULL CHECK (REGEXP_LIKE(dr_username, '^[A-Za-z][A-Za-z0-9_]{4,49}$')),  
    dr_password         VARCHAR2(64) NOT NULL,  
    shift               VARCHAR2(10) NOT NULL CHECK (shift IN ('Morning', 'Evening', 'Night')),  
    consultation_fees   DECIMAL(10,2) NOT NULL CHECK (consultation_fees >= 0),  
    availability_status VARCHAR2(20) NOT NULL CHECK (availability_status IN ('Available', 'Busy', 'On Leave')),  
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)  
);
--procedure for doctor
CREATE OR REPLACE PROCEDURE insert_doctor(  
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
    v_new_id INT := doctor_seq.NEXTVAL;  
BEGIN  
    INSERT INTO Doctors (  
        doctor_id, full_name, age, mobile, qualification, gender, email,  
        specialization, experience, department_id, dr_username,  
        dr_password, shift, consultation_fees, availability_status  
    )  
    VALUES (  
        v_new_id, p_name, p_age, p_mobile, p_qualification, p_gender, p_email,  
        p_specialization, p_experience, p_department_id, p_username,  
        p_password_raw, p_shift, p_fees, p_status  
    );  
  
    DBMS_OUTPUT.PUT_LINE('Doctor inserted successfully with ID: ' || v_new_id);  
END;
/

--insert doctor
BEGIN
    insert_doctor('Dr. Aarthi R', 45, '9876543210', 'MBBS, MD', 'Female',
                  'aarthi.r@example.com', 'Cardiology', 18, 1, 'aarthi_r',
                  'pass123', 'Morning', 1000.00, 'Available');
 
    insert_doctor('Dr. Mohan Reddy', 52, '9988776655', 'MBBS, DM', 'Male',
                  'mohan.reddy@example.com', 'Neurology', 22, 2, 'mohanreddy',
                  'neuro456', 'Evening', 1200.00, 'Busy');
 
    insert_doctor('Dr. Kavitha N', 38, '9123456780', 'MBBS, D.Ortho', 'Female',
                  'kavitha.n@example.com', 'Orthopedics', 14, 3, 'kavitha_n',
                  'ortho789', 'Night', 950.00, 'Available');
 
    insert_doctor('Dr. Ajay Mehta', 41, '9871234567', 'MBBS, DCH', 'Male',
                  'ajay.mehta@example.com', 'Pediatrics', 17, 4, 'ajaymehta',
                  'kidsdoc2024', 'Morning', 850.00, 'On Leave');
 
    insert_doctor('Dr. Farah Khan', 36, '9900112233', 'MBBS, DDVL', 'Female',
                  'farah.khan@example.com', 'Dermatology', 12, 5, 'farahk',
                  'derma@456', 'Evening', 1100.00, 'Available');
END;
/
--seq_appointment
CREATE SEQUENCE appointment_seq
    START WITH 1001
    INCREMENT BY 1;
-- create appointment table 
CREATE TABLE Appointment (
    appointment_id       INT PRIMARY KEY,
    patient_id           INT NOT NULL,
    doctor_id            INT NOT NULL,
    booking_date         DATE DEFAULT SYSDATE NOT NULL,
    appointment_date     DATE NOT NULL,
 PRIORITY_LEVEL VARCHAR2(20) CHECK (PRIORITY_LEVEL IN ('REGULAR', 'EMERGENCY')),
    appointment_time     VARCHAR2(20) NOT NULL
        CHECK (REGEXP_LIKE(appointment_time, '^(0[1-9]|1[0-2]):[0-5][0-9] (AM|PM)$')),
    appointment_status   VARCHAR2(20) NOT NULL
        CHECK (appointment_status IN ('Scheduled', 'Completed', 'Cancelled')),
    problem_description  VARCHAR2(255),
    booking_type         VARCHAR2(20) NOT NULL
        CHECK (booking_type IN ('Online', 'Walk-in')),
 
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
--room
CREATE TABLE Room (
    room_id          INT PRIMARY KEY,
    room_number      VARCHAR2(10) NOT NULL UNIQUE,
    room_type        VARCHAR2(50) NOT NULL CHECK (room_type IN ('ICU', 'General', 'Private', 'Semi-Private')),
    room_status      VARCHAR2(20) NOT NULL CHECK (room_status IN ('Available', 'Occupied', 'Cleaning')),
    room_charge      DECIMAL(10, 2) NOT NULL,
    appointment_id   INT,
 
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);
--room_seq
CREATE SEQUENCE room_seq
START WITH 1
INCREMENT BY 1
NOCACHE;
---inser room procedure
CREATE OR REPLACE PROCEDURE insert_room (
    p_room_number    IN VARCHAR2,
    p_room_type      IN VARCHAR2,
    p_room_status    IN VARCHAR2,
    p_room_charge    IN DECIMAL,
    p_appointment_id IN INT DEFAULT NULL
)
IS
    v_room_id INT := room_seq.NEXTVAL;
BEGIN
    INSERT INTO Room (
        room_id, room_number, room_type, room_status, room_charge, appointment_id
    ) VALUES (
        v_room_id, p_room_number, p_room_type, p_room_status, p_room_charge, p_appointment_id
    );
 
    DBMS_OUTPUT.PUT_LINE(' Room inserted with ID: ' || v_room_id);
END;
/
--insert room
BEGIN
    insert_room('R101', 'ICU', 'Available', 5000.00);
    insert_room('R102', 'Private', 'Available', 3000.00);
    insert_room('R103', 'General', 'Cleaning', 1000.00);
    insert_room('R104', 'Semi-Private', 'Available', 2000.00);
    insert_room('R105', 'ICU', 'Occupied', 5500.00);
END;
/

--seq login
CREATE SEQUENCE login_audit_seq
START WITH 1
INCREMENT BY 1
;
--create table login
CREATE TABLE Login_Audit (  
    log_id        INT PRIMARY KEY,  
    user_type     VARCHAR2(20) NOT NULL,  
    username      VARCHAR2(50) NOT NULL,  
    login_time    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,  
    status        VARCHAR2(20) NOT NULL CHECK (status IN ('Success', 'Failed'))  
);
--- room assignment
CREATE TABLE Room_Assignment (  
    assignment_id     INT PRIMARY KEY,  
    room_id           INT NOT NULL,  
    patient_id        INT NOT NULL,  
    appointment_id    INT NOT NULL,  
    assign_date       DATE NOT NULL,  
    discharge_date    DATE,  -- Can be NULL initially
  
    FOREIGN KEY (room_id) REFERENCES Room(room_id),  
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),  
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)  
);
--seq staff
CREATE SEQUENCE staff_seq 
START WITH 1 INCREMENT BY 1;

CREATE TABLE Staffs (
    staff_id         INT PRIMARY KEY,
    full_name        VARCHAR2(100) NOT NULL,
    age              INT NOT NULL,
    mobile           VARCHAR2(20)  NOT NULL CHECK (REGEXP_LIKE(mobile, '^(\+91)?[6-9][0-9]{9}$')),,
    gender           VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')) NOT NULL,
    staff_role       VARCHAR2(50) CHECK (staff_role IN ('Receptionist', 'Nurse', 'Lab Assistant', 'Admin', 'Pharmacist')) NOT NULL,
    salary           DECIMAL(10,2) NOT NULL,
    staff_username   VARCHAR2(50) UNIQUE NOT NULL ,
    staff_password   VARCHAR2(64) NOT NULL CHECK (
        LENGTH(password) BETWEEN 8 AND 20 AND
        REGEXP_LIKE(password, '.*[A-Z].*') AND       -- At least one uppercase
        REGEXP_LIKE(password, '.*[a-z].*') AND       -- At least one lowercase
        REGEXP_LIKE(password, '.*[0-9].*') AND       -- At least one digit
        REGEXP_LIKE(password, '.*[!@#$%^&*()].*')    -- At least one special char
    )
 ,  
    department_id    INT NOT NULL,
 
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
--insert staffs
CREATE OR REPLACE PROCEDURE insert_staff(
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
    new_id INT;
BEGIN
    new_id := staff_seq.NEXTVAL;
 
    INSERT INTO Staffs (
        staff_id, full_name, age, mobile, gender, staff_role,
        salary, staff_username, staff_password, department_id
    ) VALUES (
        new_id, p_name, p_age, p_mobile, p_gender, p_role,
        p_salary, p_username, p_password_raw, p_dept_id
    );
 
    DBMS_OUTPUT.PUT_LINE(' Staff inserted with ID: ' || new_id);
END;
/
---staff insert
BEGIN
  insert_staff('Riya Sharma', 28, '9876543210', 'Female', 'Nurse', 28000, 'riya_nurse', 'pass@123', 1);
  insert_staff('Arjun Patel', 35, '9123456780', 'Male', 'Lab Assistant', 32000, 'arjun_lab', 'test@123', 2);
  insert_staff('Meena Rao', 30, '9988776655', 'Female', 'Receptionist', 25000, 'meena_recep', 'pass@321', 1);
  insert_staff('Vikram Das', 40, '9001122334', 'Male', 'Admin', 50000, 'vikram_admin', 'secure@1', 2);
  insert_staff('Sara Ali', 26, '9887766554', 'Female', 'Nurse', 29000, 'sara_nurse', 'nurse@123', 1);
END;
/
--create inventory 
CREATE TABLE Inventory (  
    item_id         INT PRIMARY KEY,  
    item_name       VARCHAR2(100) UNIQUE NOT NULL,  
    item_type       VARCHAR2(50) CHECK (item_type IN ('Medicine', 'Equipment', 'Syringe', 'IV', 'Other')) NOT NULL,  
    quantity        INT NOT NULL,  
    unit_price      DECIMAL(10, 2) NOT NULL,  
    expiry_date     DATE NOT NULL,  
    alert_status    VARCHAR2(10) DEFAULT 'OK' CHECK (alert_status IN ('OK', 'LOW')) NOT NULL  
);

--trigger
CREATE OR REPLACE TRIGGER check_stock_level  
BEFORE UPDATE ON Inventory  
FOR EACH ROW  
BEGIN  
    IF :NEW.quantity < 10 THEN  
        :NEW.alert_status := 'LOW';  
        DBMS_OUTPUT.PUT_LINE('Low stock: ' || :NEW.item_name || ' — only ' || :NEW.quantity || ' left.');  
    ELSE  
        :NEW.alert_status := 'OK';  
    END IF;  
END;  
/
--seq inventory
CREATE SEQUENCE inventory_seq START WITH 1 INCREMENT BY 1;
 --insert procedure inventory
 CREATE OR REPLACE PROCEDURE insert_inventory_item(
    p_name       IN VARCHAR2,
    p_type       IN VARCHAR2,
    p_quantity   IN INT,
    p_price      IN DECIMAL,
    p_expiry     IN DATE
)
IS
    v_id INT := inventory_seq.NEXTVAL;
BEGIN
    INSERT INTO Inventory (
        item_id, item_name, item_type, quantity, unit_price, expiry_date
    ) VALUES (
        v_id, p_name, p_type, p_quantity, p_price, p_expiry
    );
    DBMS_OUTPUT.PUT_LINE(' Inventory item inserted. ID: ' || v_id);
END;
/
--insert inventory
BEGIN
  insert_inventory_item('Paracetamol', 'Medicine', 100, 2.5, TO_DATE('2026-01-01', 'YYYY-MM-DD'));
  insert_inventory_item('Thermometer', 'Equipment', 5, 150.00, TO_DATE('2028-12-31', 'YYYY-MM-DD'));
  insert_inventory_item('Insulin', 'Medicine', 8, 220.75, TO_DATE('2025-11-15', 'YYYY-MM-DD'));
  insert_inventory_item('IV Set', 'IV', 12, 50.00, TO_DATE('2027-09-30', 'YYYY-MM-DD'));
  insert_inventory_item('Syringe Pack', 'Syringe', 3, 12.00, TO_DATE('2025-08-20', 'YYYY-MM-DD'));
END;
/
--seq service

CREATE SEQUENCE service_seq
    START WITH 1
    INCREMENT BY 1
    ;
--create service
CREATE TABLE Services (
    service_id       INT PRIMARY KEY,
    service_name     VARCHAR2(100) UNIQUE NOT NULL,
    service_charge   DECIMAL(10, 2) NOT NULL
);
--insert service procedure 
CREATE OR REPLACE PROCEDURE insert_service (
    p_name   IN VARCHAR2,
    p_charge IN DECIMAL
)
IS
    v_id INT := service_seq.NEXTVAL;
BEGIN
    INSERT INTO Services (
        service_id, service_name, service_charge
    ) VALUES (
        v_id, p_name, p_charge
    );
 
    DBMS_OUTPUT.PUT_LINE(' Service inserted. ID: ' || v_id);
END;
/
--insert 
BEGIN
  insert_service('X-Ray', 500);
  insert_service('ECG', 400);
  insert_service('Blood Test', 150);
  insert_service('MRI Scan', 1800);
  insert_service('Physiotherapy', 600);
END;
/
--create billing;
CREATE TABLE Billing (
    bill_id           INT PRIMARY KEY,
    appointment_id    INT,
    bill_date         DATE DEFAULT SYSDATE,
    total_amount      DECIMAL(10, 2),
    paid_amount       DECIMAL(10, 2),
    due_amount        DECIMAL(10, 2),
    payment_status    VARCHAR2(20) CHECK (payment_status IN ('Paid', 'Unpaid', 'Pending')),
 
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);
--billing deatils
CREATE TABLE Billing_Details (
    bill_detail_id    INT PRIMARY KEY,
    bill_id           INT,
    service_id        INT,
    quantity          INT,
    amount            DECIMAL(10, 2),
 
    FOREIGN KEY (bill_id) REFERENCES Billing(bill_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

ALTER TABLE Billing_Details
ADD service_date DATE DEFAULT SYSDATE;

CREATE TABLE Medicine_Billing (
    med_bill_id     INT PRIMARY KEY,
    bill_id         INT,
    item_id         INT,
    quantity        INT,
    amount          DECIMAL(10,2),
    FOREIGN KEY (bill_id) REFERENCES Billing(bill_id),
    FOREIGN KEY (item_id) REFERENCES Inventory(item_id)
);

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
    -- Check if bill exists
    SELECT paid_amount, total_amount 
    INTO v_paid_amount, v_total_amount
    FROM Billing 
    WHERE bill_id = p_bill_id;
 
    -- Calculate new paid and due
    v_new_paid := v_paid_amount + p_payment_amt;
    v_new_due := v_total_amount - v_new_paid;
 
    -- Prevent overpayment
    IF v_new_paid > v_total_amount THEN
        DBMS_OUTPUT.PUT_LINE(' Payment exceeds total bill. Transaction cancelled.');
        RETURN;
    END IF;
 
    -- Update billing
    UPDATE Billing
    SET paid_amount = v_new_paid,
        due_amount = v_new_due,
        payment_status = CASE 
                            WHEN v_new_due = 0 THEN 'Paid'
                            ELSE 'Pending'
                         END
    WHERE bill_id = p_bill_id;
 
    DBMS_OUTPUT.PUT_LINE(' Payment recorded. Paid: ₹' || v_new_paid || ', Due: ₹' || v_new_due);
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(' Error: Bill ID ' || p_bill_id || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Error: ' || SQLERRM);
END;
--seqence billing
CREATE SEQUENCE billing_detail_seq
START WITH 1
INCREMENT BY 1
;
--update billing
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
 
    -- Try to get room_id and doctor_id; skip if not found
    BEGIN
        SELECT ra.room_id, a.doctor_id
        INTO v_room_id, v_doctor_id
        FROM Room_Assignment ra
        JOIN Appointment a ON ra.appointment_id = a.appointment_id
        WHERE ra.appointment_id = v_appointment_id;
 
        -- Get room charge
        SELECT room_charge INTO v_room_charge
        FROM Room WHERE room_id = v_room_id;
 
        -- Get doctor fee
        SELECT consultation_fees INTO v_doctor_fee
        FROM Doctors WHERE doctor_id = v_doctor_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_room_charge := 0;
            v_doctor_fee := 0;
    END;
 
    -- Insert a fixed service (optional)
    INSERT INTO Billing_Details (
        bill_detail_id, bill_id, service_id, quantity, amount, service_date
    ) VALUES (
        billing_detail_seq.NEXTVAL, p_bill_id, 1, 1, 500, SYSDATE
    );
 
    -- Sum services and medicines
    SELECT NVL(SUM(amount), 0) INTO v_service_total
    FROM Billing_Details WHERE bill_id = p_bill_id;
 
    SELECT NVL(SUM(amount), 0) INTO v_medicine_total
    FROM Medicine_Billing WHERE bill_id = p_bill_id;
 
    -- Final bill
    v_total := v_service_total + v_medicine_total + v_room_charge + v_doctor_fee;
 
    UPDATE Billing
    SET total_amount = v_total,
        due_amount = v_total
    WHERE bill_id = p_bill_id;
 
    DBMS_OUTPUT.PUT_LINE('✅ Final Bill: ₹' || v_total || 
                         ' (Room ₹' || v_room_charge || 
                         ', Doctor ₹' || v_doctor_fee || 
                         ', Services ₹' || v_service_total || 
                         ', Medicines ₹' || v_medicine_total || ')');
END;
/

--pay bill
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
    -- Validate positive payment
    IF p_payment_amt <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '❌ Payment amount must be greater than 0.');
    END IF;
 
    -- Check if bill exists and get current amounts
    SELECT paid_amount, total_amount INTO v_paid_amount, v_total_amount
    FROM Billing WHERE bill_id = p_bill_id;
 
    -- Prevent overpayment
    IF (v_paid_amount + p_payment_amt) > v_total_amount THEN
        RAISE_APPLICATION_ERROR(-20002, '❌ Payment exceeds total bill amount.');
    END IF;
 
    -- Calculate new values
    v_new_paid := v_paid_amount + p_payment_amt;
    v_new_due := v_total_amount - v_new_paid;
 
    -- Update billing
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
---
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
 
 ------------------------<Discharge_Summary>----------------------------
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
 -------------<Patient_Dashboard_View>--------
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
------------<Doctor_Dashboard_View>-----------
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
--------<Staff_Dashboard_View>---------
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
-----<Admin_Overview_View>--------
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

-----------<Cursor due bill identifer>----------------
SET SERVEROUTPUT ON;
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
-----------<Admin Low Stock>----------
SET SERVEROUTPUT ON;
DECLARE
    CURSOR low_stock IS
        SELECT item_name, quantity
        FROM Inventory
        WHERE quantity < 10;
 
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
-----------------<Auto_Assign_Room_By_Type>----------------------------
CREATE SEQUENCE room_assign_seq 
START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE PROCEDURE Auto_Assign_Room_By_Type(
    p_appointment_id IN INT,
    p_room_type      IN VARCHAR2
) IS
    v_room_id     Room.room_id%TYPE;
    v_patient_id  Appointment.patient_id%TYPE;
 
    CURSOR available_rooms IS
        SELECT room_id
        FROM Room
        WHERE room_status = 'Available'
          AND room_type = p_room_type
          AND ROWNUM = 1;
BEGIN
    -- Get patient ID from appointment
    SELECT patient_id INTO v_patient_id
    FROM Appointment
    WHERE appointment_id = p_appointment_id;
 
    -- Find available room of given type
    OPEN available_rooms;
    FETCH available_rooms INTO v_room_id;
    CLOSE available_rooms;
 
    IF v_room_id IS NOT NULL THEN
        -- Assign the room
        INSERT INTO Room_Assignment (
            assignment_id, room_id, patient_id, appointment_id, assign_date, discharge_date
        )
        VALUES (
            room_assign_seq.NEXTVAL, v_room_id, v_patient_id, p_appointment_id, SYSDATE, NULL
        );
 
        -- Update room status
        UPDATE Room
        SET room_status = 'Occupied'
        WHERE room_id = v_room_id;
 
        DBMS_OUTPUT.PUT_LINE('✅ ' || p_room_type || ' room ' || v_room_id || ' assigned to appointment ' || p_appointment_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('❌ No available room of type: ' || p_room_type);
    END IF;
END;
/

--BEGIN
    --Auto_Assign_Room_By_Type(1001);  -- replace with a real appointment_id
--END;

-------Reset_User_Password
CREATE OR REPLACE PROCEDURE Reset_User_Password (
    p_user_type     IN VARCHAR2,  -- 'Doctor', 'Staff', 'Patient'
    p_username      IN VARCHAR2,
    p_new_password  IN VARCHAR2
) IS
    rows_updated INT;
BEGIN
    IF UPPER(p_user_type) = 'DOCTOR' THEN
        UPDATE Doctors
        SET dr_password = p_new_password
        WHERE dr_username = p_username;
        rows_updated := SQL%ROWCOUNT;

    ELSIF UPPER(p_user_type) = 'STAFF' THEN
        UPDATE Staffs
        SET staff_password = p_new_password
        WHERE staff_username = p_username;
        rows_updated := SQL%ROWCOUNT;

    ELSIF UPPER(p_user_type) = 'PATIENT' THEN
        UPDATE Patients
        SET pt_password = p_new_password
        WHERE pt_username = p_username;
        rows_updated := SQL%ROWCOUNT;

    ELSE
        DBMS_OUTPUT.PUT_LINE('❌ Invalid user type. Use Doctor, Staff, or Patient.');
        RETURN;
    END IF;

    IF rows_updated = 0 THEN
        DBMS_OUTPUT.PUT_LINE('❌ No such user found: ' || p_username);
    ELSE
        DBMS_OUTPUT.PUT_LINE('✅ Password updated for ' || p_user_type || ' : ' || p_username);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: ' || SQLERRM);
END;
/
--BEGIN
   -- Reset_User_Password('Doctor', 'dr_arun', 'newsecure123');
--END;
--Discharge_Patient_Room
CREATE OR REPLACE PROCEDURE Discharge_Patient_Room(p_appointment_id IN INT) IS
    v_room_id        Room.room_id%TYPE;
    v_discharge_date Room_Assignment.discharge_date%TYPE;
BEGIN
    -- Check if an active assignment exists
    SELECT room_id, discharge_date INTO v_room_id, v_discharge_date
    FROM Room_Assignment
    WHERE appointment_id = p_appointment_id;
 
    -- Check if already discharged
    IF v_discharge_date IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('⚠️ Patient already discharged. Room: ' || v_room_id);
        RETURN;
    END IF;
 
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
        DBMS_OUTPUT.PUT_LINE('❌ No room assignment found for appointment ID: ' || p_appointment_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: ' || SQLERRM);
END;
/
--BEGIN
    --Discharge_Patient_Room(1021);  -- Will work only once
--END;/
--query SELECT * FROM Monthly_Revenue_View;
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

CREATE OR REPLACE PROCEDURE Validate_Login (  
    p_user_type   IN VARCHAR2,  
    p_username    IN VARCHAR2,  
    p_password    IN VARCHAR2  
) IS  
    v_count           INT := 0;  
    v_status          VARCHAR2(20);  
    v_user_id         INT;  
BEGIN  
    IF UPPER(p_user_type) = 'PATIENT' THEN  
        SELECT COUNT(*), MAX(patient_id) INTO v_count, v_user_id  
        FROM Patients  
        WHERE pt_username = p_username AND pt_password = p_password;  
  
    ELSIF UPPER(p_user_type) = 'DOCTOR' THEN  
        SELECT COUNT(*), MAX(doctor_id) INTO v_count, v_user_id  
        FROM Doctors  
        WHERE dr_username = p_username AND dr_password = p_password;  
  
    ELSIF UPPER(p_user_type) = 'STAFF' THEN  
        SELECT COUNT(*), MAX(staff_id) INTO v_count, v_user_id  
        FROM Staffs  
        WHERE staff_username = p_username AND staff_password = p_password;  
  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('❌ Invalid user type');  
        RETURN;  
    END IF;  
  
    -- Determine login status  
    IF v_count > 0 THEN  
        v_status := 'Success';  
        DBMS_OUTPUT.PUT_LINE('✅ Login successful');  
        
        -- Show appropriate dashboard data
        IF UPPER(p_user_type) = 'PATIENT' THEN  
            DBMS_OUTPUT.PUT_LINE('--- Patient Dashboard ---');  
            FOR rec IN (SELECT * FROM Patient_Dashboard_View WHERE patient_id = v_user_id) LOOP  
                DBMS_OUTPUT.PUT_LINE('Appointment ID: ' || rec.appointment_id || 
                                     ', Status: ' || rec.appointment_status || 
                                     ', Due: ₹' || rec.due_amount);  
            END LOOP;  
  
        ELSIF UPPER(p_user_type) = 'DOCTOR' THEN  
            DBMS_OUTPUT.PUT_LINE('--- Doctor Dashboard ---');  
            SELECT COUNT(*) INTO v_count FROM Appointment WHERE doctor_id = v_user_id;  
            DBMS_OUTPUT.PUT_LINE('Total Appointments: ' || v_count);  
  
        ELSIF UPPER(p_user_type) = 'STAFF' THEN  
            DBMS_OUTPUT.PUT_LINE('--- Staff Dashboard ---');  
            FOR rec IN (SELECT * FROM Staff_Dashboard_View WHERE appointment_status = 'Scheduled') LOOP  
                DBMS_OUTPUT.PUT_LINE('Appointment ID: ' || rec.appointment_id || 
                                     ', Patient: ' || rec.patient_name || 
                                     ', Doctor: ' || rec.doctor_name);  
            END LOOP;  
        END IF;  
  
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
--BEGIN
    --Validate_Login('Patient', 'pt_ravi', 'pass@123');
--END;
SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE Generate_Bill(p_appointment_id IN INT) IS
    v_bill_id         INT;
    v_service_total   NUMBER := 0;
    v_medicine_total  NUMBER := 0;
    v_room_total      NUMBER := 0;
    v_doctor_fee      NUMBER := 0;
    v_total           NUMBER := 0;
    v_paid            NUMBER := 0;
BEGIN
    -- Get bill ID & paid amount
    SELECT bill_id, NVL(paid_amount, 0) INTO v_bill_id, v_paid
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
 
    -- Room charge based on stay duration (if discharged)
    SELECT NVL(SUM(r.room_charge * (NVL(ra.discharge_date, SYSDATE) - ra.assign_date)), 0)
    INTO v_room_total
    FROM Room_Assignment ra
    JOIN Room r ON ra.room_id = r.room_id
    WHERE ra.appointment_id = p_appointment_id;
 
    -- Doctor consultation fee
    SELECT NVL(d.consultation_fees, 0) INTO v_doctor_fee
    FROM Appointment a
    JOIN Doctors d ON a.doctor_id = d.doctor_id
    WHERE a.appointment_id = p_appointment_id;
 
    -- Calculate grand total
    v_total := v_service_total + v_medicine_total + v_room_total + v_doctor_fee;
 
    -- Update Billing
    UPDATE Billing
    SET total_amount = v_total,
        due_amount = v_total - v_paid
    WHERE bill_id = v_bill_id;
 
    -- Print breakdown
    DBMS_OUTPUT.PUT_LINE('🧾 Final Bill Generated');
    DBMS_OUTPUT.PUT_LINE('💊 Medicine  : ₹' || v_medicine_total);
    DBMS_OUTPUT.PUT_LINE('🛠️ Services : ₹' || v_service_total);
    DBMS_OUTPUT.PUT_LINE('🛏️ Room      : ₹' || v_room_total);
    DBMS_OUTPUT.PUT_LINE('👨‍⚕️ Doctor    : ₹' || v_doctor_fee);
    DBMS_OUTPUT.PUT_LINE('💰 Total     : ₹' || v_total);
    DBMS_OUTPUT.PUT_LINE('💸 Paid      : ₹' || v_paid || ' | Due: ₹' || (v_total - v_paid));
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('❌ Billing record not found for appointment ID: ' || p_appointment_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: ' || SQLERRM);
END;
/
---BEGIN
    Generate_Bill(101);  -- Replace with valid appointment_id
---END;/
------------<Trigger room_set_available >-------
CREATE OR REPLACE TRIGGER trg_room_set_available
AFTER UPDATE OF discharge_date ON Room_Assignment
FOR EACH ROW
BEGIN
    IF :NEW.discharge_date IS NOT NULL THEN
        UPDATE Room
        SET room_status = 'Available'
        WHERE room_id = :NEW.room_id;
    END IF;
END;

-- Sequence for Login Audit
CREATE SEQUENCE login_audit_seq
START WITH 1
INCREMENT BY 1;


 
-- View to summarize login activity
CREATE OR REPLACE VIEW Login_Audit_Summary AS
SELECT
    user_type,
    username,
    COUNT(*) AS total_logins,
    SUM(CASE WHEN status = 'Success' THEN 1 ELSE 0 END) AS successful_logins,
    SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) AS failed_logins
FROM Login_Audit
GROUP BY user_type, username;

SELECT * FROM Login_Audit_Summary WHERE user_type = 'Doctor';

CREATE TABLE Patient_Staff_Link (
patient_id INT NOT NULL,
staff_id INT NOT NULL,

 FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

CREATE SEQUENCE appointment_seq 
START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE waiting_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE Waiting_List (
    wait_id           INT PRIMARY KEY,
    patient_id        INT,
    specialization    VARCHAR2(50),
    preferred_doctor  INT,
    created_at        TIMESTAMP DEFAULT SYSTIMESTAMP,
    status            VARCHAR2(20) DEFAULT 'Waiting'
);
set define off;
CREATE OR REPLACE PROCEDURE Create_Auto_Appointment (
    p_patient_id     IN INT,
    p_specialization IN VARCHAR2,
    p_date           IN DATE,
    p_time           IN VARCHAR2,
    p_preferred_doctor IN INT DEFAULT NULL
)
IS
    v_gender      VARCHAR2(10);
    v_age         INT;
    v_doctor_id   INT;
    v_appt_id     INT := appointment_seq.NEXTVAL;
BEGIN
    -- Get patient info
    SELECT gender, age INTO v_gender, v_age
    FROM Patients
    WHERE patient_id = p_patient_id;

    -- Try preferred doctor first
    IF p_preferred_doctor IS NOT NULL THEN
        BEGIN
            SELECT doctor_id INTO v_doctor_id
            FROM Doctors
            WHERE doctor_id = p_preferred_doctor
              AND specialization = p_specialization
              AND availability_status = 'Available';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_doctor_id := NULL;
        END;
    END IF;

    -- If no preferred doctor or not available, assign by logic
    IF v_doctor_id IS NULL THEN
        BEGIN
            IF v_gender = 'Female' THEN
                SELECT doctor_id INTO v_doctor_id
                FROM Doctors
                WHERE specialization = p_specialization
                  AND gender = 'Female'
                  AND availability_status = 'Available'
                  AND ROWNUM = 1;
            ELSIF v_age >= 60 THEN
                SELECT doctor_id INTO v_doctor_id
                FROM Doctors
                WHERE specialization = p_specialization
                  AND availability_status = 'Available'
                ORDER BY experience DESC
                FETCH FIRST 1 ROWS ONLY;
            ELSE
                SELECT doctor_id INTO v_doctor_id
                FROM Doctors
                WHERE specialization = p_specialization
                  AND availability_status = 'Available'
                  AND ROWNUM = 1;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_doctor_id := NULL;
        END;
    END IF;

    -- Create appointment if doctor is found
    IF v_doctor_id IS NOT NULL THEN
        INSERT INTO Appointment (
            appointment_id, patient_id, doctor_id,
            booking_date, appointment_date, appointment_time,
            appointment_status, problem_description, booking_type
        )
        VALUES (
            v_appt_id, p_patient_id, v_doctor_id,
            SYSDATE, p_date, p_time,
            'Scheduled', 'Auto-assigned', 'Walk-in'
        );

        UPDATE Doctors
        SET availability_status = 'Busy'
        WHERE doctor_id = v_doctor_id;

        DBMS_OUTPUT.PUT_LINE('✅ Appointment created with Doctor ID: ' || v_doctor_id);
    ELSE
        -- Insert into waiting list
        INSERT INTO Waiting_List (
            patient_id, specialization, preferred_doctor, status, created_at
        ) VALUES (
            p_patient_id, p_specialization, p_preferred_doctor, 'Waiting', SYSTIMESTAMP
        );

        DBMS_OUTPUT.PUT_LINE('⏳ No doctor available now. Added to waiting list.');
    END IF;
END;
/

--BEGIN
 --   Create_Auto_Appointment(
 --       p_patient_id => 101,
  --      p_specialization => 'Cardiology',
 ----       p_date => TO_DATE('2025-07-10', 'YYYY-MM-DD'),
   --     p_time => '10:00 AM',
--     p_doctor_pref_id => 201  -- optional  );
--END;

CREATE OR REPLACE PROCEDURE ASSIGN_PATIENT_BY_PREFERENCE IS
    CURSOR waitlist_cur IS
        SELECT wl_id, patient_id, specialization, preferred_doctor
        FROM Waiting_List
        WHERE status = 'Waiting'
        ORDER BY created_at
        FOR UPDATE SKIP LOCKED;

    v_doctor_id   INT;
    v_appointment_id INT := appointment_seq.NEXTVAL;
    v_wl_id       INT;
    v_patient_id  INT;
    v_specialization VARCHAR2(100);
    v_pref_doc    INT;
BEGIN
    OPEN waitlist_cur;
    FETCH waitlist_cur INTO v_wl_id, v_patient_id, v_specialization, v_pref_doc;
    CLOSE waitlist_cur;

    IF v_wl_id IS NOT NULL THEN
        BEGIN
            -- Try preferred doctor first
            IF v_pref_doc IS NOT NULL THEN
                SELECT doctor_id INTO v_doctor_id
                FROM Doctors
                WHERE doctor_id = v_pref_doc
                AND availability_status = 'Available'
                AND specialization = v_specialization;
            ELSE
                SELECT doctor_id INTO v_doctor_id
                FROM Doctors
                WHERE availability_status = 'Available'
                AND specialization = v_specialization
                AND ROWNUM = 1;
            END IF;

            -- Assign doctor
            INSERT INTO Appointment (
                appointment_id, patient_id, doctor_id,
                booking_date, appointment_date, appointment_time,
                appointment_status, problem_description, booking_type
            ) VALUES (
                v_appointment_id, v_patient_id, v_doctor_id,
                SYSDATE, SYSDATE, '10:00 AM',
                'Scheduled', 'Auto-assigned from waitlist', 'Walk-in'
            );

            -- Mark patient as processed
            UPDATE Waiting_List
            SET status = 'Scheduled'
            WHERE wl_id = v_wl_id;

            -- Set doctor as busy
            UPDATE Doctors
            SET availability_status = 'Busy'
            WHERE doctor_id = v_doctor_id;

            DBMS_OUTPUT.PUT_LINE('✅ Assigned doctor ' || v_doctor_id || ' to patient ' || v_patient_id);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('❌ No available doctor for specialization: ' || v_specialization);
        END;
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_auto_assign_waiting
AFTER UPDATE OF availability_status ON Doctors
FOR EACH ROW
WHEN (NEW.availability_status = 'Available')
BEGIN
    Assign_Patient_By_Preference;
END;
/

UPDATE Appointment
SET appointment_status = 'Completed'
WHERE appointment_id = 1001; -- Example


--BEGIN
 --   Assign_Next_Waiting_Patient(201); -- doctor_id
--END;

CREATE OR REPLACE PROCEDURE Assign_Next_Waiting_Patient(p_doctor_id IN INT) IS
    v_patient_id     INT;
    v_new_appt_id    INT := appointment_seq.NEXTVAL;
BEGIN
    -- Get next waiting patient (based on creation time)
    SELECT patient_id INTO v_patient_id
    FROM Waiting_List
    WHERE status = 'Waiting'
    ORDER BY created_at
    FETCH FIRST 1 ROWS ONLY;

    -- Insert into Appointment
    INSERT INTO Appointment (
        appointment_id, patient_id, doctor_id,
        booking_date, appointment_date, appointment_time,
        appointment_status, problem_description, booking_type
    )
    VALUES (
        v_new_appt_id, v_patient_id, p_doctor_id,
        SYSDATE, SYSDATE, '10:00 AM',
        'Scheduled', 'Auto-assigned from waitlist', 'Walk-in'
    );

    -- Mark waiting list as assigned
    UPDATE Waiting_List
    SET status = 'Assigned'
    WHERE patient_id = v_patient_id;

    -- Update doctor availability
    UPDATE Doctors
    SET availability_status = 'Busy'
    WHERE doctor_id = p_doctor_id;

    DBMS_OUTPUT.PUT_LINE('✅ Patient ' || v_patient_id || ' assigned to Doctor ' || p_doctor_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('❌ No waiting patients found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: ' || SQLERRM);
END;
/

--- Generate_Monthly_Report
CREATE OR REPLACE PROCEDURE Generate_Monthly_Report (
    p_month IN VARCHAR2  -- Format: 'YYYY-MM'
)
IS
    v_total_bills       NUMBER := 0;
    v_service_total     NUMBER := 0;
    v_medicine_total    NUMBER := 0;
    v_room_total        NUMBER := 0;
    v_doctor_fee_total  NUMBER := 0;
    v_total_revenue     NUMBER := 0;
BEGIN
    -- Total bills
    SELECT COUNT(*) INTO v_total_bills
    FROM Billing
    WHERE TO_CHAR(bill_date, 'YYYY-MM') = p_month;

    -- Total service charges
    SELECT NVL(SUM(bd.amount), 0) INTO v_service_total
    FROM Billing b
    JOIN Billing_Details bd ON b.bill_id = bd.bill_id
    WHERE TO_CHAR(b.bill_date, 'YYYY-MM') = p_month;

    -- Total medicine charges
    SELECT NVL(SUM(mb.amount), 0) INTO v_medicine_total
    FROM Billing b
    JOIN Medicine_Billing mb ON b.bill_id = mb.bill_id
    WHERE TO_CHAR(b.bill_date, 'YYYY-MM') = p_month;

    -- Total room charges
    SELECT NVL(SUM(r.room_charge * (ra.discharge_date - ra.assign_date)), 0)
    INTO v_room_total
    FROM Room_Assignment ra
    JOIN Room r ON ra.room_id = r.room_id
    JOIN Appointment a ON ra.appointment_id = a.appointment_id
    JOIN Billing b ON a.appointment_id = b.appointment_id
    WHERE TO_CHAR(b.bill_date, 'YYYY-MM') = p_month
      AND ra.discharge_date IS NOT NULL;

    -- Total doctor fees
    SELECT NVL(SUM(d.consultation_fees), 0) INTO v_doctor_fee_total
    FROM Billing b
    JOIN Appointment a ON b.appointment_id = a.appointment_id
    JOIN Doctors d ON a.doctor_id = d.doctor_id
    WHERE TO_CHAR(b.bill_date, 'YYYY-MM') = p_month;

    -- Total Revenue
    v_total_revenue := v_service_total + v_medicine_total + v_room_total + v_doctor_fee_total;

    -- Output the report
    DBMS_OUTPUT.PUT_LINE('📅 Monthly Report for: ' || p_month);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('🧾 Total Bills         : ' || v_total_bills);
    DBMS_OUTPUT.PUT_LINE('🛠️ Services Revenue    : ₹' || v_service_total);
    DBMS_OUTPUT.PUT_LINE('💊 Medicines Revenue   : ₹' || v_medicine_total);
    DBMS_OUTPUT.PUT_LINE('🛏️ Room Charges        : ₹' || v_room_total);
    DBMS_OUTPUT.PUT_LINE('👨‍⚕️ Doctor Fees        : ₹' || v_doctor_fee_total);
    DBMS_OUTPUT.PUT_LINE('💰 Total Revenue       : ₹' || v_total_revenue);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
END;
/
--BEGIN
  --  Generate_Monthly_Report('2025-07');
--END;
--/
--Doctor_Performance_View
CREATE OR REPLACE VIEW Doctor_Performance_View AS
SELECT
    d.doctor_id,
    d.full_name AS doctor_name,
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments,
    NVL(SUM(d.consultation_fees), 0) AS total_revenue
FROM Doctors d
LEFT JOIN Appointment a ON d.doctor_id = a.doctor_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY d.doctor_id, d.full_name, d.specialization;











 

