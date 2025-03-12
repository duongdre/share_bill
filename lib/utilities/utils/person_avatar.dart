import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/person.dart';

import '../../screens/home/controller/home_screen_provider.dart';

class PersonAvatar extends ConsumerWidget {
  final Person? person;
  final double size;
  final bool isEditable;

  const PersonAvatar({
    Key? key,
    required this.person,
    this.size = 50.0,
    this.isEditable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homeScreenTotalNotifierProvider);
    final homeScreenNotifier = ref.read(homeScreenTotalNotifierProvider.notifier);

    Widget avatarWidget;

    if (person == null) {
      if (homeScreenNotifier.newPersonAvtUploaded.isNotEmpty && homeScreenNotifier.newPersonId.isNotEmpty) {
        print(homeScreenNotifier.newPersonAvtUploaded);
        // Use CachedNetworkImage to load and cache the avatar
        avatarWidget = ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: CachedNetworkImage(
            imageUrl: homeScreenNotifier.newPersonAvtUploaded,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => _buildPlaceholderAvatar(),
          ),
        );
      } else {
        // Show placeholder avatar
        avatarWidget = _buildPlaceholderAvatar();
      }
    } else if (person!.avtUrl.isEmpty) {
      // Show placeholder avatar
      avatarWidget = _buildPlaceholderAvatar();
    } else {
      // Use CachedNetworkImage to load and cache the avatar
      avatarWidget = ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CachedNetworkImage(
          imageUrl: person!.avtUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => _buildPlaceholderAvatar(),
        ),
      );
    }

    if (isEditable) {
      return Stack(
        children: [
          avatarWidget,
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                if (person == null) {
                  homeScreenNotifier.uploadUserAvatar();
                } else {
                  homeScreenNotifier.updateUserAvatar(person!.uid);
                }
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: size / 4,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return avatarWidget;
    }
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