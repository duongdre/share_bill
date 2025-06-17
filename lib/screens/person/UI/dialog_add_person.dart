import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/colors.gen.dart';
import 'package:share_bill/utilities/utils/avatar_person.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';
import '../../../models/data_models/person.dart';
import '../controller/person_provider.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';

class DialogAddPerson extends ConsumerStatefulWidget {
  const DialogAddPerson({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DialogAddPersonState();
}

class _DialogAddPersonState extends ConsumerState<DialogAddPerson> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController describeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    nameController.dispose();
    describeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ref.watch(personNotifierProvider);

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
                                localizations.addPerson,
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

                        // Avatar Section
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: ColorName.homeGrayBalance,
                                      blurRadius: 4,
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: AvatarPerson(
                                  person: ref.read(personNotifierProvider.notifier).currentPersonDetail,
                                  size: 100,
                                  isEditable: true,
                                ),
                              ),
                              if (ref.read(personNotifierProvider.notifier).isLoadingImage)
                                Container(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            localizations.tapToAddPhoto,
                            style: const TextStyle(
                              color: ColorName.loginTextColorGray,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Name Field
                        Text(
                          localizations.fullNameStar,
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
                              return localizations.pleaseEnterAName;
                            }
                            if (value.trim().length < 2) {
                              return localizations.nameMustBeAtLeast2Characters;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: localizations.enterPersonName,
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
                        const SizedBox(height: 20),

                        // Description Field
                        Text(
                          localizations.descriptionOptional,
                          style: const TextStyle(
                            color: ColorName.iconGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: describeController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: localizations.addANoteAboutPerson,
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
                          ),
                        ),
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
                                onTap: _isLoading ? null : _handleAddPerson,
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
                                          localizations.addPerson,
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

  Future<void> _handleAddPerson() async {
    final localizations = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Create new person
      final newPerson = Person(
        uid: const Uuid().v4(),
        name: nameController.text.trim(),
        avtUrl: ref.read(personNotifierProvider.notifier).currentPersonDetail.avtUrl,
        groups: {},
        describe: describeController.text.trim(),
      );

      // Set the person data in the provider
      ref.read(personNotifierProvider.notifier).currentPersonDetail = newPerson;

      // Add person to database
      await ref.read(personNotifierProvider.notifier).addNewPerson(newPerson);

      if (mounted) {
        context.pop();
        toastification.show(
          title: Text(localizations.personAddedSuccessfully),
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          title: Text('${localizations.errorAddingPerson} ${e.toString()}'),
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
