import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/enums/task_filter_enum.dart';
import '../../../data/models/total_tasks_model.dart';
import '../home_controller.dart';

class TodoCardFilter extends StatelessWidget {
  final String label;
  final TaskFilterEnum taskFilter;
  final TotalTasksModel? totalTasksModel;
  final bool selected;

  const TodoCardFilter({
    Key? key,
    required this.label,
    required this.taskFilter,
    this.totalTasksModel,
    required this.selected,
  }) : super(key: key);

  int? get totalRemainTasks =>
      totalTasksModel!.totalTasks - totalTasksModel!.totalTasksFinish;

  double _getPercentFinish() {
    final total = totalTasksModel?.totalTasks ?? 0;
    final totalFinish = totalTasksModel?.totalTasksFinish ?? 0.1;

    if (total == 0) return 0.0;

    final percent = (totalFinish * 100) / total;
    return percent / 100;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<HomeController>().findTasks(filter: taskFilter),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 120,
          maxWidth: 150,
        ),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(.8)),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${totalRemainTasks ?? 0} TASKS',
              style: TextStyle(
                fontSize: 10,
                color: selected ? Colors.white : Colors.grey,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.0,
                end: _getPercentFinish(),
              ),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  backgroundColor: selected
                      ? Theme.of(context).primaryColorLight
                      : Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      selected ? Colors.white : Theme.of(context).primaryColor),
                  value: value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
