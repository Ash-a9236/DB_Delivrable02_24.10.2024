--CREATE DATABASE MST;

--USE MST;
/*
DDL Statements 18% :
--You did not explain any ON DELETE actions for your foreign key constraints

--You did declare IDENTITY and SEQUENCE, but use it!

Create Indexes 10%
DML (Sample Test Data) 5% : Data entry errors!
Script File 2% : Error encountered while running your script.
*/

-- SEQUENCES
CREATE SEQUENCE SEQ_GUIDE_ID 
START WITH 1001
INCREMENT BY 1 
MAXVALUE 9999;--

CREATE SEQUENCE SEQ_TOUR_ID 
START WITH 3601
INCREMENT BY 1 
MAXVALUE 9999;--

CREATE SEQUENCE SEQ_LOCATION_ID 
START WITH 5701
INCREMENT BY 1 
MAXVALUE 9999;--


CREATE SEQUENCE SEQ_TRIP_ID 
START WITH 7501
INCREMENT BY 1 
MAXVALUE 9999;--

CREATE SEQUENCE SEQ_TRANSACTIONS_ID 
START WITH 8501
INCREMENT BY 1 
MAXVALUE 9999;--

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
);--

CREATE TABLE TOUR(
	TOUR_ID CHAR(4) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_TOUR_ID,
	TOUR_NAME CHAR(25) NOT NULL, 
	DURATION INT,
	FEE NUMERIC NOT NULL,
	CREATED_DATE DATE NOT NULL,
	CONSTRAINT TOUR_CREATED_DATE_CK CHECK (CREATED_DATE <= CAST(GETDATE() AS DATE))
);--

CREATE TABLE LOCATION(
	LOCATION_ID CHAR(4) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_LOCATION_ID,
	LOCATION_NAME VARCHAR(50) NOT NULL,
	TYPE VARCHAR(50),
	DESCRIPTION VARCHAR(300),
	STRT_NO INT, 
	STRT_NAME VARCHAR(25), 
	CITY VARCHAR(25), 
	ZIP CHAR(6)
);--

CREATE TABLE TRIP(
	TRIP_ID CHAR(4) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_TRIP_ID,
	TOUR_ID CHAR(4), --FK
	GUIDE_ID CHAR(4), --FK
	CONSTRAINT TRIP_GUIDE_ID_FK FOREIGN KEY (GUIDE_ID) REFERENCES GUIDE ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT TRIP_TOUR_ID_FK FOREIGN KEY (TOUR_ID) REFERENCES TOUR ON DELETE CASCADE ON UPDATE CASCADE,
	TRIP_DATE DATE,
	SCHEDULED_TIME TIME,
	CREATED_DATE DATE NOT NULL,
	CONSTRAINT TRIP_CREATED_DATE_CK CHECK (CREATED_DATE <= GETDATE())
);--

CREATE TABLE VISIT(
	TOUR_ID CHAR(4) NOT NULL, --FK
	CONSTRAINT FK_VISIT_TOUR_ID FOREIGN KEY (TOUR_ID) REFERENCES TOUR ON DELETE CASCADE ON UPDATE CASCADE,
	LOCATION_ID CHAR(4) NOT NULL, --FK
	CONSTRAINT VISIT_LOCATION_ID_FK FOREIGN KEY (LOCATION_ID) REFERENCES LOCATION ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT VISIT_TOUR_LOCATION_PK PRIMARY KEY(TOUR_ID, LOCATION_ID) --PK
);--I DID ON DELETE CASCADE INSTEAD OF SET NULL BECAUSE THERE IS A FK PROBLEM IF IT BECOMES NULL FOR THE FK_VISIT_TOUR_ID

CREATE TABLE QUALIFICATION(
	TOUR_ID CHAR(4), --FK
	CONSTRAINT QUALIFICATION_TOUR_ID_FK FOREIGN KEY (TOUR_ID) REFERENCES TOUR ON DELETE CASCADE ON UPDATE CASCADE,
	GUIDE_ID CHAR(4), --FK
	CONSTRAINT QUALIFICATION_GUIDE_ID_FK FOREIGN KEY (GUIDE_ID) REFERENCES GUIDE ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT QUALIFICATION_TOUR_GUIDE_ID_PK PRIMARY KEY(TOUR_ID, GUIDE_ID), --PK
	TEST_DATE DATE NOT NULL
);--I DID ON DELETE CASCADE INSTEAD OF SET NULL BECAUSE THERE IS A FK PROBLEM IF IT BECOMES NULL FOR THE QUALIFICATION_TOUR_ID_FK AND QUALIFICATION_GUIDE_ID_FK

