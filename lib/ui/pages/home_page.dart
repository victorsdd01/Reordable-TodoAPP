import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/blocs.dart';
import 'package:todo_app/models/models.dart';
import 'package:uuid/uuid.dart';

import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late TextEditingController titleController;
  late TextEditingController descriptionController;


  FocusNode descriptionFocus = FocusNode();


  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    descriptionFocus.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // final Size size =  MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if(state.tasks.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: NoTasks(),
                    )
                  );
                }
                return const Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                        child: _Top(),
                      ),
                      _Tasks(),
                    ],
                  ),
                );
              },
            ),
            const ColoredBox(
              color: Colors.white,
              child: _Footer()
            )
          ],
        ),
      )
    );
  }
}

class NoTasks extends StatelessWidget {
  const NoTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/icons/investigation.png', fit: BoxFit.cover, height: 200, width: 200,),
        const Text('Your task list is empty', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),),
        Text('You don´t have any active tasks right', style: TextStyle(fontSize: 14, color: Colors.grey.shade500),),
        Text('now. Try to add some!', style: TextStyle(fontSize: 14, color: Colors.grey.shade500),),
      ],
    );
  }
}

class _Footer extends StatefulWidget {
  const _Footer({
    super.key,
  });

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {

  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              value.trim().isNotEmpty 
                ? context.read<TodoBloc>().add(const AddDisableStateEvent(disable: false)) 
                : (!context.read<TodoBloc>().state.disable && value.trim().isEmpty 
                    ? context.read<TodoBloc>().add(const AddDisableStateEvent(disable: true)) 
                    : null
                  );
            },
            decoration: InputDecoration(
              hintText: 'Add new task',
              suffixIcon: IconButton(
                icon: const Icon(Icons.cancel_outlined), 
                color: Theme.of(context).primaryColor, 
                onPressed: () => _controller.text = ''
              )
            ),
            
          ),
        ),
        const SizedBox(height: 10,),
        Button(
          onClick: () {
            context.read<TodoBloc>().add(AddNeWTaskEvent(
              newTask: Task(
                  id: const Uuid().v4(), 
                  title: _controller.text, 
                  completed: false,  
                )
              )
            );
            _controller.text = '';
            context.read<TodoBloc>().add(const AddDisableStateEvent(disable: true));
          }
        )
      ],
    );
  }
}

class _Top extends StatelessWidget {
  const _Top({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('''Today's Tasks''', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800 )),
                  TextButton(
                    onPressed: () => context.read<TodoBloc>().add(const AddAllTasksEvent(tasks: [])),
                    child:  Text('CLEAR ALL', style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor, ),)
                  ),
                ],
              ),
            ),
            Row(
              children: [
                BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    return Text('(${state.completedTasks.length}/${state.tasks.length}) Completed Tasks', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, ),);
                  },
                ),
              ],
            ),
          ],
        ),
    );
  }
}

class _Tasks extends StatelessWidget {
  const _Tasks({
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return ReorderableListView.builder(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation, 
                builder: (context, child) {
                  final double animValue = Curves.easeInOut.transform(animation.value);
                  final double scale = lerpDouble(1, 1.02, animValue)!;
                  final Task task = state.tasks[index];
                  return Transform.scale(
                    scale: scale,
                    child: Item(
                      task: task
                    )
                  );
                },
              );
            },
            itemBuilder: (context, index) {
              final Task task = state.tasks[index];
              return Item(
                key: Key(task.id),
                task: task
              );
            }, 
            itemCount: context.watch<TodoBloc>().state.tasks.length, 
            onReorder: (oldIndex, newIndex) => context.read<TodoBloc>().add(UpdateItemPositionListEvent(oldIndex: oldIndex, newIndex: newIndex))
          );
        },
      )
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Checkbox.adaptive(
            activeColor: Theme.of(context).primaryColor,
            value: task.completed, 
            onChanged: (value) {
              task.completed = value!;
              context.read<TodoBloc>().add(UpdateTaskEvent(updatedTask: task));
            },
          ),
          Text(task.title,
          style:  TextStyle(
              color: task.completed ? Colors.grey.shade400 : null,
              decoration: task.completed ? TextDecoration.lineThrough : null,
              decorationColor: Colors.grey.shade600
            ), 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis ,

          ),
          const Spacer(),
          IconButton.filled(
            color: Colors.red,
            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xfffceaea))),
            iconSize: 18,
            onPressed: () => context.read<TodoBloc>().add(DeleteTaskEvent(task: task)),
            icon: const Icon(Icons.delete)
          )
        ],
      )
    );
  }
}