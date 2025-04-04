import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget skelton(double width, [double? height]) {
  return Shimmer.fromColors(
    baseColor: Colors.black,
    highlightColor: Colors.black54,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.04),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 20,
          width: 100,
          decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.all(Radius.circular(12))),
            ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.04),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 20,
                  width: 110,
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.04),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14))),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 20,
          width: 140,
          decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.all(Radius.circular(14))),
        ),
      ],
    ),
  );
}

Widget smallDetails(String title, String rating, String location, String price ) {
  return Padding(
    padding: const EdgeInsets.only(left: 7, right: 7),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
            width: 200,
            child: Text(title),
          ),
         const SizedBox(
            height: 5,
          ),
         SizedBox(
            height: 20,
            width: 200,
            child: Text(location),
          ),
         const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  width: 100,
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.cyan,),
                      const SizedBox(width: 5,),
                      Text(rating)
                    ],
                  ),
                ),
                const Spacer(),
                      SizedBox(
                        height: 20,
                        width: 200,
                        child: Text("$price KSH /per day"),
                      ),
              ],
            ),
          ),
        ],
    ),
  );
}
