
CREATE SEQUENCE patient_seq 
START WITH 1001 INCREMENT BY 1;
 
-- Modified Patients Table
CREATE TABLE Patients (
    patient_id        INT PRIMARY KEY,
    full_name         VARCHAR2(100) NOT NULL,
    age               INT NOT NULL CHECK (age > 0),
    mobile            VARCHAR2(20) NOT NULL CHECK (REGEXP_LIKE(mobile, '^(\+91)?[6-9][0-9]{9}$')),
    blood_group       VARCHAR2(10) NOT NULL,
    gender            VARCHAR2(10) NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),
    email             VARCHAR2(100) NOT NULL,
    address           VARCHAR2(100) NOT NULL,
    patient_type      VARCHAR2(20) NOT NULL CHECK (patient_type IN ('Inpatient', 'Outpatient')),
    pt_username       VARCHAR2(50) UNIQUE NOT NULL,
    pt_password       VARCHAR2(100) NOT NULL,
    patient_history   VARCHAR2(500)
);

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
    v_patient_id     INT := patient_seq.NEXTVAL;
    v_hashed_password RAW(256);
BEGIN
    -- 3 is the constant for SHA-256
    v_hashed_password := DBMS_CRYPTO.HASH(
        UTL_I18N.STRING_TO_RAW(p_password_raw, 'AL32UTF8'),
        3  -- SHA-256
    );

    INSERT INTO Patients (
        patient_id, full_name, age, mobile, blood_group, gender,
        email, address, patient_type, pt_username, pt_password, patient_history
    ) VALUES (
        v_patient_id, p_name, p_age, p_mobile, p_blood_group, p_gender,
        p_email, p_address, p_type, p_username, RAWTOHEX(v_hashed_password), p_history
    );

    DBMS_OUTPUT.PUT_LINE(' Patient inserted with hashed password. ID: ' || v_patient_id);
END;
/


BEGIN
    insert_patient('Ravi Kumar', 28, '9876543210', 'A+', 'Male', 'ravi@example.com', 'Chennai', 'Outpatient', 'pt_ravi', 'pass@123', 'No major illness');
    insert_patient('Priya Sharma', 35, '9876543211', 'B+', 'Female', 'priya@example.com', 'Coimbatore', 'Inpatient', 'pt_priya', 'pass@456', 'Allergic to penicillin');
    insert_patient('John Das', 40, '9876543212', 'O-', 'Male', 'john@example.com', 'Madurai', 'Outpatient', 'pt_john', 'pass@789', 'Diabetic');
    insert_patient('Meena Iyer', 52, '9876543213', 'AB+', 'Female', 'meena@example.com', 'Trichy', 'Inpatient', 'pt_meena', 'pass@321', 'Hypertension');
    insert_patient('Arjun Rao', 19, '9876543214', 'B-', 'Male', 'arjun@example.com', 'Salem', 'Outpatient', 'pt_arjun', 'pass@654', 'Fracture - Right Hand');
END;
/

SELECT patient_id, full_name, pt_username, pt_password FROM Patients;


CREATE TABLE IMAGEDATA (
    image_id      INT PRIMARY KEY,
    service_name  VARCHAR2(100) NOT NULL,
    patient_id    INT REFERENCES Patients(patient_id),
    scan_image    BLOB
);


CREATE OR REPLACE DIRECTORY scan_dir AS 'D:\Scans' ; 
GRANT READ ON DIRECTORY scan_dir TO SYSTEM;

CREATE OR REPLACE PROCEDURE proc_insert_imagedata (
    p_image_id     IN INT,
    p_service_name IN VARCHAR2,
    p_patient_id   IN INT,
    p_file_name    IN VARCHAR2  -- example: 'xray1.jpg'
)
IS
    v_bfile  BFILE;
    v_blob   BLOB;
BEGIN
    -- Step 1: Insert row with empty BLOB
    INSERT INTO IMAGEDATA (image_id, service_name, patient_id, scan_image)
    VALUES (p_image_id, p_service_name, p_patient_id, EMPTY_BLOB())
    RETURNING scan_image INTO v_blob;

    -- Step 2: Attach the BFILE from SCAN_DIR (must already exist)
    v_bfile := BFILENAME('SCAN_DIR', p_file_name);

    -- Step 3: Load the file into the BLOB column
    DBMS_LOB.OPEN(v_bfile, DBMS_LOB.LOB_READONLY);
    DBMS_LOB.LoadFromFile(v_blob, v_bfile, DBMS_LOB.GETLENGTH(v_bfile));
    DBMS_LOB.CLOSE(v_bfile);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Image inserted: ' || p_file_name);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Error: ' || SQLERRM);
END;
/


BEGIN
    proc_insert_imagedata(
        3,               -- image_id
        'CT_SCAN',         -- service_name
        1004,            -- patient_id (must exist in Patients)
        'ct_scan.jpeg'      -- image file name in SCAN_DIR
    );
END;
/

GRANT READ ON DIRECTORY SCAN_DIR TO SYSTEM;

SELECT 
    image_id, 
    service_name, 
    patient_id, 
    LENGTH(scan_image) AS size_in_bytes
FROM 
    IMAGEDATA;


SELECT * FROM IMAGEDATA;




