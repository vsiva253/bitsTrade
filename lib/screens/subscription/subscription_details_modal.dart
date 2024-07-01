// lib/models/subscription_model.dart
class Subscription {
  final String plan;
  final int parent;
  final int child;
  final int price;
  final String type;

  Subscription({
    required this.plan,
    required this.parent,
    required this.child,
    required this.price,
    required this.type,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      plan: json['plan'],
      parent: json['parent'],
      child: json['child'],
      price: json['price'],
      type: json['type'],
    );
  }
}
