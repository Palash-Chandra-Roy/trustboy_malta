// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'addon_model.dart';
import 'currencies_model.dart';
import 'languages_model.dart';
import 'maintainance_mode_model.dart';
import 'setting_model.dart';
import 'splash_model.dart';

class WebsiteSetupModel extends Equatable {
  final SettingModel? setting;
  final List<CurrenciesModel>? currencyList;
  final List<LanguagesModel>? languageList;
  final MaintainTextModel? maintainTextModel;
  final SplashModel? splash;
  final AddonModel? addons;
  final Map<String, String>? localizations;

  const WebsiteSetupModel({
    required this.setting,
    required this.currencyList,
    required this.languageList,
    required this.maintainTextModel,
    required this.splash,
    required this.addons,
    required this.localizations,
  });

  WebsiteSetupModel copyWith({
    SettingModel? setting,
    List<CurrenciesModel>? currencyList,
    List<LanguagesModel>? languageList,
    MaintainTextModel? maintainTextModel,
    SplashModel? splash,
    AddonModel? addons,
    Map<String, String>? localizations,
    //PusherInfo? pusherInfo,
  }) {
    return WebsiteSetupModel(
      setting: setting ?? this.setting,
      currencyList: currencyList ?? this.currencyList,
      languageList: languageList ?? this.languageList,
      splash: splash ?? this.splash,
      addons: addons ?? this.addons,
      maintainTextModel: maintainTextModel ?? this.maintainTextModel,
      localizations: localizations ?? this.localizations,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'setting': setting?.toMap(),
      'currency_list': currencyList?.map((x) => x.toMap()).toList(),
      'language_list': languageList?.map((x) => x.toMap()).toList(),
    };
  }

  factory WebsiteSetupModel.fromMap(Map<String, dynamic> map) {
    return WebsiteSetupModel(
      setting: map['setting'] != null
          ? SettingModel.fromMap(map['setting'] as Map<String, dynamic>)
          : null,
      currencyList: map['currency_list'] != null
          ? List<CurrenciesModel>.from(
              (map['currency_list'] as List<dynamic>).map<CurrenciesModel>(
                (x) => CurrenciesModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      languageList: map['language_list'] != null
          ? List<LanguagesModel>.from(
              (map['language_list'] as List<dynamic>).map<LanguagesModel>(
                (x) => LanguagesModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      splash: map['splash_screens'] != null
          ? SplashModel.fromMap(
              map['splash_screens'] as Map<String, dynamic>)
          : null,
      addons: map['addons'] != null
          ? AddonModel.fromMap(
              map['addons'] as Map<String, dynamic>)
          : null,
      maintainTextModel: map['maintainance'] != null
          ? MaintainTextModel.fromMap(
              map['maintainance'] as Map<String, dynamic>)
          : null,
      localizations: map['localizations'] != null
          ? Map<String, String>.from(map['localizations'] as Map)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WebsiteSetupModel.fromJson(String source) =>
      WebsiteSetupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [setting, currencyList, languageList, localizations,splash,addons];
  }
}
