# Rewardify - Rewards Redemption Application

Rewardify is a web application that allows users to view their reward points balance, browse available rewards, redeem points for rewards, and view their redemption history.

## Technology Stack

* **Backend**: Ruby on Rails 8.0.2 with Ruby 3.2.0
* **Frontend**: React.js with functional components and hooks
* **Database**: SQLite
* **Testing**: RSpec, FactoryBot

## Features

* View current reward points balance
* Browse available rewards
* Redeem rewards using points
* View redemption history
* RESTful API for all functionality

## API Endpoints

The application provides the following RESTful API endpoints:

### Users

* **GET /api/v1/users/:id/balance** - Get a user's current points balance

### Rewards

* **GET /api/v1/rewards** - Get a list of available rewards
* **GET /api/v1/rewards/:id** - Get details of a specific reward
* **POST /api/v1/rewards/:id/redeem** - Redeem a reward (requires `user_id` in request body)

### Redemptions

* **GET /api/v1/users/:id/redemptions** - Get a user's redemption history

## Installation

### Prerequisites

* Ruby 3.2.0
* Rails 8.0.2
* Node.js and npm

### Setup

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/rewardify.git
   cd rewardify
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Set up the database:
   ```
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

4. Start the Rails server:
   ```
   bin/rails server
   ```

5. Visit `http://localhost:3000` in your browser

## Design Decisions & Architecture

The application follows a standard Rails MVC architecture with some additional patterns:

* **Service Objects**: Business logic is isolated in service classes to keep controllers and models clean and focused on their primary responsibilities.
* **Serializers**: Response formatting is separated into serializer classes to ensure consistent JSON structures.
* **Transactional Operations**: All critical operations (like redeeming rewards) are performed within transactions to ensure data integrity.

## Assumptions

* Users are pre-authenticated (authentication is outside the scope of this implementation)
* Points are a non-negative integer value
* Users cannot redeem rewards if they don't have sufficient points
* Rewards can be marked as unavailable and cannot be redeemed in that state

## Tradeoffs

* **SQLite vs PostgreSQL**: Used SQLite for simplicity and ease of setup, though a production app would likely use PostgreSQL for better concurrency and feature support.
* **Simple Serialization**: Used custom serializers rather than introducing dependencies like jsonapi-serializer to keep the codebase lean.
* **Service Layer**: Added a service layer for business logic even though it adds some complexity because it improves maintainability and testability.

## Future Improvements

Given more time, the following improvements could be implemented:

* **Caching**: Add Redis caching for frequently accessed data like available rewards and user point balances
* **API Versioning**: Implement formal versioning in the API for better future compatibility
* **Pagination**: Add pagination to lists of rewards and redemption history
* **Enhanced Error Handling**: Add more specific error types and status codes for various failure scenarios
* **Performance Optimization**: Optimize redemption queries with joining and indexing
* **Background Jobs**: Process redemptions asynchronously for better user experience during peak loads
* **Swagger/OpenAPI Documentation**: Generate API documentation using OpenAPI specifications

## Testing

Run tests with:
```
bundle exec rspec
```

The test suite includes:
* Model validations and associations
* Service layer business logic
* Controller request/response cycles
* Edge cases such as insufficient points and unavailable rewards

## Demo Data

The seed file creates a test user with the following details:
* Email: user@example.com
* Points: 600 (after initial redemptions)

It also creates several sample rewards with different point values and a couple of sample redemptions.

## License

This project is licensed under the MIT License.

## Author

[Your Name]
