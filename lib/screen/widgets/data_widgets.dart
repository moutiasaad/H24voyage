import 'package:flutter/material.dart';

import 'constant.dart';

class CancellationWidget extends StatelessWidget {
  const CancellationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        border: Border.all(
          color: kBorderColorTextField,
          width: 1.5,
        ),
        color: kWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFlightHeader(),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPolicyTable(),
                const SizedBox(height: 10.0),
                Text(
                  'From the date of departure',
                  style: kBodyTextStyle.copyWith(fontSize: 12.0),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: kBorderColorTextField),
          _buildFlightHeader(),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPolicyTable(),
                const SizedBox(height: 10.0),
                Text(
                  'From the date of departure',
                  style: kBodyTextStyle.copyWith(fontSize: 12.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: kBorderColorTextField, width: 1.0),
            ),
            child: const Image(
              image: AssetImage('images/indigo.png'),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            'DAC - CCU',
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: kDarkWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            border: Border.all(color: kBorderColorTextField),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time frame',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'From scheduled flight departure',
                      style: kBodyTextStyle.copyWith(fontSize: 11.0),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Airline Fee + MMT Fee',
                      textAlign: TextAlign.end,
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      '(Per Passenger)',
                      textAlign: TextAlign.end,
                      style: kBodyTextStyle.copyWith(fontSize: 11.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: kWhite,
                  border: Border.all(color: kBorderColorTextField),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0 hours to 24 hours*',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Text(
                      '24 Hours to 365 day*',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: kWhite,
                  border: Border.all(color: kBorderColorTextField),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        'ADULT: Non Refundable',
                        style: kTextStyle.copyWith(
                          color: const Color(0xFFD32F2F),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        'ADULT: Non Refundable',
                        style: kTextStyle.copyWith(
                          color: const Color(0xFFD32F2F),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DateChangePolicy extends StatelessWidget {
  const DateChangePolicy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        border: Border.all(
          color: kBorderColorTextField,
          width: 1.5,
        ),
        color: kWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFlightHeader(),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPolicyTable(),
                const SizedBox(height: 10.0),
                Text(
                  'From the date of departure',
                  style: kBodyTextStyle.copyWith(fontSize: 12.0),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: kBorderColorTextField),
          _buildFlightHeader(),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPolicyTable(),
                const SizedBox(height: 10.0),
                Text(
                  'From the date of departure',
                  style: kBodyTextStyle.copyWith(fontSize: 12.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: kBorderColorTextField, width: 1.0),
            ),
            child: const Image(
              image: AssetImage('images/indigo.png'),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            'DAC - CCU',
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: kDarkWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            border: Border.all(color: kBorderColorTextField),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time frame',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'From scheduled flight departure',
                      style: kBodyTextStyle.copyWith(fontSize: 11.0),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Airline Fee + MMT Fee',
                      textAlign: TextAlign.end,
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      '(Per Passenger)',
                      textAlign: TextAlign.end,
                      style: kBodyTextStyle.copyWith(fontSize: 11.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: kWhite,
                  border: Border.all(color: kBorderColorTextField),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0 hours to 24 hours*',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Text(
                      '24 Hours to 365 day*',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: kWhite,
                  border: Border.all(color: kBorderColorTextField),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        'ADULT: Non Refundable',
                        style: kTextStyle.copyWith(
                          color: const Color(0xFFD32F2F),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        'ADULT: Non Refundable',
                        style: kTextStyle.copyWith(
                          color: const Color(0xFFD32F2F),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BaggagePolicy extends StatelessWidget {
  const BaggagePolicy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        border: Border.all(
          color: kBorderColorTextField,
          width: 1.5,
        ),
        color: kWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFlightHeader(),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: _buildBaggageTable(),
          ),
          const Divider(height: 1, color: kBorderColorTextField),
          _buildFlightHeader(),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: _buildBaggageTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: kBorderColorTextField, width: 1.0),
            ),
            child: const Image(
              image: AssetImage('images/indigo.png'),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            'DAC - CCU',
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaggageTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 45,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kDarkWhite,
                  border: Border.all(color: kBorderColorTextField),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Cabin',
                    style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 45,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kDarkWhite,
                  border: Border.all(color: kBorderColorTextField),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Check-in',
                    style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Data Row
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kWhite,
                        border: Border.all(color: kBorderColorTextField),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            'ADULT',
                            style: kTextStyle.copyWith(
                              color: kPrimaryColor,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kWhite,
                        border: Border.all(color: kBorderColorTextField),
                      ),
                      child: Center(
                        child: Text(
                          '8 kgs (1 piece only)',
                          textAlign: TextAlign.center,
                          style: kTextStyle.copyWith(
                            color: kSubTitleColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kWhite,
                  border: Border.all(color: kBorderColorTextField),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    '30 Kgs',
                    textAlign: TextAlign.center,
                    style: kTextStyle.copyWith(
                      color: kSubTitleColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}