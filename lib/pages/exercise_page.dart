// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:my_fit_journey/models/cardio_machine_exercise.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/models/exercise_photo.dart';
import 'package:my_fit_journey/models/exercise_step.dart';
import 'package:my_fit_journey/models/free_weight_exercise.dart';
import 'package:my_fit_journey/models/machine_weight_exercise.dart';
import 'package:my_fit_journey/models/other_exercise.dart';
import 'package:my_fit_journey/pages/body_selector_page.dart';
import 'package:my_fit_journey/storage/storage.dart';
import 'package:my_fit_journey/widgets/step_item.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';
import 'package:photo_view/photo_view.dart';

class ExercisePage extends StatefulWidget {
  static const String route = '/exercise';
  final Exercise exercise;

  const ExercisePage({super.key, required this.exercise});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final List<ExercisePhoto> photos = [];
  final List<ExercisePhoto> deletedPhotos = [];
  final highlightParts = <BodyPart>[];
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _minWeightController;
  late final TextEditingController _maxWeightController;
  late final TextEditingController _weightStepController;
  late final TextEditingController _minSpeedController;
  late final TextEditingController _maxSpeedController;
  late final TextEditingController _speedStepController;
  late final TextEditingController _minIntensityController;
  late final TextEditingController _maxIntensityController;
  late final TextEditingController _intensityStepController;
  late final TextEditingController _detailsController;

