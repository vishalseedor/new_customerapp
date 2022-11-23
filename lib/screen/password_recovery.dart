import 'package:flutter/material.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/const/theme.dart';
import 'package:food_app/provider/auth_provider.dart';
import 'package:food_app/screen/reset_password.dart';
import 'package:food_app/services/snackbar.dart';
import 'package:provider/provider.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({Key key}) : super(key: key);
  static const routeName = 'password-recovery';

  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  GlobalSnackBar globalSnackBar = GlobalSnackBar();
  final TextEditingController _useremail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.04,
                ),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: CustomColor.orangecolor,
                  child: Center(child: Text('LOGO')),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width,
                  child: Column(
                    children: [
                      Text('Password Recovery',
                          style: CustomThemeData().sliderTitleText()),
                      Text(
                        'Please enter your email address to recover \n your password',
                        textAlign: TextAlign.center,
                        style: CustomThemeData().sliderSubtitleText(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: CustomThemeData().sliderSubtitleText(),
                    ),
                    Container(
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                          color: CustomColor.grey100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: CustomColor.orangecolor,
                                )),
                        child: TextFormField(
                          controller: _useremail,
                          style: CustomThemeData().clearStyle(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              hintText: 'seedorsoft@gmail.com',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                              )),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.07,
                  child: ElevatedButton(
                    child: const Text('Send Email'),
                    onPressed: () {
                      auth.ForgetPasswordApicall(email: _useremail.text)
                          .then((value) {
                        if (value == 200) {
                          Navigator.of(context).pop();
                          globalSnackBar.successsnackbar(
                              context: context,
                              text:
                                  'Password reset instructions have been sent to email!');
                        }
                      });
                      // Navigator.of(context)
                      //     .pushNamed(ResetPasswordScreen.routename);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
