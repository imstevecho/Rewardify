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

## API Endpoints

### Users

* **GET /api/v1/users/:id/points** - Get a user's current points balance

### Rewards

* **GET /api/v1/rewards** - Get a list of available rewards
* **GET /api/v1/rewards/:id** - Get details of a specific reward

### Redemptions

* **POST /api/v1/users/:user_id/redemptions** - Redeem a reward (requires `reward_id` in request body)
* **GET /api/v1/users/:user_id/redemptions** - Get a user's redemption history

## Database Structure

The application has three main models:

1. **User** - Stores user information and points balance
2. **Reward** - Stores information about available rewards
3. **Redemption** - Stores records of reward redemptions

## Testing

Run tests with:
```
bundle exec rspec
```

## Demo Data

The seed file creates a test user with the following details:
* Email: user@example.com
* Points: 600 (after initial redemptions)

It also creates several sample rewards with different point values and a couple of sample redemptions.

## License

This project is licensed under the MIT License.

## Author

[Your Name]
