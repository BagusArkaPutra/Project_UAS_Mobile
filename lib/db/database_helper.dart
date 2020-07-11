import 'dart:io';

import 'package:aplikasitask/db/model/kebiasaan_model.dart';
import 'package:aplikasitask/db/model/tracking_model.dart';
import 'package:aplikasitask/utils/core_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  // jadikan ini kelas singleton
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // hanya memiliki satu rujukan seluruh aplikasi ke database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    //  instantiate db saat pertama kali diakses
    _database = await _initDatabase();
    return _database;
  }

  // ini membuka basis data (dan membuatnya jika tidak ada)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Kode SQL untuk membuat tabel database
  Future _onCreate(Database db, int version) async {
    await db.execute(KebiasaanModel.getCreateTableQuery());
    await db.execute(TrackingModel.getCreateTableQuery());
  }

  // Metode pembantu
  // Menyisipkan baris dalam database di mana setiap kunci di Peta adalah nama kolom
  // dan nilainya adalah nilai kolom. Nilai kembali adalah id dari
  // baris yang dimasukkan.
  Future<int> insertHabitModel(KebiasaanModel kebiasaanModel) async {
    Database db = await instance.database;
    Map<String, dynamic> row = kebiasaanModel.getRow();
    return await db.insert(KebiasaanModel.TABLE_NAME, row);
  }

  Future<int> updateHabitModel(KebiasaanModel habitModel) async {
    Database db = await instance.database;
    Map<String, dynamic> row = habitModel.getRow();
    return await db.update(KebiasaanModel.TABLE_NAME, row,
        where: '${KebiasaanModel.COLUMN_ID} = ?', whereArgs: [habitModel.id]);
  }

  Future<int> insertTrackingModel(TrackingModel trackingModel) async {
    Database db = await instance.database;
    Map<String, dynamic> row = trackingModel.getRow();
    return await db.insert(TrackingModel.TABLE_NAME, row);
  }

  Future<int> deleteTrackingModel(int trackingId) async {
    Database db = await instance.database;
    return await db.delete(TrackingModel.TABLE_NAME,
        where: '${TrackingModel.COLUMN_ID} = ?', whereArgs: [trackingId]);
  }

  // Semua baris dikembalikan sebagai daftar peta, di mana setiap peta berada
  // daftar kunci-nilai kolom.
  Future<List<KebiasaanModel>> queryAllHabits() async {
    Database db = await instance.database;

    final allHabits = await db.query(KebiasaanModel.TABLE_NAME);
    return allHabits
        .map((e) => KebiasaanModel.getHabitModelFromRow(e))
        .toList();
  }

  Future<KebiasaanModel> getHabitById(int id) async {
    Database db = await instance.database;
    return await db
        .rawQuery('SELECT * FROM ${KebiasaanModel.TABLE_NAME} WHERE id=$id')
        .then((value) =>
            value.map((e) => KebiasaanModel.getHabitModelFromRow(e)).first);
  }

  Future<List<TrackingModel>> queryAllTracking(int habitId) async {
    Database db = await instance.database;
    return await db
        .rawQuery(
            'SELECT * FROM ${TrackingModel.TABLE_NAME} WHERE ${TrackingModel.COLUMN_HABIT_ID}=$habitId')
        .then((value) => value
            .map((e) => TrackingModel.getTrackingModelFromRow(e))
            .toList());
  }

  Future<List<TrackingModel>> queryAllTrackingDetails() async {
    Database db = await instance.database;
    final list = await db.rawQuery(
        'SELECT * FROM ${TrackingModel.TABLE_NAME} WHERE ${TrackingModel.COLUMN_CHECKED_DATE} >= ${CoreUtils.getWeek()[0].dateTime.millisecondsSinceEpoch}');
    return list.map((e) => TrackingModel.getTrackingModelFromRow(e)).toList();
  }

  Future<void> deleteHabitAndData(int habitId) async {
    Database db = await instance.database;
    await db.delete(KebiasaanModel.TABLE_NAME,
        where: '${KebiasaanModel.COLUMN_ID} = ?', whereArgs: [habitId]);
    await db.delete(TrackingModel.TABLE_NAME,
        where: '${TrackingModel.COLUMN_HABIT_ID} = ?', whereArgs: [habitId]);
  }
}
