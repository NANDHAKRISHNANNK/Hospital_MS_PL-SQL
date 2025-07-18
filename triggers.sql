

--trg_appointment_reminder
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
