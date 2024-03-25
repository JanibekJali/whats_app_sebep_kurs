import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.isLoading}) : super(key: key);
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: LinearProgressIndicator(),
          );
  }
}
