# Expense Tracker App - Project Summary

## 📱 Overview
A Flutter-based expense tracking application that automatically reads bank SMS messages to track debits and credits. The app provides visual analytics and transaction history.

## ✨ Features Implemented

### 1. **SMS Permission Screen** (`sms_permission_screen.dart`)
- Requests SMS read permissions on app launch
- Uses the `telephony` package to access SMS
- Navigates to login screen after permission is granted

### 2. **Login Screen** (`login_screen.dart`)
- Email and password validation
- Form validation with proper error messages
- Stores user information globally
- Clean, modern UI with icons

### 3. **Dashboard** (`dashboard_screen.dart`)
- Bottom navigation with 3 tabs:
  - Dashboard Home
  - Transactions
  - Profile

### 4. **Dashboard Home** (`dashboard_home.dart`)
- **Summary Card**: Shows total spent with filter dropdown (Weekly/Monthly)
- **Bar Chart**: Visual comparison of debit vs credit
- **Summary Cards**: Individual debit and credit amounts
- **Analytics Button**: Navigate to detailed analytics
- Real-time data refresh based on filter selection

### 5. **Transactions Screen** (`transactions_screen.dart`)
- Lists all SMS transactions filtered by date range
- **Merchant Extraction**: Identifies known merchants (Zomato, Swiggy, Amazon, etc.)
- **Transaction Details**: Shows amount, type (debit/credit), date
- **Interactive Cards**: Tap to view full SMS message in bottom sheet
- Color-coded: Red for debits, Green for credits

### 6. **Analytics Screen** (`analytics_screen.dart`)
- **Pie Chart**: Shows spent vs received ratio
- **Line Chart**: 7-day transaction trend
- Filter toggle (Weekly/Monthly)
- Visual representation using `fl_chart` package

### 7. **Profile Screen** (`profile_screen.dart`)
- User information display
- Summary of total debit and credit
- App information and privacy details
- Logout functionality

## 📊 Data Processing

### SMS Parsing (`refresh_totals.dart`)
The app intelligently parses bank SMS messages:

**Amount Extraction:**
- Regex pattern: `(rs\.?|inr|₹)\s?([\d,]+(\.\d+)?)`
- Handles various formats: Rs., INR, ₹
- Removes commas and parses decimal amounts

**Transaction Type Detection:**
- **Debit Keywords**: debit, debited, dr, spent, purchase, withdrawn
- **Credit Keywords**: credit, credited, cr, received

**Date Filtering:**
- Weekly: Last 7 days
- Monthly: Current month only

**Merchant Extraction:**
- Known merchants: Zomato, Swiggy, Amazon, Flipkart, Uber, Ola, Paytm, Google, IRCTC, Netflix, Spotify, Reliance, DMart
- Pattern matching for "SPENT AT", "PAID TO", "AT", "TO"
- Fallback: "BANK TRANSACTION"

## 📈 Charts & Visualizations

### 1. **Bar Chart** (`debit_credit_chart.dart`)
- Side-by-side comparison of debit and credit
- Background bars for scale reference
- Rounded corners for modern look
- Y-axis shows amounts in rupees
- Proper spacing to prevent label clipping

### 2. **Pie Chart** (`debit_credit_pie.dart`)
- Shows proportion of spent vs received
- Displays actual amounts in each section
- Center space for donut chart effect
- Color-coded sections

### 3. **Line Chart** (`debit_credit_line.dart`)
- 7-day trend visualization
- Dual lines for debit and credit
- Date labels on X-axis (DD/MM format)
- Amount labels on Y-axis (in thousands)
- Curved lines with gradient fill
- Dynamic Y-axis intervals based on data range

## 🎨 UI/UX Features

- **Material Design**: Clean, modern interface
- **Color Coding**: 
  - Red for debits/expenses
  - Green for credits/income
  - Blue for primary actions
- **Icons**: Meaningful icons throughout the app
- **Cards**: Elevated cards with shadows for depth
- **Responsive**: Adapts to different screen sizes
- **Loading States**: Shows progress indicators during data refresh

## 🔧 Technical Stack

### Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.8
  telephony: ^0.2.0      # SMS reading
  fl_chart: ^0.68.0      # Charts and graphs
