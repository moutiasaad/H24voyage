import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/controllers/profile_controller.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const HomeHeader({
    Key? key,
    required this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF5100),
                      Color(0xFFFF5100),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  'images/background-home.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: 15.0,
                right: 15.0,
                bottom: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Image.asset(
                          'images/logo-h24-v2.png',
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SmallTapEffect(
                        onTap: onNotificationTap,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE14900),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Builder(
                    builder: (context) {
                      final profile = context.read<ProfileController>();
                      final isLoggedIn = profile.customer != null;
                      final firstName = profile.firstName;
                      final profileImage = profile.customer?['profileImage']
                          ?? profile.customer?['profileImageUrl']
                          ?? profile.customer?['avatar'];
                      final hasImage = profileImage is String && profileImage.isNotEmpty;

                      return Row(
                        children: [
                          // Avatar circle
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE14900),
                              shape: BoxShape.circle,
                              image: hasImage
                                  ? DecorationImage(
                                      image: NetworkImage(profileImage),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: !hasImage
                                ? Center(
                                    child: isLoggedIn && firstName.isNotEmpty
                                        ? Text(
                                            firstName[0].toUpperCase(),
                                            style: kTextStyle.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          )
                                        : Image.asset(
                                            'images/avion.png',
                                            width: 24,
                                            height: 14,
                                            color: Colors.white,
                                          ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isLoggedIn && firstName.isNotEmpty)
                                Text(
                                  lang.S.of(context).homeGreeting(firstName),
                                  style: kTextStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                  ),
                                )
                              else
                                Text(
                                  lang.S.of(context).homeWelcome,
                                  style: kTextStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                  ),
                                ),
                              Text(
                                lang.S.of(context).homeBookFlight,
                                style: kTextStyle.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
