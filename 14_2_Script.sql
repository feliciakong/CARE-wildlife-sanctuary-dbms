-- CARE WILDLIFE SANCTUARY DATABASE --

-- ==== DROP TABLES ==== -- 
DROP TABLE MedicalLog CASCADE CONSTRAINTS;
DROP TABLE EventRole CASCADE CONSTRAINTS;
DROP TABLE Contribution CASCADE CONSTRAINTS;
DROP TABLE Animal CASCADE CONSTRAINTS;
DROP TABLE Schedule CASCADE CONSTRAINTS;
DROP TABLE Species CASCADE CONSTRAINTS;
DROP TABLE Staff CASCADE CONSTRAINTS;
DROP TABLE Habitat CASCADE CONSTRAINTS;
DROP TABLE Veterinarian CASCADE CONSTRAINTS;
DROP TABLE Procedure CASCADE CONSTRAINTS;
DROP TABLE Event CASCADE CONSTRAINTS;
DROP TABLE Donor CASCADE CONSTRAINTS;

-- ==== CREATE TABLES ==== --

CREATE TABLE Species (
    SpeciesID           VARCHAR2(10)    PRIMARY KEY,
    Name                VARCHAR2(100)   NOT NULL,
    ConservationStatus  VARCHAR2(50)    NOT NULL,
    CHECK (ConservationStatus IN ('Critically Endangered', 'Endangered', 'Vulnerable', 'Near Threatened', 'Least Concern'))
);

CREATE TABLE Staff (
    StaffID             VARCHAR2(10)    PRIMARY KEY,
    FirstName           VARCHAR2(20)    NOT NULL,
    LastName            VARCHAR2(20)    NOT NULL,
    PhoneNo             NUMERIC(20)     NOT NULL,
    Email               VARCHAR2(100)   NOT NULL,
    CHECK (PhoneNo LIKE '601%'),
    CHECK (Email LIKE '%@%.%')
);

CREATE TABLE Habitat (
    HabitatID           VARCHAR2(10)    PRIMARY KEY,
    Type                VARCHAR2(20)    NOT NULL,
    MaxCapacity         NUMBER(3)       NOT NULL,
    CHECK (MaxCapacity > 0)
);

CREATE TABLE Animal (
    AnimalID            VARCHAR2(10)    PRIMARY KEY,
    SpeciesID           VARCHAR2(10)    NOT NULL,
    PrimaryCaregiverID  VARCHAR2(10)    NOT NULL,
    CurrentHabitatID    VARCHAR2(10)    NOT NULL,
    DayOfIntake         DATE            NOT NULL,
    RescueLocation      VARCHAR2(50),
    ReasonForAdmission  VARCHAR2(100)   NOT NULL,
    CONSTRAINT FK_Animal_Species FOREIGN KEY (SpeciesID) REFERENCES Species(SpeciesID),
    CONSTRAINT FK_Animal_Staff FOREIGN KEY (PrimaryCaregiverID) REFERENCES Staff(StaffID),
    CONSTRAINT FK_Animal_Habitat FOREIGN KEY (CurrentHabitatID) REFERENCES Habitat(HabitatID)
);

CREATE TABLE Schedule (
    ScheduleID          VARCHAR2(10)    PRIMARY KEY,
    StaffID             VARCHAR2(10)    NOT NULL,
    ShiftDate           DATE            NOT NULL,
    ShiftStartTime      DATE            NOT NULL,
    ShiftEndTime        DATE            NOT NULL,
    AssignedTask        VARCHAR2(100)   NOT NULL,
    AssignedLocation    VARCHAR2(100)   NOT NULL,
    CONSTRAINT FK_Schedule_Staff FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    CHECK (ShiftEndTime > ShiftStartTime)
);

CREATE TABLE Veterinarian (
    VeterinarianID      VARCHAR2(10)    PRIMARY KEY,
    FirstName           VARCHAR2(20)    NOT NULL,
    LastName            VARCHAR2(20)    NOT NULL,
    PhoneNo             NUMERIC(20)     NOT NULL,
    Email               VARCHAR2(100)   NOT NULL,
    CHECK (PhoneNo LIKE '601%'),
    CHECK (Email LIKE '%@%.%')
);

CREATE TABLE Procedure (
    ProcedureID         VARCHAR2(10)    PRIMARY KEY,
    ProcedureName       VARCHAR2(50)    NOT NULL,
    Description         VARCHAR2(100),
    StandardCost        NUMBER(10,2)    NOT NULL,
    CHECK (StandardCost >= 0)
);

CREATE TABLE MedicalLog (
    MedicalLogID        VARCHAR2(10)    PRIMARY KEY,
    AnimalID            VARCHAR2(10)    NOT NULL,
    VeterinarianID      VARCHAR2(10)    NOT NULL,
    ProcedureID         VARCHAR2(10)    NOT NULL,
    ProcedureDate       DATE            NOT NULL,
    Results             VARCHAR2(100)   NOT NULL,
    Notes               VARCHAR2(100),
    HealthCheckRating   VARCHAR2(20)    NOT NULL,
    CONSTRAINT MedicalLog_Animal FOREIGN KEY (AnimalID) REFERENCES Animal(AnimalID),
    CONSTRAINT MedicalLog_Veterinarian FOREIGN KEY (VeterinarianID) REFERENCES Veterinarian(VeterinarianID),
    CONSTRAINT MedicalLog_Procedure FOREIGN KEY (ProcedureID) REFERENCES Procedure(ProcedureID),
    CHECK (HealthCheckRating IN ('Poor', 'Fair', 'Good', 'Excellent'))
);

CREATE TABLE Donor (
    DonorID             VARCHAR2(10)    PRIMARY KEY,
    FirstName           VARCHAR2(20)    NOT NULL,
    LastName            VARCHAR2(20)    NOT NULL,
    PhoneNo             NUMERIC(20)     NOT NULL,
    Email               VARCHAR2(100)   NOT NULL,
    CHECK (PhoneNo LIKE '601%'),
    CHECK (Email LIKE '%@%.%')
);

