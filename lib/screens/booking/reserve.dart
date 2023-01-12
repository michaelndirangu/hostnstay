import 'package:flutter/material.dart';
import 'package:hostnstay/screens/Payment/paymethods.dart';

import '../../utils/warningmsg.dart';

class Booking extends StatefulWidget {
  final String title, price, location, rating, owneruid;
  final List imageUrls;
  const Booking(
      {Key? key,
      required this.title,
      required this.price,
      required this.location,
      required this.rating,
      required this.imageUrls,
      required this.owneruid})
      : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  DateTime initialDate = DateTime.now();
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime(2023);
  late String date;

  late final TextEditingController guests = TextEditingController();
  late final TextEditingController arrivalTime = TextEditingController();
  late final TextEditingController departTime = TextEditingController();

  // validate() {
  //   if (guests.text.isEmpty &&
  //       arrivalTime.text.isEmpty &&
  //       departTime.text.isEmpty) {
  //     showWarningMsg(context, 'fill out all fields');
  //   } else {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => Payment(
  //           price: price,
  //         )));
  //   }
  // }

  Future<DateTime?> datePicker() async {
    DateTime? value = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate);

    if (value == null) return null;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final String price = widget.price;
    final String title = widget.title;
    final String location = widget.location;
    final String rating = widget.rating;
    final List imageUrls = widget.imageUrls;
    final String owneruid = widget.owneruid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Here'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                'How may guests are expected?',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              )),
          Container(
              height: 40,
              width: 100,
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                controller: guests,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'no.',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
              )),
          const SizedBox(
            height: 6,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Text(
              'Select the range of days you are expecting to be a guest.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: IconButton(
                onPressed: () {
                  showDateRangePicker(
                      context: context,
                      firstDate: firstDate,
                      lastDate: lastDate);
                },
                icon: const Icon(
                  Icons.calendar_month,
                  size: 24,
                  color: Colors.blue,
                )),
          ),
          const SizedBox(
            height: 5,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Text(
              'Arriving Date.',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextFormField(
                readOnly: true,
                controller: arrivalTime,
                decoration: InputDecoration(
                    hintText: '$firstDate',
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)))),
          ),
          const SizedBox(
            height: 5,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Text(
              'Departing Date.',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextFormField(
                controller: departTime,
                readOnly: true,
                decoration: InputDecoration(
                    hintText: '$lastDate',
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)))),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              children: [
                const Text('Check in date : '),
                const Spacer(),
                IconButton(
                    onPressed: datePicker,
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              children: [
                const Text('Check out date : '),
                const Spacer(),
                IconButton(
                    onPressed: datePicker,
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: ElevatedButton(
              onPressed: () {
                if (guests.text.isEmpty &&
                    arrivalTime.text.isEmpty &&
                    departTime.text.isEmpty) {
                  showWarningMsg(context, 'fill out all fields');
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Payment(
                              price: price,
                              title: title,
                              location: location,
                              rating: rating,
                              imageUrls: imageUrls,
                              owneruid: owneruid
                              )));
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.cyan),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: const Text('Proceed To Payment',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
