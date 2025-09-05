import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/data_provider/remote_url.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/auth_repository.dart';
import '../forgot_password/forgot_password_state_model.dart';

part 'delete_state.dart';

class DeleteCubit extends Cubit<PasswordStateModel> {
  final AuthRepository _repository;
  final LoginBloc _loginBloc;

  DeleteCubit({
    required AuthRepository repository,
    required LoginBloc loginBloc,
  })  : _repository = repository,
        _loginBloc = loginBloc,
        super(PasswordStateModel.init());

  void changeCurrentPassword(String text) {
    emit(state.copyWith(password: text, deleteState: const DeleteInitial()));
  }

  void showPassword() {
    emit(state.copyWith(showPassword: !state.showPassword, deleteState: const DeleteInitial()));
  }

  // void changeIndex(int index) {
  //   debugPrint('change-index $index');
  //   emit(state.copyWith(currentIndex: index));
  // }

  Future<void> deleteAccount() async {
    //debugPrint('email-body ${state.toMap()}');
   if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
       final uri = Utils.tokenWithCode(RemoteUrls.accountDelete(_loginBloc.userInformation?.user?.isSeller == 1), _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode,extraParams: {'_method': 'DELETE'});
       //debugPrint('delete-uri $uri');
      emit(state.copyWith(deleteState: const DeleteLoading()));
       final result = await _repository.deleteAccount(uri, state);
       result.fold(
             (failure) {
           if (failure is InvalidAuthData) {
             final errors = DeleteFormError(failure.errors);
             emit(state.copyWith(deleteState: errors));
           } else {
             final errors = DeleteError(failure.message, failure.statusCode);
             emit(state.copyWith(deleteState: errors));
           }
         },
             (data) {
           emit(state.copyWith(deleteState: DeleteLoaded(data)));
         },
       );
     }
  }

  void clear() {
    emit(state.clear());
  }
}
