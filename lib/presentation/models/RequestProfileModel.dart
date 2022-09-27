import 'dart:convert';
import 'dart:io';

/// email : "fdgfdg"
/// password : 23
/// name : "fdgfdg"
/// user_type : "MODEL"
/// gender : 1
/// age : 23
/// city : "выпывп".tr()
/// phone : 324234324234
/// instagram : ""
/// website : ""
/// about : "вава".tr()
/// close_size : 34
/// shoes_size : 34
/// growth : 34
/// bust : 34
/// waist : 34
/// hips : 34
/// look_type : 1
/// skin_color : "светлый".tr()
/// hair_color : "брюнет".tr()
/// hair_length : "длинные".tr()
/// is_have_international_passport : true
/// is_have_tattoo : false
/// is_have_english : true

RequestProfileModel requestProfileModelFromJson(String str) => RequestProfileModel.fromJson(json.decode(str));
String requestProfileModelToJson(RequestProfileModel data) => json.encode(data.toJson());

class RequestProfileModel {
  RequestProfileModel({
    String? email,
    String? password,
    String? name,
    String? userType,
    int? gender,
    int? workerType,
    int? age,
    String? city,
    String? phone,
    String? instagram,
    String? facebook,
    String? linkedin,
    String? website,
    String? about,
    int? closeSize,
    int? shoesSize,
    int? growth,
    int? bust,
    int? waist,
    int? hips,
    String? lookType,
    String? skinColor,
    String? hairColor,
    String? hairLength,
    bool? isHaveInternationalPassport,
    bool? isHaveTattoo,
    bool? isHaveEnglish,
    File? avatar,
  }) {
    _email = email;
    _password = password;
    _name = name;
    _userType = userType;
    _gender = gender;
    _workerType = workerType;
    _age = age;
    _city = city;
    _phone = phone;
    _instagram = instagram;
    _facebook = facebook;
    _linkedin = linkedin;
    _website = website;
    _about = about;
    _closeSize = closeSize;
    _shoesSize = shoesSize;
    _growth = growth;
    _bust = bust;
    _waist = waist;
    _hips = hips;
    _lookType = lookType;
    _skinColor = skinColor;
    _hairColor = hairColor;
    _hairLength = hairLength;
    _isHaveInternationalPassport = isHaveInternationalPassport;
    _isHaveTattoo = isHaveTattoo;
    _isHaveEnglish = isHaveEnglish;
    _avatar = avatar;
  }

