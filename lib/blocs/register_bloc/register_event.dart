abstract class RegisterEvent {}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  RegisterEmailChanged(this.email);
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  RegisterPasswordChanged(this.password);
}

class RegisterUsernameChanged extends RegisterEvent {
  final String username;

  RegisterUsernameChanged(this.username);
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;

  RegisterConfirmPasswordChanged(this.confirmPassword);
}

class RegisterSubmitted extends RegisterEvent {}

class RegisterSuccessEvent extends RegisterEvent {}
