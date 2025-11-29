import 'package:get_it/get_it.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:jiwa_bakti/enums/status.dart';

void showToast({
  required String message,
  Toast length = Toast.LENGTH_SHORT,
  Status status = Status.success,
}) {
  final Color backgroundColor;

  switch (status) {
    case Status.success:
      backgroundColor = const Color(0xFF49CE78);
      break;
    case Status.warning:
      backgroundColor = const Color(0xFFE1B845);
      break;
    case Status.error:
      backgroundColor = const Color(0xFFDB5B53);
      break;
  }

  Fluttertoast.showToast(
    msg: message,
    toastLength: length,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    fontSize: 10.sp,
  );
}

void showFToast({
  required String message,
  required BuildContext context,
  int maxLine = 2,
  int toastSeconds = 2,
  Status status = Status.success,
}) {
  final FToast fToast = FToast();
  fToast.init(context);

  final User user = GetIt.I<User>();
  final ThemeOptions themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

  final Color backgroundColor;

  switch (status) {
    case Status.success:
      backgroundColor = const Color(0XFFEFEFEF);
      break;
    case Status.warning:
      backgroundColor = const Color(0xFFE1B845);
      break;
    case Status.error:
      backgroundColor = themeOptions.primaryColorLight;
      break;
  }

  Widget child = Container(
    padding: const EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      color: backgroundColor,
      boxShadow: const [
        BoxShadow(
            color: Color.fromRGBO(210, 210, 210, 1.0),
            spreadRadius: 3,
            blurRadius: 10),
      ],
    ),
    child: Center(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 30),
              child: Image.asset(
                "assets/images/jb_logo.jpg",
                height: 60,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              message,
              style: TextStyle(
                  fontSize: user.textSizeScale * 16.0
              ),
              maxLines: maxLine,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    )
  );

  fToast.showToast(
    child: child,
    gravity: ToastGravity.SNACKBAR,
    toastDuration: Duration(seconds: toastSeconds),
  );
}
