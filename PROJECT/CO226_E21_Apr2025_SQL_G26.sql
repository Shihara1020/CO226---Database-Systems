-- =====================================================
-- CRIME MANAGEMENT SYSTEM - COMPLETE MYSQL IMPLEMENTATION
-- Group 27: Fikry M.N.A, PERERA W.S.S., DEWAGEDARA D.M.E.S.
-- =====================================================

-- Drop database if exists and create new one
DROP DATABASE IF EXISTS crime_management_system;
CREATE DATABASE crime_management_system;
USE crime_management_system;

-- =====================================================
-- 1. RELATIONAL SCHEMA IMPLEMENTATION
-- =====================================================

-- Table: POLICE_STATION
CREATE TABLE POLICE_STATION (
    station_id VARCHAR(10) PRIMARY KEY,
    location VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    station_incharge_id VARCHAR(10),
    CONSTRAINT chk_contact_format CHECK (contact_number REGEXP '^[0-9+()-]+$')
);

-- Table: POLICE_OFFICER
CREATE TABLE POLICE_OFFICER (
    officer_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    officer_rank VARCHAR(50) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    address VARCHAR(200) NOT NULL,
    date_of_joining DATE NOT NULL,
    assigned_station_id VARCHAR(10),
    CONSTRAINT fk_officer_station FOREIGN KEY (assigned_station_id) 
        REFERENCES POLICE_STATION(station_id) ON DELETE SET NULL,
    CONSTRAINT chk_officer_contact CHECK (contact_number REGEXP '^[0-9+()-]+$')
);

-- Add foreign key constraint for station in-charge
ALTER TABLE POLICE_STATION 
ADD CONSTRAINT fk_station_incharge 
FOREIGN KEY (station_incharge_id) REFERENCES POLICE_OFFICER(officer_id);

-- Table: CRIME
CREATE TABLE CRIME (
    crime_id VARCHAR(10) PRIMARY KEY,
    crime_type VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    crime_date DATE NOT NULL,
    crime_time TIME NOT NULL,
    location VARCHAR(200) NOT NULL,
    assigned_station_id VARCHAR(10) NOT NULL,
    lead_investigator_id VARCHAR(10),
    status VARCHAR(20) DEFAULT 'Open',
    CONSTRAINT fk_crime_station FOREIGN KEY (assigned_station_id) 
        REFERENCES POLICE_STATION(station_id) ON DELETE CASCADE,
    CONSTRAINT fk_crime_lead_investigator FOREIGN KEY (lead_investigator_id) 
        REFERENCES POLICE_OFFICER(officer_id) ON DELETE SET NULL,
    CONSTRAINT chk_crime_status CHECK (status IN ('Open', 'Under Investigation', 'Solved', 'Closed'))
);

-- Table: SUSPECT
CREATE TABLE SUSPECT (
    suspect_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    street_name VARCHAR(100),
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    address VARCHAR(200) NOT NULL,
    criminal_records_summary TEXT,
    status VARCHAR(20) DEFAULT 'Wanted',
    CONSTRAINT chk_suspect_age CHECK (age > 0 AND age < 120),
    CONSTRAINT chk_suspect_gender CHECK (gender IN ('Male', 'Female', 'Other')),
    CONSTRAINT chk_suspect_status CHECK (status IN ('Arrested', 'Wanted', 'Released'))
);

-- Table: VICTIM
CREATE TABLE VICTIM (
    victim_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    contact_info VARCHAR(15),
    address VARCHAR(200) NOT NULL,
    CONSTRAINT chk_victim_age CHECK (age > 0 AND age < 120),
    CONSTRAINT chk_victim_gender CHECK (gender IN ('Male', 'Female', 'Other'))
);

-- Table: EVIDENCE
CREATE TABLE EVIDENCE (
    evidence_id VARCHAR(10) PRIMARY KEY,
    crime_id VARCHAR(10) NOT NULL,
    type VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    location_found VARCHAR(200) NOT NULL,
    date_collected DATE NOT NULL,
    collected_by VARCHAR(10),
    CONSTRAINT fk_evidence_crime FOREIGN KEY (crime_id) 
        REFERENCES CRIME(crime_id) ON DELETE CASCADE,
    CONSTRAINT fk_evidence_collector FOREIGN KEY (collected_by) 
        REFERENCES POLICE_OFFICER(officer_id) ON DELETE SET NULL
);

