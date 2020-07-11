import 'package:flutter/material.dart';
import 'package:aplikasitask/common/Kebiasaan_view_model.dart';
import 'package:aplikasitask/datasource/data_source.dart';
import 'package:provider/provider.dart';

import 'widget_hari.dart';

class WidgetMinggu extends StatelessWidget {
  final int index;

  WidgetMinggu(this.index);

  @override
  Widget build(BuildContext context) {
    return Consumer<KebiasaanNotifier>(
        builder: (context, habitsNotifier, child) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: getDays(habitsNotifier.habits[index].trackingModels),
      );
    });
  }

  List<Widget> getDays(List<TrackingViewModel> trackingModels) {
    List<Widget> days = [];
    for (TrackingViewModel trackingViewModel in trackingModels) {
      days.add(WidgetHari(trackingViewModel));
    }

    return days;
  }
}
