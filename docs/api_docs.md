Health Management System API Documentation
This document outlines the RESTful APIs for the Health Management System. The APIs use JWT for user authentication and an API key for third-party service integration. 
Table of Contents

**Authentication APIs
**Login
Signup


**Health Program APIs**
Get All Health Programs
Search Health Programs
Get Health Program by ID
Create Health Program
Delete Health Program


**Client APIs**
Get All Clients
Search Clients
Get Client by ID
Create Client
Delete Client
Enroll Client in Programs


**Third-Party Health Data API**
Get Client Health Data




Authentication APIs
1. Login
Authenticate a user and return a JWT token.

Endpoint: POST /auth/login
Headers:
Content-Type: application/json


Body:{
  "email": "admin@example.com",
  "password": "admin123"
}


Success Response (200):{
  "status": "success",
  "data": {
    "user": {
      "id": 1,
      "username": "admin",
      "email": "admin@example.com"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}


Error Response (401):{
  "status": "error",
  "message": "Invalid credentials"
}



2. Signup
Register a new user and return a JWT token.

Endpoint: POST /auth/signup
Headers:
Content-Type: application/json


Body:{
  "username": "newuser",
  "email": "newuser@example.com",
  "password": "newuser123"
}


Success Response (201):{
  "status": "success",
  "data": {
    "user": {
      "id": 3,
      "username": "newuser",
      "email": "newuser@example.com"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}


Error Response (400):{
  "status": "error",
  "message": "Email already exists"
}




Health Program APIs
3. Get All Health Programs
Retrieve a paginated list of health programs.

Endpoint: GET /health-programs?page={page}&limit={limit}
Headers:
Authorization: Bearer <JWT_TOKEN>


Query Parameters:
page: Page number (default: 1)
limit: Number of items per page (default: 10)


Success Response (200):{
  "status": "success",
  "data": [
    {
      "id": 1,
      "name": "Diabetes Management Program",
      "description": "A program to manage diabetes through diet and exercise.",
      "startDate": "2025-01-01T00:00:00Z",
      "endDate": "2025-12-31T00:00:00Z",
      "eligibilityCriteria": {
        "id": 1,
        "minAge": 30,
        "maxAge": 60,
        "requiredDiagnosis": "diabetes"
      },
      "createdByUser": {
        "id": 1,
        "username": "admin",
        "email": "admin@example.com"
      },
      "createdAt": "2024-10-01T00:00:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 3,
    "hasMore": true
  }
}


Error Response (401):{
  "status": "error",
  "message": "Unauthorized"
}



4. Search Health Programs
Search health programs by name or description.

Endpoint: GET /health-programs/search?query={query}&page={page}&limit={limit}
Headers:
Authorization: Bearer <JWT_TOKEN>


Query Parameters:
query: Search term
page: Page number
limit: Number of items per page


Success Response (200):{
  "status": "success",
  "data": [
    {
      "id": 1,
      "name": "Diabetes Management Program",
      "description": "A program to manage diabetes through diet and exercise.",
      "startDate": "2025-01-01T00:00:00Z",
      "endDate": "2025-12-31T00:00:00Z",
      "eligibilityCriteria": {
        "id": 1,
        "minAge": 30,
        "maxAge": 60,
        "requiredDiagnosis": "diabetes"
      },
      "createdByUser": {
        "id": 1,
        "username": "admin",
        "email": "admin@example.com"
      },
      "createdAt": "2024-10-01T00:00:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "hasMore": false
  }
}



5. Get Health Program by ID
Retrieve details of a specific health program.

Endpoint: GET /health-programs/{id}
Headers:
Authorization: Bearer <JWT_TOKEN>


Success Response (200):{
  "status": "success",
  "data": {
    "id": 1,
    "name": "Diabetes Management Program",
    "description": "A program to manage diabetes through diet and exercise.",
    "startDate": "2025-01-01T00:00:00Z",
    "endDate": "2025-12-31T00:00:00Z",
    "eligibilityCriteria": {
      "id": 1,
      "minAge": 30,
      "maxAge": 60,
      "requiredDiagnosis": "diabetes"
    },
    "createdByUser": {
      "id": 1,
      "username": "admin",
      "email": "admin@example.com"
    },
    "createdAt": "2024-10-01T00:00:00Z"
  }
}



6. Create Health Program
Create a new health program.

Endpoint: POST /health-programs
Headers:
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json


Body:{
  "name": "New Program",
  "description": "A new health program.",
  "startDate": "2025-06-01T00:00:00Z",
  "endDate": "2025-12-01T00:00:00Z",
  "eligibilityCriteria": {
    "minAge": 25,
    "maxAge": 50,
    "requiredDiagnosis": "none"
  }
}


Success Response (201):{
  "status": "success",
  "data": {
    "id": 4,
    "name": "New Program",
    "description": "A new health program.",
    "startDate": "2025-06-01T00:00:00Z",
    "endDate": "2025-12-01T00:00:00Z",
    "eligibilityCriteria": {
      "id": 4,
      "minAge": 25,
      "maxAge": 50,
      "requiredDiagnosis": "none"
    },
    "createdByUser": {
      "id": 1,
      "username": "admin",
      "email": "admin@example.com"
    },
    "createdAt": "2025-04-27T00:00:00Z"
  }
}



7. Delete Health Program
Delete a health program by ID.

Endpoint: DELETE /health-programs/{id}
Headers:
Authorization: Bearer <JWT_TOKEN>


Success Response (204): No content.
Error Response (404):{
  "status": "error",
  "message": "Health program not found"
}




Client APIs
8. Get All Clients
Retrieve a paginated list of clients.

Endpoint: GET /clients?page={page}&limit={limit}
Headers:
Authorization: Bearer <JWT_TOKEN>


Query Parameters:
page: Page number (default: 1)
limit: Number of items per page (default: 10)


Success Response (200):{
  "status": "success",
  "data": [
    {
      "id": 1,
      "firstName": "John",
      "lastName": "Doe",
      "gender": "male",
      "dateOfBirth": "1980-05-15T00:00:00Z",
      "contactInfo": "john.doe@example.com",
      "address": "123 Main St, City",
      "currentDiagnoses": ["diabetes"],
      "enrolledPrograms": [
        {
          "id": 3,
          "name": "General Wellness Program",
          "description": "A program for overall health and wellness.",
          "startDate": "2025-03-01T00:00:00Z",
          "endDate": "2025-09-30T00:00:00Z"
        }
      ],
      "registeredByUser": {
        "id": 1,
        "username": "admin",
        "email": "admin@example.com"
      },
      "createdAt": "2024-10-10T00:00:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 3,
    "hasMore": true
  }
}



9. Search Clients
Search clients by name.

Endpoint: GET /clients/search?query={query}&page={page}&limit={limit}
Headers:
Authorization: Bearer <JWT_TOKEN>


Query Parameters:
query: Search term
page: Page number
limit: Number of items per page


Success Response (200):{
  "status": "success",
  "data": [
    {
      "id": 1,
      "firstName": "John",
      "lastName": "Doe",
      "gender": "male",
      "dateOfBirth": "1980-05-15T00:00:00Z",
      "contactInfo": "john.doe@example.com",
      "address": "123 Main St, City",
      "currentDiagnoses": ["diabetes"],
      "enrolledPrograms": [],
      "registeredByUser": {
        "id": 1,
        "username": "admin",
        "email": "admin@example.com"
      },
      "createdAt": "2024-10-10T00:00:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "hasMore": false
  }
}



10. Get Client by ID
Retrieve details of a specific client.

Endpoint: GET /clients/{id}
Headers:
Authorization: Bearer <JWT_TOKEN>


Success Response (200):{
  "status": "success",
  "data": {
    "id": 1,
    "firstName": "John",
    "lastName": "Doe",
    "gender": "male",
    "dateOfBirth": "1980-05-15T00:00:00Z",
    "contactInfo": "john.doe@example.com",
    "address": "123 Main St, City",
    "currentDiagnoses": ["diabetes"],
    "enrolledPrograms": [],
    "registeredByUser": {
      "id": 1,
      "username": "admin",
      "email": "admin@example.com"
    },
    "createdAt": "2024-10-10T00:00:00Z"
  }
}



11. Create Client
Register a new client.

Endpoint: POST /clients
Headers:
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json


Body:{
  "firstName": "New",
  "lastName": "Client",
  "gender": "female",
  "dateOfBirth": "1990-01-01T00:00:00Z",
  "contactInfo": "new.client@example.com",
  "address": "789 Elm St, City",
  "currentDiagnoses": ["hypertension"]
}


Success Response (201):{
  "status": "success",
  "data": {
    "id": 4,
    "firstName": "New",
    "lastName": "Client",
    "gender": "female",
    "dateOfBirth": "1990-01-01T00:00:00Z",
    "contactInfo": "new.client@example.com",
    "address": "789 Elm St, City",
    "currentDiagnoses": ["hypertension"],
    "enrolledPrograms": [],
    "registeredByUser": {
      "id": 1,
      "username": "admin",
      "email": "admin@example.com"
    },
    "createdAt": "2025-04-27T00:00:00Z"
  }
}



12. Delete Client
Delete a client by ID.

Endpoint: DELETE /clients/{id}
Headers:
Authorization: Bearer <JWT_TOKEN>


Success Response (204): No content.

13. Enroll Client in Programs
Enroll a client in one or more health programs.

Endpoint: POST /clients/{clientId}/enroll
Headers:
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json


Body:{
  "healthProgramIds": [1, 3]
}


Success Response (200):{
  "status": "success",
  "message": "Client enrolled successfully"
}


Error Response (400):{
  "status": "error",
  "message": "Client is not eligible for programs with IDs: 1",
  "ineligibleHealthProgramIds": [1]
}




Third-Party Health Data API
14. Get Client Health Data
Fetch additional health data for a client from a third-party service.

Endpoint: GET https://thirdparty.healthapi.com/v1/clients/{clientId}/health-data
Headers:
X-API-Key: <API_KEY>


Success Response (200):{
  "status": "success",
  "data": {
    "clientId": 1,
    "bloodPressureHistory": [
      {
        "date": "2025-04-01T00:00:00Z",
        "systolic": 120,
        "diastolic": 80
      }
    ]
  }
}


Error Response (403):{
  "status": "error",
  "message": "Invalid API key"
}




Notes

JWT Token: Include the JWT token in the Authorization header for all authenticated requests. If the token is invalid or expired (401 response), the client should redirect to the login screen.
API Key: The API key for the third-party health data API should be stored securely (e.g., in a .env file) and included in the X-API-Key header.

You should create .env in the root directory of flutter project for holding BASE_URL

This API documentation is designed to support the Health Management System's functionality, including user authentication, health program management, client management, and third-party data integration.
