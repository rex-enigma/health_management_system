Draft

# Health_managment_system

A new Flutter project.


## Prerequisite
- nodejs_version: v16.20.2
- Flutter_version: 3.27.1
- JDK_version: 17
- MySQL_version: 8.0.41
- Stacked_cli_version: 1.14.0

## Setup
### Backend:
- Create a `.env` file in `backend` directory to hold the following variables:
```
DB_HOST=localhost
DB_PORT=<your_db_port>
DB_NAME=<your_db_name>
DB_USER=<your_db_user>
DB_PASSWORD=<your_db_name>
JWT_SECRET=<your_jwt_secret>
```

### Frontend:
- Create a `.env` file in the root directory of the project for flutter to hold `BASE_URL` for remote data source.
```
BASE_URL=<your API's base URL>
```

## Implemented Functionality
1. User Authentication with JWT
2. **View Health Programs**: Users can view a paginated list of health programs.
3. **Search Health Programs**: Users can search health programs by name or description, with results paginated.
4. **View Health Program Details**: Users can view detailed information about a specific health program, including eligibility criteria and creator details.
5. **Create Health Program**: Users can create a new health program with details like name, description, dates, and eligibility criteria (min/max age, required diagnosis)
6. **Delete Health Program:** Users can delete a health program
7. **View Clients**: Users can view a paginated list of clients with infinite scrolling.
8. **Search Clients**: Users can search clients by first or last name, with results paginated.
View Client Profile: Users can view detailed client information, including enrolled programs, diagnoses, and personal details.
1.  **Register Client**: Users can register a new client with details like name, gender, date of birth, contact info, address, and diagnoses.
2.   **Delete Client**: Users can delete a client
3.   **Enroll Client in Programs**: Users can enroll a client in eligible health programs with eligibility checks based on age and diagnoses.
4.   The system has the ability to generate api key for external system integration.


**Find API Documentation in docs folder in the root directory of this project (its in a draft mode)**

<!-- ## Screens -->

[ERD](./design/database_ERD/Screenshot%20from%202025-04-27%2023-18-15.png)