class Person {
  Person({
    required this.uid,
    required this.name,
    required this.yearOfBirth,
    required this.avtUrl,
    required this.groupId,
  });

  String uid;
  String name;
  int yearOfBirth;
  String avtUrl;
  List<String> groupId;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      uid: json['uid'],
      name: json['name'],
      yearOfBirth: json['yearOfBirth'],
      avtUrl: json['avtUrl'],
      groupId: json['groupId'],
    );
  }

  factory Person.fromMap(Map<dynamic, dynamic> map) {
    return Person(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      yearOfBirth: map['yearOfBirth'] ?? 1,
      avtUrl: map['avtUrl'] ?? '',
      groupId: (map['groupId'] != null) ? List<String>.from(map['groupId'] as List<Object?>) : [],
    );
  }

  // Create a copy of this Person with modified fields
  Person copyWith({
    String? uid,
    String? name,
    int? yearOfBirth,
    String? avtUrl,
    List<String>? groupId,
  }) {
    return Person(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      yearOfBirth: yearOfBirth ?? this.yearOfBirth,
      avtUrl: avtUrl ?? this.avtUrl,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'yearOfBirth': yearOfBirth,
      'avtUrl': avtUrl,
      'groupId': groupId,
    };
  }
}
