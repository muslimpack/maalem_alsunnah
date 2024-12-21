// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class NewPageProgressIndicatorBuilder extends StatelessWidget {
  const NewPageProgressIndicatorBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
