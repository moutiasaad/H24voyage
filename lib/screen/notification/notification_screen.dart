import 'package:flight_booking/screen/home/home.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Example notifications list - empty for now to show empty state
  final List<NotificationItem> _notifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 24.0),
              child: Text(
                'Boîte de réception',
                style: kTextStyle.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kTitleColor,
                ),
              ),
            ),

            // Content
            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bell icon image
            Image.asset(
              'assets/notif.JPG',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 40),

            // Title
            Text(
              'Pas encore de notifications',
              style: kTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kTitleColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              'Vous recevrez des alertes concernant vos voyages et votre compte. Avez-vous déjà choisi votre prochaine destination ?',
              style: kTextStyle.copyWith(
                fontSize: 15,
                color: kSubTitleColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Explorer button
            SizedBox(
              width: double.infinity,
              child: ButtonGlobalWithoutIcon(
                buttontext: 'Explorer',
                buttonDecoration: kButtonDecoration.copyWith(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {
                  const Home().launch(context);
                },
                buttonTextColor: kWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: _notifications.length,
      separatorBuilder: (context, index) => const Divider(
        color: kBorderColorTextField,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return SmallTapEffect(
      onTap: () {
        // Handle notification tap
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: notification.isRead
                    ? kBorderColorTextField
                    : kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notification.icon,
                color: notification.isRead ? kSubTitleColor : kPrimaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: kTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight:
                          notification.isRead ? FontWeight.normal : FontWeight.w600,
                      color: kTitleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: kTextStyle.copyWith(
                      fontSize: 13,
                      color: kSubTitleColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.time,
                    style: kTextStyle.copyWith(
                      fontSize: 12,
                      color: kSubTitleColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            // Unread indicator
            if (!notification.isRead)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Notification model
class NotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    this.icon = Icons.notifications_outlined,
    this.isRead = false,
  });
}
