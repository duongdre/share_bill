import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_bill/gen/fonts.gen.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/screens/bill/controller/bill_provider.dart';
import 'package:share_bill/screens/group/controller/group_provider.dart';
import 'package:share_bill/utilities/utils/avatar_group.dart';
import 'package:share_bill/utilities/utils/avatar_person.dart';
import '../../gen/colors.gen.dart';
import '../../models/data_models/bill.dart';
import '../../models/data_models/group.dart';
import '../../screens/person/controller/person_provider.dart';

//ignore: must_be_immutable
class AvatarBill extends ConsumerWidget {
  final Bill bill;
  final double size;
  Group? group;

  AvatarBill({
    super.key,
    required this.bill,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(billNotifierProvider);
    final groupScreenNotifier = ref.read(groupNotifierProvider.notifier);
    Widget avatarWidget;

    group ??= groupScreenNotifier.findGroupWithUid(bill.groupId);

    if (group == null) {
      avatarWidget = _buildPlaceholderAvatar();
    } else {
      // Show placeholder avatar
      avatarWidget = AvatarGroup(group: group!, size: size);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20, right: 4),
      child: Row(
        children: [
          avatarWidget,
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref.read(personNotifierProvider.notifier).findPersonWithUid(bill.personId)?.name ?? ": ${bill.getDescribe()}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.homeBlackText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
                Text(
                  DateFormat("HH:mm - dd/MM/yy").format(DateTime.fromMillisecondsSinceEpoch(bill.createdAt ?? 0)),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.loginTextColorGray,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Container(
            width: 100,
            alignment: Alignment.centerRight,
            child: Text(
              NumberFormat.currency(locale: "vi_VN", symbol: "Đ").format(bill.amount),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ColorName.homeRedText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: ColorName.homeGrayHold,
      child: Icon(
        Icons.person,
        size: size / 1.5,
        color: Colors.grey[600],
      ),
    );
  }
}
