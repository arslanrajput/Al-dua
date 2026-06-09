import 'package:flutter/material.dart';

import '../../../core/util/constants.dart';

class ChangeFormatSwitch extends StatelessWidget {
  const ChangeFormatSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: kBrandLogoGreen,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFFD5DEE8),
    );
  }
}
