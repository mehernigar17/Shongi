import '../models/period_entry.dart';

abstract class PeriodRepository {
  Future<List<PeriodEntry>> loadPeriods();
  Future<void> addPeriod(PeriodEntry entry);
  Future<void> deletePeriod(String id);
}