CREATE TABLE Event (
    EventID             VARCHAR2(10)    PRIMARY KEY,
    EventType           VARCHAR2(30)    NOT NULL,
    EventDate           DATE            NOT NULL,
    Description         VARCHAR2(100),
    AttendanceCount     NUMBER(10)      NOT NULL,
    CHECK (AttendanceCount >= 0)
);

CREATE TABLE Contribution (
    ContributionID      VARCHAR2(10)    PRIMARY KEY,
    DonorID             VARCHAR2(10)    NOT NULL,
    EventID             VARCHAR2(10),
    Amount              NUMBER(10,2)    NOT NULL,
    ContributionDate    DATE            NOT NULL,
    DonationType        VARCHAR2(20)    NOT NULL,
    CONSTRAINT Contribution_Donor FOREIGN KEY (DonorID) REFERENCES Donor(DonorID),
    CONSTRAINT Contribution_Event FOREIGN KEY (EventID) REFERENCES Event(EventID),
    CHECK (Amount >= 0)
);

CREATE TABLE EventRole (
    StaffID            VARCHAR2(10)     NOT NULL,
    EventID            VARCHAR2(10)     NOT NULL,
    ParticipationRole  VARCHAR2(30)     NOT NULL,
    Notes              VARCHAR2(100),
    PRIMARY KEY (StaffID, EventID),
    CONSTRAINT EventRole_Staff FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    CONSTRAINT EventRole_Event FOREIGN KEY (EventID) REFERENCES Event(EventID)
);


-- ==== INSERT DATA ==== --

-- Insert Data for Species (27 Species) --
INSERT INTO Species VALUES ('S001', 'Malayan Tiger', 'Critically Endangered');
INSERT INTO Species VALUES ('S002', 'Sumatran Orangutan', 'Critically Endangered');
INSERT INTO Species VALUES ('S003', 'Sun Bear', 'Vulnerable');
INSERT INTO Species VALUES ('S004', 'Asian Elephant', 'Endangered');
INSERT INTO Species VALUES ('S005', 'Clouded Leopard', 'Vulnerable');
INSERT INTO Species VALUES ('S006', 'Malayan Tapir', 'Endangered');
INSERT INTO Species VALUES ('S007', 'Siamang', 'Endangered');
INSERT INTO Species VALUES ('S008', 'Long-tailed Macaque', 'Vulnerable');
INSERT INTO Species VALUES ('S009', 'Monitor Lizard', 'Least Concern');
INSERT INTO Species VALUES ('S010', 'Brahminy Kite', 'Least Concern');
INSERT INTO Species VALUES ('S011', 'Oriental Pied Hornbill', 'Least Concern');
INSERT INTO Species VALUES ('S012', 'Flying Fox', 'Near Threatened');
INSERT INTO Species VALUES ('S013', 'Slow Loris', 'Endangered');
INSERT INTO Species VALUES ('S014', 'Estuarine Crocodile', 'Least Concern');
INSERT INTO Species VALUES ('S015', 'Kingfisher', 'Least Concern');
INSERT INTO Species VALUES ('S016', 'Mouse Deer', 'Least Concern');
INSERT INTO Species VALUES ('S017', 'Flying Squirrel', 'Least Concern');
INSERT INTO Species VALUES ('S018', 'Porcupine', 'Least Concern');
INSERT INTO Species VALUES ('S019', 'Civet', 'Least Concern');
INSERT INTO Species VALUES ('S020', 'Otter', 'Near Threatened');
INSERT INTO Species VALUES ('S021', 'Crested Serpent Eagle', 'Least Concern');
INSERT INTO Species VALUES ('S022', 'Barn Owl', 'Least Concern');
INSERT INTO Species VALUES ('S023', 'Dusky Leaf Monkey', 'Vulnerable');
INSERT INTO Species VALUES ('S024', 'Black Eagle', 'Least Concern');
INSERT INTO Species VALUES ('S025', 'White-bellied Sea Eagle', 'Least Concern');
INSERT INTO Species VALUES ('S026', 'Leopard Cat', 'Least Concern');
INSERT INTO Species VALUES ('S027', 'Binturong', 'Vulnerable');

-- Insert Data for Staff (13 Staffs) -- 
INSERT INTO Staff VALUES ('ST001', 'Aisyah', 'Ismail', 60123456789, 'aisyah.ismail@carewild.my');
INSERT INTO Staff VALUES ('ST002', 'Rahim', 'Abdullah', 60129876543, 'rahim.abdullah@carewild.my');
INSERT INTO Staff VALUES ('ST003', 'Siti', 'Noraini', 60122334455, 'siti.noraini@carewild.my');
INSERT INTO Staff VALUES ('ST004', 'Faiz', 'Zulkifli', 60124567890, 'faiz.zulkifli@carewild.my');
INSERT INTO Staff VALUES ('ST005', 'Nadia', 'Tan', 60121234567, 'nadia.tan@carewild.my');
INSERT INTO Staff VALUES ('ST006', 'Daniel', 'Lee', 60130011223, 'daniel.lee@carewild.my');
INSERT INTO Staff VALUES ('ST007', 'Farah', 'Yusof', 60139887766, 'farah.yusof@carewild.my');
INSERT INTO Staff VALUES ('ST008', 'Amir', 'Hashim', 60134561234, 'amir.hashim@carewild.my');
INSERT INTO Staff VALUES ('ST009', 'Liyana', 'Kamaruddin', 60136543210, 'liyana.kamaruddin@carewild.my');
INSERT INTO Staff VALUES ('ST010', 'Zulkarnain', 'Ahmad', 60137654321, 'zulkarnain.ahmad@carewild.my');
INSERT INTO Staff VALUES ('ST011', 'Hafiz', 'Ramli', 60131112233, 'hafiz.ramli@carewild.my');
INSERT INTO Staff VALUES ('ST012', 'Chong', 'Mei Ling', 60135556677, 'chong.meiling@carewild.my');
INSERT INTO Staff VALUES ('ST013', 'Kavitha', 'Raj', 60136667788, 'kavitha.raj@carewild.my');

