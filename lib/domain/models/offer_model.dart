class OfferModel {
  final String id;
  final String userName;
  final String userAvatar;
  final double price;
  final DateTime postedDate;
  final int quantity;
  final String userBadge; // Partner, Supporter, etc.
  final bool isVerified;

  const OfferModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.price,
    required this.postedDate,
    this.quantity = 1,
    this.userBadge = '',
    this.isVerified = false,
  });
}
