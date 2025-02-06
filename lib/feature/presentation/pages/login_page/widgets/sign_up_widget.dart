import 'package:borgo/feature/presentation/pages/login_page/widgets/text_field_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget(
      {super.key,
      required this.phoneCtr,
      required this.passwordCtr,
      required this.nameCtr,
      required this.emailCtr,
      required this.addressCtr,
      required this.controllerH});

  final GetxController controllerH;
  final TextEditingController phoneCtr;
  final TextEditingController passwordCtr;
  final TextEditingController nameCtr;
  final TextEditingController emailCtr;
  final TextEditingController addressCtr;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    widget.phoneCtr.clear();
    widget.nameCtr.clear();
    widget.emailCtr.clear();
    widget.addressCtr.clear();
    widget.passwordCtr.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            TextFieldWidget(
              title: 'Ism',
              controller: widget.nameCtr,
              isName: true,
              controllerH: widget.controllerH,
            ),
            SizedBox(
              height: 12,
            ),
            TextFieldWidget(
              title: 'Familya',
              controller: widget.addressCtr,
              isAddress: true,
              controllerH: widget.controllerH,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 72,
                  child: TextFieldWidget(
                    isRegion: true,
                    title: '+998',
                    controller: null,
                    isPhone: true,
                    controllerH: widget.controllerH,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFieldWidget(
                    isRegion: false,
                    title: 'Telefon raqam',
                    controller: widget.phoneCtr,
                    controllerH: widget.controllerH,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            TextFieldWidget(
              title: 'Elektron pochta',
              controller: widget.emailCtr,
              isEmail: true,
              controllerH: widget.controllerH,
            ),
            SizedBox(
              height: 12,
            ),
            TextFieldWidget(
              title: 'Parol',
              controller: widget.passwordCtr,
              isPassword: true,
              controllerH: widget.controllerH,
            ),
            SizedBox(
              height: 12,
            ),
            TextFieldWidget(
              title: 'Parolni tasdiqlang',
              controller: null,
              isPassword: true,
              controllerH: widget.controllerH,
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