CREATE TABLE TOURIST(
	TOURIST_ID INT IDENTITY(1,1)PRIMARY KEY,
	FNAME VARCHAR(25),
	LNAME VARCHAR(25),
	STRT_NO INT, 
	STRT_NAME VARCHAR(25), 
	CITY VARCHAR(25), 
	ZIP CHAR(6)
);--

CREATE TABLE TRANSACTIONS(
	TRANSACTIONS_ID CHAR(4) PRIMARY KEY DEFAULT NEXT VALUE FOR SEQ_TRANSACTIONS_ID,
	TOURIST_ID INT, --FK
	CONSTRAINT TRANSACTIONS_TOURIST_ID_FK FOREIGN KEY(TOURIST_ID) REFERENCES TOURIST ON DELETE CASCADE ON UPDATE CASCADE,
	PAYMENT_METHOD CHAR(6),
	CARD_NO CHAR(20),--INT UNIQUE: MUST BE CHANGED TO NOT UNIQUE BECAUSE YOU CAN USE THE CARD TO PAY AGIAN FOR YOU OR SOMEONE ELSE. ALSO CHANGED TO CHAR(20) IF POSSIBLE
	EXPIRATION_DATE DATE,
	CVC INT,
	CARD_HOLDER CHAR(25),  
	TRANS_DATE DATE, 
	AMOUNT MONEY NOT NULL
);

CREATE TABLE SIGNUP(
	TRIP_ID CHAR(4) NOT NULL, --FK, 
	TRANSACTION_ID CHAR(4) NOT NULL, --FK
	CONSTRAINT SIGNUP_TRANSACTION_ID_FK FOREIGN KEY (TRANSACTION_ID) REFERENCES TRANSACTIONS ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT SIGNUP_TRIP_ID_FK FOREIGN KEY (TRIP_ID) REFERENCES TRIP ON DELETE CASCADE ON UPDATE CASCADE,
	TOURIST_ID INT NOT NULL, --FK
	CONSTRAINT SIGNUP_TOURIST_ID_FK FOREIGN KEY(TOURIST_ID) REFERENCES TOURIST ON DELETE CASCADE,
	CONSTRAINT SIGNUP_TRIP_TOURIST_ID_FK PRIMARY KEY(TRIP_ID, TOURIST_ID), --PK
	SIGNUP_DATE DATE NOT NULL,
);--


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
ON GUIDE(LNAME);--


-- INSERT STATMENTS
-- Website used to find information such as random names or card numbers : 
-- https://www.fakenamegenerator.com/advanced.php?t=country&n%5B%5D=us&c%5B%5D=ca&gen=50&age-min=19&age-max=85

INSERT INTO GUIDE (FNAME, LNAME, HIRED_DATE, STRT_NO, STRT_NAME, CITY, ZIP) VALUES
    ('Connie', 'Slater', '2024/03/15', '3707', 'Ontario O', 'Montreal', 'H2X1Y8'),
    ('Stanley', 'Mathews', '2024/05/02', '4759', 'Ste. Catherine Ouest', 'Montreal', 'H3B4W5'),
    ('Joanne', 'Ramos', '2024/05/17', '2872', 'rue Levy', 'Montreal', 'H3C5K4'),
    ('Cordelia', 'Everett', '2024/07/25', '1376', 'Papineau Avenue', 'Montreal', 'H2K4J5');
SELECT * FROM GUIDE;--

INSERT INTO TOUR(TOUR_NAME, DURATION, FEE, CREATED_DATE) VALUES 
    ('The Parks', 3, 100, '2023/02/20'),
    ('The Museums', 1.5, 200, '2023/05/15'),
    ('Markets', 3, 120, '2023/10/07'),
    ('Religious Heritage', 2, 150, '2023/11/18');
SELECT * FROM TOUR;--

INSERT INTO QUALIFICATION(TOUR_ID, GUIDE_ID, TEST_DATE) VALUES 
    ('3601', '1001', '2024/03/20'), -- Connie {Parks, Markets}
    ('3603', '1001', '2024/03/30'),
    ('3602','1002',  '2024/05/07'), -- Stanley {Museums, Markets}
    ('3603','1002', '2024/05/17'),
    ('3601', '1003', '2024/05/22'), -- Joanne {Parks, Religious Heritage}
    ('3604', '1003', '2024/05/27'),
    ('3602', '1004', '2024/07/30'), -- Cordelia {Museums, Religious Heritage}
    ('3604', '1004', '2024/08/05');
