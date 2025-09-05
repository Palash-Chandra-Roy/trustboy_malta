import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:work_zone/data/models/order/order_item_model.dart';

import '../../data/models/auth/login_state_model.dart';
import '../../data/models/home/job_post.dart';
import '../../data/models/order/order_detail_model.dart';
import '../../data/models/setting/addon_model.dart';
import '../../data/models/setting/currencies_model.dart';
import '../../logic/bloc/login/login_bloc.dart';
import '../../logic/cubit/currency/currency_cubit.dart';
import '../../logic/cubit/setting/setting_cubit.dart';
import '../routes/route_names.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import '../widgets/primary_button.dart';
import 'constraints.dart';

class Utils {
  static final _selectedDate = DateTime.now();

  static final _initialTime = TimeOfDay.now();

  // static Future<bool> getStoragePermission(BuildContext context) async {
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     // print('permission denied');
  //     status = await Permission.storage.request();
  //   }
  //   return status.isGranted;
  // }

  // static Future<bool> _requestPermissions() async {
  //   var status = await Permission.storage.status;
  //   if (status.isDenied) {
  //     status = await Permission.storage.request();
  //   }
  //   return status.isGranted;
  // }

  // static Future<String> getDir() async {
  //   if (Platform.isAndroid) {
  //     Directory? directory;
  //     if (await _requestPermissions()) {
  //       if (Platform.version.compareTo('29') >= 0) {
  //         directory = await getExternalStorageDirectory();
  //       } else {
  //         directory = Directory('/storage/emulated/0/Download');
  //       }
  //       await directory?.create(recursive: true);
  //     }
  //     return directory?.path ?? '';
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  // }

