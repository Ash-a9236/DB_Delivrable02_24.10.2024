
CREATE DATABASE MST;

USE MST;

--ENSURE THAT THE NAMES HERE CORRESPOND WITH THE NAMES IN THE ERD

--TABLE CREATION
--ADD NOT NULL FOR FK MAYBE, MAYBE ADD FOREGIN KEY CONTRAINT AFTER
-- TO IMPLEMENT 1:M M:M ETC THE FK ARENT ALWAYS REFERENCED IN EACH TABLE CHECK WEBSITE 
-- THERES TOO MANY FKS, FOR EACH FOREIGN KEY YOU NEED TO HAVE A LINK.

--ALTER DATABASE MST SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--DROP DATABASE MST;


-- SEQUENCES

CREATE SEQUENCE SEQ_GUIDE_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 999999999;

CREATE SEQUENCE SEQ_TOUR_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 999999999;

CREATE SEQUENCE SEQ_LOCATION_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 999999999;

--CREATE SEQUENCE SEQ_QUALIFICATION_ID 
--START WITH 1
--INCREMENT BY 1 
--MAXVALUE 999999999;

CREATE SEQUENCE SEQ_TRIP_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 999999999;

CREATE SEQUENCE SEQ_TOURIST_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 999999999;

CREATE SEQUENCE SEQ_TRANSACTIONS_ID 
START WITH 1
INCREMENT BY 1 
MAXVALUE 999999999;


CREATE TABLE GUIDE(
	GUIDE_ID CHAR(9) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_GUIDE_ID,
	QUALIFICATION_ID CHAR(9),
	FULL_NAME VARCHAR(100) NOT NULL, --INCLUDES FNAME, LNAME
	HIRED_DATE DATE NOT NULL,
	CONSTRAINT CHK_HIRED_DATE CHECK (HIRED_DATE <= CAST(GETDATE() AS DATE)),
	ADDRESS VARCHAR(100) -- INCLUDES STRT_NO, STRT_NAME, CITY, ZIP
);


CREATE TABLE TOUR(
	TOUR_ID CHAR(9) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_TOUR_ID,
	NAME CHAR(25) NOT NULL, 
	DURATION TIME,
	FEE NUMERIC NOT NULL,
	CREATED_DATE DATE NOT NULL,
	CONSTRAINT CHK_TOUR_CREATED_DATE CHECK (CREATED_DATE <= CAST(GETDATE() AS DATE))
);


CREATE TABLE LOCATION(
	LOCATION_ID CHAR(9) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_LOCATION_ID,
	NAME VARCHAR(25) NOT NULL,
	TYPE VARCHAR(25),
	DESCRIPTION VARCHAR(50),
	ADDRESS VARCHAR(100) NOT NULL -- INCLUDES STRT_NO, STRT_NAME, CITY, ZIP

);


CREATE TABLE VISIT(
	TOUR_ID CHAR(9) NOT NULL, --FK
	CONSTRAINT FK_VISIT_TOUR_ID FOREIGN KEY (TOUR_ID) REFERENCES TOUR ON DELETE CASCADE ON UPDATE CASCADE,
	LOCATION_ID CHAR(9) NOT NULL, --FK
	CONSTRAINT FK_VISIT_LOCATION_ID FOREIGN KEY (LOCATION_ID) REFERENCES LOCATION ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT PK_VISIT_TOUR_LOCATION PRIMARY KEY(TOUR_ID, LOCATION_ID) --PK
);


CREATE TABLE QUALIFICATION(
	TOUR_ID CHAR(9), --FK
	CONSTRAINT FK_QUALIFICATION_TOUR_ID FOREIGN KEY (TOUR_ID) REFERENCES TOUR ON DELETE CASCADE ON UPDATE CASCADE,
	GUIDE_ID CHAR(9), --FK
	CONSTRAINT FK_QUALIFICATION_GUIDE_ID FOREIGN KEY (GUIDE_ID) REFERENCES GUIDE ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT PK_QUALIFICATION_TOUR_GUIDE_ID PRIMARY KEY(TOUR_ID, GUIDE_ID), --PK
	TEST_DATE DATE NOT NULL

);

