import '../models/doctor.dart'; abstract class DoctorRepository { Future<List<Doctor>> loadDoctors(); }
