import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/setting/currencies_model.dart';
import '../../../data/models/setting/languages_model.dart';
import 'currency_state_model.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyStateModel> {
  CurrencyCubit() : super(CurrencyStateModel.init());

  void addNewCurrency(CurrenciesModel newCurrency) {
    final updatedCurrencies = List.of(state.currencies)..add(newCurrency);
    emit(state.copyWith(currencies: updatedCurrencies));
  }

  void addNewLanguage(LanguagesModel newLanguage) {
    final updatedCurrencies = List<LanguagesModel>.from(state.languages)..add(newLanguage);
    emit(state.copyWith(languages: updatedCurrencies));
  }

  Future<void> getRealtimeCurrency() async {
    // emit(state.copyWith(currencyState: CurrencyRealtimeLoading()));
    // Either<Failure, double> result;
    // if (state.currencies.isNotEmpty) {
    //   result = await _repository.getRealtimeCurrency(
    //       state.currencies.first.currencyCode.toUpperCase());
    // } else {
    //   result = await _repository.getRealtimeCurrency('USD');
    // }
    // result.fold(
    //       (failure) {
    //     final errors = CurrencyRealtimeError(failure.message, failure.statusCode);
    //     emit(state.copyWith(currencyState:errors));
    //   },
    //       (data) {
    //     debugPrint('converted-price $data');
    //     debugPrint('first-item ${state.currencies.first.currencyRate}');
    //     final loaded = CurrencyRealtimeLoaded(data);
    //     emit(state.copyWith(currencyState: loaded,currencyRate: data));
    //   },
    // );
  }


  void clearLanguage() {
    if (state.languages.isNotEmpty) {
      // debugPrint('previous-lang-clear ${state.languages.first.langCode}');
      emit(state.copyWith(languages: <LanguagesModel>[]));
    }
  }

  void clearCurrency() {
    if (state.currencies.isNotEmpty) {
      // debugPrint('previous-lang-clear ${state.languages.first.langCode}');
      emit(state.copyWith(currencies: <CurrenciesModel>[]));
    }
  }
}
