import 'package:flutter/material.dart';
import 'package:digibook/constants.dart';

Container circularProgress() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(kPrimaryColor),
      ));
}

Container linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(kPrimaryColor),
    ),
  );
}




// Container(
//           height: MediaQuery.of(context).size.height * 0.5,
//           child: GridView.count(
//             crossAxisCount: 2,
//             scrollDirection: Axis.horizontal,
//             crossAxisSpacing: MediaQuery.of(context).size.height * 0.05,
//             mainAxisSpacing: MediaQuery.of(context).size.height * 0.05,
//             children: List.generate(scrollTopics.length, (index) {
//               return Container(
//                 color: Colors.orange,
//                 child: Center(
//                   child: Text(scrollTopics[index]),
//                 ),
//               );
//             }),
//           ),
//         ),