import 'dart:io';
import 'package:dori/components/dory_constants.dart';
import 'package:dori/components/dory_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/dory_widgets.dart';
import 'add_alarm_page.dart';
import 'components/add_page_widget.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _nameController = TextEditingController();
  File? _medicineImage;

@override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body:  SingleChildScrollView(
        child: AddPageBody(children: [
                  Text(
                    '어떤 약이예요?', style: Theme.of(context).textTheme.headline4, 
                    ),
                  const SizedBox(height: largeSpace),
                  Center(
                    child: MedicineImageButton(
                      changeImageFile: (File? value) {
                        _medicineImage = value;
                      },
                      ),
                  ),
                  const SizedBox(height: largeSpace + regularSpace),
                  Text(
                    '약 이름', style: Theme.of(context).textTheme.subtitle1,
                  ),
                  TextFormField(
                    controller: _nameController,
                    maxLength: 20,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      hintText: '복용할 약 이름을 기입해주세요.',
                      hintStyle: Theme.of(context).textTheme.bodyText2,
                      contentPadding: textFieldContentpadding,
                    ),
                    onChanged: (str){
                      setState(() {});
                    },
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: _nameController.text.isEmpty ? null : _onAddAlarmPage, 
        text: '다음',
      ),
    );
  }

  void _onAddAlarmPage(){
    Navigator.push(
      context, 
      FadePageRoute(
        page: AddAlarmPage(
          medicineImage: _medicineImage,
          medicineName: _nameController.text,
        ),
      ),
    );
  }
}



class MedicineImageButton extends StatefulWidget {
  const MedicineImageButton({super.key, required this.changeImageFile});

  final ValueChanged<File?> changeImageFile;

  @override
  State<MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<MedicineImageButton> {
  File? _pickedImage;
  
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      child: CupertinoButton(
        onPressed: _showBottomSheet,
        padding: _pickedImage == null ? null : EdgeInsets.zero,
        child: _pickedImage == null 
            ? const Icon(
                CupertinoIcons.photo_camera_solid,
                  size: 40,
                  color: Colors.white,
              ) 
            : CircleAvatar(
              foregroundImage: FileImage(_pickedImage!),
              radius: 50,
              ),
      ),
    );
  }
  void _showBottomSheet(){
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return PickImageBottomSheet(
          onPressedCamera:()=> _onPressed(ImageSource.camera),
          onPressedGallary:()=> _onPressed(ImageSource.gallery),
        );
      },
    );
  }
  void _onPressed(ImageSource source){
      ImagePicker().pickImage(source: source).then((xfile) {
        if(xfile == null) return;
          setState(() {
            _pickedImage = File(xfile.path);
            widget.changeImageFile(_pickedImage);
            Navigator.maybePop(context);
          }
        );
      },
    );
  }
}

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet({super.key, this.onPressedCamera, this.onPressedGallary});

  final VoidCallback? onPressedCamera;
  final VoidCallback? onPressedGallary;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(children: [
        TextButton(
          onPressed: onPressedCamera,
          child: const Text('카메라로 촬영'),
        ),
        TextButton(
          onPressed: onPressedGallary,
          child: const Text('앨범에서 가져오기'),
        ),
      ],
    );
  }
}