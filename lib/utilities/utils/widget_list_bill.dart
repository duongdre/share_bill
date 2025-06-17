import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../gen/colors.gen.dart';
import '../../models/data_models/bill.dart';
import '../../screens/group/controller/group_provider.dart';
import '../../screens/person/controller/person_provider.dart';
import 'avatar_person.dart';

class ListBill extends ConsumerWidget {
  final List<Bill> bills;
  final double? height;
  final EdgeInsets? margin;
  final bool scrollable;
  final Function(Bill)? onBillTap;

  const ListBill({
    super.key,
    required this.bills,
    this.height,
    this.margin,
    this.scrollable = false,
    this.onBillTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double calculatedHeight = height ?? (6 + 6 + 76) * bills.length * 1.0;

    return SizedBox(
      height: scrollable ? null : calculatedHeight,
      child: ListView.builder(
        physics: scrollable
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        shrinkWrap: scrollable,
        itemCount: bills.length,
        itemBuilder: (context, index) {
          final bill = bills[index];
          return GestureDetector(
            onTap: onBillTap != null ? () => onBillTap!(bill) : null,
            child: BillListItem(
              bill: bill,
              margin: margin ?? const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
              ref: ref,
            ),
          );
        },
      ),
    );
  }
}

class BillListItem extends ConsumerWidget {
  final Bill bill;
  final EdgeInsets margin;

  const BillListItem({
    super.key,
    required this.bill,
    required this.margin,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentPerson = ref.read(personNotifierProvider.notifier).findPersonWithUid(bill.personId);
    final recentGroup = ref.read(groupNotifierProvider.notifier).findGroupWithUid(bill.groupId);

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
            child: AvatarPerson(
              person: recentPerson,
              size: 56,
              isEditable: false,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${recentPerson?.name}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.textBlack,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                ),
                Text(
                  "${recentGroup?.name}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.textGray,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                ),
                Text(
                  DateFormat("MMM dd, yyyy - HH:mm").format(DateTime.fromMillisecondsSinceEpoch(bill.createdAt ?? 0)),
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
            NumberFormat.currency(locale: "vi_VN", symbol: "").format(bill.amount.toInt()),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ColorName.textGreen,
              fontSize: 16,
            ),
            maxLines: 1,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}