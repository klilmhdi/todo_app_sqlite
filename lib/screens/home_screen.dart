import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/share/bloc/db_cubit.dart';
import 'package:todo_app/share/components.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DbCubit()..CreateDataBase(),
      child: BlocConsumer<DbCubit, DbState>(
        listener: (context, status) {
          if (status is InsertIntoDB) {
            Navigator.pop(context);
          }
        },
        builder: (context, status) {
          DbCubit cubit = DbCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            key: cubit.scaffoldkey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.deepOrange,
              elevation: 0.1,
              title: Text(
                'To Do',
                style: TextStyle(color: Colors.white),
              ),
            ),
            floatingActionButton: cubit.currentIndex == 0 ? FloatingActionButton(
              onPressed: () {
            if (cubit.isBottomSheetShown) {
              if (cubit.scaffoldkey.currentState != null &&
                  cubit.formkey.currentState != null &&
                  cubit.formkey.currentState!.validate()) {
                cubit.InsertIntoDataBase(
                    title: cubit.titleController.text,
                    date: cubit.dateController.text,
                    time: cubit.timeController.text);
              }
            } else {
              cubit.isBottomSheetShown = true;
              cubit.scaffoldkey.currentState!.showBottomSheet((context) => Container(
                color: Colors.white,
                child: Form(
                  key: cubit.formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: defaultTextFormField(
                          validator: ( value) {
                            if (value!.isEmpty) {
                              return 'Tasks Must be not  empty';
                            }
                            return null;
                          },

                          controller: cubit.titleController,
                          keyboaredType: TextInputType.text,
                          Label: 'Tasks title',
                          prefix: Icons.title,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: defaultTextFormField(

                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Date Must be not empty';
                            }
                            return null;
                          },
                          controller: cubit.dateController,
                          keyboaredType: TextInputType.datetime,
                          Label: 'Date',
                          prefix: Icons.calendar_month,
                          ontap: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                DateTime.parse('2030-01-01'))
                                .then((value) => {
                              cubit.dateController.text =
                                  DateFormat.yMMMd()
                                      .format(value!),
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),


                        child: defaultTextFormField(
                          validator: ( value) {
                            if (value!.isEmpty) {
                              return 'time must be not empty';
                            }
                            return null;
                          },

                          controller: cubit.timeController,
                          keyboaredType: TextInputType.datetime,
                          Label: 'Date',
                          prefix: Icons.watch,
                          ontap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then(
                                  (value) => {
                                print(value!.format(context)),
                                cubit.timeController.text =
                                    value.format(context).toString(),
                              },
                            );
                          },
                        ),
                      ),
                      /////
                    ],
                  ),
                ),
              ),
              ).closed.then((value) {
                cubit.ChangebottomSheet(isShown: false, icon: Icons.edit);
              });
              cubit.ChangebottomSheet(isShown: true, icon: Icons.add);
            }
          }, ////
          child: Icon(
          cubit.floatIcon,
          ),
          ) : null,
            bottomNavigationBar: BottomNavigationBar(
              selectedFontSize: 20.0,
              elevation: 15.0,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.ChangeNavBarIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.table_rows_sharp),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
          );
        },
      ),
    );
  }
}

