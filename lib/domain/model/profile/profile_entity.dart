import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int? id;
  final List<String>? profilePhotos;
  final String? name;
  final String? userType;
  final int? gender;
  final int? age;
  final int? feedbackCount;
  final String? city;
  final String? phone;
  final String? facebook;
  final String? instagram;
  final String? linkedin;
  final String? website;
  final String? about;
  final int? workerType;
  final int? closeSize;
  final int? shoesSize;
  final int? growth;
  final int? bust;
  final int? waist;
  final int? hips;
  final String? lookType;
  final String? skinColor;
  final String? hairColor;
  final String? hairLength;
  final bool? isHaveInternationalPassport;
  final bool? isHaveTattoo;
  final bool? isHaveEnglish;
  final bool? isFavorite;
  final String? photo;
  final String? workType;
  final int? userId;

  ProfileEntity({
    this.id,
    this.profilePhotos,
    this.name,
    this.userType,
    this.gender,
    this.age,
    this.feedbackCount,
    this.city,
    this.phone,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.website,
    this.about,
    this.workerType,
    this.closeSize,
    this.shoesSize,
    this.growth,
    this.bust,
    this.waist,
    this.hips,
    this.lookType,
    this.skinColor,
    this.hairColor,
    this.hairLength,
    this.isHaveInternationalPassport,
    this.isHaveTattoo,
    this.isHaveEnglish,
    this.isFavorite,
    this.photo,
    this.workType,
    this.userId,
  });

  @override
  List<Object?> get props => [
        id,
        profilePhotos,
        name,
        userType,
        gender,
        age,
        feedbackCount,
        city,
        phone,
        facebook,
        instagram,
        linkedin,
        website,
        about,
        workerType,
        closeSize,
        shoesSize,
        growth,
        bust,
        waist,
        hips,
        lookType,
        skinColor,
        hairColor,
        hairLength,
        isHaveInternationalPassport,
        isHaveTattoo,
        isHaveEnglish,
        isFavorite,
        photo,
        workType,
        userId,
      ];
}
