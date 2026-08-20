import 'package:flutter/material.dart';
import '../features/doctors/views/booking_view.dart';
import '../features/doctors/models/doctor.dart';
class AppRouter { static Route<void> booking(Doctor doctor) => MaterialPageRoute<void>(builder: (_) => BookingView(doctor: doctor)); }
