import 'package:digibook/blocs/resetpass_bloc/resetpass_event.dart';
import 'package:digibook/blocs/resetpass_bloc/resetpass_state.dart';
import 'package:digibook/repositories/user_repository.dart';
import 'package:digibook/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RePassBloc extends Bloc<RePassEvent, RePassState> {
  final UserRepository _userRepository;

  RePassBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(RePassState.initial());

  @override
  Stream<RePassState> mapEventToState(RePassEvent event) async* {
    if (event is RePassEmailChanged) {
      yield* _mapRePassEmailChangeToState(event.email);
    } else if (event is RePassSubmitted) {
      yield* _mapRePassSubmittedToState(event.email);
    }
  }

  Stream<RePassState> _mapRePassEmailChangeToState(String email) async* {
    yield state.rePasswordUpdate(
        isRePassEmailValid: Validators.isValidEmail(email));
  }

  Stream<RePassState> _mapRePassSubmittedToState(String email) async* {
    yield RePassState.rePasswordLoading();
    try {
      await _userRepository.passwordReset(email);
      yield RePassState.rePasswordSuccess();
      yield RePassState.rePasswordSuccess();
    } catch (error) {
      yield RePassState.rePasswordFail();
    }
  }
}
