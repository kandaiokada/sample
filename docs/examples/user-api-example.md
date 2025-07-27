# User API - Complete Documentation Example

This example demonstrates how to document a complete User API using our documentation templates and best practices.

## API Overview

The User API provides functionality for managing user accounts, including creation, retrieval, updating, and deletion of user records.

**Base URL**: `https://api.example.com/v1`
**Authentication**: Bearer token required
**Rate Limit**: 1000 requests per hour per user

## Endpoints

### Create User
**File**: `docs/api/endpoints/users-post.md`

This endpoint creates a new user account.

```markdown
# Create User

## Overview
Creates a new user account with the provided information.

## Endpoint Details

**URL:** `POST /api/v1/users`
**Authentication:** Required
**Rate Limit:** 10 requests per minute

## Parameters

### Request Body
```json
{
  "name": "string",
  "email": "string",
  "age": "integer"
}
```

### Headers
| Header | Required | Description |
|--------|----------|-------------|
| `Authorization` | Yes | Bearer token for authentication |
| `Content-Type` | Yes | application/json |

## Response

### Success Response (201)
```json
{
  "status": "success",
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "age": 30,
    "created_at": "2023-01-01T12:00:00Z"
  }
}
```

### Error Response (400)
```json
{
  "status": "error",
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ]
}
```

## Examples

### cURL
```bash
curl -X POST \
  'https://api.example.com/v1/users' \
  -H 'Authorization: Bearer your_token_here' \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "John Doe",
    "email": "john.doe@example.com",
    "age": 30
  }'
```

### JavaScript
```javascript
const response = await fetch('https://api.example.com/v1/users', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer your_token_here',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    name: 'John Doe',
    email: 'john.doe@example.com',
    age: 30
  })
});

const user = await response.json();
console.log(user);
```
```

### Get User by ID
**File**: `docs/api/endpoints/users-get-id.md`

This endpoint retrieves a specific user by their ID.

```markdown
# Get User by ID

## Overview
Retrieves a user account by its unique identifier.

## Endpoint Details

**URL:** `GET /api/v1/users/{id}`
**Authentication:** Required
**Rate Limit:** 100 requests per minute

## Parameters

### Path Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string (uuid) | Yes | Unique identifier for the user |

### Headers
| Header | Required | Description |
|--------|----------|-------------|
| `Authorization` | Yes | Bearer token for authentication |

## Response

### Success Response (200)
```json
{
  "status": "success",
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "age": 30,
    "created_at": "2023-01-01T12:00:00Z",
    "updated_at": "2023-01-15T14:30:00Z"
  }
}
```

### Error Response (404)
```json
{
  "status": "error",
  "message": "User not found"
}
```

## Examples

### cURL
```bash
curl -X GET \
  'https://api.example.com/v1/users/123e4567-e89b-12d3-a456-426614174000' \
  -H 'Authorization: Bearer your_token_here'
```

### JavaScript
```javascript
const userId = '123e4567-e89b-12d3-a456-426614174000';
const response = await fetch(`https://api.example.com/v1/users/${userId}`, {
  headers: {
    'Authorization': 'Bearer your_token_here'
  }
});

const user = await response.json();
console.log(user);
```
```

## Schemas

### User Schema
**File**: `docs/api/schemas/User.md`

This schema defines the structure of a user object.

```markdown
# User

## Overview
Represents a user account in the system.

## Schema Definition

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["id", "name", "email", "created_at"],
  "properties": {
    "id": {
      "type": "string",
      "format": "uuid",
      "description": "Unique identifier for the user"
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 255,
      "description": "Full name of the user"
    },
    "email": {
      "type": "string",
      "format": "email",
      "description": "Email address"
    },
    "age": {
      "type": "integer",
      "minimum": 13,
      "maximum": 120,
      "description": "Age in years"
    },
    "created_at": {
      "type": "string",
      "format": "date-time",
      "description": "Account creation timestamp"
    },
    "updated_at": {
      "type": "string",
      "format": "date-time",
      "description": "Last update timestamp"
    }
  }
}
```

## Properties

