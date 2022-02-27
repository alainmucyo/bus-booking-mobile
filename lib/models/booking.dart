import 'package:flutter/foundation.dart';

class Booking {
  @required
  final int id;
  @required
  final int amount;
  @required
  final String name;
  final List<dynamic> departureTimes;

  Booking(this.id, this.amount, this.name, this.departureTimes);
}
