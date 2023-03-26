import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';


class CategoryInputDialog extends StatefulWidget {
  const CategoryInputDialog({Key? key}) : super(key: key);

  @override
  _CategoryInputDialogState createState() => _CategoryInputDialogState();
}

class _CategoryInputDialogState extends State<CategoryInputDialog> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late String _categoryName;
  bool isCategoryValidated = false;

  @override
  void initState() {
    super.initState();
    _categoryName = '';
  }

  String? _validateChk(String? value) {
    if (value == null || value.isEmpty) {
      isCategoryValidated = false;
      return '주문서의 이름을 입력해주세요';
    }

    // Box에 저장된 주문서에 같은 이름이 있는지 체크
    if (HiveBoxes.categories.values
        .any((model) => model.name == value)) {
      isCategoryValidated = false;
      return '같은 이름을 가진 주문서가 있습니다.';
    }

    isCategoryValidated = true;
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
          initialValue: _categoryName,
          onChanged: (value) {
            setState(() {
              _categoryName = value;
            });
          },
          validator: _validateChk,
          decoration: InputDecoration(
            labelText: '주문서 이름을 적어주세요.',
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
              final newCategory =
              CategoryModel(name: _categoryName, texts: [], isSelected: false);
              HiveBoxes.categories.add(newCategory);
              Navigator.pop(context);
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
