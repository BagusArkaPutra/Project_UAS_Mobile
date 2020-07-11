import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:aplikasitask/common/info_tanggal.dart';
import 'package:aplikasitask/common/Kebiasaan_view_model.dart';
import 'package:aplikasitask/constants/constants.dart';
import 'package:aplikasitask/db/database_helper.dart';
import 'package:aplikasitask/db/model/kebiasaan_model.dart';
import 'package:aplikasitask/db/model/tracking_model.dart';
import 'package:aplikasitask/utils/core_utils.dart';

class KebiasaanNotifier extends ChangeNotifier {
  List<KebiasaanModel> _habits = [];
  List<TrackingModel> _trackingModels = [];
  List<KebiasaanViewModel> _habitViewModels = [];

  DatabaseHelper _dbHelper;

  KebiasaanNotifier() {
    _dbHelper = DatabaseHelper.instance;
    syncForFreshData().then((value) {
      notifyListeners();
    });
  }

  Future<void> syncForFreshData() async {
    await _fetchAllHabits();
    await _fetchAllTrackingModels();
    formHabitViewModel();
  }

  _fetchAllHabits() async {
    _habits.clear();
    _habits.addAll(await _dbHelper.queryAllHabits());
  }

  void addHabit(KebiasaanModel habitModel) async {
    await _dbHelper.insertHabitModel(habitModel);
    syncForFreshData();
  }

  void updateHabitModel(KebiasaanModel habitModel) async {
    await _dbHelper.updateHabitModel(habitModel);
    syncForFreshData();
  }

  Future<void> markDone(TrackingViewModel trackingViewModel) async {
    if (trackingViewModel.id != -1) {
      await _dbHelper.deleteTrackingModel(trackingViewModel.id);
    } else {
      await _dbHelper.insertTrackingModel(TrackingModel(
          habitId: trackingViewModel.habitId,
          checkedDate: trackingViewModel.dateTime));
    }

    syncForFreshData();
  }

  _fetchAllTrackingModels() async {
    _trackingModels.clear();
    _trackingModels.addAll(await _dbHelper.queryAllTrackingDetails());
  }

  int getTotalCount() {
    return _habitViewModels.length;
  }

  void formHabitViewModel() {
    _habitViewModels.clear();
    for (final habit in _habits) {
      final filteredTrackingModels = _trackingModels
          .where((element) => element.habitId == habit.id)
          .toList();

      final List<TrackingViewModel> trackingViewModels = [];

      final List<Infotanggal> thisWeek = CoreUtils.getWeek();
      for (Infotanggal dateInfo in thisWeek) {
        TrackingModel trackingModel;

        for (TrackingModel tm in filteredTrackingModels) {
          if (tm.checkedDate == dateInfo.dateTime.millisecondsSinceEpoch) {
            trackingModel = tm;
            break;
          }
        }

        bool isToday = dateInfo.dateType == DateType.TODAY;
        bool shouldEnable = !(dateInfo.dateType == DateType.FUTURE_DATE ||
            DateTime.fromMillisecondsSinceEpoch(habit.startingDate)
                    .compareTo(dateInfo.dateTime) >
                0);

        HabitDayState state = HabitDayState.NOT_APPLICABLE;
        if (shouldEnable) {
          if (isToday) {
            state = trackingModel != null
                ? HabitDayState.DONE
                : HabitDayState.PENDING;
          } else {
            state = trackingModel != null
                ? HabitDayState.DONE
                : HabitDayState.NOT_DONE;
          }
        }

        if (trackingModel != null) {
          trackingViewModels.add(TrackingViewModel(
              id: trackingModel.id,
              habitId: habit.id,
              dateTime: trackingModel.checkedDate,
              dayName: dateInfo.dayName,
              isEnabled: shouldEnable,
              isToday: isToday,
              habitDayState: state));
        } else {
          trackingViewModels.add(TrackingViewModel(
              id: -1,
              habitId: habit.id,
              dateTime: dateInfo.dateTime.millisecondsSinceEpoch,
              dayName: dateInfo.dayName,
              isEnabled: shouldEnable,
              isToday: isToday,
              habitDayState: state));
        }
      }

      var habitViewModel = KebiasaanViewModel(
          id: habit.id,
          name: habit.name,
          startingDate: habit.startingDate,
          repetition: habit.repetition,
          trackingModels: trackingViewModels);

      _habitViewModels.add(habitViewModel);
    }

    notifyListeners();
  }

  KebiasaanModel searchHabit(int habitId) {
    return _habits.firstWhere((element) => element.id == habitId,
        orElse: () => null);
  }

  void deleteHabit(int habitId) async {
    await _dbHelper.deleteHabitAndData(habitId);
    syncForFreshData();
  }

  UnmodifiableListView<KebiasaanViewModel> get habits {
    return UnmodifiableListView(_habitViewModels);
  }
}
