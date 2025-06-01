import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import 'package:pushnoti/services/api_service.dart';


class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Домашняя страница")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: provider.simulateNotification,
              child: Text("Отправить тестовое уведомление"),
            ),
            ElevatedButton(
        onPressed: provider.token == null
            ? null
            : () async {
                await ApiService.registerDevice(provider.token!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Токен отправлен повторно")),
                );
              },
        child: Text('Отправить токен на сервер'),
      ),
      IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Очистить уведомления',
            onPressed: () {
              context.read<NotificationProvider>().clearNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("История уведомлений очищена")),
              );
            },
          ),
            const SizedBox(height: 10),
            Text("FCM Token:"),
            SelectableText(provider.token ?? "Загрузка..."),
            const SizedBox(height: 10),
            Expanded(
              child: provider.notifications.isEmpty
                  ? Center(child: Text("Уведомлений пока нет"))

                  : ListView.builder(
                      itemCount: provider.notifications.length,
                      itemBuilder: (context, index) {
                        final n = provider.notifications[index];
                        return Card(
                          child: ListTile(
                            title: Text(n.title),
                            subtitle: Text(n.body),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
