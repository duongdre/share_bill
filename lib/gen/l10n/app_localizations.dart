import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @menuProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get menuProfile;

  /// No description provided for @menuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get menuHelp;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get menuLogout;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageInfo.
  ///
  /// In en, this message translates to:
  /// **'Language changes will take effect immediately. The app will update all text to your selected language.'**
  String get settingsLanguageInfo;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @addPerson.
  ///
  /// In en, this message translates to:
  /// **'Add Person'**
  String get addPerson;

  /// No description provided for @addGroup.
  ///
  /// In en, this message translates to:
  /// **'Add Group'**
  String get addGroup;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @favoritePersons.
  ///
  /// In en, this message translates to:
  /// **'Favorite Persons'**
  String get favoritePersons;

  /// No description provided for @recentGroups.
  ///
  /// In en, this message translates to:
  /// **'Recent Groups'**
  String get recentGroups;

  /// No description provided for @recentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Recent Expense'**
  String get recentExpenses;

  /// No description provided for @personManager.
  ///
  /// In en, this message translates to:
  /// **'Person Manager'**
  String get personManager;

  /// No description provided for @groupManager.
  ///
  /// In en, this message translates to:
  /// **'Group Manager'**
  String get groupManager;

  /// No description provided for @expenseManager.
  ///
  /// In en, this message translates to:
  /// **'Expense Manager'**
  String get expenseManager;

  /// No description provided for @personDetails.
  ///
  /// In en, this message translates to:
  /// **'Person Details'**
  String get personDetails;

  /// No description provided for @groupDetails.
  ///
  /// In en, this message translates to:
  /// **'Group Details'**
  String get groupDetails;

  /// No description provided for @newExpense.
  ///
  /// In en, this message translates to:
  /// **'New Expense'**
  String get newExpense;

  /// No description provided for @selectGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Group'**
  String get selectGroup;

  /// No description provided for @whoPaid.
  ///
  /// In en, this message translates to:
  /// **'Who paid?'**
  String get whoPaid;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @spentMoney.
  ///
  /// In en, this message translates to:
  /// **'Spent Money'**
  String get spentMoney;

  /// No description provided for @addMemberToGroup.
  ///
  /// In en, this message translates to:
  /// **'Add Member to Group'**
  String get addMemberToGroup;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @createNewGroup.
  ///
  /// In en, this message translates to:
  /// **'Create New Group'**
  String get createNewGroup;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name *'**
  String get groupName;

  /// No description provided for @pleaseEnterAGroupName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a group name'**
  String get pleaseEnterAGroupName;

  /// No description provided for @groupNameMustBeAtLeast2Characters.
  ///
  /// In en, this message translates to:
  /// **'Group name must be at least 2 characters'**
  String get groupNameMustBeAtLeast2Characters;

  /// No description provided for @enterGroupName.
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get enterGroupName;

  /// No description provided for @selectMembers.
  ///
  /// In en, this message translates to:
  /// **'Select Members'**
  String get selectMembers;

  /// No description provided for @noPersonsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No persons available'**
  String get noPersonsAvailable;

  /// No description provided for @addSomePeopleFirstToCreateAGroup.
  ///
  /// In en, this message translates to:
  /// **'Add some people first to create a group'**
  String get addSomePeopleFirstToCreateAGroup;

  /// No description provided for @memberSelected.
  ///
  /// In en, this message translates to:
  /// **'member(s) selected'**
  String get memberSelected;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @pleaseSelectAtLeastOneMember.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one member'**
  String get pleaseSelectAtLeastOneMember;

  /// No description provided for @groupCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Group created successfully'**
  String get groupCreatedSuccessfully;

  /// No description provided for @errorCreatingGroup.
  ///
  /// In en, this message translates to:
  /// **'Error creating group:'**
  String get errorCreatingGroup;

  /// No description provided for @addNewGroupSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Add new group successfully'**
  String get addNewGroupSuccessfully;

  /// No description provided for @updateInformationSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Update information successfully'**
  String get updateInformationSuccessfully;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @persons.
  ///
  /// In en, this message translates to:
  /// **'Persons'**
  String get persons;

  /// No description provided for @pleaseAgreeToTheTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms of Service'**
  String get pleaseAgreeToTheTermsOfService;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @startSplittingBillsWithFriends.
  ///
  /// In en, this message translates to:
  /// **'Start splitting bills with friends'**
  String get startSplittingBillsWithFriends;

  /// No description provided for @pleaseEnterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterYourFullName;

  /// No description provided for @nameMustBeAtLeast2Char.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMustBeAtLeast2Char;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @pleaseEnterAPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get pleaseEnterAPassword;

  /// No description provided for @passwordMustBeAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustBeAtLeast8Characters;

  /// No description provided for @passwordMustContainUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain uppercase, lowercase and number'**
  String get passwordMustContainUppercase;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @createAStrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get createAStrongPassword;

  /// No description provided for @pleaseConfirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmYourPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @reEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterYourPassword;

  /// No description provided for @iAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeToThe;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed:'**
  String get loginFailed;

  /// No description provided for @shareBill.
  ///
  /// In en, this message translates to:
  /// **'Share Bill'**
  String get shareBill;

  /// No description provided for @splitExpensesWithFriends.
  ///
  /// In en, this message translates to:
  /// **'Split expenses with friends'**
  String get splitExpensesWithFriends;

  /// No description provided for @welcomeToShareBill.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Share Bill'**
  String get welcomeToShareBill;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @youAgreeToOurTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our Terms of Service'**
  String get youAgreeToOurTermsOfService;

  /// No description provided for @tapToAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get tapToAddPhoto;

  /// No description provided for @fullNameStar.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get fullNameStar;

  /// No description provided for @pleaseEnterAName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterAName;

  /// No description provided for @nameMustBeAtLeast2Characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMustBeAtLeast2Characters;

  /// No description provided for @enterPersonName.
  ///
  /// In en, this message translates to:
  /// **'Enter person name'**
  String get enterPersonName;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @addANoteAboutPerson.
  ///
  /// In en, this message translates to:
  /// **'Add a note about this person...'**
  String get addANoteAboutPerson;

  /// No description provided for @personAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Person added successfully'**
  String get personAddedSuccessfully;

  /// No description provided for @errorAddingPerson.
  ///
  /// In en, this message translates to:
  /// **'Error adding person: '**
  String get errorAddingPerson;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get featureComingSoon;

  /// No description provided for @pleaseFillInAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get pleaseFillInAllFields;

  /// No description provided for @successfullyAddedExpense.
  ///
  /// In en, this message translates to:
  /// **'Successfully added expense'**
  String get successfullyAddedExpense;

  /// No description provided for @successfullyUpdatedGroupMembers.
  ///
  /// In en, this message translates to:
  /// **'Successfully updated group members'**
  String get successfullyUpdatedGroupMembers;

  /// No description provided for @errorUpdatingMembers.
  ///
  /// In en, this message translates to:
  /// **'Error updating members'**
  String get errorUpdatingMembers;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @dateAndTimeRequired.
  ///
  /// In en, this message translates to:
  /// **'Date and time are required'**
  String get dateAndTimeRequired;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @onB02.
  ///
  /// In en, this message translates to:
  /// **'Split expenses effortlessly'**
  String get onB02;

  /// No description provided for @onB03.
  ///
  /// In en, this message translates to:
  /// **'The easiest way to split bills and manage shared expenses with friends, family, and colleagues.'**
  String get onB03;

  /// No description provided for @onB04.
  ///
  /// In en, this message translates to:
  /// **'Manage Your People'**
  String get onB04;

  /// No description provided for @onB05.
  ///
  /// In en, this message translates to:
  /// **'Keep track of everyone'**
  String get onB05;

  /// No description provided for @onB06.
  ///
  /// In en, this message translates to:
  /// **'Add friends, family, and colleagues to your network. Upload photos and add notes to remember everyone easily.'**
  String get onB06;

  /// No description provided for @onB07.
  ///
  /// In en, this message translates to:
  /// **'Create Groups'**
  String get onB07;

  /// No description provided for @onB08.
  ///
  /// In en, this message translates to:
  /// **'Organize your expenses'**
  String get onB08;

  /// No description provided for @onB09.
  ///
  /// In en, this message translates to:
  /// **'Create groups for different occasions - family dinners, roommate expenses, or work lunches. Add members and start tracking!'**
  String get onB09;

  /// No description provided for @onB10.
  ///
  /// In en, this message translates to:
  /// **'Track Expenses'**
  String get onB10;

  /// No description provided for @onB11.
  ///
  /// In en, this message translates to:
  /// **'Record every expense'**
  String get onB11;

  /// No description provided for @onB12.
  ///
  /// In en, this message translates to:
  /// **'Quickly add expenses with amount, description, and who paid. See real-time calculations and group totals.'**
  String get onB12;

  /// No description provided for @onB13.
  ///
  /// In en, this message translates to:
  /// **'Stay Organized'**
  String get onB13;

  /// No description provided for @onB14.
  ///
  /// In en, this message translates to:
  /// **'View analytics & history'**
  String get onB14;

  /// No description provided for @onB15.
  ///
  /// In en, this message translates to:
  /// **'See who owes what, track spending patterns, and view detailed expense history. Never lose track of shared expenses again!'**
  String get onB15;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @noPersonsYet.
  ///
  /// In en, this message translates to:
  /// **'No Persons Yet'**
  String get noPersonsYet;

  /// No description provided for @startByAddingPeopleToTrackExpenses.
  ///
  /// In en, this message translates to:
  /// **'Start by adding people to track expenses with'**
  String get startByAddingPeopleToTrackExpenses;

  /// No description provided for @noGroupsYet.
  ///
  /// In en, this message translates to:
  /// **'No Groups Yet'**
  String get noGroupsYet;

  /// No description provided for @createGroupsToOrganizeExpenses.
  ///
  /// In en, this message translates to:
  /// **'Create groups to organize your shared expenses'**
  String get createGroupsToOrganizeExpenses;

  /// No description provided for @noBillsYet.
  ///
  /// In en, this message translates to:
  /// **'No Bills Yet'**
  String get noBillsYet;

  /// No description provided for @startTrackingExpensesByAddingBills.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your expenses by adding bills'**
  String get startTrackingExpensesByAddingBills;

  /// No description provided for @addBill.
  ///
  /// In en, this message translates to:
  /// **'Add Bill'**
  String get addBill;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get noResultsFound;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found for'**
  String get noDataFound;

  /// No description provided for @myTransactions.
  ///
  /// In en, this message translates to:
  /// **'My Transactions'**
  String get myTransactions;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @addNewTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add New Transaction'**
  String get addNewTransaction;

  /// No description provided for @transactionPurpose.
  ///
  /// In en, this message translates to:
  /// **'Transaction Purpose'**
  String get transactionPurpose;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get transactionDate;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @pleaseEnterTransactionPurpose.
  ///
  /// In en, this message translates to:
  /// **'Please enter transaction purpose'**
  String get pleaseEnterTransactionPurpose;

  /// No description provided for @purposeMustBeAtLeast2Characters.
  ///
  /// In en, this message translates to:
  /// **'Purpose must be at least 2 characters'**
  String get purposeMustBeAtLeast2Characters;

  /// No description provided for @enterTransactionPurpose.
  ///
  /// In en, this message translates to:
  /// **'Enter transaction purpose'**
  String get enterTransactionPurpose;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get pleaseSelectDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @transactionAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Transaction added successfully'**
  String get transactionAddedSuccessfully;

  /// No description provided for @errorAddingTransaction.
  ///
  /// In en, this message translates to:
  /// **'Error adding transaction'**
  String get errorAddingTransaction;

  /// No description provided for @noTransactionsForThisDay.
  ///
  /// In en, this message translates to:
  /// **'No transactions for this day'**
  String get noTransactionsForThisDay;

  /// No description provided for @tapPlusToAddOne.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add one'**
  String get tapPlusToAddOne;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