| Property | Type | Required | Constraints | Description |
|----------|------|----------|-------------|-------------|
| `id` | string (uuid) | Yes | - | Unique identifier for the user |
| `name` | string | Yes | 1-255 chars | Full name of the user |
| `email` | string (email) | Yes | Valid email format | Email address |
| `age` | integer | No | 13-120 | Age in years |
| `created_at` | string (datetime) | Yes | ISO 8601 format | Account creation timestamp |
| `updated_at` | string (datetime) | No | ISO 8601 format | Last update timestamp |

## Examples

### Complete User Object
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "name": "John Doe",
  "email": "john.doe@example.com",
  "age": 30,
  "created_at": "2023-01-01T12:00:00Z",
  "updated_at": "2023-01-15T14:30:00Z"
}
```

### Minimal User Object
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "name": "Jane Smith",
  "email": "jane.smith@example.com",
  "created_at": "2023-01-02T10:15:00Z"
}
```
```

## Components

### UserCard Component
**File**: `docs/components/UserCard.md`

A React component for displaying user information.

```markdown
# UserCard

## Overview
A card component that displays user information in a clean, formatted layout.

## Import
```javascript
import { UserCard } from './components/UserCard';
```

## Props/Parameters

| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `user` | User | Yes | - | User object to display |
| `showEmail` | boolean | No | true | Whether to show email address |
| `onClick` | (user: User) => void | No | - | Click handler for the card |
| `className` | string | No | - | Additional CSS classes |

## Basic Usage

```javascript
import React from 'react';
import { UserCard } from './components/UserCard';

function UserList({ users }) {
  return (
    <div className="user-list">
      {users.map(user => (
        <UserCard
          key={user.id}
          user={user}
          onClick={(user) => console.log('Clicked:', user.name)}
        />
      ))}
    </div>
  );
}
```

## Advanced Examples

### With Custom Styling
```javascript
<UserCard
  user={user}
  showEmail={false}
  className="custom-card"
  onClick={handleUserSelect}
/>
```

### In a Grid Layout
```javascript
<div className="grid grid-cols-3 gap-4">
  {users.map(user => (
    <UserCard
      key={user.id}
      user={user}
      onClick={navigateToProfile}
    />
  ))}
</div>
```
```

## Functions

### validateUser Function
**File**: `docs/functions/validateUser.md`

A utility function for validating user data.

```markdown
# validateUser

## Overview
Validates user data against the User schema and business rules.

## Signature
```typescript
function validateUser(
  userData: Partial<User>,
  options?: ValidationOptions
): ValidationResult
```

## Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `userData` | Partial<User> | Yes | - | User data to validate |
| `options` | ValidationOptions | No | {} | Validation configuration |

### ValidationOptions

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `strict` | boolean | No | false | Enable strict validation mode |
| `allowPartial` | boolean | No | true | Allow partial user objects |

## Return Value

**Type:** `ValidationResult`

```typescript
interface ValidationResult {
  isValid: boolean;
  errors: ValidationError[];
  warnings: string[];
}

interface ValidationError {
  field: string;
  message: string;
  code: string;
}
```

## Usage Examples

### Basic Validation
```javascript
import { validateUser } from './utils/validation';

const userData = {
  name: "John Doe",
  email: "john.doe@example.com",
  age: 30
};

const result = validateUser(userData);

if (result.isValid) {
  console.log('User data is valid');
} else {
  console.log('Validation errors:', result.errors);
}
```

### Strict Validation
```javascript
const result = validateUser(userData, {
  strict: true,
  allowPartial: false
});

if (!result.isValid) {
  result.errors.forEach(error => {
    console.error(`${error.field}: ${error.message}`);
  });
}
```

### With Error Handling
```javascript
try {
  const result = validateUser(userData);
  
  if (result.isValid) {
    await createUser(userData);
  } else {
    displayValidationErrors(result.errors);
  }
} catch (error) {
  console.error('Validation failed:', error.message);
}
```
```

## Integration Example

Here's how all these components work together in a real application:

```javascript
import React, { useState } from 'react';
import { UserCard } from './components/UserCard';
import { validateUser } from './utils/validation';

