import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/refund/refund_item.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/profile_repository.dart';

part 'refund_state.dart';

class RefundCubit extends Cubit<RefundItem> {

  final ProfileRepository _repository;
  final LoginBloc _loginBloc;

  RefundCubit({
    required ProfileRepository repository,
    required LoginBloc loginBloc,
  })  : _repository = repository,
        _loginBloc = loginBloc,
        super(RefundItem.init());

  List<RefundItem> refunds = [];

  Future<void> getRefunds() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      emit(state.copyWith(refundState: RefundLoading()));
      final uri = Utils.tokenWithCode(RemoteUrls.buyerRefunds,
          _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode);

      final result = await _repository.getRefunds(uri);
      result.fold((failure) {
        final errorState =
        RefundStateError(failure.message, failure.statusCode);
        emit(state.copyWith(refundState: errorState));
      }, (success) {
        refunds = success;
        final successState = RefundLoaded(success);
        emit(state.copyWith(refundState: successState));
      });
    }
  }

}
