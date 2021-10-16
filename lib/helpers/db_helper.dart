import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  // NOTE จริง ๆ ไม่ต้องประกาศคลาสก็ได้แต่ต้องการกรุ๊ป และใช้ static method
  static Future<sql.Database> database() async {
    // NOTE craete database
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, ver) async {
      return await db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT , image TEXT , loc_lat REAL, loc_lng REAL, address TEXT)',
      ); // NOTE ฟังก์ชันจะทำงานถ้าหา database ชื่อนี้ไม่เจอ
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    ); // NOTE บอก database ว่าถ้ามีข้อมูลที่เข้ามาแล้ว id ซ้ำให้ทับไปเลย
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