-- Insert Data for Habitat (4 Habitat Types) --
INSERT INTO Habitat VALUES ('H001', 'Quarantine', 15);
INSERT INTO Habitat VALUES ('H002', 'Rehab', 12);
INSERT INTO Habitat VALUES ('H003', 'Aviary', 15);
INSERT INTO Habitat VALUES ('H004', 'MammalDen', 20);

-- Insert Data for Animal (35 Animals Admitted) --
INSERT INTO Animal VALUES ('A001', 'S008', 'ST002', 'H001', TO_DATE('04-04-2009', 'DD-MM-YYYY'), 'Taman Negara', 'Leg injury after fall from tree');
INSERT INTO Animal VALUES ('A002', 'S002', 'ST001', 'H001', TO_DATE('14-08-2006', 'DD-MM-YYYY'), 'Kinabatangan', 'Orphaned and underweight');
INSERT INTO Animal VALUES ('A003', 'S009', 'ST009', 'H003', TO_DATE('09-11-2013', 'DD-MM-YYYY'), 'Kota Tinggi', 'Tail fracture from vehicle accident');
INSERT INTO Animal VALUES ('A004', 'S011', 'ST004', 'H002', TO_DATE('21-02-2008', 'DD-MM-YYYY'), 'Langkawi', 'Wing injury from wire entanglement');
INSERT INTO Animal VALUES ('A005', 'S021', 'ST005', 'H003', TO_DATE('15-03-2022', 'DD-MM-YYYY'), 'Belum Rainforest', 'Gunshot wound from poaching');
INSERT INTO Animal VALUES ('A006', 'S015', 'ST004', 'H003', TO_DATE('29-06-2017', 'DD-MM-YYYY'), 'Melaka River', 'Trapped in fishing net');
INSERT INTO Animal VALUES ('A007', 'S003', 'ST010', 'H004', TO_DATE('18-06-2003', 'DD-MM-YYYY'), 'Temenggor Forest', 'Rescued abandoned and starving');
INSERT INTO Animal VALUES ('A008', 'S022', 'ST003', 'H002', TO_DATE('11-04-2020', 'DD-MM-YYYY'), 'Tumpat', 'Unable to fly, possible wing sprain');
INSERT INTO Animal VALUES ('A009', 'S012', 'ST005', 'H003', TO_DATE('10-05-2005', 'DD-MM-YYYY'), 'Taiping', 'Wing tear due to predator attack');
INSERT INTO Animal VALUES ('A010', 'S023', 'ST002', 'H003', TO_DATE('25-01-2004', 'DD-MM-YYYY'), 'Pulau Pinang', 'Malnourished, found alone');
INSERT INTO Animal VALUES ('A011', 'S019', 'ST006', 'H004', TO_DATE('02-04-2019', 'DD-MM-YYYY'), 'Ipoh', 'Hit by motorcycle');
INSERT INTO Animal VALUES ('A012', 'S002', 'ST013', 'H003', TO_DATE('28-12-2011', 'DD-MM-YYYY'), 'Bintulu', 'Confiscated from illegal pet trade');
INSERT INTO Animal VALUES ('A013', 'S009', 'ST001', 'H003', TO_DATE('01-10-2006', 'DD-MM-YYYY'), 'Putrajaya Wetlands', 'Found with cuts along tail');
INSERT INTO Animal VALUES ('A014', 'S001', 'ST012', 'H001', TO_DATE('08-09-2021', 'DD-MM-YYYY'), 'Rompin Forest Reserve', 'Trapped in poacher snare, leg injury');
INSERT INTO Animal VALUES ('A015', 'S024', 'ST003', 'H002', TO_DATE('13-07-2007', 'DD-MM-YYYY'), 'Bentong', 'Wing sprain after storm');
INSERT INTO Animal VALUES ('A016', 'S016', 'ST011', 'H004', TO_DATE('03-06-2004', 'DD-MM-YYYY'), 'Endau-Rompin', 'Injured leg after fall in ravine');
INSERT INTO Animal VALUES ('A017', 'S008', 'ST004', 'H003', TO_DATE('16-04-2023', 'DD-MM-YYYY'), 'Klang', 'Stress and poor diet from urban area');
INSERT INTO Animal VALUES ('A018', 'S017', 'ST007', 'H003', TO_DATE('06-12-2022', 'DD-MM-YYYY'), 'Bukit Larut', 'Found after falling from high tree');
INSERT INTO Animal VALUES ('A019', 'S006', 'ST010', 'H004', TO_DATE('30-03-2003', 'DD-MM-YYYY'), 'Gua Musang', 'Injured hoof from roadside ditch');
INSERT INTO Animal VALUES ('A020', 'S025', 'ST009', 'H002', TO_DATE('12-06-2009', 'DD-MM-YYYY'), 'Pulau Pangkor', 'Breathing issue after haze exposure');
INSERT INTO Animal VALUES ('A021', 'S013', 'ST006', 'H004', TO_DATE('27-03-2024', 'DD-MM-YYYY'), 'Kuala Krai', 'Abandoned infant, weak condition');
INSERT INTO Animal VALUES ('A022', 'S018', 'ST008', 'H004', TO_DATE('04-06-2021', 'DD-MM-YYYY'), 'Lata Kinjang', 'Roadside injury on back');
INSERT INTO Animal VALUES ('A023', 'S023', 'ST003', 'H001', TO_DATE('08-08-2016', 'DD-MM-YYYY'), 'Batu Caves', 'Dehydrated and confused');
INSERT INTO Animal VALUES ('A024', 'S010', 'ST012', 'H002', TO_DATE('07-03-2020', 'DD-MM-YYYY'), 'Pulau Redang', 'Wing strain after collision');
INSERT INTO Animal VALUES ('A025', 'S020', 'ST002', 'H001', TO_DATE('22-02-2006', 'DD-MM-YYYY'), 'Kampung Kuantan', 'Leg cut from plastic entanglement');
INSERT INTO Animal VALUES ('A026', 'S022', 'ST001', 'H002', TO_DATE('26-11-2010', 'DD-MM-YYYY'), 'Kuala Selangor', 'Eye infection, unable to hunt');
INSERT INTO Animal VALUES ('A027', 'S019', 'ST011', 'H003', TO_DATE('17-05-2023', 'DD-MM-YYYY'), 'Segamat', 'Rescued from palm plantation');
INSERT INTO Animal VALUES ('A028', 'S026', 'ST005', 'H003', TO_DATE('09-10-2003', 'DD-MM-YYYY'), 'Baling', 'Minor wounds from fencing wire');
INSERT INTO Animal VALUES ('A029', 'S009', 'ST008', 'H003', TO_DATE('01-07-2007', 'DD-MM-YYYY'), 'Kuching', 'Found injured in urban drain');
INSERT INTO Animal VALUES ('A030', 'S008', 'ST004', 'H001', TO_DATE('06-06-2012', 'DD-MM-YYYY'), 'Seremban', 'Starving, rescued from market area');
INSERT INTO Animal VALUES ('A031', 'S027', 'ST012', 'H001', TO_DATE('05-09-2020', 'DD-MM-YYYY'), 'Miri', 'Head bruising after tree fall');
INSERT INTO Animal VALUES ('A032', 'S011', 'ST007', 'H003', TO_DATE('31-07-2016', 'DD-MM-YYYY'), 'Jerantut', 'Found inside shop, stressed');
INSERT INTO Animal VALUES ('A033', 'S001', 'ST002', 'H004', TO_DATE('14-01-2015', 'DD-MM-YYYY'), 'Taman Negara', 'Dehydrated and underfed, rescued by patrol');
INSERT INTO Animal VALUES ('A034', 'S002', 'ST013', 'H003', TO_DATE('21-03-2005', 'DD-MM-YYYY'), 'Sandakan', 'Found alone near logging site');
INSERT INTO Animal VALUES ('A035', 'S011', 'ST006', 'H002', TO_DATE('11-08-2014', 'DD-MM-YYYY'), 'Kuala Lipis', 'Wing injury from tree fall');

