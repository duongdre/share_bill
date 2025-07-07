import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/data_models/transaction.dart';
import '../../../services/firebase_services/user_service.dart';

part 'transaction_provider.g.dart';

@riverpod
class TransactionNotifier extends _$TransactionNotifier {
  List<Transaction> allTransactions = [];
  Map<dynamic, dynamic> allTransactionMapping = {};

  // Current selected date for viewing transactions
  DateTime selectedDate = DateTime.now();

  // Current viewing month/year
  DateTime currentViewingMonth = DateTime.now();

  @override
  int build() {
    state = 0;
    return state;
  }

  void setSelectedDate(DateTime date) {
    selectedDate = DateTime(date.year, date.month, date.day);
    state = state + 1;
  }

  void setCurrentViewingMonth(DateTime month) {
    currentViewingMonth = DateTime(month.year, month.month, 1);
    state = state + 1;
  }

  void goToNextMonth() {
    currentViewingMonth = DateTime(currentViewingMonth.year, currentViewingMonth.month + 1, 1);
    state = state + 1;
  }

  void goToPreviousMonth() {
    currentViewingMonth = DateTime(currentViewingMonth.year, currentViewingMonth.month - 1, 1);
    state = state + 1;
  }

  List<Transaction> getTransactionsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;

    return allTransactions.where((transaction) {
      return transaction.transactionDate >= startOfDay && transaction.transactionDate <= endOfDay;
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Transaction> getTransactionsForSelectedDate() {
    return getTransactionsForDate(selectedDate);
  }

  // Get all transactions for the current viewing month
  List<Transaction> getTransactionsForMonth(DateTime month) {
    final startOfMonth = DateTime(month.year, month.month, 1).millisecondsSinceEpoch;
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59).millisecondsSinceEpoch;

    return allTransactions.where((transaction) {
      return transaction.transactionDate >= startOfMonth && transaction.transactionDate <= endOfMonth;
    }).toList();
  }

  // Get days that have transactions in current viewing month
  Set<int> getDaysWithTransactions() {
    final monthTransactions = getTransactionsForMonth(currentViewingMonth);
    return monthTransactions.map((transaction) {
      return DateTime.fromMillisecondsSinceEpoch(transaction.transactionDate).day;
    }).toSet();
  }

  // Get total amount spent for a specific date
  int getTotalForDate(DateTime date) {
    final dayTransactions = getTransactionsForDate(date);
    return dayTransactions.fold(0, (sum, transaction) => sum + transaction.amount);
  }

  // Get total amount spent for current viewing month
  int getTotalForMonth() {
    final monthTransactions = getTransactionsForMonth(currentViewingMonth);
    return monthTransactions.fold(0, (sum, transaction) => sum + transaction.amount);
  }

  Future<void> fetchAllTransactions() async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      print('USER ID: ${UserService.getCurrentUserId()}');
      final databaseReference = UserService.getUserCollectionRef('transactions');
      final snapshot = await databaseReference.get().timeout(const Duration(seconds: 30));

      allTransactions.clear();
      allTransactionMapping.clear();

      if (snapshot.exists) {
        for (final data in snapshot.children) {
          final transaction = Transaction.fromMap(data.value as Map);
          print('✅ Successfully parsed transaction: ${transaction.uid} - Amount: ${transaction.amount}');
          allTransactions.add(transaction);
        }
        allTransactionMapping = snapshot.value as Map<dynamic, dynamic>;
      } else {
        print('📭 No transactions data available.');
      }

      // Sort transactions by creation date (newest first)
      allTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (error) {
      print('📭 Error fetching transactions: $error');
    }
    print('📊 Final transactions count: ${allTransactions.length}');
    state = state + 1;
  }

  Future<void> addNewTransaction(Transaction newTransaction) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      final databaseReference = UserService.getUserCollectionRef('transactions');
      await databaseReference.child(newTransaction.uid).set(newTransaction.toJson());

      // Refresh the list
      await fetchAllTransactions();
      state = state + 1;
    } catch (e) {
      print("Error adding new transaction: $e");
    }
  }

  Future<void> updateTransaction(String transactionId, Map<String, dynamic> updates) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      final databaseReference = UserService.getUserCollectionRef('transactions');
      await databaseReference.child(transactionId).update(updates);

      // Refresh the list
      await fetchAllTransactions();
      state = state + 1;
    } catch (e) {
      print("Error updating transaction: $e");
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      final databaseReference = UserService.getUserCollectionRef('transactions');
      await databaseReference.child(transactionId).remove();

      // Refresh the list
      await fetchAllTransactions();
      state = state + 1;
    } catch (e) {
      print("Error deleting transaction: $e");
    }
  }

  Transaction? findTransactionWithUid(String transactionId) {
    try {
      return Transaction.fromMap(allTransactionMapping[transactionId] as Map);
    } catch (e) {
      return null;
    }
  }
}