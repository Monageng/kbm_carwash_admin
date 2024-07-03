import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/common/functions/date_utils.dart';
import 'package:kbm_carwash_admin/common/functions/logger_utils.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/error_dialog.dart';
import '../models/car_wash_service_model.dart';

class ServiceCaptureScreen extends StatefulWidget {
  late CarWashService carWashService;

  ServiceCaptureScreen({
    super.key,
    required this.carWashService,
  });

  @override
  State<ServiceCaptureScreen> createState() => _ServiceCaptureScreenState();
}

class _ServiceCaptureScreenState extends State<ServiceCaptureScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  // final TextEditingController _codeController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    update(widget.carWashService);
  }

  void update(CarWashService carWashService) {
    if (carWashService.id > 0) {
      _nameController.text = carWashService.name!;
      _descriptionController.text = carWashService.description!;
      _priceController.text = "${carWashService.price!}";
      // _codeController.text = carWashService.code!;
      _fromDateController.text = formatDateTime(carWashService.fromDate!);
      _toDateController.text = formatDateTime(carWashService.toDate!);
    }
  }

  void clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    // _codeController.clear();
    _fromDateController.clear();
    _toDateController.clear();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      int key = widget.carWashService.id;

      widget.carWashService.name = _nameController.text;
      widget.carWashService.description = _descriptionController.text;
      widget.carWashService.price = double.tryParse(_priceController.text);
      // widget.carWashService.code = _codeController.text;
      widget.carWashService.createdAt = DateTime.now();
      widget.carWashService.fromDate = DateTime.parse(_fromDateController.text);
      widget.carWashService.toDate = DateTime.parse(_toDateController.text);

      String responseMessage;
      if (key < 1) {
        key = await CommonApiService().getLatestID("car_wash_services");
        widget.carWashService.id = key;
        widget.carWashService.active = true;
        responseMessage = await CommonApiService()
            .save(widget.carWashService.toJson(), "car_wash_services");
      } else {
        widget.carWashService.id = key;
        responseMessage = await CommonApiService()
            .update(key, "car_wash_services", widget.carWashService.toJson());
      }
      logger.d("responseMessage $responseMessage");

      await showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: responseMessage);
          });

      if (responseMessage.contains("successfully")) {
        //logEvent("liger_review_sumbit_successful");

        Navigator.of(context).pop(widget.carWashService);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Car wash service details',
          style: TextStyle(color: Colors.black)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                width: 250,
                controller: _nameController,
                hintText: "Name",
                label: "Name",
                isObscre: false,
                validator: (value) {
                  return getFieldValidationMessage("Name", value);
                },
              ),
              // CustomTextField(
              //   width: 250,
              //   controller: _codeController,
              //   hintText: "Code",
              //   label: "Code",
              //   isObscre: false,
              //   validator: (value) {
              //     return getFieldValidationMessage("Code", value);
              //   },
              // ),
              CustomTextField(
                width: 250,
                controller: _descriptionController,
                hintText: "Description",
                label: "Description",
                isObscre: false,
                validator: (value) {
                  return getFieldValidationMessage("Description", value);
                },
              ),
              CustomTextField(
                width: 250,
                controller: _priceController,
                hintText: "Price",
                label: "Price",
                isObscre: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }

                  try {
                    double parsedValue = double.parse(value);
                    if (parsedValue <= 0) {
                      return 'Price must be greater than zero';
                    }
                  } catch (e) {
                    return 'Invalid price format';
                  }

                  return null;
                },
              ),
              CustomCalender(
                width: 250,
                controller: _fromDateController,
                firstDate: DateTime.now(),
                label: "From date",
                lastDate: DateTime.now().add(const Duration(days: 3522)),
              ),
              CustomCalender(
                width: 250,
                controller: _toDateController,
                firstDate: DateTime.now(),
                label: "To date",
                lastDate: DateTime.now().add(const Duration(days: 3522)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                        Navigator.of(context).pop(widget.carWashService);
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