SELECT * FROM QUALIFICATION;

INSERT INTO TRIP(TOUR_ID, GUIDE_ID, TRIP_DATE, SCHEDULED_TIME, CREATED_DATE) VALUES 
    ('3601', '1001','2025/08/02', '10:30:00', '2024/07/01'),
    ('3602', '1001', '2025/08/03', '14:09:00', '2024/07/01'),
    ('3603', '1002', '2025/08/09', '10:30:00', '2024/07/01'),
    ('3604', '1004', '2025/08/10', '14:30:00', '2024/07/01'),
    ('3601', '1003', '2025/08/16', '10:30:00', '2024/07/08'),
    ('3602', '1004', '2025/08/17', '14:00:00', '2024/07/08'),
    ('3603', '1002', '2025/08/23', '10:30:00', '2024/07/08'),
    ('3604', '1001', '2025/08/24', '14:30:00', '2024/07/08'),
    ('3601', '1003', '2025/08/30', '10:30:00', '2024/07/15'),
    ('3602', '1001', '2025/09/01', '14:00:00', '2024/07/15'),
    ('3603', '1002', '2025/09/07', '10:30:00', '2024/07/15'),
    ('3604', '1001', '2025/09/08', '14:30:00', '2024/07/15');
SELECT * FROM TRIP;
SELECT * FROM GUIDE;

INSERT INTO LOCATION(LOCATION_NAME, TYPE, DESCRIPTION, STRT_NO, STRT_NAME, CITY, ZIP) VALUES 
    ('Mont Royal Park', 'Park', 'A beautiful park on a small mountain with multiple trails to hike, picknic spots, and a stunning view of the city', 1260, 'Remembrance Rd', 'Montreal', 'H3H1A2'),
    ('Notre-Dame Basilica', 'Religious Cultural Heritage', 'A stunning Gothic Revival church known for its beautiful interior with its splendid woodwork, stained glass, and lighting', 110, 'Notre-Dame St W', 'Montreal', 'H2Y1T1'),
    ('Montreal Museum of Fine Arts', 'Museum', 'A museum showcasing multiple very diverse collections from classical to contemporary art, by Canadian or international artists', 1380, 'Sherbrooke St W', 'Montreal', 'H3G1J5'),
    ('Jean-Talon Market', 'Market', 'A lively market with fresh and local produces and baked goods.', 7070, 'Henri-Julien Ave', 'Montreal', 'H2S3S3'),
    ('Atwater Market', 'Market', 'A vibrant market located near the Lachine Canal with fresh and local produces and baked goods.', 138, 'Atwater Ave', 'Montreal', 'H4C2H6'),
    ('Biodome de Montreal', 'Zoo', 'An indoor nature exhibit of Canada s multiple and very distinct biomes.', 4777, 'Pierre-De Coubertin Ave', 'Montreal', 'H1V1B3'),
    ('Saint Joseph Oratory', 'Religious Cultural Heritage', 'A stunning basilica located on the Mont Royal, with its breath taking dome, gardens, and city view.', 3800, 'Queen Mary Rd', 'Montreal', 'H3V1H6'),
    ('Botanical Garden', 'Garden', 'One of the largest botanical gardens in the world, with themed gardens and greenhouses that change following the seasons.', 4101, 'Sherbrooke St E', 'Montreal', 'H1X2B2'),
    ('Musee Pointe-à-Callière', 'Museum', 'A museum highlinting the history of Montreal through its archeology', 350, 'Place Royale', 'Montreal', 'H2Y3Y5'),
    ('Parc Jean-Drapeau', 'Park', 'A gigantic park set on two islands with year-round events such as the F1 on the Gilles Villeneuve circuit.', 1, 'Circuit Gilles Villeneuve', 'Montreal', 'H3C1A9');
SELECT * FROM LOCATION;--

INSERT INTO VISIT(TOUR_ID, LOCATION_ID) VALUES 
    ('3601', '5701'), -- Parks
    ('3601', '5708'),
    ('3601', '5710'),
    ('3602', '5703'), -- Museums
    ('3602', '5702'),
    ('3602', '5709'),
    ('3603', '5704'), -- Markets
    ('3603', '5705'),
    ('3603', '5702'),
    ('3604', '5702'), -- Religous Heritage
    ('3604', '5707'),
    ('3604', '5705');
SELECT * FROM VISIT;--

