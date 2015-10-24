# Capsules

### [POST] `/api/v1a/capsules/forward`

__Details__
- This endpoint will forward a Yada that is referenced in the request payload by making copies of the original yada and sending it to the recipients.
- In the recipients, there must be either a phone_number or an email address

__Validation Rules__

__Request Payload__
```json
{
  "capsule": {
    "id": 123,
    "recipients": [
      {
        "phone_number": "9728326262",
        "email": "homer.simpson@gmail.com",
        "full_name": "Homer Sipmson"
      },
      {
        "phone_number": "8178675309",
        "email": "tommy.tutone@yahoo.com",
        "full_name": "Tommy Tutone"
      }
    ]
  }
}
```

__Response__ 200 OK
```json
{
  "capsules": [
    {
      "id": 423,
      "comment": "Leave me alone!",
      "creator": {
        "id": 3213,
        "full_name": "George Burns",
        "phone_number": "2145439873",
        "email": "gburns@gmail.com",
        "location": null,
        "profile_image": "",
        "created_at": "2015-01-11T04:26:50.010Z",
        "updated_at": "2015-09-23T20:16:38.015Z"
      },
      "recipients": [
        {
          "id": 5432,
          "phone_number": "9728326262",
          "email": "homer.simpson@gmail.com",
          "full_name": "Homer Sipmson",
          "location": null,
          "profile_image": "",
          "created_at": "2015-01-11T04:26:50.010Z",
          "updated_at": "2015-09-23T20:16:38.015Z"
        }
      ],
      "location": null,
      "status": null,
      "thumbnail_path": null,
      "assets": [
        {
          "id": 98792,
          "media_type": "1",
          "resource_path": "https://some_image.png"
        }
      ],
      "start_date": "2015-10-24T13:30:00Z",
      "comments_count": 0,
      "is_read": false,
      "is_unlocked": false,
      "is_forwarded": true,
      "created_at": "2015-01-11T04:26:50.010Z",
      "updated_at": "2015-09-23T20:16:38.015Z"
    },
    {
      "id": 423,
      "comment": "Leave me alone!",
      "creator": {
        "id": 3213,
        "full_name": "George Burns",
        "phone_number": "2145439873",
        "email": "gburns@gmail.com",
        "location": null,
        "profile_image": "",
        "created_at": "2015-01-11T04:26:50.010Z",
        "updated_at": "2015-09-23T20:16:38.015Z"
      },
      "recipients": [
        {
          "id": 5432,
          "phone_number": "8178675309",
          "email": "tommy.tutone@yahoo.com",
          "full_name": "Tommy Tutone",
          "location": null,
          "profile_image": "",
          "created_at": "2015-01-11T04:26:50.010Z",
          "updated_at": "2015-09-23T20:16:38.015Z"
        }
      ],
      "location": null,
      "status": null,
      "thumbnail_path": null,
      "assets": [
        {
          "id": 98792,
          "media_type": "1",
          "resource_path": "https://some_image.png"
        }
      ],
      "start_date": "2015-10-24T13:30:00Z",
      "comments_count": 0,
      "is_read": false,
      "is_unlocked": false,
      "is_forwarded": true,
      "created_at": "2015-01-11T04:26:50.010Z",
      "updated_at": "2015-09-23T20:16:38.015Z"
    }
  ]
}
```
