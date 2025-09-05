import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../logic/bloc/login/login_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/home/home_model.dart';
import '../../repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  final LoginBloc _loginBloc;

  HomeCubit({
    required HomeRepository homeRepository,
    required LoginBloc loginBloc,
  })  : _homeRepository = homeRepository,
        _loginBloc = loginBloc,
        super(const HomeInitial()) {
    getHomeData(_loginBloc.state.langCode);
  }

  HomeModel? homeModel;


  Future<void> getHomeData(String code) async {
    final uri = Uri.parse(RemoteUrls.homeUrl).replace(queryParameters: {'lang_code': code});
    emit(HomeStateLoading());
    final result = await _homeRepository.getHomeData(uri);
    result.fold((failure) {
      final errorState = HomeStateError(failure.message, failure.statusCode);
      emit(errorState);
    }, (success) {
      homeModel = success;
      final successState = HomeStateLoaded(success);
      emit(successState);
    });
  }

}
