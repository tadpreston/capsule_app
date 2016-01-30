# Sessions

### [POST] `admin/sessions`

__Details__
- This endpoint will authenticate an admin user. An admin user is a user that exists in the AdminUsers table. The user must be authenticated in order to access the admin functions of PinYada.

__Validation Rules__
- `401 unauthorized` - Either the email was not found or the password was incorrect

__Request Payload__
```json
{
  "session" : {
    "email" : "homersimpson@gmail.com",
    "password" : "supersecret"
  }
}
```
__Response__ 200 OK
```json
{
  "session" : {
    "auth_token" : "abc123def456"
  }
}
```