INSERT INTO TOURIST(FNAME, LNAME, STRT_NO, STRT_NAME, CITY, ZIP) VALUES 
    ('Glenn', 'Smith', 2169, 'rue Saint-Antoine', 'Granby', 'J1S5T7'),
    ('Phyllis', 'Perry', 2076, 'Bank St', 'Ottawa', 'K1H7Z1'),
    ('Barbara', 'Reagan', 1076, 'Wentz Avenue', 'Saskatoon', 'S7K7A9'),
    ('Steven', 'Hintz', 3508, 'Tycos Dr', 'Toronto', 'M5T1T4'),
    ('Brenda', 'Mott', 1290, 'avenue Royale', 'Quebec', 'G1R5B2'),
    ('John', 'McLaughlin', 968, 'De LAcadie Boul', 'Montreal', 'H4N3C5'),
    ('Jose', 'Ybarra', 2288, 'Essendene Avenu', 'Abbotsford', 'V2S2H7'),
    ('Lester', 'Casanova', 2832, 'MacLaren Street', 'Ottawa', 'K1P5M7'),
    ('Michael', 'Strozier', 2545, 'Ross Terrasse', 'Fredericton', 'E3B5W5'),
    ('Marcella', 'Whitfield', 1839, '90th Avenue', 'Drumheller', 'T0J0Y0'),
    ('Donnell', 'Marshall', 4720, 'Burdett Avenue', 'Victoria', 'V8N2A4'),
    ('Joe', 'Riley', 241, 'avenue Royale', 'Quebec', 'G1E2L3');
SELECT * FROM TOURIST;--

INSERT INTO TRANSACTIONS(TOURIST_ID, PAYMENT_METHOD, CARD_NO, EXPIRATION_DATE, CVC, CARD_HOLDER, TRANS_DATE, AMOUNT) VALUES
    (1, 'DEBIT', '4556550022111151', '2025/10/31', NULL, 'Glenn Smith', '2024/07/17', 345),
    (2, 'DEBIT', '5243240113698599', '2026/08/31', NULL, 'Phyllis Perry', '2024/07/18', 564.78),
    (3, 'CREDIT', '4716874052965055', '2029/09/30', 456, 'Barbara Reagan', '2024/07/19', 199.99),
    (4, 'CREDIT', '4716859227366792', '2027/05/31', 565, 'Steven Hintz', '2024/07/20', 230),
    (5, 'CREDIT', '5519351252323126', '2025/03/31', 464, 'Brenda Mott', '2024/07/21', 119),
    (6, 'CREDIT', '5519351252323126', '2025/06/30', 215, 'John McLaughlin', '2024/07/21', 323.55),
    (7, 'DEBIT', '3616289579532247', '2027/11/30', NULL, 'Jose Ybarra', '2024/07/22', 430.25),
    (8, 'CREDIT', '5330228958406313', '2026/10/31', 153, 'Lester Casanova', '2024/07/24', 225),
    (9, 'CREDIT', '4716981828874238', '2029/08/30', 616, 'Michael Strozier', '2024/07/26', 453),
    (10, 'CREDIT', '5137447538966654', '2026/12/31', 523, 'Marcella Whitfield', '2024/07/27', 212.64),
    (11, 'CREDIT', '5240501454239209', '2028/03/31', 352, 'Donnell Marshall', '2024/07/29', 123),
    (12, 'CREDIT', '4532631102511111', '2026/03/31', 654, 'Joe Riley', '2024/07/30', 279.89);
SELECT * FROM TRANSACTIONS;

