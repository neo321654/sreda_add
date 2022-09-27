import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';

class SimpleFutureBuilder<Success> extends StatelessWidget {
  final Future<dartz.Either<Exception, Success>> future;
  final Widget loading;
  final Widget Function(BuildContext, Exception) errorBuilder;
  final Widget Function(BuildContext, Success) loadedBuilder;
  const SimpleFutureBuilder({
    Key? key,
    required this.future,
    required this.loading,
    required this.errorBuilder,
    required this.loadedBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dartz.Either<Exception, Success>>(
      future: future,
      builder: (context, snapshot) => snapshot.data == null
          ? loading
          : snapshot.data!.fold(
              (exception) => errorBuilder(context, exception),
              (success) => loadedBuilder(context, success),
            ),
    );
  }
}
