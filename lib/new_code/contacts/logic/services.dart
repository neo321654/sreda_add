import 'package:dartz/dartz.dart';
import '/new_code/common/functional.dart';
import '/new_code/contacts/logic/api/api.dart';
import '/new_code/contacts/logic/api/entities.dart';

typedef ContactsGetter = Future<Either<Exception, Contacts>> Function(int id);
typedef BoughtContactChecker = Future<Either<Exception, bool>> Function(int id);

ContactsGetter newContactsGetter(APIContactsGetter getContacts) => (id) => withExceptionHandling(() => getContacts(id));
BoughtContactChecker newBoughtContactChecker(APIBoughtContactChecker check) =>
    (id) => withExceptionHandling(() => check(id));
