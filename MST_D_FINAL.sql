
CREATE DATABASE MST;

USE MST;


-- SEQUENCES

CREATE SEQUENCE SEQ_GUIDE_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 9999;

CREATE SEQUENCE SEQ_TOUR_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 9999;

CREATE SEQUENCE SEQ_LOCATION_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 9999;

CREATE SEQUENCE SEQ_TRIP_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 9999;

CREATE SEQUENCE SEQ_TRANSACTIONS_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 9999;


CREATE TABLE GUIDE(
	GUIDE_ID CHAR(4) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_GUIDE_ID,
	FNAME VARCHAR(25),
	LNAME VARCHAR(25),
	HIRED_DATE DATE NOT NULL,
	CONSTRAINT GUIDE_HIRED_DATE_CK CHECK (HIRED_DATE <= CAST(GETDATE() AS DATE)),
	STRT_NO INT, 
	STRT_NAME VARCHAR(25), 
	CITY VARCHAR(25), 
	ZIP CHAR(6)
);


CREATE TABLE TOUR(
	TOUR_ID CHAR(4) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_TOUR_ID,
	TOUR_NAME CHAR(25) NOT NULL, 
	DURATION TIME,
	FEE NUMERIC NOT NULL,
	CREATED_DATE DATE NOT NULL,
	CONSTRAINT TOUR_CREATED_DATE_CK CHECK (CREATED_DATE <= CAST(GETDATE() AS DATE))
);


CREATE TABLE LOCATION(
	LOCATION_ID CHAR(4) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_LOCATION_ID,
	LOCATION_NAME VARCHAR(25) NOT NULL,
	TYPE VARCHAR(25),
	DESCRIPTION VARCHAR(50),
	STRT_NO INT, 
	STRT_NAME VARCHAR(25), 
	CITY VARCHAR(25), 
	ZIP CHAR(6)

);


CREATE TABLE VISIT(
	TOUR_ID CHAR(4) NOT NULL, --FK
	CONSTRAINT FK_VISIT_TOUR_ID FOREIGN KEY (TOUR_ID) REFERENCES TOUR ON DELETE SET NULL ON UPDATE CASCADE,
	LOCATION_ID CHAR(4) NOT NULL, --FK
	CONSTRAINT VISIT_LOCATION_ID_FK FOREIGN KEY (LOCATION_ID) REFERENCES LOCATION ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT VISIT_TOUR_LOCATION_PK PRIMARY KEY(TOUR_ID, LOCATION_ID) --PK
);


CREATE TABLE QUALIFICATION(
	TOUR_ID CHAR(4), --FK
	CONSTRAINT QUALIFICATION_TOUR_ID_FK FOREIGN KEY (TOUR_ID) REFERENCES TOUR ON DELETE SET NULL ON UPDATE CASCADE,
	GUIDE_ID CHAR(4), --FK
	CONSTRAINT QUALIFICATION_GUIDE_ID_FK FOREIGN KEY (GUIDE_ID) REFERENCES GUIDE ON DELETE NULL ON UPDATE CASCADE,
	CONSTRAINT QUALIFICATION_TOUR_GUIDE_ID_PK PRIMARY KEY(TOUR_ID, GUIDE_ID), --PK
	TEST_DATE DATE NOT NULL

);

CREATE TABLE TRIP(
	TRIP_ID CHAR(4) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_TRIP_ID,
	TOUR_ID CHAR(4), --FK
	CONSTRAINT TRIP_TOUR_ID_FK FOREIGN KEY (TOUR_ID) REFERENCES TOUR ON DELETE CASCADE ON UPDATE CASCADE,
	TRIP_DATE DATE,
	SCHEDULED_TIME TIME,
	CONSTRAINT TRIP_SCHEDULED_TIME_CK CHECK (CREATED_DATE >= CAST(GETDATE() AS DATE)),
	CREATED_DATE DATE NOT NULL,
	CONSTRAINT TRIP_CREATED_DATE_CK CHECK (CREATED_DATE <= CAST(GETDATE() AS DATE))
	
);


CREATE TABLE TOURIST(
	TOURIST_ID INT IDENTITY(1,1)PRIMARY KEY,
	FNAME VARCHAR(25),
	LNAME VARCHAR(25),
	STRT_NO INT, 
	STRT_NAME VARCHAR(25), 
	CITY VARCHAR(25), 
	ZIP CHAR(6)

);


CREATE TABLE TRANSACTIONS(
	TRANSACTIONS_ID CHAR(4) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_TRANSACTIONS_ID,
	TOURIST_ID CHAR(4), --FK
	CONSTRAINT TRANSACTIONS_TOURIST_ID_FK FOREIGN KEY (TOURIST_ID) REFERENCES TOURIST ON DELETE CASCADE ON UPDATE CASCADE,
	PAYMENT_METHOD CHAR(6),
	CARD_NO INT UNIQUE,
	EXPIRATION_DATE DATE,
	CVC INT,
	CARD_HOLDER CHAR(25),				    
	TRANS_DATE DATE
);

CREATE TABLE SIGNUP(
	TRIP_ID CHAR(4) NOT NULL, --FK
	CONSTRAINT SIGNUP_TRIP_ID_FK FOREIGN KEY (TRIP_ID) REFERENCES TRIP ON DELETE SET NULL ON UPDATE CASCADE,
	TOURIST_ID CHAR(4) NOT NULL, --FK
	CONSTRAINT SIGNUP_TOURIST_ID_FK FOREIGN KEY (TOURIST_ID) REFERENCES TOURIST ON DELETE CASCADE,
	CONSTRAINT SIGNUP_TRIP_TOURIST_ID_FK PRIMARY KEY(TRIP_ID, TOURIST_ID), --PK
	SIGNUP_DATE DATE NOT NULL,
);


--CONSTRAINTS
ALTER TABLE TRANSACTIONS
ADD CONSTRAINT TRANSACTIONS_PAYMENT_METHOD_CK CHECK (PAYMENT_METHOD IN ('DEBIT', 'CREDIT'));

ALTER TABLE SIGNUP
ADD CONSTRAINT SIGNUP_SIGNUP_DATE_CK CHECK (SIGNUP_DATE <= CAST(GETDATE() AS DATE));



-- NON-CLUSTERED INDEXES

CREATE INDEX TOUR_NAME_IDX 
ON TOUR(TOUR_NAME);

CREATE INDEX GUIDE_FNAME_IDX
ON GUIDE(FNAME);

CREATE INDEX GUIDE_LNAME_IDX
ON GUIDE(LNAME);



--DROPPING
DROP SEQUENCE SEQ_GUIDE_ID;
DROP SEQUENCE SEQ_TOUR_ID 
DROP SEQUENCE SEQ_LOCATION_ID;
DROP SEQUENCE SEQ_TRIP_ID;
DROP SEQUENCE SEQ_TOURIST_ID;
DROP SEQUENCE SEQ_TRANSACTIONS_ID;

DROP TABLE SIGNUP;
DROP TABLE VISIT;
DROP TABLE LOCATION;
ALTER TABLE TOURIST
DROP CONSTRAINT FK_TOURIST_TRANSACTION_ID;
DROP TABLE TRANSACTIONS;
DROP TABLE TOURIST;
DROP TABLE TRIP;
DROP TABLE QUALIFICATION;
DROP TABLE TOUR;
DROP TABLE GUIDE;






