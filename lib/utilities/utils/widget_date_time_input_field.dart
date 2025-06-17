import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';

class DateTimeInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(DateTime?)? onDateTimeSelected;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool isRequired;

  const DateTimeInputField({
    super.key,
    required this.controller,
    this.onDateTimeSelected,
    this.hintText = 'MMM dd, yyyy - HH:mm',
    this.validator,
    this.isRequired = false,
  });

  @override
  State<DateTimeInputField> createState() => _DateTimeInputFieldState();
}

class _DateTimeInputFieldState extends State<DateTimeInputField> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      try {
        _selectedDateTime = DateFormat('MMM dd, yyyy - HH:mm').parse(widget.controller.text);
      } catch (e) {
        // Handle parse error if needed
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    // First, show date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Calendar text color
            ),
          ),
          child: child!,
        );
      },
    );

    // If date is picked, proceed to time picker
    if (pickedDate != null) {
      // Show time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedDateTime != null
            ? TimeOfDay.fromDateTime(_selectedDateTime!)
            : TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              timePickerTheme: TimePickerThemeData(
                dayPeriodTextColor: Colors.blue,
                hourMinuteTextColor: Colors.black54,
                dialHandColor: Colors.blue,
                dialBackgroundColor: Colors.blue.withOpacity(0.1),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        // Combine date and time
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedDateTime = combinedDateTime;
          widget.controller.text = DateFormat('MMM dd, yyyy - HH:mm').format(combinedDateTime);
          if (widget.onDateTimeSelected != null) {
            widget.onDateTimeSelected!(_selectedDateTime);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDateTime(context),
            ),
            IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () => _selectDateTime(context),
            ),
          ],
        ),
      ),
      validator: widget.validator ?? (widget.isRequired
          ? (value) => (value == null || value.isEmpty) ? localizations.dateAndTimeRequired : null
          : null),
      onTap: () => _selectDateTime(context),
    );
  }
}