```

### Permissions (Android)
```xml
<uses-permission android:name="android.permission.READ_SMS"/>
<uses-permission android:name="android.permission.RECEIVE_SMS"/>
```

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── globals.dart                       # Global state variables
├── data/
│   └── refresh_totals.dart           # SMS parsing and calculation logic
├── screens/
│   ├── sms_permission_screen.dart    # Initial permission request
│   ├── login_screen.dart             # User login
│   ├── dashboard_screen.dart         # Main navigation
│   ├── dashboard_home.dart           # Home tab with summary
│   ├── transactions_screen.dart      # Transaction list
│   ├── analytics_screen.dart         # Detailed analytics
│   └── profile_screen.dart           # User profile
└── widgets/
    ├── debit_credit_chart.dart       # Bar chart widget
    ├── debit_credit_pie.dart         # Pie chart widget
    └── debit_credit_line.dart        # Line chart widget
```

## 🚀 How to Run

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android device or emulator (API level 21+)

### Steps
1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run on Android:**
   ```bash
   flutter run
   ```

3. **Build APK:**
   ```bash
   flutter build apk --release
   ```

## ⚠️ Important Notes

### SMS Permissions
- The app requires SMS read permissions to function
- On Android 6.0+, runtime permissions are requested
- Users must grant permission for the app to work

### Data Privacy
- All SMS data is processed locally on the device
- No data is sent to external servers
- SMS messages are only read, never modified or deleted

### Limitations
- Currently processes only the last 50 SMS messages
- Merchant detection is limited to known patterns
- Some bank SMS formats may not be recognized
- Requires manual login (no authentication backend)

## 🔮 Future Enhancements

### Potential Features
1. **Category Management**: Categorize expenses (Food, Transport, Shopping, etc.)
2. **Budget Setting**: Set monthly budgets with alerts
3. **Export Data**: Export transactions to CSV/Excel
4. **Cloud Sync**: Backup data to cloud storage
5. **Multiple Accounts**: Support multiple bank accounts
6. **Recurring Transactions**: Identify and track recurring payments
7. **Bill Reminders**: Set reminders for upcoming bills
8. **Advanced Analytics**: 
   - Month-over-month comparison
   - Category-wise spending
   - Spending patterns and insights
9. **Dark Mode**: Theme toggle
10. **Notifications**: Daily/weekly spending summaries

### Technical Improvements
1. **Database**: Use SQLite/Hive for persistent storage
2. **State Management**: Implement Provider/Riverpod/Bloc
3. **Testing**: Add unit and widget tests
4. **CI/CD**: Set up automated builds and testing
5. **Better SMS Parsing**: ML-based transaction extraction
6. **Multi-language Support**: Internationalization (i18n)

## 🐛 Known Issues

1. **Windows Build**: Requires Visual Studio toolchain (app is designed for Android)
2. **SMS Format Variations**: Some bank SMS formats may not be parsed correctly
3. **Date Handling**: Timezone considerations may affect date filtering
4. **Performance**: Large SMS history may slow down the app

## 📝 Testing Checklist

- [x] SMS permission flow
- [x] Login validation
- [x] Dashboard navigation
- [x] Filter switching (Weekly/Monthly)
- [x] Transaction list display
- [x] Transaction detail modal
- [x] Analytics charts rendering
- [x] Profile information display
- [x] Logout functionality
- [ ] Android build and deployment
- [ ] Real device testing with actual bank SMS
- [ ] Edge cases (no SMS, no permissions, etc.)

## 👨‍💻 Development Notes

### Global State
The app uses simple global variables for state management:
- `currentFilter`: FilterType (weekly/monthly)
- `globalTotalSpent`: Total debit amount
- `totalDebit`: Sum of all debits
- `totalCredit`: Sum of all credits
- `loggedInUserEmail`: User's email
- `loggedInUserName`: Extracted from email

### SMS Processing Flow
1. Request SMS permissions
2. Fetch inbox SMS (last 50 messages)
3. Filter by date range (weekly/monthly)
4. Extract amount using regex
5. Classify as debit or credit
6. Calculate totals
7. Update UI

### Chart Data
- Bar Chart: Uses actual debit/credit totals
- Pie Chart: Shows proportion of debit vs credit
- Line Chart: Uses mock day-wise distribution (can be enhanced with real data)

## 📄 License
This project is for educational purposes.

## 🤝 Contributing
This is a freelance project. For modifications or enhancements, please contact the project owner.

---

**Last Updated**: January 2026
**Version**: 1.0.0
**Platform**: Android (Flutter)
