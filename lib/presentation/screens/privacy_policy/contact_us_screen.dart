import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:work_zone/presentation/routes/route_packages_name.dart';

import '../../../data/models/contact/contact_us_model.dart';
import '../../../logic/contact/contact_cubit.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/fetch_error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import 'component/contact_us_form.dart';
import 'component/location_tab.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {


  late ContactCubit termCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    termCubit = context.read<ContactCubit>();

    Future.microtask(()=>termCubit.getContactUs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  DefaultAppBar(title: Utils.translatedText(context, 'Contact Us')),
      body: PageRefresh(
        onRefresh: () async {
          termCubit.getContactUs();
        },
        child: BlocConsumer<ContactCubit, ContactUsModel>(
          listener: (context, service) {
            final state = service.contactState;
            if (state is ContactDataError) {
              if (state.statusCode == 503 || termCubit.contact == null) {
                termCubit.getContactUs();
              }
            }

          },
          builder: (context, service) {
            final state = service.contactState;
            if (state is ContactDataLoading) {
              return const LoadingWidget();
            } else if (state is ContactDataError) {
              if (state.statusCode == 503 || termCubit.contact != null) {
                return LoadedContactUsView(termsCon: termCubit.contact);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is ContactDataLoaded) {
              return LoadedContactUsView(termsCon: state.message);
            }
            if (termCubit.contact != null) {
              return LoadedContactUsView(termsCon: termCubit.contact);
            } else {
              return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class LoadedContactUsView extends StatelessWidget {
  const LoadedContactUsView({super.key, this.termsCon});
  final ContactUsModel? termsCon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: Utils.symmetric(),
      child: Column(
        children: [
          ContactUsForm(),
          Utils.verticalSpace(20.0),
          ContactInfo(
            icon: Icons.phone,
            title: 'Phone',
            subTitle: '${termsCon?.phone??''}\n${termsCon?.phone2??''}',
          ),
          ContactInfo(
            icon: Icons.email_outlined,
            title: 'Email',
            subTitle: '${termsCon?.email??''}\n${termsCon?.email2??''}',
          ),
          ContactInfo(
            icon: Icons.location_on,
            title: 'Location',
            subTitle: termsCon?.address??'',
          ),
          // LocationTab(link: termsCon?.mapCode??''),
        ],
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  const ContactInfo({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.bottom = 10.0,
  });

  final IconData icon;
  final String title;
  final String subTitle;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Utils.symmetric(v: 10.0),
      margin: Utils.only(bottom: bottom),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: Utils.borderRadius(r: 4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: Utils.all(value: 6.0),
            margin: Utils.only(right: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color:  blackColor,
                borderRadius: Utils.borderRadius(r: 4.0)),
            child: Icon(icon, color: whiteColor),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                    text: Utils.translatedText(context, title),
                    color: gray5B,
                    fontSize: 12.0),
                Utils.verticalSpace(4.0),
                Flexible(
                  fit: FlexFit.loose,
                  child: CustomText(
                    text: subTitle,
                    maxLine: 3,
                    color: blackColor,
                    height: 1.6,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