-- Table: ARREST
CREATE TABLE ARREST (
    arrest_id VARCHAR(10) PRIMARY KEY,
    suspect_id VARCHAR(10) NOT NULL,
    arrest_date DATE NOT NULL,
    arrest_location VARCHAR(200) NOT NULL,
    arresting_officer_id VARCHAR(10) NOT NULL,
    CONSTRAINT fk_arrest_suspect FOREIGN KEY (suspect_id) 
        REFERENCES SUSPECT(suspect_id) ON DELETE CASCADE,
    CONSTRAINT fk_arrest_officer FOREIGN KEY (arresting_officer_id) 
        REFERENCES POLICE_OFFICER(officer_id) ON DELETE CASCADE
);

-- Junction Table: INVESTIGATION (Many-to-Many: Crime-Officer)
CREATE TABLE INVESTIGATION (
    crime_id VARCHAR(10),
    officer_id VARCHAR(10),
    assigned_date DATE NOT NULL,
    PRIMARY KEY (crime_id, officer_id),
    CONSTRAINT fk_investigation_crime FOREIGN KEY (crime_id) 
        REFERENCES CRIME(crime_id) ON DELETE CASCADE,
    CONSTRAINT fk_investigation_officer FOREIGN KEY (officer_id) 
        REFERENCES POLICE_OFFICER(officer_id) ON DELETE CASCADE
);

-- Junction Table: CRIME_SUSPECT (Many-to-Many: Crime-Suspect)
CREATE TABLE CRIME_SUSPECT (
    crime_id VARCHAR(10),
    suspect_id VARCHAR(10),
    involvement_description TEXT,
    PRIMARY KEY (crime_id, suspect_id),
    CONSTRAINT fk_crime_suspect_crime FOREIGN KEY (crime_id) 
        REFERENCES CRIME(crime_id) ON DELETE CASCADE,
    CONSTRAINT fk_crime_suspect_suspect FOREIGN KEY (suspect_id) 
        REFERENCES SUSPECT(suspect_id) ON DELETE CASCADE
);

-- Junction Table: CRIME_VICTIM (Many-to-Many: Crime-Victim)
CREATE TABLE CRIME_VICTIM (
    crime_id VARCHAR(10),
    victim_id VARCHAR(10),
    relationship_to_crime VARCHAR(100),
    PRIMARY KEY (crime_id, victim_id),
    CONSTRAINT fk_crime_victim_crime FOREIGN KEY (crime_id) 
        REFERENCES CRIME(crime_id) ON DELETE CASCADE,
    CONSTRAINT fk_crime_victim_victim FOREIGN KEY (victim_id) 
        REFERENCES VICTIM(victim_id) ON DELETE CASCADE
);

-- =====================================================
-- 2. POPULATE TABLES WITH MEANINGFUL DATA
-- =====================================================

-- Insert Police Stations
INSERT INTO POLICE_STATION (station_id, location, contact_number, station_incharge_id) VALUES
('PS001', 'Colombo Central', '011-2345678', NULL),
('PS002', 'Kandy City', '081-2234567', NULL),
('PS003', 'Galle Fort', '091-2123456', NULL),
('PS004', 'Negombo', '031-2112233', NULL),
('PS005', 'Anuradhapura', '025-2223344', NULL);

