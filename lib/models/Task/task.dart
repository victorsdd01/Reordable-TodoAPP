

import 'package:equatable/equatable.dart';

class Task  extends Equatable {
  String id;
  String title;
  String? description;
  bool completed;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
  });


  factory Task.fromMap(Map<String,dynamic> json) => Task(
    id:json[' id'], 
    title:json[' title'], 
    description:json[' description'], 
    completed:json[' completed']
  );

  Map<String, dynamic> toJson() => {};
  
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    completed,
  ];
}