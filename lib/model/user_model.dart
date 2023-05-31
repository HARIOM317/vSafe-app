class UserModel {
  String? name;
  String? id;
  String? phone;
  String? email;
  String? type;

  UserModel({this.name, this.id, this.phone, this.email, this.type});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'phone': phone,
      'email': email,
      'type': type
    };
  }
}


class MyUserModal {
  String? name;
  String? phone;
  String? email;
  String? type;

  MyUserModal();

  MyUserModal.fromJson(Map<String, dynamic> json){
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    type = json['type'];
  }
}
