import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/service/service_item.dart';
import '../../../../logic/cubit/service/service_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/add_new_button.dart';
import '../../../widgets/common_container.dart';
import '../../../widgets/custom_form.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/horizontal_line.dart';

class SeoInformation extends StatelessWidget {
  const SeoInformation({super.key});

  @override
  Widget build(BuildContext context) {
   final sCubit = context.read<ServiceCubit>();
   if(sCubit.state.tagList.isEmpty){
     sCubit.addTags('');
   }
    return  CommonContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: Utils.translatedText(context, 'SEO Information'),fontSize: 18.0,fontWeight: FontWeight.w600),
          const HorizontalLine(),

          CustomFormWidget(
            label: Utils.translatedText(context, 'Tags'),
            bottomSpace: 20.0,
            isRequired: false,
            child: BlocBuilder<ServiceCubit, ServiceItem>(
              builder: (context, state) {
                // final post = state.profileState;
                return Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    (state.tagList.length / 2).ceil(),
                        (rowIndex) {
                      final int firstIndex = rowIndex * 2;
                      final int secondIndex = firstIndex + 1;
                      final bool isLastRow = rowIndex == (state.tagList.length / 2).ceil() - 1;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              initialValue: state.tagList[firstIndex],
                              onChanged: (String text){
                                sCubit.updateTags(firstIndex, text);
                              },
                              decoration: InputDecoration(
                                hintText: Utils.translatedText(context, 'Tags', true),
                                border: outlineBorder(),
                                enabledBorder: outlineBorder(),
                                focusedBorder: outlineBorder(),
                                suffixIcon: GestureDetector(
                                  onTap: ()=>sCubit.removeTags(firstIndex),
                                  child: const Icon(Icons.clear, color: redColor),
                                ),
                              ),
                            ),
                          ),
                          if (secondIndex < state.tagList.length)...[Utils.horizontalSpace(10.0)],

                          if (secondIndex < state.tagList.length)...[
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                initialValue: state.tagList[secondIndex],
                                onChanged: (String text){
                                  sCubit.updateTags(secondIndex, text);
                                },
                                decoration: InputDecoration(
                                  hintText: Utils.translatedText(context, 'Tags', true),
                                  border: outlineBorder(),
                                  enabledBorder: outlineBorder(),
                                  focusedBorder: outlineBorder(),
                                  suffixIcon: GestureDetector(
                                    onTap: ()=>sCubit.removeTags(secondIndex),
                                    child: const Icon(Icons.clear, color: redColor),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          if (isLastRow)...[Utils.horizontalSpace(10.0)],// Spacer before the button
                          if (isLastRow)...[
                            AddNewButton(onPressed: (){
                              sCubit.addTags('');
                            }),
                          ],
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),

          CustomFormWidget(
            label: Utils.translatedText(context, 'SEO Title'),
            bottomSpace: 20.0,
            isRequired: false,
            child: BlocBuilder<ServiceCubit, ServiceItem>(
              builder: (context, state) {
                return TextFormField(
                  initialValue: state.seoTitle,
                  onChanged: sCubit.seoTitleChange,
                  decoration:  InputDecoration(
                      hintText: Utils.translatedText(context, 'SEO Title',true),
                      border:  outlineBorder(),
                      enabledBorder: outlineBorder(),
                      focusedBorder: outlineBorder()
                  ),
                  keyboardType: TextInputType.text,

                );
              },
            ),
          ),

          CustomFormWidget(
            label: Utils.translatedText(context, 'SEO Description'),
            bottomSpace: 20.0,
            isRequired: false,
            child: BlocBuilder<ServiceCubit, ServiceItem>(
              builder: (context, state) {
                return TextFormField(
                  initialValue: state.seoDescription,
                  onChanged: sCubit.seoDesChange,
                  decoration:  InputDecoration(
                    hintText: Utils.translatedText(context, 'SEO Description',true),
                    border:  outlineBorder(10.0),
                    enabledBorder: outlineBorder(10.0),
                    focusedBorder: outlineBorder(10.0),
                    alignLabelWithHint: true
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
