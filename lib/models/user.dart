class User {
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;
  String occupation;
  String regNo;
  String branch;
  int year;
  int batch;
  String otherDescription;
  double totalMarks;

  User({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
    this.occupation: '',
    this.regNo,
    this.branch,
    this.year,
    this.batch,
    this.otherDescription,
    this.totalMarks: 0.0,
  });

  void addAuthData(String uid, String name, String email, String username,
      String profilePhoto) {
    this.uid = uid;
    this.name = name;
    this.email = email;
    this.username = username;
    this.profilePhoto = profilePhoto;
  }

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data["status"] = user.status;
    data["state"] = user.state;
    data["profile_photo"] = user.profilePhoto;
    data["occupation"] = user.occupation;
    data["regNo"] = user.regNo;
    data["branch"] = user.branch;
    data["year"] = user.year;
    data["batch"] = user.batch;
    data["otherDescription"] = user.otherDescription;
    data["totalMarks"] = user.totalMarks;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.occupation = mapData['occupation'];
    this.regNo = mapData["regNo"];
    this.branch = mapData["branch"];
    this.year = mapData["year"];
    this.batch = mapData["batch"];
    this.otherDescription = mapData["otherDescription"];
    this.totalMarks = mapData["totalMarks"];
  }
}
