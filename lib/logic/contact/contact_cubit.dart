import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/errors/failure.dart';

import '../../data/data_provider/remote_url.dart';
import '../../data/models/contact/contact_us_model.dart';
import '../../presentation/errors/errors_model.dart';
import '../../presentation/utils/utils.dart';
import '../bloc/login/login_bloc.dart';
import '../repository/setting_repository.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactUsModel> {

  final SettingRepository _repository;
  final LoginBloc _loginBloc;


  ContactUsModel? contact;
  List<ContactUsModel>? faqs = [];

  ContactCubit(
      {required SettingRepository repository,
        required LoginBloc loginBloc})
      : _repository = repository,
        _loginBloc = loginBloc,
        super(ContactUsModel());


  Future<void> getContactUs() async {
      emit(state.copyWith(contactState: ContactDataLoading()));
      final uri = Utils.tokenWithCode(RemoteUrls.contact(ContactType.contactUs), _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode,extraParams: {'_method':'GET'});
      final result = await _repository.getContactUs(uri,null);
      result.fold((failure) {
        final errorState = ContactDataError(failure.message, failure.statusCode);
        emit(state.copyWith(contactState: errorState));
      }, (success) {
        contact = success;
        final successState = ContactDataLoaded(success);
        emit(state.copyWith(contactState: successState));
      });
  }

  Future<void> subContactUs() async {
    emit(state.copyWith(contactState: ContactLoading()));
    final uri = Utils.tokenWithCode(RemoteUrls.contact(ContactType.submitContact), _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode,extraParams: {'_method':'POST'});
    final result = await _repository.submitContact(uri,state);
    result.fold((failure) {
    if(failure is InvalidAuthData){
      final errorState = ContactFormError(failure.errors);
      emit(state.copyWith(contactState: errorState));
    }else{
      final errorState = ContactError(failure.message, failure.statusCode);
      emit(state.copyWith(contactState: errorState));
    }
    }, (success) {
      final successState = ContactLoaded(success);
      emit(state.copyWith(contactState: successState));
    });
  }

  Future<void> getFaqsUs() async {
    emit(state.copyWith(contactState: ContactDataLoading()));
    final uri = Utils.tokenWithCode(RemoteUrls.contact(ContactType.faqs), _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode,extraParams: {'_method':'GET'});
    final result = await _repository.getFaqs(uri);
    result.fold((failure) {
      final errorState = ContactDataError(failure.message, failure.statusCode);
      emit(state.copyWith(contactState: errorState));
    }, (success) {
      faqs = success;
      final successState = ContactFaqsLoaded(success);
      emit(state.copyWith(contactState: successState));
    });
  }

  void addName(String text)=> emit(state.copyWith(question: text,contactState: ContactInitial()));
  void addEmail(String text)=> emit(state.copyWith(email: text,contactState: ContactInitial()));
  void addPhone(String text)=> emit(state.copyWith(phone: text,contactState: ContactInitial()));
  void addSubject(String text)=> emit(state.copyWith(phone2: text,contactState: ContactInitial()));
  void addMessage(String text)=> emit(state.copyWith(description: text,contactState: ContactInitial()));


  void initState() {
    emit(state.copyWith(contactState: const ContactInitial()));
  }

  void clearField(){
    emit(ContactUsModel());
  }

}
