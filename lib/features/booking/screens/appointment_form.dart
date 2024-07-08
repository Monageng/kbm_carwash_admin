import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/common/widgets/custom_dropdown.dart';
import 'package:kbm_carwash_admin/features/users/models/user_model.dart';
import '../../../common/functions/date_utils.dart';
import '../../../common/functions/logger_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/custom_time.dart';
import '../../../common/widgets/error_dialog.dart';
import '../../services/models/car_wash_service_model.dart';
import '../../services/service/car_wash_api_service.dart';
import '../../users/services/car_wash_api_service.dart';
import '../models/appointment_model.dart';

class AppointmentScreen extends StatefulWidget {
  late CarWashAppointment appointment;

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

  final DateTime _selectedDate = DateTime.now();
  final TimeOfDay _selectedTime = TimeOfDay.now();
  String selectedValue = "Select a car wash service";

  List<UserModel> userList = [];
  List<String?> searchUserList = [];

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
    update(widget.appointment);
  }

  void getUsers() async {
    List<UserModel> fetchedUsers = await UserApiService().getAllUsers();
    setState(() {
      userList = fetchedUsers;
      searchUserList = userList.map((e) => e.firstName).toList();
    });
  }

  void update(CarWashAppointment appointment) {
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

  Future<List<String>> _fetchCarWashNames() async {
    List<CarWashService>? carwashServiceList =
        await CarWashApiService().getAllCarWashService();

    List<String> lis =
        carwashServiceList.map((service) => service.name ?? '').toList();
    lis.add("Select a car wash service");
    return lis;
  }

  final List<String> searchTerms = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
  ];
  List<String> filteredTerms = [];

  @override
  Widget build(BuildContext context) {
    var serviceOptions = FutureBuilder<List<String>>(
      future: _fetchCarWashNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show error message if data fetching fails
        } else {
          List<String> serviceNames = snapshot.data as List<String>;

          return DropdownButton<String>(
            value: selectedValue,
            items: serviceNames.map((String name) {
              return DropdownMenuItem<String>(
                value: name,
                child: Text(
                  name,
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedValue = value!;
              });
            },
            hint: const Text(
                'Select a car wash service'), // Placeholder text when no option is selected
          );
        }
      },
    );

    return AlertDialog(
      title: const Text('Appointment details',
          style: TextStyle(color: Colors.black)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              serviceOptions,
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
              // TextField(
              //   style: TextStyle(color: Colors.black),
              //   onChanged: (value) {
              //     _filterSearchResults(value);
              //   },
              //   decoration: const InputDecoration(
              //     fillColor: Colors.amber,
              //     labelText: "Search",
              //     hintText: "Search",
              //     prefixIcon: Icon(Icons.search),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(25.0)),
              //     ),
              //   ),
              // ),

              // CustomTextField(
              //   width: 250,
              //   controller: _clientIdController,
              //   hintText: "Client Id",
              //   label: "Client Id",
              //   isObscre: false,
              //   validator: (value) {
              //     return getFieldValidationMessage("Client id", value);
              //   },
              // ),
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
