CREATE TABLE
    IF NOT EXISTS users (
        id INT PRIMARY KEY AUTO_INCREMENT,
        first_name VARCHAR(255) NOT NULL,
        last_name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        password_hash VARCHAR(255) NOT NULL,
        phone_number VARCHAR(50),
        profile_image_path VARCHAR(255),
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE
    IF NOT EXISTS clients (
        id INT PRIMARY KEY AUTO_INCREMENT,
        profile_image_path VARCHAR(255),
        first_name VARCHAR(255) NOT NULL,
        last_name VARCHAR(255) NOT NULL,
        gender ENUM ('male', 'female', 'other') NOT NULL,
        date_of_birth DATE NOT NULL,
        contact_info VARCHAR(255) NOT NULL,
        address VARCHAR(255),
        user_id INT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
    );

CREATE TABLE
    IF NOT EXISTS diagnoses (
        id INT PRIMARY KEY AUTO_INCREMENT,
        diagnosis_name VARCHAR(255) NOT NULL UNIQUE
    );

CREATE TABLE
    IF NOT EXISTS eligibility_criteria (
        id INT PRIMARY KEY AUTO_INCREMENT,
        min_age INT,
        max_age INT,
        required_diagnosis_id INT NOT NULL,
        FOREIGN KEY (required_diagnosis_id) REFERENCES diagnoses (id)
    );

CREATE TABLE
    IF NOT EXISTS health_programs (
        id INT PRIMARY KEY AUTO_INCREMENT,
        image_path VARCHAR(255),
        name VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        start_date DATETIME NOT NULL,
        end_date DATETIME,
        eligibility_criteria_id INT,
        created_by_user_id INT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (eligibility_criteria_id) REFERENCES eligibility_criteria (id),
        FOREIGN KEY (created_by_user_id) REFERENCES users (id)
    );

CREATE TABLE
    IF NOT EXISTS client_diagnoses (
        client_id INT,
        diagnosis_id INT,
        PRIMARY KEY (client_id, diagnosis_id),
        FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE,
        FOREIGN KEY (diagnosis_id) REFERENCES diagnoses (id) ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS health_program_enrollments (
        client_id INT,
        health_program_id INT,
        PRIMARY KEY (client_id, health_program_id),
        FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE,
        FOREIGN KEY (health_program_id) REFERENCES health_programs (id) ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS external_systems (
        id INT PRIMARY KEY AUTO_INCREMENT,
        api_key_hash VARCHAR(255) NOT NULL,
        system_name VARCHAR(255) NOT NULL,
        contact_email VARCHAR(255),
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        status ENUM ('active', 'revoked', 'inactive') DEFAULT 'active',
        revocation_reason TEXT
    );

INSERT IGNORE INTO diagnoses (diagnosis_name)
VALUES
    ('hivPositive'),
    ('tb'),
    ('malariaPositive'),
    ('diabetesType1'),
    ('diabetesType2'),
    ('gestationalDiabetes'),
    ('hypertension'),
    ('asthma'),
    ('chronicObstructivePulmonaryDisease'),
    ('anemia'),
    ('dengueFever'),
    ('cholera'),
    ('hepatitisB'),
    ('hepatitisC'),
    ('typhoidFever'),
    ('covid19'),
    ('pneumonia'),
    ('cirrhosisOfTheLiver'),
    ('humanPapillomavirus'),
    ('rheumatoidArthritis'),
    ('chronicKidneyDisease'),
    ('sickleCellDisease'),
    ('stroke');