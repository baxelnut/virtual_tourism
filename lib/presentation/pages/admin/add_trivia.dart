import 'package:flutter/material.dart';

import '../../../core/global_values.dart';

class AddTrivia extends StatefulWidget {
  final String title;
  final TextEditingController triviaController;
  final List<TextEditingController> optionControllers;
  final VoidCallback addAnswerField;
  final void Function(Map<String, dynamic> trivia) onConfirm;

  const AddTrivia({
    super.key,
    required this.title,
    required this.triviaController,
    required this.optionControllers,
    required this.addAnswerField,
    required this.onConfirm,
  });

  @override
  State<AddTrivia> createState() => _AddTriviaState();
}

class _AddTriviaState extends State<AddTrivia> {
  int? correctIndex;
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    bool canRemove = widget.optionControllers.length > 2;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListTile(
            dense: true,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              children: [
                TextField(
                  controller: widget.triviaController,
                  readOnly: _isConfirmed,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.title,
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    counterText: "",
                    counter: null,
                  ),
                  maxLength: 200,
                  maxLines: 2,
                ),
                Visibility(
                  visible: !_isConfirmed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Select'), if (canRemove) Text('Remove')],
                  ),
                ),
                ...widget.optionControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: answerOptions(
                      index: index,
                      controller: controller,
                      theme: theme,
                      onRemove: () {
                        setState(() {
                          widget.optionControllers.removeAt(index);

                          if (correctIndex != null && correctIndex == index) {
                            correctIndex = null;
                          } else if (correctIndex != null &&
                              correctIndex! > index) {
                            correctIndex = correctIndex! - 1;
                          }
                        });
                      },
                      canRemove: canRemove,
                      correctIndex: correctIndex,
                      onSelectedAsCorrect: (selectedIndex) {
                        setState(() {
                          correctIndex = selectedIndex;
                        });
                      },
                    ),
                  );
                }),
                Visibility(
                  visible: !_isConfirmed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: widget.addAnswerField,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                        ),
                        child: Text(
                          'Add options',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isConfirmed
                            ? null
                            : () {
                                final question =
                                    widget.triviaController.text.trim();
                                final options = widget.optionControllers
                                    .map((controller) => controller.text.trim())
                                    .toList();

                                final emptyIndices = <int>[];
                                for (int i = 0; i < options.length; i++) {
                                  if (options[i].isEmpty) {
                                    emptyIndices.add(i +
                                        1); // +1 to make it user-friendly (Option 1, 2...)
                                  }
                                }

                                if (question.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please enter a trivia question.')),
                                  );
                                  return;
                                }

                                if (options.length < 2) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please enter at least 2 answer options.')),
                                  );
                                  return;
                                }

                                if (emptyIndices.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please fill in all options. Empty: ${emptyIndices.join(', ')}',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (correctIndex == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please select a correct answer.')),
                                  );
                                  return;
                                }

                                if (question.isNotEmpty &&
                                    options.length >= 2 &&
                                    correctIndex != null) {
                                  final trivia = {
                                    'question': question,
                                    'answers': options,
                                    'correctAnswer': options[correctIndex!],
                                    'correctIndex': correctIndex,
                                  };

                                  widget.onConfirm(trivia);
                                  setState(() {
                                    _isConfirmed = true;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please enter a question, at least 2 options, and select a correct answer.')),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text(
                          'Confirm',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _isConfirmed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isConfirmed = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text(
                          'Edit',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isConfirmed = false;
                            correctIndex = null;

                            widget.triviaController.clear();

                            for (var controller in widget.optionControllers) {
                              controller.dispose();
                            }
                            widget.optionControllers.clear();

                            widget.optionControllers.addAll([
                              TextEditingController(),
                              TextEditingController(),
                            ]);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text(
                          'Delete',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget answerOptions({
    required int index,
    required TextEditingController controller,
    required ThemeData theme,
    required VoidCallback onRemove,
    required bool canRemove,
    required int? correctIndex,
    required ValueChanged<int> onSelectedAsCorrect,
  }) {
    return Row(
      children: [
        Radio<int>(
          value: index,
          groupValue: correctIndex,
          onChanged: _isConfirmed
              ? null
              : (value) {
                  onSelectedAsCorrect(value!);
                },
          activeColor: theme.colorScheme.primary,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: _isConfirmed,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: (_isConfirmed && correctIndex == index)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            decoration: InputDecoration(
              border: _isConfirmed
                  ? InputBorder.none
                  : const UnderlineInputBorder(),
              hintText: "Option ${index + 1}",
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
              counterText: "",
            ),
            maxLength: 100,
            maxLines: 1,
          ),
        ),
        if (canRemove && !_isConfirmed)
          IconButton(
            icon: Icon(
              Icons.remove_rounded,
              color: theme.colorScheme.onSurface,
              size: 20,
            ),
            onPressed: onRemove,
          ),
      ],
    );
  }
}
