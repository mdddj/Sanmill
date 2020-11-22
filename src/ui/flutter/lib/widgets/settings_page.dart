/*
  FlutterMill, a mill game playing frontend derived from ChessRoad
  Copyright (C) 2019 He Zhaoyun (ChessRoad author)
  Copyright (C) 2019-2020 Calcitem <calcitem@outlook.com>

  FlutterMill is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  FlutterMill is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:sanmill/common/config.dart';
import 'package:sanmill/services/audios.dart';
import 'package:sanmill/services/player.dart';
import 'package:sanmill/style/colors.dart';
import 'package:sanmill/style/toast.dart';

import 'edit_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _version = "";

  @override
  void initState() {
    super.initState();
    loadVersionInfo();
  }

  loadVersionInfo() async {
    //
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'Version ${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  changeDifficult() {
    //
    callback(int thinkingTime) async {
      //
      Navigator.of(context).pop();

      setState(() {
        Config.thinkingTime = thinkingTime;
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
            title: Text('初级'),
            groupValue: Config.thinkingTime,
            value: 5000,
            onChanged: callback,
          ),
          Divider(),
          RadioListTile(
            activeColor: UIColors.primaryColor,
            title: Text('中级'),
            groupValue: Config.thinkingTime,
            value: 15000,
            onChanged: callback,
          ),
          Divider(),
          RadioListTile(
            activeColor: UIColors.primaryColor,
            title: Text('高级'),
            groupValue: Config.thinkingTime,
            value: 30000,
            onChanged: callback,
          ),
          Divider(),
          SizedBox(height: 56),
        ],
      ),
    );
  }

  switchMusic(bool value) async {
    //
    setState(() {
      Config.bgmEnabled = value;
    });

    if (Config.bgmEnabled) {
      //Audios.loopBgm('bg_music.mp3');
    } else {
      Audios.stopBgm();
    }

    Config.save();
  }

  switchTone(bool value) async {
    //
    setState(() {
      Config.toneEnabled = value;
    });

    Config.save();
  }

  changeName() async {
    //
    final newName = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              EditPage('棋手姓名', initValue: Player.shared.name)),
    );

    if (newName != null) nameChanged(newName);
  }

  nameChanged(String newName) async {
    //
    setState(() {
      Player.shared.name = newName;
    });

    Player.shared.saveAndUpload();
  }

  showAbout() {
    //
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('关于「直棋 」', style: TextStyle(color: UIColors.primaryColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5),
            Text('版本', style: TextStyle(fontFamily: '')),
            Text('$_version', style: TextStyle(fontFamily: '')),
            SizedBox(height: 15),
            Text('官网', style: TextStyle(fontFamily: '')),
            GestureDetector(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: 'http://www.calcitem.com'),
                );
                Toast.toast(context, msg: '网址已复制！');
              },
              child: Text(
                "http://www.calcitem.com",
                style: TextStyle(fontFamily: '', color: Colors.blue),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('好的'), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    final TextStyle headerStyle =
        TextStyle(color: UIColors.secondaryColor, fontSize: 20.0);
    final TextStyle itemStyle = TextStyle(color: UIColors.primaryColor);

    return Scaffold(
      backgroundColor: UIColors.lightBackgroundColor,
      appBar: AppBar(title: Text('设置')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10.0),
            Text("人机难度", style: headerStyle),
            const SizedBox(height: 10.0),
            Card(
              color: UIColors.boardBackgroundColor,
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("游戏难度", style: itemStyle),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Text(Config.thinkingTime <= 5000
                          ? '初级'
                          : Config.thinkingTime <= 15000
                              ? '中级'
                              : '高级'),
                      Icon(Icons.keyboard_arrow_right,
                          color: UIColors.secondaryColor),
                    ]),
                    onTap: changeDifficult,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text("声音", style: headerStyle),
            Card(
              color: UIColors.boardBackgroundColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    activeColor: UIColors.primaryColor,
                    value: Config.bgmEnabled,
                    title: Text("背景音乐", style: itemStyle),
                    onChanged: switchMusic,
                  ),
                  _buildDivider(),
                  SwitchListTile(
                    activeColor: UIColors.primaryColor,
                    value: Config.toneEnabled,
                    title: Text("提示音效", style: itemStyle),
                    onChanged: switchTone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text("排行榜", style: headerStyle),
            Card(
              color: UIColors.boardBackgroundColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("棋手姓名", style: itemStyle),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Text(Player.shared.name),
                      Icon(Icons.keyboard_arrow_right,
                          color: UIColors.secondaryColor),
                    ]),
                    onTap: changeName,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text("关于", style: headerStyle),
            Card(
              color: UIColors.boardBackgroundColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("关于「直棋」", style: itemStyle),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Text(_version ?? ''),
                      Icon(Icons.keyboard_arrow_right,
                          color: UIColors.secondaryColor),
                    ]),
                    onTap: showAbout,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60.0),
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