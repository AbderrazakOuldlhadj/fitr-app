class UserM {
  late String name;
  late String address;
  late String email;
  late String uId;
  late String type;

  UserM({
    required this.name,
    required this.address,
    required this.email,
    required this.uId,
    required this.type,
  });

   UserM.fromJson({required Map<String, dynamic> json}){
     name =json['name'];
     email =json['email'];
     uId =json['uId'];
     type =json['type'];
     address=json['address'];
   }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'email': email,
      'type': type,
      'uId': uId,
    };
  }
}
