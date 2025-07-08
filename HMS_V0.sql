-- seq for patient id 
CREATE SEQUENCE SEQ_PATIENT_ID
  START WITH 1001
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
  --create p_table
CREATE TABLE PATIENTS (
  PATIENT_ID INT PRIMARY KEY,
  FULL_NAME VARCHAR2(50) NOT NULL,
  AGE INT CHECK (AGE > 0),
  DATE_OF_BIRTH DATE,
  MOBILE VARCHAR2(10) NOT NULL UNIQUE 
    CHECK (LENGTH(MOBILE) = 10 AND REGEXP_LIKE(MOBILE, '^[0-9]+$')),
  BLOOD_GROUP VARCHAR2(5) 
    CHECK (BLOOD_GROUP IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
  GENDER VARCHAR2(6) 
    CHECK (GENDER IN ('M', 'F', 'Other')), -- O = Other
  EMAIL VARCHAR2(50) UNIQUE,
  ADDRESS VARCHAR2(100),
  PATIENT_TYPE VARCHAR2(15) 
    CHECK (PATIENT_TYPE IN ('INPATIENT', 'OUTPATIENT')),
  PT_USERNAME VARCHAR2(50) UNIQUE NOT NULL,
  PT_PASSWORD VARCHAR2(30) NOT NULL,
  PATIENT_HISTORY VARCHAR2(500),
  CREATED_AT DATE DEFAULT SYSDATE
);
INSERT INTO PATIENTS (
  PATIENT_ID, FULL_NAME, AGE, DATE_OF_BIRTH, MOBILE, BLOOD_GROUP, GENDER,
  EMAIL, ADDRESS, PATIENT_TYPE, PT_USERNAME, PT_PASSWORD, PATIENT_HISTORY
) VALUES (
  SEQ_PATIENT_ID.NEXTVAL, 'John Doe', 30, TO_DATE('1994-05-10', 'YYYY-MM-DD'), 
  '9876543210', 'A+', 'M', 'john@example.com', 'Chennai', 
  'OUTPATIENT', 'john_doe', 'securePass123', 'No previous history'
);
--seq for dept
CREATE SEQUENCE DEPT_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE DEPARTMENTS (
  DEPARTMENT_ID INT PRIMARY KEY,
  DEPARTMENT_NAME VARCHAR2(50) NOT NULL UNIQUE
);
INSERT INTO DEPARTMENTS VALUES (DEPT_SEQ.NEXTVAL, 'Cardiology');
INSERT INTO DEPARTMENTS VALUES (DEPT_SEQ.NEXTVAL, 'Neurology');
INSERT INTO DEPARTMENTS VALUES (DEPT_SEQ.NEXTVAL, 'Orthopedics');
INSERT INTO DEPARTMENTS VALUES (DEPT_SEQ.NEXTVAL, 'Pediatrics');
INSERT INTO DEPARTMENTS VALUES (DEPT_SEQ.NEXTVAL, 'Gynecology');
INSERT INTO DEPARTMENTS VALUES (DEPT_SEQ.NEXTVAL, 'Dermatology');
INSERT INTO DEPARTMENTS VALUES (DEPT_SEQ.NEXTVAL, 'Oncology');
INSERT INTO DEPARTMENTS VALUES (DEPT_SEQ.NEXTVAL, 'ENT');
--seq
CREATE SEQUENCE APPOINTMENT_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
--appointment
CREATE TABLE APPOINTMENT (
  APPOINTMENT_ID INT PRIMARY KEY,
  DATE_AND_TIME TIMESTAMP NOT NULL,
  BOOKING_DATE DATE NOT NULL,
  REASON VARCHAR2(50),
  APPOINTMENT_MODE VARCHAR2(20)
    CHECK (APPOINTMENT_MODE IN ('ONLINE', 'OFFLINE')),
  PRIORITY_LEVEL VARCHAR2(20)
    CHECK (PRIORITY_LEVEL IN ('REGULAR', 'EMERGENCY')),
  STATUS VARCHAR2(20)
    CHECK (STATUS IN ('SCHEDULED', 'COMPLETED', 'CANCELLED')),
  PATIENT_ID INT NOT NULL,
  CONSTRAINT FK_APPOINTMENT_PATIENT
    FOREIGN KEY (PATIENT_ID)
    REFERENCES PATIENTS(PATIENT_ID)
    ON DELETE CASCADE
);
SET DEFINE OFF;
INSERT INTO APPOINTMENT VALUES (
  APPOINTMENT_SEQ.NEXTVAL,
  TO_TIMESTAMP('2025-07-09 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
  TO_DATE('2025-07-08', 'YYYY-MM-DD'),
  'Routine check-up',
  'OFFLINE',
  'REGULAR',
  'SCHEDULED',
  1001
);
 
 --seq service
CREATE SEQUENCE SERVICE_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE SERVICE (
  SERVICE_ID INT PRIMARY KEY,
  SERVICE_NAME VARCHAR2(20) NOT NULL UNIQUE,
  CHARGES DECIMAL(10,2) CHECK (CHARGES >= 0),
  AVAILABILITY_STATUS VARCHAR2(20) CHECK (AVAILABILITY_STATUS IN ('AVAILABLE', 'UNAVAILABLE'))
);

INSERT INTO SERVICE VALUES (SERVICE_SEQ.NEXTVAL, 'X-Ray', 500.00, 'AVAILABLE');
INSERT INTO SERVICE VALUES (SERVICE_SEQ.NEXTVAL, 'MRI Scan', 3500.00, 'AVAILABLE');
INSERT INTO SERVICE VALUES (SERVICE_SEQ.NEXTVAL, 'Blood Test', 250.00, 'AVAILABLE');
INSERT INTO SERVICE VALUES (SERVICE_SEQ.NEXTVAL, 'ECG', 700.00, 'UNAVAILABLE');
INSERT INTO SERVICE VALUES (SERVICE_SEQ.NEXTVAL, 'Physiotherapy', 1000.00, 'AVAILABLE');
INSERT INTO SERVICE VALUES (SERVICE_SEQ.NEXTVAL, 'Ultrasound', 2000.00, 'AVAILABLE');
INSERT INTO SERVICE VALUES (SERVICE_SEQ.NEXTVAL, 'CT Scan', 4000.00, 'UNAVAILABLE');
INSERT INTO SERVICE VALUES (SERVICE_SEQ.NEXTVAL, 'Vaccination', 150.00, 'AVAILABLE');

--seq bill
CREATE SEQUENCE BILL_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
--billing 
CREATE TABLE BILLING (
  BILL_ID INT PRIMARY KEY,
  DATE_ISSUED DATE NOT NULL,
  DISCOUNT DECIMAL(10,2) CHECK (DISCOUNT >= 0),
  TOTAL_AMOUNT DECIMAL(10,2) CHECK (TOTAL_AMOUNT >= 0),
  CURRENT_PAYMENT DECIMAL(10,2) CHECK (CURRENT_PAYMENT >= 0),
  DUE_PAY DECIMAL(10,2) CHECK (DUE_PAY >= 0),
  MODE_OF_PAYMENT VARCHAR2(20)
    CHECK (MODE_OF_PAYMENT IN ('CASH', 'CARD', 'UPI')),
  STATUS VARCHAR2(20)
    CHECK (STATUS IN ('PAID', 'UNPAID', 'PARTIALLY PAID')),
  APPOINTMENT_ID INT NOT NULL,
  SERVICE_ID INT NOT NULL,

  CONSTRAINT FK_BILLING_APPOINTMENT
    FOREIGN KEY (APPOINTMENT_ID)
    REFERENCES APPOINTMENT(APPOINTMENT_ID)
    ON DELETE CASCADE,

  CONSTRAINT FK_BILLING_SERVICE
    FOREIGN KEY (SERVICE_ID)
    REFERENCES SERVICE(SERVICE_ID)
    ON DELETE CASCADE
);

INSERT INTO BILLING VALUES (
  BILL_SEQ.NEXTVAL,
  TO_DATE('2025-07-08', 'YYYY-MM-DD'),
  50.00,
  500.00,
  450.00,
  0.00,
  'CASH',
  'PAID',
  1,
  1
);
--seq staff
DROP SEQUENCE STAFF_SEQ;
CREATE SEQUENCE STAFF_SEQ
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
--staff
CREATE TABLE STAFF (
  STAFF_ID INT PRIMARY KEY,
  FULL_NAME VARCHAR2(50) NOT NULL,
  AGE INT CHECK (AGE > 18),
  MOBILE VARCHAR2(10) NOT NULL UNIQUE 
    CHECK (LENGTH(MOBILE) = 10 AND REGEXP_LIKE(MOBILE, '^[0-9]+$')),
  SALARY DECIMAL(10,2) CHECK (SALARY >= 0),
  GENDER VARCHAR2(6) CHECK (GENDER IN ('M', 'F', 'OTHER')),
  EMAIL VARCHAR2(30) UNIQUE,
  ROLE VARCHAR2(20) NOT NULL,
  ST_USERNAME VARCHAR2(50) UNIQUE NOT NULL,
  ST_PASSWORD VARCHAR2(30) NOT NULL,
  SHIFT VARCHAR2(20) CHECK (SHIFT IN ('MORNING', 'EVENING', 'NIGHT')),
  DEPARTMENT_ID INT NOT NULL,
  APPOINTMENT_ID INT NOT NULL,

  CONSTRAINT FK_STAFF_DEPARTMENT
    FOREIGN KEY (DEPARTMENT_ID)
    REFERENCES DEPARTMENTS(DEPARTMENT_ID)
    ON DELETE CASCADE,

  CONSTRAINT FK_STAFF_APPOINTMENT
    FOREIGN KEY (APPOINTMENT_ID)
    REFERENCES APPOINTMENT(APPOINTMENT_ID)
    ON DELETE CASCADE
);
SELECT * FROM APPOINTMENT WHERE APPOINTMENT_ID = 1;
INSERT INTO APPOINTMENT VALUES (
  1,
  TO_TIMESTAMP('2025-07-09 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
  TO_DATE('2025-07-08', 'YYYY-MM-DD'),
  'Routine check-up',
  'OFFLINE',
  'REGULAR',
  'SCHEDULED',
  1001  -- Make sure this PATIENT_ID exists too
);
INSERT INTO STAFF VALUES (
  STAFF_SEQ.NEXTVAL, 'Dr. Ramesh Rao', 45, '9876543210', 75000.00, 'M', 'ramesh.rao@example.com',
  'Doctor', 'rameshrao', 'DrRao@123', 'MORNING', 1, 1
);
--seq
CREATE SEQUENCE SUMMARY_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE DISCHARGE_SUMMARY (
  SUMMARY_ID INT PRIMARY KEY,
  ADMISSION_DATE DATE NOT NULL,
  DISCHARGE_DATE DATE NOT NULL,
  TREATMENT_GIVEN VARCHAR2(600) NOT NULL,
  CONDITION_ON_DISCHARGE VARCHAR2(500),
  FOLLOWUP_INSTRUCTIONS VARCHAR2(800),
  APPOINTMENT_ID INT NOT NULL,

  CONSTRAINT FK_APPOINTMENT_DISCHARGE
    FOREIGN KEY (APPOINTMENT_ID)
    REFERENCES APPOINTMENT(APPOINTMENT_ID)
    ON DELETE CASCADE
);

INSERT INTO DISCHARGE_SUMMARY VALUES (
  SUMMARY_SEQ.NEXTVAL,
  TO_DATE('2025-07-01', 'YYYY-MM-DD'),
  TO_DATE('2025-07-08', 'YYYY-MM-DD'),
  'General observation and vitals monitoring',
  'Stable and conscious',
  'Continue medications for 5 days. Review after 1 week.',
  1
);
--sequence iteam
CREATE SEQUENCE ITEM_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE INVENTORY (
  ITEM_ID INT PRIMARY KEY,
  ITEM_NAME VARCHAR2(50) NOT NULL,
  CATEGORY VARCHAR2(50) NOT NULL,
  QUANTITY_IN_STOCK INT CHECK (QUANTITY_IN_STOCK >= 0),
  UNIT_OF_MEASURE VARCHAR2(50),
  REORDER_LEVEL INT CHECK (REORDER_LEVEL >= 0),
  LAST_ORDER_DATE DATE,
  UNIT_PRICE DECIMAL(8,2) CHECK (UNIT_PRICE >= 0),
  EXPIRY_DATE DATE,
  BILL_ID INT NOT NULL,

  CONSTRAINT FK_BILL_INVENTORY
    FOREIGN KEY (BILL_ID)
    REFERENCES BILLING(BILL_ID)
    ON DELETE CASCADE
);
INSERT INTO INVENTORY VALUES (
  ITEM_SEQ.NEXTVAL, 'Paracetamol', 'Medicine', 100, 'Tablets', 50,
  TO_DATE('2025-07-01', 'YYYY-MM-DD'), 1.50, TO_DATE('2026-06-30', 'YYYY-MM-DD'), 1
);

SELECT * FROM BILLING WHERE BILL_ID = 1;
INSERT INTO BILLING VALUES (
  BILL_SEQ.NEXTVAL,
  TO_DATE('2025-07-08', 'YYYY-MM-DD'),
  50.00,
  500.00,
  450.00,
  0.00,
  'CASH',
  'PAID',
  1,
  1
);
--seq room
CREATE SEQUENCE ROOM_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
CREATE SEQUENCE ROOM_SEQ
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE TABLE ROOMS (
  ROOM_NUMBER INT PRIMARY KEY,
  ROOM_TYPE VARCHAR2(20) NOT NULL
    CHECK (ROOM_TYPE IN ('PRIVATE', 'GENERAL', 'ICU')),
  CHARGES_PER_DAY DECIMAL(10,2) NOT NULL
    CHECK (CHARGES_PER_DAY >= 0),
  AVAILABILITY_STATUS VARCHAR2(20) NOT NULL
    CHECK (AVAILABILITY_STATUS IN ('AVAILABLE', 'NOT AVAILABLE')),
  APPOINTMENT_ID INT NOT NULL,

  CONSTRAINT FK_APPOINTMENT_ROOM
    FOREIGN KEY (APPOINTMENT_ID)
    REFERENCES APPOINTMENT(APPOINTMENT_ID)
    ON DELETE CASCADE
);
INSERT INTO ROOMS VALUES (
  ROOM_SEQ.NEXTVAL, 'PRIVATE', 2500.00, 'AVAILABLE', 1
);
--doctor
CREATE SEQUENCE DOCTOR_SEQ
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE TABLE DOCTOR (
  DOCTOR_ID INT PRIMARY KEY,
  FULL_NAME VARCHAR2(100) NOT NULL,
  AGE INT CHECK (AGE > 25),
  MOBILE VARCHAR2(20) NOT NULL UNIQUE
         CHECK (REGEXP_LIKE(MOBILE, '^[0-9]{10,}$')),
  QUALIFICATION VARCHAR2(50) NOT NULL,
  GENDER VARCHAR2(10) CHECK (GENDER IN ('M', 'F', 'OTHER')),
  EMAIL VARCHAR2(100) UNIQUE,
  SPECIALIZATION VARCHAR2(50) NOT NULL,
  EXPERIENCE INT CHECK (EXPERIENCE >= 0),
  DEPARTMENT_ID INT NOT NULL,
  DR_USERNAME VARCHAR2(100) UNIQUE NOT NULL,
  DR_PASSWORD VARCHAR2(50) NOT NULL,
  SHIFT VARCHAR2(20) CHECK (SHIFT IN ('MORNING', 'EVENING', 'NIGHT')),
  CONSULTATION_FEES DECIMAL(10,2) CHECK (CONSULTATION_FEES >= 0),
  AVAILABILITY_STATUS VARCHAR2(50) CHECK (AVAILABILITY_STATUS IN ('AVAILABLE', 'NOT AVAILABLE')),
  APPOINTMENT_ID INT NOT NULL,

  CONSTRAINT FK_DOCTOR_DEPT
    FOREIGN KEY (DEPARTMENT_ID)
    REFERENCES DEPARTMENTS(DEPARTMENT_ID)
    ON DELETE CASCADE,

  CONSTRAINT FK_DOCTOR_APPT
    FOREIGN KEY (APPOINTMENT_ID)
    REFERENCES APPOINTMENT(APPOINTMENT_ID)
    ON DELETE CASCADE
);
INSERT INTO DOCTOR VALUES (
  DOCTOR_SEQ.NEXTVAL, 'Dr. Rakesh Mehra', 40, '9876543210', 'MBBS, MD', 'M',
  'rakesh.mehra@example.com', 'Cardiology', 12, 1, 'dr_rakesh', 'Rakesh@123',
  'MORNING', 500.00, 'AVAILABLE', 1
);

CREATE TABLE PATIENT_STAFF (
  PATIENT_ID INT NOT NULL,
  STAFF_ID INT NOT NULL,
 
  CONSTRAINT PK_PATIENT_STAFF PRIMARY KEY (PATIENT_ID, STAFF_ID),
 
  CONSTRAINT FK_PATIENT_TO_PATIENT_STAFF
    FOREIGN KEY (PATIENT_ID)
    REFERENCES PATIENTS(PATIENT_ID)
    ON DELETE CASCADE,
 
  CONSTRAINT FK_STAFF_TO_PATIENT_STAFF
    FOREIGN KEY (STAFF_ID)
    REFERENCES STAFF(STAFF_ID)
    ON DELETE CASCADE
);
INSERT INTO PATIENT_STAFF VALUES (1001, 4);
-----------< insert patient >--------------
CREATE OR REPLACE PACKAGE pkg_user_mgmt AS
  PROCEDURE proc_register_user (
    p_full_name        IN VARCHAR2,
    p_age              IN NUMBER,
    p_dob              IN DATE,
    p_mobile           IN VARCHAR2,
    p_blood_group      IN VARCHAR2,
    p_gender           IN VARCHAR2,
    p_email            IN VARCHAR2,
    p_address          IN VARCHAR2,
    p_patient_type     IN VARCHAR2,
    p_username         IN VARCHAR2,
    p_password         IN VARCHAR2
  );
END pkg_user_mgmt;


CREATE OR REPLACE PACKAGE BODY pkg_user_mgmt AS

  PROCEDURE proc_register_user (
    p_full_name        IN VARCHAR2,
    p_age              IN NUMBER,
    p_dob              IN DATE,
    p_mobile           IN VARCHAR2,
    p_blood_group      IN VARCHAR2,
    p_gender           IN VARCHAR2,
    p_email            IN VARCHAR2,
    p_address          IN VARCHAR2,
    p_patient_type     IN VARCHAR2,
    p_username         IN VARCHAR2,
    p_password         IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO PATIENTS (
      PATIENT_ID, FULL_NAME, AGE, DATE_OF_BIRTH, MOBILE,
      BLOOD_GROUP, GENDER, EMAIL, ADDRESS, PATIENT_TYPE,
      PT_USERNAME, PT_PASSWORD
    ) VALUES (
      SEQ_PATIENT_ID.NEXTVAL, p_full_name, p_age, p_dob, p_mobile,
      p_blood_group, p_gender, p_email, p_address, p_patient_type,
      p_username, p_password
    );

    DBMS_OUTPUT.PUT_LINE('Patient registered successfully.');
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Username or mobile/email already exists.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END;

END pkg_user_mgmt;

BEGIN
  pkg_user_mgmt.proc_register_user(
    p_full_name     => 'Santhos',
    p_age           => 22,
    p_dob           => TO_DATE('2003-07-08', 'YYYY-MM-DD'),
    p_mobile        => '9876543219',
    p_blood_group   => 'A+',
    p_gender        => 'M',
    p_email         => 'nk@example.com',
    p_address       => 'chennai',
    p_patient_type  => 'OUTPATIENT',
    p_username      => 'Sandy',
    p_password      => 'san@12345'
  );
END;


--------------------<appointment_mgmt>------------
CREATE OR REPLACE PACKAGE pkg_appointment_mgmt AS
  PROCEDURE proc_auto_appointment (
    p_patient_id      IN NUMBER,
    p_reason          IN VARCHAR2,
    p_mode            IN VARCHAR2,
    p_priority        IN VARCHAR2,
    p_date_time       IN TIMESTAMP
  );
END pkg_appointment_mgmt;
CREATE OR REPLACE PACKAGE BODY pkg_appointment_mgmt AS

  PROCEDURE proc_auto_appointment (
    p_patient_id      IN NUMBER,
    p_reason          IN VARCHAR2,
    p_mode            IN VARCHAR2,
    p_priority        IN VARCHAR2,
    p_date_time       IN TIMESTAMP
  ) IS
    v_appt_id NUMBER;
  BEGIN
    -- Insert a new appointment
    INSERT INTO APPOINTMENT (
      APPOINTMENT_ID, DATE_AND_TIME, BOOKING_DATE,
      REASON, APPOINTMENT_MODE, PRIORITY_LEVEL, STATUS, PATIENT_ID
    ) VALUES (
      APPOINTMENT_SEQ.NEXTVAL, p_date_time, SYSDATE,
      p_reason, p_mode, p_priority, 'SCHEDULED', p_patient_id
    );

    DBMS_OUTPUT.PUT_LINE('Appointment scheduled successfully for patient ID: ' || p_patient_id);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Error: Patient not found.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END;

END pkg_appointment_mgmt;

BEGIN
  pkg_appointment_mgmt.proc_auto_appointment(
    p_patient_id => 1001,
    p_reason     => 'Fever and cold',
    p_mode       => 'OFFLINE',
    p_priority   => 'REGULAR',
    p_date_time  => TO_TIMESTAMP('2025-07-10 09:30:00', 'YYYY-MM-DD HH24:MI:SS')
  );
END;
-----------<Billing Generation>---------

CREATE OR REPLACE PACKAGE pkg_billing_mgmt AS
  PROCEDURE proc_generate_billing (
    p_appointment_id  IN NUMBER,
    p_service_id      IN NUMBER,
    p_discount        IN NUMBER,
    p_payment         IN NUMBER,
    p_mode_of_payment IN VARCHAR2
  );
END pkg_billing_mgmt;


CREATE OR REPLACE PACKAGE BODY pkg_billing_mgmt AS

  PROCEDURE proc_generate_billing (
    p_appointment_id  IN NUMBER,
    p_service_id      IN NUMBER,
    p_discount        IN NUMBER,
    p_payment         IN NUMBER,
    p_mode_of_payment IN VARCHAR2
  ) IS
    v_total      DECIMAL(10,2);
    v_due        DECIMAL(10,2);
  BEGIN
    -- Get service charge
    SELECT CHARGES INTO v_total
    FROM SERVICE
    WHERE SERVICE_ID = p_service_id;

    -- Apply discount
    v_total := v_total - p_discount;

    -- Calculate due
    v_due := v_total - p_payment;

    -- Insert billing record
    INSERT INTO BILLING (
      BILL_ID, DATE_ISSUED, DISCOUNT, TOTAL_AMOUNT,
      CURRENT_PAYMENT, DUE_PAY, MODE_OF_PAYMENT, STATUS,
      APPOINTMENT_ID, SERVICE_ID
    ) VALUES (
      BILL_SEQ.NEXTVAL, SYSDATE, p_discount, v_total,
      p_payment, v_due, p_mode_of_payment,
      CASE 
        WHEN v_due = 0 THEN 'PAID'
        WHEN p_payment = 0 THEN 'UNPAID'
        ELSE 'PARTIALLY PAID'
      END,
      p_appointment_id, p_service_id
    );

    DBMS_OUTPUT.PUT_LINE('Billing generated successfully.');

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Service not found.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END;

END pkg_billing_mgmt;

BEGIN
  pkg_billing_mgmt.proc_generate_billing(
    p_appointment_id  => 1,
    p_service_id      => 1,
    p_discount        => 50,
    p_payment         => 450,
    p_mode_of_payment => 'CASH'
  );
END;

-------<Discharge Summary >-------
CREATE OR REPLACE PACKAGE pkg_patient_mgmt AS
  PROCEDURE proc_discharge_summary (
    p_admission_date        IN DATE,
    p_discharge_date        IN DATE,
    p_treatment_given       IN VARCHAR2,
    p_condition_on_discharge IN VARCHAR2,
    p_followup_instructions IN VARCHAR2,
    p_appointment_id        IN NUMBER
  );
END pkg_patient_mgmt;
CREATE OR REPLACE PACKAGE BODY pkg_patient_mgmt AS

  PROCEDURE proc_discharge_summary (
    p_admission_date        IN DATE,
    p_discharge_date        IN DATE,
    p_treatment_given       IN VARCHAR2,
    p_condition_on_discharge IN VARCHAR2,
    p_followup_instructions IN VARCHAR2,
    p_appointment_id        IN NUMBER
  ) IS
  BEGIN
    -- Insert discharge summary
    INSERT INTO DISCHARGE_SUMMARY (
      SUMMARY_ID,
      ADMISSION_DATE,
      DISCHARGE_DATE,
      TREATMENT_GIVEN,
      CONDITION_ON_DISCHARGE,
      FOLLOWUP_INSTRUCTIONS,
      APPOINTMENT_ID
    ) VALUES (
      SUMMARY_SEQ.NEXTVAL,
      p_admission_date,
      p_discharge_date,
      p_treatment_given,
      p_condition_on_discharge,
      p_followup_instructions,
      p_appointment_id
    );

    DBMS_OUTPUT.PUT_LINE('Discharge summary recorded successfully.');

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END;

END pkg_patient_mgmt;

BEGIN
  pkg_patient_mgmt.proc_discharge_summary(
    p_admission_date         => TO_DATE('2025-07-01', 'YYYY-MM-DD'),
    p_discharge_date         => TO_DATE('2025-07-08', 'YYYY-MM-DD'),
    p_treatment_given        => 'General observation and medication',
    p_condition_on_discharge => 'Stable',
    p_followup_instructions  => 'Review after 7 days',
    p_appointment_id         => 1
  );
END;

-----<staff assign>---
CREATE OR REPLACE PACKAGE pkg_patient_mgmt AS
  PROCEDURE proc_assign_staff_to_patient (
    p_patient_id IN NUMBER,
    p_staff_id   IN NUMBER
  );
END pkg_patient_mgmt;

CREATE OR REPLACE PACKAGE BODY pkg_patient_mgmt AS

  PROCEDURE proc_assign_staff_to_patient (
    p_patient_id IN NUMBER,
    p_staff_id   IN NUMBER
  ) IS
    v_exists NUMBER;
  BEGIN
    -- Check if the mapping already exists
    SELECT COUNT(*)
    INTO v_exists
    FROM PATIENT_STAFF
    WHERE PATIENT_ID = p_patient_id AND STAFF_ID = p_staff_id;

    IF v_exists = 0 THEN
      -- Insert assignment
      INSERT INTO PATIENT_STAFF (PATIENT_ID, STAFF_ID)
      VALUES (p_patient_id, p_staff_id);

      DBMS_OUTPUT.PUT_LINE('Staff assigned to patient successfully.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Staff already assigned to this patient.');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END;

END pkg_patient_mgmt;

BEGIN
  pkg_patient_mgmt.proc_assign_staff_to_patient(
    p_patient_id => 1001,
    p_staff_id   => 1
  );
END;

---<>---
