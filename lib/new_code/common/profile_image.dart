import 'package:flutter/material.dart';
import '/domain/model/profile/profile_entity.dart';
import '/presentation/screens/profile/show_profile_model_screen.dart';

import '../../presentation/screens/home/gallery_screen.dart';

class ProfileImage extends StatelessWidget {
  final ProfileEntity profile;
  final double size;

  const ProfileImage({Key? key, required this.profile, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = getLinkPhoto(profile);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GalleryPhotoScreen(
            images: [imageUrl],
            initialIndex: 0,
          ),
        ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
