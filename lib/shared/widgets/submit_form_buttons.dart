import 'package:flutter/material.dart';

class SubmitFormButtons extends StatefulWidget {
  const SubmitFormButtons({Key? key, required this.formKey, required this.submit}) : super(key: key);

  final GlobalKey<FormState> formKey;
  final Function submit;
  @override
  State<SubmitFormButtons> createState() => _SubmitFormButtonsState();
}

class _SubmitFormButtonsState extends State<SubmitFormButtons> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipOval(
              child: Material(
                // button color
                color: Colors.grey,
                child: InkWell(
                  // inkwell color
                  splashColor: Colors.tealAccent,
                  child: const SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.cancel, color: Colors.black,)
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            const SizedBox(width: 50),
            ClipOval(
              child: Material(
                // button color
                color: Colors.green,
                child: InkWell(
                  // inkwell color
                  splashColor: Colors.tealAccent,
                  child: const SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.save_alt, color: Colors.black,)
                  ),
                  onTap: () async {
                    setState(() => loading = true);
                    if (widget.formKey.currentState!.validate()) {
                      widget.submit();
                    }
                    setState(() => loading = false);
                  },
                ),
              ),
            ),
          ],
        )
    );
  }
}
