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
      "name": "Cool Campaign"
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
    "assets": [
      {
        "id": 12,
        "resource_path": "secureurl"
      },
      {
        "id": 13,
        "resource_path": "secureurl"
      },
      {
        "id": 14,
        "resource_path": "secureurl"
      },
      {
        "id": 15,
        "resource_path": "secureurl"
      }
    ],
    "message_from": "this is a message from",
    "message_to": "this is a message to"
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
    + Budget is required

__Request Payload__
```json
{
  "campaign" : {
    "name": "Cool Campaign",
    "budget": 1000.00,
    "assets": [
      {
        "id": 12,
        "resource_path": "urlforfromclient",
        "media_type": "1",
        "metadata": { "image_type": 1 }
      },
      {
        "id": 13,
        "resource_path": "urlforfromuser",
        "media_type": "1",
        "metadata": { "image_type": 2 }
      },
      {
        "id": 14,
        "resource_path": "urlforkeep",
        "media_type": "1",
        "metadata": { "image_type": 3 }
      },
      {
        "id": 15,
        "resource_path": "urlforforward",
        "media_type": "1",
        "metadata": { "image_type": 4 }
      },
      {
        "id": 16,
        "resource_path": "urlforended",
        "media_type": "1",
        "metadata": { "image_type": 5 }
      }
    ],
    "message_from": "this is a message from",
    "message_to": "this is a message to"
  }
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
    "assets": [
      {
        "id": 12,
        "resource_path": "urlforfromclient",
        "metadata": { "image_type": 1 }
      },
      {
        "id": 13,
        "resource_path": "urlforfromuser",
        "metadata": { "image_type": 2 }
      },
      {
        "id": 14,
        "resource_path": "urlforkeep",
        "metadata": { "image_type": 3 }
      },
      {
        "id": 15,
        "resource_path": "urlforforward",
        "metadata": { "image_type": 4 }
      },
      {
        "id": 16,
        "resource_path": "urlforended",
        "metadata": { "image_type": 5 }
      }
    ],
    "message_from": "this is a message from",
    "message_to": "this is a message to"
  }
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