-- Insert Data for Schedule (10 Schedules) --
INSERT INTO Schedule VALUES ('SCH001', 'ST001', TO_DATE('11-07-2025', 'DD-MM-YYYY'), TO_DATE('11-07-2025 08:00', 'DD-MM-YYYY HH24:MI'), TO_DATE('11-07-2025 16:00', 'DD-MM-YYYY HH24:MI'), 'Check Animal Health', 'Vet Room');
INSERT INTO Schedule VALUES ('SCH002', 'ST002', TO_DATE('12-07-2025', 'DD-MM-YYYY'), TO_DATE('12-07-2025 09:00', 'DD-MM-YYYY HH24:MI'), TO_DATE('12-07-2025 17:00', 'DD-MM-YYYY HH24:MI'), 'Feed Birds', 'Aviary');
INSERT INTO Schedule VALUES ('SCH003', 'ST003', TO_DATE('13-07-2025', 'DD-MM-YYYY'), TO_DATE('13-07-2025 08:00', 'DD-MM-YYYY HH24:MI'), TO_DATE('13-07-2025 16:00', 'DD-MM-YYYY HH24:MI'), 'Surgery Prep', 'Surgery Room');
INSERT INTO Schedule VALUES ('SCH004', 'ST004', TO_DATE('14-07-2025', 'DD-MM-YYYY'), TO_DATE('14-07-2025 10:00', 'DD-MM-YYYY HH24:MI'), TO_DATE('14-07-2025 18:00', 'DD-MM-YYYY HH24:MI'), 'Lead Tour', 'Main Hall');
INSERT INTO Schedule VALUES ('SCH005', 'ST005', TO_DATE('15-07-2025', 'DD-MM-YYYY'), TO_DATE('15-07-2025 08:00', 'DD-MM-YYYY HH24:MI'), TO_DATE('15-07-2025 16:00', 'DD-MM-YYYY HH24:MI'), 'Clean Enclosures', 'Rehab');
INSERT INTO Schedule VALUES ('SCH006', 'ST006', TO_DATE('16-07-2025', 'DD-MM-YYYY'), TO_DATE('16-07-2025 09:00', 'DD-MM-YYYY HH24:MI'), TO_DATE('16-07-2025 17:00', 'DD-MM-YYYY HH24:MI'), 'Vaccinate Animals', 'Quarantine');
INSERT INTO Schedule VALUES ('SCH007', 'ST007', TO_DATE('17-07-2025', 'DD-MM-YYYY'), TO_DATE('17-07-2025 08:00', 'DD-MM-YYYY HH24:MI'), TO_DATE('17-07-2025 16:00', 'DD-MM-YYYY HH24:MI'), 'Give Talk', 'Conference Room');
INSERT INTO Schedule VALUES ('SCH008', 'ST008', TO_DATE('18-07-2025', 'DD-MM-YYYY'), TO_DATE('18-07-2025 08:00', 'DD-MM-YYYY HH24:MI'), TO_DATE('18-07-2025 16:00', 'DD-MM-YYYY HH24:MI'), 'Admin Duties', 'Office');
INSERT INTO Schedule VALUES ('SCH009', 'ST009', TO_DATE('19-07-2025', 'DD-MM-YYYY'), TO_DATE('19-07-2025 09:00', 'DD-MM-YYYY HH24:MI'), TO_DATE('19-07-2025 17:00', 'DD-MM-YYYY HH24:MI'), 'Feed Mammals', 'Mammal Den');
INSERT INTO Schedule VALUES ('SCH010', 'ST010', TO_DATE('20-07-2025', 'DD-MM-YYYY'), TO_DATE('20-07-2025 08:00', 'DD-MM-YYYY HH24:MI'), TO_DATE('20-07-2025 16:00', 'DD-MM-YYYY HH24:MI'), 'Health Checks', 'Vet Room');

