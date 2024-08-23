import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/storage/storage.dart';
import 'package:my_fit_journey/widgets/exercise_card.dart';
import 'package:my_fit_journey/widgets/exercise_type_chip.dart';
import 'package:my_fit_journey/widgets/stack_app_bar_body.dart';

class ExercisePicker extends StatefulWidget {
  const ExercisePicker({super.key});

  @override
  State<ExercisePicker> createState() => _ExercisePickerState();
}

class _ExercisePickerState extends State<ExercisePicker> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final List<ExerciseType> _selectedTypes = ExerciseType.values.toList();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kBackgroundColor,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: 525,
        child: StackAppBarBody(
          isLargeTitle: false,
          title: 'pick-exercise'.i18n(),
          titleWidget: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  focusNode: _searchFocusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'search-exercise'.i18n(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: kGap),
                Wrap(
                  children: [
                    for (var type in ExerciseType.values)
                      Padding(
                        padding: const EdgeInsets.all(kGap / 2),
                        child: Listener(
                          onPointerDown: (event) {
                            setState(() {
                              if (_selectedTypes.contains(type)) {
                                _selectedTypes.remove(type);
                              } else {
                                _selectedTypes.add(type);
                              }
                            });
                          },
                          child: ExerciseTypeChip(
                              type: type,
                              color: _selectedTypes.contains(type)
                                  ? type.color
                                  : Colors.grey),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              top: kGap * 2,
              left: kGap,
              right: kGap,
              bottom: kGap,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              clipBehavior: Clip.none,
              itemCount: Storage.exerciseStorage.items.length,
              itemBuilder: (context, index) {
                final exercise = Storage.exerciseStorage.items[index];
                final isSelected = _selectedTypes.contains(exercise.type);
                final isSearchMatch = exercise.title
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    exercise.description
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase());
                if (!isSelected || !isSearchMatch) {
                  return const SizedBox.shrink();
                }

                return ExerciseCard(
                  isCompact: true,
                  exercise: exercise,
                  builder: (context, child) => child,
                  onTap: () {
                    Navigator.pop(context, exercise);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
