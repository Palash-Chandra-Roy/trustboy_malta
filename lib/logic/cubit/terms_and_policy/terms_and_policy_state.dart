import 'package:equatable/equatable.dart';

import '../../../data/models/terms_conditions/terms_conditions.dart';

abstract class TermsAndPolicyState extends Equatable {
  const TermsAndPolicyState();

  @override
  List<Object> get props => [];
}

class TermsAndPolicyInitial extends TermsAndPolicyState {
  const TermsAndPolicyInitial();

  @override
  List<Object> get props => [];
}

class TermsAndPolicyStateLoading extends TermsAndPolicyState {}

class TermsAndPolicyStateLoaded extends TermsAndPolicyState {
  final TermsConditionsModel termsConditionsModel;

  const TermsAndPolicyStateLoaded(this.termsConditionsModel);

  @override
  List<Object> get props => [termsConditionsModel];
}


class TermsAndPolicyStateError extends TermsAndPolicyState {
  final String message;
  final int statusCode;

  const TermsAndPolicyStateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}









