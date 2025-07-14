SET SERVEROUTPUT ON;

DECLARE
  smtp_host      VARCHAR2(100) := 'localhost';  -- Papercut SMTP
  smtp_port      NUMBER := 25;                 
  sender_email   VARCHAR2(100) := 'nandhakrishnannk63@gmail.com';
  receiver_email VARCHAR2(100) := 'nandhakrishnannp@gmail.com';  
  subject        VARCHAR2(200) := ' Hospital Bill – ₹4975 Paid';
  message_body   CLOB;
  conn           UTL_SMTP.CONNECTION;

BEGIN

  message_body := 
    'Hello Nnadhakrishnan N,' || CHR(13) || CHR(10) || CHR(10) ||
    'Thank you for visiting our hospital.' || CHR(13) || CHR(10) ||
    'Here are your billing details:' || CHR(13) || CHR(10) ||
    ' Bill ID: 4' || CHR(13) ||
    ' Appointment ID: 84' || CHR(13) ||
    '️ Doctor: Dr. Meera (General Medicine)' || CHR(13) ||
    ' Room Type: Private' || CHR(13) ||
    ' Services Used: ECG (Qty: 1, ₹500); X-Ray (Qty: 1, ₹500)' || CHR(13) ||
    ' Medicines: Paracetamol (Qty: 10, ₹25)' || CHR(13) ||
    ' Total Amount: ₹4975' || CHR(13) ||
    ' Paid: ₹4975' || CHR(13) ||
    ' Due: ₹0' || CHR(13) ||
    '️ Bill Date: 2025-07-14 09:55 AM' || CHR(13) ||
    ' Payment Status: Paid' || CHR(13) || CHR(10) || CHR(10) ||
    'We wish you a speedy recovery!' || CHR(13) || CHR(10) || CHR(10) ||
    'Regards,' || CHR(13) || CHR(10) ||
    ' HCL Hospital Management System';

  -- Connect and send email
  conn := UTL_SMTP.OPEN_CONNECTION(smtp_host, smtp_port);
  UTL_SMTP.HELO(conn, smtp_host);

  UTL_SMTP.MAIL(conn, sender_email);
  UTL_SMTP.RCPT(conn, receiver_email);
  UTL_SMTP.OPEN_DATA(conn);

  -- Email headers
  UTL_SMTP.WRITE_DATA(conn, 'From: ' || sender_email || CHR(13));
  UTL_SMTP.WRITE_DATA(conn, 'To: ' || receiver_email || CHR(13));
  UTL_SMTP.WRITE_DATA(conn, 'Subject: ' || subject || CHR(13));
  UTL_SMTP.WRITE_DATA(conn, 'Content-Type: text/plain; charset=UTF-8' || CHR(13));
  UTL_SMTP.WRITE_DATA(conn, CHR(13) || message_body);

  UTL_SMTP.CLOSE_DATA(conn);
  UTL_SMTP.QUIT(conn);

  DBMS_OUTPUT.PUT_LINE('Email sent successfully via Papercut SMTP!');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(' Email send failed: ' || SQLERRM);
END;
/
