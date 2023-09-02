import 'package:fluttertoast/fluttertoast.dart';

import '../utils/colors.dart';

Future<bool?> showToast(msg) {
  return Fluttertoast.showToast(
    backgroundColor: primary,
    toastLength: Toast.LENGTH_LONG,
    msg: msg,
  );
}
