import 'dart:async';
import 'package:databases_with_sqlite/view/modle/usermodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBasesHelper {
  DataBasesHelper._();
  static final DataBasesHelper db = DataBasesHelper._();

  static Database? _dataBases;
  Future<Database?> get dataBases async {
    if (_dataBases == null) {
      _dataBases = await initializeDatabaseMethod();
    }
    return _dataBases;
  }

  Future<Database> initializeDatabaseMethod() async {
    String path = join(await getDatabasesPath(), "databases.db");
    Database myData = await openDatabase(path, version: 1, onCreate: onCereate);

    return myData;
  }

  Future<void> onCereate(Database db, int version) async {
    await db.execute('''CREATE TABLE Users 
        (id INTEGER PRIMARY KEY AUTOINCREMENT,
         name TEXT,
         email TEXT ,
         phone TEXT)''');
    print("+++++++++++++++++TableCreated+++++++++++++++++");
  }

  Future<User?> insertDataInUserModel(User user) async {
    print(user);
    var dbClient = await dataBases;
    await dbClient!.insert("Users", user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print("+++++++++++++++++${user.toMap()} +++++++++++++++++");

    return user;
  }

  Future<User?> UpdattDataInUserModel(User user) async {
    var dbClient = await dataBases;
    await dbClient!.update(
      "Users",
      user.toMap(),
      where: "id=?",
      whereArgs: [user.Id],
    );
    print("+++++++++++++++++ Hello Updated +++++++++++++++++");
  }

  Future<User?> readDataOnlyOneRow(int id) async {
    var dbClient = await dataBases;
    List<Map<String, dynamic>> maps = await dbClient!.query(
      "Users",
      where: "id=?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<User?>> GetDataAll() async {
    var dbClient = await dataBases;
    List<Map<String, dynamic>> maps = await dbClient!.query(
      "Users",
    );

    List<User> list =
        maps.isNotEmpty ? maps.map((user) => User.fromJson(user)).toList() : [];

    return list;
  }

  Future<void> DeleteDataOnlyOneRow(int id) async {
    var dbClient = await dataBases;
    List<Map<String, dynamic>> maps = await dbClient!.query(
      "Users",
      where: "id = ?",
      whereArgs: [id],
    );
    print("+++++++++++++++++ Hello deleted one   +++++++++++++++++");
  }
}
