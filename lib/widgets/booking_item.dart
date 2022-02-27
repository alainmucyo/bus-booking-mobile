import 'package:booking_app/models/booking.dart';
import 'package:booking_app/screens/admin_reports.dart';
import 'package:booking_app/screens/destination.dart';
import 'package:booking_app/utils/constants.dart';
import 'package:booking_app/widgets/shared/card_container.dart';
import 'package:flutter/material.dart';

class BookingItem extends StatelessWidget {
  final Booking booking;
  final bool isAdmin;

  const BookingItem({Key key, this.booking, this.isAdmin = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () {
          if (isAdmin) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminReports(
                  key: ValueKey(booking.id),
                  booking: booking,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DestinationScreen(
                  key: ValueKey(booking.id),
                  destination: booking,
                ),
              ),
            );
          }
        },
        child: CardContainer(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: CustomColor.PRIMARY,
              child: Text(
                "#${booking.id}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              booking.name,
              style: TextStyle(fontSize: 19),
            ),
            subtitle: Text("${Utils.numberFormat(booking.amount)} RWF"),
            trailing: Icon(Icons.car_rental),
          ),
        ),
      ),
    );
  }
}
