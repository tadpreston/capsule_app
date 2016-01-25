# Campaigns

### [GET] `admin/campaigns`

__Validation Rules__
 - `401 Not Authorized` if client tries to access `admin/campaign` and has not been authorized

__Response__ 200 OK

```json
{
  "campaigns" : [
    {
      "id" : 42,
      "name" : "Cool Campaign"
    }
  ]
}
```

### [GET] `admin/campaigns/:campaign_id`

__Validation Rules__
 - `401 Not Authorized` if client tries to access `admin/campaigns` and has not been authorized

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

### [POST] `admin/campaigns`

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
        "media_type": "1"
      },
      {
        "id": 13,
        "resource_path": "urlforfromuser",
        "media_type": "1"
      },
      {
        "id": 14,
        "resource_path": "urlforkeep",
        "media_type": "1"
      },
      {
        "id": 15,
        "resource_path": "urlforforward",
        "media_type": "1"
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
  "client" : {
    "id" : 42,
    "name" : "Cool People",
    "email" : "cool@people.com",
    "profile_image" : "http://somefancyurl.com"
  }
}
```

