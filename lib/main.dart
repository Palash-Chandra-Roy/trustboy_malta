// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'presentation/routes/route_names.dart';
import 'presentation/utils/constraints.dart';
import 'presentation/utils/k_images.dart';
import 'presentation/utils/utils.dart';
import 'presentation/widgets/custom_app_bar.dart';
import 'presentation/widgets/custom_image.dart';
import 'presentation/widgets/custom_text.dart';
import 'presentation/widgets/custom_theme.dart';
import 'presentation/widgets/fetch_error_text.dart';
import 'state_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await StateInject.initDB();

  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) => errorScreen(flutterErrorDetails.exception);

  runApp(const WorkZone());
}

class WorkZone extends StatelessWidget {
  const WorkZone({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375.0, 812.0),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (BuildContext context, child) {
        return MultiRepositoryProvider(
          providers: StateInject.repositoryProvider,
          child: MultiBlocProvider(
            providers: StateInject.blocProviders,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              onGenerateRoute: RouteNames.generateRoutes,
              initialRoute: RouteNames.splashScreen,
              theme: MyTheme.theme,
              onUnknownRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: FetchErrorText(
                        text: 'No Route Found ${settings.name}',
                        textColor: blackColor),
                  ),
                );
              },
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child ?? const SizedBox(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class Error404 extends StatelessWidget {
  const Error404({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
              height: 250.0,
              width: double.infinity,
              child: CustomImage(path: KImages.error404,fit: BoxFit.cover,)),
          // Utils.verticalSpace(10.0),
          CustomText(text: Utils.translatedText(context, 'Sorry for inconvenience'),fontSize: 20.0,fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}

Widget errorScreen(dynamic detailsException) {
  return Scaffold(
      appBar:kReleaseMode? const CustomAppBar(title: 'Error Occurred'):null,
      body: Padding(
          padding: Utils.all(value: 20.0),
          child:
          kReleaseMode
              ?const Error404()
              :Center(child: CustomText(text:'$detailsException',textAlign: TextAlign.center,height: 1.6,))
      )
  );
}