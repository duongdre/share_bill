class Person {
  Person({
    required this.uid,
    required this.name,
    required this.avtUrl,
    required this.groupId,
  });

  String uid;
  String name;
  String avtUrl;
  List<String> groupId;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      uid: json['uid'],
      name: json['name'],
      avtUrl: json['avtUrl'],
      groupId: json['groupId'],
    );
  }

  factory Person.fromMap(Map<dynamic, dynamic> map) {
    return Person(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      avtUrl: map['avtUrl'] ?? '',
      groupId: (map['groupId'] != null) ? List<String>.from(map['groupId'] as List<Object?>) : [],
    );
  }

  // Create a copy of this Person with modified fields
  Person copyWith({
    String? uid,
    String? name,
    String? avtUrl,
    List<String>? groupId,
  }) {
    return Person(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      avtUrl: avtUrl ?? this.avtUrl,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'avtUrl': avtUrl,
      'groupId': groupId,
    };
  }
}