function UserManagement() {
  const [users, setUsers] = useState([]);
  const [newUser, setNewUser] = useState({
    name: '',
    email: '',
    age: ''
  });
  const [validationErrors, setValidationErrors] = useState([]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Validate user data
    const validation = validateUser(newUser);
    
    if (!validation.isValid) {
      setValidationErrors(validation.errors);
      return;
    }

    try {
      // Create user via API
      const response = await fetch('/api/v1/users', {
        method: 'POST',
        headers: {
          'Authorization': 'Bearer ' + getAuthToken(),
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(newUser)
      });

      if (response.ok) {
        const createdUser = await response.json();
        setUsers([...users, createdUser.data]);
        setNewUser({ name: '', email: '', age: '' });
        setValidationErrors([]);
      } else {
        const error = await response.json();
        console.error('API Error:', error.message);
      }
    } catch (error) {
      console.error('Network Error:', error);
    }
  };

  const handleUserClick = async (user) => {
    try {
      const response = await fetch(`/api/v1/users/${user.id}`, {
        headers: {
          'Authorization': 'Bearer ' + getAuthToken()
        }
      });

      if (response.ok) {
        const userData = await response.json();
        console.log('Full user data:', userData.data);
      }
    } catch (error) {
      console.error('Failed to fetch user details:', error);
    }
  };

  return (
    <div className="user-management">
      <h1>User Management</h1>
      
      {/* User Creation Form */}
      <form onSubmit={handleSubmit} className="mb-8">
        <div className="space-y-4">
          <input
            type="text"
            placeholder="Name"
            value={newUser.name}
            onChange={(e) => setNewUser({...newUser, name: e.target.value})}
            className="w-full p-2 border rounded"
          />
          <input
            type="email"
            placeholder="Email"
            value={newUser.email}
            onChange={(e) => setNewUser({...newUser, email: e.target.value})}
            className="w-full p-2 border rounded"
          />
          <input
            type="number"
            placeholder="Age"
            value={newUser.age}
            onChange={(e) => setNewUser({...newUser, age: parseInt(e.target.value)})}
            className="w-full p-2 border rounded"
          />
          <button type="submit" className="px-4 py-2 bg-blue-500 text-white rounded">
            Create User
          </button>
        </div>
        
        {/* Validation Errors */}
        {validationErrors.length > 0 && (
          <div className="mt-4 p-4 bg-red-100 border border-red-400 rounded">
            <h3 className="text-red-800 font-semibold">Validation Errors:</h3>
            <ul className="list-disc list-inside text-red-700">
              {validationErrors.map((error, index) => (
                <li key={index}>{error.field}: {error.message}</li>
              ))}
            </ul>
          </div>
        )}
      </form>

      {/* User List */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {users.map(user => (
          <UserCard
            key={user.id}
            user={user}
            onClick={handleUserClick}
            className="hover:shadow-lg transition-shadow"
          />
        ))}
      </div>
    </div>
  );
}

function getAuthToken() {
  // Implementation would retrieve token from storage
  return localStorage.getItem('authToken');
}

export default UserManagement;
```

## Documentation Workflow

1. **API Development**: When developing the User API endpoints
   - Copy `docs/templates/api/endpoint-template.md` 
   - Fill in endpoint details, parameters, responses
   - Add realistic examples

2. **Schema Documentation**: For data models
   - Copy `docs/templates/api/schema-template.md`
   - Define JSON schema and properties
   - Provide validation examples

3. **Component Documentation**: For UI components
   - Copy `docs/templates/components/component-template.md`
   - Document props, events, styling options
   - Include usage examples

4. **Function Documentation**: For utility functions
   - Copy `docs/templates/functions/function-template.md`
   - Document parameters, return values, exceptions
   - Show integration examples

5. **Validation**: Run validation scripts
   ```bash
   ./scripts/validate-docs.sh docs/
   ```

This example demonstrates how comprehensive documentation makes it easy for developers to understand and use your APIs, components, and functions effectively.