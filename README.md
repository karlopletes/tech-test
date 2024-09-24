# Studio Absence API

This application is designed to manage absences and stays in various studios. The core functionality includes detecting gaps between stays in a studio, allowing the user to upload absences via JSON, and updating the stays accordingly.

## Table of Contents
- [Installation](#installation)
- [API Endpoints](#api-endpoints)
- [Testing](#testing)
- [Future Improvements](#future-improvements)

---

## Installation

To set up the application, follow these steps:

1. **Install Dependencies:**

Make sure you have [Bundler](https://bundler.io/) installed, then run:

```bash
bundle install
```

2. **Set Up the Database:**

Configure your database (PostgreSQL) in config/database.yml, then run:

```bash
rails db:create
rails db:migrate
rails db:seed
```

3. **Start the Server:**

Run the Rails server:

```bash
rails server
```


## API Endpoints
1. **List Absences**
```http
GET /api/v1/absences
```
Description: Returns a list of detected absences for all studios.
##### Response:
```json
{
  "absences": [
    {
      "studio_id": 1,
      "studio_name": "Studio1",
      "start_date": "2024-01-06",
      "end_date": "2024-01-10"
    },
    {
      "studio_id": 2,
      "studio_name": "Studio2",
      "start_date": "2024-01-15",
      "end_date": "2024-01-20"
    }
  ]
}
```

2. **Update Absences**
```http
POST /api/v1/absences/update
```
Description: Updates the stays in the database to reflect the absences provided.

##### Request Payload:
```json
{
  "absences": [
    { "studio_id": 1, "start_date": "2024-01-05", "end_date": "2024-01-10" },
    { "studio_id": 2, "start_date": "2024-01-01", "end_date": "2024-01-12" }
  ]
}
```

##### Response:
```json
{
  "message": "Absences processed",
  "results": [
    { "studio": "Studio1", "start_date": "2024-01-05", "end_date": "2024-01-10" },
    { "studio": "Studio2", "start_date": "2024-01-01", "end_date": "2024-01-12" }
  ]
}
```

## Testing
The application is tested using RSpec with fixtures for preloaded data. The tests cover both the controller and the service classes.

**Running the Tests:**

```bash
bundle exec rspec
```

**Coverage report:**

```bash
  $ open coverage/index.html
```

## Future Improvements
* Pagination: Implement pagination for API endpoints
* Authentication: Add authentication for API endpoints
* Upgrade to latest versions of Ruby and Rails
* Create CI/CD pipeline
* Dockerize application
