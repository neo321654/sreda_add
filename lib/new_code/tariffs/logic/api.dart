import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '/data/api/constants.dart';
import '/new_code/common/api.dart';
import '/new_code/common/functional.dart';

typedef PurchaseHandler = Future<Either<Exception, void>> Function(String purchaseID);

const _purchasesUrl = ApiConstants.BASE_URL + "tariffs/purchases/";

PurchaseHandler newPurchaseHandler(Dio dio, BaseOptionsGetter getOptions) =>
    (purchaseId) => withExceptionHandling(() async {
          final options = await getOptions();
          print("requesting server for a purchase $purchaseId");
          await dio.post(
            _purchasesUrl,
            data: {"purchase_id": purchaseId},
            options: options.copyWith(
              contentType: "application/x-www-form-urlencoded",
              method: "POST",
            ),
          );
        });
