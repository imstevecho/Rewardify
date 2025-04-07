# Rewardify

A straightforward rewards redemption platform built with Rails 8 and React.

## Overview

Rewardify lets users check their reward points, browse available rewards, redeem them, and view their redemption history. Nothing fancy - just a clean, functional points redemption system.

## Tech Stack

* **Backend**: Ruby on Rails 8.0.2 / Ruby 3.2.0
* **Frontend**: React with functional components and hooks
* **Database**: SQLite (simple, no complex hosting needed for this)
* **Testing**: RSpec, FactoryBot

## API Endpoints

We've kept the API REST-friendly while ensuring backward compatibility:

### Users

* **GET /api/v1/users/:id/balance** - Get user's points balance
* **GET /api/v1/users/:id/points** - Legacy endpoint, same function

### Rewards

* **GET /api/v1/rewards** - List all available rewards
* **GET /api/v1/rewards/:id** - Get details for a specific reward
* **GET /api/v1/rewards/premium** - Get premium rewards (costs > 100 points)
* **GET /api/v1/users/:id/rewards/affordable** - Get rewards the user can afford
* **POST /api/v1/rewards/:id/redeem** - Redeem a reward (requires `user_id` in the request body)

### Redemptions

* **GET /api/v1/users/:id/redemptions** - Get user's redemption history
* **POST /api/v1/users/:id/redemptions** - Create a redemption for a user
* **POST /api/v1/redemptions** - Alternative endpoint for creating a redemption

## Enhanced Response Data

The API provides enriched data when appropriate context is provided:

* When a user ID is included with reward requests, you'll receive additional fields:
  * `affordable` - Whether the user can afford this reward
  * `points_needed` - How many more points needed (if not affordable)
  * `message` - User-friendly message about affordability

* Redemption responses include formatted dates and complete reward details

## Getting Started

### Prerequisites

* Ruby 3.2.0
* Rails 8.0.2
* Node.js and npm (recent versions)

### Development Setup

1. Clone the repo:
   ```
   git clone git@github.com:imstevecho/Rewardify.git
   cd rewardify
   ```
   Otherwise you can extract the zip file

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

4. Fire up the Rails server:
   ```bash
   bin/rails server
   ```

5. Visit `http://localhost:3000` - you should see the React frontend

## Development Notes

### Architecture

I've set this up with a more or less standard Rails architecture, with a few extras:

* **Service Objects**: Core business logic is in standalone service classes (like `RewardRedemptionService`) to keep controllers and models thin
* **Serializers**: Custom serializer classes handle JSON formatting so it's consistent across the API
* **Transactional Operations**: Critical operations (like redemption) use transactions to ensure data integrity
* **Model Methods**: Practical helper methods on models like `Reward#affordable_for?` and `User#affordable_rewards`

### Project Decisions

#### Why SQLite?

SQLite is fine for this project. In production, you'd likely swap to Postgres, but this avoids unnecessary complexity.

#### Serialization

I went with simple Ruby classes instead of bringing in serialization gems. The project's needs are straightforward, so I avoided extra dependencies.

#### API Versioning

I put everything in a `/v1` namespace from the start. Makes future versioning simpler when (not if) we need to change things.

#### Error Handling

Error handling is comprehensive but pragmatic - focusing on providing clear messages that the frontend can display.

#### Naming Consistency

API responses use `cost` for reward points in newer endpoints but maintain `points_required` for backward compatibility.

### Resetting Test Data

This is handy when manually testing. Three options are available:

```bash
# Just reset points to 500, keep redemption history
rails rewards:reset

# Reset to 500 points, keep only one coffee voucher redemption
rails rewards:reset_with_default

# Full wipe - 500 points, no redemptions
rails rewards:reset_all
```

## Future Improvements

Things I'd add with more time:

* **Caching**: Add Redis for performance on frequently accessed data
* **Pagination**: For rewards and redemption histories when they grow
* **Request Specs**: More comprehensive API tests beyond controller tests
* **Background Processing**: Move redemption to Sidekiq jobs for better UX during peak loads
* **API Docs**: Add Swagger/OpenAPI for better developer experience

## Testing

Run the tests with:
```bash
bundle exec rspec
```

Coverage includes:
* Model validations
* Controller actions
* Edge cases (insufficient points, unavailable rewards, etc.)
* Serialization

## Demo Data

The seed data creates:
* A test user with 600 points
* Several rewards ranging from coffee (100 pts) to weekend getaways (2000 pts)
* A couple of sample redemptions

## License

MIT Licensed. Use it however you want.