-- Insert Police Officers
INSERT INTO POLICE_OFFICER (officer_id, name, officer_rank, contact_number, address, date_of_joining, assigned_station_id) VALUES
('OFF001', 'Inspector Silva', 'Inspector', '077-1234567', '123 Main St, Colombo', '2020-01-15', 'PS001'),
('OFF002', 'Sergeant Perera', 'Sergeant', '077-2345678', '456 Kandy Rd, Kandy', '2019-03-20', 'PS002'),
('OFF003', 'Constable Fernando', 'Constable', '077-3456789', '789 Galle Rd, Galle', '2021-06-10', 'PS003'),
('OFF004', 'Inspector Jayawardena', 'Inspector', '077-4567890', '321 Beach Rd, Negombo', '2018-08-25', 'PS004'),
('OFF005', 'Sergeant Bandara', 'Sergeant', '077-5678901', '654 Ancient City, Anuradhapura', '2020-11-30', 'PS005'),
('OFF006', 'Constable Wickramasinghe', 'Constable', '077-6789012', '987 Temple Rd, Colombo', '2022-01-05', 'PS001'),
('OFF007', 'Inspector Gunasekara', 'Inspector', '077-7890123', '147 Hill St, Kandy', '2017-04-15', 'PS002'),
('OFF008', 'Sergeant Rajapaksa', 'Sergeant', '077-8901234', '258 Fort Rd, Galle', '2019-09-10', 'PS003'),
('OFF009', 'Constable Mendis', 'Constable', '077-9012345', '369 Church St, Negombo', '2021-12-20', 'PS004'),
('OFF010', 'Inspector Amarasekara', 'Inspector', '077-0123456', '741 Sacred City, Anuradhapura', '2018-02-28', 'PS005');

-- Update Police Station in-charge
UPDATE POLICE_STATION SET station_incharge_id = 'OFF001' WHERE station_id = 'PS001';
UPDATE POLICE_STATION SET station_incharge_id = 'OFF002' WHERE station_id = 'PS002';
UPDATE POLICE_STATION SET station_incharge_id = 'OFF004' WHERE station_id = 'PS004';
UPDATE POLICE_STATION SET station_incharge_id = 'OFF005' WHERE station_id = 'PS005';
UPDATE POLICE_STATION SET station_incharge_id = 'OFF007' WHERE station_id = 'PS003';

-- Insert Crimes
INSERT INTO CRIME (crime_id, crime_type, description, crime_date, crime_time, location, assigned_station_id, lead_investigator_id, status) VALUES
('CR001', 'Theft', 'Motorcycle stolen from parking area', '2024-01-15', '14:30:00', 'Pettah Market, Colombo', 'PS001', 'OFF001', 'Under Investigation'),
('CR002', 'Assault', 'Physical assault during argument', '2024-01-20', '20:15:00', 'Peradeniya Road, Kandy', 'PS002', 'OFF002', 'Open'),
('CR003', 'Burglary', 'House broken into, valuables stolen', '2024-02-05', '03:00:00', 'Fort Area, Galle', 'PS003', 'OFF007', 'Solved'),
('CR004', 'Fraud', 'Credit card fraud at ATM', '2024-02-10', '16:45:00', 'Main Street, Negombo', 'PS004', 'OFF004', 'Under Investigation'),
('CR005', 'Vandalism', 'Public property damaged', '2024-02-15', '22:30:00', 'Sacred City, Anuradhapura', 'PS005', 'OFF005', 'Open'),
('CR006', 'Drug Possession', 'Illegal drugs found during search', '2024-03-01', '11:20:00', 'Slave Island, Colombo', 'PS001', 'OFF006', 'Solved'),
('CR007', 'Domestic Violence', 'Reported domestic abuse case', '2024-03-05', '19:00:00', 'Mahakanda, Kandy', 'PS002', 'OFF007', 'Under Investigation'),
('CR008', 'Cybercrime', 'Online banking fraud', '2024-03-10', '13:15:00', 'Unawatuna, Galle', 'PS003', 'OFF008', 'Open'),
('CR009', 'Robbery', 'Armed robbery at jewelry store', '2024-03-15', '10:30:00', 'Sea Street, Negombo', 'PS004', 'OFF009', 'Under Investigation'),
('CR010', 'Murder', 'Suspicious death investigation', '2024-03-20', '07:45:00', 'Mihintale, Anuradhapura', 'PS005', 'OFF010', 'Under Investigation');

