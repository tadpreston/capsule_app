# Clients

### [GET] `admin/clients`

__Validation Rules__
 - `401 Not Authorized` if client tries to access `admin/clients` and has not been authorized

__Response__ 200 OK

```json
{
  "clients" : [
    {
      "id" : 42,
      "name" : "Cool People",
      "email" : "cool@people.com",
      "profile_image" : "http://somefancyurl.com"
    }
  ]
}
```

### [GET] `admin/clients/:client_id`

__Validation Rules__
 - `401 Not Authorized` if client tries to access `admin/clients` and has not been authorized

__Response__ 200 OK

```json
{
  "client" : {
    "id" : 42,
    "name" : "Cool People",
    "email" : "cool@people.com",
    "profile_image" : "http://somefancyurl.com"
  }
}
```

### [POST] `admin/clients`

 __Validation Rules__
  - `401 Not Authorized` if client tries to access `admin/clients` and has not been authorized
  - `400 Bad Request` if client fails to provide required fields and valid values
    + Name is required
    + Email is required and must be unique
    + Password is required
    + Password must match password_confirmation

 __Request Payload__
 ```json
 {
   "client": {
     "name": "Starbucks",
     "email": "starbucks@gmail.com",
     "password": "supersecret",
     "password_confirmation": "supersecret"
   }
 }
 ```

 __Response__ 201 Created
 ```json
