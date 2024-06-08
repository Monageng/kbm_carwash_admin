import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/common/functions/date_utils.dart';
import 'package:kbm_carwash_admin/common/widgets/custom_time.dart';
import 'package:kbm_carwash_admin/features/booking/models/appointment_model.dart';
import 'package:kbm_carwash_admin/features/services/service/car_wash_api_service.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/functions/logger_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/email_text_field.dart';
import '../../../common/widgets/error_dialog.dart';
import '../../services/models/car_wash_service_model.dart';

class AppointmentScreen extends StatefulWidget {
  late CarWashAppointment appointment;

  AppointmentScreen({
    super.key,
    required this.appointment,
  });

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String selectedValue = "Select a car wash service";

  @override
  void initState() {
    super.initState();
    update(widget.appointment);
  }

  void update(CarWashAppointment appointment) {
    if (appointment.id! > 0) {
      _serviceNameController.text = appointment.serviceName!;
      _clientIdController.text = "${appointment.clientId!}";
      _dateController.text = formatDateTime(appointment.date);
      _statusController.text = appointment.status!;
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

      widget.appointment.clientId = int.tryParse(_clientIdController.text);
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
        responseMessage = await CommonApiService()
            .save(widget.appointment.toJson(), "appointment");
      } else {
        widget.appointment.id = key;
        responseMessage = await CommonApiService()
            .update(key, "appointment", widget.appointment.toJson());
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
        carwashServiceList?.map((service) => service.name ?? '').toList() ?? [];
    lis.add("Select a car wash service");
    return lis;
  }

  @override
  Widget build(BuildContext context) {
    var serviceOptions = FutureBuilder<List<String>>(
      future:
          _fetchCarWashNames(), // Assuming _fetchCarWashNames is a function that maps the list of CarWashService to their names

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
              print("selectedValue : $selectedValue");
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
              // CustomTextField(
              //   width: 250,
              //   controller: _serviceNameController,
              //   hintText: "Service Name",
              //   label: " Service Name",
              //   isObscre: false,
              //   validator: (value) {
              //     return getFieldValidationMessage("Service Name", value);
              //   },
              // ),
              CustomCalender(
                width: 250,
                label: "Appointment date",
                controller: _dateController,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365898)),
                selectedDate: _selectedDate,
              ),
              CustomTime(
                selectedTime: _selectedTime,
                width: 250,
                label: "Appointment time",
                controller: _timeController,
              ),
              CustomTextField(
                width: 250,
                controller: _statusController,
                hintText: "Status",
                label: "Status",
                isObscre: false,
                validator: (value) {
                  return getFieldValidationMessage("Status", value);
                },
              ),
              CustomTextField(
                width: 250,
                controller: _clientIdController,
                hintText: "Client Id",
                label: "Client Id",
                isObscre: false,
                validator: (value) {
                  return getFieldValidationMessage("Client id", value);
                },
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
