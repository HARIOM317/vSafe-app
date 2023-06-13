class UserModel {
  String? name;
  String? id;
  String? phone;
  String? email;
  String? type;
  String? profilePic;

  UserModel({this.name, this.id, this.phone, this.email, this.type, this.profilePic});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'phone': phone,
      'email': email,
      'type': type,
      'profilePic': profilePic
    };
  }
}


class MyUserModal {
  String? name;
  String? phone;
  String? email;
  String? type;
  String? profilePic;

  MyUserModal();

  MyUserModal.fromJson(Map<String, dynamic> json){
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    type = json['type'];
    profilePic = json['profilePic'];
  }
}
