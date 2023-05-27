# Installation And Usage
## Installation
Clone the repository.

This project is built using Docker. To build and run it at first time:
```
docker-compose build
docker-compose up -d
docker-compose run web bundle exec rake db:setup
```
After the initialization, you can start app by:
```
docker-compose up
```
Application will be available on http://localhost:3000/

Tests are built using RSpec. Run the test suite with:
```
docker-compose run web bundle exec rspec
```

## Run
### New User
To create a new user, you can utilize the following endpoint:

* Endpoint: /api/v1/users
* Method: POST
* Request body:
```json
{ 
  "user":
  {
  "email": "example@nami.ai",
  "password": "dsfd23344"
  }
}
```
The response will include the details of the created user. Here's an example of the response format:
```json
{
  "id": 1,
  "email": "example@nami.ai",
  "created_at": "2023-05-25T12:34:56Z",
  "updated_at": "2023-05-25T12:34:56Z"
}
```
### Authorization 
To authorize your access, please follow these steps:
1. Make a POST request to the following endpoint: /api/auth/login, Include the following request body:
```json
{
  "email": "example@nami.ai",
  "password": "dsfd23344"
}
```
2. If the provided credentials are valid, you will receive a response containing an authentication token:
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2ODQ0MzA3MzJ9.ltjZ3TFtDyOnydfNccP4PEhMwmtrwLGbPFsvBJiBVEA"
}
```
3. To authorize subsequent requests, include the obtained token in the header as the Authorization parameter with the Bearer authentication scheme.
Example header:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjJleHAiOjE2ODQ0MzA3MzJ9.ltjZ3TFtydfNcP4PEhMwmtrwLGbPFsvBJiBVEA
```
Remember to include the token with each authorized request.
### Usage
This application includes two required endpoints for URL encoding and decoding. The endpoints and their expected responses are as follows:
1. URL Encoding Endpoint:
* Endpoint: /api/v1/urls/encode
* Method: POST
* Request Body:
```json
{
  "url": "https://codesubmit.io/library/react"
}
```
* Response:
```json
{
  "shortened": "localhost:3000/23dfwe",
}
```

2. URL Decoding Endpoint:
* Endpoint: /api/v1/urls/decode
* Method: POST
* Request Body:
```json
{
  "shortened": "23dfwe"
}
```
* Response:
```json
{
  "url": "https://codesubmit.io/library/react"
}
```
The response contains the original URL associated with the provided shortened URL.
