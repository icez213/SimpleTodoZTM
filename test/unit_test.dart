import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/providers/todo_provider.dart';

void main() {
  late ProviderContainer container;
  late TodoListNotifier notifier;

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(todoProvider.notifier);
  });

  test('todo list starts empty', () {
    //Asset
    expect(notifier.state, []);
  });

  test('add todo', () {
    //Act
    notifier.addTodo("record video");
    expect(notifier.state[0].content, "record video");
  });

  test('delete todo', () {
    //Arrange
    notifier.addTodo("record video");
    expect(notifier.state[0].content, "record video");

    //Act
    notifier.deleteTodo(notifier.state[0].todoId);
    expect(notifier.state, []);
  });

  test('complete todo', () {
    //Arrange
    notifier.addTodo("record video");
    expect(notifier.state[0].content, "record video");
    expect(notifier.state[0].completed, false);

    notifier.completeTodo(notifier.state[0].todoId);
    expect(notifier.state[0].completed, true);
  });
}
