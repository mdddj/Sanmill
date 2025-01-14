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

part of 'package:sanmill/screens/general_settings/general_settings_page.dart';

class _SkillLevelSlider extends StatelessWidget {
  const _SkillLevelSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: S.of(context).skillLevel,
      child: ValueListenableBuilder(
        valueListenable: DB().listenGeneralSettings,
        builder: (context, Box<GeneralSettings> box, _) {
          final GeneralSettings generalSettings = box.get(
            DB.generalSettingsKey,
            defaultValue: const GeneralSettings(),
          )!;

          return Slider(
            value: generalSettings.skillLevel.toDouble(),
            min: 1,
            max: Constants.topSkillLevel.toDouble(),
            divisions: Constants.topSkillLevel - 1,
            label: generalSettings.skillLevel.toString(),
            onChanged: (value) {
              DB().generalSettings =
                  generalSettings.copyWith(skillLevel: value.toInt());
              logger.v("Skill level Slider value: $value");
            },
          );
        },
      ),
    );
  }
}