-- Insert Suspects
INSERT INTO SUSPECT (suspect_id, name, street_name, age, gender, address, criminal_records_summary, status) VALUES
('SUS001', 'Kamal Perera', 'Main Street', 28, 'Male', '123 Main St, Colombo', 'Previous theft charges', 'Wanted'),
('SUS002', 'Nimal Silva', 'Kandy Road', 35, 'Male', '456 Kandy Rd, Kandy', 'Assault history', 'Arrested'),
('SUS003', 'Sunil Fernando', 'Galle Road', 42, 'Male', '789 Galle Rd, Galle', 'Burglary convictions', 'Arrested'),
('SUS004', 'Priya Jayawardena', 'Beach Road', 30, 'Female', '321 Beach Rd, Negombo', 'Financial crimes', 'Wanted'),
('SUS005', 'Ajith Bandara', 'Ancient City', 25, 'Male', '654 Ancient City, Anuradhapura', 'Vandalism charges', 'Wanted'),
('SUS006', 'Ravi Wickrama', 'Temple Road', 33, 'Male', '987 Temple Rd, Colombo', 'Drug-related offenses', 'Arrested'),
('SUS007', 'Saman Gunasekara', 'Hill Street', 29, 'Male', '147 Hill St, Kandy', 'Domestic violence', 'Arrested'),
('SUS008', 'Chamara Rajapaksa', 'Fort Road', 31, 'Male', '258 Fort Rd, Galle', 'Cyber crimes', 'Wanted'),
('SUS009', 'Indika Mendis', 'Church Street', 38, 'Male', '369 Church St, Negombo', 'Armed robbery', 'Wanted'),
('SUS010', 'Lakmal Amarasekara', 'Sacred City', 45, 'Male', '741 Sacred City, Anuradhapura', 'Violent crimes', 'Arrested');

-- Insert Victims
INSERT INTO VICTIM (victim_id, name, age, gender, contact_info, address) VALUES
('VIC001', 'Amara Dissanayake', 32, 'Male', '077-1111111', '111 Liberty Plaza, Colombo'),
('VIC002', 'Kumari Rathnayake', 28, 'Female', '077-2222222', '222 Queens Road, Kandy'),
('VIC003', 'Rohan Wijesinghe', 45, 'Male', '077-3333333', '333 Lighthouse St, Galle'),
('VIC004', 'Sandya Jayasekara', 35, 'Female', '077-4444444', '444 Catholic Church St, Negombo'),
('VIC005', 'Thilak Senanayake', 50, 'Male', '077-5555555', '555 Archaeology Dept, Anuradhapura'),
('VIC006', 'Malini Herath', 26, 'Female', '077-6666666', '666 Bambalapitiya, Colombo'),
('VIC007', 'Chandana Perera', 40, 'Male', '077-7777777', '777 Botanical Garden Rd, Kandy'),
('VIC008', 'Nilanthi Silva', 33, 'Female', '077-8888888', '888 Dutch Hospital, Galle'),
('VIC009', 'Asanka Fernando', 29, 'Male', '077-9999999', '999 Fish Market, Negombo'),
('VIC010', 'Dilhani Bandara', 38, 'Female', '077-0000000', '000 Ruwanwelisaya, Anuradhapura');

-- Insert Evidence
INSERT INTO EVIDENCE (evidence_id, crime_id, type, description, location_found, date_collected, collected_by) VALUES
('EV001', 'CR001', 'Fingerprints', 'Fingerprints on motorcycle handle', 'Pettah Market, Colombo', '2024-01-16', 'OFF001'),
('EV002', 'CR002', 'Witness Statement', 'Eyewitness testimony', 'Peradeniya Road, Kandy', '2024-01-21', 'OFF002'),
('EV003', 'CR003', 'DNA Evidence', 'DNA sample from crime scene', 'Fort Area, Galle', '2024-02-06', 'OFF007'),
('EV004', 'CR004', 'Video Footage', 'CCTV footage from ATM', 'Main Street, Negombo', '2024-02-11', 'OFF004'),
('EV005', 'CR005', 'Physical Evidence', 'Damaged property samples', 'Sacred City, Anuradhapura', '2024-02-16', 'OFF005'),
('EV006', 'CR006', 'Drug Sample', 'Illegal substance for testing', 'Slave Island, Colombo', '2024-03-02', 'OFF006'),
('EV007', 'CR007', 'Medical Report', 'Injury documentation', 'Mahakanda, Kandy', '2024-03-06', 'OFF007'),
('EV008', 'CR008', 'Digital Evidence', 'Computer logs and traces', 'Unawatuna, Galle', '2024-03-11', 'OFF008'),
('EV009', 'CR009', 'Weapon', 'Knife used in robbery', 'Sea Street, Negombo', '2024-03-16', 'OFF009'),
('EV010', 'CR010', 'Forensic Evidence', 'Autopsy findings', 'Mihintale, Anuradhapura', '2024-03-21', 'OFF010');

