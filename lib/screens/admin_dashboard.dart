import 'package:booking_app/models/booking.dart';
import 'package:booking_app/providers/auth_provider.dart';
import 'package:booking_app/screens/admin_login.dart';
import 'package:booking_app/utils/constants.dart';
import 'package:booking_app/widgets/booking_item.dart';
import 'package:booking_app/widgets/shared/empty_container.dart';
import 'package:booking_app/widgets/shared/input_widget.dart';
import 'package:booking_app/widgets/shared/loader.dart';
import 'package:booking_app/widgets/shared/primary_button.dart';
import 'package:booking_app/widgets/summary.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = "/admin-dashboard";

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _firstLoad = true, _mainLoading = false;

  List<Booking> available_bookings = [];

  Future<void> _fetchDestinations(userId) async {
    try {
      setState(() {
        _mainLoading = true;
      });
      Dio dio = new Dio();
      dio.options.baseUrl = Constants.BASE_URL;
      List<Booking> _fetchedData = [];
      final resp = await dio.get("/destinations?userId=$userId");
      print(resp.data);

      resp.data.forEach((e) {
        _fetchedData.add(Booking(
          e["id"],
          e["amount"],
          e["name"],
          e["departure_time_formatted"] as List<dynamic>,
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
  void initState() {
    Future.delayed(Duration.zero, () {
      var userId = Provider.of<AuthProvider>(context, listen: false).userId;
      _fetchDestinations(userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
/*    var userId = Provider.of<AuthProvider>(context, listen: false).userId;
    print("User ID: $userId");*/
    var _isLoading = false;
    var _formKey = GlobalKey<FormState>();

    final _ticketIdController = TextEditingController();

    _validate() async {
      _formKey.currentState.save();
      final isValid = _formKey.currentState.validate();
      if (!isValid) return;
      try {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Validating booking..."),
              content: Container(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        );
        Dio dio = new Dio();
        dio.options.baseUrl = Constants.BASE_URL;
        await dio.post("/validate-booking/${_ticketIdController.text}");
        Navigator.pop(context);
        Utils.showSnackBar(
          title: "Booking validated successfully!",
          context: context,
          color: Colors.green,
        );
      } on DioError catch (e) {
        print(e.response.data["message"]);
        Navigator.pop(context);
        Navigator.pop(context);
        Utils.showSnackBar(title: e.response.data["message"], context: context);
      } catch (e) {
        print('Unknown error');
        Navigator.pop(context);
      } /*finally {
        Navigator.pop(context);
      }*/
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Stuff Dashboard"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (val){
              Navigator.pushReplacementNamed(context, AdminLogin.routeName);
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "logout",
                  child: Text("Logout"),
                )
              ];
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Validate A Ticket",
        child: Icon(Icons.qr_code_scanner),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              enableDrag: true,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              builder: (_) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: 14,
                    left: 12,
                    right: 12,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "Validate the booking",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        InputWidget(
                          label: "Booking ID",
                          controller: _ticketIdController,
                          validator: (value) {
                            if (value.isEmpty) return "Booking ID is required";
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        PrimaryButton(
                          text: "Validate",
                          onPressed: _validate,
                          block: true,
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      ),
      body: _mainLoading
          ? Loader()
          : available_bookings == []
              ? EmptyContainer("No destinations")
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SummaryWidget(),
                      SizedBox(height: 20),
                      Text("Destinations: ", style: TextStyle(fontSize: 16)),
                      ...available_bookings
                          .map((e) => BookingItem(
                                isAdmin: true,
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
