import 'package:booking_app/models/booking.dart';
import 'package:booking_app/screens/payments_webview.dart';
import 'package:booking_app/utils/constants.dart';
import 'package:booking_app/widgets/shared/input_widget.dart';
import 'package:booking_app/widgets/shared/primary_button.dart';
import 'package:booking_app/widgets/shared/select_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DestinationScreen extends StatefulWidget {
  final Booking destination;

  const DestinationScreen({Key key, this.destination}) : super(key: key);

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  DateTime _selectedDate;
  String _selectedTime;
  TimeOfDay _selectedFormattedTime;
  DateTime _departureDateTime;
  String time;
  var _dateController = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _destinationData = {"names": "", "phone_number": ""};

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    Dio dio = new Dio();
    dio.options.baseUrl = Constants.BASE_URL;
    _departureDateTime = new DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedFormattedTime.hour,
      _selectedFormattedTime.minute,
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Submitting booking..."),
          content: Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
    try {
      final resp = await dio.post("/bookings", data: {
        "names": _destinationData["names"],
        "phone_number": _destinationData["phone_number"],
        "amount": widget.destination.amount,
        "destination_id": widget.destination.id,
        "departure_time": _departureDateTime.toIso8601String()
      });
      Navigator.pop(context);
      print(resp.data);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebView(link: resp.data),
        ),
      );
    } on DioError catch (e) {
      Navigator.pop(context);
      Utils.showSnackBar(title: e.response.data["message"], context: context);
    } catch (e) {
      Navigator.pop(context);
      print(e);
      Utils.showSnackBar(title: "Something went wrong", context: context);
    }
  }

  Future<DateTime> _pickDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2023),
    );
    return selectedDate;
  }

  Future<TimeOfDay> _pickTime(BuildContext context) async {
    final selectedDate = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Uzuza iyi form!",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 15),
              InputWidget(
                label: "Amazina",
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Names can\'t be empty!';
                  }
                  return null;
                },
                onSaved: (val) {
                  _destinationData["names"] = val;
                },
              ),
              SizedBox(height: 10),
              InputWidget(
                label: "Numero za telephone",
                inputType: TextInputType.phone,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Username can\'t be empty!';
                  }
                  return null;
                },
                onSaved: (val) {
                  _destinationData["phone_number"] = val;
                },
              ),
              SizedBox(height: 10),
              InputWidget(
                label: "Italiki y'urugendo",
                controller: _dateController,
                onTap: () {
                  _pickDate(context).then((value) {
                    setState(() {
                      _selectedDate = value;
                      _dateController.text =
                          DateFormat("y-MM-dd").format(value);
                    });
                  });
                },
                readOnly: true,
              ),
              SizedBox(height: 10),
              SelectWidget(
                items: widget.destination.departureTimes,
                label: "Isaha y'urugendo",
                value: _selectedTime,
                onChanged: (val) {
                  print(val);
                  _selectedTime = val;

                  _selectedFormattedTime = TimeOfDay(
                      hour: int.parse(val.split(":")[0]),
                      minute: int.parse(val.split(":")[1]));
                },
              ),
              /*  InputWidget(
                label: "Isaha y'urugendo",
                controller: _timeController,
                onTap: () {
                  _pickTime(context).then((value) {
                    setState(() {
                      _selectedTime = value;
                      final now = DateTime.now();
                      final departureTime = new DateTime(now.year, now.month,
                          now.day, value.hour, value.minute);

                      _timeController.text =
                          DateFormat.Hm().format(departureTime);
                    });
                  });
                },
                readOnly: true,
              ),*/
              SizedBox(height: 10),
              PrimaryButton(
                onPressed: _submitForm,
                text: "EMEZA!",
                block: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