  RequestProfileModel.fromJson(dynamic json) {
    _email = json['email'];
    _password = json['password'];
    _name = json['name'];
    _userType = json['user_type'];
    _gender = json['gender'];
    _workerType = json['worker_type'];
    _age = json['age'];
    _city = json['city'];
    _phone = json['phone'];
    _instagram = json['instagram'];
    _website = json['website'];
    _about = json['about'];
    _closeSize = json['close_size'];
    _shoesSize = json['shoes_size'];
    _growth = json['growth'];
    _bust = json['bust'];
    _waist = json['waist'];
    _hips = json['hips'];
    _lookType = json['look_type'];
    _skinColor = json['skin_color'];
    _hairColor = json['hair_color'];
    _hairLength = json['hair_length'];
    _isHaveInternationalPassport = json['is_have_international_passport'];
    _isHaveTattoo = json['is_have_tattoo'];
    _isHaveEnglish = json['is_have_english'];
    _avatar = json['photo'];
  }
  String? _email;
  String? _password;
  String? _name;
  String? _userType;
  int? _gender;
  int? _workerType;
  int? _age;
  String? _city;
  String? _phone;
  String? _instagram;
  String? _facebook;
  String? _linkedin;
  String? _website;
  String? _about;
  int? _closeSize;
  int? _shoesSize;
  int? _growth;
  int? _bust;
  int? _waist;
  int? _hips;
  String? _lookType;
  String? _skinColor;
  String? _hairColor;
  String? _hairLength;
  bool? _isHaveInternationalPassport;
  bool? _isHaveTattoo;
  bool? _isHaveEnglish;
  File? _avatar;
  RequestProfileModel copyWith({
    String? email,
    String? password,
    String? name,
    String? userType,
    int? gender,
    int? workerType,
    int? age,
    String? city,
    String? phone,
    String? instagram,
    String? facebook,
    String? linkedin,
    String? website,
    String? about,
    int? closeSize,
    int? shoesSize,
    int? growth,
    int? bust,
    int? waist,
    int? hips,
    String? lookType,
    String? skinColor,
    String? hairColor,
    String? hairLength,
    bool? isHaveInternationalPassport,
    bool? isHaveTattoo,
    bool? isHaveEnglish,
    File? avatar,
  }) =>
      RequestProfileModel(
        email: email ?? _email,
        password: password ?? _password,
        name: name ?? _name,
        userType: userType ?? _userType,
        gender: gender ?? _gender,
        workerType: workerType ?? _workerType,
        age: age ?? _age,
        city: city ?? _city,
        phone: phone ?? _phone,
        instagram: instagram ?? _instagram,
        facebook: facebook ?? _facebook,
        linkedin: linkedin ?? _linkedin,
        website: website ?? _website,
        about: about ?? _about,
        closeSize: closeSize ?? _closeSize,
        shoesSize: shoesSize ?? _shoesSize,
        growth: growth ?? _growth,
        bust: bust ?? _bust,
        waist: waist ?? _waist,
        hips: hips ?? _hips,
        lookType: lookType ?? _lookType,
        skinColor: skinColor ?? _skinColor,
        hairColor: hairColor ?? _hairColor,
        hairLength: hairLength ?? _hairLength,
        isHaveInternationalPassport: isHaveInternationalPassport ?? _isHaveInternationalPassport,
        isHaveTattoo: isHaveTattoo ?? _isHaveTattoo,
        isHaveEnglish: isHaveEnglish ?? _isHaveEnglish,
        avatar: avatar ?? _avatar,
      );
  String? get email => _email;
  String? get password => _password;
  String? get name => _name;
  String? get userType => _userType;
  int? get gender => _gender;
  int? get age => _age;
  String? get city => _city;
  String? get phone => _phone;
  String? get instagram => _instagram;
  String? get facebook => facebook;
  String? get linkedin => linkedin;
  String? get website => _website;
  String? get about => _about;
  int? get closeSize => _closeSize;
  int? get shoesSize => _shoesSize;
  int? get growth => _growth;
  int? get bust => _bust;
  int? get waist => _waist;
  int? get hips => _hips;
  String? get lookType => _lookType;
  String? get skinColor => _skinColor;
  String? get hairColor => _hairColor;
  String? get hairLength => _hairLength;
  bool? get isHaveInternationalPassport => _isHaveInternationalPassport;
  bool? get isHaveTattoo => _isHaveTattoo;
  bool? get isHaveEnglish => _isHaveEnglish;
  File? get avatar => _avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['password'] = _password;
    map['name'] = _name;
    map['user_type'] = _userType;
    map['gender'] = _gender;
    map['worker_type'] = _workerType;
    map['age'] = _age;
    map['city'] = _city;
    map['phone'] = _phone;
    map['instagram'] = _instagram;
    map['facebook'] = _facebook;
    map['linkedin'] = _linkedin;
    map['website'] = _website;
    map['about'] = _about;
    map['close_size'] = _closeSize;
    map['shoes_size'] = _shoesSize;
    map['growth'] = _growth;
    map['bust'] = _bust;
    map['waist'] = _waist;
    map['hips'] = _hips;
    map['look_type'] = _lookType;
    map['skin_color'] = _skinColor;
    map['hair_color'] = _hairColor;
    map['hair_length'] = _hairLength;
    map['is_have_international_passport'] = _isHaveInternationalPassport;
    map['is_have_tattoo'] = _isHaveTattoo;
    map['is_have_english'] = _isHaveEnglish;
    map['photo'] = _avatar;
    return map;
  }
}
