import 'package:flutter/cupertino.dart';
import 'package:hostnstay/widgets/skeleton.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            skelton(MediaQuery.of(context).size.width/1.0, 150),
            const SizedBox(height: 5,),
            skelton(MediaQuery.of(context).size.width/1.0, 150),
            const SizedBox(height: 5),
            skelton(MediaQuery.of(context).size.width/1.0, 150),
            const SizedBox(height: 5,),
            skelton(MediaQuery.of(context).size.width/1.0, 150),
            const SizedBox(height: 5),
            skelton(MediaQuery.of(context).size.width/1.0, 150),
            const SizedBox(height: 5),
            skelton(MediaQuery.of(context).size.width/1.0, 150),
            const SizedBox(height: 5),
            skelton(MediaQuery.of(context).size.width/1.0, 150),
            const SizedBox(height: 5),
            skelton(MediaQuery.of(context).size.width/1.0, 150),
            const SizedBox(height: 5),
            skelton(MediaQuery.of(context).size.width/1.0, 150),
            const SizedBox(height: 5),
            skelton(MediaQuery.of(context).size.width/1.0, 150),
            const SizedBox(height: 5),
            skelton(MediaQuery.of(context).size.width/1.0, 150),
          ],
        ),
      ),
    );
  }
}