-- Insert Data for Veterinarian (5 Veterinarians) --
INSERT INTO Veterinarian VALUES ('V001', 'Sarah', 'Tan', 60125851425, 'sarah.tan@wildlife.org');
INSERT INTO Veterinarian VALUES ('V002', 'James', 'Lim', 60111234567, 'james.lim@wildlife.org');
INSERT INTO Veterinarian VALUES ('V003', 'Emily', 'Chong', 60132345678, 'emily.chong@wildlife.org');
INSERT INTO Veterinarian VALUES ('V004', 'Daniel', 'Ng', 60143456789, 'daniel.ng@wildlife.org');
INSERT INTO Veterinarian VALUES ('V005', 'Aisha', 'Rahman', 60154567890, 'aisha.rahman@wildlife.org');

-- Insert Data for Procedure (10 Procedure Types) --
INSERT INTO Procedure VALUES ('P001', 'Wound Cleaning', 'Cleaning and dressing of animal wounds.', 120.00);
INSERT INTO Procedure VALUES ('P002', 'X-Ray', 'Diagnostic imaging using X-rays to check bones and organs.', 250.00);
INSERT INTO Procedure VALUES ('P003', 'Antibiotic Injection', 'Administering antibiotics via injection for bacterial infections.', 90.00);
INSERT INTO Procedure VALUES ('P004', 'Fracture Treatment', 'Treating bone fractures, including setting and casting.', 300.00);
INSERT INTO Procedure VALUES ('P005', 'Dental Check', 'Examination and cleaning of an animal''s teeth.', 150.00);
INSERT INTO Procedure VALUES ('P006', 'Eye Examination', 'Comprehensive examination of the animal''s eyes for issues.', 130.00);
INSERT INTO Procedure VALUES ('P007', 'Surgery', 'Performing surgical operations for various medical conditions.', 600.00);
INSERT INTO Procedure VALUES ('P008', 'Vaccination', 'Administering vaccines for disease prevention.', 80.00);
INSERT INTO Procedure VALUES ('P009', 'Parasite Removal', 'Treatment and removal of internal or external parasites.', 110.00);
INSERT INTO Procedure VALUES ('P010', 'Burn Treatment', 'Care and treatment for burns, including wound dressing and pain management.', 200.00);

