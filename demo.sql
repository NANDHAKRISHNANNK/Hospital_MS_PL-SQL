---insert patient id 65
begin
    pkg_hospital_mgmt.insert_patient(
    'nandhu',
     22,'7779503210','B+','Male','nandhuu@gmail.com',
     'Chennai','Outpatient','nandhu_kri','nandhu01', 'fever'
  );
END;
/
--appointment id 84 doc 12
---When an appointment is scheduled, the trigger trg_appointment_reminder will automatically execute.

BEGIN
  pkg_hospital_mgmt.Create_Auto_Appointment(65, 'General Medicine', SYSDATE , '10:00 AM');
END;


--give a appointment id in the parameter
--romm no 2 
BEGIN
 pkg_hospital_mgmt.Auto_Assign_Room_By_Type(84, 'Private');
END;



INSERT INTO Billing VALUES
 (4, 84, SYSDATE, 0, 0, 0, 'Pending');  -- bill id ,appointment id  

--billing details 

INSERT INTO Billing_Details (bill_detail_id, bill_id, service_id, quantity, amount, service_date)
VALUES (10, 4, 2, 1, 500, SYSDATE);

--medical billing

INSERT INTO Medicine_Billing VALUES 
(5, 4, 1, 10, 25); --MED_BILL_ID, BILL_ID,ITEM_ID,QUANTITY,AMOUNT

--update total bill

BEGIN
  pkg_hospital_mgmt.update_total_bill_amount(4);--bill_id
END;

--Discharge_Patient_Room give appointment id in the parameter 

BEGIN
  pkg_hospital_mgmt.Discharge_Patient_Room(84);
END;

--pay bill  bill id , amount
BEGIN
  pkg_hospital_mgmt.pay_bill(4,4975 );
END;

--generate Generate_Monthly_Report
BEGIN
  pkg_hospital_mgmt.Generate_Monthly_Report('2025-07');
END;

------------------<LOgin>-------------------
BEGIN
   pkg_hospital_mgmt.Validate_Login('PATIENt','nandhu_kri','nandhu06');
end;

-----------------<Reset Password>------------

BEGIN
    pkg_hospital_mgmt.Reset_User_Password('PATIENt','nandhu_kri','nandhu06');
    end;
------------<views>-------------

SELECT * FROM Patient_Dashboard_View;
SELECT * FROM Doctor_Dashboard_View;
SELECT * FROM Staff_Dashboard_View;
--admin purpose views
SELECT * FROM Admin_Overview_View;
SELECT * FROM Doctor_Performance_View;
SELECT * FROM Billing_History_View;

-------------<Function>-------------
SELECT calculate_discount(2000, 10) AS discount FROM dual;
SELECT count_available_rooms AS available_rooms FROM dual;
SELECT count_available_doctors AS available_doctors FROM dual;
SELECT calculate_room_bill('R101', 3) AS total_bill FROM dual;
SELECT * FROM TABLE(get_available_rooms);










