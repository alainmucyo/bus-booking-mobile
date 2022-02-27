import 'package:booking_app/widgets/shared/card_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminBookingItem extends StatelessWidget {
  final Map<String, dynamic> booking;

  const AdminBookingItem({Key key, this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CardContainer(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: booking["scanned"] == 1 ? Theme.of(context).accentColor: null,
            child: booking["scanned"] == 1 ? Icon(Icons.check) : Icon(Icons.pending),
          ),
          title: Text(booking["names"]),
          subtitle: Text(booking["phone_number"]),
          trailing: Text(DateFormat.yMEd().format(
                DateTime.parse(
                  booking["departure_time"],
                ),
              ) +
              " at " +
              DateFormat.Hm().format(
                DateTime.parse(
                  booking["departure_time"],
                ),
              )),
        ),
      ),
    );
  }
}
