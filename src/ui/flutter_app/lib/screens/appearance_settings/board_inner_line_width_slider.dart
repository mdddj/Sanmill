// This file is part of Sanmill.
// Copyright (C) 2019-2022 The Sanmill developers (see AUTHORS file)
//
// Sanmill is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Sanmill is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

part of 'package:sanmill/screens/appearance_settings/appearance_settings_page.dart';

class _BoardInnerWidthSlider extends StatelessWidget {
  const _BoardInnerWidthSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: S.of(context).boardInnerLineWidth,
      child: ValueListenableBuilder(
        valueListenable: DB().listenDisplaySettings,
        builder: (context, Box<DisplaySettings> box, _) {
          final DisplaySettings displaySettings = box.get(
            DB.displaySettingsKey,
            defaultValue: const DisplaySettings(),
          )!;

          return Slider(
            value: displaySettings.boardInnerLineWidth,
            max: 20,
            divisions: 200,
            label: displaySettings.boardInnerLineWidth.toStringAsFixed(1),
            onChanged: (value) {
              logger.v("[config] BoardInnerLineWidth value: $value");
              DB().displaySettings =
                  displaySettings.copyWith(boardInnerLineWidth: value);
            },
          );
        },
      ),
    );
  }
}
