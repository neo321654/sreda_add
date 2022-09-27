import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/domain/model/auth/post_entity.dart';

import '../colors.dart';
import '../screens/home/detail_screen.dart';

class PostCard extends StatelessWidget {
  final PostEntity postEntity;
  const PostCard({Key? key, required this.postEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 140,
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Image border
                child: CachedNetworkImage(
                  imageUrl: getPhoto(postEntity),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 160,
              child: Stack(
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(
                      postEntity.title,
                      maxLines: 2,
                      //overflow: TextOverflow.ellipsis,
                      style:const TextStyle(
                          color: lightText,
                          fontWeight: FontWeight.w600,
                          fontFamily: "GloryRegular", fontSize: 17),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: SvgIconWithText(
                            sizeIcon: 12,
                            sizeText: 12,
                            paddingLeft: 1,
                            description: postEntity.city,
                            svgPath: 'assets/images/ic_location_1.svg',
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: SvgIconWithText(
                            sizeIcon: 12,
                            sizeText: 12,
                            description: getPostDateFormat(postEntity.executionDate),
                            svgPath: 'assets/images/ic_calendar_1.svg',
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SvgIconWithText(
                          sizeIcon: 12,
                          sizeText: 12,
                          width: 8,
                          paddingLeft: 0.5,
                          description: '${postEntity.budget} P',
                          svgPath: 'assets/images/ic_dollars_1.svg',
                        ),
                      ],
                    ),
                  )


                ],
              ),
            ),
          ),


        ],
      ),
    );
  }
}

String getPostDateFormat(String executionDate) {
  DateFormat dateFormatFrom = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  DateFormat dateFormatTo = DateFormat("dd.MM");
  DateTime dateTime = dateFormatFrom.parse(executionDate);
  return dateFormatTo.format(dateTime);
}

String getPhoto(PostEntity postEntity) {
  if (postEntity.photos.isNotEmpty) {
    return postEntity.photos[0];
  } else {
    return "https://www.signupgenius.com/cms/images/business/appointment-scheduling-tips-photographers-article-600x400.jpg";
  }
}