-- Insert Arrests
INSERT INTO ARREST (arrest_id, suspect_id, arrest_date, arrest_location, arresting_officer_id) VALUES
('AR001', 'SUS002', '2024-01-25', 'Kandy City Center', 'OFF002'),
('AR002', 'SUS003', '2024-02-08', 'Galle Fort', 'OFF007'),
('AR003', 'SUS006', '2024-03-03', 'Colombo Central', 'OFF006'),
('AR004', 'SUS007', '2024-03-07', 'Kandy Hospital', 'OFF007'),
('AR005', 'SUS010', '2024-03-22', 'Anuradhapura Court', 'OFF010');

-- Insert Investigation assignments
INSERT INTO INVESTIGATION (crime_id, officer_id, assigned_date) VALUES
('CR001', 'OFF001', '2024-01-15'),
('CR001', 'OFF006', '2024-01-16'),
('CR002', 'OFF002', '2024-01-20'),
('CR003', 'OFF007', '2024-02-05'),
('CR003', 'OFF008', '2024-02-06'),
('CR004', 'OFF004', '2024-02-10'),
('CR005', 'OFF005', '2024-02-15'),
('CR006', 'OFF006', '2024-03-01'),
('CR007', 'OFF007', '2024-03-05'),
('CR008', 'OFF008', '2024-03-10'),
('CR009', 'OFF009', '2024-03-15'),
('CR010', 'OFF010', '2024-03-20');

-- Insert Crime-Suspect relationships
INSERT INTO CRIME_SUSPECT (crime_id, suspect_id, involvement_description) VALUES
('CR001', 'SUS001', 'Primary suspect in motorcycle theft'),
('CR002', 'SUS002', 'Perpetrator of assault'),
('CR003', 'SUS003', 'Burglar who broke into house'),
('CR004', 'SUS004', 'Credit card fraud perpetrator'),
('CR005', 'SUS005', 'Vandalism suspect'),
('CR006', 'SUS006', 'Drug possession suspect'),
('CR007', 'SUS007', 'Domestic violence perpetrator'),
('CR008', 'SUS008', 'Cybercrime suspect'),
('CR009', 'SUS009', 'Armed robbery suspect'),
('CR010', 'SUS010', 'Murder suspect');

-- Insert Crime-Victim relationships
INSERT INTO CRIME_VICTIM (crime_id, victim_id, relationship_to_crime) VALUES
('CR001', 'VIC001', 'Owner of stolen motorcycle'),
('CR002', 'VIC002', 'Assault victim'),
('CR003', 'VIC003', 'Burglary victim'),
('CR004', 'VIC004', 'Credit card fraud victim'),
('CR005', 'VIC005', 'Vandalism complainant'),
('CR006', 'VIC006', 'Drug case witness'),
('CR007', 'VIC007', 'Domestic violence victim'),
('CR008', 'VIC008', 'Cybercrime victim'),
('CR009', 'VIC009', 'Robbery victim'),
('CR010', 'VIC010', 'Murder victim');

-- =====================================================
-- 3. SQL QUERIES (20 QUERIES)
-- =====================================================

-- Query 1: Simple SELECT - List all police stations
SELECT * FROM POLICE_STATION;

-- Query 2: SELECT with WHERE - Find all crimes in Colombo
SELECT * FROM CRIME WHERE location LIKE '%Colombo%';

