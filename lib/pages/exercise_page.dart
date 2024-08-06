// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/models/exercise_photo.dart';
import 'package:my_fit_journey/pages/body_selector_page.dart';
import 'package:my_fit_journey/widgets/step_item.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';
import 'package:photo_view/photo_view.dart';

class ExercisePage extends StatefulWidget {
  static const String route = '/exercise';
  final Exercise? exercise;

  const ExercisePage({super.key, this.exercise});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class ExerciseStep {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final bool isShowContinueButton;

  ExerciseStep(
      {required this.title,
      required this.content,
      this.actions = const [],
      this.isShowContinueButton = true});
}

class _ExercisePageState extends State<ExercisePage> {
  final List<ExercisePhoto> photos = [];
  final List<ExercisePhoto> deletedPhotos = [];
  final highlightParts = <BodyPart>[];
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  late final Map<String, BodyGroup> bodyStructure;
  late final PageController _pageViewController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  int stepIndex = 0;
  late ExerciseType? exerciseTypeValue;
  Map<String, (dynamic, TextEditingController?)> specificationValues = {};

  @override
  void initState() {
    bodyStructure = getBodyStructure();
    _pageViewController = PageController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    loadExerciseData();

    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void loadExerciseData() {
    final exercise = widget.exercise;
    if (exercise == null) {
      setExerciseType(ExerciseType.machineWeight);
      return;
    }

    _titleController.text = exercise.title;
    _descriptionController.text = exercise.description;
    highlightParts.addAll(exercise.bodyParts);
    photos.addAll(exercise.photos);
    setExerciseType(exercise.type);
    exerciseTypeSpecifications[exerciseTypeValue]!.forEach((key, value) {
      final v = exercise.specifications[key];
      if (v == null) {
        return;
      }

      specificationValues[key] = (
        value.isEnum ? value.indexToEnumConverter!(v) : v,
        value.isEnum
            ? null
            : (TextEditingController()
              ..value = TextEditingValue(text: v?.toString() ?? ''))
      );
    });
  }

  void setExerciseType(ExerciseType? value) {
    exerciseTypeValue = value;
    if (exerciseTypeValue == null) {
      specificationValues.clear();
      return;
    }

    specificationValues =
        exerciseTypeSpecifications[exerciseTypeValue]!.map((key, value) {
      final dynamic v = value.initValueFn();
      return MapEntry(key, (
        v,
        value.isEnum
            ? null
            : (TextEditingController()
              ..value = TextEditingValue(text: v?.toString() ?? ''))
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _onSave,
        child: Icon(Icons.save),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: globalPadding),
                for (var step in steps)
                  StepItem(
                    index: steps.indexOf(step) + 1,
                    title: Text(step.title),
                    actions: Row(children: step.actions),
                    child: step.content,
                  ),
                const SizedBox(height: globalPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exercise = widget.exercise ?? Exercise.empty();
    exercise.title = _titleController.text;
    exercise.description = _descriptionController.text;
    exercise.bodyParts
      ..clear()
      ..addAll(highlightParts);
    exercise.photos
      ..clear()
      ..addAll(photos.where((photo) => !deletedPhotos.contains(photo)));
    exercise.type = exerciseTypeValue!;
    exercise.specifications
      ..clear()
      ..addAll(exerciseTypeSpecifications[exerciseTypeValue]!.map((key, value) {
        final spec = specificationValues[key]!;
        final specValue = value.isEnum
            ? spec.$1.index
            : value.fromTextConverter!(spec.$2!.text);
        return MapEntry(key, specValue);
      }));

    if (!exercise.isInBox) {
      exerciseBox.put(exercise.id, exercise);
    } else {
      exercise.save();
    }

    Navigator.of(context).pop();
  }

  Future<XFile?> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    return pickedFile;
  }

  Future<List<XFile>> getImages() async {
    final pickedFiles = await picker.pickMultiImage();

    return pickedFiles;
  }

  List<ExerciseStep> _getSteps() {
    return [
      ExerciseStep(
        title: 'exercise-details'.i18n(),
        content: _buildExerciseDetails(),
      ),
      ExerciseStep(
        title: 'target-muscles'.i18n(),
        actions: _buildRargetMusclesActions(),
        content: _buildRargetMuscles(),
      ),
      ExerciseStep(
        title: 'exercise-photos'.i18n(),
        actions: _buildExercisePhotosActions(),
        content: _buildExercisePhotos(),
      ),
      ExerciseStep(
        title: 'exercise-specifications'.i18n(),
        isShowContinueButton: false,
        content: _buildExerciseSpecifications(),
      ),
    ];
  }

  List<Widget> _buildRargetMusclesActions() {
    return [
      TextButton(
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());

          var result = await Navigator.of(context)
              .pushNamed(BodySelectorPage.route, arguments: highlightParts);
          if (result == null) {
            return;
          }

          setState(() {
            highlightParts.clear();
            highlightParts.addAll(result as List<BodyPart>);
          });
        },
        child: Text('choice'.i18n()),
      ),
      SizedBox(width: globalPadding),
    ];
  }

  Widget _buildExerciseSpecifications() {
    if (specificationValues.isEmpty) {
      return Text('No specifications for selected exercise type');
    }

    return Padding(
      padding: const EdgeInsets.only(right: globalPadding * 2),
      child: Column(
        children: [
          for (var entry
              in exerciseTypeSpecifications[exerciseTypeValue]!.entries)
            entry.value.isEnum
                ? DropdownButtonFormField<dynamic>(
                    items: [
                      for (var option in entry.value.options!)
                        DropdownMenuItem(
                          value: option.$1,
                          child: Text(option.$2.i18n()),
                        )
                    ],
                    value: specificationValues[entry.key]!.$1,
                    onChanged: (value) {
                      specificationValues[entry.key] =
                          (value, specificationValues[entry.key]!.$2);
                    },
                  )
                : TextField(
                    controller: specificationValues[entry.key]!.$2,
                    keyboardType: entry.value.inputType,
                    inputFormatters: entry.value.inputFormatters,
                    maxLines: null,
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: entry.key,
                    ),
                  ),
          SizedBox(height: globalPadding),
        ],
      ),
    );
  }

  List<Widget> _buildExercisePhotosActions() {
    return [
      PopupMenuButton(
        icon: Icon(Icons.add),
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: _onAddGalleryPhotos,
            child: Text("gallery".i18n()),
          ),
          PopupMenuItem(
            onTap: _onAddCameraPhoto,
            child: Text("camera".i18n()),
          ),
          PopupMenuItem(
            onTap: _onAddUrlPhoto,
            child: Text("url".i18n()),
          ),
          // PopupMenuItem(
          //   onTap: _onAddOnlineSearchPhoto,
          //   child: Text("online-search".i18n()),
          // ),
        ],
      ),
      SizedBox(width: globalPadding),
    ];
  }

