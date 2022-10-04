import 'package:flutter/material.dart';

class LoadingUtil {
  static Widget showLoading({Color color = Colors.white}) {
    return Center(
      child: SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(color: color),
      ),
    );
  }

  static Widget showLoadingCover({Color color = Colors.white}) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.5),
      ),
      alignment: Alignment.center,
      child: showLoading(color: color),
    );
  }
}
