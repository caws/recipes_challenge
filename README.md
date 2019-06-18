# Recipes Challenge

### The challenge
Write an API to manage a recipe system. 
A cook must have the ability to CRUD and list recipes.
Every single recipe should contain one image to show how it looks like. 
You need to limit access to the endpoints depending on the need. 
Authentication is a must. 

### What this is

A platform for cooks to upload their recipes.

### Prerequisites

```
Rails 5.2.3
Ruby 2.5.1
```

### Getting Started

* Clone the project
* rake:db create db:migrate db:seed
* rake:db create db:migrate db:seed RAILS_ENV=test (if you're planning on running tests)
* bundle install
* rails s

### JWT Authentication

This application uses JWT to safely transmit information for some resources.

####To use this API you must:

1. Obtain an authorization token
2. Send this authorization token within as part of your header for every API request
3. Consume the API

##### Obtain an authorization token

To obtain an authorization, you must send the user credentials
as a POST request to the following endpoint

| Result | Request Type | URL |
| :---: | :---: | :---: |
| Return user and authentication token| POST | /v1/authenticate  |

Example of credentials:
```json
{
	"email":"example@mail.com",
	"password":"123123123"
}
```

##### Send the obtained token in every single one of your API requests

Example of token:
```json
{
    "auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NTIwMTMyMDh9.heFSqXj89Ai3zF142RMYnhcPuAcYRT9Vy3kUau1wgNc"
}
```

### Permissions

On top of the JWT authentication, resources in this applications are protected by permissions
(by using CanCanCan). 

At this point, there are two profiles available: Administrator and Cook. An Administrator is able to 
do everything in the system whereas a Cook is limited to editing their own resources (Recipes and User),
for the most part. 

Below is a table showing what each can do.

| Resource | Administrator | Cook |
| :---: | :---: | :---: 
| Users | All actions | Only their own
| Recipe | All actions | Only their own  

### API Endpoints

Below are the endpoints available. Those that cointain the word protected 
can only be used by users holding a JWT token and who have the right
profile for a given action.

Ex: PATCH request to /v1/users/1

If the JWT token is that of a user with admin rights, then the request is accepted.
If the JWT token is that of a normal user, the system checks if the ID of the user they are
trying to update equals their own id. In case it does, the request is accepted, 
in case they are trying to update someone else's profile, the request is denied.

#### Ingredients

| Result | Request Type | URL | Parameters Expected | Protection
| :---: | :---: | :---: |  :---: | :---: |
| Return most popular ingredients | GET | /v1/ingredients/most_popular | None | None

#### Profiles

| Result | Request Type | URL | Parameters Expected | Protection
| :---: | :---: | :---: |  :---: | :---: |
| Return profiles | GET | /v1/profiles  | None | JWT / Permission
| Create profile | POST | /v1/profiles  | Recipe JSON | JWT / Permission
| Return profile with id = 1 | GET | /v1/profiles/1  | none | JWT / Permission
| Update profile with id = 1 | PATCH/PUT | /v1/profiles/1  | Profile JSON | JWT / Permission
| Delete profile with id = 1 | DELETE | /v1/profiles/1  | none | JWT / Admin

#### Recipes

| Result | Request Type | URL | Parameters Expected | Protection
| :---: | :---: | :---: |  :---: | :---: |
| Return recipes | GET | /v1/recipes  | None | None
| Return searched recipes | GET | v1/recipes/search  | query= | None
| Create recipe | POST | /v1/recipes  | Recipe JSON | JWT
| Return recipe with id = 1 | GET | /v1/recipes/1  | none | JWT / Permission
| Update recipe with id = 1 | PATCH/PUT | /v1/recipes/1  | Recipe JSON | JWT / Permission
| Delete recipe with id = 1 | DELETE | /v1/recipes/1  | none | JWT / Permission

##### Extra 

There's also the possibility of requesting the JSON of a recipe containing one attribute 
with an array of IDs of recipes that share ingredients with the one you're browsing. 

In order to do that, you must add the param related with the value true to the GET /v1/recipes
request.

Ex.:GET /v1/recipes/190?related=true

You can also chain that using nested routes (read more in the Nested routes section 
of this document).

Ex.:GET /v1/users/{:user_id}/recipes/{:recipe_id}?related=true

#### Signup

| Result | Request Type | URL | Parameters Expected | Protection
| :---: | :---: | :---: |  :---: | :---: |
| Create new user | POST | /v1/signup | User details | None

#### Users

| Result | Request Type | URL | Parameters Expected | Protection
| :---: | :---: | :---: |  :---: | :---: |
| Return users | GET | /v1/users  | None | JWT / Permission
| Create users| POST | /v1/users  | User JSON  | JWT / Permission
| Return user with id = 1 | GET | /v1/users/1  | none  | JWT / Permission
| Update user  with id = 1 | PATCH/PUT | /v1/users/1  | User JSON  | JWT / Permission
| Delete user  with id = 1 | DELETE | /v1/users/1  | none  | JWT / Permission

### Nested routes

By using nested routes it's possible to request, for example, the recipes of a given 
user by sending a get request to a route like /v1/users/{:id}/recipes. 
Where {:id} is the id of a given user. Below are the nested routes present in this application. 

#### Users x Recipes

| Result | Request Type | URL | Parameters Expected | Protection
| :---: | :---: | :---: |  :---: | :---: |
| Return recipes for user with id = 1 | GET | /v1/users/1/recipes | None  | None
| Return recipe with id 1 for user with id = 1 | GET | /v1/users/1/recipes/1 | None  | None

#### Profiles x Users

| Result | Request Type | URL | Parameters Expected | Protection
| :---: | :---: | :---: |  :---: | :---: |
| Return users for profile with id = 1 | GET | /v1/profiles/1/users | None | JWT / Permission
| Return user with id 1 for profile with id = 1 | GET | /v1/profiles/1/users/1 | None  | None

### Built With

   * [Active_model_serializers](https://github.com/rails-api/active_model_serializers)
   * [Api-pagination](https://github.com/davidcelis/api-pagination)
   * [BCrypt](https://github.com/codahale/bcrypt-ruby)
   * [CanCanCan](https://github.com/CanCanCommunity/cancancan)
   * [Carrierwave](https://github.com/carrierwaveuploader/carrierwave)
   * [Carrierwave-base64](https://github.com/y9v/carrierwave-base64) 
   * [Cloudinary](https://github.com/cloudinary/cloudinary_gem)
   * [Factory_bot](https://github.com/thoughtbot/factory_bot)
   * [Faker](https://github.com/stympy/faker)
   * [Jwt](https://github.com/jwt/ruby-jwt)
   * [Kaminari](https://github.com/kaminari/kaminari)
   * [Postgres](https://bitbucket.org/ged/ruby-pg/wiki/Home)
   * [Rails](https://github.com/rails/rails)
   * [Rack-cors](https://github.com/cyu/rack-cors)
   * [Rspec-rails](https://github.com/rspec/rspec)
   * [Simple_command](https://github.com/nebulab/simple_command)
   * [Shoulda-callback-matchers](https://github.com/jdliss/shoulda-callback-matchers)
   * [Shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers/)
   
    
