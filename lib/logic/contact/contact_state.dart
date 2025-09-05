part of 'contact_cubit.dart';

sealed class ContactState extends Equatable {
  const ContactState();
  @override
  List<Object?> get props => [];
}

final class ContactInitial extends ContactState {
    const ContactInitial();
}


class ContactLoading extends ContactState {
  const ContactLoading();
}

class ContactLoaded extends ContactState {
  final String? message;

  const ContactLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactError extends ContactState {
  final String message;
  final int statusCode;

  const ContactError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class ContactFormError extends ContactState {
  final Errors errors;

  const ContactFormError(this.errors);

  @override
  List<Object> get props => [errors];
}



///contact data
class ContactDataLoading extends ContactState {
  const ContactDataLoading();
}

class ContactDataLoaded extends ContactState {
  final ContactUsModel? message;

  const ContactDataLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactDataError extends ContactState {
  final String message;
  final int statusCode;

  const ContactDataError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class ContactFaqsLoaded extends ContactState {
  final List<ContactUsModel>? faqs;

  const ContactFaqsLoaded(this.faqs);

  @override
  List<Object?> get props => [faqs];
}