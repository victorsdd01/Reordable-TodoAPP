part of 'todo_bloc.dart';

 class TodoState extends Equatable {

  final List<Task> tasks;
  final bool disable;
  final List<Task> completedTasks;

  const TodoState({
    this.tasks= const [],
    this.disable = true,
    this.completedTasks =const []
  });

  TodoState copyWith({
    List<Task>? tasks,
    bool? disable,
    List<Task>? completedTasks
  }) => TodoState(
    tasks: tasks ?? this.tasks,
    disable: disable ?? this.disable,
    completedTasks: completedTasks ?? this.completedTasks
  );
  
  @override
  List<Object> get props => [
    tasks,
    disable,
    completedTasks
  ];
}
