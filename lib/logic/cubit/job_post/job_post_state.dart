part of 'job_post_cubit.dart';

sealed class JobPostState extends Equatable {
  const JobPostState();
  @override
  List<Object?> get props => [];
}

final class JobPostInitial extends JobPostState {
  const JobPostInitial();
}

final class JobPostLoading extends JobPostState {}

final class JobPostError extends JobPostState {
  final String message;
  final int statusCode;

  const JobPostError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class JobPostLoaded extends JobPostState {
  final JobPostModel jobPost;

  const JobPostLoaded(this.jobPost);

  @override
  List<Object> get props => [jobPost];
}

final class JobPostInfoLoaded extends JobPostState {
  final JobCreateInfo jobPost;

  const JobPostInfoLoaded(this.jobPost);

  @override
  List<Object> get props => [jobPost];
}

final class JobPostReqLoading extends JobPostState {}

final class JobPostReqLoaded extends JobPostState {
  final List<ApplicationModel> jobPost;

  const JobPostReqLoaded(this.jobPost);

  @override
  List<Object> get props => [jobPost];
}

final class JobPostReqError extends JobPostState {
  final String message;
  final int statusCode;

  const JobPostReqError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class JobPostReqDetailsLoading extends JobPostState {}

final class JobPostReqDetailsLoaded extends JobPostState {
  final ApplicationModel jobPost;

  const JobPostReqDetailsLoaded(this.jobPost);

  @override
  List<Object> get props => [jobPost];
}


//apply for a job
final class JobPostApplyFormError extends JobPostState {
  final Errors errors;

  const JobPostApplyFormError(this.errors);

  @override
  List<Object> get props => [errors];
}

final class JobPostApplyLoaded extends JobPostState {
  final String message;

  const JobPostApplyLoaded(this.message);

  @override
  List<Object> get props => [message];
}

final class JobPostApplyError extends JobPostState {
  final String message;
  final int statusCode;

  const JobPostApplyError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

//delete job post
final class JobPostDeleteError extends JobPostState {
  final String message;
  final int statusCode;

  const JobPostDeleteError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class JobPostDeleteLoading extends JobPostState {}

final class JobPostDeleteLoaded extends JobPostState {
  final String message;

  const JobPostDeleteLoaded(this.message);

  @override
  List<Object> get props => [message];
}



//Details
final class JobPostDetailsError extends JobPostState {
  final String message;
  final int statusCode;

  const JobPostDetailsError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class JobPostDetailsLoaded extends JobPostState {
  final JobPostItem jobPost;

  const JobPostDetailsLoaded(this.jobPost);

  @override
  List<Object> get props => [jobPost];
}


//add/update job post
final class JobPostAddingLoading extends JobPostState {}

final class JobPostAddError extends JobPostState {
  final String message;
  final int statusCode;

  const JobPostAddError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class JobPostAddFormError extends JobPostState {
  final Errors errors;

  const JobPostAddFormError(this.errors);

  @override
  List<Object> get props => [errors];
}

final class JobPostAddedLoaded extends JobPostState {
  final String message;
  final JobCreateInfo? jobPost;

  const JobPostAddedLoaded(this.message,this.jobPost);

  @override
  List<Object?> get props => [message,jobPost];

}

//edit job post
final class JobPostEditLoading extends JobPostState {}

final class JobPostEditError extends JobPostState {
  final String message;
  final int statusCode;

  const JobPostEditError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class JobPostEditLoaded extends JobPostState {
  final JobCreateInfo? jobPost;

  const JobPostEditLoaded(this.jobPost);

  @override
  List<Object?> get props => [jobPost];

}

