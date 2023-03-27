import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:spell_of_victory/model/ChoiceModel.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';


class ChoiceInputDialog extends StatefulWidget {
  const ChoiceInputDialog({Key? key}) : super(key: key);

  @override
  _CategoryInputDialogState createState() => _CategoryInputDialogState();
}

class _CategoryInputDialogState extends State<ChoiceInputDialog> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late String _choiceName;
  bool isChoiceValidated = false;

  @override
  void initState() {
    super.initState();
    _choiceName = '';
  }

  String? _validateChk(String? value) {
    if (value == null || value.isEmpty) {
      isChoiceValidated = false;
      return '주문의 이름을 입력해주세요';
    }

    // Box에 저장된 주문서에 같은 이름이 있는지 체크
    if (HiveBoxes.choices.values
        .any((model) => model.name == value)) {
      isChoiceValidated = false;
      return '같은 이름을 가진 주문이 있습니다.';
    }

    isChoiceValidated = true;
    return null; // 유효성 검사 통과
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('새로운 주문'),
      content: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          initialValue: _choiceName,
          onChanged: (value) {
            setState(() {
              _choiceName = value;
            });
          },
          validator: _validateChk,
          decoration: InputDecoration(
            labelText: '주문 이름을 적어주세요.',
            contentPadding: EdgeInsets.all(10),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newChoice =
              ChoiceModel(name: _choiceName, texts: [], isSelected: false);
              HiveBoxes.choices.add(newChoice);
              Navigator.pop(context);
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
