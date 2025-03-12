import 'dart:convert';

class Group {
  final String id;
  final String name;
  final int createdAt;
  final Map<String, bool> members;

  Group({
    required this.id,
    required this.name,
    int? createdAt,
    Map<String, bool>? members,
  }) :
        this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
        this.members = members ?? {};

  // Create a Group from JSON data
  factory Group.fromJson(String id, Map<String, dynamic> json) {
    return Group(
      id: id,
      name: json['name'] ?? '',
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
      'name': name,
      'createdAt': createdAt,
      'members': members,
    };
  }

  // Create a copy of Group with some changes
  Group copyWith({
    String? name,
    int? createdAt,
    Map<String, bool>? members,
  }) {
    return Group(
      id: this.id,
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
    return 'Group{id: $id, name: $name, createdAt: $createdAt, members: $members}';
  }

  // Create a Group from a map
  factory Group.fromMap(String id, Map<String, dynamic> map) {
    return Group(
      id: id,
      name: map['name'] ?? '',
      createdAt: map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      members: (map['members'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as bool),
      ) ??
          {},
    );
  }
}