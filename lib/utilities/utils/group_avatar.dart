import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/utilities/utils/person_avatar.dart';
import '../../models/data_models/group.dart';
import '../../screens/person/controller/person_provider.dart';

class GroupAvatar extends ConsumerWidget {
  final Group group;
  final double size;
  final bool isEditable;

  const GroupAvatar({
    Key? key,
    required this.group,
    this.size = 50.0,
    this.isEditable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(personNotifierProvider);
    final personNotifier = ref.read(personNotifierProvider.notifier);

    Widget avatarWidget;

    final countMember = group.countMember();

    if (countMember == 1) {
      // Use CachedNetworkImage to load and cache the avatar
      avatarWidget = PersonAvatar(
        person: personNotifier.findPersonWithUid(group.members.keys.toList()[0]),
        size: size,
        isEditable: false,
      );
    } else if (countMember == 2) {
      // Use CachedNetworkImage to load and cache the avatar
      avatarWidget = Stack(
        children: [
          PersonAvatar(
            person: personNotifier.findPersonWithUid(group.members.keys.toList()[1]),
            size: size,
            isEditable: false,
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            child: PersonAvatar(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[0]),
              size: size,
              isEditable: false,
            ),
          )
        ],
      );
    } else if (countMember >= 3) {
      // Use CachedNetworkImage to load and cache the avatar
      avatarWidget = Stack(
        children: [
          Container(
            child: PersonAvatar(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[2]),
              size: size,
              isEditable: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            child: PersonAvatar(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[1]),
              size: size,
              isEditable: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 32),
            child: PersonAvatar(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[0]),
              size: size,
              isEditable: false,
            ),
          )
        ],
      );
    } else {
      avatarWidget = _buildPlaceholderAvatar();
    }

    return avatarWidget;
  }

  Widget _buildPlaceholderAvatar() {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey[300],
      child: Icon(
        Icons.person,
        size: size / 1.5,
        color: Colors.grey[600],
      ),
    );
  }
}
