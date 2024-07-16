import 'package:flutter/material.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/model/city_model.dart';
import '../../../common/model/province.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/contact_number_text_field.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/email_text_field.dart';
import '../../../common/widgets/error_dialog.dart';
import '../../../session/app_session.dart';
import '../models/franchise_model.dart';

class FranchiseForm extends StatefulWidget {
  final Franchise franchise;
  const FranchiseForm({super.key, required this.franchise});
  @override
  State<FranchiseForm> createState() => _FranchiseFormState();
}

class _FranchiseFormState extends State<FranchiseForm> {
  bool isNewFranchise = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contatcNumberController =
      TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _emilaController = TextEditingController();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _longitudeCodeController =
      TextEditingController();
  final TextEditingController _latituteCodeController = TextEditingController();
  final TextEditingController _effectiveFromDateController =
      TextEditingController();
  final TextEditingController _effectiveToDateController =
      TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  String selectedCountry = 'Select Country';
  String selectedCity = 'Select City';
  late List<String>? countries = ['Select Country'];

  String selectedProvince = 'Select Province';
  late List<String>? provinces = ['Select Province'];
  List<String> cities = ['Select City'];
  TimeOfDay selectedTime = TimeOfDay.now();

  final DateTime _selectedFromDate = DateTime.now();
  final DateTime _selectedToDate = DateTime.now();

  List<String> operatingHoursOptions = [
    "06:00 AM",
    "07:00 AM",
    "08:00 AM",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "13:00 PM",
    "14:00 PM",
    "15:00 PM",
    "16:00 PM",
    "17:00 PM",
    "18:00 PM",
    "19:00 PM",
    "20:00 PM",
    "21:00 PM",
    "22:00 PM",
    "23:00 PM",
    "00:00 AM"
  ];
  String selectedFromTime = "08:00 AM";
  String selectedToTime = "23:00 PM";

