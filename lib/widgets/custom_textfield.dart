import 'package:flutter/material.dart';
import '../constants.dart';

class CustomTextField extends StatefulWidget {
  final String hint, initialValue;
  final IconData icon;
  final Function onClick;
  CustomTextField(
      {@required this.hint,
      this.icon,
      @required this.onClick,
      this.initialValue});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String _errMsg(String hint) {
    switch (hint) {
      case ("Enter your name"):
        return ('name is empty');
      case ("Enter your email"):
        return ('email is empty');
      case ("Enter your password"):
        return ('password is empty');
      default:
        return ('$hint is empty');
    }
  }

  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) return _errMsg(widget.hint);
          switch (widget.hint) {
            case ("Enter your name"):
              if (value.contains(RegExp(r'\d+')))
                return 'name must contain letters only';
              break;
            case ("Enter your email"):
              if (!value.contains(RegExp(r'^[\w]+@([\w]+\.)+[\w]{2,4}$')))
                return 'wrong email format\nex: test@gmail.com';
              break;
            case ("Enter your password"):
              if (value.length < 6)
                return 'password must be greater than or equal 6 characters';
          }
        },
        onSaved: widget.onClick,
        keyboardType: widget.hint == ('Enter your email')
            ? TextInputType.emailAddress
            : TextInputType.text,
        obscureText: widget.hint == ('Enter your password') ? _obscure : false,
        cursorColor: kMainColor,
        initialValue: widget.initialValue,
        decoration: InputDecoration(
          errorMaxLines: 2,
          filled: true,
          fillColor: kSecondaryColor,
          hintText: widget.hint,
          prefixIcon: widget.icon == null
              ? null
              : Icon(
                  widget.icon,
                  color: kMainColor,
                ),
          suffixIcon: widget.hint == ('Enter your password')
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.security : Icons.remove_red_eye_sharp,
                    color: kMainColor,
                  ),
                  onPressed: () => setState(() {
                    _obscure = !_obscure;
                  }),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
