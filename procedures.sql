-- PACKAGE SPECIFICATIO
SET DEFINE OFF;
CREATE OR REPLACE PACKAGE pkg_hospital_mgmt AS
  PROCEDURE insert_patient(
    p_name VARCHAR2, p_age INT, p_mobile VARCHAR2, p_blood_group VARCHAR2,
    p_gender VARCHAR2, p_email VARCHAR2, p_address VARCHAR2, p_type VARCHAR2,
    p_username VARCHAR2, p_password_raw VARCHAR2, p_history VARCHAR2);

  PROCEDURE insert_department(p_name VARCHAR2, p_head VARCHAR2);

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
    p_password    IN VARCHAR2 )
     IS 
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
        DBMS_OUTPUT.PUT_LINE(' Invalid user type');  
        RETURN;  
    END IF;  
  
    -- Determine login status  
    IF v_count > 0 THEN  
        v_status := 'Success';  
        DBMS_OUTPUT.PUT_LINE(' Login successful');  
        
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
        DBMS_OUTPUT.PUT_LINE(' Invalid username or password');  
    END IF;  
  
    -- Insert audit log  
    INSERT INTO Login_Audit (  
        log_id, user_type, username, login_time, status  
    ) VALUES (  
        login_audit_seq.NEXTVAL, p_user_type, p_username, SYSTIMESTAMP, v_status  
    );  
  
EXCEPTION  
    WHEN OTHERS THEN  
        DBMS_OUTPUT.PUT_LINE(' Error: ' || SQLERRM);  
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
    ELSE
        -- Insert into waiting list
        INSERT INTO Waiting_List (
            patient_id, specialization, preferred_doctor, status, created_at
        ) VALUES (
            p_patient_id, p_specialization, p_preferred_doctor, 'Waiting', SYSTIMESTAMP
        );

        DBMS_OUTPUT.PUT_LINE(' No doctor available now. Added to waiting list.');
    END IF;
     END;

  PROCEDURE Generate_Monthly_Report( p_month IN VARCHAR2 )
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