-- Query 3: SELECT with ORDER BY - List officers by rank and joining date
SELECT officer_id, name, rank, date_of_joining 
FROM POLICE_OFFICER 
ORDER BY rank, date_of_joining DESC;

-- Query 4: INNER JOIN - Get crime details with investigating officers
SELECT c.crime_id, c.crime_type, c.description, po.name AS lead_investigator
FROM CRIME c
INNER JOIN POLICE_OFFICER po ON c.lead_investigator_id = po.officer_id;

-- Query 5: LEFT JOIN - List all suspects and their arrest information
SELECT s.suspect_id, s.name, s.status, a.arrest_date, a.arrest_location
FROM SUSPECT s
LEFT JOIN ARREST a ON s.suspect_id = a.suspect_id;

-- Query 6: COUNT - Number of crimes per station
SELECT ps.location, COUNT(c.crime_id) AS crime_count
FROM POLICE_STATION ps
LEFT JOIN CRIME c ON ps.station_id = c.assigned_station_id
GROUP BY ps.station_id, ps.location;

-- Query 7: AVG - Average age of suspects
SELECT AVG(age) AS average_suspect_age FROM SUSPECT;

-- Query 8: GROUP BY with HAVING - Stations with more than 1 crime
SELECT assigned_station_id, COUNT(*) AS crime_count
FROM CRIME
GROUP BY assigned_station_id
HAVING COUNT(*) > 1;

-- Query 9: Subquery - Officers investigating more crimes than average
SELECT officer_id, name
FROM POLICE_OFFICER
WHERE officer_id IN (
    SELECT officer_id
    FROM INVESTIGATION
    GROUP BY officer_id
    HAVING COUNT(*) > (
        SELECT AVG(crime_count)
        FROM (
            SELECT COUNT(*) AS crime_count
            FROM INVESTIGATION
            GROUP BY officer_id
        ) AS avg_calc
    )
);

-- Query 10: EXISTS - Crimes that have evidence
SELECT c.crime_id, c.crime_type, c.description
FROM CRIME c
WHERE EXISTS (
    SELECT 1 FROM EVIDENCE e WHERE e.crime_id = c.crime_id
);

-- Query 11: UNION - All people (officers and suspects) with their roles
SELECT name, 'Officer' AS role FROM POLICE_OFFICER
UNION
SELECT name, 'Suspect' AS role FROM SUSPECT;

-- Query 12: CASE - Categorize crimes by urgency
SELECT crime_id, crime_type, 
    CASE 
        WHEN crime_type IN ('Murder', 'Robbery') THEN 'High Priority'
        WHEN crime_type IN ('Assault', 'Burglary') THEN 'Medium Priority'
        ELSE 'Low Priority'
    END AS priority_level
FROM CRIME;

-- Query 13: Date functions - Crimes in the last 30 days
SELECT crime_id, crime_type, crime_date
FROM CRIME
WHERE crime_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Query 14: String functions - Format officer information
SELECT 
    CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2))) AS formatted_name,
    CONCAT(rank, ' - ', assigned_station_id) AS rank_station
FROM POLICE_OFFICER;

-- Query 15: Multiple JOINs - Complete crime investigation details
SELECT 
    c.crime_id,
    c.crime_type,
    c.location,
    po.name AS lead_investigator,
    ps.location AS station_location,
    s.name AS suspect_name,
    v.name AS victim_name
FROM CRIME c
JOIN POLICE_OFFICER po ON c.lead_investigator_id = po.officer_id
JOIN POLICE_STATION ps ON c.assigned_station_id = ps.station_id
JOIN CRIME_SUSPECT cs ON c.crime_id = cs.crime_id
JOIN SUSPECT s ON cs.suspect_id = s.suspect_id
JOIN CRIME_VICTIM cv ON c.crime_id = cv.crime_id
JOIN VICTIM v ON cv.victim_id = v.victim_id;

-- Query 16: Correlated subquery - Stations with above average crime rates
SELECT ps.station_id, ps.location, 
    (SELECT COUNT(*) FROM CRIME c WHERE c.assigned_station_id = ps.station_id) AS crime_count
