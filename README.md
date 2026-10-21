# 💰 Expense Tracker

An intelligent Flutter-based expense tracking application that automatically reads and analyzes bank SMS messages to track your spending and income.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Android-green.svg)
![License](https://img.shields.io/badge/License-Educational-orange.svg)

## 🌟 Features

- 📱 **Automatic SMS Parsing** - Reads bank SMS to extract transaction details
- 📊 **Visual Analytics** - Beautiful charts showing spending patterns
- 💳 **Transaction History** - Detailed list of all debits and credits
- 🔍 **Merchant Detection** - Automatically identifies popular merchants
- 📈 **Trend Analysis** - Track spending over time with interactive graphs
- 🎨 **Modern UI** - Clean, intuitive Material Design interface
- 🔒 **Privacy First** - All data processed locally, no external servers

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0 or higher
- Android device or emulator (API level 21+)

### Installation

1. **Clone the repository** (or navigate to the project directory)
   ```bash
   cd c:/projects_free/freelance/expense_tracker/expense
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Build APK**
   ```bash
   flutter build apk --release
   ```

## 📱 Screenshots & Flow

1. **SMS Permission** → Grant SMS read access
2. **Login** → Enter email and password
3. **Dashboard** → View spending summary with charts
4. **Transactions** → Browse all transactions
5. **Analytics** → Detailed spending analysis
6. **Profile** → User info and settings

## 🎯 How It Works

The app intelligently parses bank SMS messages to:
1. Extract transaction amounts (₹, Rs., INR formats)
2. Classify as debit or credit
3. Identify merchants (Zomato, Amazon, Swiggy, etc.)
4. Calculate totals and trends
5. Display visual analytics

### Supported SMS Formats
```
✅ Rs.500 debited from A/c XX1234 at AMAZON
✅ INR 1000.50 credited to your account
✅ ₹250 spent at SWIGGY on 28-01-2026
```

## 📊 Analytics Features

- **Bar Chart** - Compare debit vs credit amounts
- **Pie Chart** - Spending vs income ratio
- **Line Chart** - 7-day transaction trends
- **Filters** - Weekly and monthly views

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **Charts**: fl_chart ^0.68.0
- **SMS Access**: telephony ^0.2.0
- **Platform**: Android

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── globals.dart                 # Global state
├── data/
│   └── refresh_totals.dart     # SMS parsing logic
├── screens/
│   ├── sms_permission_screen.dart
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── dashboard_home.dart
│   ├── transactions_screen.dart
│   ├── analytics_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── debit_credit_chart.dart  # Bar chart
    ├── debit_credit_pie.dart    # Pie chart
    └── debit_credit_line.dart   # Line chart
```

## 🔐 Permissions

The app requires the following Android permissions:
- `READ_SMS` - To read bank transaction messages
- `RECEIVE_SMS` - To detect new transactions

**Privacy Note**: All SMS data is processed locally on your device. No data is sent to external servers.

## 📖 Documentation

- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed setup instructions and troubleshooting
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Complete feature documentation and architecture

## 🎨 Features Breakdown

### Dashboard
- Total spending overview
- Weekly/Monthly filter
- Debit vs Credit comparison
- Quick access to analytics

### Transactions
- Chronological transaction list
- Color-coded (Red: Debit, Green: Credit)
- Tap for full SMS details
- Merchant identification

### Analytics
- Interactive charts
- Time-based filtering
- Spending trends
- Visual insights

### Profile
- User information
- Account summary
- App information
- Logout option

## 🔧 Configuration

### Customizing Merchant Detection
Edit `lib/screens/transactions_screen.dart`:
```dart
final known = [
  'ZOMATO', 'SWIGGY', 'AMAZON', 'FLIPKART',
  // Add your merchants here
];
```

### Adjusting SMS Limit
Edit `lib/data/refresh_totals.dart`:
```dart
for (var msg in sms.take(50)) {  // Change 50 to desired limit
```

## 🐛 Known Limitations

- Processes last 50 SMS messages only
- Some bank SMS formats may not be recognized
- Android-only (iOS has SMS access restrictions)
- No cloud backup (local storage only)

## 🚀 Future Enhancements

- [ ] Category-wise expense tracking
- [ ] Budget setting and alerts
- [ ] Export to CSV/Excel
- [ ] Cloud backup and sync
- [ ] Recurring transaction detection
- [ ] Bill payment reminders
- [ ] Dark mode support
- [ ] Multi-language support

## 🤝 Contributing

This is a freelance project. For modifications or feature requests, please contact the project owner.

## 📄 License

This project is for educational purposes.

## 🆘 Support

For issues and troubleshooting, refer to:
- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Setup and troubleshooting
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Detailed documentation

## 👨‍💻 Development

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Format Code
```bash
flutter format .
```

---

**Version**: 1.0.0  
**Platform**: Android  
**Last Updated**: January 2026

Made with ❤️ using Flutter
