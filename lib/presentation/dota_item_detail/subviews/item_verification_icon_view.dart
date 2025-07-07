import 'package:dotagiftx_mobile/data/core/constants/verified_inventory_constants.dart';
import 'package:flutter/material.dart';

class ItemVerificationIconView extends StatelessWidget {
  final int? status;
  final bool? isResell;

  const ItemVerificationIconView({
    required this.status,
    this.isResell = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if ((isResell ?? false) && status == VerifiedInventoryConstants.verified) {
      return const Icon(
        Icons.check_circle_outline,
        color: Color(0xFF2BDAC9),
        size: 18,
      );
    } else if (status == VerifiedInventoryConstants.verified) {
      return const Icon(Icons.check, color: Colors.green, size: 18);
    }

    return const SizedBox.shrink();
  }
}
