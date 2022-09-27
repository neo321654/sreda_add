import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/domain/model/auth/post_entity.dart';

import '../colors.dart';
import '../screens/home/detail_screen.dart';

class PostCardResponse extends StatelessWidget {
  final PostEntity postEntity;
  final bool isModel;
  const PostCardResponse({Key? key, required this.postEntity,required this.isModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        child:
          Stack(
            children:[
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Image border
                child: CachedNetworkImage(
                  imageUrl: getPhoto(postEntity),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),

                !isModel? Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                    decoration: BoxDecoration(
                      color: colorBackground,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    //todo data status
                    child:const Text('На модерации',style: TextStyle(
                      fontSize: 13
                    ),),
                  ),
                ),
              ):Container(),

              Align(
                alignment: Alignment.topRight,
                child: Container(
                  alignment: Alignment.center,
                  height: 35,
                  width: 90,
                  decoration:const BoxDecoration(
                    color: vikingColor,
                    borderRadius:  BorderRadius.only(bottomLeft:Radius.circular(15),topRight: Radius.circular(10))
                  ),
                  child: Text( '${postEntity.budget} P',style:const TextStyle(
                    color: Colors.white
                  ),),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 180,
                    child: Text(
                      postEntity.title,
                      maxLines: 2,
                      //overflow: TextOverflow.ellipsis,
                      style:const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: "GloryRegular", fontSize: 16),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 15,
                bottom: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(postEntity.city,style:const TextStyle(
                          color: Colors.white,
                          fontSize: 13
                        ),),
                       const SizedBox(width: 5),
                        SvgPicture.asset('assets/images/ic_location_white.svg')
                      ],
                    ),
                   const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text( getPostDateFormat(postEntity.executionDate),style:const TextStyle(
                            color: Colors.white,
                            fontSize: 13
                        ),),
                        const SizedBox(width: 5),
                        SvgPicture.asset('assets/images/ic_calendar_white.svg',width: 15,)
                      ],
                    ),


                  ],
                ),
              )


            ]),


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
