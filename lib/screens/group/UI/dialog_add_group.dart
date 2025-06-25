import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/colors.gen.dart';
import 'package:share_bill/utilities/utils/avatar_person.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';
import '../../../models/data_models/group.dart';
import '../../../models/data_models/person.dart';
import '../../person/controller/person_provider.dart';
import '../controller/group_provider.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';

class DialogAddGroup extends ConsumerStatefulWidget {
  const DialogAddGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DialogAddGroupState();
}

class _DialogAddGroupState extends ConsumerState<DialogAddGroup> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Map<String, bool> selectedMembers = {};

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();

    // Initialize with all persons as unselected
    final persons = ref.read(personNotifierProvider.notifier).allPerson;
    for (final person in persons) {
      selectedMembers[person.uid] = false;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ref.watch(personNotifierProvider);
    final persons = ref.read(personNotifierProvider.notifier).allPerson;

    return GestureDetector(
      behavior: HitTestBehavior.translucent, // Ensures taps are detected even on empty areas
      onTap: () {
        // Hide keyboard and remove focus when tapping elsewhere
        FocusScope.of(context).unfocus();
      },
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20.0),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              decoration: ShapeDecoration(
                color: ColorName.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                shadows: [
                  BoxShadow(
                    color: ColorName.homeGrayBalance.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                localizations.createNewGroup,
                                style: const TextStyle(
                                  color: ColorName.textBlack,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => context.pop(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColorName.homeGrayHold,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: ColorName.iconGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Group Name Field
                        Text(
                          localizations.groupName,
                          style: const TextStyle(
                            color: ColorName.iconGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return localizations.pleaseEnterAGroupName;
                            }
                            if (value.trim().length < 2) {
                              return localizations.groupNameMustBeAtLeast2Characters;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: localizations.enterGroupName,
                            hintStyle: const TextStyle(
                              color: ColorName.loginTextColorGray,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: ColorName.borderBlack, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Members Selection
                        Text(
                          localizations.selectMembers,
                          style: const TextStyle(
                            color: ColorName.iconGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),

                        if (persons.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ColorName.homeGrayHold,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: ColorName.homeGrayBalance),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.person_add,
                                  size: 32,
                                  color: ColorName.loginTextColorGray,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  localizations.noPersonsAvailable,
                                  style: const TextStyle(
                                    color: ColorName.loginTextColorGray,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  localizations.addSomePeopleFirstToCreateAGroup,
                                  style: const TextStyle(
                                    color: ColorName.loginTextColorGray,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            constraints: const BoxConstraints(
                              maxHeight: 200,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorName.borderBlack),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: persons.length <= 3
                                ? Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: persons.map((person) => _buildPersonItem(person)).toList(),
                                )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: persons.length,
                                    itemBuilder: (context, index) {
                                      final person = persons[index];
                                      return _buildPersonListItem(person);
                                    },
                                  ),
                          ),

                        if (persons.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            "${_getSelectedCount()} ${localizations.memberSelected}",
                            style: const TextStyle(
                              color: ColorName.loginTextColorGray,
                              fontSize: 12,
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => context.pop(),
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: ColorName.homeGrayHold,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: ColorName.homeGrayBalance),
                                  ),
                                  child: Text(
                                    localizations.cancel,
                                    style: const TextStyle(
                                      color: ColorName.textGray,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: _isLoading ? null : _handleCreateGroup,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _isLoading ? ColorName.homeGrayBalance : ColorName.groupManagementBackGroundButton,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: ColorName.homeGrayBalance,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Text(
                                          localizations.createGroup,
                                          style: const TextStyle(
                                            color: ColorName.homeWhiteButtonBg,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonItem(Person person) {
    final isSelected = selectedMembers[person.uid] ?? false;

    return InkWell(
      onTap: () {
        setState(() {
          selectedMembers[person.uid] = !isSelected;
        });
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? ColorName.greenColor.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? ColorName.greenColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AvatarPerson(
                  person: person,
                  size: 48,
                  isEditable: false,
                ),
                if (isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: ColorName.greenColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              person.name,
              style: const TextStyle(
                color: ColorName.textBlack,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonListItem(Person person) {
    final isSelected = selectedMembers[person.uid] ?? false;

    return InkWell(
      onTap: () {
        setState(() {
          selectedMembers[person.uid] = !isSelected;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? ColorName.greenColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                AvatarPerson(
                  person: person,
                  size: 40,
                  isEditable: false,
                ),
                if (isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: ColorName.greenColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name,
                    style: const TextStyle(
                      color: ColorName.textBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (person.getPersonDescribe().isNotEmpty)
                    Text(
                      person.getPersonDescribe(),
                      style: const TextStyle(
                        color: ColorName.textGray,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ColorName.greenColor : ColorName.homeGrayBalance,
                  width: 2,
                ),
                color: isSelected ? ColorName.greenColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  int _getSelectedCount() {
    return selectedMembers.values.where((isSelected) => isSelected).length;
  }

  Future<void> _handleCreateGroup() async {
    final localizations = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;

    // Check if at least one member is selected
    if (_getSelectedCount() == 0) {
      toastification.show(
        title: Text(localizations.pleaseSelectAtLeastOneMember),
        style: ToastificationStyle.fillColored,
        type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create new group
      final newGroup = Group(
        uid: const Uuid().v4(),
        name: nameController.text.trim(),
        members: Map.from(selectedMembers)..removeWhere((key, value) => !value),
      );

      // Add group to database
      ref.read(groupNotifierProvider.notifier).currentGroupDetail = newGroup;
      await ref.read(groupNotifierProvider.notifier).addNewGroup(newGroup);

      if (mounted) {
        context.pop();
        toastification.show(
          title: Text(localizations.groupCreatedSuccessfully),
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          title: Text('${localizations.errorCreatingGroup} ${e.toString()}'),
          style: ToastificationStyle.fillColored,
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
