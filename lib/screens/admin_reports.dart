import 'package:booking_app/models/booking.dart';
import 'package:booking_app/providers/auth_provider.dart';
import 'package:booking_app/utils/constants.dart';
import 'package:booking_app/widgets/admin_booking_item.dart';
import 'package:booking_app/widgets/shared/empty_container.dart';
import 'package:booking_app/widgets/shared/loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminReports extends StatefulWidget {
  final Booking booking;

  const AdminReports({Key key, this.booking}) : super(key: key);

  @override
  _AdminReportsState createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  bool  _mainLoading = false;

  List<dynamic> _bookings = [];

  Future<void> _fetchBookings(userId) async {
    try {
      setState(() {
        _mainLoading = true;
      });
      Dio dio = new Dio();
      dio.options.baseUrl = Constants.BASE_URL;
      final resp = await dio
          .get("/bookings?destination_id=${widget.booking.id}&userId=$userId");
      print(resp.data);

      setState(() {
        _bookings = resp.data;
      });
    } catch (e) {
      print(e);
      Utils.showSnackBar(title: "Something went wrong", context: context);
    } finally {
      setState(() {
        _mainLoading = false;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final userId = Provider.of<AuthProvider>(context, listen: false).userId;
      _fetchBookings(userId);
    });
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.booking.name),
      ),
      body: _mainLoading
          ? Loader()
          : _bookings == []
              ? EmptyContainer("No bookings available")
              : ListView.builder(
                  itemCount: _bookings.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemBuilder: (ctx, i) {
                    return AdminBookingItem(
                      key: ValueKey(_bookings[i]["id"]),
                      booking: _bookings[i],
                    );
                  },
                ),
    );
  }
}
