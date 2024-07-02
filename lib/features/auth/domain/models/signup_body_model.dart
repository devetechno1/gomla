class SignUpBodyModel {
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? password;
  String? refCode;
  int? isAddress;
  String? addressType;
  String? customerAddress;
  String? floor;
  String? road;
  String? house;
  String? longitude;
  String? latitude;
  String? contactPerson;


  SignUpBodyModel({
    this.fName,
    this.lName,
    this.phone,
    this.email = '',
    this.password,
    this.refCode = '',
    this.isAddress,
    this.addressType,
    this.customerAddress,
    this.floor,
    this.road,
    this.house,
    this.latitude,
    this.longitude,
    this.contactPerson
  });

  SignUpBodyModel.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    refCode = json['ref_code'];
    isAddress=json['is_address'];
    addressType=json['address_type'];
    customerAddress=json['customer_address'];
    floor=json['floor'];
    road=json['road'];
    house=json['house'];
    latitude='1';
    longitude='1';
    contactPerson= json['contact_person_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['ref_code'] = refCode;
    data['is_address'] = isAddress;
    data['address_type'] = addressType;
    data['customer_address'] = customerAddress;
    data['floor'] = floor;
    data['road'] = road;
    data['house'] = house;
    data['latitude']=latitude;
    data['longitude']=longitude;
    data['contact_person_number']=contactPerson;
    return data;
  }
}
