class Person {
  Person({
    required this.uid,
    required this.name,
    String? describe,
    required this.avtUrl,
    required this.groups,
  }) : describe = describe ?? '';

  String uid;
  String name;
  String describe;
  String avtUrl;
  Map<String, bool> groups;

  String getPersonDescribe() {
    return describe ?? "";
  }

  String getPersonName() {
    return name;
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      uid: json['uid'],
      name: json['name'],
      describe: json['describe'],
      avtUrl: json['avtUrl'],
      groups: (json['groups'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as bool),
      ) ??
          {},
    );
  }

  factory Person.fromMap(Map<dynamic, dynamic> map) {
    return Person(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      describe: map['describe'] ?? '',
      avtUrl: map['avtUrl'] ?? '',
      groups: (map['groups'] as Map<dynamic, dynamic>?)?.map(
            (key, value) => MapEntry(key.toString(), value as bool),
      ) ??
          {},
    );
  }

  // Convert Person to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'describe': describe,
      'avtUrl': avtUrl,
      'groups': groups,
    };
  }

  Person copyWith({
    String? uid,
    String? name,
    String? describe,
    String? avtUrl,
    Map<String, bool>? groups,
  }) {
    return Person(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      describe: describe ?? this.describe,
      avtUrl: avtUrl ?? this.avtUrl,
      groups: groups ?? this.groups,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'describe': describe,
      'avtUrl': avtUrl,
      'groups': groups,
    };
  }

  // Add a group to this person
  Person addGroup(String groupId) {
    final updatedGroups = Map<String, bool>.from(groups);
    updatedGroups[groupId] = true;
    return copyWith(groups: updatedGroups);
  }

  // Remove a group from this person
  Person removeGroup(String groupId) {
    final updatedGroups = Map<String, bool>.from(groups);
    updatedGroups.remove(groupId);
    return copyWith(groups: updatedGroups);
  }
}