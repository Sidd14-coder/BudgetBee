# 🚀 Expense Tracker - Setup Guide

## Quick Start

### 1. Prerequisites
Ensure you have the following installed:
- **Flutter SDK** (3.0.0 or higher)
  - Download from: https://flutter.dev/docs/get-started/install
- **Android Studio** or **VS Code** with Flutter extensions
- **Android SDK** (API level 21 or higher)
- **Android Device** or **Emulator**

### 2. Verify Flutter Installation
```bash
flutter doctor
```
Make sure all checkmarks are green (Visual Studio is optional for Android development).

### 3. Install Dependencies
Navigate to the project directory and run:
```bash
cd c:/projects_free/freelance/expense_tracker/expense
flutter pub get
```

### 4. Run the App

#### On Android Emulator
1. Start an Android emulator from Android Studio
2. Run:
```bash
flutter run
```

#### On Physical Android Device
1. Enable Developer Options on your device
2. Enable USB Debugging
3. Connect device via USB
4. Run:
```bash
flutter devices  # Verify device is detected
flutter run
```

### 5. Build APK for Distribution
```bash
# Debug APK
flutter build apk --debug

# Release APK (optimized)
flutter build apk --release
```
The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## 📱 Testing the App

### Test Flow
1. **Launch App** → SMS Permission Screen appears
2. **Grant Permission** → Tap "Allow Permission"
3. **Login** → Enter any email and password (min 6 characters)
4. **Dashboard** → View your expense summary
5. **Transactions** → See parsed SMS transactions
6. **Analytics** → View charts and trends
7. **Profile** → Check user info and logout

### Test Data
The app will automatically parse SMS messages from your device. For testing:
- Use an Android device with bank SMS messages
- Or manually send test SMS in the format:
  ```
  Rs.500 debited from your account at ZOMATO on 28/01/2026
  Rs.1000 credited to your account on 28/01/2026
  ```

## 🔧 Troubleshooting

### Issue: "Unable to find suitable Visual Studio toolchain"
**Solution**: This is expected. The app is designed for Android, not Windows. Use `flutter run` on an Android device/emulator instead.

### Issue: "Permission denied" when accessing SMS
**Solution**: 
1. Go to device Settings → Apps → Expense Tracker → Permissions
2. Enable SMS permission manually
3. Restart the app

### Issue: "No transactions showing"
**Solution**:
1. Ensure SMS permission is granted
2. Check if you have bank SMS messages in your inbox
3. Verify the SMS format matches the parsing patterns
4. Try switching between Weekly and Monthly filters

### Issue: Charts not displaying
**Solution**:
1. Ensure `fl_chart` package is installed: `flutter pub get`
2. Check if there's transaction data available
3. Restart the app

### Issue: Build fails with dependency errors
**Solution**:
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

## 📊 Understanding the Data

### How SMS Parsing Works
The app looks for these patterns in SMS:
- **Amount**: `Rs.`, `INR`, `₹` followed by numbers
- **Debit**: Keywords like "debit", "debited", "spent", "purchase"
- **Credit**: Keywords like "credit", "credited", "received"

### Supported Bank SMS Formats
Examples of supported formats:
```
✅ Rs.500 debited from A/c XX1234 at AMAZON
✅ INR 1000.50 credited to your account
✅ ₹250 spent at SWIGGY on 28-01-2026
✅ Your A/c debited by Rs.100 for PAYTM
```

### Known Merchants
The app recognizes these merchants automatically:
- Food: Zomato, Swiggy
- Shopping: Amazon, Flipkart, DMart, Reliance
- Transport: Uber, Ola
- Services: Paytm, Google, IRCTC, Netflix, Spotify

## 🎯 Usage Tips

### 1. Filter Selection
- **Weekly**: Shows last 7 days of transactions
- **Monthly**: Shows current month's transactions

### 2. Transaction Details
- Tap any transaction card to see the full SMS message
- Color coding: Red = Debit, Green = Credit

### 3. Analytics
- Pie chart shows spending vs income ratio
- Line chart shows 7-day trend
- Use filter to change time range

### 4. Privacy
- All data stays on your device
- No internet connection required
- SMS messages are only read, never modified

## 🔐 Permissions Explained

### READ_SMS
- **Why**: To read bank transaction messages
- **When**: Requested on first launch
- **Data**: Only reads SMS, doesn't send anywhere

### RECEIVE_SMS
- **Why**: To detect new transactions in real-time (future feature)
- **When**: Requested on first launch
- **Data**: Only monitors for bank SMS

## 📱 Device Requirements

### Minimum Requirements
- Android 5.0 (API level 21) or higher
- 50 MB free storage
- SMS messages in inbox

### Recommended
- Android 8.0 or higher
- 100 MB free storage
- Active bank account with SMS alerts

## 🆘 Support

### Common Questions

**Q: Does this app send my SMS data anywhere?**
A: No, all processing happens locally on your device.

**Q: Can I use this on iOS?**
A: Currently, the app is Android-only due to SMS access limitations on iOS.

**Q: Will this delete my SMS messages?**
A: No, the app only reads SMS messages, never modifies or deletes them.

**Q: How many SMS messages does it process?**
A: Currently limited to the last 50 SMS messages for performance.

**Q: Can I add custom merchants?**
A: Not in the current version, but this is a planned feature.

### Getting Help
If you encounter issues:
1. Check the troubleshooting section above
2. Run `flutter doctor` to verify setup
3. Check `flutter analyze` for code issues
4. Review the PROJECT_SUMMARY.md for detailed documentation

## 🔄 Updating the App

To update dependencies:
```bash
flutter pub upgrade
```

To update Flutter SDK:
```bash
flutter upgrade
```

## 📦 Building for Production

### Release Build Steps
1. Update version in `pubspec.yaml`
2. Build release APK:
   ```bash
   flutter build apk --release
   ```
3. Test the release APK on a device
4. Distribute via Google Play Store or direct APK

### App Signing (for Play Store)
1. Generate keystore:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Configure signing in `android/app/build.gradle`
3. Build signed APK:
   ```bash
   flutter build apk --release
   ```

## 🎉 You're All Set!

The app should now be running on your device. Start tracking your expenses automatically!

---

**Need Help?** Check PROJECT_SUMMARY.md for detailed feature documentation.
