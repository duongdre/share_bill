class Person {
  Person({
    required this.uid,
    required this.name,
    required this.yearOfBirth,
    required this.avtUrl,
  });

  Person.fromFulfill({
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
  List<String>? groupId;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person.fromFulfill(
      uid: json['uid'],
      name: json['name'],
      yearOfBirth: json['yearOfBirth'],
      avtUrl: json['avtUrl'],
      groupId: json['groupId'],
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

  Map<String, dynamic> toJsonWithoutUid() {
    return {
      'name': name,
      'yearOfBirth': yearOfBirth,
      'avtUrl': avtUrl,
      'groupId': groupId,
    };
  }
}