INSERT INTO SIGNUP (TRIP_ID, TOURIST_ID, SIGNUP_DATE, TRANSACTION_ID) VALUES
    ('7501', 1, '2024-07-17', '8529'), -- Glenn Smith signs up for "The Parks" trip
    ('7502', 2, '2024-07-18', '8530'), -- Phyllis Perry signs up for "The Museums" trip
    ('7503', 3, '2024-07-19', '8531'), -- Barbara Reagan signs up for "Markets" trip
    ('7504', 4, '2024-07-20', '8527'), -- Steven Hintz signs up for "Religious Heritage" trip
    ('7501', 5, '2024-07-21', '8522'), -- Brenda Mott signs up for "The Parks" trip 
    ('7502', 6, '2024-07-21', '8533'), -- John McLaughlin signs up for "The Museums" trip 
    ('7503', 7, '2024-07-22', '8532'), -- Jose Ybarra signs up for "Markets" trip 
    ('7504', 8, '2024-07-24', '8526'), -- Lester Casanova signs up for "Religious Heritage" trip
    ('7501', 9, '2024-07-26', '8524'), -- Michael Strozier signs up for "The Parks" trip 
    ('7502', 10, '2024-07-27', '8522'); -- Marcella Whitfield signs up for "The Museums"


    --('7501', 1, '2024-07-17', '8501'), -- Glenn Smith signs up for "The Parks" trip
    --('7502', 2, '2024-07-18', '8510'), -- Phyllis Perry signs up for "The Museums" trip
    --('7503', 3, '2024-07-19', '8511'), -- Barbara Reagan signs up for "Markets" trip
    --('7504', 4, '2024-07-20', '8507'), -- Steven Hintz signs up for "Religious Heritage" trip
    --('7501', 5, '2024-07-21', '8502'), -- Brenda Mott signs up for "The Parks" trip 
    --('7502', 6, '2024-07-21', '8503'), -- John McLaughlin signs up for "The Museums" trip 
    --('7503', 7, '2024-07-22', '8502'), -- Jose Ybarra signs up for "Markets" trip 
    --('7504', 8, '2024-07-24', '8506'), -- Lester Casanova signs up for "Religious Heritage" trip
    --('7501', 9, '2024-07-26', '8504'), -- Michael Strozier signs up for "The Parks" trip 
    --('7502', 10, '2024-07-27', '8512'); -- Marcella Whitfield signs up for "The Museums"
SELECT * FROM SIGNUP;
DELETE FROM SIGNUP

--DELEETE THIS:
ALTER TABLE SIGNUP
ADD TRANSACTION_ID CHAR(4);

ALTER TABLE SIGNUP
ADD CONSTRAINT SIGNUP_TRANSACTION_ID_FK FOREIGN KEY (TRANSACTION_ID) REFERENCES TRANSACTIONS;

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


--3 COMPLEX QUERRIES:
/*
1. Develop at least 3 complex queries that represent answers to likely business questions 
	a. 1-2 sentence, for why it's relevant and interesting to the owners of the system.		
	Use aggregate operators, group by clause, order by clause, subqueries and involve table joins
*/

--A querry to get the 
SELECT * FROM TOURIST;
SELECT * FROM TRANSACTIONS;
SELECT * FROM QUALIFICATION;
SELECT * FROM TRIP;
SELECT * FROM LOCATION;
SELECT * FROM TOUR;
SELECT * FROM SIGNUP;
SELECT * FROM VISIT;

CREATE VIEW viewTourParticipants
AS
SELECT TOUR_NAME, TRIP_DATE, FNAME, LNAME
FROM SIGNUP as SP LEFT JOIN TOURIST as TST
ON SP.TOURIST_ID = TST.TOURIST_ID LEFT JOIN TRIP AS TP
ON SP.TRIP_ID = TP.TOUR_ID LEFT JOIN TOUR AS T
ON SP.TOURIST_ID = T.TOUR_ID
GROUP BY (T.TOUR_ID);

--Querry to find the see the trips grouped by guides 
--SELECT TR.TRIP_ID,   
--FROM TOUR T JOIN VISIT V ON T.TOUR_ID = V.TOUR_ID

--See the number of tourists signed up for each tour(a tour has many trips)
SELECT T.TOUR_ID, TOUR_NAME, COUNT(S.TOURIST_ID) AS Participants 
FROM SIGNUP S JOIN TRIP TR ON TR.TRIP_ID = S.TRIP_ID JOIN TOUR T
ON T.TOUR_ID = TR.TOUR_ID
GROUP BY T.TOUR_ID, TOUR_NAME;

--See in wich tour each guide participates
SELECT TRIP , G.GUIDE_ID, CONCAT(FNAME, ' ', LNAME) AS Guide_Name
FROM GUIDE G JOIN TRIP T ON G.GUIDE_ID = T.GUIDE_ID;

--SEE THE GENERATED REVENUE FROM EACH TOUR 
SELECT T.TOUR_ID, TOUR_NAME, SUM(AMOUNT), AVG(AMOUNT) AS Average_Paid
FROM TRIP TR JOIN TOUR T 
ON TR.TOUR_ID = T.TOUR_ID JOIN SIGNUP S
ON S.TRIP_ID = TR.TRIP_ID JOIN TOURIST TS
ON S.TOURIST_ID = TS.TOURIST_ID JOIN TRANSACTIONS TRANS
ON TRANS.TOURIST_ID = TS.TOURIST_ID
GROUP BY T.TOUR_ID, TOUR_NAME;


