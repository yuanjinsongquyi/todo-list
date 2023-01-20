import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todo_list/data/repo/repository.dart';
import 'package:todo_list/data/source/task.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/views/edit.dart';
import 'package:todo_list/widget/widgets.dart';

import '../widget/task_item.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskEditScreen(
                  task: Task(),
                ),
              ),
            );
          },
          label: const Text('Add New Task')),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Do List',
                          style: themeData.textTheme.headline6!.apply(
                            color: themeData.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: themeData.colorScheme.onPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          searchKeywordNotifier.value = _controller.text;
                        },
                        controller: _controller,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search tasks...'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: searchKeywordNotifier,
                builder: (context, value, child) {
                  return Consumer<Repository<Task>>(
                    builder: (context, repository, child) {
                      return FutureBuilder<List<Task>>(
                        future:
                            repository.getAll(searchKeyword: _controller.text),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 100),
                                child: TaskList(
                                    items: snapshot.data!,
                                    themeData: themeData),
                              );
                            } else {
                              return const EmptyState();
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.items,
    required this.themeData,
  }) : super(key: key);

  final List<Task> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tasks',
                    style: themeData.textTheme.headline6,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 70,
                    height: 3,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  )
                ],
              ),
              MaterialButton(
                color: const Color(0xffeaeff5),
                textColor: secondaryTextColor,
                elevation: 0,
                onPressed: (() {
                  final taskRepository =
                      Provider.of<Repository<Task>>(context, listen: false);
                  taskRepository.deleteAll();
                }),
                child: Row(
                  children: const [
                    Text('Delete all'),
                    SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.delete_solid,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          final Task task = items.toList()[index - 1];
          return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                final taskRepository =
                Provider.of<Repository<Task>>(context, listen: false);
                taskRepository.deleteById(task.id);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('${task.title} is deleted')));
              },
              background: Container(color: Colors.red),
              child: TaskItem(task: task));
        }
      },
    );
  }
}
