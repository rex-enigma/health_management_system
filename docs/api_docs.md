Draft

# Health Management System API Documentation

This document provides detailed specifications for the RESTful APIs used in the Health Management System. The APIs utilize **JWT** for user authentication and an **API key** for third-party access to client data. 

## Overview

- **Authentication:** All requests (except `/v1/auth/login` and `/v1/auth/signup`) require a JWT token in the `Authorization` header.
- **Third-Party Access:** Third-party applications can access client data via `/v1/clients`, `/v1/clients/{id}` and `/v1/clients/search` endpoints, authenticated using an API key in the `X-API-Key` header.
- **Error Handling:** Error responses include a `status` field (`error`) and a `message` field.

## Table of Contents

- [Health Management System API Documentation](#health-management-system-api-documentation)
  - [Overview](#overview)
  - [Table of Contents](#table-of-contents)
  - [Authentication APIs](#authentication-apis)
    - [1. Login](#1-login)
      - [Request Body](#request-body)
      - [Responses](#responses)
    - [2. Signup](#2-signup)
      - [Request Body](#request-body-1)
      - [Responses](#responses-1)
  - [Health Program APIs](#health-program-apis)
    - [3. Get All Health Programs](#3-get-all-health-programs)
      - [Query Parameters](#query-parameters)
      - [Responses](#responses-2)
    - [4. Search Health Programs](#4-search-health-programs)
      - [Query Parameters](#query-parameters-1)
      - [Responses](#responses-3)
    - [5. Get Health Program by ID](#5-get-health-program-by-id)
      - [Responses](#responses-4)
    - [6. Create Health Program](#6-create-health-program)
      - [Request Body](#request-body-2)
      - [Responses](#responses-5)
    - [7. Delete Health Program](#7-delete-health-program)
      - [Responses](#responses-6)
  - [Client APIs](#client-apis)
    - [8. Get All Clients](#8-get-all-clients)
      - [Query Parameters](#query-parameters-2)
      - [Responses](#responses-7)
    - [9. Search Clients](#9-search-clients)
      - [Query Parameters](#query-parameters-3)
      - [Responses](#responses-8)
    - [10. Get Client by ID](#10-get-client-by-id)
      - [Responses](#responses-9)
    - [11. Create Client](#11-create-client)
      - [Request Body](#request-body-3)
      - [Responses](#responses-10)
    - [12. Delete Client](#12-delete-client)
      - [Responses](#responses-11)
    - [13. Enroll Client in Programs](#13-enroll-client-in-programs)
      - [Responses](#responses-12)
  - [Third-Party Access API](#third-party-access-api)
    - [14. Get All Clients (Third-Party)](#14-get-all-clients-third-party)
      - [Query Parameters](#query-parameters-4)
      - [Responses](#responses-13)
    - [15. Search Clients (Third-Party)](#15-search-clients-third-party)
      - [Query Parameters](#query-parameters-5)
      - [Responses](#responses-14)
    - [16. Get Client Health Data (Third-Party)](#16-get-client-health-data-third-party)
      - [Responses](#responses-15)
  - [Additional Notes](#additional-notes)
  - [Additional Notes](#additional-notes-1)

---

## Authentication APIs

### 1. Login

**Authenticate a user and return a JWT token.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `POST`                         |
| **Endpoint**    | `/v1/auth/login`               |
| **Headers**     | `Content-Type: application/json` |

#### Request Body
```json
{
  "email": "admin@example.com",
  "password": "admin123"
}
```

#### Responses

- **Success (200):**
  ```json
  {
    "user": {
      "id": 1,
      "username": "admin",
      "email": "admin@example.com"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
  ```

- **Error (401):**
  ```json
  {
    "status": "error",
    "message": "Invalid credentials"
  }
  ```

---

### 2. Signup

**Register a new user and return a JWT token.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `POST`                         |
| **Endpoint**    | `/v1/auth/signup`              |
| **Headers**     | `Content-Type: application/json` |

#### Request Body
```json
{
  "username": "newuser",
  "email": "newuser@example.com",
  "password": "newuser123"
}
```

#### Responses

- **Success (201):**
  ```json
  {
    "user": {
      "id": 3,
      "username": "newuser",
      "email": "newuser@example.com"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
  ```

- **Error (400):**
  ```json
  {
    "status": "error",
    "message": "Email already exists"
  }
  ```

---

## Health Program APIs

### 3. Get All Health Programs

**Retrieve a list of health programs.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `GET`                          |
| **Endpoint**    | `/v1/health-programs?page={page}&limit={limit}` |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` |

#### Query Parameters
| **Parameter** | **Description**           | **Default** |
|---------------|---------------------------|-------------|
| `page`        | Page number              | 1           |
| `limit`       | Items per page           | 10          |

#### Responses

- **Success (200):**
  ```json
  [
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
  ]
  ```

- **Error (401):**
  ```json
  {
    "status": "error",
    "message": "Unauthorized"
  }
  ```

---

### 4. Search Health Programs

**Search health programs by name or description.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `GET`                          |
| **Endpoint**    | `/v1/health-programs/search?query={query}&page={page}&limit={limit}` |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` |

#### Query Parameters
| **Parameter** | **Description**           | **Default** |
|---------------|---------------------------|-------------|
| `query`       | Search term              | N/A         |
| `page`        | Page number              | 1           |
| `limit`       | Items per page           | 10          |

#### Responses

- **Success (200):**
  ```json
  [
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
  ]
  ```

---

### 5. Get Health Program by ID

**Retrieve details of a specific health program.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `GET`                          |
| **Endpoint**    | `/v1/health-programs/{id}`     |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` |

#### Responses

- **Success (200):**
  ```json
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
  ```

---

### 6. Create Health Program

**Create a new health program.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `POST`                         |
| **Endpoint**    | `/v1/health-programs`          |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` <br> `Content-Type: application/json` |

#### Request Body
```json
{
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
```

#### Responses

- **Success (201):**
  ```json
  {
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
  ```

---

### 7. Delete Health Program

**Delete a health program by ID.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `DELETE`                       |
| **Endpoint**    | `/v1/health-programs/{id}`     |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` |

#### Responses

- **Success (204):** No content.
- **Error (404):**
  ```json
  {
    "status": "error",
    "message": "Health program not found"
  }
  ```

---

## Client APIs

### 8. Get All Clients

**Retrieve a list of clients.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `GET`                          |
| **Endpoint**    | `/v1/clients?page={page}&limit={limit}` |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` |

#### Query Parameters
| **Parameter** | **Description**           | **Default** |
|---------------|---------------------------|-------------|
| `page`        | Page number              | 1           |
| `limit`       | Items per page           | 10          |

#### Responses

- **Success (200):**
  ```json
  [
    {
      "id": 1,
      "firstName": "John",
      "lastName": "Doe",
      "gender": "male",
      "dateOfBirth": "1980-05-15T00:00:00Z",
      "contactInfo": "john.doe@example.com",
      "address": "123 Main St, City",
      "diagnoses": ["diabetes"],
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
  ]
  ```

---

### 9. Search Clients

**Search clients by name.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `GET`                          |
| **Endpoint**    | `/v1/clients/search?query={query}&page={page}&limit={limit}` |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` |

#### Query Parameters
| **Parameter** | **Description**           | **Default** |
|---------------|---------------------------|-------------|
| `query`       | Search term              | N/A         |
| `page`        | Page number              | 1           |
| `limit`       | Items per page           | 10          |

#### Responses

- **Success (200):**
  ```json
  [
    {
      "id": 1,
      "firstName": "John",
      "lastName": "Doe",
      "gender": "male",
      "dateOfBirth": "1980-05-15T00:00:00Z",
      "contactInfo": "john.doe@example.com",
      "address": "123 Main St, City",
      "diagnoses": ["diabetes"],
      "enrolledPrograms": [],
      "registeredByUser": {
        "id": 1,
        "username": "admin",
        "email": "admin@example.com"
      },
      "createdAt": "2024-10-10T00:00:00Z"
    }
  ]
  ```

---

### 10. Get Client by ID

**Retrieve details of a specific client.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `GET`                          |
| **Endpoint**    | `/v1/clients/{id}`             |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` |

#### Responses

- **Success (200):**
  ```json
  {
    "id": 1,
    "firstName": "John",
    "lastName": "Doe",
    "gender": "male",
    "dateOfBirth": "1980-05-15T00:00:00Z",
    "contactInfo": "john.doe@example.com",
    "address": "123 Main St, City",
    "diagnoses": ["diabetes"],
    "enrolledPrograms": [],
    "registeredByUser": {
      "id": 1,
      "username": "admin",
      "email": "admin@example.com"
    },
    "createdAt": "2024-10-10T00:00:00Z"
  }
  ```

---

### 11. Create Client

**Register a new client.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `POST`                         |
| **Endpoint**    | `/v1/clients`                  |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` <br> `Content-Type: application/json` |

#### Request Body
```json
{
  "firstName": "New",
  "lastName": "Client",
  "gender": "female",
  "dateOfBirth": "1990-01-01T00:00:00Z",
  "contactInfo": "new.client@example.com",
  "address": "789 Elm St, City",
  "diagnosis_names": ["hypertension"]
}
```

#### Responses

- **Success (201):**
  ```json
  {
    "id": 4,
    "firstName": "New",
    "lastName": "Client",
    "gender": "female",
    "dateOfBirth": "1990-01-01T00:00:00Z",
    "contactInfo": "new.client@example.com",
    "address": "789 Elm St, City",
    "diagnosis_names": ["hypertension"],
    "enrolledPrograms": [],
    "registeredByUser": {
      "id": 1,
      "username": "admin",
      "email": "admin@example.com"
    },
    "createdAt": "2025-04-27T00:00:00Z"
  }
  ```

---

### 12. Delete Client

**Delete a client by ID.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `DELETE`                       |
| **Endpoint**    | `/v1/clients/{id}`             |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` |

#### Responses

- **Success (204):** No content.

---

### 13. Enroll Client in Programs

**Enroll a client in one or more health programs.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `POST`                         |
| **Endpoint**    | `/v1/clients/{clientId}/enroll` |
| **Headers**     | `Authorization: Bearer <JWT_TOKEN>` <br> `Content-Type: application/json` |

#### Responses

- **Success (200):**
  ```json
  {
    "message": "Client enrolled successfully"
  }
  ```

---

## Third-Party Access API

### 14. Get All Clients (Third-Party)

**Allow third-party applications to retrieve a list of clients.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `GET`                          |
| **Endpoint**    | `/v1/clients?page={page}&limit={limit}` |
| **Headers**     | `X-API-Key: <API_KEY>`         |

#### Query Parameters
| **Parameter** | **Description**           | **Default** |
|---------------|---------------------------|-------------|
| `page`        | Page number              | 1           |
| `limit`       | Items per page           | 10          |

#### Responses

- **Success (200):**
  ```json
  [
    {
      "id": 1,
      "firstName": "John",
      "lastName": "Doe",
      "gender": "male",
      "dateOfBirth": "1980-05-15T00:00:00Z",
      "contactInfo": "john.doe@example.com",
      "address": "123 Main St, City",
      "diagnoses": ["diabetes"],
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
  ]
  ```

- **Error (403):**
  ```json
  {
    "status": "error",
    "message": "Invalid API key"
  }
  ```

---

### 15. Search Clients (Third-Party)

**Allow third-party applications to search clients by name.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `GET`                          |
| **Endpoint**    | `/v1/clients/search?query={query}&page={page}&limit={limit}` |
| **Headers**     | `X-API-Key: <API_KEY>`         |

#### Query Parameters
| **Parameter** | **Description**           | **Default** |
|---------------|---------------------------|-------------|
| `query`       | Search term              | N/A         |
| `page`        | Page number              | 1           |
| `limit`       | Items per page           | 10          |

#### Responses

- **Success (200):**
  ```json
  [
    {
      "id": 1,
      "firstName": "John",
      "lastName": "Doe",
      "gender": "male",
      "dateOfBirth": "1980-05-15T00:00:00Z",
      "contactInfo": "john.doe@example.com",
      "address": "123 Main St, City",
      "diagnoses": ["diabetes"],
      "enrolledPrograms": [],
      "registeredByUser": {
        "id": 1,
        "username": "admin",
        "email": "admin@example.com"
      },
      "createdAt": "2024-10-10T00:00:00Z"
    }
  ]
  ```

- **Error (403):**
  ```json
  {
    "status": "error",
    "message": "Invalid API key"
  }
  ```

---

### 16. Get Client Health Data (Third-Party)

**Allow third-party applications to access health data for a specific client.**

| **Field**       | **Value**                       |
|-----------------|---------------------------------|
| **Method**      | `GET`                          |
| **Endpoint**    | `/v1/third-party/clients/{clientId}/health-data` |
| **Headers**     | `X-API-Key: <API_KEY>`         |

#### Responses

- **Success (200):**
  ```json
  {
    "clientId": 1,
    "firstName": "John",
    "lastName": "Doe",
    "gender": "male",
    "dateOfBirth": "1980-05-15T00:00:00Z",
    "diagnoses": ["diabetes"],
    "enrolledPrograms": [
      {
        "id": 3,
        "name": "General Wellness Program",
        "description": "A program for overall health and wellness.",
        "startDate": "2025-03-01T00:00:00Z",
        "endDate": "2025-09-30T00:00:00Z"
      }
    ]
  }
  ```

- **Error (403):**
  ```json
  {
    "status": "error",
    "message": "Invalid API key"
  }
  ```

- **Error (404):**
  ```json
  {
    "status": "error",
    "message": "Client not found"
  }
  ```

---

## Additional Notes

- **JWT Token Management:** After login/signup, store the JWT token locally (e.g., using `shared_preferences`). Include it in the `Authorization` header for all authenticated requests. On a 401 response, redirect the user to the login screen and clear the token.
- **API Key for Third-Party Access:** Generate API keys for trusted third-party applications and validate them on the server side for the `/v1/clients`, `/v1/clients/search`, and `/v1/third-party/clients/{clientId}/health-data` endpoints. Store API keys securely and revoke them if necessary.
- **Error Handling:** All API error responses include a `status` field (`error`) and a `message` field for errors, making it easy to display user-friendly messages in the app.

This documentation provides a comprehensive guide for developers integrating with the Health Management System APIs.

## Additional Notes

- **JWT Token Management:** After login/signup, store the JWT token locally (e.g., using `flutter_secure_storage`). Include it in the `Authorization` header for all authenticated requests. On a 401 response, redirect the user to the login screen and clear the token.
- **API Key Security:** The API key for the third-party health data API should be stored securely (e.g., in a .env file) and included in the X-API-Key header.
- You should create .`env` in the root directory of flutter project for holding BASE_URL and use `flutter_dotenv` to load the your flutter project based environment variables
  
This documentation provides a comprehensive guide for developers integrating with the Health Management System APIs.