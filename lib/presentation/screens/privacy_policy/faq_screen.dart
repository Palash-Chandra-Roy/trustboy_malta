import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '/presentation/routes/route_packages_name.dart';
import '../../../data/models/contact/contact_us_model.dart';
import '../../../logic/contact/contact_cubit.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {

  late ContactCubit termCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    termCubit = context.read<ContactCubit>();

    Future.microtask(()=>termCubit.getFaqsUs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  DefaultAppBar(title: Utils.translatedText(context, 'FAQ')),
      body: PageRefresh(
        onRefresh: () async {
          termCubit.getFaqsUs();
        },
        child: BlocConsumer<ContactCubit, ContactUsModel>(
          listener: (context, service) {
            final state = service.contactState;
            if (state is ContactDataError) {
              if (state.statusCode == 503 || termCubit.contact == null) {
                termCubit.getFaqsUs();
              }
            }

          },
          builder: (context, service) {
            final state = service.contactState;
            if (state is ContactDataLoading) {
              return const LoadingWidget();
            } else if (state is ContactDataError) {
              if (state.statusCode == 503) {
                return LoadedFaqsView(termsCon: termCubit.faqs);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is ContactFaqsLoaded) {
              return LoadedFaqsView(termsCon: state.faqs);
            }
            if (termCubit.faqs?.isNotEmpty??false) {
              return LoadedFaqsView(termsCon: termCubit.faqs);
            } else {
              return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class LoadedFaqsView extends StatefulWidget {
  const LoadedFaqsView({super.key, this.termsCon});
  final List<ContactUsModel>? termsCon;

  @override
  State<LoadedFaqsView> createState() => _LoadedFaqsViewState();
}

class _LoadedFaqsViewState extends State<LoadedFaqsView> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.termsCon?.length ?? 0,
      itemBuilder: (context, index) {
        final faq = widget.termsCon?[index];
        final isExpanded = expandedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              expandedIndex = isExpanded ? null : index;
            });
          },
          child: Container(
            margin: Utils.symmetric(h: 16.0, v: 6.0),
            padding: Utils.symmetric(h: 16.0, v: 14.0),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text:faq?.question ?? '',
                        color: blackColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    )
                  ],
                ),
                // Body
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: Utils.only(top: 12.0),
                    child: Column(
                      children: [
                        const Divider(color: borderColor),
                        HtmlWidget(faq?.answer ?? ''),
                      ],
                    ),
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

