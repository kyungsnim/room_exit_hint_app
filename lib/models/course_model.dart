class CourseModel {
  String id;
  String courseName;      // 과제 명
  String courseNumber;    // 과제 회차
  String courseGrade;    // 학년
  DateTime courseDate;    // 수업일시
  DateTime firstDueDate;  // 1차 제출기간
  DateTime secondDueDate; // 2차 제출기간
  DateTime thirdDueDate;  // 3차 제출기간

  CourseModel(
      { required this.id,
        required this.courseName,
        required this.courseNumber,
        required this.courseGrade,
        required this.courseDate,
        required this.firstDueDate,
        required this.secondDueDate,
        required this.thirdDueDate});

  factory CourseModel.fromMap(Map data) {
    return CourseModel(
      id: data['id'],
      courseName: data['courseName'],
      courseNumber: data['courseNumber'],
      courseGrade: data['courseGrade'],
      courseDate: data['courseDate'].toDate(),
      firstDueDate: data['firstDueDate'].toDate(),
      secondDueDate: data['secondDueDate'].toDate(),
      thirdDueDate: data['thirdDueDate'].toDate(),
    );
  }

  factory CourseModel.fromDS(String id, Map<String, dynamic> data) {
    return CourseModel(
      id: id,
      courseName: data['courseName'],
      courseNumber: data['courseNumber'],
      courseGrade: data['courseGrade'],
      courseDate: data['courseDate'].toDate(),
      firstDueDate: data['firstDueDate'].toDate(),
      secondDueDate: data['secondDueDate'].toDate(),
      thirdDueDate: data['thirdDueDate'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "courseName": courseName,
      "courseNumber": courseName,
      "courseGrade": courseGrade,
      "courseDate": courseDate,
      "firstDueDate": firstDueDate,
      "secondDueDate": secondDueDate,
      "thirdDueDate": thirdDueDate,
    };
  }
}