FROM POLICE_STATION ps
WHERE (SELECT COUNT(*) FROM CRIME c WHERE c.assigned_station_id = ps.station_id) > 
    (SELECT AVG(crime_count) FROM (
        SELECT COUNT(*) AS crime_count 
        FROM CRIME 
        GROUP BY assigned_station_id
    ) AS avg_crimes);

-- Query 17: Window function - Rank officers by crimes investigated
SELECT 
    po.officer_id,
    po.name,
    COUNT(i.crime_id) AS crimes_investigated,
    RANK() OVER (ORDER BY COUNT(i.crime_id) DESC) AS investigation_rank
FROM POLICE_OFFICER po
LEFT JOIN INVESTIGATION i ON po.officer_id = i.officer_id
GROUP BY po.officer_id, po.name;

-- Query 18: Complex query - Crime statistics by month and type
SELECT 
    YEAR(crime_date) AS year,
    MONTH(crime_date) AS month,
    crime_type,
    COUNT(*) AS crime_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY YEAR(crime_date), MONTH(crime_date)) AS percentage
FROM CRIME
GROUP BY YEAR(crime_date), MONTH(crime_date), crime_type
ORDER BY year, month, crime_count DESC;

-- Query 19: Aggregate with multiple conditions - Officer workload analysis
SELECT 
    po.officer_id,
    po.name,
    po.rank,
    COUNT(DISTINCT i.crime_id) AS investigations,
    COUNT(DISTINCT a.arrest_id) AS arrests,
    COUNT(DISTINCT e.evidence_id) AS evidence_collected
FROM POLICE_OFFICER po
LEFT JOIN INVESTIGATION i ON po.officer_id = i.officer_id
LEFT JOIN ARREST a ON po.officer_id = a.arresting_officer_id
LEFT JOIN EVIDENCE e ON po.officer_id = e.collected_by
GROUP BY po.officer_id, po.name, po.rank
ORDER BY investigations DESC, arrests DESC;

-- Query 20: Full text search simulation - Find crimes by description keywords
SELECT crime_id, crime_type, description, location
FROM CRIME
WHERE description LIKE '%stolen%' OR description LIKE '%assault%' OR description LIKE '%fraud%'
ORDER BY crime_date DESC;

-- =====================================================
-- 4. VIEWS
-- =====================================================

-- View 1: Active investigations summary
CREATE VIEW active_investigations AS
SELECT 
    c.crime_id,
    c.crime_type,
    c.location,
    c.status,
    po.name AS lead_investigator,
    ps.location AS station
FROM CRIME c
JOIN POLICE_OFFICER po ON c.lead_investigator_id = po.officer_id
JOIN POLICE_STATION ps ON c.assigned_station_id = ps.station_id
WHERE c.status IN ('Open', 'Under Investigation');

-- View 2: Suspect arrest history
CREATE VIEW suspect_arrest_history AS
SELECT 
    s.suspect_id,
    s.name,
    s.status,
    a.arrest_date,
    a.arrest_location,
    po.name AS arresting_officer
FROM SUSPECT s
LEFT JOIN ARREST a ON s.suspect_id = a.suspect_id
LEFT JOIN POLICE_OFFICER po ON a.arresting_officer_id = po.officer_id;

-- View 3: Crime statistics by station
CREATE VIEW crime_statistics_by_station AS
SELECT 
    ps.station_id,
    ps.location,
    COUNT(c.crime_id) AS total_crimes,
    COUNT(CASE WHEN c.status = 'Solved' THEN 1 END) AS solved_crimes,
    COUNT(CASE WHEN c.status = 'Open' THEN 1 END) AS open_crimes,
    ROUND(COUNT(CASE WHEN c.status = 'Solved' THEN 1 END) * 100.0 / COUNT(c.crime_id), 2) AS solve_rate
FROM POLICE_STATION ps
LEFT JOIN CRIME c ON ps.station_id = c.assigned_station_id
GROUP BY ps.station_id, ps.location;


