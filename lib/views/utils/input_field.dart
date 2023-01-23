import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatefulWidget {
  static const keyPrefix = 'InputField';

  final int? characterLimit;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final String? labelText;
  final bool? enabledField;
  final String? initialText;

  const InputField({
    Key? key,
    this.characterLimit,
    required this.onChanged,
    this.hintText,
    this.labelText,
    this.enabledField,
    this.initialText,
  }) : super(key: key);

  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController.fromValue(
      TextEditingValue(text: widget.initialText ?? ''),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('${InputField.keyPrefix}-TextField'),
      style: Theme.of(context).textTheme.headline2,
      decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(4.r)),
                borderSide: BorderSide(
                  color: Theme.of(context).disabledColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(4.r)),
                borderSide: BorderSide(
                  color: Theme.of(context).disabledColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(4.r)),
              ),
              helperText: '',
              helperMaxLines: 3,
              errorMaxLines: 1,
              contentPadding: EdgeInsets.fromLTRB(6.w,
                  0, 6.w, 0),
              labelText: widget.labelText,),
      minLines: 1,
      maxLines: 1,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
      controller: textEditingController,
      onChanged: (value) {
        widget.onChanged(value);
      },
      enabled: widget.enabledField,
    );
  }
}
