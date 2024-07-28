


import 'package:get_it/get_it.dart';
import 'package:todo_app/domain/blocs.dart';

GetIt getIt =  GetIt.instance;


void initServiceLocator(){


  getIt.registerSingleton(TodoBloc()); 


}