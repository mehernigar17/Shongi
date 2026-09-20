import '../models/daily_log.dart';

abstract class LogRepository {
  Future<List<DailyLog>> loadLogs({DateTime? from, DateTime? to});
  Future<void> saveLog(DailyLog log);
  Future<void> deleteLog(String id);
}