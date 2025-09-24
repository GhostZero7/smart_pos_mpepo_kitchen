# Mpepo Kitchen Smart POS System
## CCS3142 Mobile Application Development Assignment

### 🏪 Project Overview
A modern, mobile-based Point of Sale (POS) system developed for **Mpepo Kitchen**, a local restaurant looking to digitize their sales operations. The system features seamless integration with tax authority e-invoicing systems and robust offline capabilities.

### 👥 Group Members
- **Student A**: [Nsowa Febias] - POS Core Features, Tax Calculations, Receipt Generation, Backend Integration
- **Student B**: [Name] - Tax Authority Integration, E-Invoicing API
- **Student C**: [Name] - Backend Server, Reporting System, Database Design

### 🚀 Features Implemented by Student A

#### ✅ Core POS Functionality
- **Product Management**: Beautiful product catalog with categories
- **Shopping Cart**: Add, remove, and update item quantities
- **Real-time Calculations**: Automatic tax (15% VAT) and discount computations
- **Receipt Generation**: Professional digital receipts with order summaries

#### ✅ Technical Implementation
- **Flutter Frontend**: Cross-platform mobile application
- **Python FastAPI Backend**: RESTful API with automatic OpenAPI documentation
- **Offline Support**: Local transaction queue for network failures
- **State Management**: Provider pattern for efficient data flow

#### ✅ User Experience
- **Professional UI/UX**: Material Design with custom theme
- **Responsive Design**: Works on various screen sizes
- **Intuitive Navigation**: Easy-to-use interface for restaurant staff

### 📱 Mobile Application

#### Prerequisites
- Flutter SDK 3.0.0+
- Android Studio / VS Code with Flutter extension
- Android device/emulator (API 21+)

#### Installation & Running
```bash
cd mobile_app

# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Build release APK
flutter build apk --release
```

#### APK Location
- **Debug APK**: `mobile_app/build/app/outputs/flutter-apk/app-debug.apk`
- **Release APK**: `mobile_app/build/app/outputs/flutter-apk/app-release.apk`

### 🐍 Backend Server

#### Prerequisites
- Python 3.8+
- pip package manager

#### Installation & Running
```bash
cd backend_server

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

#### API Documentation
- **Swagger UI**: http://smartposmpepokitchen-production.up.railway.app/docs
- **OpenAPI JSON**: http://smartposmpepokitchen-production.up.railway.app/openapi.json
- **ReDoc**: http://smartposmpepokitchen-production.up.railway.app/redoc

### 🌐 API Endpoints

#### Products
- `GET /products` - Retrieve all products
- `GET /products/{id}` - Get specific product details

#### Health Check
- `GET /` - API status check

### 🗃️ Database Schema

#### Products Table
```sql
CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price REAL NOT NULL,
    image_url TEXT,
    category TEXT,
    is_available BOOLEAN DEFAULT TRUE
);
```

#### Sample Data
```sql
INSERT INTO products (name, description, price, category) VALUES
('Chicken Burger', 'Juicy grilled chicken with fresh veggies', 12.99, 'Burgers'),
('Vegetable Pizza', 'Fresh vegetable pizza with mozzarella', 15.99, 'Pizza'),
('French Fries', 'Crispy golden fries with seasoning', 5.99, 'Sides');
```

### 📊 Project Structure

```
smart_pos_mpepo_kitchen/
├── mobile_app/                 # Flutter application
│   ├── lib/
│   │   ├── models/            # Data models
│   │   ├── providers/         # State management
│   │   ├── screens/           # UI screens
│   │   ├── services/          # API services
│   │   ├── theme/             # App styling
│   │   └── widgets/           # Reusable components
│   ├── android/               # Android specific files
│   └── pubspec.yaml           # Dependencies
├── backend_server/            # Python FastAPI backend
│   ├── main.py               # Main application
│   ├── requirements.txt      # Python dependencies
│   └── database.py           # Database configuration
├── docs/                     # Documentation
│   ├── technical_report.md
│   ├── postman_collection.json
│   └── database_schema.sql
└── README.md
```

### 🛠️ Technical Stack

#### Frontend
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **HTTP Client**: Dio/HTTP
- **PDF Generation**: Printing package

#### Backend
- **Framework**: FastAPI
- **Language**: Python 3.8+
- **API Documentation**: OpenAPI/Swagger
- **Database**: SQLite (development)

### 📋 Testing

#### API Testing with Postman
1. Import `docs/postman_collection.json` into Postman
2. Set base URL to `http://smartposmpepokitchen-production.up.railway.app
3. Test all endpoints

#### Mobile App Testing
- Test on Android device/emulator
- Verify product loading and cart functionality
- Test receipt generation
- Validate tax calculations

### 🚀 Deployment

#### Backend Deployment
The FastAPI server can be deployed to:
- Heroku
- DigitalOcean
- AWS EC2
- Any Python-compatible hosting service

#### Mobile App Deployment
- **Android**: Google Play Store
- **iOS**: Apple App Store (with additional configuration)

### 🐛 Troubleshooting

#### Common Issues
1. **API Connection Failed**: Ensure backend is running on port 8000
2. **Products Not Loading**: Check internet connection and API endpoint
3. **Build Errors**: Run `flutter clean` and `flutter pub get`

#### Network Configuration
- For physical device testing: Use computer's IP address
- Ensure both devices are on same network
- Disable firewall temporarily for testing

### 📞 Support

For technical issues or questions regarding Student A's implementation, contact:
- **Name**: [Nsowa Febias]
- **Student ID**: [202102827]
- **Email**: [Email]

### 📄 License

This project is developed for educational purposes as part of CCS3142 Mobile Application Development course.

### 🎯 Future Enhancements

- [ ] Real-time order synchronization
- [ ] Advanced reporting dashboard
- [ ] Multi-language support
- [ ] Payment gateway integration
- [ ] Inventory management system

---

**Developed with ❤️ for Mpepo Kitchen - Making modern POS solutions accessible to local businesses.**

*Last Updated: September 2024*
