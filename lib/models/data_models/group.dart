import 'dart:convert';

class Group {
  Group({
    required this.uid,
    required this.name,
    this.createdAt,
    required this.members,
  });

  String uid;
  String name;
  num? createdAt = DateTime.now().millisecondsSinceEpoch;
  Map<String, bool> members;

  int countMember() {
    var result = 0;
    for (final data in members.values.toList()) {
      if (data) {
        result = result + 1;
      }
    }
    return result;
  }

  String getMember() {
    final member = countMember();
    if (member < 1) {
      return "0 member";
    } else if (member == 1) {
      return "$member member";
    } else {
      return "$member members";
    }
  }

  // Create a Group from JSON data
  factory Group.fromJson(String id, Map<String, dynamic> json) {
    return Group(
      uid: json['uid'],
      name: json['name'],
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      members: (json['members'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as bool),
          ) ??
          {},
    );
  }

  // Convert Group to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'createdAt': createdAt ?? DateTime.now().millisecondsSinceEpoch,
      'members': members,
    };
  }

  // Create a copy of Group with some changes
  Group copyWith({
    String? uid,
    String? name,
    num? createdAt,
    Map<String, bool>? members,
  }) {
    return Group(
      uid: this.uid,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt ?? DateTime.now().millisecondsSinceEpoch,
      members: members ?? this.members,
    );
  }

  // Check if a person is a member of this group
  bool isMember(String personId) {
    return members.containsKey(personId);
  }

  // Get the number of members in this group
  int get memberCount => members.length;

  String getNameForSpent() {
    if (name.isEmpty) name = "NaN";
    return name;
  }

  @override
  String toString() {
    return 'Group{id: $uid, name: $name, createdAt: $createdAt, members: $members}';
  }

  // Create a Group from a map
  factory Group.fromMap(Map<dynamic, dynamic> map) {
    return Group(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      members: (map['members'] as Map<dynamic, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as bool),
          ) ??
          {},
    );
  }
}
