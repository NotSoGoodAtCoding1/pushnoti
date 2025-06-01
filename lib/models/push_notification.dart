class PushNotification {
  final String title;
  final String body;

  PushNotification({required this.title, required this.body});

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
      };

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}
