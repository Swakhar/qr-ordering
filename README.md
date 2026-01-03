# QR Ordering System

A modern QR-based restaurant ordering system built with Ruby on Rails. This application allows customers to scan QR codes at their tables to view the menu, place orders, split payments, and track their orders in real-time. Restaurant staff can manage orders through a kitchen display and admin dashboard.

## Features

- 🍽️ **Digital Menu** - Multi-language support (German, English, Turkish, Italian)
- 🛒 **Order Management** - Real-time order tracking with Turbo Streams
- 💳 **Payment Splitting** - Stripe integration for flexible payment options
- 📊 **Admin Dashboard** - Rails Admin panel for restaurant management
- 👨‍🍳 **Kitchen Display** - Live order updates for kitchen staff
- 🏷️ **Allergen Info** - Display allergen information for menu items
- 📱 **QR Codes** - Generate unique QR codes for each table
- 🔔 **AI Upselling** - Rule-based suggestion engine for complementary items

## Tech Stack

- **Ruby:** 3.3.4
- **Rails:** 8.0.2.1
- **Database:** PostgreSQL 14+
- **Asset Pipeline:** Propshaft
- **CSS Framework:** Tailwind CSS + dartsass-rails
- **JavaScript:** Hotwire (Turbo + Stimulus) + Importmap
- **Background Jobs:** GoodJob
- **Authentication:** Devise
- **Admin Panel:** Rails Admin
- **Payments:** Stripe
- **QR Generation:** rqrcode

## System Requirements

- Ruby 3.3.4 or higher
- PostgreSQL 14 or higher
- Node.js (for asset processing)
- Bundler 2.0+

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd qr-ordering
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Database Setup

Create and configure your database:

```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Load seed data (creates demo restaurant with menu items)
rails db:seed
```

### 4. Environment Variables

Create a `.env` file in the root directory (optional for development):

```bash
# Database (if not using default)
DATABASE_URL=postgresql://localhost:5433/app_development

# Stripe (for payment processing)
STRIPE_PUBLISHABLE_KEY=your_key_here
STRIPE_SECRET_KEY=your_secret_here

# Application
RAILS_ENV=development
```

### 5. Start the Development Server

```bash
# Start Rails server and CSS watchers
bin/dev

# Or start components separately:
# Rails server (port 3007)
rails s -p 3007

# Tailwind CSS watcher
rails tailwindcss:watch

# DartSass watcher
rails dartsass:watch
```

The application will be available at:
- **Customer Menu:** http://localhost:3007/r/gasthaus-bavaria/t/TBL001
- **Admin Dashboard:** http://localhost:3007/admin
- **Kitchen Display:** http://localhost:3007/kitchen

## Default Credentials

After running `db:seed`, you can log in to the admin panel with:

- **Email:** admin@restaurant.com
- **Password:** password123

## Demo Data

The seed file creates:
- 1 Restaurant (Gasthaus Bavaria - German cuisine)
- 8 Tables (TBL001 - TBL008)
- 5 Menu Categories (Appetizers, Mains, Sides, Drinks, Desserts)
- 19 Menu Items with German/English descriptions
- 1 Admin staff account

## Project Structure

```
app/
├── controllers/      # Application controllers
├── models/          # ActiveRecord models
├── views/           # ERB templates
├── javascript/      # Stimulus controllers
└── assets/          # Stylesheets and images

config/
├── initializers/    # Rails Admin, Devise, etc.
├── routes.rb        # Application routes
└── database.yml     # Database configuration

db/
├── migrate/         # Database migrations
└── seeds.rb         # Seed data
```

## Development Roadmap

- [x] Step 1: Model associations and validations
- [x] Step 2: Seed data with German restaurant menu
- [ ] Step 3: Customer QR menu view (in progress)
- [ ] Step 4: AI upsell suggestions
- [ ] Step 5: Payment splitting
- [ ] Step 6: Kitchen display with Turbo Streams
- [ ] Step 7: Admin dashboard enhancements
- [ ] Step 8: i18n implementation (DE, EN, TR, IT)
- [ ] Step 9: QR code generation
- [ ] Step 10: Stripe configuration
- [ ] Step 11: Analytics dashboard
- [ ] Step 12: UI/UX polish

## Running Tests

```bash
# Run all tests
rails test

# Run system tests
rails test:system
```

## Deployment

The application is configured for deployment with Kamal. See `config/deploy.yml` for deployment configuration.

```bash
# Deploy to production
kamal deploy
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests
4. Submit a pull request

## License

This project is proprietary software.

## Support

For questions or issues, please contact the development team.
