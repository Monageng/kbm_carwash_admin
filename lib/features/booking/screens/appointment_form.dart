import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/common/widgets/custom_text_field.dart';
import 'package:kbm_carwash_admin/features/rewards/models/referal_model.dart';
import 'package:kbm_carwash_admin/features/rewards/services/reward_service.dart';
import 'package:kbm_carwash_admin/session/app_session.dart';
import '../../../common/functions/date_utils.dart';
import '../../../common/functions/logger_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/custom_dropdown.dart';
import '../../../common/widgets/custom_time.dart';
import '../../../common/widgets/error_dialog.dart';
import '../../services/models/car_models_model.dart';
import '../../services/models/car_wash_service_model.dart';
import '../../services/models/service_franchise_link_model.dart';
import '../../services/service/car_wash_api_service.dart';
import '../models/appointment_model.dart';

class AppointmentScreen extends StatefulWidget {
  late Appointment appointment;
  late VoidCallback? refreshData;

  AppointmentScreen({
    super.key,
    required this.appointment,
    this.refreshData,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _referalCodeController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final DateTime _selectedDate = DateTime.now();
  final TimeOfDay _selectedTime = TimeOfDay.now();
  String selectedValue = "Select a car wash service";
  String selectedCarModelValue = "Select Model";
  String selectedCarServiceValue = "Select Service";

  List<String> carModelOptions = ["Select Model"];
  List<String> carServiceOptions = ["Select Service"];

  late List<CarModel?> carModelList;
  late List<CarWashService?> carServiceList;

  late Future<List<ServiceFranchiseLink>> serviceFranchiseList;

  String selectedStatus = "Select status";
  List<String> statusList = [
    "Select status",
    "Awaiting confirmation",
    "Confirmed",
    "Completed",
    "Cancelled",
    "Recieved"
  ];

  @override
  void initState() {
    super.initState();
    serviceFranchiseList = getData();
    serviceFranchiseList.then((value) {
      setState(() {
        loadCarModelOptions();
        loadCarServiceOptions();
      });
    });

    update(widget.appointment);
  }

  void update(Appointment appointment) {
    if (appointment.id > 0) {
      _serviceNameController.text = appointment.serviceName!;
      _clientIdController.text = "${appointment.clientId!}";
      _dateController.text = formatDateTime(appointment.date);

      if (appointment.status != null) {
        selectedStatus = appointment.status!;
      }
      _statusController.text = selectedStatus;
      _timeController.text = appointment.time!;
      fetchCarModel().whenComplete(() {
        if (carModelList.isNotEmpty) {
          CarModel? carModel = carModelList.firstWhere(
              (element) => element!.id == appointment.carModelId,
              orElse: () => null);
          if (carModel != null) {
            setState(() {
              selectedCarModelValue = carModel.carType!;
            });
          }
        }
      });
      fetchCarService().whenComplete(() {
        if (carServiceList.isNotEmpty) {
          CarWashService? washService = carServiceList.firstWhere(
              (element) => element!.name == appointment.serviceName,
              orElse: () => null);
          if (washService != null) {
            setState(() {
              selectedCarServiceValue = washService.name!;
            });
          }
        }
      });
    }
  }

  void clearControllers() {
    _serviceNameController.clear();
    _clientIdController.clear();
    _dateController.clear();
    _timeController.clear();
    _statusController.clear();
  }

  String validateForm() {
    var errorMessage = "";
    if (selectedCarModelValue.contains("Select Model")) {
      errorMessage = "$errorMessage select car model ";
    }

    if (selectedCarServiceValue.contains("Select Service")) {
      errorMessage = "$errorMessage select car service ";
    }

    if (_statusController.text.toString().isEmpty ||
        _statusController.text.trim().contains("Select status")) {
      errorMessage = "$errorMessage select status ,";
    }
    return errorMessage;
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      String error = validateForm();

      if (error.isNotEmpty) {
        await showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: error,
                title: "Validation error",
              );
            });
      } else {
        _formKey.currentState!.save();
        validateForm();

        bool process = true;
        if (_referalCodeController.text.isNotEmpty) {
          List<Referral> referalList = await RewardsApiService()
              .getReferalByCode(_referalCodeController.text.toUpperCase(),
                  AppSessionModel().loggedOnUser!.franchise!.id);

          if (referalList.length > 0) {
            Referral referral = referalList.first;
            if (referral.id > 0) {
              referral.recipientClient = widget.appointment.client;
              referral.status = "CLAIMED";
              referral.franchise = AppSessionModel().loggedOnUser!.franchise!;
              widget.appointment.referalId = referral.id;

              await CommonApiService()
                  .update(referral.id, "referal", referral.toJson());
            }
          } else {
            process = false;
            await showDialog(
                context: context,
                builder: (c) {
                  return ErrorDialog(
                      message: "The referal code is invalid ",
                      title: "Confirmation");
                });
          }
        }
        if (process) {
          int key = widget.appointment.id;

          widget.appointment.clientId = widget.appointment.clientId!;
          widget.appointment.createAt = DateTime.now();
          widget.appointment.date = DateTime.parse(_dateController.text);
          widget.appointment.serviceName = selectedValue;
          widget.appointment.status = _statusController.text;
          widget.appointment.time = _timeController.text;
          // widget.appointment.service_franchise_link_id =

          int carModelId = carModelList
              .firstWhere(
                  (element) => element!.carType == selectedCarModelValue)!
              .id;
          widget.appointment.carModelId = carModelId;
          widget.appointment.serviceName = selectedCarServiceValue;
          List<ServiceFranchiseLink> list1 = await serviceFranchiseList;

          ServiceFranchiseLink serviceLink = list1.firstWhere((element) =>
              element.service!.name == widget.appointment.serviceName &&
              element.carModelId == carModelId &&
              element.franchiseId == widget.appointment.franchiseId);

          widget.appointment.serviceFranchiseLinkId = serviceLink.id;

          String responseMessage;
          if (key < 1) {
            key = await CommonApiService().getLatestID("appointment");
            widget.appointment.id = key;
            widget.appointment.active = true;
            widget.appointment.status = "Recieved";
            responseMessage = await CommonApiService()
                .save(widget.appointment.toJson(), "appointment");
          } else {
            widget.appointment.id = key;
            responseMessage = await CommonApiService()
                .update(key, "appointment", widget.appointment.toJson());
            if (responseMessage.contains("successfully")) {
              if (widget.appointment.status!.contains("Completed")) {}
            }
          }
          logger.d("responseMessage $responseMessage");

          await showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                    message: responseMessage, title: "Confirmation");
              });

          if (responseMessage.contains("successfully")) {
            //logEvent("liger_review_sumbit_successful");
            //Navigator.of(context).pushReplacementNamed('/home');
            Navigator.of(context).pop(widget.appointment);
            widget.refreshData!();
          }
        }
      }
    }
  }

  Future<List<String>> loadCarModelOptions() async {
    List<ServiceFranchiseLink>? carwashServiceList = await serviceFranchiseList;
    carModelList = carwashServiceList.map((e) => e.carModel).toList();

    carModelOptions = carwashServiceList
        .map((service) => service.carModel!.carType ?? '')
        .toSet()
        .toList();

    setState(() {
      carModelOptions = ['Select Model', ...carModelOptions];
    });
    return carModelOptions;
  }

  Future<List<String>> loadCarServiceOptions() async {
    List<ServiceFranchiseLink>? carwashServiceList = await serviceFranchiseList;

    carServiceList = carwashServiceList.map((e) => e.service).toList();
    carServiceOptions = carwashServiceList
        .map((service) => service.service!.name ?? '')
        .toSet()
        .toList();
    setState(() {
      carServiceOptions = ['Select Service', ...carServiceOptions];
    });
    return carServiceOptions;
  }

  Future<List<String>> fetchCarModel() async {
    List<ServiceFranchiseLink>? carwashServiceList = await serviceFranchiseList;
    carModelList = carwashServiceList.map((e) => e.carModel).toList();

    carModelOptions = carwashServiceList
        .map((service) => service.carModel!.carType ?? '')
        .toSet()
        .toList();
    List<String> resonse = ['Select Model', ...carModelOptions];
    return resonse;
  }

  Future<List<String>> fetchCarService() async {
    List<ServiceFranchiseLink>? carwashServiceList = await serviceFranchiseList;

    carServiceList = carwashServiceList.map((e) => e.service).toList();
    List<String> lis = carwashServiceList
        .map((service) => service.service!.name ?? '')
        .toSet()
        .toList();
    List<String> resonse = ['Select service', ...lis];
    return resonse;
  }

  Future<List<String>> fetchCarServiceByCarModel(String carModel) async {
    List<ServiceFranchiseLink>? carwashServiceList = await serviceFranchiseList;
    carwashServiceList = carwashServiceList
        .where((element) => element.carModel!.carType == carModel)
        .toList();

    carServiceList = carwashServiceList.map((e) => e.service).toList();
    List<String> lis = carwashServiceList
        .map((service) => service.service!.name ?? '')
        .toSet()
        .toList();
    List<String> resonse = ['Select Service', ...lis];

    setState(() {
      carServiceOptions = resonse;
    });

    return resonse;
  }

  Future<List<ServiceFranchiseLink>> getData() async {
    return CarWashApiService()
        .getServiceByFranchiseId(widget.appointment.franchiseId!);
  }

  List<String> filteredTerms = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Appointment details',
          style: TextStyle(color: Colors.black)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                controller: _referalCodeController,
                label: "Referal Code",
                hintText: "Referal Code",
                isObscre: false,
              ),
              Container(
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                width: 250,
                child: DropdownButton<String>(
                  iconSize: 24, // Set the size of the dropdown icon
                  elevation: 16, // Set the elevation of the dropdown
                  iconEnabledColor: Colors.blue, // S
                  style: const TextStyle(color: Colors.black),
                  value: selectedCarModelValue.trim(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCarModelValue = newValue!;
                      fetchCarServiceByCarModel(selectedCarModelValue);
                    });
                  },
                  items: carModelOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.trim(),
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                width: 250,
                child: DropdownButton<String>(
                  iconSize: 24, // Set the size of the dropdown icon
                  elevation: 16, // Set the elevation of the dropdown
                  iconEnabledColor: Colors.blue, // S
                  style: const TextStyle(color: Colors.black),
                  value: selectedCarServiceValue.trim(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCarServiceValue = newValue!;
                      //fetchCarServiceByCarModel(selectedCarModelValue);
                    });
                  },
                  alignment: Alignment.center,
                  items: carServiceOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.trim(),
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              CustomCalender(
                width: 250,
                isMandatory: true,
                label: "Appointment date",
                controller: _dateController,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365898)),
                selectedDate: _selectedDate,
              ),
              CustomTime(
                isMandatory: true,
                selectedTime: _selectedTime,
                width: 250,
                label: "Appointment time",
                controller: _timeController,
              ),
              CustomDropDown(
                controller: _statusController,
                selected: selectedStatus,
                sizeOptions: statusList,
                width: 250,
              ),
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
                        Navigator.of(context).pop(widget.appointment);
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
