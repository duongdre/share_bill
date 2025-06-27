import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../gen/colors.gen.dart';
import '../../models/data_models/person.dart';
import 'avatar_person.dart';
import 'empty_state.dart';

class ListPerson extends ConsumerWidget {
  final List<Person> persons;
  final double? height;
  final EdgeInsets? margin;
  final bool scrollable;
  final Function(Person)? onPersonTap;

  const ListPerson({
    super.key,
    required this.persons,
    this.height,
    this.margin,
    this.scrollable = false,
    this.onPersonTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (persons.isEmpty) {
      return const EmptyPersonsState();
    }

    final double calculatedHeight = height ?? (6 + 6 + 76) * persons.length * 1.0;

    return SizedBox(
      height: scrollable ? null : calculatedHeight,
      child: ListView.builder(
        physics: scrollable ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
        shrinkWrap: scrollable,
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          return GestureDetector(
            onTap: onPersonTap != null ? () => onPersonTap!(person) : null,
            child: PersonListItem(
              person: person,
              margin: margin ?? const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
              ref: ref,
            ),
          );
        },
      ),
    );  }

  //Person grid view
  ///TODO: Save for further actions / features
  /*Widget _buildGridView(BuildContext context, WidgetRef ref) {
    if (persons.isEmpty) {
      return const Center(child: Text("No persons available"));
    }

    // Calculate grid dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = gridItemSize ?? 160.0;
    if (itemWidth < 66.0) {
      itemWidth = 66.0;
    }
    final calculatedAxisCount = gridAxisCount ?? (screenWidth / itemWidth).floor();

    // Calculate aspect ratio based on provided dimensions or use default
    final aspectRatio = gridItemSize != null ? gridItemSize! / gridItemSize! * 0.8 : 0.8;

    // Use GridView.builder for grid layout
    return Container(
      height: scrollable ? null : height ?? 400, // Use provided height or default
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: calculatedAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        physics: scrollable ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
        shrinkWrap: scrollable,
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          return GestureDetector(
            onTap: onPersonTap != null ? () => onPersonTap!(person) : null,
            child: PersonGridItem(
              size: itemWidth * 1.15,
              person: person,
              ref: ref,
            ),
          );
        },
      ),
    );
  }*/
}

class PersonListItem extends ConsumerWidget {
  final Person person;
  final EdgeInsets margin;
  final WidgetRef ref;

  const PersonListItem({
    super.key,
    required this.person,
    required this.margin,
    required this.ref,
  });

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
            child: AvatarPerson(
              person: person,
              size: 56,
              isEditable: false,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  person.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.textBlack,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                ),
                Text(
                  person.getPersonDescribe(),
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
          const Icon(
            Icons.star_border,
            color: ColorName.textGray,
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.delete,
            color: ColorName.textGray,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class PersonGridItem extends ConsumerWidget {
  final Person person;
  final double size;
  final WidgetRef ref;

  const PersonGridItem({
    super.key,
    required this.size,
    required this.person,
    required this.ref,
  });

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size * 0.075),
          AvatarPerson(
            person: person,
            size: size * 0.45,
            isEditable: false,
          ),
          SizedBox(height: size * 0.075),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.05),
            child: Text(
              person.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorName.textBlack,
                fontSize: size * 0.1,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
          SizedBox(height: size * 0.025),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.05),
            child: Text(
              person.getPersonDescribe(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorName.textGray,
                fontSize: size * 0.0875,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
          SizedBox(height: size * 0.075),
        ],
      ),
    );
  }
}
