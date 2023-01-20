import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo_list/data/repo/repository.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/views/home.dart';

import '../data/source/task.dart';
import '../widget/input_field.dart';

class TaskEditScreen extends StatefulWidget {
  final Task task;

  const TaskEditScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  late final TextEditingController _titleController = TextEditingController(text: widget.task.title);
  late final TextEditingController _noteController = TextEditingController(text: widget.task.note);
  late  DateTime _selecteDate = DateTime.now();
  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selecteDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null) {
      setState(() {
        _selecteDate = _pickedDate;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        elevation: 0,
        title: const Text('Edit Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if ( _titleController.text == "" || _noteController.text=="") {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('text can not be null')));
            } else {
              widget.task.title = _titleController.text;
              widget.task.note = _noteController.text;
              widget.task.date = DateFormat.yMd().format(_selecteDate);
              widget.task.priority = widget.task.priority ?? Priority.low;
              final repository =
              Provider.of<Repository<Task>>(context, listen: false);
              repository.createOrUpdate(widget.task);
              Navigator.of(context).pop();
            }

          },
          label: const Text('Save Changes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      label: 'High',
                      color: highPriorityColor,
                      isSelected: widget.task.priority == Priority.high,
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.high;
                        });
                      },
                    )),
                const SizedBox(width: 8),
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      label: 'Normal',
                      color: normalPriorityColor,
                      isSelected: widget.task.priority == Priority.normal,
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.normal;
                        });
                      },
                    )),
                const SizedBox(width: 8),
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      label: 'Low',
                      color: lowPriorityColor,
                      isSelected:  widget.task.priority == null || widget.task.priority == Priority.low,
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.low;
                        });
                      },
                    )),
              ],
            ),
            InputField(
              title: 'Title',
              hint: 'Enter your title here...',
              fieldController: _titleController,
            ),
            InputField(
              title: 'Note',
              hint: 'Enter your note here...',
              fieldController: _noteController,
            ),
            InputField(
              title: 'Date',
              hint: DateFormat.yMd().format(_selecteDate),
              child: IconButton(
                onPressed: () => _getDateFromUser(),
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox(
      {Key? key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: _PriorityCheckBoxShape(
                  value: isSelected,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityCheckBoxShape extends StatelessWidget {
  const _PriorityCheckBoxShape({
    Key? key,
    required this.value,
    required this.color,
  }) : super(key: key);
  final bool value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 12,
            )
          : null,
    );
  }
}
