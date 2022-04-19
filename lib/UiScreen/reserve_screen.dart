import 'package:flutter/material.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:snow_remover/models/checkout_screen_args.dart';
import 'package:snow_remover/utility.dart' as utility;

class ReserveScreen extends StatefulWidget {
  const ReserveScreen({Key? key}) : super(key: key);

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    _dateController.text = utility.formattedDate(selectedDate, "/");
    _timeController.text = utility.formattedTime(selectedTime);
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = utility.formattedDate(selectedDate, "/");
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        _timeController.text = utility.formattedTime(selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CheckoutArgs;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: constant.primaryColor,
      body: Column(children: [
        Center(
          child: SizedBox(
              width: double.infinity,
              height: screenHeight * 0.20,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const BackButton(color: Colors.white),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.15),
                      child: const Text(
                        "Reserve Order",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "Date",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: 50,
                width: 160,
                decoration: const BoxDecoration(color: Colors.white),
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "Time",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: 50,
                width: 160,
                decoration: const BoxDecoration(color: Colors.white),
                child: InkWell(
                  onTap: () => _selectTime(context),
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
          child: InkWell(
            onTap: () => checkout(args),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.red,
              ),
              width: screenWidth * 0.90,
              height: 40,
              alignment: Alignment.center,
              child: const Text(
                "Reserve",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void checkout(CheckoutArgs args) {
    String selectedDtime = utility.formattedDate(selectedDate, "-") +
        " " +
        utility.formattedTime(selectedTime) +
        ":00";
    args.rDateTime = DateTime.parse(selectedDtime);
    Navigator.pushNamed(context, '/checkout', arguments: args);
  }
}
