import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';
import '../../../gen/colors.gen.dart';
import '../../../models/data_models/transaction.dart';
import '../controller/transaction_provider.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';

class DialogAddTransaction extends ConsumerStatefulWidget {
  const DialogAddTransaction({super.key});

  @override
  ConsumerState<DialogAddTransaction> createState() => _DialogAddTransactionState();
}

class _DialogAddTransactionState extends ConsumerState<DialogAddTransaction>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  final TextEditingController purposeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  DateTime selectedDate = DateTime.now();
  int currentAmount = 0;
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();

    // Initialize date with current selected date from transaction provider
    selectedDate = ref.read(transactionNotifierProvider.notifier).selectedDate;
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);

    amountController.addListener(_updateAmount);
  }

  @override
  void dispose() {
    controller.dispose();
    purposeController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _updateAmount() {
    String text = amountController.text;
    if (text.isEmpty) {
      currentAmount = 0;
      return;
    }

    // Remove all non-digit characters
    text = text.replaceAll(RegExp(r'[^\d]'), '');

    if (text.isEmpty) {
      currentAmount = 0;
      return;
    }

    // Convert to int directly
    currentAmount = int.parse(text);

    // Update the text with proper formatting
    final newText = currencyFormatter.format(currentAmount);

    // Avoid infinite loop by checking if the text is already formatted
    if (amountController.text != newText) {
      amountController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20.0),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              decoration: ShapeDecoration(
                color: ColorName.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                shadows: [
                  BoxShadow(
                    color: ColorName.homeGrayBalance.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                localizations.addNewTransaction ?? 'Add New Transaction',
                                style: const TextStyle(
                                  color: ColorName.textBlack,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => context.pop(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColorName.homeGrayHold,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: ColorName.iconGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Transaction Purpose Field
                        Text(
                          localizations.transactionPurpose ?? 'Transaction Purpose *',
                          style: const TextStyle(
                            color: ColorName.iconGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: purposeController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return localizations.pleaseEnterTransactionPurpose ?? 'Please enter transaction purpose';
                            }
                            if (value.trim().length < 2) {
                              return localizations.purposeMustBeAtLeast2Characters ?? 'Purpose must be at least 2 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: localizations.enterTransactionPurpose ?? 'Enter transaction purpose',
                            hintStyle: const TextStyle(
                              color: ColorName.loginTextColorGray,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Amount Field
                        Text(
                          localizations.amount ?? 'Amount *',
                          style: const TextStyle(
                            color: ColorName.iconGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: false),
                          validator: (value) {
                            if (currentAmount <= 0) {
                              return localizations.pleaseEnterValidAmount ?? 'Please enter a valid amount';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '0 ₫',
                            hintStyle: const TextStyle(
                              color: ColorName.loginTextColorGray,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Date Field
                        Text(
                          localizations.transactionDate ?? 'Transaction Date *',
                          style: const TextStyle(
                            color: ColorName.iconGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: _selectDate,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return localizations.pleaseSelectDate ?? 'Please select a date';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: localizations.selectDate ?? 'Select date',
                            hintStyle: const TextStyle(
                              color: ColorName.loginTextColorGray,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: const Icon(
                              Icons.calendar_today,
                              color: ColorName.iconGray,
                              size: 20,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => context.pop(),
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: ColorName.homeGrayHold,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: ColorName.homeGrayBalance),
                                  ),
                                  child: Text(
                                    localizations.cancel ?? 'Cancel',
                                    style: const TextStyle(
                                      color: ColorName.textGray,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: _isLoading ? null : _handleAddTransaction,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _isLoading ? ColorName.homeGrayBalance : ColorName.groupManagementBackGroundButton,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: ColorName.homeGrayBalance,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                      : Text(
                                    localizations.addTransaction ?? 'Add Transaction',
                                    style: const TextStyle(
                                      color: ColorName.homeWhiteButtonBg,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: ColorName.homeBlackText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  Future<void> _handleAddTransaction() async {
    final localizations = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Create the transaction date at the start of the selected day
      final transactionDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      ).millisecondsSinceEpoch;

      // Create new transaction
      final newTransaction = Transaction(
        uid: const Uuid().v4(),
        purpose: purposeController.text.trim(),
        amount: currentAmount,
        transactionDate: transactionDate,
      );

      // Add transaction to database
      await ref.read(transactionNotifierProvider.notifier).addNewTransaction(newTransaction);

      // Update the selected date in the provider to show the newly added transaction
      ref.read(transactionNotifierProvider.notifier).setSelectedDate(selectedDate);

      if (mounted) {
        context.pop();
        toastification.show(
          title: Text(localizations.transactionAddedSuccessfully ?? 'Transaction added successfully'),
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          title: Text('${localizations.errorAddingTransaction ?? 'Error adding transaction'}: ${e.toString()}'),
          style: ToastificationStyle.fillColored,
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}