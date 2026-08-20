import '../models/statistics_data.dart'; abstract class StatisticsRepository { Future<StatisticsData> load(int rangeIndex); }
