class ContactModel {
  late String uid;
  late String email;
  late String firstName;
  late String lastName;
  late String tel;
  late String profileImage;

  ContactModel({
    required this.uid, 
    required this.email, 
    required this.firstName, 
    required this.lastName, 
    required this.tel, 
    required this.profileImage});

//receive data from server
  static ContactModel fromMap(Map<String, dynamic> map) {
    return ContactModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        tel: map['tel'], 
        profileImage: map['profileImage']);
  }

  //send data to server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstName,
      'lastname': lastName,
      'phoneno': tel,
      'profileimage': profileImage
    };
  }
}