  static String convertToSlug(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z\d]+'), '-');
  }

  static bool validateName(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z ]{1,30}$');
    return nameRegex.hasMatch(name);
  }


  static Future<bool> getStoragePermission() async {
    debugPrint('version ${Platform.operatingSystemVersion}');

    final storagePermission = await Permission.storage.request();
    final manageStoragePermission = await Permission.manageExternalStorage.request();

    if (storagePermission.isGranted || manageStoragePermission.isGranted) {
      return true;
    } else if (storagePermission.isPermanentlyDenied || manageStoragePermission.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return false;
    }
  }


  static Size mediaQuery(BuildContext context) => MediaQuery.of(context).size;

  static String defaultImg(BuildContext context,[bool isProfile = true]) {
    final setting = context.read<SettingCubit>();
    if(isProfile){
      if ((setting.settingModel?.setting?.defaultAvatar.isNotEmpty ?? false) && setting.settingModel?.setting?.defaultAvatar != 'default.png') {
        return setting.settingModel?.setting?.defaultAvatar ?? '';
      } else {
        return 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';
      }
    }else{
      return 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';
    }
  }

  static String translatedText(BuildContext context, String key,
      [bool lower = false]) {
    final webSetting = context.read<SettingCubit>();
    if (lower == true) {
      if (webSetting.settingModel?.localizations?[key] != null) {
        return webSetting.settingModel?.localizations?[key]?.toLowerCase()??'';
      } else {
        return key.toLowerCase();
      }
    } else {
      if (webSetting.settingModel?.localizations?[key] != null) {
        return webSetting.settingModel?.localizations?[key]??'';
      } else {
        return key;
      }
    }
  }

  static List<TextInputFormatter> inputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}$'))
  ];

  static String capitalizeFirstLetter(String? input) {
    if (input?.isEmpty??false) {
      return input??'';
    }
    try{
      return (input?[0].toUpperCase()??'') + (input?.substring(1).toLowerCase()??'');
    }catch (e){
      throw Exception(e.toString());
    }
  }

  static String priceSeparator(double value, {String locale = 'en_US', String symbol = '', int radix = 2}) {
    try {
      final formatter = NumberFormat.currency(
        locale: locale,
        symbol: symbol,
        decimalDigits: radix,
      );
      return formatter.format(value);
    } catch (e) {
      return value.toStringAsFixed(radix);
    }
  }

  static String getRemainingDays(String? futureDate) {
    if(futureDate?.isNotEmpty??false){
      try {
        DateTime targetDate = DateTime.parse(futureDate??'');

        DateTime today = DateTime.now();

        int remainingDays = targetDate.difference(today).inDays;

        String days = remainingDays > 0 ? remainingDays.toString() : '0';

        return days;
      } catch (e) {
        return '0';
      }
    }else{
      return '0';
    }
  }

  static String convertCurrency(BuildContext context, var price, CurrenciesModel c, [int radix = 2]) {

    final cCubit = context.read<CurrencyCubit>();
    final newCurrency = c.currencyRate;
    // final newCurrency = cCubit.state.currencyRate != 0.0?cCubit.state.currencyRate: c.currencyRate;
    // debugPrint('new-currency-rate $newCurrency');
    if (c.status.toLowerCase() == 'active' && (c.currencyPosition.toLowerCase() == 'after_price')) {
      if (price is double) {
        final result = price * newCurrency;
        return '${priceSeparator(result, symbol: '', radix: radix)}${c.currencyIcon}';
      }
      if (price is String) {
        final r = double.tryParse(price) ?? 0.0;
        final p = r * newCurrency;
        return '${priceSeparator(p, symbol: '', radix: radix)}${c.currencyIcon}';
      }
      if (price is int) {
        final p = price * newCurrency;
        return '${priceSeparator(p, symbol: '', radix: radix)}${c.currencyIcon}';
      } else {
        final p = price * newCurrency;
        return '${priceSeparator(p, symbol: '', radix: radix)}${c.currencyIcon}';
      }
    } else {
      if (price is double) {
        final result = price * newCurrency;
        return '${c.currencyIcon}${priceSeparator(result, symbol: '', radix: radix)}';
      }
      if (price is String) {
        final r = double.tryParse(price) ?? 0.0;
        final p = r * newCurrency;
        return '${c.currencyIcon}${priceSeparator(p, symbol: '', radix: radix)}';
      }
      if (price is int) {
        final p = price * newCurrency;
        return '${c.currencyIcon}${priceSeparator(p, symbol: '', radix: radix)}';
      }
      final p = price * newCurrency;
      return '${c.currencyIcon}${priceSeparator(p, symbol: '')}';
    }
  }

  static String formatAmount(BuildContext context, var price, [int radix = 2]) {
    final cCubit = context.read<CurrencyCubit>();
    final appSetting = context.read<SettingCubit>();

    if (cCubit.state.currencies.isNotEmpty) {
      return Utils.convertCurrency(context, price, cCubit.state.currencies.first, radix);
    } else if (appSetting.settingModel?.setting != null) {
      const currency = '\$';
      // final currency = appSetting.settingModel?.setting?.currencyIcon ?? '\$';
      if (price is double) {
        return priceSeparator(price, symbol: currency, radix: radix);
      }
      if (price is String) {
        final parsedPrice = double.tryParse(price) ?? 0.0;
        return priceSeparator(parsedPrice, symbol: currency, radix: radix);
      }
      if (price is int) {
        return priceSeparator(price.toDouble(), symbol: currency, radix: radix);
      }
      return priceSeparator(0.0, symbol: currency, radix: radix);
    }
    // Fallback option with a default currency symbol
    else {
      const currency = '\$';
      if (price is double) {
        return priceSeparator(price, symbol: currency, radix: radix);
      }
      if (price is String) {
        final parsedPrice = double.tryParse(price) ?? 0.0;
        return priceSeparator(parsedPrice, symbol: currency, radix: radix);
      }
      if (price is int) {
        return priceSeparator(price.toDouble(), symbol: currency, radix: radix);
      }
      return priceSeparator(0.0, symbol: currency, radix: radix);
    }
  }

  static String imageContent(BuildContext context, String key) {
    // final webSetting = context.read<AppSettingCubit>().settingModel;
    // if (webSetting != null && webSetting.imageContent![key] != null) {
    //   return RemoteUrls.imageUrl(webSetting.imageContent![key]!);
    // } else {
    return key;
    //}
  }

  static Uri tokenWithCode(String url, String token, String langCode,{Map<String, String>? extraParams}) {
    return Uri.parse('$url?').replace(queryParameters: {'token': token, 'lang_code': langCode,...extraParams??{}});
  }

  static BlocListener<LoginBloc, LoginStateModel> logoutListener() {
    return BlocListener<LoginBloc, LoginStateModel>(
      listener: (context, state) {
        final logout = state.loginState;
        if (logout is LoginStateLogoutLoading) {
          Utils.loadingDialog(context);
        } else {
          Utils.closeDialog(context);
          if (logout is LoginStateLogoutError) {
            Utils.errorSnackBar(context, logout.message);
          } else if (logout is LoginStateLogoutLoaded) {
            Utils.showSnackBar(context, logout.message);
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.authScreen,
              (route) => false,
            );
          }
        }
      },
    );
  }

  static Widget logout({required Widget child}) {
    return BlocListener<LoginBloc, LoginStateModel>(
      listener: (context, state) {
        final logout = state.loginState;
        if (logout is LoginStateLogoutLoading) {
          //Utils.loadingDialog(context);
        } else {
          //Utils.closeDialog(context);
          if (logout is LoginStateLogoutError) {
            Utils.errorSnackBar(context, logout.message);
          } else if (logout is LoginStateLogoutLoaded) {
            Utils.showSnackBar(context, logout.message);
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.authScreen,
              (route) => false,
            );
          }
        }
      },
      child: child,
    );
  }

  static Future<void> logoutFunction(BuildContext context) async {
    context.read<LoginBloc>().add(const LoginEventLogout());
    // Navigator.pushNamedAndRemoveUntil(context, RouteNames.authScreen, (route) => false);
  }

  static Future<String?> pickSingleImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
    return null;
  }

  static Future<List<String?>> pickMultipleImage() async {
    final ImagePicker picker = ImagePicker();
    final List<String> imageList = [];
    final List<XFile?> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var i in images) {
        imageList.add(i!.path.toString());
      }
      debugPrint('picked images: ${imageList.length}');
      return imageList;
    }
    return [];
  }

  // static Future<String?> pickSingleFile([bool isResume = false]) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: isResume == true
  //         ? ['mp4', 'mpeg4', 'flv', 'wmv', 'avi']
  //         : ['jpg', 'jpeg', 'png', 'gif'],
  //   );
  //   if (result != null &&
  //       result.files.single.path != null &&
  //       result.files.single.path!.isNotEmpty) {
  //     File file = File(result.files.single.path!);
  //     debugPrint('file-path ${file.path}');
  //     return file.path;
  //   } else {
  //     debugPrint('file path not found');
  //     return '';
  //   }
  // }

  static Future<String?> pickSingleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result?.files.single.path?.isNotEmpty??false) {
      File file = File(result?.files.single.path??'');
      debugPrint('file-path ${file.path}');
      return file.path;
    } else {
      debugPrint('file path not found');
      return '';
    }
  }

  static Future<List<String>> pickMultipleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'jpg', 'jpeg', 'zip', 'pdf', 'png'],
        allowMultiple: true);
    final List<String> fileList = [];
    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        if (file.path != null && file.path!.isNotEmpty) {
          fileList.add(file.path!);
        }
      }
    }
    // debugPrint('pickMultipleFile $fileList');
    return fileList;
  }

  static String timeWithData(String? data, [bool timeAndDate = true]) {
    if(data?.isNotEmpty??false){
    try{
      if (timeAndDate) {
        DateTime dateTime = DateTime.parse(data??'');
        String formattedDate = DateFormat('h:mm a - MMM d, yyyy').format(dateTime);
        return formattedDate;
      } else {
        DateTime dateTime = DateTime.parse(data??'');
        String formattedDate = DateFormat('MMM d, yyyy').format(dateTime);
        return formattedDate;
      }
    }catch (e){
      throw Exception('Error occurred ${e.toString()}');
    }
    }else{
      return '';
    }
  }


  static String orderStatusText(BuildContext context,OrderItem? item){
    if(item?.approvedBySeller == 'approved'){
      if(item?.orderStatus == 'approved_by_seller'){
        return Utils.translatedText(context, 'In-Progress');
      } else if(item?.completedByBuyer == 'complete'){
        return Utils.translatedText(context, 'Complete');
      } else if(item?.orderStatus == 'cancel_by_seller'){
        return Utils.translatedText(context, 'Cancel by Seller');
      } else if(item?.orderStatus == 'cancel_by_buyer'){
        return Utils.translatedText(context, 'Cancel by Buyer');
      }else{
        return '';
      }
    }
    if(item?.approvedBySeller == 'rejected'){
      return Utils.translatedText(context, 'Rejected by Seller');
    }else if(item?.orderStatus == 'cancel_by_buyer'){
      return Utils.translatedText(context, 'Cancel by Buyer');
    }else{
      return Utils.translatedText(context, 'Awaiting for Approval');
    }
  }

  static Color orderStatusBg(BuildContext context,OrderItem? item){
    if(item?.approvedBySeller == 'approved'){
      if(item?.orderStatus == 'approved_by_seller'){
        return greenColor.withOpacity(0.2);
      } else if(item?.completedByBuyer == 'complete'){
        return greenColor.withOpacity(0.2);
      } else if(item?.orderStatus == 'cancel_by_seller'){
        return redColor.withOpacity(0.2);
      } else if(item?.orderStatus == 'cancel_by_buyer'){
        return redColor.withOpacity(0.2);
      }else{
        return transparent;
      }
    }
    if(item?.approvedBySeller == 'rejected'){
      return redColor.withOpacity(0.2);
    }else if(item?.orderStatus == 'cancel_by_buyer'){
      return redColor.withOpacity(0.2);
    }else{
      return redColor.withOpacity(0.2);
    }
  }
  static Color orderStatusTextColor(BuildContext context,OrderItem? item){
    if(item?.approvedBySeller == 'approved'){
      if(item?.orderStatus == 'approved_by_seller'){
        return greenColor;
      } else if(item?.completedByBuyer == 'complete'){
        return greenColor;
      } else if(item?.orderStatus == 'cancel_by_seller'){
        return redColor;
      } else if(item?.orderStatus == 'cancel_by_buyer'){
        return redColor;
      }else{
        return transparent;
      }
    }
    if(item?.approvedBySeller == 'rejected'){
      return redColor;
    }else if(item?.orderStatus == 'cancel_by_buyer'){
      return redColor;
    }else{
      return redColor;
    }
  }

  static String jobStatusText(BuildContext context,JobPostItem? item){
    if(item?.approvedByAdmin == 'approved'){
      if(item?.checkJobStatus == 'approved'){
        return Utils.translatedText(context, 'Hired');
      } else if(item?.checkJobStatus == 'pending'){
        return Utils.translatedText(context, 'In-Progress');
      } else{
        return Utils.translatedText(context, 'Rejected');
      }
    }else{
      return Utils.translatedText(context, 'Awaiting');
    }
  }

  static Color jobStatusBg(BuildContext context,JobPostItem? item){
    if(item?.approvedByAdmin == 'approved'){
      if(item?.checkJobStatus == 'approved'){
        return const Color(0xFFe2ffde);
      } else if(item?.checkJobStatus == 'pending'){
        return const Color(0xFFe2ffde);
      } else{
        return const Color(0xFFfef0e2);
      }
    }else{
      return const Color(0xFFe2ffde);
    }
  }

  static String jobReqStatusText(BuildContext context,JobReqItem? item){
    if(item?.status == 'approved'){
      return Utils.translatedText(context, 'Hired');
    } else if(item?.status == 'pending'){
      return Utils.translatedText(context, 'Pending');
    } else{
      return Utils.translatedText(context, 'Rejected');
    }
  }
  static Color jobReqStatusBg(BuildContext context,JobReqItem? item){
    if(item?.status == 'approved'){
      return const Color(0xFFe2ffde);
    } else if(item?.status == 'pending'){
      return const Color(0xFFfef0e2);
    } else{
      return const Color(0xFFfef0e2);
    }
  }

  static bool orderAction(BuildContext context,OrderItem? item,[bool isBoth = true]){
    if(isBoth){
      if(Utils.isSeller(context)){
        if(item?.approvedBySeller == 'pending'){
          if(item?.orderStatus != 'cancel_by_buyer'){
            return true;
          }else{
            return false;
          }
        }else{
          return false;
        }
      }else{
        if(item?.approvedBySeller == 'approved'){
          if(item?.orderStatus == 'approved_by_seller'){
            return true;
          }else{
            return false;
          }
        }else{
          return false;
        }
      }

    } else{
      if(Utils.isSeller(context)){
        if(item?.approvedBySeller == 'approved'){
          if(item?.orderStatus == 'approved_by_seller'){
            return true;
          }else{
            return false;
          }
        }else{
          return false;
        }
      }else{
        if(item?.approvedBySeller == 'pending'){
          if(item?.orderStatus != 'cancel_by_buyer'){
            return true;
          }else{
            return false;
          }
        }else{
          return false;
        }
      }
    }
  }

  static bool refundOrder(BuildContext context, OrderDetail? item) {
    if (Utils.isSeller(context)) return false;

    final order = item?.order;
    if (order == null) return false;

    final isCancelled = order.orderStatus == 'cancel_by_seller' ||
        order.orderStatus == 'cancel_by_buyer' ||
        order.approvedBySeller == 'rejected';

    // final canRefund = order.ableToRefund == true &&
    //     order.canSendRefund == true &&
    //     order.refundAvailable == true;

    return isCancelled && Utils.isAddon(context)?.refund == true;
  }


  static String decodeHtmlEntities(String html) {
    Map<String, String> htmlEntities = {
      '&nbsp;': ' ',
      '&lt;': '<',
      '&gt;': '>',
      '&amp;': '&',
      '&quot;': '"',
      '&apos;': "'",
      '&cent;': '¢',
      '&pound;': '£',
      '&yen;': '¥',
      '&euro;': '€',
      '&copy;': '©',
      '&reg;': '®',
    };

    htmlEntities.forEach((entity, char) {html = html.replaceAll(entity, char);});

    html = html.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
      return String.fromCharCode(int.parse(match.group(1)!));
    });
    return html;
  }

  static bool isSeller(BuildContext context) {
    final login = context.read<LoginBloc>();
    if(login.userInformation?.user?.isSeller == 1 || login.userInformation?.userType.toLowerCase() == 'seller'){
      return true;
    }else{
      return false;
    }
  }

  static bool isLoggedIn(BuildContext context) {
    final login = context.read<LoginBloc>();
    if(login.userInformation != null){
      return true;
    }else{
      return false;
    }
  }

  static AddonModel? isAddon(BuildContext context){
    final settingCubit = context.read<SettingCubit>();
    if(settingCubit.settingModel?.addons != null){
      return settingCubit.settingModel?.addons;
    }else{
      return null;
    }
  }

  static void showSnackBarWithLogin(BuildContext context, [String? msg,Color textColor = whiteColor]) {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 1600),
      content: CustomText(text: Utils.translatedText(context, msg??'Please login first'), color: textColor),
      action: SnackBarAction(
        label: Utils.translatedText(context, 'Login'),
        onPressed: (){
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.authScreen,
                (route) => false,
          );
        },
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static String formatDate(var date) {
    late DateTime dateTime;
    if (date is String) {
      dateTime = DateTime.parse(date);
    } else {
      dateTime = date;
    }

    // return DateFormat.MMMEd().format(_dateTime.toLocal());
    return DateFormat.yMMMMd().format(dateTime.toLocal());
  }

  static String timeAgo(var date) {
    late DateTime dateTime;
    if (date is String) {
      dateTime = DateTime.now();
    } else {
      dateTime = date;
    }

    // return DateFormat.MMMEd().format(_dateTime.toLocal());
    return DateFormat.jm().format(dateTime);
  }

  static List<dynamic> parseJsonToString(String? text, [bool isTags = true]) {
    List tags = [];

    if (text != null && text.isNotEmpty && text.toLowerCase() != 'null') {
      try {
        List<dynamic> parsedJson = jsonDecode(text.replaceAll('&quot;', '"'));
        if (isTags) {
          tags = parsedJson.map((tag) => tag['value']).toList();
        } else {
          tags = parsedJson.map((tag) => tag).toList();
        }
      } catch (e) {
        throw Exception('error occurred ${e.toString()}');
      }
    }

    return tags;
  }

  static String convertToAgo(String? time) {
    Duration diff = DateTime.now().difference(DateTime.parse(time!));
    try {
      if (diff.inDays >= 1) {
        return '${diff.inDays} days ago';
      } else if (diff.inHours >= 1) {
        return '${diff.inHours} hours ago';
      } else if (diff.inMinutes >= 1) {
        return '${diff.inMinutes} minutes ago';
      } else if (diff.inSeconds >= 1) {
        return '${diff.inSeconds} seconds ago';
      } else {
        return 'Just Now';
      }
    } catch (e) {
      return '';
    }
  }

  static Widget verticalSpace(double size) {
    return SizedBox(height: size.h);
  }

  static Widget horizontalSpace(double size) {
    return SizedBox(width: size.w);
  }

  static double hSize(double size) {
    return size.w;
  }

  static double vSize(double size) {
    return size.h;
  }

  static EdgeInsets symmetric({double h = 20.0, v = 0.0}) {
    return EdgeInsets.symmetric(
        horizontal: Utils.hPadding(size: h), vertical: Utils.vPadding(size: v));
  }

  static double radius(double radius) {
    return radius.sp;
  }

  static BorderRadius borderRadius({double r = 10.0}) {
    return BorderRadius.circular(Utils.radius(r));
  }

  static EdgeInsets all({double value = 0.0}) {
    return EdgeInsets.all(value.dm);
  }

  static EdgeInsets only({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return EdgeInsets.only(
        left: left.w, top: top.h, right: right.w, bottom: bottom.h);
  }

  static double vPadding({double size = 20.0}) {
    return size.h;
  }

  static double hPadding({double size = 20.0}) {
    return size.w;
  }

  static double toDouble(String? number) {
    try {
      if (number == null) return 0;
      return double.tryParse(number) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  static double toInt(String? number) {
    try {
      if (number == null) return 0;
      return double.tryParse(number) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  static Future<DateTime?> selectDate(BuildContext context) => showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime(2050),
      );

  static Future<TimeOfDay?> selectTime(BuildContext context) =>
      showTimePicker(context: context, initialTime: _initialTime);

  static void closeKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static loadingDialog(
    BuildContext context, {
    bool barrierDismissible = false,
  }) {
    //closeDialog(context);
    showCustomDialog(
      context,
      child: Container(
        height: Utils.vSize(120.0),
        padding: Utils.all(value: 20.0),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: primaryColor),
              Utils.horizontalSpace(15.0),
              const CustomText(text: 'Please wait a moment')
            ],
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static bool _isDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  static void closeDialog(BuildContext context) {
    if (_isDialogShowing(context)) {
      Navigator.of(context).pop(true);
    }
  }

  static Future showCustomDialog(
    BuildContext context, {
    Widget? child,
    bool barrierDismissible = false,
    Color bgColor = whiteColor,
    EdgeInsets? padding,
    double? radius,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        final p = padding ?? Utils.symmetric();
        final r = radius ?? 6.0;
        return Dialog(
          backgroundColor: bgColor,
          insetPadding: p,
          shape: RoundedRectangleBorder(
            borderRadius: Utils.borderRadius(r: Utils.radius(r)),
          ),
          child: child,
        );
      },
    );
  }
  static void errorSnackBar(BuildContext context, String errorMsg,
      [int duration = 2500]) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: duration),
          content: CustomText(text: errorMsg, color: redColor),
        ),
      );
  }

  static void showSnackBar(BuildContext context, String msg,
      [Color textColor = whiteColor, int time = 2500]) {
    final snackBar = SnackBar(
      duration: Duration(milliseconds: time),
      content: CustomText(text: Utils.translatedText(context, msg), color: textColor),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void serviceUnAvailable(BuildContext context, String msg,
      [Color textColor = Colors.white]) {
    final snackBar = SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 500),
        content: Text(msg, style: TextStyle(color: textColor)));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSnackBarWithAction(
      BuildContext context, String msg, VoidCallback onPress,
      [Color textColor = primaryColor]) {
    final snackBar = SnackBar(
      content: Text(msg, style: TextStyle(color: textColor)),
      action: SnackBarAction(
        label: 'Active',
        onPressed: onPress,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static exitFromAppDialog(BuildContext context) {
    return Utils.showCustomDialog(
      context,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomImage(path: 'KImages.exitApp'),
            Utils.verticalSpace(8.0),
            const CustomText(
              text: 'Are you sure',
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              color: blackColor,
              fontSize: 24.0,
            ),
            Utils.verticalSpace(4.0),
            const CustomText(
              text: 'You want to Exit?',
              fontWeight: FontWeight.w500,
              color: grayColor,
              fontSize: 16.0,
            ),
            Utils.verticalSpace(16.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  text: 'Exit',
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  minimumSize: const Size(125.0, 45.0),
                ),
                const SizedBox(width: 12.0),
                PrimaryButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                  bgColor: redColor,
                  textColor: whiteColor,
                  minimumSize: const Size(125.0, 45.0),
                ),
              ],
            ),
            Utils.verticalSpace(14.0),
          ],
        ),
      ),
    );
  }
}
