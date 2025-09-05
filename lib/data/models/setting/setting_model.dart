import 'dart:convert';

import 'package:equatable/equatable.dart';

class SettingModel extends Equatable {
  final String logo;
  final String favicon;
  final String appName;
  final String contactMessageMail;
  final String timezone;
  final String selectedTheme;
  final int recaptchaStatus;
  final String recaptchaSiteKey;
  final String recaptchaSecretKey;
  final String tawkChatLink;
  final int tawkStatus;
  final String googleAnalyticId;
  final String googleAnalyticStatus;
  final String pixelAppId;
  final int pixelStatus;
  final String placeholderImage;
  final String cookieConsentStatus;
  final String cookieConsentMessage;
  final String errorImage;
  final String loginPageBg;
  final String adminLogin;
  final String breadcrumbImage;
  final int isFacebook;
  final String facebookClientId;
  final String facebookSecretId;
  final String facebookRedirectUrl;
  final int isGmail;
  final String gmailClientId;
  final String gmailSecretId;
  final String gmailRedirectUrl;
  final String defaultAvatar;
  final String defaultCoverImage;
  final int maintenanceStatus;
  final String maintenanceImage;
  final String maintenanceText;
  final String appVersion;
  final String facebookLink;
  final String twitterLink;
  final String linkedinLink;
  final String instagramLink;
  final String footerLogo;
  final String emptyImage;
  final String notFound;
  final String commissionType;
  final int commissionPerSale;

  const SettingModel({
    required this.logo,
    required this.favicon,
    required this.appName,
    required this.contactMessageMail,
    required this.timezone,
    required this.selectedTheme,
    required this.recaptchaStatus,
    required this.recaptchaSiteKey,
    required this.recaptchaSecretKey,
    required this.tawkChatLink,
    required this.tawkStatus,
    required this.googleAnalyticId,
    required this.googleAnalyticStatus,
    required this.pixelAppId,
    required this.pixelStatus,
    required this.placeholderImage,
    required this.cookieConsentStatus,
    required this.cookieConsentMessage,
    required this.errorImage,
    required this.loginPageBg,
    required this.adminLogin,
    required this.breadcrumbImage,
    required this.isFacebook,
    required this.facebookClientId,
    required this.facebookSecretId,
    required this.facebookRedirectUrl,
    required this.isGmail,
    required this.gmailClientId,
    required this.gmailSecretId,
    required this.gmailRedirectUrl,
    required this.defaultAvatar,
    required this.defaultCoverImage,
    required this.maintenanceStatus,
    required this.maintenanceImage,
    required this.maintenanceText,
    required this.appVersion,
    required this.facebookLink,
    required this.twitterLink,
    required this.linkedinLink,
    required this.instagramLink,
    required this.footerLogo,
    required this.emptyImage,
    required this.notFound,
    required this.commissionType,
    required this.commissionPerSale,
  });

