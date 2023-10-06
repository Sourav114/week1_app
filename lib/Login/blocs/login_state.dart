abstract class SignInState{}

class SignInInitialState extends SignInState{}

class SignInValidState extends SignInState{}

class SignInErrorState extends SignInState{
  final String errorMessage;
  SignInErrorState(this.errorMessage);
}

class SignInLoadingState extends SignInState{}