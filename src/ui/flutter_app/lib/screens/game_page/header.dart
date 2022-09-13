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

part of 'game_page.dart';

@visibleForTesting
class GameHeader extends StatefulWidget implements PreferredSizeWidget {
  GameHeader({Key? key}) : super(key: key);

  @override
  final Size preferredSize = Size.fromHeight(
    kToolbarHeight + DB().displaySettings.boardTop + AppTheme.boardMargin,
  );

  @override
  State<GameHeader> createState() => _GameHeaderState();
}

class _GameHeaderState extends State<GameHeader> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolledUnder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
    }
    _scrollNotificationObserver = ScrollNotificationObserver.of(context);
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.addListener(_handleScrollNotification);
    }
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final bool oldScrolledUnder = _scrolledUnder;
      _scrolledUnder = notification.depth == 0 &&
          notification.metrics.extentBefore > 0 &&
          notification.metrics.axis == Axis.vertical;
      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {
          // React to a change in MaterialState.scrolledUnder
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final divider = Container(
      height: 4,
      width: 180,
      margin: const EdgeInsets.only(bottom: AppTheme.boardMargin),
      decoration: BoxDecoration(
        color: DB().colorSettings.boardBackgroundColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );

    final appBar = Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: DrawerIcon.of(context)!.icon,
        ),
        Center(
          child: BlockSemantics(
            child: Padding(
              padding: EdgeInsets.only(top: DB().displaySettings.boardTop),
              child: Column(
                children: <Widget>[
                  const HeaderIcons(),
                  divider,
                  const HeaderTip(),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        bottom: false,
        child: appBar,
      ),
    );
  }
}

@visibleForTesting
class HeaderTip extends StatefulWidget {
  const HeaderTip({Key? key}) : super(key: key);

  @override
  HeaderStateTip createState() => HeaderStateTip();
}

class HeaderStateTip extends State<HeaderTip> {
  String? message;

  void showTip() {
    final tipState = MillController().tip;

    if (tipState.showSnackBar && tipState.message != null) {
      rootScaffoldMessengerKey.currentState!
          .showSnackBarClear(tipState.message!);
    }
    setState(() => message = tipState.message);
  }

  @override
  void initState() {
    MillController().tip.addListener(showTip);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      message ?? S.of(context).welcome,
      maxLines: 1,
      style: TextStyle(color: DB().colorSettings.messageColor),
    );
  }

  @override
  void dispose() {
    MillController().tip.removeListener(showTip);
    super.dispose();
  }
}

@visibleForTesting
class HeaderIcons extends StatefulWidget {
  const HeaderIcons({Key? key}) : super(key: key);

  @override
  HeaderStateIcons createState() => HeaderStateIcons();
}

class HeaderStateIcons extends State<HeaderIcons> {
  void showIcons() {
    setState(() {});
  }

  @override
  void initState() {
    MillController().headIcons.addListener(showIcons);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: DB().colorSettings.messageColor,
      ),
      child: Row(
        key: const Key("HeaderIconRow"),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(MillController().gameInstance.gameMode.leftHeaderIcon),
          Icon(MillController().gameInstance.sideToMove.icon),
          Icon(MillController().gameInstance.gameMode.rightHeaderIcon),
        ],
      ),
    );
  }

  @override
  void dispose() {
    MillController().headIcons.removeListener(showIcons);
    super.dispose();
  }
}