-- Insert Data for MedicalLog (35 Medical Log Entries) --
INSERT INTO MedicalLog VALUES ('M001', 'A001', 'V001', 'P004', TO_DATE('02-05-2009', 'DD-MM-YYYY'), 'Clean break, cast applied.', 'Monitor for swelling.', 'Good');
INSERT INTO MedicalLog VALUES ('M002', 'A005', 'V002', 'P007', TO_DATE('16-03-2022', 'DD-MM-YYYY'), 'Bullet successfully extracted.', 'Patient stable. Started on antibiotics.', 'Excellent');
INSERT INTO MedicalLog VALUES ('M003', 'A005', 'V002', 'P007', TO_DATE('21-04-2022', 'DD-MM-YYYY'), 'Surgical incision healing well, no swelling or discharge.', 'Animal alert and eating. Continue pain medication for 3 more days. Monitor for infection signs.', 'Excellent');
INSERT INTO MedicalLog VALUES ('M004', 'A008', 'V003', 'P001', TO_DATE('06-05-2020', 'DD-MM-YYYY'), 'Minor abrasions cleaned.', 'Wing sprain confirmed. Rest advised. Daily wound cleaning.', 'Fair');
INSERT INTO MedicalLog VALUES ('M005', 'A010', 'V001', 'P003', TO_DATE('28-02-2004', 'DD-MM-YYYY'), 'Positive response on antibiotics, fever down.', 'Repeat antibiotic dose tomorrow. Continue hydration and nutritional support.', 'Good');
INSERT INTO MedicalLog VALUES ('M006', 'A012', 'V004', 'P008', TO_DATE('15-01-2012', 'DD-MM-YYYY'), 'Vaccine administered.', 'No adverse reaction. Animal to be quarantined for observation.', 'Excellent');
INSERT INTO MedicalLog VALUES ('M007', 'A015', 'V002', 'P002', TO_DATE('03-08-2007', 'DD-MM-YYYY'), 'No bone fractures visible.', 'X-ray confirmed soft tissue damage only. Continue rest and anti-inflammatories.', 'Good');
INSERT INTO MedicalLog VALUES ('M008', 'A020', 'V005', 'P006', TO_DATE('21-07-2009', 'DD-MM-YYYY'), 'Eyes clear, no foreign bodies.', 'Breathing still labored. Continue monitoring for respiratory distress.', 'Fair');
INSERT INTO MedicalLog VALUES ('M009', 'A023', 'V001', 'P003', TO_DATE('30-09-2016', 'DD-MM-YYYY'), 'Hydration level improving.', 'Continue electrolyte solution. Animal showing signs of alertness.', 'Good');
INSERT INTO MedicalLog VALUES ('M010', 'A027', 'V004', 'P009', TO_DATE('11-07-2023', 'DD-MM-YYYY'), 'External parasites successfully removed.', 'Animal seems more comfortable. Apply topical treatment daily.', 'Excellent');
INSERT INTO MedicalLog VALUES ('M011', 'A002', 'V001', 'P005', TO_DATE('23-09-2006', 'DD-MM-YYYY'), 'Minor tartar buildup, no cavities.', 'Recommended softer diet to aid dental health. Gums appear healthy.', 'Good');
INSERT INTO MedicalLog VALUES ('M012', 'A004', 'V002', 'P006', TO_DATE('20-04-2008', 'DD-MM-YYYY'), 'No corneal damage, slight conjunctivitis.', 'Prescribed eye drops for 7 days. Monitor for swelling.', 'Fair');
INSERT INTO MedicalLog VALUES ('M013', 'A007', 'V003', 'P009', TO_DATE('19-07-2003', 'DD-MM-YYYY'), 'Presence of fleas and ticks confirmed.', 'Successfully removed external parasites.', 'Good');
INSERT INTO MedicalLog VALUES ('M014', 'A009', 'V004', 'P001', TO_DATE('14-06-2005', 'DD-MM-YYYY'), 'Cleaned and dressed superficial wounds on wing.', 'No deep tissue damage observed.', 'Good');
INSERT INTO MedicalLog VALUES ('M015', 'A011', 'V005', 'P010', TO_DATE('18-05-2019', 'DD-MM-YYYY'), 'Minor burns on paw, stable condition.', 'Applied burn cream and bandage. Pain management initiated.', 'Good');
INSERT INTO MedicalLog VALUES ('M016', 'A013', 'V001', 'P001', TO_DATE('30-10-2006', 'DD-MM-YYYY'), 'Cuts cleaned and stitched.', 'Wounds healing well. Keep area clean to prevent infection.', 'Good');
INSERT INTO MedicalLog VALUES ('M017', 'A014', 'V002', 'P004', TO_DATE('08-11-2021', 'DD-MM-YYYY'), 'Fracture set, leg splinted.', 'Tiger is recovering well from the snare injury. Monitoring vital signs.', 'Good');
INSERT INTO MedicalLog VALUES ('M018', 'A016', 'V003', 'P002', TO_DATE('15-07-2004', 'DD-MM-YYYY'), 'X-ray clear, no bone break.', 'Confirmed soft tissue injury. Applying cold compress and restricting movement.', 'Good');
INSERT INTO MedicalLog VALUES ('M019', 'A017', 'V004', 'P005', TO_DATE('20-06-2023', 'DD-MM-YYYY'), 'Good dental health for age.', 'No immediate concerns. Recommended diet enrichment for overall health.', 'Excellent');
INSERT INTO MedicalLog VALUES ('M020', 'A018', 'V005', 'P006', TO_DATE('12-01-2023', 'DD-MM-YYYY'), 'No ocular damage, healthy eyes.', 'Eye exam clear. Focus on recovery from fall.', 'Excellent');
INSERT INTO MedicalLog VALUES ('M021', 'A019', 'V001', 'P001', TO_DATE('01-05-2003', 'DD-MM-YYYY'), 'Hoof wound cleaned thoroughly.', 'Deep cut, but no foreign objects. Bandage to be changed daily.', 'Fair');
INSERT INTO MedicalLog VALUES ('M022', 'A021', 'V002', 'P003', TO_DATE('20-04-2024', 'DD-MM-YYYY'), 'Responded well to first dose of antibiotics.', 'Infant slow loris gaining weight. Continue antibiotic course.', 'Good');
INSERT INTO MedicalLog VALUES ('M023', 'A022', 'V003', 'P010', TO_DATE('29-07-2020', 'DD-MM-YYYY'), 'Extensive abrasions on back, no deep tissue loss.', 'Burns treated with special ointment. Needs frequent dressing changes.', 'Fair');
INSERT INTO MedicalLog VALUES ('M024', 'A024', 'V004', 'P006', TO_DATE('04-08-2020', 'DD-MM-YYYY'), 'Pupils reactive, no signs of infection.', 'Eyes are fine. Focus on wing recovery.', 'Good');
INSERT INTO MedicalLog VALUES ('M025', 'A025', 'V005', 'P001', TO_DATE('13-03-2006', 'DD-MM-YYYY'), 'Leg laceration cleaned, minor sutures.', 'Wound looks clean. Monitor for signs of infection.', 'Good');
INSERT INTO MedicalLog VALUES ('M026', 'A026', 'V001', 'P006', TO_DATE('23-12-2010', 'DD-MM-YYYY'), 'Corneal ulcer observed on the right eye.', 'Started on topical eye medication. Recheck in 3 days.', 'Poor');
INSERT INTO MedicalLog VALUES ('M027', 'A028', 'V002', 'P001', TO_DATE('06-12-2003', 'DD-MM-YYYY'), 'Superficial cuts disinfected.', 'Wounds are minor, healing naturally. Keep enclosure clean.', 'Good');
INSERT INTO MedicalLog VALUES ('M028', 'A029', 'V003', 'P001', TO_DATE('09-08-2007', 'DD-MM-YYYY'), 'Drainage wound cleaned thoroughly.', 'No signs of further infection. Daily cleaning advised.', 'Good');
INSERT INTO MedicalLog VALUES ('M029', 'A026', 'V001', 'P006', TO_DATE('25-01-2011', 'DD-MM-YYYY'), 'Corneal ulcer improving, less redness.', 'Continued topical eye medication. Animal responding well, recheck in 5 days.', 'Fair');
INSERT INTO MedicalLog VALUES ('M030', 'A030', 'V003', 'P005', TO_DATE('16-07-2012', 'DD-MM-YYYY'), 'Teeth show signs of neglect. Minor scaling performed.', 'Recommend soft diet initially.', 'Fair');
INSERT INTO MedicalLog VALUES ('M031', 'A031', 'V004', 'P002', TO_DATE('22-11-2020', 'DD-MM-YYYY'), 'X-ray clear, no skull fracture.', 'Brain concussion protocol in place. Monitor neurological signs closely.', 'Good');
INSERT INTO MedicalLog VALUES ('M032', 'A032', 'V005', 'P005', TO_DATE('04-11-2016', 'DD-MM-YYYY'), 'No significant dental issues.', 'Animal shows signs of stress reduction in larger enclosure.', 'Excellent');
INSERT INTO MedicalLog VALUES ('M033', 'A033', 'V001', 'P003', TO_DATE('21-02-2015', 'DD-MM-YYYY'), 'Hydration improving, appetite returning.', 'Tiger responding well to treatment for dehydration.', 'Good');
INSERT INTO MedicalLog VALUES ('M034', 'A034', 'V002', 'P009', TO_DATE('16-05-2005', 'DD-MM-YYYY'), 'Signs of internal parasites detected.', 'Administered broad-spectrum dewormer. Repeat in 2 weeks.', 'Fair');
INSERT INTO MedicalLog VALUES ('M035', 'A035', 'V003', 'P002', TO_DATE('04-09-2014', 'DD-MM-YYYY'), 'X-ray confirmed minor wing sprain.', 'No fracture. Wing wrapped for support. Rest advised.', 'Good');

