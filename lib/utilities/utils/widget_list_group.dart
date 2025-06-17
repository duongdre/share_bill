import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../gen/colors.gen.dart';
import '../../models/data_models/group.dart';
import '../../screens/bill/controller/bill_provider.dart';
import 'avatar_group.dart';

class ListGroup extends ConsumerWidget {
  final List<Group> groups;
  final double? height;
  final EdgeInsets? margin;
  final bool scrollable;
  final Function(Group)? onGroupTap;

  const ListGroup({
    super.key,
    required this.groups,
    this.height,
    this.margin,
    this.scrollable = false,
    this.onGroupTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double calculatedHeight = height ?? (6 + 6 + 76) * groups.length * 1.0;

    return SizedBox(
      height: scrollable ? null : calculatedHeight,
      child: ListView.builder(
        physics: scrollable
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        shrinkWrap: scrollable,
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return GestureDetector(
            onTap: onGroupTap != null ? () => onGroupTap!(group) : null,
            child: GroupListItem(
              group: group,
              margin: margin ?? const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
              ref: ref,
            ),
          );
        },
      ),
    );
  }
}

class GroupListItem extends ConsumerWidget {
  final Group group;
  final EdgeInsets margin;

  const GroupListItem({
    super.key,
    required this.group,
    required this.margin,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(color: ColorName.whiteShadow, blurRadius: 2, offset: Offset(1, 1)),
        ],
        color: ColorName.white,
      ),
      margin: margin,
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(16.0),
            child: AvatarGroup(
              group: group,
              size: 56,
              isEditable: false,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.textBlack,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                ),
                Text(
                  group.getMember(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.textGray,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Text(
            NumberFormat.currency(locale: "vi_VN", symbol: "").format(
                ref.read(billNotifierProvider.notifier).getTotalPaidOfAGroup(group).toInt()
            ),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ColorName.textGreen,
              fontSize: 16,
            ),
            maxLines: 1,
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.star_border,
            color: ColorName.textGray,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}