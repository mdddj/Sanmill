/*
  This file is part of Sanmill.
  Copyright (C) 2019-2021 The Sanmill developers (see AUTHORS file)

  Sanmill is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Sanmill is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:sanmill/common/config.dart';
import 'package:sanmill/generated/l10n.dart';
import 'package:sanmill/style/colors.dart';

class GameSettingsPage extends StatefulWidget {
  @override
  _GameSettingsPageState createState() => _GameSettingsPageState();
}

class _GameSettingsPageState extends State<GameSettingsPage> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  @override
  void initState() {
    super.initState();
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  showBoardColorDialog() async {
    AlertDialog alert = AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: changeColor,
          showLabel: true,
          //pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            setState(() => currentColor = pickerColor);
            Config.boardBackgroundColor = pickerColor.value;
            Config.save();
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showBackgroundColorDialog() async {
    AlertDialog alert = AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: changeColor,
          showLabel: true,
          //pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            setState(() => currentColor = pickerColor);
            Config.darkBackgroundColor = pickerColor.value;
            Config.save();
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showBoardLineColorDialog() async {
    AlertDialog alert = AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: changeColor,
          showLabel: true,
          //pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            setState(() => currentColor = pickerColor);
            Config.boardLineColor = pickerColor.value;
            Config.save();
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  setSkillLevel() async {
    //
    callback(int skillLevel) async {
      //
      Navigator.of(context).pop();

      setState(() {
        Config.skillLevel = skillLevel;
      });

      Config.save();
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          RadioListTile(
            activeColor: UIColors.primaryColor,
            title: Text('L1'),
            groupValue: Config.skillLevel,
            value: 10,
            onChanged: callback,
          ),
          Divider(),
          RadioListTile(
            activeColor: UIColors.primaryColor,
            title: Text('L2'),
            groupValue: Config.skillLevel,
            value: 20,
            onChanged: callback,
          ),
          Divider(),
          RadioListTile(
            activeColor: UIColors.primaryColor,
            title: Text('L3'),
            groupValue: Config.skillLevel,
            value: 30,
            onChanged: callback,
          ),
          Divider(),
          SizedBox(height: 56),
        ],
      ),
    );
  }

  setWhoMovesFirst(bool value) async {
    setState(() {
      Config.aiMovesFirst = !value;
    });

    Config.save();
  }

  setAiIsLazy(bool value) async {
    setState(() {
      Config.aiIsLazy = value;
    });

    Config.save();
  }

  setIsAutoRestart(bool value) async {
    setState(() {
      Config.isAutoRestart = value;
    });

    Config.save();
  }

  setIsAutoChangeFirstMove(bool value) async {
    setState(() {
      Config.isAutoChangeFirstMove = value;
    });

    Config.save();
  }

  setResignIfMostLose(bool value) async {
    setState(() {
      Config.resignIfMostLose = value;
    });

    Config.save();
  }

  setShufflingEnabled(bool value) async {
    setState(() {
      Config.shufflingEnabled = value;
    });

    Config.save();
  }

  setLearnEndgame(bool value) async {
    setState(() {
      Config.learnEndgame = value;
    });

    Config.save();
  }

  setIdsEnabled(bool value) async {
    setState(() {
      Config.idsEnabled = value;
    });

    Config.save();
  }

  setDepthExtension(bool value) async {
    setState(() {
      Config.depthExtension = value;
    });

    Config.save();
  }

  setOpeningBook(bool value) async {
    setState(() {
      Config.openingBook = value;
    });

    Config.save();
  }

  setTone(bool value) async {
    //
    setState(() {
      Config.toneEnabled = value;
    });

    Config.save();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headerStyle =
        TextStyle(color: UIColors.crusoeColor, fontSize: 20.0);
    final TextStyle itemStyle = TextStyle(color: UIColors.crusoeColor);
    final cardColor = UIColors.floralWhiteColor;

    return Scaffold(
      backgroundColor: UIColors.lightBackgroundColor,
      appBar: AppBar(
          centerTitle: true,
          title: Text(S.of(context).settings),
          backgroundColor: UIColors.primaryColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10.0),
            Text(S.of(context).skillLevel, style: headerStyle),
            const SizedBox(height: 10.0),
            Card(
              color: cardColor,
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(S.of(context).skillLevel, style: itemStyle),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Text(Config.skillLevel == 10
                          ? 'L1'
                          : Config.skillLevel == 20
                              ? 'L2'
                              : 'L3'),
                      Icon(Icons.keyboard_arrow_right,
                          color: UIColors.secondaryColor),
                    ]),
                    onTap: setSkillLevel,
                  ),
                  SwitchListTile(
                    activeColor: UIColors.primaryColor,
                    value: Config.aiIsLazy,
                    title: Text(S.of(context).aiIsLazy, style: itemStyle),
                    onChanged: setAiIsLazy,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).sound, style: headerStyle),
            Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    activeColor: UIColors.primaryColor,
                    value: Config.toneEnabled,
                    title: Text(S.of(context).tone, style: itemStyle),
                    onChanged: setTone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).whoMovesFirst, style: headerStyle),
            Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    activeColor: UIColors.primaryColor,
                    value: !Config.aiMovesFirst,
                    title: Text(
                        Config.aiMovesFirst
                            ? S.of(context).ai
                            : S.of(context).human,
                        style: itemStyle),
                    onChanged: setWhoMovesFirst,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).misc, style: headerStyle),
            Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    activeColor: UIColors.primaryColor,
                    value: Config.isAutoRestart,
                    title: Text(S.of(context).isAutoRestart, style: itemStyle),
                    onChanged: setIsAutoRestart,
                  ),
                  _buildDivider(),
                  SwitchListTile(
                    activeColor: UIColors.primaryColor,
                    value: Config.shufflingEnabled,
                    title:
                        Text(S.of(context).shufflingEnabled, style: itemStyle),
                    onChanged: setShufflingEnabled,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).color, style: headerStyle),
            Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(S.of(context).boardColor, style: itemStyle),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Text(Config.boardBackgroundColor.toRadixString(16)),
                      Icon(Icons.keyboard_arrow_right,
                          color: UIColors.secondaryColor),
                    ]),
                    onTap: showBoardColorDialog,
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text(S.of(context).backgroudColor, style: itemStyle),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Text(Config.darkBackgroundColor.toRadixString(16)),
                      Icon(Icons.keyboard_arrow_right,
                          color: UIColors.secondaryColor),
                    ]),
                    onTap: showBackgroundColorDialog,
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text(S.of(context).lineColor, style: itemStyle),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Text(Config.boardLineColor.toRadixString(16)),
                      Icon(Icons.keyboard_arrow_right,
                          color: UIColors.secondaryColor),
                    ]),
                    onTap: showBoardLineColorDialog,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 1.0,
      color: UIColors.lightLineColor,
    );
  }
}