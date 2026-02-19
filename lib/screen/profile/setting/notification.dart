import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;

import '../../widgets/constant.dart';

class NotificationSc extends StatelessWidget {
  const NotificationSc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = lang.S.of(context);

    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kWhite),
        centerTitle: true,
        title: Text(
          l10n.notificationTitle,
          style: kTextStyle.copyWith(
            color: kTitleColor,
          ),
        ),
        actions: [
          PopupMenuButton<int>(
            padding: EdgeInsets.zero,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(l10n.notificationAllClear),
              ),
            ],
            offset: const Offset(0, 30),
            color: kWhite,
            elevation: 1.0,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
            top: 25, bottom: 15, left: 15, right: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: ListView(
          children: [
            _sectionTitle(l10n.notificationToday),
            const SizedBox(height: 15),
            _notificationItem(context),
            _notificationItem(context),

            const SizedBox(height: 25),

            _sectionTitle(l10n.notificationYesterday),
            const SizedBox(height: 15),
            _notificationItem(context),
            _notificationItem(context),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: kSubTitleColor),
    );
  }

  Widget _notificationItem(BuildContext context) {
    final l10n = lang.S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor.withOpacity(0.1),
              ),
              child: const Icon(
                IconlyBold.notification,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.notificationPaymentSuccessTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.notificationPaymentSuccessDesc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: kSubTitleColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.notificationTimeAgo(
                      "15 Jun 2023",
                      l10n.notificationMinutesAgo(2),
                    ),
                    style: const TextStyle(
                      fontSize: 10,
                      color: kSubTitleColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        const Divider(
          thickness: 1.0,
          color: kBorderColorTextField,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
