part of 'db_cubit.dart';

@immutable
abstract class DbState {}

class DbInitial extends DbState {}

class ChangeNavBar extends DbState{}

class CreateDB extends DbState{}

class InsertIntoDB extends DbState{}

class GetDatafromDB extends DbState{}

class UpdateDB extends DbState{}

class DeleteFromDB extends DbState{}

class ChangeIconState extends DbState{}

class ChangeBottomSheetState extends DbState{}

class AppGetDatabaseLoadingState extends DbState{}

