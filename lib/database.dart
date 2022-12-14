import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'Users.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    //example database
    final List users = [
      Users(username: "Kareem", email: "Kareem@gmail.com", balance: 1000),
      Users(username: "ahmed", email: "ahmed@gmail.com", balance: 10000),
      Users(username: "kamel", email: "kamel@gmail.com", balance: 10000),
      Users(username: "asmaa", email: "asmaa@gmail.com", balance: 10000),
      Users(username: "nourhan", email: "nourhan@gmail.com", balance: 10000),
      Users(username: "ali", email: "ali@gmail.com", balance: 10000),
      Users(username: "donia", email: "donia@gmail.com", balance: 10000),
      Users(username: "kamr", email: "kamr@gmail.com", balance: 10000),
      Users(username: "ahmed", email: "ahmed@gmail.com", balance: 10000),
      Users(username: "mahmoud", email: "mahmoud@gmail.com", balance: 10000),
    ];

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();

    return await openDatabase(join(documentsDirectory.path, 'banking.db'),
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE users(username TEXT PRIMARY KEY, 
      email TEXT, balance INTEGER)''');
      print(join(await getDatabasesPath(), 'banking.db'));
      for (int index = 0; index < users.length; index++) {
        newUser(users[index]);
      }
    }, version: 1);
  }

  Future newUser(Users newUser) async {
    final db = await database;
    var res = await db.rawInsert('''INSERT INTO users(username, email, balance)
    VALUES(?,?,?)''', [newUser.username, newUser.email, newUser.balance]);
    return res;
  }

  Future<List<Users>> getAllUsers() async {
    final db = await database;
    List res =
        await db.query('users', columns: ['username', 'email', 'balance']);
    List<Users> userlist = [];
    res.forEach((element) {
      Users user = Users.fromMap(element);
      userlist.add(user);
    });
    return userlist;
  }

  Future<int> updateBalance(int balance, username) async {
    final db = await database;
    int res = await db.rawUpdate(
        'UPDATE users SET balance = $balance WHERE username = "$username"');
    print("updated balance on $res");
    return res;
  }

  Future<List<Map<String, dynamic>>> getUser(String username) async {
    final db = await database;
    var res =
        await db.rawQuery('SELECT * FROM "users" WHERE username = "$username"');
    return res;
  }
}
