# Categories

### [GET] `api/v1a/categories`

__Response__ 200 OK
```json
{
  "categories": [
    {
      "id": 12,
      "name": "Birthday"
    },
    {
      "id": 13,
      "name": "Good Morning"
    }
  ]
}
```

### [GET] `api/v1a/categories/:category_id`

__Validation Rules__
- `404 Not Found` if the client access a `category_id` that does not exist

__Response__ 200 OK
```json
{
  "id": 42,
  "name": "Get Well"
}
```
