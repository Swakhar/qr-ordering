# QR Ordering System

A modern QR-based restaurant ordering system built with Ruby on Rails. This application allows customers to scan QR codes at their tables to view the menu, place orders, split payments, and track their orders in real-time. Restaurant staff can manage orders through a kitchen display and admin dashboard.

## Features

- 🍽️ **Digital Menu** - Multi-language support (German, English, Turkish, Italian)
- 🛒 **Order Management** - Real-time order tracking with Turbo Streams & WebSockets
- 💳 **Payment Splitting** - Stripe integration for flexible payment options
- 📊 **Analytics Dashboard** - Sales metrics, revenue tracking, and order statistics
- 🎨 **Admin Dashboard** - Beautiful analytics UI with charts and insights
- 📱 **QR Code Generator** - Generate and download QR codes (PNG/SVG) for all tables
- 👨‍🍳 **Kitchen Display** - Live order updates for kitchen staff with real-time broadcasts
- 🏷️ **Allergen Info** - Display allergen information for menu items
- 🌍 **Internationalization** - Full i18n support for 4 languages with language switcher
- 🔔 **AI Upselling** - Rule-based suggestion engine for complementary items
- ⚡ **Real-time Updates** - Action Cable WebSocket broadcasts for instant updates

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

Create a `.env` file in the root directory:

```bash
# Database (if not using default)
DATABASE_URL=postgresql://localhost:5433/app_development

# Stripe (for payment processing)
# Get your test keys from: https://dashboard.stripe.com/test/apikeys
STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here
STRIPE_SECRET_KEY=sk_test_your_key_here
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here

# Application
RAILS_ENV=development
```

**📘 For complete Stripe setup instructions, see [docs/STRIPE_SETUP.md](docs/STRIPE_SETUP.md)**

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
- **Analytics Dashboard:** http://localhost:3007/admin/dashboard  
- **QR Code Manager:** http://localhost:3007/admin/qr_codes
- **Rails Admin:** http://localhost:3007/admin (legacy admin panel)
- **Kitchen Display:** http://localhost:3007/kitchen/gasthaus-bavaria

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

## Key Features Guide

### Analytics Dashboard
Access comprehensive sales analytics at `/admin/dashboard`:
- Total revenue and order statistics
- Average order value tracking
- Daily revenue charts
- Order status breakdowns
- Top selling items
- Recent orders overview
- Date range filtering

### QR Code Management
Generate and manage QR codes at `/admin/qr_codes`:
- Visual QR code preview for all tables
- Download individual QR codes (PNG or SVG)
- Bulk download all QR codes as ZIP
- Print-ready formats with guidelines
- Direct menu link testing

### Multi-Language Support
The system supports 4 languages: German (DE), English (EN), Turkish (TR), Italian (IT)
- Default language: German
- Switch languages by adding `?locale=en` to any URL
- Language preference persists in session
- Use the language switcher component: `<%= render 'shared/language_switcher' %>`

### Real-Time Kitchen Display
WebSocket-powered live updates:
- New orders appear automatically
- Status updates broadcast to all connected clients
- Works for authenticated and unauthenticated users
- Turbo Streams for instant UI updates

### Stripe Payment Integration
Secure payment processing with split payment support:
- Multiple payment methods via Stripe
- Split payments for group orders
- Real-time webhook processing
- Automatic order status updates
- Test mode for development
- **Setup Guide:** [docs/STRIPE_SETUP.md](docs/STRIPE_SETUP.md)

**Quick Start:**
```bash
# Set your Stripe test keys in .env
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Test locally with Stripe CLI
stripe listen --forward-to localhost:3007/stripe/webhook
```

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
- [x] Step 3: Customer QR menu view
- [x] Step 4: AI upsell suggestions (rule-based)
- [x] Step 5: Payment splitting
- [x] Step 6: Kitchen display with Turbo Streams
- [x] Step 7: Admin dashboard enhancements
- [x] Step 8: i18n implementation (DE, EN, TR, IT)
- [x] Step 9: QR code generation
- [x] Step 10: Stripe configuration
- [x] Step 11: Analytics dashboard
- [x] Step 12: UI/UX polish

## UI/UX Enhancements

The application features a modern, polished user interface with:

### Visual Design
- **Gradient Backgrounds**: Beautiful gradients with animated blob effects
- **Glass Morphism**: Modern frosted glass design elements
- **Smooth Animations**: Fade-in, slide, scale, and custom effects
- **Hover Effects**: Interactive feedback on all clickable elements
- **Responsive Design**: Optimized for mobile, tablet, and desktop
- **Modern Typography**: Clean, readable font hierarchy

### Animations & Effects
- **15+ Custom Animations**: Including fade, slide, pulse, bounce, blob
- **Staggered Entrance**: Elements animate in sequence
- **Loading States**: Shimmer effects and spinners
- **Toast Notifications**: Slide-in success messages
- **Ripple Effects**: Material Design-inspired interactions
- **Glow Effects**: Subtle shadows and highlights

### Components
- **Modern Cards**: Shadow elevations with hover effects
- **Gradient Buttons**: Eye-catching CTAs with scale animations
- **Status Badges**: Color-coded with proper semantics
- **Glass Cards**: Backdrop blur for premium feel
- **Custom Scrollbars**: Styled for consistent experience

### Accessibility
- **WCAG AA Compliant**: Proper color contrast ratios
- **Keyboard Navigation**: Full keyboard support
- **Focus Indicators**: Visible focus rings on all interactive elements
- **Semantic HTML**: Proper heading hierarchy and ARIA labels
- **Screen Reader Friendly**: Descriptive alt text and labels

### Performance
- **System Fonts**: No web font loading delay
- **CSS Animations**: Hardware-accelerated transforms
- **Lazy Loading**: Images load on demand
- **Optimized Assets**: Minimal CSS/JS footprint
- **60fps Animations**: Smooth on all modern devices

For complete UI/UX documentation, see [docs/UI_UX_GUIDE.md](docs/UI_UX_GUIDE.md)

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
