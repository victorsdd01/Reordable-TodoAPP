part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class AddAllTasksEvent extends TodoEvent{
  final List<Task> tasks;
  const AddAllTasksEvent({required this.tasks});
}

class AddNeWTaskEvent extends TodoEvent{
  final Task newTask;
  const AddNeWTaskEvent({required this.newTask});
}

class UpdateTaskEvent extends TodoEvent{  
  final Task updatedTask;
  const UpdateTaskEvent({required this.updatedTask});
}

class DeleteTaskEvent extends TodoEvent{  
  final Task task;
  const DeleteTaskEvent({required this.task});
}

class UpdateItemPositionListEvent extends TodoEvent{
  final int oldIndex, newIndex;
  const UpdateItemPositionListEvent({required this.oldIndex, required this.newIndex});
}

class AddDisableStateEvent extends TodoEvent{
  final bool disable;
  const AddDisableStateEvent({required this.disable});
}

class CompleteTAskEvent extends TodoEvent{
  final Task completedTask;
  const CompleteTAskEvent({required this.completedTask});
}

class RemoveCompleteTaskEvent extends TodoEvent{
  final String taskToDeleteId;
  const RemoveCompleteTaskEvent({required this.taskToDeleteId});
}