  // void _onAddOnlineSearchPhoto() async {}

  void _onAddGalleryPhotos() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final images = await getImages();

    setState(() {
      photos.addAll([
        for (var image in images)
          ExercisePhoto(source: ExercisePhotoSource.local, path: image.path)
      ]);
    });
  }

  void _onAddCameraPhoto() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final image = await getImage(ImageSource.camera);
    if (image == null) {
      return;
    }

    setState(() {
      photos.add(
          ExercisePhoto(source: ExercisePhotoSource.local, path: image.path));
    });
  }

  void _onAddUrlPhoto() async {
    FocusScope.of(context).requestFocus(FocusNode());
    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text("enter-url".i18n()),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "url".i18n(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("cancel".i18n()),
            ),
            TextButton(
              child: Text("add".i18n()),
              onPressed: () {
                setState(() {
                  photos.add(ExercisePhoto(
                      source: ExercisePhotoSource.network,
                      path: controller.text));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildExercisePhotos() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (photos.isEmpty) ...[
            Text('No photos added'),
          ],
          for (var photo in photos) _buildPhotoCard(context, photo),
          const SizedBox(width: globalPadding),
        ],
      ),
    );
  }

  Widget _buildRargetMuscles() {
    return Padding(
      padding: const EdgeInsets.only(right: globalPadding * 2),
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(globalPadding),
          child: Row(
            children: [
              Flexible(
                child: SvgHighlight(
                  svgCode: maleFrontSvg,
                  highlightParts: highlightParts.toList(),
                ),
              ),
              Flexible(
                child: SvgHighlight(
                  svgCode: maleBackSvg,
                  highlightParts: highlightParts.toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseDetails() {
    return Padding(
      padding: const EdgeInsets.only(right: globalPadding * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _titleController,
            autofocus: false,
            decoration: InputDecoration(
              labelText: 'title'.i18n(),
            ),
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            autofocus: false,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'description'.i18n(),
            ),
          ),
          DropdownButtonFormField<ExerciseType>(
            decoration: InputDecoration(
              labelText: 'exercise-type'.i18n(),
            ),
            items: [
              for (var option in exerciseTypeOptions)
                DropdownMenuItem(
                  value: option.$1,
                  child: Text(option.$2.i18n()),
                )
            ],
            value: exerciseTypeValue,
            onChanged: _onExerciseTypeChanged,
            validator: (value) {
              if (value == null) {
                return 'Please select exercise type';
              }
              return null;
            },
          ),
          SizedBox(height: globalPadding * 2),
        ],
      ),
    );
  }

  void _onExerciseTypeChanged(ExerciseType? value) {
    setState(() {
      setExerciseType(value);
    });
  }

  Widget _buildPhotoCard(BuildContext context, ExercisePhoto photo) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: 125,
        height: 125,
        child: Stack(
          children: [
            Positioned.fill(
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog.fullscreen(
                        child: PhotoView(
                          heroAttributes:
                              PhotoViewHeroAttributes(tag: photo.path),
                          imageProvider:
                              photo.source == ExercisePhotoSource.local
                                  ? FileImage(File(photo.path))
                                  : NetworkImage(photo.path),
                        ),
                      );
                    },
                  );
                },
                child: Hero(
                  tag: photo.path,
                  child: Opacity(
                    opacity: deletedPhotos.contains(photo) ? 0.5 : 1,
                    child: Image(
                      image: photo.source == ExercisePhotoSource.local
                          ? FileImage(File(photo.path))
                          : NetworkImage(photo.path),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    if (deletedPhotos.contains(photo)) {
                      deletedPhotos.remove(photo);
                    } else {
                      deletedPhotos.add(photo);
                    }
                  });
                },
                icon: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(globalPadding),
                    child: Icon(
                      deletedPhotos.contains(photo)
                          ? Icons.settings_backup_restore_rounded
                          : Icons.delete,
                      color: deletedPhotos.contains(photo)
                          ? Colors.blue
                          : Colors.red,
                      size: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
