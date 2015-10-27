# Passes

### [POST] `/api/v1a/passes/redeem`

__Details__
- This endpoint will redeem a pass and return a pkpass file to be added to the user's wallet

__Validation Rules__

__Request Payload__
```json
{
  "id": 1234,
  "capsule_id": 43523
}
```

__Response__ 200 OK
