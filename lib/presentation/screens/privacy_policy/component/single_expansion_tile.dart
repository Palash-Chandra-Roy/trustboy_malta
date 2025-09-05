import 'package:flutter/material.dart';

import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';

// class SingleExpansionTile extends StatefulWidget {
//   const SingleExpansionTile({
//     super.key,
//     this.isExpand = false,
//     this.heading = 'Include Service',
//     required this.child,
//      this.subTitle,
//     this.margin = 16.0
//   });
//   final bool isExpand;
//   final String heading;
//   final Widget child;
//   final Widget? subTitle;
//   final double margin;
//
//   @override
//   State<SingleExpansionTile> createState() => _SingleExpansionTileState();
// }
//
// class _SingleExpansionTileState extends State<SingleExpansionTile> {
//   bool itemExpand = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: Utils.symmetric(h: widget.margin, v: 6.0).copyWith(bottom: 2.0),
//       decoration: BoxDecoration(
//           color: whiteColor,
//           border: Border.all(color: whiteColor),
//           borderRadius: Utils.borderRadius(r: 4.0)),
//       child: Theme(
//         data: Theme.of(context).copyWith(dividerColor: transparent),
//         child: ExpansionTile(
//           onExpansionChanged: (bool expand) {
//             setState(() => itemExpand = expand);
//           },
//           initiallyExpanded: widget.isExpand,
//           tilePadding: Utils.symmetric(h: 16.0),
//           childrenPadding: Utils.all(value: 14.0).copyWith(top: 5.0),
//           title: CustomText(
//             text: widget.heading,
//             color: blackColor,
//             fontSize: 14.0,
//             fontWeight: FontWeight.w600,
//           ),
//           // subtitle: widget.subTitle??const SizedBox(),
//           children: [
//             widget.child,
//           ],
//         ),
//       ),
//     );
//   }
// }

class SingleExpansionTile extends StatelessWidget {
  const SingleExpansionTile({
    super.key,
    this.isExpand = false,
    this.heading = 'Include Service',
    required this.child,
    this.subTitle,
    this.margin = 16.0,
    required this.onExpand,
  });

  final bool isExpand;
  final String heading;
  final Widget child;
  final Widget? subTitle;
  final double margin;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: Utils.symmetric(h: margin, v: 6.0).copyWith(bottom: 2.0),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(color: whiteColor),
        borderRadius: Utils.borderRadius(r: 4.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: transparent),
        child: ExpansionTile(
          onExpansionChanged: (bool expanded) {
            if (expanded) onExpand();
          },
          initiallyExpanded: isExpand,
          tilePadding: Utils.symmetric(h: 16.0),
          childrenPadding: Utils.all(value: 14.0).copyWith(top: 5.0),
          title: CustomText(
            text: heading,
            color: blackColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
          children: [child],
        ),
      ),
    );
  }
}
