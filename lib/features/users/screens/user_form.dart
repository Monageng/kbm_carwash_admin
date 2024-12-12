import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/functions/date_utils.dart';
import '../../../common/functions/logger_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/contact_number_text_field.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/email_text_field.dart';
import '../../../common/widgets/error_dialog.dart';
import '../models/user_model.dart';

class UserScreen extends StatefulWidget {
  late UserModel user;
  late VoidCallback? refreshData;

  UserScreen({super.key, required this.user, this.refreshData});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _userIdController = TextEditingController();
  late final TextEditingController _firstNameController =
      TextEditingController();
  late final TextEditingController _lastNameController =
      TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    update(widget.user);
  }

  void update(UserModel userModel) {
    if (userModel.id! > 0) {
      _firstNameController.text = userModel.firstName!;
      _lastNameController.text = userModel.lastName!;
      _titleController.text = userModel.title!;
      _mobileNumberController.text = userModel.mobileNumber!;
      _emailController.text = userModel.email!;
      if (userModel.dateOfBirth != null) {
        _dateOfBirthController.text = userModel.dateOfBirth!;
      }
    }
  }

  void clearControllers() {
    _firstNameController.clear();
    _lastNameController.clear();
    _titleController.clear();
    _mobileNumberController.clear();
    _emailController.clear();
    _userIdController.clear();
  }

  String? validateInput() {
    String date = _dateOfBirthController.text;
    DateTime dateOfBirth = DateTime.parse(date);

    int age = calculateAge(dateOfBirth);

    if (age < 14) {
      return "Only client older than 14 are eligible ";
    } else {
      return null;
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? validationResponse = validateInput();
      if (validationResponse != null) {
        await showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                  title: "Validation Error", message: validationResponse);
            });
      } else {
        int key = widget.user.id!;
        widget.user.firstName = _firstNameController.text;
        widget.user.lastName = _lastNameController.text;
        widget.user.title = _titleController.text;
        widget.user.email = _emailController.text;
        widget.user.mobileNumber = _mobileNumberController.text;
        widget.user.dateOfBirth = _dateOfBirthController.text;
        //DateTime.now().add(Duration(days: -7200)).toIso8601String();
        widget.user.role = "Client";

        String responseMessage;
        if (key < 1) {
          key = await CommonApiService().getLatestID("client");
          widget.user.id = key;
          widget.user.active = true;
          widget.user.userId = generateRandomString(36);
          responseMessage =
              await CommonApiService().save(widget.user.toJson(), "client");
        } else {
          widget.user.id = key;
          responseMessage = await CommonApiService()
              .update(key, "client", widget.user.toJson());
        }
        logger.d("responseMessage $responseMessage");

        await showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: responseMessage,
                title: "Save details",
              );
            });

        if (responseMessage.contains("successfully")) {
          //logEvent("liger_review_sumbit_successful");

          Navigator.of(context).pop(widget.user);
          widget.refreshData!();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('User details', style: TextStyle(color: Colors.black)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                width: 250,
                controller: _firstNameController,
                hintText: "First Name",
                label: " First Name",
                isObscre: false,
                validator: (value) {
                  return getFieldValidationMessage("First Name", value);
                },
              ),
              CustomTextField(
                width: 250,
                controller: _lastNameController,
                hintText: "Surname",
                label: "Surname",
                isObscre: false,
                validator: (value) {
                  return getFieldValidationMessage("Surname", value);
                },
              ),
              ContactNumberTextField(
                label: "Mobile Number",
                controller: _mobileNumberController,
                width: 250,
              ),
              EmailTextField(controller: _emailController),
              CustomCalender(
                width: 250,
                label: "date of birth",
                controller: _dateOfBirthController,
                firstDate: DateTime.now().add(const Duration(days: -29200)),
                selectedDate: DateTime.now(),
                isMandatory: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomElevatedButton(
                      text: "Save",
                      onPressed: _saveForm,
                    ),
                  ),
                  Center(
                    child: CustomElevatedButton(
                      text: "Close",
                      onPressed: () {
                        Navigator.of(context).pop(widget.user);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
