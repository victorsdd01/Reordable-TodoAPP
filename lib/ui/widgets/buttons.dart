import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/blocs.dart';

class Button extends StatelessWidget {
  const Button({
    super.key, required this.onClick,
  });

  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => state.disable ? null : onClick(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              color:state.disable ? Colors.grey.shade400 : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(5.0)
        
            ),
            height: 50,
            width: double.maxFinite,
            child: const Center(child: Text('ADD TASK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),)),
          ),
        );
      },
    );
  }
}