  SettingModel copyWith({
    String? logo,
    String? favicon,
    String? appName,
    String? contactMessageMail,
    String? timezone,
    String? selectedTheme,
    int? recaptchaStatus,
    String? recaptchaSiteKey,
    String? recaptchaSecretKey,
    String? tawkChatLink,
    int? tawkStatus,
    String? googleAnalyticId,
    String? googleAnalyticStatus,
    String? pixelAppId,
    int? pixelStatus,
    String? placeholderImage,
    String? cookieConsentStatus,
    String? cookieConsentMessage,
    String? errorImage,
    String? loginPageBg,
    String? adminLogin,
    String? breadcrumbImage,
    int? isFacebook,
    String? facebookClientId,
    String? facebookSecretId,
    String? facebookRedirectUrl,
    int? isGmail,
    String? gmailClientId,
    String? gmailSecretId,
    String? gmailRedirectUrl,
    String? defaultAvatar,
    String? defaultCoverImage,
    int? maintenanceStatus,
    String? maintenanceImage,
    String? maintenanceText,
    String? appVersion,
    String? facebookLink,
    String? twitterLink,
    String? linkedinLink,
    String? instagramLink,
    String? footerLogo,
    String? emptyImage,
    String? notFound,
    String? commissionType,
    int? commissionPerSale,
  }) {
    return SettingModel(
      logo: logo ?? this.logo,
      favicon: favicon ?? this.favicon,
      appName: appName ?? this.appName,
      contactMessageMail: contactMessageMail ?? this.contactMessageMail,
      timezone: timezone ?? this.timezone,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      recaptchaStatus: recaptchaStatus ?? this.recaptchaStatus,
      recaptchaSiteKey: recaptchaSiteKey ?? this.recaptchaSiteKey,
      recaptchaSecretKey: recaptchaSecretKey ?? this.recaptchaSecretKey,
      tawkChatLink: tawkChatLink ?? this.tawkChatLink,
      tawkStatus: tawkStatus ?? this.tawkStatus,
      googleAnalyticId: googleAnalyticId ?? this.googleAnalyticId,
      googleAnalyticStatus: googleAnalyticStatus ?? this.googleAnalyticStatus,
      pixelAppId: pixelAppId ?? this.pixelAppId,
      pixelStatus: pixelStatus ?? this.pixelStatus,
      placeholderImage: placeholderImage ?? this.placeholderImage,
      cookieConsentStatus: cookieConsentStatus ?? this.cookieConsentStatus,
      cookieConsentMessage: cookieConsentMessage ?? this.cookieConsentMessage,
      errorImage: errorImage ?? this.errorImage,
      loginPageBg: loginPageBg ?? this.loginPageBg,
      adminLogin: adminLogin ?? this.adminLogin,
      breadcrumbImage: breadcrumbImage ?? this.breadcrumbImage,
      isFacebook: isFacebook ?? this.isFacebook,
      facebookClientId: facebookClientId ?? this.facebookClientId,
      facebookSecretId: facebookSecretId ?? this.facebookSecretId,
      facebookRedirectUrl: facebookRedirectUrl ?? this.facebookRedirectUrl,
      isGmail: isGmail ?? this.isGmail,
      gmailClientId: gmailClientId ?? this.gmailClientId,
      gmailSecretId: gmailSecretId ?? this.gmailSecretId,
      gmailRedirectUrl: gmailRedirectUrl ?? this.gmailRedirectUrl,
      defaultAvatar: defaultAvatar ?? this.defaultAvatar,
      defaultCoverImage: defaultCoverImage ?? this.defaultCoverImage,
      maintenanceStatus: maintenanceStatus ?? this.maintenanceStatus,
      maintenanceImage: maintenanceImage ?? this.maintenanceImage,
      maintenanceText: maintenanceText ?? this.maintenanceText,
      appVersion: appVersion ?? this.appVersion,
      facebookLink: facebookLink ?? this.facebookLink,
      twitterLink: twitterLink ?? this.twitterLink,
      linkedinLink: linkedinLink ?? this.linkedinLink,
      instagramLink: instagramLink ?? this.instagramLink,
      footerLogo: footerLogo ?? this.footerLogo,
      emptyImage: emptyImage ?? this.emptyImage,
      notFound: notFound ?? this.notFound,
      commissionType: commissionType ?? this.commissionType,
      commissionPerSale: commissionPerSale ?? this.commissionPerSale,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'logo': logo,
      'favicon': favicon,
      'app_name': appName,
      'contact_message_mail': contactMessageMail,
      'timezone': timezone,
      'selected_theme': selectedTheme,
      'recaptcha_status': recaptchaStatus,
      'recaptcha_site_key': recaptchaSiteKey,
      'recaptcha_secret_key': recaptchaSecretKey,
      'tawk_chat_link': tawkChatLink,
      'tawk_status': tawkStatus,
      'google_analytic_id': googleAnalyticId,
      'google_analytic_status': googleAnalyticStatus,
      'pixel_app_id': pixelAppId,
      'pixel_status': pixelStatus,
      'placeholder_image': placeholderImage,
      'cookie_consent_status': cookieConsentStatus,
      'cookie_consent_message': cookieConsentMessage,
      'error_image': errorImage,
      'login_page_bg': loginPageBg,
      'admin_login': adminLogin,
      'breadcrumb_image': breadcrumbImage,
      'is_facebook': isFacebook,
      'facebook_client_id': facebookClientId,
      'facebook_secret_id': facebookSecretId,
      'facebook_redirect_url': facebookRedirectUrl,
      'is_gmail': isGmail,
      'gmail_client_id': gmailClientId,
      'gmail_secret_id': gmailSecretId,
      'gmail_redirect_url': gmailRedirectUrl,
      'default_avatar': defaultAvatar,
      'default_cover_image': defaultCoverImage,
      'maintenance_status': maintenanceStatus,
      'maintenance_image': maintenanceImage,
      'maintenance_text': maintenanceText,
      'app_version': appVersion,
      'facebook_link': facebookLink,
      'twitter_link': twitterLink,
      'linkedin_link': linkedinLink,
      'instagram_link': instagramLink,
      'footer_logo': footerLogo,
      'empty_image': emptyImage,
      'not_found': notFound,
      'commission_type': commissionType,
      'commission_per_sale': commissionPerSale,
    };
  }

