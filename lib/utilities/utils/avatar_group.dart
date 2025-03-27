import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/gen/fonts.gen.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/utilities/utils/avatar_person.dart';
import '../../gen/colors.gen.dart';
import '../../models/data_models/group.dart';
import '../../screens/person/controller/person_provider.dart';

class AvatarGroup extends ConsumerWidget {
  final Group group;
  final double size;
  final bool isEditable;

  const AvatarGroup({
    super.key,
    required this.group,
    this.size = 50.0,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(personNotifierProvider);
    final personNotifier = ref.read(personNotifierProvider.notifier);

    Widget avatarWidget;

    final countMember = group.countMember();

    if (countMember == 1) {
      // Use CachedNetworkImage to load and cache the avatar
      avatarWidget = AvatarPerson(
        person: personNotifier.findPersonWithUid(group.members.keys.toList()[0]),
        size: size,
        isEditable: false,
      );
    } else if (countMember == 2) {
      // Use CachedNetworkImage to load and cache the avatar
      avatarWidget = Stack(
        children: [
          AvatarPerson(
            person: personNotifier.findPersonWithUid(group.members.keys.toList()[1]),
            size: size,
            isEditable: false,
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            child: AvatarPerson(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[0]),
              size: size,
              isEditable: false,
            ),
          )
        ],
      );
    } else if (countMember == 3) {
      // Use CachedNetworkImage to load and cache the avatar
      avatarWidget = Stack(
        children: [
          Container(
            child: AvatarPerson(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[2]),
              size: size,
              isEditable: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            child: AvatarPerson(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[1]),
              size: size,
              isEditable: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 32),
            child: AvatarPerson(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[0]),
              size: size,
              isEditable: false,
            ),
          )
        ],
      );
    } else if (countMember > 3) {
      // Use CachedNetworkImage to load and cache the avatar
      avatarWidget = Stack(
        children: [
          Container(
            child: AvatarPerson(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[2]),
              size: size,
              isEditable: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            child: AvatarPerson(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[1]),
              size: size,
              isEditable: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 32),
            child: AvatarPerson(
              person: personNotifier.findPersonWithUid(group.members.keys.toList()[0]),
              size: size,
              isEditable: false,
            ),
          ),
          CircleAvatar(
            radius: size / 4,
            backgroundColor: ColorName.homeGrayHold,
            child: Text(
              "+ ${countMember - 3} ",
              style: TextStyle(
                fontSize: 16,
                fontFamily: FontFamily.raleway,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold
              ),
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
      backgroundColor: ColorName.homeGrayHold,
      child: Icon(
        Icons.person,
        size: size / 1.5,
        color: Colors.grey[600],
      ),
    );
  }
}
