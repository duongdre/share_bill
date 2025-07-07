class Transaction {
  Transaction({
    required this.uid,
    required this.purpose,
    required this.amount,
    required this.transactionDate,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  String uid;
  String purpose;
  int amount; // Amount in smallest currency unit (e.g., cents)
  int transactionDate; // Date as millisecondsSinceEpoch (start of day)
  int createdAt;

  String getPurpose() {
    var result = purpose;
    if (result.isEmpty) result = "No description";
    return result;
  }

  DateTime get transactionDateTime => DateTime.fromMillisecondsSinceEpoch(transactionDate);
  DateTime get createdDateTime => DateTime.fromMillisecondsSinceEpoch(createdAt);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      uid: json['uid'],
      purpose: json['purpose'],
      amount: json['amount'],
      transactionDate: json['transactionDate'],
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Transaction copyWith({
    String? uid,
    String? purpose,
    int? amount,
    int? transactionDate,
    int? createdAt,
  }) {
    return Transaction(
      uid: uid ?? this.uid,
      purpose: purpose ?? this.purpose,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Transaction.fromMap(Map<dynamic, dynamic> map) {
    return Transaction(
      uid: map['uid'] ?? '',
      purpose: map['purpose'] ?? '',
      amount: map['amount'] ?? 0,
      transactionDate: map['transactionDate']?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      createdAt: map['createdAt']?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'purpose': purpose,
      'amount': amount,
      'transactionDate': transactionDate,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'purpose': purpose,
      'amount': amount,
      'transactionDate': transactionDate,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'Transaction{uid: $uid, purpose: $purpose, amount: $amount, transactionDate: $transactionDate, createdAt: $createdAt}';
  }
}