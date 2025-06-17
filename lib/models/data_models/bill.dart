class Bill {
  Bill({
    required this.uid,
    required this.groupId,
    required this.personId,
    required this.amount,
    this.description,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch; // ✅ Set default in initializer list

  String uid;
  String groupId;
  String personId;
  int amount;
  String? description;
  int createdAt;

  String getDescribe() {
    var result = description ?? "Không ghi chú";
    if (result.isEmpty) result = "Không ghi chú";
    return result;
  }

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      uid: json['uid'],
      groupId: json['name'],
      personId: json['personId'],
      amount: json['amount'],
      description: json['description'],
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Bill copyWith({
    String? uid,
    String? groupId,
    String? personId,
    int? amount,
    String? description,
    int? createdAt,
  }) {
    return Bill(
      uid: uid ?? this.uid,
      groupId: groupId ?? this.groupId,
      personId: personId ?? this.personId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Bill.fromMap(Map<dynamic, dynamic> map) {
    return Bill(
      uid: map['uid'] ?? '',
      groupId: map['groupId'] ?? '',
      personId: map['personId'] ?? '',
      amount: map['amount'] ?? 0,
      description: map['description'],
      createdAt: map['createdAt']?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'groupId': groupId,
      'personId': personId,
      'amount': amount,
      'description': description,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'groupId': groupId,
      'personId': personId,
      'amount': amount,
      'description': description,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'Bill{id: $uid, groupId: $groupId, personId: $personId, amount: $amount, description: $description, createdAt: $createdAt}';
  }
}