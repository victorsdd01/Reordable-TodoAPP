import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<AddAllTasksEvent>((event, emit) => emit(state.copyWith(tasks: event.tasks)) );
    on<AddNeWTaskEvent>(_addNewTaskEvent);
    on<UpdateTaskEvent>(_updateTaskEvent);
    on<DeleteTaskEvent>(_deleteTaskEvent);
    on<UpdateItemPositionListEvent>(_updateItemPositionListEvent);
    on<AddDisableStateEvent>((event, emit)=> emit(state.copyWith(disable: event.disable)));
    on<CompleteTAskEvent>(_addCompletedTaskEvent);
    on<RemoveCompleteTaskEvent>(_removeCompleteTaskEvent);
  }

  FutureOr<void> _removeCompleteTaskEvent(RemoveCompleteTaskEvent event,Emitter<TodoState> emit) {
    final List<Task> updatedList = List.from(state.completedTasks);
    updatedList.removeWhere((task)=> task.id == event.taskToDeleteId);
    emit(state.copyWith(completedTasks: updatedList));
  }

  FutureOr<void> _addCompletedTaskEvent(CompleteTAskEvent event, Emitter<TodoState> emit) {
    final List<Task> updatedList = List.from(state.completedTasks);
    updatedList.add(event.completedTask);
    emit(state.copyWith(completedTasks: updatedList));
  }


  FutureOr<void> _addNewTaskEvent(AddNeWTaskEvent event,Emitter<TodoState> emit){
    final List<Task> updatedList = List.from(state.tasks);
    updatedList.add(event.newTask);
    emit(state.copyWith(tasks: updatedList));
  }

  FutureOr<void> _updateTaskEvent(UpdateTaskEvent event, Emitter<TodoState> emit){
    final List<Task> updatedList = List.from(state.tasks);
    final int taskIndex =  updatedList.indexWhere((task)=> task.id == event.updatedTask.id);
    updatedList[taskIndex].completed = event.updatedTask.completed;
    if (updatedList[taskIndex].completed) {
      add(CompleteTAskEvent(completedTask: updatedList[taskIndex]));
    } else {
      //Remove the complete task if the complete value comes false...
      add(RemoveCompleteTaskEvent(taskToDeleteId: updatedList[taskIndex].id));
    }
    emit(state.copyWith(tasks: updatedList));
  }

  FutureOr<void> _deleteTaskEvent(DeleteTaskEvent event, Emitter<TodoState> emit){
    final List<Task> updatedList = List.from(state.tasks);
    updatedList.removeWhere((task)=> task.id == event.task.id);
    emit(state.copyWith(tasks: updatedList));
  }

  FutureOr<void> _updateItemPositionListEvent(UpdateItemPositionListEvent event, Emitter<TodoState> emit){
    final List<Task> updatedList = List.from(state.tasks);
    final Task task = updatedList.removeAt(event.oldIndex);

    int adjustedIndex = event.newIndex;
    if (event.newIndex > event.oldIndex) {
      adjustedIndex -= 1;
    }

    if (adjustedIndex < 0) {
      adjustedIndex = 0;
    } else if (adjustedIndex > updatedList.length) {
      adjustedIndex = updatedList.length;
    }

    updatedList.insert(adjustedIndex, task);
    emit(state.copyWith(tasks: updatedList));
  }
}
