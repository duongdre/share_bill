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
  int? createdAt;
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

  // Create a Group from JSON data
  factory Group.fromJson(String id, Map<String, dynamic> json) {
    return Group(
      uid: json['uid'],
      name: json['name'],
      createdAt: json['createdAt'],
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
      'createdAt': createdAt,
      'members': members,
    };
  }

  // Create a copy of Group with some changes
  Group copyWith({
    String? uid,
    String? name,
    int? createdAt,
    Map<String, bool>? members,
  }) {
    return Group(
      uid: this.uid,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
    );
  }

  // Add a member to this group
  Group addMember(String personId) {
    final updatedMembers = Map<String, bool>.from(members);
    updatedMembers[personId] = true;
    return copyWith(members: updatedMembers);
  }

  // Remove a member from this group
  Group removeMember(String personId) {
    final updatedMembers = Map<String, bool>.from(members);
    updatedMembers.remove(personId);
    return copyWith(members: updatedMembers);
  }

  // Check if a person is a member of this group
  bool isMember(String personId) {
    return members.containsKey(personId);
  }

  // Get the number of members in this group
  int get memberCount => members.length;

  @override
  String toString() {
    return 'Group{id: $uid, name: $name, createdAt: $createdAt, members: $members}';
  }

  // Create a Group from a map
  factory Group.fromMap(Map<dynamic, dynamic> map) {
    return Group(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['createdAt'],
      members: (map['members'] as Map<dynamic, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as bool),
          ) ??
          {},
    );
  }
}
