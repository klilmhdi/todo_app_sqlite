import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/share/bloc/db_cubit.dart';
import 'package:todo_app/share/components.dart';

class ArchivesPage extends StatelessWidget {
  const ArchivesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DbCubit cubit = DbCubit.get(context);
    return BlocConsumer<DbCubit, DbState>(
        builder: (context, State){
          return tasksList(tasks: cubit.archivedTasks);
        },
        listener: (context,state){});
    throw UnimplementedError();
  }
}
