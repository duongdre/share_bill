Share Bill helps you manage your finances.

## Getting Started

# 💰 Share Bill - Split Expenses with Friends

A modern, intuitive Flutter app for splitting bills and managing shared expenses with friends, family, and colleagues. Built with Firebase for real-time data sync and featuring a beautiful, user-friendly interface.

## 📱 Features

### 👥 **Person Management**
- Add and manage people in your network
- Upload profile pictures for easy identification
- Add notes and descriptions for each person
- View spending history for each individual

### 🎯 **Group Management**
- Create custom groups for different occasions
- Add multiple people to groups
- Visual group avatars with member preview
- Track group spending and member contributions

### 💳 **Expense Tracking**
- Quick expense entry with amount, description, and date
- Choose who paid and which group it belongs to
- Support for Vietnamese currency (VND) formatting
- Automatic calculation of group totals

### 📊 **Smart Analytics**
- View recent expenses and transactions
- See who owes what in each group
- Track individual spending patterns
- Real-time expense calculations

### 🔐 **Secure Authentication**
- Email/password registration and login
- Secure user data with Firebase Authentication
- Personal data isolation between users
- Automatic session management

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (3.0 or higher)
- **Dart SDK** (3.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Firebase Account** for backend services

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/share_bill.git
   cd share_bill
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
    - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
    - Enable Authentication (Email/Password)
    - Enable Realtime Database
    - Enable Cloud Storage
    - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
    - Place them in respective platform directories

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 How to Use

### 🔐 **Getting Started**
1. **Create Account**: Sign up with your email and password
2. **Login**: Use your credentials to access the app
3. **Home Dashboard**: View your recent activities and quick actions

### 👤 **Managing People**
1. **Add Person**:
    - Tap the "Add Person" button on home screen or person management screen
    - Enter their name (required)
    - Add optional description/notes
    - Upload a profile picture (optional)

2. **View People**:
    - Navigate to "Persons" tab
    - See all people in your network
    - Tap any person to view their details and spending history

### 👥 **Creating Groups**
1. **Add Group**:
    - Tap "Add Group" on home screen or group management screen
    - Enter group name (required)
    - Select members from your people list
    - At least one member is required

2. **Manage Groups**:
    - Navigate to "Groups" tab
    - View all your groups
    - Tap a group to see member details and recent expenses

### 💰 **Adding Expenses**
1. **Quick Add**:
    - Tap the "+" floating action button on any screen
    - Or use "Add Expense" button on home screen

2. **Fill Details**:
    - **Select Group**: Choose which group this expense belongs to
    - **Who Paid**: Select the person who paid from group members
    - **Amount**: Enter the expense amount in VND
    - **Description**: Add what the expense was for
    - **Date & Time**: Set when the expense occurred

3. **Submit**: Tap "Spent money" to save the expense

### 📊 **Viewing Reports**
- **Home Screen**: See recent expenses and group summaries
- **Expense Manager**: View all transactions with filtering options
- **Group Details**: See who paid what in each group
- **Person Details**: View individual spending history

## 🎨 User Interface

### 🏠 **Home Screen**
- **Welcome Message**: Personalized greeting with your name
- **Quick Actions**: Add Person, Add Group, Add Expense buttons
- **Favorite Persons**: Horizontal scroll of your frequent contacts
- **Recent Groups**: Your active groups with spending totals
- **Recent Expenses**: Latest transactions across all groups

### 🔍 **Navigation**
- **Bottom Navigation**: Easy access to Home, Expenses, Groups, and Persons
- **Search Functionality**: Find people, groups, or transactions quickly
- **Pull to Refresh**: Update data by pulling down on lists

### 🎭 **User Experience**
- **Intuitive Icons**: Clear visual indicators for all actions
- **Smooth Animations**: Polished transitions and loading states
- **Error Handling**: Helpful messages when things go wrong
- **Offline Support**: View cached data when internet is unavailable

## 🔧 Technical Features

### 🏗️ **Architecture**
- **Flutter Framework**: Cross-platform mobile development
- **Riverpod**: State management and dependency injection
- **Go Router**: Type-safe navigation and routing
- **Firebase Services**: Backend as a Service (BaaS)

### 🔄 **State Management**
- **Reactive UI**: Automatic updates when data changes
- **Provider Pattern**: Clean separation of business logic
- **Immutable State**: Predictable data flow and debugging

### 🗄️ **Data Storage**
- **Firebase Realtime Database**: Real-time data synchronization
- **Cloud Storage**: Profile picture and file uploads
- **Local Caching**: Improved performance and offline access

### 🔐 **Security**
- **User Authentication**: Secure login and registration
- **Data Isolation**: Users can only access their own data
- **Validation**: Input validation and error prevention
- **Privacy**: No data sharing between different users

## 📱 Supported Platforms

- ✅ **Android** (API level 21+)
- ✅ **iOS** (iOS 11.0+)
- 🔄 **Web** (Coming soon)

## 🌍 Localization

- **Primary Language**: Vietnamese (vi_VN)
- **Currency**: Vietnamese Dong (VND)
- **Date Format**: DD/MM/YYYY
- **Time Format**: 24-hour format

## 🎯 Use Cases

### 👨‍👩‍👧‍👦 **Family Expenses**
- Track household spending
- Split grocery bills
- Manage family outings and activities
- Monitor children's allowances

### 🏠 **Roommates**
- Split rent and utilities
- Share grocery costs
- Manage household supplies
- Track cleaning service expenses

### 👫 **Friends**
- Split restaurant bills
- Share travel expenses
- Group gift purchases
- Event planning costs

### 💼 **Work Colleagues**
- Team lunch expenses
- Conference and travel sharing
- Office supply costs
- Group celebration expenses

## 📞 Support & Feedback

### 🐛 **Found a Bug?**
If you encounter any issues:
1. Check if the issue already exists in our [Issues](https://github.com/yourusername/share_bill/issues)
2. Create a new issue with detailed description
3. Include screenshots if applicable
4. Mention your device and app version

### 💡 **Feature Requests**
Have ideas for improvement? We'd love to hear them!
- Create a feature request issue
- Describe the feature and its benefits
- Explain your use case

### 📧 **Contact**
- **Email**: support@sharebill.app
- **Issues**: [GitHub Issues](https://github.com/yourusername/share_bill/issues)

## 🔄 Future Updates

### 🚀 **Coming Soon**
- **Receipt Scanning**: OCR for automatic expense entry
- **Bill Splitting Calculator**: Smart split by percentage or custom amounts
- **Export Data**: PDF and CSV export options
- **Notifications**: Reminders for pending expenses
- **Multiple Currencies**: Support for different currencies
- **Dark Mode**: Alternative theme option

### 🎯 **Roadmap**
- **Web Version**: Access from any browser
- **Advanced Analytics**: Detailed spending insights and charts
- **Integration**: Connect with banking apps and expense services
- **Social Features**: Share expenses and settle debts
- **Backup & Sync**: Multiple device synchronization

## 📄 Privacy Policy

We take your privacy seriously:
- **Personal Data**: Only collect necessary information for app functionality
- **Data Security**: All data encrypted and securely stored
- **No Sharing**: Your data is never shared with third parties
- **User Control**: You can delete your account and data anytime

## 📋 Terms of Service

By using Share Bill, you agree to:
- Use the app responsibly and honestly
- Respect other users' privacy
- Not attempt to hack or abuse the service
- Follow local laws regarding financial tracking

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing cross-platform framework
- **Firebase**: For reliable backend services
- **Community**: All contributors and users who help improve the app
- **Design Inspiration**: Modern mobile app design principles

## 🙏 Acknowledgments

- **For build / run the project**:
- **Try**: "dart run build_runner build" for code generation then use "flutter run"

- **Try**: "dart run build_runner watch" for code generation
- **Try**: "flutter gen-l10n" for l10n generation constantly

---

**Happy Bill Splitting! 💰✨**

*Make expense sharing effortless with Share Bill - because money matters shouldn't complicate friendships.*