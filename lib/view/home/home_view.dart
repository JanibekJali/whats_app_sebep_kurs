import 'package:flutter/material.dart';
import 'package:whats_app_sebep_kurs/view/sign_in/sign_in.dart';
import 'package:whats_app_sebep_kurs/view/sign_up/sign_up_view.dart';
import 'package:whats_app_sebep_kurs/widgets/buttons/custom_main_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomMainButton(
            buttonText: 'Sign In',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignINView()));
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomMainButton(
            buttonText: 'Sign Up',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpView()));
            },
          ),
        ],
      ),
    );
  }
}