  Future<void> _save(BuildContext context) async {
    int _key = widget.franchise.id;
    String city = selectedCity != "Select City" ? selectedCity : "";
    String province =
        selectedProvince != "Select Province" ? selectedProvince : "";
    Franchise franchise = Franchise(
      id: 0,
      name: _nameController.text,
      streetAddress: _streetAddressController.text,
      city: city,
      province: province,
      postalCode: _postalCodeController.text,
      country: _countryController.text,
      latitude: double.parse(_latituteCodeController.text),
      longitude: double.parse(_longitudeCodeController.text),
      active: true,
      contactPerson: _contactPersonController.text,
      email: _emilaController.text,
      contactNumber: _contatcNumberController.text,
      description: _descriptionController.text,
      effectiveFromDate: DateTime.now().toIso8601String(),
      effectiveToDate: DateTime.now().toIso8601String(),
      modifiedBy: "System",
      imageUrl: _imageController.text,
    );

    try {
      String responseMessage = "";

      if (_key < 1) {
        _key = await CommonApiService().getLatestID("franchise");
        franchise.id = _key;
        responseMessage =
            await CommonApiService().save(franchise.toJson(), "franchise");
      } else {
        franchise.id = _key;
        responseMessage = await CommonApiService()
            .update(_key, "franchise", franchise.toJson());
      }

      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: responseMessage);
          });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    setDefaults();

    loadLookupProvince().then((result) {
      setState(() {
        provinces = ['Select Province', ...result];
      });
    });
  }

  List<String> filteredList = [];

  fetchCities(String selectedProvince) async {
    print("selectedProvince $selectedProvince");
    loadLookupCity(selectedProvince).then((result) {
      print(" result ---- ${result}");
      setState(() {
        cities = ['Select City', ...result];
        selectedCity = "Select City";
      });
    });

    return AppSessionModel().provinceList;
  }

  Future<List<String>> loadLookupCity(String selectedProvince) async {
    List<City> list =
        await CommonApiService().fetchCityByProvince(selectedProvince);
    List<String> dropdownList =
        list.map((e) => e.name!.trim()).cast<String>().toList();

    return dropdownList;
  }

  Future<List<String>> loadLookupProvince() async {
    List<Province> list = await AppSessionModel().provinceList;
    List<String> dropdownList =
        list.map((e) => e.name!.trim()).cast<String>().toList();

    return dropdownList;
  }

  void setDefaults() {
    if (widget.franchise.id > 0) {
      _nameController.text = widget.franchise.name;
      _contatcNumberController.text = widget.franchise.contactNumber!;
      _contactPersonController.text = widget.franchise.contactPerson!;
      _emilaController.text = widget.franchise.email!;
      _descriptionController.text = widget.franchise!.description!;
      _streetAddressController.text = widget.franchise.streetAddress!;
      _countryController.text = widget.franchise.country!;
      _postalCodeController.text = "${widget.franchise.postalCode}";
      _longitudeCodeController.text = "${widget.franchise.longitude}";
      _latituteCodeController.text = "${widget.franchise.latitude}";
      _imageController.text = "${widget.franchise.imageUrl}";
      _effectiveFromDateController.text = widget.franchise.effectiveFromDate!;
      _effectiveToDateController.text = widget.franchise.effectiveToDate!;
      loadLookupProvince().then((result) {
        setState(() {
          provinces!.clear();
          provinces = ['Select Province', ...result];
        });
      });

      selectedProvince = widget.franchise.province!;
      loadLookupCity(selectedProvince).then((result) {
        setState(() {
          cities = ['Select City', ...result];
          if (widget.franchise.city != null ||
              widget.franchise.city!.isNotEmpty) {
            selectedCity = widget.franchise.city!;
          } else {
            selectedCity = "Select City";
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setDefaults();
    return AlertDialog(
      title: const Text('New Franchise details',
          style: TextStyle(color: Colors.black)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Form(
                    key: _formKey1,
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          "General Information",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CustomTextField(
                        controller: _nameController,
                        width: 300,
                        hintText: "Name",
                        label: "Name",
                        isObscre: false,
                        validator: (value) {
                          return getFieldValidationMessage("Name", value);
                        },
                      ),
                      CustomTextField(
                        controller: _descriptionController,
                        width: 300,
                        hintText: "Description",
                        label: "Description",
                        isObscre: false,
                        validator: (value) {
                          return getFieldValidationMessage(
                              "Description", value);
                        },
                      ),
                      CustomTextField(
                          width: 300,
                          controller: _contactPersonController,
                          hintText: "Contact Person",
                          label: "Contact Person",
                          isObscre: false,
                          validator: (value) {
                            return getFieldValidationMessage(
                                "Contact Person", value);
                          }),
                      ContactNumberTextField(
                          controller: _contatcNumberController,
                          width: 300,
                          label: "Contact number"),
                      EmailTextField(controller: _emilaController, width: 300),
                      CustomTextField(
                          width: 300,
                          controller: _imageController,
                          hintText: "Image",
                          label: "Image",
                          isObscre: false,
                          validator: (value) {
                            return null;
                          }),
                      CustomCalender(
                        width: 300,
                        label: "From date",
                        controller: _effectiveFromDateController,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365898)),
                        selectedDate: _selectedFromDate,
                      ),
                      CustomCalender(
                        width: 300,
                        label: "To date",
                        controller: _effectiveToDateController,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365898)),
                        selectedDate: _selectedToDate,
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 60),
                          child: const Text(
                            "Address Information",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        CustomTextField(
                            width: 300,
                            controller: _streetAddressController,
                            hintText: "Street Address",
                            label: "Street Address",
                            isObscre: false,
                            validator: (value) {
                              return getFieldValidationMessage(
                                  "Street address", value);
                            }),
                        Container(
                          width: 300,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: DropdownButton<String>(
                            iconSize: 24, // Set the size of the dropdown icon
                            elevation: 16, // Set the elevation of the dropdown
                            iconEnabledColor: Colors.blue, // S
                            style: const TextStyle(color: Colors.black),
                            value: selectedProvince,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedProvince = newValue!;
                                fetchCities(selectedProvince);
                              });
                            },
                            alignment: Alignment.center,
                            items: provinces!
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 300,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: DropdownButton<String>(
                            iconSize: 24, // Set the size of the dropdown icon
                            elevation: 16, // Set the elevation of the dropdown
                            iconEnabledColor: Colors.blue, // S
                            style: const TextStyle(color: Colors.black),
                            value: selectedCity,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCity = newValue!;
                              });
                            },
                            alignment: Alignment.center,
                            items: cities
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        CustomTextField(
                            width: 100,
                            controller: _postalCodeController,
                            hintText: "Postal Code",
                            label: "Postal Code",
                            isObscre: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a postal code';
                              }

                              // Use a regular expression to validate if the entered value is numeric
                              // if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                              //   return 'Postal code must be numeric and valid postal code';
                              // }
                            }),
                        Row(
                          children: [
                            CustomTextField(
                                controller: _longitudeCodeController,
                                width: 120,
                                hintText: "longitude",
                                label: "Longitude",
                                isObscre: false,
                                validator: (value) {
                                  return getFieldValidationLongitude(
                                      "Longitude", value);
                                }),
                            CustomTextField(
                                controller: _latituteCodeController,
                                hintText: "latitude",
                                label: "latitude",
                                isObscre: false,
                                width: 120,
                                validator: (value) {
                                  return getFieldValidationLatitude(
                                      "Latitude", value);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CustomElevatedButton(
                      text: "Save Franchise Details",
                      onPressed: () {
                        if (_formKey1.currentState!.validate() &&
                            _formKey.currentState!.validate()) {
                          _formKey1.currentState!.save();
                          _formKey.currentState!.save();
                          _save(context);
                        }
                      },
                    ),
                  ),
                ),
                Center(
                  child: CustomElevatedButton(
                    text: "Close",
                    onPressed: () {
                      Navigator.of(context).pop(widget.franchise);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _nameController.dispose();
    // _contactPersonController.dispose();
    // _openingTimeController.dispose();
    // _closeTimeController.dispose();
    // _websiteUrlController.dispose();
    // _imageUrlController.dispose();
    // _effectiveFromDateController.dispose();
    // _effectiveToDateController.dispose();
    // _takeAwayController.dispose();
    // _dineInController.dispose();
    // _ratingController.dispose();
    // _activeController.dispose();
  }
}
