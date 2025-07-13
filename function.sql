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



