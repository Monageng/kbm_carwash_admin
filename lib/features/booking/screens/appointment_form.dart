import 'package:flutter/material.dart';
import '../../../common/functions/date_utils.dart';
import '../../../common/functions/logger_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/custom_dropdown.dart';
import '../../../common/widgets/custom_future_dropbox.dart';
import '../../../common/widgets/custom_time.dart';
import '../../../common/widgets/error_dialog.dart';
import '../../services/models/car_models_model.dart';
import '../../services/models/car_wash_service_model.dart';
import '../../services/models/service_franchise_link_model.dart';
import '../../services/service/car_wash_api_service.dart';
import '../../users/models/user_model.dart';
import '../../users/services/car_wash_api_service.dart';
import '../models/appointment_model.dart';

class AppointmentScreen extends StatefulWidget {
  late Appointment appointment;

  AppointmentScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _carServiceController = TextEditingController();

  final DateTime _selectedDate = DateTime.now();
  final TimeOfDay _selectedTime = TimeOfDay.now();
  String selectedValue = "Select a car wash service";
  String selectedCarModelValue = "";
  String selectedCarServiceValue = "";

  List<UserModel> userList = [];
  List<String?> searchUserList = [];

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
    "Recieved",
  ];

  @override
  void initState() {
    super.initState();
    getUsers();
    serviceFranchiseList = getData();
    update(widget.appointment);
  }

  void getUsers() async {
    List<UserModel> fetchedUsers = await UserApiService().getAllUsers();
    setState(() {
      userList = fetchedUsers;
      searchUserList = userList.map((e) => e.firstName).toList();
    });
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
    }
  }

  void clearControllers() {
    _serviceNameController.clear();
    _clientIdController.clear();
    _dateController.clear();
    _timeController.clear();
    _statusController.clear();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

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
              (element) => element!.carType == _carModelController.text)!
          .id;
      widget.appointment.carModelId = carModelId;
      widget.appointment.serviceName = _carServiceController.text;
      List<ServiceFranchiseLink> list1 = await serviceFranchiseList;

      print(" serviceLink ${widget.appointment.toJson()}");

      ServiceFranchiseLink serviceLink = list1.firstWhere((element) =>
          element.service!.name == widget.appointment.serviceName &&
          element.carModelId == carModelId &&
          element.franchiseId == widget.appointment.franchiseId);
      widget.appointment.serviceFranchiseLinkId = serviceLink.id;
      print(" Response for service link ${serviceLink.toJson()}");

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
            return ErrorDialog(message: responseMessage);
          });

      if (responseMessage.contains("successfully")) {
        //logEvent("liger_review_sumbit_successful");

        Navigator.of(context).pop(widget.appointment);
      }
    }
  }

  Future<List<String>> fetchCarModel() async {
    List<ServiceFranchiseLink>? carwashServiceList = await serviceFranchiseList;
    carModelList = carwashServiceList.map((e) => e.carModel).toList();

    List<String> lis = carwashServiceList
        .map((service) => service.carModel!.carType ?? '')
        .toSet()
        .toList();
    List<String> resonse = ['Select Model', ...lis];
    return resonse;
  }

  Future<List<String>> fetchCarService() async {
    List<ServiceFranchiseLink>? carwashServiceList = await serviceFranchiseList;

    carServiceList = carwashServiceList.map((e) => e.service).toList();
    List<String> lis = carwashServiceList
        .map((service) => service.service!.name ?? '')
        .toList();
    List<String> resonse = ['Select service', ...lis];
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
              CustomFutureDropbox(
                  width: 250,
                  futureList: fetchCarModel(),
                  controller: _carModelController,
                  hintText: "",
                  selectedValue: selectedCarModelValue),
              CustomFutureDropbox(
                  width: 250,
                  futureList: fetchCarService(),
                  controller: _carServiceController,
                  hintText: "",
                  selectedValue: selectedCarServiceValue),
              CustomCalender(
                width: 250,
                label: "Appointment date",
                controller: _dateController,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365898)),
                selectedDate: _selectedDate,
              ),
              CustomTime(
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
