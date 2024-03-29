import 'package:jezzyshopping/models/sqlite_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDatabase = 'ungjed.db';
  final int versionDatabase = 1;
  final String tableDatabase = 'orderTABLE';
  final String columId = 'id';
  final String columShopcode = 'shopcode';
  final String columNameShop = 'nameshop';
  final String columProductId = 'productId';
  final String columName = 'name';
  final String columUnit = 'unit';
  final String columPrice = 'price';
  final String columAmount = 'amount';
  final String columSum = 'sum';

  SQLiteHelper() {
    initialDatabase();
  }

  Future<void> initialDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $tableDatabase (id INTEGER PRIMARY KEY, $columShopcode TEXT, $columNameShop TEXT, $columProductId TEXT, $columName TEXT, $columUnit TEXT, $columPrice TEXT, $columAmount TEXT, $columSum TEXT)'),
      version: versionDatabase,
    );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
    );
  }

  Future<void> insertSQLite({required SQLiteModel sqLiteModel}) async {
    Database database = await connectedDatabase();
    await database
        .insert(tableDatabase, sqLiteModel.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      print('Insert ${sqLiteModel.name} Success');
    });
  }

  Future<List<SQLiteModel>> readAllSQLite() async {
    var sqliteModels = <SQLiteModel>[];

    Database database = await connectedDatabase();
    var result = await database.query(tableDatabase);
    for (var element in result) {
      SQLiteModel sqLiteModel = SQLiteModel.fromMap(element);
      sqliteModels.add(sqLiteModel);
    }

    return sqliteModels;
  }

  Future<void> editAmount(
      {required int idEdit, required SQLiteModel sqLiteModel}) async {
    Database database = await connectedDatabase();

    await database
        .update(tableDatabase, sqLiteModel.toMap(), where: '$columId = $idEdit')
        .then((value) {
      print('Edit SQLite Success');
    });
  }

  Future<void> deleteValueWhereId({required int idDelete}) async {
    Database database = await connectedDatabase();
    await database
        .delete(tableDatabase, where: '$columId = $idDelete')
        .then((value) {
      print('Delete SQLite at id : $idDelete Sucess');
    });
  }

  Future<void> clearSQLite() async {
    Database database = await connectedDatabase();
    await database.delete(tableDatabase).then((value) {
      print('Empty SQLite Success');
    });
  }
} // End Clase