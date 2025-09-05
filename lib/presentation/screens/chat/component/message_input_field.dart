import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/chat/message_model.dart';
import '../../../../logic/cubit/chat/chat_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';

class MessageInputField extends StatelessWidget {
  MessageInputField({super.key});

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final mCubit = context.read<ChatCubit>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)
          .copyWith(bottom: 8),
      child: BlocBuilder<ChatCubit, MessageModel>(
        builder: (context, state) {
          return TextFormField(
            focusNode: focusNode,
            textInputAction: TextInputAction.done,
            //initialValue: state.message,
            controller: mCubit.messageController,
            style: const TextStyle(fontSize: 16.0),
            onChanged: (String text) {
              //print('onChanged $text');
              mCubit.addMessage(text);
            },
            decoration: InputDecoration(
              hintText: '${Utils.translatedText(context, 'Type message')}..',
              // enabled: state.isShowSugMessage == false || state.other == true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              suffixIcon: IconButton(
                splashRadius: 1.0,
                onPressed: () {
                  mCubit.sendTicketMessage();
                  mCubit.messageController.clear();
                  //mCubit.clear();
                },
                icon: Icon(
                  Icons.send_rounded,
                  color:
                      state.message.trim().isNotEmpty ? greenColor : grayColor,
                  size: 30.0,
                ),
              ),
              // prefixIcon: IconButton(
              //   splashRadius: 0.5,
              //   onPressed: () async {
              //     // mCubit.add(MessageEventClearExitDoc());
              //     // final doc = await Utils.pickMultipleFile();
              //     // if (doc.isNotEmpty) {
              //     //   for (int i = 0; i < doc.length; i++) {
              //     //     if (doc[i].isNotEmpty) {
              //     //       mCubit.add(MessageEventAddDoc(doc[i]));
              //     //     }
              //     //   }
              //     // }
              //   },
              //   icon: const Icon(
              //     Icons.attach_file,
              //     color: grayColor,
              //     size: 30.0,
              //   ),
              // ),
              fillColor: const Color(0xFFF7F5F0),
            ),
          );
        },
      ),
    );
  }
}
