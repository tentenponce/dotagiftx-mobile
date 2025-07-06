import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarketOfferCardView extends StatelessWidget {
  final MarketListingModel offer;
  final VoidCallback onTap;

  const MarketOfferCardView({
    required this.offer,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2D3A),
        border: Border(bottom: BorderSide(color: Color(0xFF3A3F4A), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // User Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey.withOpacity(0.3),
                image:
                    offer.user.avatar.isNotEmpty
                        ? DecorationImage(
                          image: NetworkImage(
                            'https://avatars.steamstatic.com/${offer.user.avatar}_full.jpg',
                          ),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child:
                  offer.user.avatar.isEmpty
                      ? const Icon(
                        Icons.person,
                        color: AppColors.grey,
                        size: 24,
                      )
                      : null,
            ),
            const SizedBox(width: 12),

            // User Info and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name Row
                  Row(
                    children: [
                      Text(
                        offer.user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // User Badge
                      if (_getUserBadge().isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getBadgeColor(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getUserBadge(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],

                      // Verification Checkmark
                      if (_isUserVerified())
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Posted Date
                  Text(
                    'Posted ${_formatDate(offer.createdAt)}',
                    style: const TextStyle(color: AppColors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Price and Contact Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Price
                Text(
                  '\$${offer.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Contact Seller Button
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Contact Seller',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return DateFormat('MMM d').format(date);
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  Color _getBadgeColor() {
    final badge = _getUserBadge();
    switch (badge) {
      case 'PARTNER':
        return const Color(0xFFFF8C00); // Orange
      case 'SUPPORTER':
        return const Color(0xFF4A90E2); // Blue
      default:
        return AppColors.grey;
    }
  }

  String _getUserBadge() {
    // Determine badge based on subscription or market stats
    if (offer.user.subscription > 0) {
      if (offer.user.subscriptionType.toLowerCase().contains('partner')) {
        return 'PARTNER';
      } else {
        return 'SUPPORTER';
      }
    }
    return '';
  }

  bool _isUserVerified() {
    // Consider user verified if they have good market stats
    return offer.user.marketStats.inventoryVerified > 0 ||
        offer.user.marketStats.deliveryNameVerified > 0 ||
        offer.user.subscription > 0;
  }
}
