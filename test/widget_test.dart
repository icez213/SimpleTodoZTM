import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/main.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/pages/completed.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/providers/todo_provider.dart';

void main() {
  testWidgets("default state", (widgetTester) async {
    await widgetTester
        .pumpWidget(const ProviderScope(child: MyApp()));

    Finder defaultText =
        find.text("Add a todo using the button below");

    expect(defaultText, findsOneWidget);
  });
  testWidgets("completed todos show up on completed page",
      (widgetTester) async {
    TodoListNotifier notifier = TodoListNotifier(<Todo>[
      Todo(
          todoId: 0,
          content: "record video",
          completed: true)
    ]);

    await widgetTester.pumpWidget(
      ProviderScope(
        overrides: [
          todoProvider.overrideWith((ref) => notifier),
        ],
        child: const MaterialApp(home: CompletedTodos()),
      ),
    );

    Finder completedText = find.text("record video");

    expect(completedText, findsOneWidget);
  });

  testWidgets("slide and delete a todo", (tester) async {
    TodoListNotifier notifier = TodoListNotifier(
      <Todo>[
        Todo(
            todoId: 0,
            content: "record video",
            completed: false)
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todoProvider.overrideWith((ref) => notifier),
        ],
        child: const MaterialApp(home: MyHomePage()),
      ),
    );
    Finder completedText = find.text("record video");

    expect(completedText, findsOneWidget);

    Finder draggableWidget =
        find.byKey(const ValueKey("0"));
    Finder deleteButton =
        find.byKey(const ValueKey("0delete"));
    await tester.timedDrag(draggableWidget,
        const Offset(200, 0), const Duration(seconds: 1));
    await tester.pump();
    await tester.tap(deleteButton);
    await tester.pump();

    Finder defaultText =
        find.text("Add a todo using the button below");
    expect(defaultText, findsOneWidget);
  });
}