  WeightUnit weightUnitValue = WeightUnit.kg;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.exercise is MachineWeightExercise ||
        widget.exercise is FreeWeightExercise) {
      _minWeightController = TextEditingController();
      _maxWeightController = TextEditingController();
      _weightStepController = TextEditingController();
    }

    if (widget.exercise is CardioMachineExercise) {
      _minSpeedController = TextEditingController();
      _maxSpeedController = TextEditingController();
      _speedStepController = TextEditingController();
      _minIntensityController = TextEditingController();
      _maxIntensityController = TextEditingController();
      _intensityStepController = TextEditingController();
    }

    if (widget.exercise is OtherExercise) {
      _detailsController = TextEditingController();
    }

    loadExerciseData();

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    if (widget.exercise is MachineWeightExercise ||
        widget.exercise is FreeWeightExercise) {
      _minWeightController.dispose();
      _maxWeightController.dispose();
      _weightStepController.dispose();
    }

    if (widget.exercise is CardioMachineExercise) {
      _minSpeedController.dispose();
      _maxSpeedController.dispose();
      _speedStepController.dispose();
      _minIntensityController.dispose();
      _maxIntensityController.dispose();
      _intensityStepController.dispose();
    }

    if (widget.exercise is OtherExercise) {
      _detailsController.dispose();
    }

    super.dispose();
  }

  void loadExerciseData() {
    final exercise = widget.exercise;

    _titleController.text = exercise.title;
    _descriptionController.text = exercise.description;
    highlightParts.addAll(exercise.bodyParts);
    photos.addAll(exercise.photos);

    if (exercise is MachineWeightExercise) {
      weightUnitValue = exercise.weightUnit;
      _minWeightController.text = exercise.minWeight.toString();
      _maxWeightController.text = exercise.maxWeight.toString();
      _weightStepController.text = exercise.weightStep.toString();
    }
    if (exercise is FreeWeightExercise) {
      weightUnitValue = exercise.weightUnit;
      _minWeightController.text = exercise.minWeight.toString();
      _maxWeightController.text = exercise.maxWeight.toString();
      _weightStepController.text = exercise.weightStep.toString();
    }
    if (exercise is CardioMachineExercise) {
      _minSpeedController.text = exercise.minSpeed.toString();
      _maxSpeedController.text = exercise.maxSpeed.toString();
      _speedStepController.text = exercise.speedStep.toString();
      _minIntensityController.text = exercise.minIntensity.toString();
      _maxIntensityController.text = exercise.maxIntensity.toString();
      _intensityStepController.text = exercise.intensityStep.toString();
    }
    if (exercise is OtherExercise) {
      _detailsController.text = exercise.details;
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'new'.i18n([exerciseTypeMap[widget.exercise.type]!.i18n()]),
      //   ),
      // ),
      // floatingActionButtonLocation: ExpandableFab.location,
      backgroundColor: kBackgroundColor,
      floatingActionButton: FloatingActionButton(
        heroTag: 'save-${widget.exercise.id}',
        onPressed: _onSave,
        child: Icon(Icons.save),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(kGap * 2),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kLightShadowColor,
                          offset: Offset(-5, -5),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: kDarkShadowColor,
                          offset: Offset(5, 5),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
                    ),
                  ),
                ),
                Text(
                  'new'.i18n([exerciseTypeMap[widget.exercise.type]!.i18n()]),
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer()
              ],
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: kGap),
                      for (var step in steps)
                        Padding(
                          padding: const EdgeInsets.only(left: kGap * 2),
                          child: StepItem(
                            index: steps.indexOf(step) + 1,
                            title: Text(
                              step.title,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: Row(children: step.actions),
                            child: step.content,
                          ),
                        ),
                      const SizedBox(height: kGap),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exercise = widget.exercise;
    exercise.title = _titleController.text;
    exercise.description = _descriptionController.text;
    exercise.bodyParts
      ..clear()
      ..addAll(highlightParts);
    exercise.photos
      ..clear()
      ..addAll(photos.where((photo) => !deletedPhotos.contains(photo)));

    if (exercise is MachineWeightExercise) {
      exercise.weightUnit = weightUnitValue;
      exercise.minWeight = int.parse(_minWeightController.text);
      exercise.maxWeight = int.parse(_maxWeightController.text);
      exercise.weightStep = int.parse(_weightStepController.text);
    }
    if (exercise is FreeWeightExercise) {
      exercise.weightUnit = weightUnitValue;
      exercise.minWeight = int.parse(_minWeightController.text);
      exercise.maxWeight = int.parse(_maxWeightController.text);
      exercise.weightStep = int.parse(_weightStepController.text);
    }
    if (exercise is CardioMachineExercise) {
      exercise.minSpeed = double.parse(_minSpeedController.text);
      exercise.maxSpeed = double.parse(_maxSpeedController.text);
      exercise.speedStep = double.parse(_speedStepController.text);
      exercise.minIntensity = int.parse(_minIntensityController.text);
      exercise.maxIntensity = int.parse(_maxIntensityController.text);
      exercise.intensityStep = int.parse(_intensityStepController.text);
    }
    if (exercise is OtherExercise) {
      exercise.details = _detailsController.text;
    }

    if (Storage.exerciseStorage.contains(exercise.id)) {
      Storage.exerciseStorage.update(exercise);
    } else {
      Storage.exerciseStorage.insertAt(0, exercise);
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
      if (widget.exercise is WeightExercise)
        ExerciseStep(
          title: 'exercise-specifications'.i18n(),
          content: _buildWeightExerciseSpecifications(),
        ),
      if (widget.exercise is CardioMachineExercise)
        ExerciseStep(
          title: 'exercise-specifications'.i18n(),
          content: _buildCardioMachineExerciseSpecifications(),
        ),
      if (widget.exercise is OtherExercise)
        ExerciseStep(
          title: 'exercise-specifications'.i18n(),
          content: _buildOtherExerciseSpecifications(),
        ),
    ];
  }

  Widget _buildOtherExerciseSpecifications() {
    return Padding(
      padding: const EdgeInsets.only(right: kGap * 2),
      child: Column(
        children: [
          TextFormField(
            controller: _detailsController,
            autofocus: false,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'details'.i18n(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardioMachineExerciseSpecifications() {
    return Padding(
      padding: const EdgeInsets.only(right: kGap * 2),
      child: Column(
        children: [
          TextFormField(
            controller: _minSpeedController,
            keyboardType: TextInputType.number,
            validator: _intValidatorFn(min: 0),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              labelText: 'min-speed'.i18n(),
            ),
          ),
          TextFormField(
            controller: _maxSpeedController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _intValidatorFn(min: 1),
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              labelText: 'max-speed'.i18n(),
            ),
          ),
          TextFormField(
            controller: _speedStepController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _intValidatorFn(min: 1),
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              labelText: 'speed-step'.i18n(),
            ),
          ),
          SizedBox(height: kGap * 2),
          TextFormField(
            controller: _minIntensityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _intValidatorFn(min: 0),
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              labelText: 'min-intensity'.i18n(),
            ),
          ),
          TextFormField(
            controller: _maxIntensityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _intValidatorFn(min: 1),
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              labelText: 'max-intensity'.i18n(),
            ),
          ),
          TextFormField(
            controller: _intensityStepController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _intValidatorFn(min: 1),
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              labelText: 'intensity-step'.i18n(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightExerciseSpecifications() {
    return Padding(
      padding:
          const EdgeInsets.only(right: kGap * 2, bottom: kGap * 2, top: kGap),
      child: Column(
        children: [
          DropdownButtonFormField<WeightUnit>(
            items: [
              for (var option in weightUnitOptions)
                DropdownMenuItem(
                  value: option.unit,
                  child: Text(option.title.i18n()),
                )
            ],
            value: weightUnitValue,
            onChanged: (value) {
              setState(() {
                weightUnitValue = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'weight-unit'.i18n(),
            ),
          ),
          TextFormField(
            controller: _minWeightController,
            keyboardType: TextInputType.number,
            validator: _doubleValidatorFn(min: 0),
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              labelText: 'min-weight'.i18n(),
            ),
          ),
          TextFormField(
            controller: _maxWeightController,
            keyboardType: TextInputType.number,
            validator: _doubleValidatorFn(min: 1),
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              labelText: 'max-weight'.i18n(),
            ),
          ),
          TextFormField(
            controller: _weightStepController,
            keyboardType: TextInputType.number,
            validator: _doubleValidatorFn(min: 1),
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              labelText: 'weight-step'.i18n(),
            ),
          )
        ],
      ),
    );
  }

  FormFieldValidator<String>? _intValidatorFn({int? min}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter value';
      }

      final number = int.tryParse(value);
      if (number == null) {
        return 'Please enter valid number';
      }

      if (min != null && number < min) {
        return 'Please enter number greater than $min';
      }

      return null;
    };
  }

  FormFieldValidator<String>? _doubleValidatorFn({double? min}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter value';
      }

      final number = double.tryParse(value);
      if (number == null) {
        return 'Please enter valid number';
      }

      if (min != null && number < min) {
        return 'Please enter number greater than $min';
      }

      return null;
    };
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
      SizedBox(width: kGap),
    ];
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
      SizedBox(width: kGap),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: kGap, top: kGap),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (photos.isEmpty) ...[
              Text('No photos added'),
            ],
            for (var photo in photos) _buildPhotoCard(context, photo),
            const SizedBox(width: kGap),
          ],
        ),
      ),
    );
  }

  Widget _buildRargetMuscles() {
    return Padding(
      padding: const EdgeInsets.only(right: kGap * 2),
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(kGap),
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
      padding: const EdgeInsets.only(right: kGap * 2),
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
          SizedBox(height: kGap * 2),
        ],
      ),
    );
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
                                  ? FileImage(File(photo.path)) as ImageProvider
                                  : NetworkImage(photo.path) as ImageProvider,
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
                          ? FileImage(File(photo.path)) as ImageProvider
                          : NetworkImage(photo.path) as ImageProvider,
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
                    padding: const EdgeInsets.all(kGap),
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
