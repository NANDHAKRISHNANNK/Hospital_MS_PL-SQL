CREATE SEQUENCE patient_seq 
START WITH 1 INCREMENT BY 1
    NOCACHE  
    NOCYCLE;

--Create Patient table

CREATE TABLE Patients (
    patient_id        INT PRIMARY KEY,
    full_name         VARCHAR2(100) NOT NULL,
    age               INT NOT NULL CHECK (age > 0),
    -- Indian mobile number validation
    mobile            VARCHAR2(20) NOT NULL CHECK (
        REGEXP_LIKE(mobile, '^(\+91)?[6-9][0-9]{9}$')
    ),
    blood_group       VARCHAR2(10) NOT NULL CHECK (
        blood_group IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')
    ),
    gender            VARCHAR2(10) NOT NULL CHECK (
        gender IN ('Male', 'Female', 'Other')
    ),
    email             VARCHAR2(100) CHECK (
        REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@gmail\.com$')
    ),
    address           VARCHAR2(100) NOT NULL,
    patient_type      VARCHAR2(20) NOT NULL CHECK (
        patient_type IN ('Inpatient', 'Outpatient')
    ),
    pt_username       VARCHAR2(50) UNIQUE NOT NULL CHECK (
    (REGEXP_LIKE(pt_username, '^[A-Za-z][A-Za-z0-9_]{4,49}$'))
        
    ,
    pt_password       VARCHAR2(100) NOT NULL CHECK (
        LENGTH(pt_password) BETWEEN 8 AND 20 AND
        REGEXP_LIKE(pt_password, '.*[A-Z].*') AND   -- At least one uppercase
        REGEXP_LIKE(pt_password, '.*[a-z].*') AND    -- At least one lowercase
        REGEXP_LIKE(pt_password, '.*[0-9].*') AND     -- At least one digit
        REGEXP_LIKE(pt_password, '.*[!@#$%^&*()].*')    -- At least one special char
    ),
    patient_history   VARCHAR2(500)
);

--- sequ department
CREATE SEQUENCE department_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE  
    NOCYCLE;

    --create a department 
 CREATE TABLE Departments (
    department_id     INT PRIMARY KEY,
    department_name   VARCHAR2(100) NOT NULL,
    department_head   VARCHAR2(100) NOT NULL
);
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
    mobile              VARCHAR2(20) NOT NULL CHECK (REGEXP_LIKE(mobile, '^[6-9][0-9]{9}$')),  
    qualification       VARCHAR2(100) NOT NULL,  
    gender              VARCHAR2(10) NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),  
    email               VARCHAR2(100) NOT NULL CHECK ( REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@gmail\.com$'),  
    specialization      VARCHAR2(100) NOT NULL,  
    experience          INT NOT NULL CHECK (experience >= 0),  
    department_id       INT NOT NULL,  
    dr_username         VARCHAR2(50) UNIQUE NOT NULL CHECK (REGEXP_LIKE(dr_username, '^[A-Za-z][A-Za-z0-9_]{4,49}$')),  
    dr_password         VARCHAR2(64) NOT NULL CHECK (
        LENGTH(dr_password) BETWEEN 8 AND 20 AND
        REGEXP_LIKE(dr_password, '.*[A-Z].*') AND   -- At least one uppercase
        REGEXP_LIKE(dr_password, '.*[a-z].*') AND    -- At least one lowercase
        REGEXP_LIKE(dr_password, '.*[0-9].*') AND     -- At least one digit
        REGEXP_LIKE(dr_password, '.*[!@#$%^&*()].*')    -- At least one special char
    ),  
    shift               VARCHAR2(10) NOT NULL CHECK (shift IN ('Morning', 'Evening', 'Night')),  
    consultation_fees   DECIMAL(10,2) NOT NULL CHECK (consultation_fees >= 0),  
    availability_status VARCHAR2(20) NOT NULL CHECK (availability_status IN ('Available', 'Busy', 'On Leave')),  
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)  
);
--seq_appointment
CREATE SEQUENCE appointment_seq
    START WITH 1001
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
-- create appointment table 
CREATE TABLE Appointment (
    appointment_id       INT PRIMARY KEY,
    patient_id           INT NOT NULL,
    doctor_id            INT NOT NULL,
    booking_date         DATE DEFAULT SYSDATE NOT NULL,
    appointment_date     DATE NOT NULL,
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

--room_seq
CREATE SEQUENCE room_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
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

--seq login
CREATE SEQUENCE login_audit_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
--create table login
CREATE TABLE Login_Audit (  
    log_id        INT PRIMARY KEY,  
    user_type     VARCHAR2(20) NOT NULL,  
    username      VARCHAR2(50) NOT NULL,  
    login_time    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,  
    status        VARCHAR2(20) NOT NULL CHECK (status IN ('Success', 'Failed'))  
);


--Room_Assignment Seq
CREATE SEQUENCE room_assignment_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

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
START WITH 1 INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE Staffs (
    staff_id         INT PRIMARY KEY,
    full_name        VARCHAR2(100) NOT NULL,
    age              INT NOT NULL,
    mobile           VARCHAR2(20) NOT NULL,
    gender           VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')) NOT NULL,
    staff_role       VARCHAR2(25) CHECK (staff_role IN ('Receptionist', 'Nurse', 'Lab Assistant', 'Admin', 'Pharmacist')) NOT NULL,
    salary           DECIMAL(10,2) NOT NULL,
    staff_username   VARCHAR2(50) UNIQUE NOT NULL CHECK (REGEXP_LIKE(staff_username, '^[A-Za-z][A-Za-z0-9_]{4,49}$')), ,
    staff_password   VARCHAR2(21) NOT NULL CHECK (
        LENGTH(staff_password) BETWEEN 8 AND 20 AND
        REGEXP_LIKE(staff_password, '.*[A-Z].*') AND   -- At least one uppercase
        REGEXP_LIKE(staff_password, '.*[a-z].*') AND    -- At least one lowercase
        REGEXP_LIKE(staff_password, '.*[0-9].*') AND     -- At least one digit
        REGEXP_LIKE(staff_password, '.*[!@#$%^&*()].*')    -- At least one special char
    ),  
    department_id    INT NOT NULL,
 
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
--seq inventory
CREATE SEQUENCE inventory_seq START WITH 1 INCREMENT BY 1
NOCACHE
NOCYCLE;
-- Table Inventory
CREATE TABLE Inventory (  
    item_id         INT PRIMARY KEY,  
    item_name       VARCHAR2(100) UNIQUE NOT NULL,  
    item_type       VARCHAR2(50) CHECK (item_type IN ('Medicine', 'Equipment', 'Syringe', 'IV', 'Other')) NOT NULL,  
    quantity        INT NOT NULL,  
    unit_price      DECIMAL(10, 2) NOT NULL,  
    expiry_date     DATE NOT NULL,  
    alert_status    VARCHAR2(10) DEFAULT 'OK' CHECK (alert_status IN ('OK', 'LOW')) NOT NULL  
);
CREATE SEQUENCE service_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
--create service
CREATE TABLE Services (
    service_id       INT PRIMARY KEY,
    service_name     VARCHAR2(100) UNIQUE NOT NULL,
    service_charge   DECIMAL(10, 2) NOT NULL
);
-- SEQUENCE billing 
CREATE SEQUENCE billing__seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- create billing table 
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
-- SEQUENCE billing deatils
CREATE SEQUENCE billing_detail_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

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

-- SEQUENCE Medicine_Billing
CREATE SEQUENCE Medicine_Billing_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE Medicine_Billing (
    med_bill_id     INT PRIMARY KEY,
    bill_id         INT,
    item_id         INT,
    quantity        INT,
    amount          DECIMAL(10,2),
    FOREIGN KEY (bill_id) REFERENCES Billing(bill_id),
    FOREIGN KEY (item_id) REFERENCES Inventory(item_id)
);

-- SEQUENCE Discharge_Summary
CREATE SEQUENCE Discharge_Summary seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

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

----table PATIENT_STAFF

CREATE TABLE PATIENT_STAFF (
PATIENT_ID INT NOT NULL,
STAFF_ID INT NOT NULL,
PRIMARY KEY (PATIENT_ID, STAFF_ID),
FOREIGN KEY (PATIENT_ID) REFERENCES PATIENTS(PATIENT_ID),
FOREIGN KEY (STAFF_ID) REFERENCES STAFF(STAFF_ID)

);

----------------------------<views>----------------------

CREATE OR REPLACE VIEW Billing_History_View AS
SELECT
    b.bill_id,
    a.appointment_id,
    p.patient_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    d.specialization,
    r.room_type,
    srv.services_summary,
    med.medicines_summary,
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
-- Join summarized services
LEFT JOIN (
    SELECT bd.bill_id,
           LISTAGG(s.service_name || ' (Qty: ' || bd.quantity || ', ₹' || bd.amount || ')', '; ') 
           WITHIN GROUP (ORDER BY s.service_name) AS services_summary
    FROM Billing_Details bd
    JOIN Services s ON bd.service_id = s.service_id
    GROUP BY bd.bill_id
) srv ON b.bill_id = srv.bill_id
-- Join summarized medicines
LEFT JOIN (
    SELECT mb.bill_id,
           LISTAGG(i.item_name || ' (Qty: ' || mb.quantity || ', ₹' || mb.amount || ')', '; ') 
           WITHIN GROUP (ORDER BY i.item_name) AS medicines_summary
    FROM Medicine_Billing mb
    JOIN Inventory i ON mb.item_id = i.item_id
    GROUP BY mb.bill_id
) med ON b.bill_id = med.bill_id;



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

---------------------<Doctor_Performance_View>-----------------

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


-----------------------<MATERIALIZED VIEW>-----------------

CREATE MATERIALIZED VIEW mv_billing_summary
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
  TRUNC(bill_date, 'IW') AS week_start,
  COUNT(*) AS bills_count,
  SUM(total_amount) AS total_billed,
  SUM(paid_amount) AS paid_total,
  SUM(due_amount) AS due_total
FROM Billing
GROUP BY TRUNC(bill_date, 'IW');


SELECT * FROM mv_billing_summary;


---------------<index>------- 
CREATE  INDEX idx_patients_username ON Patients(pt_username);
CREATE  INDEX idx_doctors_username ON Doctors(dr_username);
CREATE  INDEX idx_staffs_username ON Staffs(staff_username);

CREATE INDEX idx_billdetails_billid ON Billing_Details(bill_id);
CREATE INDEX idx_medbill_billid ON Medicine_Billing(bill_id);

------------------------<trigger>------------------------

CREATE OR REPLACE TRIGGER check_stock_level  
BEFORE UPDATE ON Inventory  
FOR EACH ROW  
BEGIN  
    IF :NEW.quantity < 10 THEN  
        :NEW.alert_status := 'LOW';  
        DBMS_OUTPUT.PUT_LINE(' Low stock: ' || :NEW.item_name || ' — only ' || :NEW.quantity || ' left.');  
    ELSE  
        :NEW.alert_status := 'OK';  
    END IF;  
END;  
/
----------trg_appointment_reminder--------------
    
CREATE OR REPLACE TRIGGER trg_appointment_reminder
AFTER INSERT ON appointment
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Reminder: Appointment scheduled for patient ID: ' || :NEW.patient_id);
END;
/
    
---trg_room_occupation
    
CREATE OR REPLACE TRIGGER trg_room_occupation
AFTER UPDATE ON ROOMS
FOR EACH ROW
WHEN (NEW.APPOINTMENT_ID IS NOT NULL)
BEGIN
  UPDATE ROOMS
  SET AVAILABILITY_STATUS = 'Not Available'
  WHERE ROOM_NUMBER = :NEW.ROOM_NUMBER;
END;
/
    
--- trg_change_patient_type
    
CREATE OR REPLACE TRIGGER trg_change_patient_type
AFTER UPDATE ON ROOM
FOR EACH ROW
WHEN (NEW.APPOINTMENT_ID IS NOT NULL)
DECLARE
  v_patient_id INT;
BEGIN
  SELECT PATIENT_ID INTO v_patient_id
  FROM APPOINTMENT
  WHERE APPOINTMENT_ID = :NEW.APPOINTMENT_ID;
 
  UPDATE PATIENTS
  SET PATIENT_TYPE = 'Inpatient'
  WHERE PATIENT_ID = v_patient_id;
END;
/
-
 -----<TRIGGER trg_room_set_available>--------   
    
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

-------------------<PACKAGE>-------------------------

-- PACKAGE SPECIFICATIO

CREATE OR REPLACE PACKAGE pkg_hospital_mgmt AS
    
---insert_patient
  PROCEDURE insert_patient(
    p_name VARCHAR2, p_age INT, p_mobile VARCHAR2, p_blood_group VARCHAR2,
    p_gender VARCHAR2, p_email VARCHAR2, p_address VARCHAR2, p_type VARCHAR2,
    p_username VARCHAR2, p_password_raw VARCHAR2, p_history VARCHAR2);

--------insert_department
  PROCEDURE insert_department(p_name VARCHAR2, p_head VARCHAR2);

---insert_doctor
  PROCEDURE insert_doctor(
    p_name VARCHAR2, p_age INT, p_mobile VARCHAR2, p_qualification VARCHAR2,
    p_gender VARCHAR2, p_email VARCHAR2, p_specialization VARCHAR2,
    p_experience INT, p_department_id INT, p_username VARCHAR2,
    p_password_raw VARCHAR2, p_shift VARCHAR2, p_fees DECIMAL, p_status VARCHAR2);


  PROCEDURE insert_room(
    p_room_number VARCHAR2, p_room_type VARCHAR2, p_room_status VARCHAR2,
    p_room_charge DECIMAL, p_appointment_id INT DEFAULT NULL);

  PROCEDURE insert_staff(
    p_name VARCHAR2, p_age INT, p_mobile VARCHAR2, p_gender VARCHAR2,
    p_role VARCHAR2, p_salary DECIMAL, p_username VARCHAR2,
    p_password_raw VARCHAR2, p_dept_id INT);

  PROCEDURE insert_inventory_item(
    p_name VARCHAR2, p_type VARCHAR2, p_quantity INT, p_price DECIMAL, p_expiry DATE);

  PROCEDURE insert_service(p_name VARCHAR2, p_charge DECIMAL);

  PROCEDURE pay_bill(p_bill_id INT, p_payment_amt DECIMAL);

  PROCEDURE update_total_bill_amount(p_bill_id INT);

  PROCEDURE Auto_Assign_Room_By_Type(p_appointment_id INT, p_room_type VARCHAR2);

  PROCEDURE Reset_User_Password(p_user_type VARCHAR2, p_username VARCHAR2, p_new_password VARCHAR2);

  PROCEDURE Discharge_Patient_Room(p_appointment_id INT);

  PROCEDURE Validate_Login(p_user_type VARCHAR2, p_username VARCHAR2, p_password VARCHAR2);

  PROCEDURE Generate_Bill(p_appointment_id INT);

  PROCEDURE Create_Auto_Appointment(
    p_patient_id INT, p_specialization VARCHAR2,
    p_date DATE, p_time VARCHAR2, p_preferred_doctor INT DEFAULT NULL);

  PROCEDURE Generate_Monthly_Report(p_month VARCHAR2);
END pkg_hospital_mgmt;
/

-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY pkg_hospital_mgmt AS

  PROCEDURE insert_patient(
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

    DBMS_OUTPUT.PUT_LINE(' Patient inserted. ID: ' || v_patient_id);
  END;

  PROCEDURE insert_department(  p_name IN VARCHAR2,
    p_head IN VARCHAR2)
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

  PROCEDURE insert_doctor(    
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
    p_status            IN VARCHAR2  ) IS 
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
  
    DBMS_OUTPUT.PUT_LINE(' Doctor inserted successfully with ID: ' || v_new_id);  
    
     END;

  PROCEDURE insert_room(
     p_room_number    IN VARCHAR2,
    p_room_type      IN VARCHAR2,
    p_room_status    IN VARCHAR2,
    p_room_charge    IN DECIMAL,
    p_appointment_id IN INT DEFAULT NULL)
     IS 
       v_room_id INT := room_seq.NEXTVAL;
BEGIN
    INSERT INTO Room (
        room_id, room_number, room_type, room_status, room_charge, appointment_id
    ) VALUES (
        v_room_id, p_room_number, p_room_type, p_room_status, p_room_charge, p_appointment_id
    );
 
    DBMS_OUTPUT.PUT_LINE('Room inserted with ID: ' || v_room_id);
      END;

  PROCEDURE insert_staff(  
      p_name          IN VARCHAR2,
    p_age           IN INT,
    p_mobile        IN VARCHAR2,
    p_gender        IN VARCHAR2,
    p_role          IN VARCHAR2,
    p_salary        IN DECIMAL,
    p_username      IN VARCHAR2,
    p_password_raw  IN VARCHAR2,
    p_dept_id       IN INT) 
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

  PROCEDURE insert_inventory_item(
     p_name       IN VARCHAR2,
    p_type       IN VARCHAR2,
    p_quantity   IN INT,
    p_price      IN DECIMAL,
    p_expiry     IN DATE) IS
       v_id INT := inventory_seq.NEXTVAL;
BEGIN
    INSERT INTO Inventory (
        item_id, item_name, item_type, quantity, unit_price, expiry_date
    ) VALUES (
        v_id, p_name, p_type, p_quantity, p_price, p_expiry
    );
    DBMS_OUTPUT.PUT_LINE(' Inventory item inserted. ID: ' || v_id); 
     END;

  PROCEDURE insert_service(
    p_name   IN VARCHAR2,
    p_charge IN DECIMAL) IS
      v_id INT := service_seq.NEXTVAL;
BEGIN
    INSERT INTO Services (
        service_id, service_name, service_charge
    ) VALUES (
        v_id, p_name, p_charge
    );
 
    DBMS_OUTPUT.PUT_LINE(' Service inserted. ID: ' || v_id);
     
      END;

  PROCEDURE pay_bill(  
   p_bill_id      IN INT,
    p_payment_amt  IN DECIMAL)
     IS
 
     v_paid_amount   DECIMAL(10,2);
    v_total_amount  DECIMAL(10,2);
    v_new_paid      DECIMAL(10,2);
    v_new_due       DECIMAL(10,2);
BEGIN
    -- Validate positive payment
    IF p_payment_amt <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, ' Payment amount must be greater than 0.');
    END IF;
 
    -- Check if bill exists and get current amounts
    SELECT paid_amount, total_amount INTO v_paid_amount, v_total_amount
    FROM Billing WHERE bill_id = p_bill_id;
 
    -- Prevent overpayment
    IF (v_paid_amount + p_payment_amt) > v_total_amount THEN
        RAISE_APPLICATION_ERROR(-20002, ' Payment exceeds total bill amount.');
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
 
    DBMS_OUTPUT.PUT_LINE(' Payment recorded. Paid: ' || v_new_paid || ', Due: ' || v_new_due);
 

     END;

  PROCEDURE update_total_bill_amount( p_bill_id IN INT) 
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
 
    DBMS_OUTPUT.PUT_LINE(' Final Bill: ₹' || v_total || 
                         ' (Room ₹' || v_room_charge || 
                         ', Doctor ₹' || v_doctor_fee || 
                         ', Services ₹' || v_service_total || 
                         ', Medicines ₹' || v_medicine_total || ')');
   END;


  PROCEDURE Auto_Assign_Room_By_Type( 
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
 
        DBMS_OUTPUT.PUT_LINE(' ' || p_room_type || ' room ' || v_room_id || ' assigned to appointment ' || p_appointment_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE(' No available room of type: ' || p_room_type);
    END IF;
      END;

  PROCEDURE Reset_User_Password(  p_user_type     IN VARCHAR2,  -- 'Doctor', 'Staff', 'Patient'
    p_username      IN VARCHAR2,
    p_new_password  IN VARCHAR2) IS 
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
        DBMS_OUTPUT.PUT_LINE(' Invalid user type. Use Doctor, Staff, or Patient.');
        RETURN;
    END IF;

    IF rows_updated = 0 THEN
        DBMS_OUTPUT.PUT_LINE(' No such user found: ' || p_username);
    ELSE
        DBMS_OUTPUT.PUT_LINE(' Password updated for ' || p_user_type || ' : ' || p_username);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
     END;


  PROCEDURE Discharge_Patient_Room(p_appointment_id IN INT)
   IS 
    v_room_id        Room.room_id%TYPE;
    v_discharge_date Room_Assignment.discharge_date%TYPE;
BEGIN
    -- Check if an active assignment exists
    SELECT room_id, discharge_date INTO v_room_id, v_discharge_date
    FROM Room_Assignment
    WHERE appointment_id = p_appointment_id;
 
    -- Check if already discharged
    IF v_discharge_date IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(' Patient already discharged. Room: ' || v_room_id);
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
 
    DBMS_OUTPUT.PUT_LINE(' Patient discharged and room ' || v_room_id || ' is now available.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(' No room assignment found for appointment ID: ' || p_appointment_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Error: ' || SQLERRM);
    END;

 PROCEDURE Validate_Login(
    p_user_type   IN VARCHAR2,
    p_username    IN VARCHAR2,
    p_password    IN VARCHAR2
) IS
    v_user_id   INT;
    v_status    VARCHAR2(20);
BEGIN
    BEGIN
        IF UPPER(p_user_type) = 'PATIENT' THEN
            SELECT patient_id INTO v_user_id
            FROM Patients
            WHERE pt_username = p_username AND pt_password = p_password;
 
        ELSIF UPPER(p_user_type) = 'DOCTOR' THEN
            SELECT doctor_id INTO v_user_id
            FROM Doctors
            WHERE dr_username = p_username AND dr_password = p_password;
 
        ELSIF UPPER(p_user_type) = 'STAFF' THEN
            SELECT staff_id INTO v_user_id
            FROM Staffs
            WHERE staff_username = p_username AND staff_password = p_password;
 
        ELSE
            DBMS_OUTPUT.PUT_LINE('Invalid user type');
            RETURN;
        END IF;
 
        -- Login success
        v_status := 'Success';
        DBMS_OUTPUT.PUT_LINE('Login successful');
 
        -- Show dashboard
        IF UPPER(p_user_type) = 'PATIENT' THEN
            DBMS_OUTPUT.PUT_LINE('--- Patient Dashboard ---');
            FOR rec IN (
                SELECT * FROM Patient_Dashboard_View
                WHERE patient_id = v_user_id
            ) LOOP
                DBMS_OUTPUT.PUT_LINE('Appointment ID: ' || rec.appointment_id ||
                                     ', Status: ' || rec.appointment_status ||
                                     ', Due: ₹' || rec.due_amount);
            END LOOP;
 
        ELSIF UPPER(p_user_type) = 'DOCTOR' THEN
            DBMS_OUTPUT.PUT_LINE('--- Doctor Dashboard ---');
            SELECT COUNT(*) INTO v_user_id FROM Appointment WHERE doctor_id = v_user_id;
            DBMS_OUTPUT.PUT_LINE('Total Appointments: ' || v_user_id);
 
        ELSIF UPPER(p_user_type) = 'STAFF' THEN
            DBMS_OUTPUT.PUT_LINE('--- Staff Dashboard ---');
            FOR rec IN (
                SELECT * FROM Staff_Dashboard_View
                WHERE appointment_status = 'Scheduled'
            ) LOOP
                DBMS_OUTPUT.PUT_LINE('Appointment ID: ' || rec.appointment_id ||
                                     ', Patient: ' || rec.patient_name ||
                                     ', Doctor: ' || rec.doctor_name);
            END LOOP;
        END IF;
 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_status := 'Failed';
            DBMS_OUTPUT.PUT_LINE('Invalid username or password');
    END;
 
   --- Audit log
    INSERT INTO Login_Audit (
        log_id, user_type, username, login_time, status
    ) VALUES (
        login_audit_seq.NEXTVAL, p_user_type, p_username, SYSTIMESTAMP, v_status
    );
 
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        INSERT INTO Login_Audit (
            log_id, user_type, username, login_time, status
        ) VALUES (
            login_audit_seq.NEXTVAL, p_user_type, p_username, SYSTIMESTAMP, 'Error'
        );
END;

  PROCEDURE Generate_Bill(p_appointment_id IN INT) IS
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
    DBMS_OUTPUT.PUT_LINE(' Final Bill Generated');
    DBMS_OUTPUT.PUT_LINE(' Medicine  : ₹' || v_medicine_total);
    DBMS_OUTPUT.PUT_LINE(' Services : ₹' || v_service_total);
    DBMS_OUTPUT.PUT_LINE(' Room      : ₹' || v_room_total);
    DBMS_OUTPUT.PUT_LINE(' Doctor    : ₹' || v_doctor_fee);
    DBMS_OUTPUT.PUT_LINE(' Total     : ₹' || v_total);
    DBMS_OUTPUT.PUT_LINE(' Paid      : ₹' || v_paid || ' | Due: ₹' || (v_total - v_paid));
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(' Billing record not found for appointment ID: ' || p_appointment_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Error: ' || SQLERRM);
    END;

  PROCEDURE Create_Auto_Appointment(
    p_patient_id     IN INT,
    p_specialization IN VARCHAR2,
    p_date           IN DATE,
    p_time           IN VARCHAR2,
    p_preferred_doctor IN INT DEFAULT NULL
    ) IS 
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

        DBMS_OUTPUT.PUT_LINE(' Appointment created with Doctor ID: ' || v_doctor_id);
   
    END IF;
     END;

  PROCEDURE Generate_Monthly_Report( p_month IN VARCHAR2 )
   IS
    
    v_total_bills       NUMBER := 0;
    v_service_total     NUMBER := 0;
    v_medicine_total    NUMBER := 0;
    v_room_total        int := 0;
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
    DBMS_OUTPUT.PUT_LINE(' Monthly Report for: ' || p_month);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' Total Bills         : ' || v_total_bills);
    DBMS_OUTPUT.PUT_LINE(' Services Revenue    : ₹' || v_service_total);
    DBMS_OUTPUT.PUT_LINE(' Medicines Revenue   : ₹' || v_medicine_total);
    DBMS_OUTPUT.PUT_LINE(' Room Charges        : ₹' || v_room_total);
    DBMS_OUTPUT.PUT_LINE(' Doctor Fees        : ₹' || v_doctor_fee_total);
    DBMS_OUTPUT.PUT_LINE(' Total Revenue       : ₹' || v_total_revenue);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
     END;

END pkg_hospital_mgmt;
/

-----------------------<function>-------------------

    --function calculate_discount
CREATE OR REPLACE FUNCTION calculate_discount (
    p_total_amount IN NUMBER,
    p_percent      IN NUMBER
) RETURN NUMBER IS
    v_discount NUMBER;
BEGIN
    v_discount := (p_total_amount * p_percent) / 100;
    RETURN v_discount;
END;
/
SELECT calculate_discount(2000, 10) AS discount FROM dual;

---count_available_rooms
CREATE OR REPLACE FUNCTION count_available_rooms
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM room
  WHERE UPPER(room_status) = 'AVAILABLE';
  
  RETURN v_count;
END;
/

SELECT count_available_rooms AS available_rooms FROM dual;

--count_available_doctors
CREATE OR REPLACE FUNCTION count_available_doctors
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM doctors
  WHERE UPPER(availability_status) = 'AVAILABLE';

  RETURN v_count;
END;
/

SELECT count_available_doctors AS available_doctors FROM dual;

--calculate_room_bill
CREATE OR REPLACE FUNCTION calculate_room_bill (
    p_room_number IN VARCHAR2,
    p_days        IN NUMBER
) RETURN NUMBER IS
  v_rate NUMBER(10, 2);
BEGIN
  SELECT room_charge INTO v_rate
  FROM room
  WHERE room_number = p_room_number;

  RETURN v_rate * p_days;
END;
/
SELECT calculate_room_bill('R101', 3) AS total_bill FROM dual;

-- Step 1: Create Object Type
CREATE OR REPLACE TYPE room_info_obj AS OBJECT (
  room_number VARCHAR2(10),
  room_type   VARCHAR2(20)
);
/

-- Step 2: Create Table Type of Objects
CREATE OR REPLACE TYPE room_info_table AS TABLE OF room_info_obj;
/

-- Step 3: Function Returning Available Rooms
CREATE OR REPLACE FUNCTION get_available_rooms
RETURN room_info_table PIPELINED
AS
BEGIN
  FOR rec IN (
    SELECT room_number, room_type
    FROM room
    WHERE UPPER(room_status) = 'AVAILABLE'
  )
  LOOP
    PIPE ROW (room_info_obj(rec.room_number, rec.room_type));
  END LOOP;
  RETURN;
END;
/

SELECT * FROM TABLE(get_available_rooms);