CREATE TABLE TRIP(
	TRIP_ID CHAR(9) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_TRIP_ID,
	TOUR_ID CHAR(9), --FK
	CONSTRAINT FK_TRIP_TOUR_ID FOREIGN KEY (TOUR_ID) REFERENCES TOUR ON DELETE CASCADE ON UPDATE CASCADE,
	GUIDE_ID CHAR(9), --FK
	CONSTRAINT FK_TRIP_GUIDE_ID FOREIGN KEY (GUIDE_ID) REFERENCES GUIDE ON DELETE CASCADE ON UPDATE CASCADE,
	TRIP_DATE DATE,
	SCHEDULED_TIME TIME, -- CHANGE NAME IN ERD
	CONSTRAINT CHK_TRIP_SCHEDULED_TIME CHECK (CREATED_DATE >= CAST(GETDATE() AS DATE)),
	CREATED_DATE DATE NOT NULL,
	CONSTRAINT CHK_TRIP_CREATED_DATE CHECK (CREATED_DATE <= CAST(GETDATE() AS DATE))
	
);


CREATE TABLE TOURIST(
	TOURIST_ID CHAR(9) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_TOURIST_ID,
	--TRIP_ID CHAR(9), --FK
	--CONSTRAINT FK_TOURIST_TRIP_ID FOREIGN KEY (TRIP_ID) REFERENCES TRIP ON DELETE SET NULL, 
	TRANSACTION_ID CHAR(9), --FK
	FULL_NAME VARCHAR(100) NOT NULL, --INCLUDES FNAME, LNAME
	ADDRESS VARCHAR(100) NOT NULL -- INCLUDES STRT_NO, STRT_NAME, CITY, ZIP

);


CREATE TABLE TRANSACTIONS(
	TRANSACTIONS_ID CHAR(9) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_TRANSACTIONS_ID,
	TOURIST_ID CHAR(9), --FK
	CONSTRAINT FK_TRANSACTIONS_TOURIST_ID FOREIGN KEY (TOURIST_ID) REFERENCES TOURIST ON DELETE CASCADE ON UPDATE CASCADE,
	TRIP_ID CHAR(9), --FK
	CONSTRAINT FK_TRANSACTIONS_TRIP_ID FOREIGN KEY (TRIP_ID) REFERENCES TRIP ON DELETE CASCADE ON UPDATE CASCADE,
	CARD_INFO VARCHAR(100) UNIQUE NOT NULL  --INCLUDES:
						    --PAYMENT_METHOD CHAR(25),
							--CARD_NO INT,
							--EXPIRATION_DATE DATE,
							--CVC INT,
							--CARD_HOLDER CHAR(25)
);

CREATE TABLE SIGNUP(
	TRIP_ID CHAR(9) NOT NULL, --FK
	CONSTRAINT FK_SIGNUP_TRIP_ID FOREIGN KEY (TRIP_ID) REFERENCES TRIP ON DELETE CASCADE ON UPDATE CASCADE,
	TOURIST_ID CHAR(9) NOT NULL, --FK
	CONSTRAINT FK_SIGNUP_TOURIST_ID FOREIGN KEY (TOURIST_ID) REFERENCES TOURIST ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_SIGNUP_TRIP_TOURIST_ID PRIMARY KEY(TRIP_ID, TOURIST_ID), --PK
	SIGNUP_DATE DATE NOT NULL,
	CONSTRAINT CHK_SIGNUP_SIGNUP_DATE CHECK (SIGNUP_DATE <= CAST(GETDATE() AS DATE)) -- ENSURE THAT SIGNUP DATE IS NOT IN THE FUTURE
																					-- ENSURE THAT SIGN UP DATE ISNT PAST SCHEDULED TRIP DATE
);


-- CONTRAINTS
ALTER TABLE TOURIST
ADD CONSTRAINT FK_TOURIST_TRANSACTION_ID FOREIGN KEY (TRANSACTION_ID) REFERENCES TRANSACTIONS;

-- ask about triggers, if its DDL or DML cuz i want to add trigger to verify that a tour visists at least 3 locations.

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






