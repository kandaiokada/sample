# [Endpoint Name]

## Overview
Brief description of what this endpoint does and its primary purpose.

## Endpoint Details

**URL:** `[METHOD] /api/v1/endpoint`
**Authentication:** Required/Optional
**Rate Limit:** X requests per minute

## Parameters

### Path Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Unique identifier for the resource |

### Query Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `limit` | integer | No | 10 | Number of items to return (1-100) |
| `offset` | integer | No | 0 | Number of items to skip |
| `sort` | string | No | created_at | Field to sort by |
| `order` | string | No | desc | Sort order (asc/desc) |

### Request Body
```json
{
  "property1": "string",
  "property2": 123,
  "property3": {
    "nested_property": "value"
  }
}
```

### Headers
| Header | Required | Description |
|--------|----------|-------------|
| `Authorization` | Yes | Bearer token for authentication |
| `Content-Type` | Yes | application/json |
| `X-API-Version` | No | API version (defaults to latest) |

## Response

### Success Response (200)
```json
{
  "status": "success",
  "data": {
    "id": "string",
    "property1": "string",
    "property2": 123,
    "created_at": "2023-01-01T00:00:00Z",
    "updated_at": "2023-01-01T00:00:00Z"
  },
  "meta": {
    "total": 100,
    "limit": 10,
    "offset": 0
  }
}
```

### Error Responses

#### 400 Bad Request
```json
{
  "status": "error",
  "message": "Invalid request parameters",
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ]
}
```

#### 401 Unauthorized
```json
{
  "status": "error",
  "message": "Authentication required"
}
```

#### 404 Not Found
```json
{
  "status": "error",
  "message": "Resource not found"
}
```

#### 429 Too Many Requests
```json
{
  "status": "error",
  "message": "Rate limit exceeded",
  "retry_after": 60
}
```

#### 500 Internal Server Error
```json
{
  "status": "error",
  "message": "Internal server error"
}
```

## Examples

### Basic Request
```bash
curl -X GET \
  'https://api.example.com/api/v1/endpoint?limit=5' \
  -H 'Authorization: Bearer your_token_here' \
  -H 'Content-Type: application/json'
```

### Request with Body
```bash
curl -X POST \
  'https://api.example.com/api/v1/endpoint' \
  -H 'Authorization: Bearer your_token_here' \
  -H 'Content-Type: application/json' \
  -d '{
    "property1": "example value",
    "property2": 123
  }'
```

### JavaScript Example
```javascript
const response = await fetch('https://api.example.com/api/v1/endpoint', {
  method: 'GET',
  headers: {
    'Authorization': 'Bearer your_token_here',
    'Content-Type': 'application/json'
  }
});

const data = await response.json();
console.log(data);
```

### Python Example
```python
import requests

headers = {
    'Authorization': 'Bearer your_token_here',
    'Content-Type': 'application/json'
}

response = requests.get(
    'https://api.example.com/api/v1/endpoint',
    headers=headers
)

data = response.json()
print(data)
```

## Usage Notes

- This endpoint supports pagination using `limit` and `offset` parameters
- Results are cached for 5 minutes
- Maximum request size is 1MB
- Response times typically under 200ms

## Related Endpoints

- [`GET /api/v1/related-endpoint`](./related-endpoint.md) - Description
- [`POST /api/v1/another-endpoint`](./another-endpoint.md) - Description

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2023-01-01 | Initial release |
| 1.1 | 2023-02-01 | Added pagination support |