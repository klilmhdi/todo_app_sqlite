import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/screens/archived_screen.dart';
import 'package:todo_app/screens/done_screen.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/tasks_screen.dart';
part 'db_state.dart';

class DbCubit extends Cubit<DbState> {
  DbCubit() : super(DbInitial());
  static DbCubit get(context)=>BlocProvider.of(context);

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var currentIndex = 0;
  bool isBottomSheetShown = false;
  IconData floatIcon = Icons.edit;
  Database? db;
  List<Map> tasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Widget> screens = [TasksPage(), DonePage(), ArchivesPage()];
  List<String>titles = ['Tasks', 'Done Tasks', 'Archived Tasks'];

  void ChangeNavBarIndex(int index) {
    currentIndex = index;
    emit(ChangeNavBar());
  }

  void ChangebottomSheet({required bool isShown, required IconData icon}) {
    isBottomSheetShown = isShown;
    floatIcon = icon;
  }

  void CreateDataBase() {
    openDatabase('todoDB', version: 1, onCreate: (Database db, int version) async {
          print("DB created");
          await db.execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)').then((value) {
            print("table created");
          }).catchError((err){print("error ${err}");});
        },
        onOpen:(db){
          GetData(db);
          print("db opened");

        }).then((value){
      db=value;
      emit(CreateDB());
    });
  }

  void GetData(Database db) {
    tasks=[];
    doneTasks=[];
    archivedTasks=[];
    db.rawQuery('SELECT * FROM tasks').then((value) {
      emit(GetDatafromDB());
      value.forEach((element) {
        if(element['status']=='new')
        {
          tasks.add(element);
        }
        else if(element['status']=='done')
        {
          doneTasks.add(element);
        }
        else
        {
          archivedTasks.add(element);
        }
      });
    });
  }

  Future InsertIntoDataBase({required String title, required String date, required String time})async {
    return await db?.transaction((txn)async {
      return await txn.rawInsert(
          'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date","new")').then((value) {
        print("raw inserted");
        emit(InsertIntoDB());
        GetData(db!);
        emit(GetDatafromDB());
      }).catchError((err){print("error when insertion $err");});

    });

  }

  void DeleteFromDataBase({required int id})async {
    db?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value){
      emit(DeleteFromDB());
      print("db deleted");
      GetData(db!);
    });
  }

  void UpdateDataBase({required int id, required String status}) {
    db?.rawUpdate('UPDATE tasks Set status= ? WHERE id= ?',['$status',id]).then((value){
      print("db updated");
      emit(UpdateDB());
      GetData(db!);
      emit(GetDatafromDB());
    });

  }
}