-- Insert Data for Event (10 Events) --
INSERT INTO Event VALUES ('E001', 'Wildlife Workshop', TO_DATE('11-06-2025', 'DD-MM-YYYY'), 'Interactive workshop for kids', 45);
INSERT INTO Event VALUES ('E002', 'Fundraising Gala', TO_DATE('17-01-2025', 'DD-MM-YYYY'), 'Formal dinner to raise funds', 120);
INSERT INTO Event VALUES ('E003', 'School Visit', TO_DATE('22-02-2025', 'DD-MM-YYYY'), 'Elementary school group tour', 35);
INSERT INTO Event VALUES ('E004', 'Community Clean-Up', TO_DATE('27-04-2025', 'DD-MM-YYYY'), 'Local park clean-up effort', 60);
INSERT INTO Event VALUES ('E005', 'Educational Fair', TO_DATE('01-03-2025', 'DD-MM-YYYY'), 'Booths and exhibits for public', 80);
INSERT INTO Event VALUES ('E006', 'Charity Run', TO_DATE('06-05-2025', 'DD-MM-YYYY'), '5km run to support sanctuary', 150);
INSERT INTO Event VALUES ('E007', 'Photography Talk', TO_DATE('11-02-2025', 'DD-MM-YYYY'), 'Wildlife photography basics', 25);
INSERT INTO Event VALUES ('E008', 'University Outreach', TO_DATE('16-05-2025', 'DD-MM-YYYY'), 'Awareness session for students', 55);
INSERT INTO Event VALUES ('E009', 'Online Webinar', TO_DATE('21-03-2025', 'DD-MM-YYYY'), 'Virtual tour and Q&A session', 90);
INSERT INTO Event VALUES ('E010', 'Volunteer Orientation', TO_DATE('26-04-2025', 'DD-MM-YYYY'), 'Intro for new volunteers', 40);

-- Insert Data for EventRole (7 Event Role Entries) --
INSERT INTO EventRole VALUES ('ST001', 'E001', 'Speaker', 'Talked about animal care');
INSERT INTO EventRole VALUES ('ST004', 'E002', 'Organizer', 'Organized booths and volunteers');
INSERT INTO EventRole VALUES ('ST006', 'E003', 'Tourguide', 'Led school tour around the sanctuary');
INSERT INTO EventRole VALUES ('ST009', 'E004', 'Volunteer', 'Assisted with equipment and transport');
INSERT INTO EventRole VALUES ('ST012', 'E005', 'Educator', 'Presented animal rehab booth');
INSERT INTO EventRole VALUES ('ST007', 'E006', 'Volunteer', 'Welcomed runners and gave instructions');
INSERT INTO EventRole VALUES ('ST003', 'E007', 'Volunteer', 'Took photos for social media');

-- Insert Data for Donor (10 Donors) --
INSERT INTO Donor VALUES ('D001', 'Katya', 'Ramzi', 60131230011, 'katya.ramzi@gmail.com');
INSERT INTO Donor VALUES ('D002', 'Bryan', 'Phang', 60132231122, 'bryan.phang@gmail.com');
INSERT INTO Donor VALUES ('D003', 'Cheryl', 'Ooi', 60133232233, 'cheryl.ooi@gmail.com');
INSERT INTO Donor VALUES ('D004', 'Daniar', 'Arul', 60134233344, 'daniar.arul@gmail.com');
INSERT INTO Donor VALUES ('D005', 'Evelyn', 'Babayeva', 60135234455, 'evelyn.babayeva@gmail.com');
INSERT INTO Donor VALUES ('D006', 'Faizal', 'Rahman', 60136235566, 'faizal.rahman@gmail.com');
INSERT INTO Donor VALUES ('D007', 'George', 'Yap', 60137236677, 'george.yap@gmail.com');
INSERT INTO Donor VALUES ('D008', 'Nataly', 'Roslan', 60138237788, 'nataly.roslan@gmail.com');
INSERT INTO Donor VALUES ('D009', 'Isabelle', 'Lee', 60139238899, 'isabelle.lee@gmail.com');
INSERT INTO Donor VALUES ('D010', 'Joshua', 'Tan', 60130239900, 'joshua.tan@gmail.com');

-- Insert Data for Contribution (10 Contributions) --
INSERT INTO Contribution VALUES ('C001', 'D001', 'E001', 500.00, TO_DATE('01-07-2025', 'DD-MM-YYYY'), 'Monetary');
INSERT INTO Contribution VALUES ('C002', 'D002', 'E002', 250.00, TO_DATE('03-07-2025', 'DD-MM-YYYY'), 'Supply');
INSERT INTO Contribution VALUES ('C003', 'D003', 'E003', 1000.00, TO_DATE('05-07-2025', 'DD-MM-YYYY'), 'Monetary');
INSERT INTO Contribution VALUES ('C004', 'D004', 'E001', 300.00, TO_DATE('07-07-2025', 'DD-MM-YYYY'), 'Sponsorship');
INSERT INTO Contribution VALUES ('C005', 'D005', 'E004', 750.00, TO_DATE('08-07-2025', 'DD-MM-YYYY'), 'Supply');
INSERT INTO Contribution VALUES ('C006', 'D006', 'E005', 1200.00, TO_DATE('10-07-2025', 'DD-MM-YYYY'), 'Monetary');
INSERT INTO Contribution VALUES ('C007', 'D007', 'E002', 400.00, TO_DATE('11-07-2025', 'DD-MM-YYYY'), 'Sponsorship');
INSERT INTO Contribution VALUES ('C008', 'D008', 'E003', 950.00, TO_DATE('12-07-2025', 'DD-MM-YYYY'), 'Supply');
INSERT INTO Contribution VALUES ('C009', 'D009', 'E006', 200.00, TO_DATE('13-07-2025', 'DD-MM-YYYY'), 'Monetary');
INSERT INTO Contribution VALUES ('C010', 'D010', 'E005', 1500.00, TO_DATE('14-07-2025', 'DD-MM-YYYY'), 'Sponsorship');


