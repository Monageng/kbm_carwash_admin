import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to KBM Carwash mobile app',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Please read these terms and conditions carefully before using kbm mobile app.',
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Acceptance of Terms',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'By using the KBM carwash platform, you agree to comply with these terms and conditions and any additional terms and policies we may provide. If you do not agree with any part of these terms, you must not use our app.',
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '2. Use of the App',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'a. You must be at least 18 years old or have parental consent to use our app.\n'
                'b. You may only use our app for lawful purposes and in accordance with these terms.\n'
                'c. In order to access certain features of the Platform, you may be required to create an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.\n'
                "d. You may not use the Platform in any manner that could damage, disable, overburden, or impair our servers or networks, or interfere with any other party's use and enjoyment of the Platform. \n"
                "e. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete. \n"
                "f. We reserve the right to suspend or terminate your account and refuse any and all current or future use of the Platform if we suspect that you have provided inaccurate, incomplete, or fraudulent information.",
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Privacy Policy',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'a. We are committed to protecting your privacy. \n'
                "b. By using our app, you consent to the collection and use of your information as described in the Privacy Policy \n"
                "c. The collected data will be used solenly for the purpose of the KBM carwash platform, The collected data will not be shared with other thirds parties \n"
                "d. Upon withdrawal of the consent KBM carwash platform will destroy all data collected according to POPIA requirement",
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '4.  Intellectual Property',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'a. All content and materials available on our app, including but not limited to text, graphics, logos, images, and software, are the property of KBM and are protected by copyright, trademark, and other intellectual property laws',
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '5.  User Content',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'a. You may be able to submit or post content through our app, such as reviews or comments. By submitting content, you grant us a non-exclusive, royalty-free, perpetual, irrevocable, and fully sublicensable right to use, reproduce, modify, adapt, publish, translate, create derivative works from, distribute, and display such content worldwide in any media',
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '6. Limitation of Liability',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'a. We do not guarantee that our app will be uninterrupted or error-free. In no event shall KBM carwash be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in any way connected with the use of our app.',
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            ),

            SizedBox(height: 16.0),
            Text(
              '7. Changes to Terms',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'a. We reserve the right to modify or amend these terms and conditions at any time. Any changes will be effective immediately upon posting on our app. Your continued use of our app following the posting of changes constitutes your acceptance of such changes',
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            ),
            // Add more terms and conditions text as needed
          ],
        ),
      ),
    );
  }
}
