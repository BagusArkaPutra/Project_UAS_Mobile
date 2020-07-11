import 'package:flutter/material.dart';
import 'package:aplikasitask/datasource/data_source.dart';
import 'package:aplikasitask/widgets/animation/base_container.dart';
import 'package:aplikasitask/widgets/animation/swipe_animation.dart';
import 'package:aplikasitask/widgets/common/kebiasaan_header_widget.dart';
import 'package:aplikasitask/widgets/common/kebiasaan_update.dart';
import 'package:aplikasitask/widgets/common/title_text.dart';
import 'package:aplikasitask/widgets/common/widget_minggu.dart';
import 'package:provider/provider.dart';

import 'tambah_kebiasaan_screen.dart';

class KebiasaanScreen extends StatelessWidget {
  static const id = "KebiasaanScreen";

  @override
  Widget build(BuildContext context) {
    return Consumer<KebiasaanNotifier>(
      builder: (context, habitsNotifier, child) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                backgroundColor: Color(0xFFEAEAF2),
                expandedHeight: 110.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: TitleText('Aplikasi Kebiasaan Harian',
                      fontSize: 20, color: Colors.black),
                  centerTitle: false,
                  titlePadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
                ),
              ),
              SliverPadding(
                  padding: EdgeInsets.only(top: 24, left: 16.0, right: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final habit = habitsNotifier.habits[index];
                      return getHabitInfo(context, habit.name, habit.repetition,
                          index, habitsNotifier);
                    }, childCount: habitsNotifier.habits.length),
                  )),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text("Tambah Kebiasaan"),
            onPressed: () => Navigator.pushNamed(
                context, TambahKebiasaanScreen.id,
                arguments: -1),
          ),
        );
      },
    );
  }

  Widget getHabitInfo(BuildContext context, String title, String frequency,
      int index, KebiasaanNotifier habitsNotifier) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BaseContainer(
            color: Color(0xFF2D2E30),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: KebiasaanUpdate(
                onEdit: () {
                  Navigator.pushNamed(context, TambahKebiasaanScreen.id,
                      arguments: habitsNotifier.habits[index].id);
                },
                onDelete: () {
                  habitsNotifier.deleteHabit(habitsNotifier.habits[index].id);
                },
              ),
            ),
          ),
        ),
        SwipeAnimation(
          child: BaseContainer(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: Column(
                children: <Widget>[
                  KebiasaanHeaderWidget(
                    title: title,
                    routineInfo: frequency,
                    iconData: Icons.calendar_today,
                  ),
                  SizedBox(height: 16),
                  WidgetMinggu(index),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
