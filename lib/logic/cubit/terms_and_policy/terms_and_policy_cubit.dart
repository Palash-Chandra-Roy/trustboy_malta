import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/bloc/login/login_bloc.dart';
import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/terms_conditions/terms_conditions.dart';
import '../../repository/setting_repository.dart';
import 'terms_and_policy_state.dart';


class TermsAndPolicyCubit extends Cubit<TermsConditionsModel> {
  final SettingRepository _repository;
  final LoginBloc _loginBloc;

  TermsAndPolicyCubit({
    required SettingRepository repository,
    required LoginBloc loginBloc,
  })  : _repository = repository,
        _loginBloc = loginBloc,
        super(const TermsConditionsModel());

  TermsConditionsModel? termsConditionsModel;

  Future<void> termsAndConditions() async {
    emit(state.copyWith(termState: TermsAndPolicyStateLoading()));

    final uri = Uri.parse(RemoteUrls.termsConditions)
        .replace(queryParameters: {'lang_code': _loginBloc.state.langCode});
    final result = await _repository.termsAndConditions(uri);
    result.fold((failure) {
      final errorState =
          TermsAndPolicyStateError(failure.message, failure.statusCode);
      emit(state.copyWith(termState: errorState));
    }, (success) {
      termsConditionsModel = success;
      final successState = TermsAndPolicyStateLoaded(success);
      emit(state.copyWith(termState: successState));
    });
  }

  Future<void> privacyPolicy() async {
    final uri = Uri.parse(RemoteUrls.privacyPolicy)
        .replace(queryParameters: {'lang_code': _loginBloc.state.langCode});
    emit(state.copyWith(termState: TermsAndPolicyStateLoading()));
    final result = await _repository.privacyPolicy(uri);
    result.fold((failure) {
      final errorState =
          TermsAndPolicyStateError(failure.message, failure.statusCode);
      emit(state.copyWith(termState: errorState));
    }, (success) {
      termsConditionsModel = success;
      final successState = TermsAndPolicyStateLoaded(success);
      emit(state.copyWith(termState: successState));
    });
  }
}
