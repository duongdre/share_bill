// transaction.dart

class Transaction {
  final String id;
  final String groupId;
  final String personId;
  final double amount;
  final String description;
  final int createdAt;

  Transaction({
    required this.id,
    required this.groupId,
    required this.personId,
    required this.amount,
    required this.description,
    int? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  // Create a Transaction from a map
  factory Transaction.fromMap(String id, Map<String, dynamic> map) {
    return Transaction(
      id: id,
      groupId: map['groupId'] ?? '',
      personId: map['personId'] ?? '',
      amount: (map['amount'] is int)
          ? (map['amount'] as int).toDouble()
          : map['amount']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      createdAt: map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Convert Transaction to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'personId': personId,
      'amount': amount,
      'description': description,
      'createdAt': createdAt,
    };
  }

  // Create a copy of Transaction with some changes
  Transaction copyWith({
    String? groupId,
    String? personId,
    double? amount,
    String? description,
    int? createdAt,
  }) {
    return Transaction(
      id: this.id,
      groupId: groupId ?? this.groupId,
      personId: personId ?? this.personId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Get the date from timestamp
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(createdAt);

  @override
  String toString() {
    return 'Transaction{id: $id, groupId: $groupId, personId: $personId, amount: $amount, description: $description, createdAt: $createdAt}';
  }
}