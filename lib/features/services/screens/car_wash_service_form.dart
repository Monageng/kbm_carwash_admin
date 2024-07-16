import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/common/widgets/custom_future_dropbox.dart';

import '../../../common/functions/date_utils.dart';
import '../../../common/functions/logger_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/error_dialog.dart';
import '../models/car_models_model.dart';
import '../models/car_wash_service_model.dart';
import '../models/service_franchise_link_model.dart';
import '../service/car_wash_api_service.dart';

class ServiceCaptureScreen extends StatefulWidget {
  late ServiceFranchiseLink carWashService;

  ServiceCaptureScreen({
    super.key,
    required this.carWashService,
  });

  @override
  State<ServiceCaptureScreen> createState() => _ServiceCaptureScreenState();
}

class _ServiceCaptureScreenState extends State<ServiceCaptureScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _carServiceController = TextEditingController();
  late Future<List<String>> futureCarModelList;
  late Future<List<String>> futureServiceList;
  String selectedCarModelValue = "";
  String selectedCarServiceValue = "";
  late List<CarModel> carModelList;
  late List<CarWashService> casServiceList;
  @override
  void initState() {
    super.initState();
    update(widget.carWashService);
    futureCarModelList = fetchCarModel();
  }

  Future<List<String>> fetchServices() async {
    List<CarWashService>? response =
        await CarWashApiService().getAllCarWashService();
    casServiceList = response;
    List<String> lis = response.map((service) => service.name ?? '').toList();
    return lis;
  }

  Future<List<String>> fetchCarModel() async {
    List<CarModel>? carwashServiceList =
        await CarWashApiService().getAllCarModels();
    carModelList = carwashServiceList;
    List<String> lis =
        carwashServiceList.map((service) => service.carType ?? '').toList();
    return lis;
  }

  void update(ServiceFranchiseLink carWashService) {
    if (carWashService.id > 0) {
      _priceController.text = "${carWashService.price!}";
      _fromDateController.text =
          formatDateTime(carWashService.service!.fromDate!);
      _toDateController.text = formatDateTime(carWashService.service!.toDate!);
    }
  }

  void clearControllers() {
    _priceController.clear();
    _fromDateController.clear();
    _toDateController.clear();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int key = widget.carWashService.id;
      widget.carWashService.price = double.tryParse(_priceController.text);

      int serviceId = casServiceList
          .firstWhere((element) => element.name == _carServiceController.text)
          .id;
      int carModelId = carModelList
          .firstWhere((element) => element.carType == _carModelController.text)
          .id;
      widget.carWashService.serviceId = serviceId;
      widget.carWashService.carModelId = carModelId;

      String responseMessage;
      if (key < 1) {
        key = await CommonApiService().getLatestID("service_franchise_links");
        widget.carWashService.id = key;
        widget.carWashService.active = true;
        widget.carWashService.createdAt = DateTime.now();
        responseMessage = await CommonApiService()
            .save(widget.carWashService.toJson(), "service_franchise_links");
      } else {
        widget.carWashService.id = key;
        responseMessage = await CommonApiService().update(
            key, "service_franchise_links", widget.carWashService.toJson());
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
    futureServiceList = fetchServices();
    return AlertDialog(
      title: const Text('Car wash service details',
          style: TextStyle(color: Colors.black)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomFutureDropbox(
                  width: 250,
                  futureList: futureCarModelList,
                  controller: _carModelController,
                  hintText: "",
                  selectedValue: selectedCarModelValue),
              CustomFutureDropbox(
                  width: 250,
                  futureList: futureServiceList,
                  controller: _carServiceController,
                  hintText: "",
                  selectedValue: selectedCarServiceValue),
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