  factory SettingModel.fromMap(Map<String, dynamic> map) {
    return SettingModel(
      logo: map['logo'] ?? '',
      favicon: map['favicon'] ?? '',
      appName: map['app_name'] ?? '',
      contactMessageMail: map['contact_message_mail'] ?? '',
      timezone: map['timezone'] ?? '',
      selectedTheme: map['selected_theme'] ?? '',
      recaptchaStatus: map['recaptcha_status'] != null? int.parse(map['recaptcha_status'].toString()):0,
      recaptchaSiteKey: map['recaptcha_site_key'] ?? '',
      recaptchaSecretKey: map['recaptcha_secret_key'] ?? '',
      tawkChatLink: map['tawk_chat_link'] ?? '',
      tawkStatus: map['tawk_status'] != null? int.parse(map['tawk_status'].toString()):0,
      googleAnalyticId: map['google_analytic_id'] ?? '',
      googleAnalyticStatus: map['google_analytic_status'] ?? '',
      pixelAppId: map['pixel_app_id'] ?? '',
      pixelStatus: map['pixel_status'] != null? int.parse(map['pixel_status'].toString()):0,
      placeholderImage: map['placeholder_image'] ?? '',
      cookieConsentStatus: map['cookie_consent_status'] ?? '',
      cookieConsentMessage: map['cookie_consent_message'] ?? '',
      errorImage: map['error_image'] ?? '',
      loginPageBg: map['login_page_bg'] ?? '',
      adminLogin: map['admin_login'] ?? '',
      breadcrumbImage: map['breadcrumb_image'] ?? '',
      isFacebook: map['is_facebook'] != null? int.parse(map['is_facebook'].toString()):0,
      facebookClientId: map['facebook_client_id'] ?? '',
      facebookSecretId: map['facebook_secret_id'] ?? '',
      facebookRedirectUrl: map['facebook_redirect_url'] ?? '',
      isGmail: map['is_gmail'] != null? int.parse(map['is_gmail'].toString()):0,
      gmailClientId: map['gmail_client_id'] ?? '',
      gmailSecretId: map['gmail_secret_id'] ?? '',
      gmailRedirectUrl: map['gmail_redirect_url'] ?? '',
      defaultAvatar: map['default_avatar'] ?? '',
      defaultCoverImage: map['default_cover_image'] ?? '',
      maintenanceStatus: map['maintenance_status'] != null? int.parse(map['maintenance_status'].toString()):0,
      maintenanceImage: map['maintenance_image'] ?? '',
      maintenanceText: map['maintenance_text'] ?? '',
      appVersion: map['app_version'] ?? '',
      facebookLink: map['facebook_link'] ?? '',
      twitterLink: map['twitter_link'] ?? '',
      linkedinLink: map['linkedin_link'] ?? '',
      instagramLink: map['instagram_link'] ?? '',
      footerLogo: map['footer_logo'] ?? '',
      emptyImage: map['empty_image'] ?? '',
      notFound: map['not_found'] ?? '',
      commissionType: map['commission_type'] ?? '',
      commissionPerSale: map['commission_per_sale'] != null? int.parse(map['commission_per_sale'].toString()):0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingModel.fromJson(String source) =>
      SettingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      logo,
      favicon,
      appName,
      contactMessageMail,
      timezone,
      selectedTheme,
      recaptchaStatus,
      recaptchaSiteKey,
      recaptchaSecretKey,
      tawkChatLink,
      tawkStatus,
      googleAnalyticId,
      googleAnalyticStatus,
      pixelAppId,
      pixelStatus,
      placeholderImage,
      cookieConsentStatus,
      cookieConsentMessage,
      errorImage,
      loginPageBg,
      adminLogin,
      breadcrumbImage,
      isFacebook,
      facebookClientId,
      facebookSecretId,
      facebookRedirectUrl,
      isGmail,
      gmailClientId,
      gmailSecretId,
      gmailRedirectUrl,
      defaultAvatar,
      defaultCoverImage,
      maintenanceStatus,
      maintenanceImage,
      maintenanceText,
      appVersion,
      facebookLink,
      twitterLink,
      linkedinLink,
      instagramLink,
      footerLogo,
      emptyImage,
      notFound,
      commissionType,
      commissionPerSale,
    ];
  }
}
