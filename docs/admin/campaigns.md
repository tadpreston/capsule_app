# Campaigns

__Details__
 - Campaigns is associated and needs to be referenced withing the context of a client.

### [GET] `admin/clients/:client_id/campaigns`

__Validation Rules__
 - `401 Not Authorized` if client tries to access `admin/campaign` and has not been authorized

__Response__ 200 OK

```json
{
  "campaigns" : [
     {
      "id": 42,
      "name": "Cool Campaign",
      "budget": 1000.00,
      "client_message": "Hello from the client...",
      "user_message": "Hello from the user...",
      "image_from_client": "somes3url",
      "image_from_user": "somes3url",
      "image_keep": "somes3url",
      "image_forward": "somes3url",
      "image_expired": "somes3url",
      "updated_at": "2015-01-31 10:30:00Z",
      "created_at": "2015-01-31 10:30:00Z"
    }
  ]
}
```

### [GET] `admin/clients/:client_id/campaigns/:campaign_id`

__Validation Rules__
 - `401 Not Authorized` if client tries to access `admin/campaigns` and has not been authorized
 - `404 Not Found` if `campaign_id` does not belong to the client

__Response__ 200 OK

```json
{
  "campaign" : {
    "id": 42,
    "name": "Cool Campaign",
    "budget": 1000.00,
    "client_message": "Hello from the client...",
    "user_message": "Hello from the user...",
    "image_from_client": "somes3url",
    "image_from_user": "somes3url",
    "image_keep": "somes3url",
    "image_forward": "somes3url",
    "image_expired": "somes3url",
    "updated_at": "2015-01-31 10:30:00Z",
    "created_at": "2015-01-31 10:30:00Z"
  }
}
```

### [POST] `admin/client/:client_id/campaigns`

__Details__
  - The images for the campaign will be passed in through an assets array with the s3 location of the asset.
  - The order in the array will be used to determine what that asset is used for.

__Validation Rules__
  - `401 Not Authorized` if client tries to access `admin/clients` and has not been authorized
  - `400 Bad Request` if client fails to provide required fields and valid values
    + Name is required
    + Budget is required and must be a number

__Request Payload__
```json
{
  "campaign" : {
    "name": "Cool Campaign",
    "budget": 1000.00,
    "client_message": "Hello from the client...",
    "user_message": "Hello from the user...",
    "image_from_client": "somes3url",
    "image_from_user": "somes3url",
    "image_keep": "somes3url",
    "image_forward": "somes3url",
    "image_expired": "somes3url"
  }
}
```

__Response__ 201 Created
```json
{
  "campaign" : {
    "id": 42,
    "name": "Cool Campaign",
    "budget": 1000.00,
    "client_message": "Hello from the client...",
    "user_message": "Hello from the user...",
    "image_from_client": "somes3url",
    "image_from_user": "somes3url",
    "image_keep": "somes3url",
    "image_forward": "somes3url",
    "image_expired": "somes3url",
    "updated_at": "2015-01-31 10:30:00Z",
    "created_at": "2015-01-31 10:30:00Z"
  }
}
```

### [PATCH] `admin/clients/:client_id/campaign/:campaign_id`

__Details__
  - Anyone of the payload attributes can be passed in to be updated.
  - If updating the password, the password and the confirmation must be passed in.

__Validation Rules__
  - `401 Not Authorized` if client tries to access `admin/clients/:client_id/campaign` and has not been authorized
  - `404 Not Found` if the campaign_id provided does not belong to the client
  - `400 Bad Request` if client fails to provide required fields and valid values
    + Name is required
    + Budget is required and must be a number

__Request Payload__
```json
{
  "campaign" : {
    "name": "Cool Campaign",
    "budget": 1000.00,
    "client_message": "Hello from the client...",
    "user_message": "Hello from the user...",
    "image_from_client": "somes3url",
    "image_from_user": "somes3url",
    "image_keep": "somes3url",
    "image_forward": "somes3url",
    "image_expired": "somes3url"
  }
}
```

__Response__ 201 Created
```json
{
  "campaign" : {
    "id": 42,
    "name": "Cool Campaign",
    "budget": 1000.00,
    "client_message": "Hello from the client...",
    "user_message": "Hello from the user...",
    "image_from_client": "somes3url",
    "image_from_user": "somes3url",
    "image_keep": "somes3url",
    "image_forward": "somes3url",
    "image_expired": "somes3url",
    "updated_at": "2015-01-31 10:30:00Z",
    "created_at": "2015-01-31 10:30:00Z"
  }
}
```

### [DELETE] `/api/client/:client_id/campaign/:campaign_id`

__Validation Rules__
  - `401 Not Authorized` if client tries to access `admin/clients/:client_id/campaigns` and has not been authorized
  - `404 Not Found` if the campaign_id provided does not belong to the client

__Response__ 200 Ok
```json
{
  "status": "Deleted" 
}
```


### [POST] `admin/campaigns/:campaign_id/pinit`

__Details__
  - This endpoint created Yadas for a campaign.

__Validation Rules__
  - `401 Not Authorized` if client tries to access `admin/clients` and has not been authorized
  - `400 Bad Request` if client fails to provide required fields and valid values

__Request Payload__
```json
{
  "pinit": {
    "unlock_at": "2016-02-04T07:30:00Z",
    "user_ids" : [201, 10, 752, 3098]
  }
}
```

### [GET] `admin/campaigns/user_search?q=somestring`

__Details__
  - Search for a user by email or partial email address

__Response__ 200 OK
```json
{
  "users": [
    {
      "id": 42,
      "name": "Fred Flintstone",
      "email": "fred@flintstones.com",
      "phone_number": "9727869907"
    }
  ]
}
```
