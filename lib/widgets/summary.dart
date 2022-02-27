import 'package:booking_app/providers/auth_provider.dart';
import 'package:booking_app/utils/constants.dart';
import 'package:booking_app/widgets/shared/card_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryWidget extends StatefulWidget {
  @override
  _SummaryWidgetState createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  Map<String, dynamic> _summary = {"today": 0, "total": 0, "scanned": 0, "destinations": 0};
  bool _firstLoad = true;

  Future<void> _fetchSummary(userID) async {
    try {
      Dio dio = new Dio();
      dio.options.baseUrl = Constants.BASE_URL;
      final resp = await dio.get("/booking-reports?userId=$userID");
      print(resp.data);

      setState(() {
        _summary = resp.data as Map<String, dynamic>;
      });

    } catch (e) {
      print(e);
      Utils.showSnackBar(title: "Something went wrong while fetching summary", context: context);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      var userId = Provider.of<AuthProvider>(context, listen: false).userId;
      _fetchSummary(userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: new NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _buildSummaryItem(
          title: "Today",
          icon: Icons.warning_amber_rounded,
          subtitle: "${_summary["today"]} bookings",
          color: Color.fromRGBO(0, 58, 81, 1),
        ),
        _buildSummaryItem(
          title: "Total",
          subtitle: "${_summary["total"]} bookings",
          icon: Icons.fact_check_outlined,
          color: Colors.amber[700],
        ),
        _buildSummaryItem(
          title: "Scanned",
          subtitle: "${_summary["scanned"]} bookings",
          icon: Icons.check,
          color: Color.fromRGBO(91, 186, 71, 1),
        ),
        _buildSummaryItem(
          title: "Destinations",
          subtitle: "${_summary["destinations"]}  destinations",
          icon: Icons.call_split_rounded,
          color: Color.fromRGBO(240, 83, 44, 1),
        ),
      ],
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

Widget _buildSummaryItem({
  IconData icon,
  String title,
  String subtitle,
  Color color,
  Function onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: CardContainer(
        child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Icon(
              icon,
              size: 30,
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, letterSpacing: .6),
                ),
              ),
              SizedBox(height: 3),
              FittedBox(
                  child: Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600]),
              )),
            ],
          )
        ],
      ),
    )),
  );
}
