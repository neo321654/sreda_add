part of "welcome_screen_cubit.dart";

abstract class WelcomeScreenState extends Equatable {
  const WelcomeScreenState();
}

class WelcomeScreenInitial extends WelcomeScreenState {
  @override
  List get props => [];
}

class WelcomeScreenLoading extends WelcomeScreenState {
  @override
  List get props => [];
}

class WelcomeScreenError extends WelcomeScreenState {
  final String errorMessage;
  @override
  List get props => [errorMessage];
  const WelcomeScreenError(this.errorMessage);
}

class WelcomeScreenSuccess extends WelcomeScreenState {
  @override
  List get props => [];
}
