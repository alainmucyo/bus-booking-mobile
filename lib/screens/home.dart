import 'package:booking_app/models/booking.dart';
import 'package:booking_app/screens/admin_login.dart';
import 'package:booking_app/utils/constants.dart';
import 'package:booking_app/widgets/booking_item.dart';
import 'package:booking_app/widgets/shared/empty_container.dart';
import 'package:booking_app/widgets/shared/loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _firstLoad = true, _mainLoading = false;
  List<Booking> available_bookings = [];

  Future<void> _fetchDestinations() async {
    try {
      setState(() {
        _mainLoading = true;
      });
      Dio dio = new Dio();
      dio.options.baseUrl = Constants.BASE_URL;
      List<Booking> _fetchedData = [];
      final resp = await dio.get("/destinations");
      print(resp.data);

      resp.data.forEach((e) {
        _fetchedData.add(Booking(
          e["id"],
          e["amount"],
          e["name"],
          e["departure_time_formatted"]
        ));
      });
      setState(() {
        available_bookings = _fetchedData;
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
  void didChangeDependencies() {
    if (!_firstLoad) return;
    _fetchDestinations();
    _firstLoad = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Horizon Bus"),
        centerTitle: true,
        actions: [
          PopupMenuButton(onSelected: (val) {
            Navigator.pushNamed(context, AdminLogin.routeName);
          }, itemBuilder: (ctx) {
            return [
              PopupMenuItem(
                child: Text("Login As staff"),
                value: "login",
              ),
            ];
          }),
        ],
      ),
      body: _mainLoading
          ? Loader()
          : available_bookings == []
              ? EmptyContainer("No destinations")
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Murakaza neza! Muhitemo urugendo.",
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ...available_bookings
                          .map((e) => BookingItem(
                                key: ValueKey(e.id),
                                booking: e,
                              ))
                          .toList()
                    ],
                  ),
                ),
    );
  }
}