-- ==== DISPLAY TABLES ==== --
SELECT * FROM Species;
SELECT * FROM Staff;
SELECT * FROM Habitat;
SELECT * FROM Animal;
SELECT * FROM Schedule;
SELECT * FROM Veterinarian;
SELECT * FROM Procedure;
SELECT * FROM MedicalLog;
SELECT * FROM Event;
SELECT * FROM EventRole;
SELECT * FROM Donor;
SELECT * FROM Contribution;



-- ==== SQL QUERIES ==== -- 

-- A) A query that requires an outer join. 
-- List all habitats and the current occupancy 
-- (number of animals each habitat houses). 

SELECT h.HabitatID, h.Type AS HabitatType, h.MaxCapacity, COUNT(a.AnimalID) AS CurrentOccupancy
FROM Habitat h
LEFT OUTER JOIN Animal a ON h.HabitatID = a.CurrentHabitatID
GROUP BY h.HabitatID, h.Type, h.MaxCapacity
ORDER BY h.HabitatID;


--B) A minimum of 4 tables join with a GROUP BY function 
-- Find the total contributions per event type. 

SELECT e.EventType, COUNT(DISTINCT c.DonorID) AS TotalDonors, SUM(c.Amount) AS TotalContributions 
FROM Event e 
JOIN Contribution c ON e.EventID = c.EventID 
JOIN Donor d ON c.DonorID = d.DonorID 
JOIN EventRole er ON e.EventID = er.EventID 
GROUP BY e.EventType 
ORDER BY TotalContributions DESC; 


-- C) A string pattern matching and date function query 
--Find all animals rescued in a location containing "forest" between year 2022 to 2024. 

SELECT AnimalID, SpeciesID, RescueLocation, DayOfIntake, TO_CHAR(DayOfIntake, 'YYYY-MM-DD') AS IntakeDate
FROM Animal 
WHERE LOWER(RescueLocation) LIKE '%forest%' AND DayOfIntake BETWEEN DATE '2022-01-01' AND DATE '2024-12-31' 
ORDER BY DayOfIntake;


-- D) A query having both OR and AND
-- Find animals that are either in the "Quarantine" OR "Rehab" habitat 
-- AND have a "Good" or "Excellent" health check rating

SELECT a.AnimalID, a.CurrentHabitatID, h.Type, ml.HealthCheckRating
FROM Animal a
JOIN Habitat h ON a.CurrentHabitatID = h.HabitatID
JOIN MedicalLog ml ON a.AnimalID = ml.AnimalID
WHERE (h.Type = 'Quarantine' OR h.Type = 'Rehab')
AND (ml.HealthCheckRating = 'Good' OR ml.HealthCheckRating = 'Excellent');


-- E) A query that consists of at least 2 subqueries
-- Find animals, with only their species and rescue location displayed, whose primary caregiver is either 'Aisyah Ismail' or 'Rahim Abdullah', 
-- AND have also received a HealthCheckRating of 'Good' or 'Excellent' in any of their medical logs.

SELECT A.AnimalID, S.Name AS SpeciesName, A.RescueLocation
FROM Animal A
JOIN Species S ON A.SpeciesID = S.SpeciesID
WHERE A.AnimalID IN (

    -- Subquery 1: Find AnimalIDs whose PrimaryCaregiver is Aisyah or Rahim
    SELECT A_sub1.AnimalID
    FROM Animal A_sub1
    WHERE A_sub1.PrimaryCaregiverID IN (

        SELECT ST.StaffID
        FROM Staff ST
        WHERE
          (ST.FirstName = 'Aisyah' AND ST.LastName = 'Ismail') OR 
          (ST.FirstName = 'Rahim' AND ST.LastName = 'Abdullah')
        )
    )

    AND A.AnimalID IN (

        -- Subquery 2: Find AnimalIDs with a 'Good' or 'Excellent' HealthCheckRating
        SELECT DISTINCT ML.AnimalID
        FROM MedicalLog ML
        WHERE ML.HealthCheckRating IN ('Good', 'Excellent'));


-- F) List the animals that have been in the sanctuary for over a year AND 
-- have received the most positive health check ratings for health studies.

SELECT A.AnimalID, S.Name AS SpeciesName, A.DayOfIntake, 
(   SELECT COUNT(*) 
    FROM MedicalLog ML1
    WHERE ML1.AnimalID = A.AnimalID) AS TotalHealthStudies,
(   SELECT COUNT(*) 
    FROM MedicalLog ML2
    WHERE ML2.AnimalID = A.AnimalID AND ML2.HealthCheckRating = 'Excellent') AS ExcellentRatingsCount
FROM Animal A
JOIN Species S ON A.SpeciesID = S.SpeciesID
JOIN MedicalLog ML ON A.AnimalID = ML.AnimalID
WHERE A.DayOfIntake <= TRUNC(SYSDATE) - 365 AND ML.HealthCheckRating = 'Excellent'
GROUP BY A.AnimalID, S.Name, A.DayOfIntake
ORDER BY ExcellentRatingsCount DESC, A.AnimalID;




