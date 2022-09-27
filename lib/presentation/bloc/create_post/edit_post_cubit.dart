import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '/data/api/service/catch_exeptions.dart';
import '/di/post_di.dart';
import '/domain/repository/post_repository.dart';

part 'edit_post_state.dart';

class EditPostCubit extends Cubit<EditPostState> {
  EditPostCubit() : super(EditPostInitial());

  final PostRepository _repository = serviceDiPost<PostRepository>();
  String errorMessage = "";

  Future<void> deletePost({required int postId}) async {
    emit(EditPostLoading());
    _repository
        .deletePost(postId: postId)
        .then((value) => {emit(EditPostSuccess())})
        .catchError((onError) => {
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(EditPostErrorState(CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {emit(EditPostErrorState(CatchException.convertException(error)))});
  }

  Future<void> updatePost(int postId, String title, String budget, String description, List<dynamic> photoList) async {
    emit(EditPostLoading());
    List<File> resultPhotos = await mapperPhoto(photoList);
    await Future.delayed(const Duration(seconds: 2));
    _repository
        .updatePost(postId: postId, title: title, budget: budget, description: description, photoList: resultPhotos)
        .then((value) => {emit(EditPostSuccess())})
        .catchError((onError) => {
              if (onError.response.statusCode == 400)
                {
                  errorMessage = onError.response.data['detail'],
                },
              emit(EditPostErrorState(CatchException.convertException(onError)))
            })
        .onError((error, stackTrace) => {emit(EditPostErrorState(CatchException.convertException(error)))});
  }

  Future<List<File>> mapperPhoto(List<dynamic> photoList) async {
    List<File> resultPhotos = [];
    photoList.forEach((element) async {
      if (element is String) {
        if (element.toString().contains("media/posts/")) {
          var myFile = await _fileFromImageUrl(element);
          resultPhotos.add(myFile);
        } else {
          resultPhotos.add(File(element));
        }
      }
    });
    return resultPhotos;
  }

  Future<File> file(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  Future<File> _fileFromImageUrl(String url) async {
    final response = await Dio().get(url, options: Options(responseType: ResponseType.bytes, followRedirects: false));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(p.join(documentDirectory.path, '${generateRandomString(10)}.png'));
    file.writeAsBytesSync(response.data);

    return file;
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
  }
}
