import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/dashboard/dashboard_model.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/profile_repository.dart';

part 'dashboard_state.dart';

class DashBoardCubit extends Cubit<DashBoardState> {
  final LoginBloc _loginBloc;
  final ProfileRepository _profileRepository;

  DashboardModel? providerDashboard;


  DashBoardCubit({
    required LoginBloc loginBloc,
    required ProfileRepository profileRepository,
  })  : _loginBloc = loginBloc,
        _profileRepository = profileRepository,
        super(const DashBoardInitial());


  Future<void> getDashBoard() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      emit( DashBoardStateLoading());
      final uri = Utils.tokenWithCode(RemoteUrls.dashboard(_loginBloc.userInformation?.user?.isSeller == 1),
          _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode);

      final result = await _profileRepository.providerDashBoard(uri);
      result.fold(
            (failure) {
          final errors = DashBoardStateError(message: failure.message, status: failure.statusCode);
          emit(errors);
        },
            (data) {
          providerDashboard = data;
          final loaded = DashBoardStateLoaded(providerDashBoard: data);
          emit(loaded);
        },
      );
    }
  }

  void initState() {
    emit(const DashBoardInitial());
  }
}
