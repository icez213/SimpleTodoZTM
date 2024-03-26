import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/pages/add.dart';
import 'package:todo/pages/completed.dart';

import '../models/todo.dart';
import '../providers/todo_provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> activeTodos = todos
        .where((todo) => todo.completed == false)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      body: activeTodos.isEmpty &&
              todos.length - activeTodos.length <= 0
          ? const Center(
              child:
                  Text("Add a todo using the button below"),
            )
          : ListView.builder(
              itemCount: activeTodos.length + 1,
              itemBuilder: (context, index) {
                if (index == activeTodos.length) {
                  if (todos.length - activeTodos.length <=
                      0) {
                    return Container();
                  } else {
                    return Center(
                      child: TextButton(
                        child:
                            const Text("Completed Todos"),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CompletedTodos()));
                        },
                      ),
                    );
                  }
                } else {
                  return Slidable(
                    key: ValueKey(
                        todos[index].todoId.toString()),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          key: ValueKey(
                              "${todos[index].todoId}delete"),
                          onPressed: (context) {
                            ref
                                .watch(
                                    todoProvider.notifier)
                                .deleteTodo(
                                    activeTodos[index]
                                        .todoId);
                          },
                          backgroundColor: Colors.red,
                          borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(20)),
                          icon: Icons.delete,
                        )
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            ref
                                .watch(
                                    todoProvider.notifier)
                                .completeTodo(
                                    activeTodos[index]
                                        .todoId);
                          },
                          backgroundColor: Colors.green,
                          borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(20)),
                          icon: Icons.check,
                        )
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            const BorderRadius.all(
                                Radius.circular(20)),
                      ),
                      child: ListTile(
                          title: Text(
                              activeTodos[index].content)),
                    ),
                  );
                }
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddTodo()));
        },
        tooltip: 'Increment',
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ),
    );
  }
}
