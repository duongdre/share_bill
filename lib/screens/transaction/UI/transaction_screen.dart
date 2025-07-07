import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../gen/colors.gen.dart';
import '../../../models/data_models/transaction.dart';
import '../controller/transaction_provider.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';

import 'dialog_add_transaction.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  static const routeName = 'transactions';
  static const routePath = '/$routeName';

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  bool _isLoading = true;
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(transactionNotifierProvider.notifier).fetchAllTransactions();
    } catch (e) {
      print('Error loading transactions: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ref.watch(transactionNotifierProvider);
    final transactionNotifier = ref.read(transactionNotifierProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: ColorName.background,
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
            onRefresh: _loadTransactions,
            child: Column(
              children: [
                _buildHeader(localizations),
                _buildCalendarHeader(transactionNotifier, localizations),
                _buildCalendar(transactionNotifier),
                _buildSelectedDateInfo(transactionNotifier, localizations),
                Expanded(
                  child: _buildTransactionsList(transactionNotifier, localizations),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: ColorName.white,
        boxShadow: [
          BoxShadow(
            color: ColorName.groupManagementBackground,
            blurRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              size: 25,
              color: ColorName.homeBlackText,
            ),
          ),
          const Spacer(),
          Text(
            localizations.myTransactions ?? 'My Transactions',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorName.homeBlackText,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 25), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(TransactionNotifier notifier, AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: ColorName.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => notifier.goToPreviousMonth(),
            icon: const Icon(Icons.chevron_left, size: 30),
          ),
          GestureDetector(
            onTap: () => _showMonthYearPicker(notifier),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ColorName.blueBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                DateFormat('MMMM yyyy').format(notifier.currentViewingMonth),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => notifier.goToNextMonth(),
            icon: const Icon(Icons.chevron_right, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(TransactionNotifier notifier) {
    final daysInMonth = DateTime(
      notifier.currentViewingMonth.year,
      notifier.currentViewingMonth.month + 1,
      0,
    ).day;

    final firstDayOfMonth = DateTime(
      notifier.currentViewingMonth.year,
      notifier.currentViewingMonth.month,
      1,
    );

    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday, 1 = Monday, etc.
    final daysWithTransactions = notifier.getDaysWithTransactions();

    return Container(
      color: ColorName.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorName.textGray,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          ...List.generate((daysInMonth + firstWeekday + 6) ~/ 7, (weekIndex) {
            return Row(
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 45));
                }

                final dayDate = DateTime(
                  notifier.currentViewingMonth.year,
                  notifier.currentViewingMonth.month,
                  dayNumber,
                );

                final isSelected = dayDate.day == notifier.selectedDate.day &&
                    dayDate.month == notifier.selectedDate.month &&
                    dayDate.year == notifier.selectedDate.year;

                final hasTransactions = daysWithTransactions.contains(dayNumber);
                final isToday = _isToday(dayDate);

                return Expanded(
                  child: GestureDetector(
                    onTap: () => notifier.setSelectedDate(dayDate),
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue
                            : isToday
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isToday && !isSelected
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              dayNumber.toString(),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : isToday
                                    ? Colors.blue
                                    : ColorName.homeBlackText,
                                fontWeight: isSelected || isToday
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (hasTransactions && !isSelected)
                            Positioned(
                              bottom: 4,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isToday ? Colors.blue : Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSelectedDateInfo(TransactionNotifier notifier, AppLocalizations localizations) {
    final selectedTransactions = notifier.getTransactionsForSelectedDate();
    final totalAmount = notifier.getTotalForDate(notifier.selectedDate);

    return Container(
      padding: const EdgeInsets.all(16),
      color: ColorName.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(notifier.selectedDate),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorName.homeBlackText,
                ),
              ),
              if (totalAmount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    currencyFormatter.format(totalAmount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${selectedTransactions.length} ${selectedTransactions.length == 1 ? 'transaction' : 'transactions'}',
            style: const TextStyle(
              fontSize: 14,
              color: ColorName.textGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(TransactionNotifier notifier, AppLocalizations localizations) {
    final selectedTransactions = notifier.getTransactionsForSelectedDate();

    if (selectedTransactions.isEmpty) {
      return Container(
        color: ColorName.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: ColorName.textGray.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                localizations.noTransactionsForThisDay ?? 'No transactions for this day',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorName.textGray.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                localizations.tapPlusToAddOne ?? 'Tap + to add one',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorName.textGray.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: ColorName.background,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: selectedTransactions.length,
        itemBuilder: (context, index) {
          final transaction = selectedTransactions[index];
          return _buildTransactionCard(transaction, localizations);
        },
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction, AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.getPurpose(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorName.homeBlackText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(transaction.createdDateTime),
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorName.textGray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            currencyFormatter.format(transaction.amount),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const DialogAddTransaction(),
    );
  }

  void _showMonthYearPicker(TransactionNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Month & Year'),
        content: SizedBox(
          height: 300,
          width: 300,
          child: YearPicker(
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            selectedDate: notifier.currentViewingMonth,
            onChanged: (date) {
              notifier.setCurrentViewingMonth(date);
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}