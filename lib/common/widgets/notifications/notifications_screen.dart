// lib/common/widgets/notifications/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../feature/auth/logic/auth_provider.dart';
import '../../styles/spacing.dart';
import '../../widgets/app_bars/adaptive_app_bar.dart';
import '../../widgets/indicators/empty_state.dart';
import '../../widgets/loaders/adaptive_loader.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.user?.userId;
    final firestore = getIt.firestore;

    return Scaffold(
      appBar: const AdaptiveAppBar(title: 'Notifications'),
      body: userId == null || userId.isEmpty
          ? const Center(
              child: EmptyState(
                  title: 'Not signed in',
                  message: 'Sign in to see notifications',
                  icon: Icons.notifications_none))
          : StreamBuilder(
              // COST OPTIMIZATION: Limit to 50 notifications per user
              stream: firestore.getCollectionStreamWithFilter(
                  'notifications', 'userId', userId, limit: 50),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: AdaptiveLoader());
                }
                if (!snapshot.hasData ||
                    (snapshot.data?.docs.isEmpty ?? true)) {
                  return const Center(
                    child: EmptyState(
                      title: 'No Notifications',
                      message: 'You\'re all caught up!',
                      icon: Icons.notifications_none,
                    ),
                  );
                }

                final docs = snapshot.data!.docs;
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.paddingS),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final title = (data['title'] ?? '').toString();
                    final body = (data['body'] ?? '').toString();
                    final type = (data['type'] ?? '').toString();
                    final read = (data['read'] ?? false) as bool;
                    return ListTile(
                      title: Text(title.isEmpty ? 'Notification' : title),
                      subtitle: body.isEmpty ? null : Text(body),
                      leading: Icon(read
                          ? Icons.mark_email_read
                          : Icons.mark_email_unread),
                      trailing: Text(type),
                      onTap: () async {
                        // Mark as read
                        await firestore
                            .updateDocument('notifications', docs[index].id, {
                          'read': true,
                          'updatedAt': DateTime.now().millisecondsSinceEpoch,
                        });
                      },
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // STRICT: Navigate based on user role - NO DEFAULT FALLBACK
          final navigationService = getIt<NavigationService>();
          final userRole = auth.user?.role.toLowerCase().trim();

          if (userRole == 'guest') {
            navigationService.goToGuestHome();
          } else if (userRole == 'owner') {
            navigationService.goToOwnerHome();
          } else {
            // Invalid or missing role - redirect to role selection
            navigationService.goToRoleSelection();
          }
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}
