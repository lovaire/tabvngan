class Savings {
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String? imageUrl;

  Savings({
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    this.imageUrl,
  });

  factory Savings.fromJson(Map<String, dynamic> json) {
    return Savings(
      title: json['title'],
      targetAmount: json['targetAmount'].toDouble(),
      currentAmount: json['currentAmount'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'imageUrl': imageUrl,
    };
  }
}
