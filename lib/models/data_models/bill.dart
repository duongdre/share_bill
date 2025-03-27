class Bill {
  Bill({
    required this.uid,
    required this.groupId,
    required this.personId,
    required this.amount,
    this.description,
    this.createdAt,
  });

  String uid;
  String groupId;
  String personId;
  int amount;
  String? description;
  int? createdAt = DateTime.now().millisecondsSinceEpoch;

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
      uid: this.uid,
      groupId: this.groupId,
      personId: this.personId,
      amount: this.amount,
      description: this.description,
      createdAt: this.createdAt ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory Bill.fromMap(Map<dynamic, dynamic> map) {
    return Bill(
      uid: map['uid'] ?? '',
      groupId: map['groupId'] ?? '',
      personId: map['personId'] ?? '',
      amount: map['amount'] ?? '',
      description: map['description'],
      createdAt: map['createdAt'].toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Convert Transaction to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'groupId': groupId,
      'personId': personId,
      'amount': amount,
      'description': description,
      'createdAt': createdAt ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'groupId': groupId,
      'personId': personId,
      'amount': amount,
      'description': description,
      'createdAt': createdAt ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'Transaction{id: $uid, groupId: $groupId, personId: $personId, amount: $amount, description: $description, createdAt: $createdAt}';
  }
}
