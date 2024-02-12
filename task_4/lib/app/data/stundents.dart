class Student {
  String lastName;
  String firstName;
  String middleName;
  double rating;
  bool isActivist;

  Student(
      {required this.lastName,
      required this.firstName,
      required this.middleName,
      required this.rating,
      required this.isActivist});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      lastName: json['lastName'] as String,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      rating: json['rating'] as double,
      isActivist: json['isActivist'] as bool,
    );
  }
}
