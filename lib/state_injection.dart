import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logic/contact/contact_cubit.dart';
import 'logic/cubit/chat/chat_cubit.dart';
import 'logic/cubit/subscription/subscription_cubit.dart';
import 'logic/cubit/wallet/wallet_cubit.dart';
import 'logic/repository/chat_repository.dart';
import 'state_injection_packages.dart';
class StateInject {
  static late final SharedPreferences _sharedPreferences;

  static Future<void> initDB() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static final repositoryProvider = <RepositoryProvider>[
    RepositoryProvider<Client>(
      create: (context) => Client(),
    ),
    RepositoryProvider<SharedPreferences>(
      create: (context) => _sharedPreferences,
    ),
    RepositoryProvider<RemoteDataSources>(
      create: (context) => RemoteDataSourcesImpl(
        client: context.read(),
      ),
    ),
    RepositoryProvider<LocalDataSources>(
      create: (context) => LocalDataSourcesImpl(
        sharedPreferences: context.read(),
      ),
    ),
    RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepositoryImpl(
        remoteDataSources: context.read(),
        localDataSources: context.read(),
      ),
    ),
    RepositoryProvider<SettingRepository>(
      create: (context) => SettingRepositoryImpl(
        remoteDataSources: context.read(),
        localDataSources: context.read(),
      ),
    ),
    RepositoryProvider<HomeRepository>(
      create: (context) => HomeRepositoryImpl(
        remoteDataSource: context.read(),
      ),
    ),

    RepositoryProvider<ServiceRepository>(
      create: (context) => ServiceRepositoryImpl(
        remoteDataSource: context.read(),
      ),
    ),

    RepositoryProvider<ProfileRepository>(
      create: (context) => ProfileRepositoryImp(
        remoteDataSource: context.read(),
        localDataSource: context.read(),
      ),
    ),

    RepositoryProvider<JobPostRepository>(
      create: (context) => JobPostRepositoryImpl(
        remoteDataSource: context.read(),
      ),
    ),
    RepositoryProvider<OrderRepository>(
      create: (context) => OrderRepositoryImpl(
        remoteDataSource: context.read(),
      ),
    ),

    RepositoryProvider<PaymentRepository>(
      create: (context) => PaymentRepositoryImpl(
        remoteDataSource: context.read(),
      ),
    ),

    RepositoryProvider<WithdrawRepository>(
      create: (context) => WithdrawRepositoryImpl(
        remoteDataSources: context.read(),
      ),
    ),

    RepositoryProvider<ChatRepository>(
      create: (context) => ChatRepositoryImpl(
        remoteDataSource: context.read(),
      ),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<InternetStatusBloc>(create: (context) => InternetStatusBloc()),
    BlocProvider<SettingCubit>(
      create: (BuildContext context) =>
          SettingCubit(repository: context.read()),
    ),
    BlocProvider<CurrencyCubit>(create: (context) => CurrencyCubit()),
    BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(
        repository: context.read(),
      ),
    ),
    BlocProvider<SignUpBloc>(
      create: (BuildContext context) => SignUpBloc(
        authRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),


    BlocProvider<ForgotPasswordCubit>(
      create: (BuildContext context) => ForgotPasswordCubit(
        authRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<DeleteCubit>(
      create: (BuildContext context) => DeleteCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<HomeCubit>(
      create: (BuildContext context) => HomeCubit(
        homeRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<ProfileCubit>(
      create: (BuildContext context) => ProfileCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<ServiceDetailCubit>(
      create: (BuildContext context) => ServiceDetailCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<ServiceCubit>(
      create: (BuildContext context) => ServiceCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<ServiceListCubit>(
      create: (BuildContext context) => ServiceListCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<WishListCubit>(
      create: (BuildContext context) => WishListCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<TermsAndPolicyCubit>(
      create: (BuildContext context) => TermsAndPolicyCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<JobPostCubit>(
      create: (BuildContext context) => JobPostCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<BuyerOrderCubit>(
      create: (BuildContext context) => BuyerOrderCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<ChangePasswordCubit>(
      create: (BuildContext context) => ChangePasswordCubit(
        profileRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<DashBoardCubit>(
      create: (BuildContext context) => DashBoardCubit(
        profileRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<WithdrawCubit>(
      create: (BuildContext context) => WithdrawCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<RefundCubit>(
      create: (BuildContext context) => RefundCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<PaymentCubit>(
      create: (BuildContext context) => PaymentCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<KycCubit>(
      create: (BuildContext context) => KycCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<ChatCubit>(
      create: (BuildContext context) => ChatCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<SubscriptionCubit>(
      create: (BuildContext context) => SubscriptionCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<WalletCubit>(
      create: (BuildContext context) => WalletCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),

    BlocProvider<ContactCubit>(
      create: (BuildContext context) => ContactCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),
  ];
}
