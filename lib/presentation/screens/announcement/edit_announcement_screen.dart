import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/data/api/constants.dart';
import '/presentation/bloc/create_post/edit_post_cubit.dart';
import '/presentation/colors.dart';
import '/presentation/widgets/base_text_field.dart';
import '/presentation/widgets/custom_dialog_box.dart';
import '/presentation/widgets/submit_button.dart';

import '../../../new_code/common/app_bar.dart';
import '../../widgets/loading.dart';

class EditAnnouncementScreen extends StatefulWidget {
  final int postId;
  final String postTitle;
  final int postBudget;
  final String postDetails;
  final List<String> postPhotos;

  EditAnnouncementScreen({
    Key? key,
    required this.postId,
    required this.postTitle,
    required this.postBudget,
    required this.postDetails,
    required this.postPhotos,
  }) : super(key: key);

  @override
  State<EditAnnouncementScreen> createState() => _EditAnnouncementScreenState();
}

class _EditAnnouncementScreenState extends State<EditAnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar('Редактировать'.tr()),
      body: BodyWidget(
        postId: widget.postId,
        postTitle: widget.postTitle,
        postBudget: widget.postBudget,
        postDetails: widget.postDetails,
        postPhotos: widget.postPhotos,
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  final int postId;
  final String postTitle;
  final int postBudget;
  final String postDetails;
  final List<String> postPhotos;

  BodyWidget({
    Key? key,
    required this.postId,
    required this.postTitle,
    required this.postBudget,
    required this.postDetails,
    required this.postPhotos,
  }) : super(key: key);

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<File> photo = [];
  List<dynamic> photoList = [];
  late EditPostCubit bloc;

  @override
  void initState() {
    bloc = EditPostCubit();
    photoList = widget.postPhotos;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.postTitle;
    budgetController.text = widget.postBudget.toString();
    descriptionController.text = widget.postDetails;
    return Provider.value(
        value: bloc,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BaseTextField(
                    controller: titleController,
                    title: "Название объявления".tr(),
                    hintText: "Введите название объявления",
                    inputType: TextInputType.text,
                    isVisibleTitle: true,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: BaseTextField(
                          controller: budgetController,
                          title: "Бюджет".tr(),
                          hintText: "Введите бюджет за проект",
                          inputType: TextInputType.number,
                          isVisibleTitle: true,
                          textAlign: TextAlign.start,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: photo.isNotEmpty,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: photo.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.file(
                                        File(photo[index].path),
                                        width: 110,
                                        height: 110,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 4, top: 10),
                                        child: GestureDetector(
                                            onTap: () {
                                              photo.removeAt(index);
                                              setState(() {
                                                photo;
                                              });
                                            },
                                            child: Icon(Icons.close)),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: ReorderableListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photoList.length,
                      onReorder: ((oldIndex, newIndex) {
                        setState(() {
                          _updateMyItems(oldIndex, newIndex);
                        });
                      }),
                      itemBuilder: (context, index) {
                        return Padding(
                          key: ValueKey(photoList[index]),
                          padding: EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: photoList[index].contains('media/posts/')
                                    ? Image.network(
                                        getProfileLinkPhoto(
                                          photoList[index],
                                        ),
                                        width: 110,
                                        height: 110,
                                      )
                                    : Image.file(
                                        File(photoList[index]),
                                        width: 110,
                                        height: 110,
                                      ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 4,
                                    top: 10,
                                  ),
                                  child: GestureDetector(
                                      onTap: () {
                                        photoList.removeAt(index);
                                        setState(() {
                                          photoList;
                                        });
                                      },
                                      child: Icon(Icons.close)),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    color: vikingColor,
                    strokeWidth: 1,
                    child: GestureDetector(
                      onTap: () async {
                        _getImageFromGallery();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0x1A1B877E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "+ Загрузите фото".tr(),
                            textAlign: TextAlign.center,
                            style:const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "GloryMedium",
                                color: mineShaft2GrayColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                 const SizedBox(height: 18.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Другие детали'.tr(),
                      style:const TextStyle(
                        color: grey,
                        fontFamily: 'GloryRegular',
                        fontSize: 14.0,
                        height: 18.0 / 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    maxLines: 5,
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: "",
                        contentPadding: EdgeInsets.all(15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: borderGreyColor,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: silverGrayColor,
                            width: 1.5,
                          ),
                        )),
                  ),
                  SizedBox(height: 18.0),
                  HttpResultWidget(),
                  SizedBox(height: 14.0),
                  SubmitButton(
                    onTap: () {
                      bloc.deletePost(postId: widget.postId);
                      // Navigator.pop(context, true);
                    },
                    textButton: "Удалить".tr(),
                    borderColor: Color(0xffFF3D00),
                    textColor: Color(0xffFF3D00),
                  ),
                  SizedBox(height: 14.0),
                  SubmitButton(
                    textButton: "Сохранить".tr(),
                    onTap: () {
                      bloc.updatePost(widget.postId, titleController.text, budgetController.text,
                          descriptionController.text, photoList);
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _updateMyItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = photoList.removeAt(oldIndex);
    photoList.insert(newIndex, item);
  }

  String getLinkPhoto(String link) {
    return (ApiConstants.BASE_URL_IMAGE + "/media/" + link.replaceAll(ApiConstants.TO_REPLACE_LINK_WHITH_HTTP, ""));
  }

  Future<void> _getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    var photo = await picker.pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
    String photoPath = File(photo!.path).toString().substring(6).replaceAll("'", "");

    photoList.add(photoPath);
    setState(() {
      photoList;
    });
  }
}

class HttpResultWidget extends StatelessWidget {
  HttpResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditPostCubit, EditPostState>(
      listener: (context, state) {
        if (state is EditPostLocalErrorState) {
          buildShowDialog(context, state.message!.toString());
        } else if (state is EditPostErrorState) {
          buildShowDialog(context, state.message!.toString());
        } else if (state is EditPostSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is EditPostInitial) {
          return Text('');
        } else if (state is EditPostLoading) {
          return LoadingIndicator();
        } else {
          return Text('');
        }
      },
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Ошибка ввода".tr(),
            descriptions: message,
            text: "Ok",
          );
        });
  }
}

getProfileLinkPhoto(String? link) {
  if (link != null && link.isNotEmpty) {
    if (!link.contains(ApiConstants.TO_REPLACE_LINK)) {
      return ApiConstants.BASE_URL_IMAGE + '/media/' + link;
    } else {
      return link;
    }
  }
}
