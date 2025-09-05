import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentation/widgets/loading_widget.dart';
import '/presentation/widgets/primary_button.dart';

import '../../../../data/models/contact/contact_us_model.dart';
import '../../../../logic/contact/contact_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_form.dart';
import '../../../widgets/error_text.dart';

class ContactUsForm extends StatefulWidget {
  const ContactUsForm({super.key});

  @override
  State<ContactUsForm> createState() => _ContactUsFormState();
}

class _ContactUsFormState extends State<ContactUsForm> {

  late ContactCubit profileCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    profileCubit = context.read<ContactCubit>();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomFormWidget(
          label: Utils.translatedText(context, 'Name'),
          bottomSpace: 14.0,
          child: BlocBuilder<ContactCubit, ContactUsModel>(
            builder: (context, state) {
              final post = state.contactState;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: state.question,
                    onChanged: profileCubit.addName,
                    decoration:  InputDecoration(
                        hintText: Utils.translatedText(context, 'Name',true),
                        border:  outlineBorder(),
                        enabledBorder: outlineBorder(),
                        focusedBorder: outlineBorder()
                    ),
                    keyboardType: TextInputType.text,

                  ),
                  if (post is ContactFormError) ...[
                    if (post.errors.name.isNotEmpty)
                      ErrorText(text: post.errors.name.first),
                  ],

                ],
              );
            },
          ),
        ),
        CustomFormWidget(
          label: Utils.translatedText(context, 'Email'),
          bottomSpace: 14.0,
          child:    BlocBuilder<ContactCubit, ContactUsModel>(
            builder: (context, state) {
              final post = state.contactState;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: state.email,
                    onChanged: profileCubit.addEmail,
                    decoration:  InputDecoration(
                        hintText: Utils.translatedText(context, 'Email',true),
                        border:  outlineBorder(),
                        enabledBorder: outlineBorder(),
                        focusedBorder: outlineBorder()
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  if (post is ContactFormError) ...[
                    if (state.question.isNotEmpty)
                      if (post.errors.email.isNotEmpty)
                        ErrorText(text: post.errors.email.first),
                  ]
                ],
              );
            },
          ),
        ),
        CustomFormWidget(
          label: Utils.translatedText(context, 'Phone'),
          bottomSpace: 14.0,
          isRequired: false,
          child:    BlocBuilder<ContactCubit, ContactUsModel>(
            builder: (context, state) {
              final post = state.contactState;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: state.phone,
                    onChanged: profileCubit.addPhone,
                    decoration:  InputDecoration(
                        hintText: Utils.translatedText(context, 'Phone',true),
                        border:  outlineBorder(),
                        enabledBorder: outlineBorder(),
                        focusedBorder: outlineBorder()
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  // if (post is ContactFormError) ...[
                  //   if (state.email.isNotEmpty)
                  //     if (post.errors.phone.isNotEmpty)
                  //       ErrorText(text: post.errors.phone.first),
                  // ]
                ],
              );
            },
          ),
        ),
        CustomFormWidget(
          label: Utils.translatedText(context, 'Subject'),
          bottomSpace: 14.0,
          child:    BlocBuilder<ContactCubit, ContactUsModel>(
            builder: (context, state) {
              final post = state.contactState;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: state.phone2,
                    onChanged: profileCubit.addSubject,
                    decoration:  InputDecoration(
                        hintText: Utils.translatedText(context, 'Subject',true),
                        border:  outlineBorder(),
                        enabledBorder: outlineBorder(),
                        focusedBorder: outlineBorder()
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                  if (post is ContactFormError) ...[
                    if (state.email.isNotEmpty)
                      if (post.errors.subject.isNotEmpty)
                        ErrorText(text: post.errors.subject.first),
                  ]
                ],
              );
            },
          ),
        ),
        CustomFormWidget(
          label: Utils.translatedText(context, 'Message'),
          bottomSpace: 20.0,
          child:  BlocBuilder<ContactCubit, ContactUsModel>(
            builder: (context, state) {
              final post = state.contactState;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: state.description,
                    onChanged: profileCubit.addMessage,
                    decoration:  InputDecoration(
                        hintText: Utils.translatedText(context, 'Message',true),
                        border:  outlineBorder(10.0),
                        enabledBorder: outlineBorder(10.0),
                        focusedBorder: outlineBorder(10.0)
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                  ),
                  if (post is ContactFormError) ...[
                    if (state.phone2.isNotEmpty)
                      if (post.errors.message.isNotEmpty)
                        ErrorText(text: post.errors.message.first),
                  ]
                ],
              );
            },
          ),
        ),

        BlocConsumer<ContactCubit, ContactUsModel>(
          listener: (context, state) {
            final s = state.contactState;
            if (s is ContactError) {
              Utils.errorSnackBar(context, s.message);
            } else if (s is ContactLoaded) {

              Utils.showSnackBar(context, s.message??'', whiteColor, 2000);

              Navigator.of(context).pop();
            }
          },
          builder: (context, states) {
            final state = states.contactState;
            if(state is ContactLoading){
              return LoadingWidget();
            }
            return PrimaryButton(text: Utils.translatedText(context, 'Send Message'), onPressed: (){
              Utils.closeKeyBoard(context);
              profileCubit.subContactUs();
            });
          },
        )

      ],
    );
  }
}
