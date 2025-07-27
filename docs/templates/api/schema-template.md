# SchemaName

## Overview
Brief description of what this schema represents and its purpose in the API.

## Schema Definition

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["id", "name", "created_at"],
  "properties": {
    "id": {
      "type": "string",
      "format": "uuid",
      "description": "Unique identifier for the resource"
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 255,
      "description": "Display name of the resource"
    },
    "email": {
      "type": "string",
      "format": "email",
      "description": "Email address (optional)"
    },
    "age": {
      "type": "integer",
      "minimum": 0,
      "maximum": 150,
      "description": "Age in years"
    },
    "tags": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "uniqueItems": true,
      "description": "List of associated tags"
    },
    "metadata": {
      "$ref": "#/definitions/Metadata"
    },
    "created_at": {
      "type": "string",
      "format": "date-time",
      "description": "Creation timestamp"
    },
    "updated_at": {
      "type": "string",
      "format": "date-time",
      "description": "Last update timestamp"
    }
  },
  "definitions": {
    "Metadata": {
      "type": "object",
      "properties": {
        "source": {
          "type": "string",
          "description": "Data source identifier"
        },
        "version": {
          "type": "string",
          "description": "Schema version"
        }
      }
    }
  }
}
```

## Properties

| Property | Type | Required | Constraints | Description |
|----------|------|----------|-------------|-------------|
| `id` | string (uuid) | Yes | - | Unique identifier for the resource |
| `name` | string | Yes | 1-255 chars | Display name of the resource |
| `email` | string (email) | No | Valid email format | Email address |
| `age` | integer | No | 0-150 | Age in years |
| `tags` | array[string] | No | Unique items | List of associated tags |
| `metadata` | Metadata | No | - | Additional metadata object |
| `created_at` | string (datetime) | Yes | ISO 8601 format | Creation timestamp |
| `updated_at` | string (datetime) | No | ISO 8601 format | Last update timestamp |

## Nested Schemas

### Metadata
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `source` | string | No | Data source identifier |
| `version` | string | No | Schema version |

## Examples

### Minimal Valid Example
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "name": "John Doe",
  "created_at": "2023-01-01T12:00:00Z"
}
```

### Complete Example
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "name": "John Doe",
  "email": "john.doe@example.com",
  "age": 30,
  "tags": ["developer", "javascript", "react"],
  "metadata": {
    "source": "api_v1",
    "version": "2.1.0"
  },
  "created_at": "2023-01-01T12:00:00Z",
  "updated_at": "2023-01-15T14:30:00Z"
}
```

### Array Example
```json
[
  {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "name": "John Doe",
    "created_at": "2023-01-01T12:00:00Z"
  },
  {
    "id": "987fcdeb-51a2-43d7-b123-456789abcdef",
    "name": "Jane Smith",
    "email": "jane.smith@example.com",
    "age": 28,
    "created_at": "2023-01-02T10:15:00Z"
  }
]
```

## Validation Rules

### Required Fields
- `id`: Must be a valid UUID v4
- `name`: Cannot be empty, maximum 255 characters
- `created_at`: Must be valid ISO 8601 datetime

### Optional Field Constraints
- `email`: Must be valid email format if provided
- `age`: Must be between 0 and 150 if provided
- `tags`: Array items must be unique if provided
- `updated_at`: Must be valid ISO 8601 datetime if provided

### Business Rules
- `updated_at` must be greater than or equal to `created_at`
- `name` cannot contain only whitespace
- `tags` array cannot contain empty strings
- Maximum of 50 tags per resource

## Error Examples

### Invalid UUID
```json
{
  "id": "invalid-uuid",
  "name": "John Doe",
  "created_at": "2023-01-01T12:00:00Z"
}
```
**Error**: `Invalid UUID format for field 'id'`

### Missing Required Field
```json
{
  "name": "John Doe",
  "created_at": "2023-01-01T12:00:00Z"
}
```
**Error**: `Required field 'id' is missing`

### Invalid Email Format
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "name": "John Doe",
  "email": "invalid-email",
  "created_at": "2023-01-01T12:00:00Z"
}
```
**Error**: `Invalid email format for field 'email'`

### Age Out of Range
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "name": "John Doe",
  "age": 200,
  "created_at": "2023-01-01T12:00:00Z"
}
```
**Error**: `Age must be between 0 and 150`

## Usage in APIs

### Endpoints Using This Schema

#### As Request Body
- `POST /api/v1/users` - Create new user
- `PUT /api/v1/users/{id}` - Update user

#### As Response Body
- `GET /api/v1/users/{id}` - Get user by ID
- `GET /api/v1/users` - List users (array of this schema)
- `POST /api/v1/users` - Create user (returns created user)

### Content Types
- **Request**: `application/json`
- **Response**: `application/json`

## Language-Specific Examples

### JavaScript/TypeScript
```typescript
interface SchemaName {
  id: string;
  name: string;
  email?: string;
  age?: number;
  tags?: string[];
  metadata?: {
    source?: string;
    version?: string;
  };
  created_at: string;
  updated_at?: string;
}

// Usage
const user: SchemaName = {
  id: "123e4567-e89b-12d3-a456-426614174000",
  name: "John Doe",
  created_at: "2023-01-01T12:00:00Z"
};
```

### Python
```python
from typing import Optional, List, Dict
from pydantic import BaseModel, Field, validator
from datetime import datetime
import uuid

class Metadata(BaseModel):
    source: Optional[str] = None
    version: Optional[str] = None

class SchemaName(BaseModel):
    id: str = Field(..., description="Unique identifier")
    name: str = Field(..., min_length=1, max_length=255)
    email: Optional[str] = Field(None, regex=r'^[^@]+@[^@]+\.[^@]+$')
    age: Optional[int] = Field(None, ge=0, le=150)
    tags: Optional[List[str]] = None
    metadata: Optional[Metadata] = None
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    @validator('id')
    def validate_uuid(cls, v):
        uuid.UUID(v)  # Raises ValueError if invalid
        return v
```

### Java
```java
import com.fasterxml.jackson.annotation.JsonProperty;
import javax.validation.constraints.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class SchemaName {
    @NotNull
    private UUID id;
    
    @NotBlank
    @Size(max = 255)
    private String name;
    
    @Email
    private String email;
    
    @Min(0)
    @Max(150)
    private Integer age;
    
    private List<String> tags;
    
    private Metadata metadata;
    
    @NotNull
    @JsonProperty("created_at")
    private LocalDateTime createdAt;
    
    @JsonProperty("updated_at")
    private LocalDateTime updatedAt;
    
    // Getters and setters...
    
    public static class Metadata {
        private String source;
        private String version;
        // Getters and setters...
    }
}
```

## Migration Guide

### From v1.0 to v2.0
- Added `metadata` field (optional)
- Changed `created` to `created_at`
- Added email format validation

### Breaking Changes
```json
// Old (v1.0)
{
  "id": "123",
  "name": "John",
  "created": "2023-01-01"
}

// New (v2.0)
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "name": "John",
  "created_at": "2023-01-01T12:00:00Z"
}
```

## Related Schemas

- [UserProfile](./user-profile.md) - Extended user information
- [UserPreferences](./user-preferences.md) - User settings and preferences
- [UserActivity](./user-activity.md) - User activity tracking

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 2.1.0 | 2023-03-01 | Added tags array support |
| 2.0.0 | 2023-02-01 | Breaking: UUID format, datetime format changes |
| 1.0.0 | 2023-01-01 | Initial schema definition |