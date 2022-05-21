import 'package:equatable/equatable.dart';

abstract class RePassEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RePassEmailChanged extends RePassEvent {
  final String email;

  RePassEmailChanged({this.email});

  @override
  List<Object> get props => [email];
}

class RePassSubmitted extends RePassEvent {
  final String email;

  RePassSubmitted({this.email});

  @override
  List<Object> get props => [email];
}
