
enum TaskItemActionsEnum{
  marAsDone(name: "Done | UnDone"),
  edit(name: "Edit"),
  delete(name: "Delete");

  final String name;
  const TaskItemActionsEnum({required this.name});
}