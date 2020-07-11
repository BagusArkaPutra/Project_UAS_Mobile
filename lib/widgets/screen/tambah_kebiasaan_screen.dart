import 'package:flutter/material.dart';
import 'package:aplikasitask/datasource/data_source.dart';
import 'package:aplikasitask/db/model/kebiasaan_model.dart';
import 'package:aplikasitask/utils/core_utils.dart';
import 'package:aplikasitask/widgets/common/title_text.dart';
import 'package:provider/provider.dart';

class TambahKebiasaanScreen extends StatefulWidget {
  static const id = "TambahKebiasaanScreen";

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<TambahKebiasaanScreen> {
  final dateEditController = TextEditingController();
  final nameEditController = TextEditingController();

  DateTime selectedDate = CoreUtils.removeTimeComponent(DateTime.now());
  String frequency = 'Harian';
  int habitId = -1;
  KebiasaanModel habitModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    habitId = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KebiasaanNotifier>(
      builder: (context, habitsNotifier, child) {
        if (habitModel == null) {
          habitModel = habitsNotifier.searchHabit(habitId);
          if (habitModel != null) {
            nameEditController.text = habitModel.name;
            selectedDate =
                DateTime.fromMillisecondsSinceEpoch(habitModel.startingDate);
            dateEditController.text = CoreUtils.getDateInDDMMYYYY(selectedDate);
            frequency = habitModel.repetition;
          }
        }

        dateEditController.text = CoreUtils.getDateInDDMMYYYY(selectedDate);

        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 32),
                          TitleText(habitModel != null
                              ? "Update Kebiasaan"
                              : "Kebiasaan Baru"),
                          SizedBox(height: 32),
                          TextField(
                            controller: nameEditController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Kebiasaan',
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  controller: dateEditController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Tanggal mulai',
                                  ),
                                  onTap: () =>
                                      _showDatePickerForStartingDate(context),
                                ),
                              ),
                              SizedBox(width: 16),
                              IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () =>
                                    _showDatePickerForStartingDate(context),
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Frekuensi",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  _getRadioWidget('Harian', false),
                                  _getRadioWidget('Tiga kali seminggu', false)
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  _getRadioWidget('Empat kali seminggu', false),
                                  _getRadioWidget('Sekali dalam seminggu', true)
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            child: RaisedButton(
                              child: Text(
                                "Simpan",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                final habitName = nameEditController.text;
                                if (habitName != null && habitName.isNotEmpty) {
                                  if (habitId != -1) {
                                    _updateNewHabit(habitId, habitName);
                                  } else {
                                    _createNewHabit(habitName);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showDatePickerForStartingDate(BuildContext context) async {
    final today = DateTime.now();
    final newDay = today.add(Duration(days: -7));
    DateTime selectedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: newDay,
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );

    setState(() {
      selectedDate = CoreUtils.removeTimeComponent(selectedDateTime);
      dateEditController.text = CoreUtils.getDateInDDMMYYYY(selectedDate);
    });
  }

  Widget _getRadioWidget(String label, bool value) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Radio(
              value: label,
              groupValue: frequency,
              onChanged: (value) {
                setState(() {
                  frequency = label;
                });
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _createNewHabit(String habitName) {
    final habitModel = KebiasaanModel(
        name: habitName,
        startingDate: selectedDate.millisecondsSinceEpoch,
        repetition: frequency);

    Provider.of<KebiasaanNotifier>(context, listen: false).addHabit(habitModel);
    Navigator.pop(context);
  }

  void _updateNewHabit(int habitId, String habitName) {
    final habitModel = KebiasaanModel(
        id: habitId,
        name: habitName,
        startingDate: selectedDate.millisecondsSinceEpoch,
        repetition: frequency);

    Provider.of<KebiasaanNotifier>(context, listen: false)
        .updateHabitModel(habitModel);
    Navigator.pop(context);
  }
}
