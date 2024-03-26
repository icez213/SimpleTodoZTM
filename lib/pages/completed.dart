import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/todo.dart';
import '../providers/todo_provider.dart';

class CompletedTodos extends ConsumerWidget {
  const CompletedTodos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> completedTodos = todos
        .where((todo) => todo.completed == true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Todos"),
      ),
      body: ListView.builder(
          itemCount: completedTodos.length,
          itemBuilder: (context, index) {
            return Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      ref
                          .watch(todoProvider.notifier)
                          .deleteTodo(
                              completedTodos[index].todoId);
                    },
                    backgroundColor: Colors.red,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(20)),
                    icon: Icons.delete,
                  )
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.all(
                      Radius.circular(20)),
                ),
                child: ListTile(
                  title:
                      Text(completedTodos[index].content),
                ),
              ),
            );
          }),
    );
  }
}
