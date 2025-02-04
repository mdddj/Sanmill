## 概览

<a href="https://f-droid.org/zh_Hans/packages/com.calcitem.sanmill/" target="_blank">
<img src="fastlane/metadata/android/zh-CN/images/featureGraphic.png" alt="Get it on F-Droid"/></a>

<a href="https://f-droid.org/zh_Hans/packages/com.calcitem.sanmill/" target="_blank">
<img src="src/ui/flutter_app/assets/badges/get-it-on-fdroid.png" alt="Get it on F-Droid" height="80"/></a>

<a href="https://gitee.com/calcitem/Sanmill" target="_blank">
<img src="src/ui/flutter_app/assets/badges/get-it-on-gitee.png" alt="Get it on Gitee" height="80"/></a>

[![Build Status](https://ci.appveyor.com/api/projects/status/github/Calcitem/Sanmill?branch=master&svg=true)](https://ci.appveyor.com/project/Calcitem/Sanmill/branch/master)
[![snapcraft](https://snapcraft.io/sanmill/badge.svg)](https://snapcraft.io/sanmill)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/dd51135302af45a989a382d3a3d9eadc)](https://www.codacy.com/gh/calcitem/Sanmill/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=calcitem/Sanmill&amp;utm_campaign=Badge_Grade)

[Sanmill](https://gitee.com/calcitem/Sanmill) 是一个直棋程序，具有命令行、移动端 Flutter 和 PC 端 Qt 三个界面。

直棋为棋规简单、老少皆宜的双人游戏，通常棋盘为同心的数个正方形，并用直线或斜线将不同的正方形相连结。直棋普遍以消灭对方吃子能力，或困毙对方为胜。规则可用 “**先摆后移，成三吃子，余三飞子，无路者负。**” 简述之。

## 直棋介绍

### 棋规

直棋流传于各地，有许多规则变体，名称亦不相同。譬如：

* 闽台称为“直棋”；
* 苗族、四川、广东阳江等地称为“三棋”
* 壮族称为“棋三”、“盘三”；
* 广东湛江等地称为“成三棋”；
* 广东揭西、河北延庆等地称为“下三棋”；
* 湘西土家族、侗族、河北涉县等地称为“打三棋”；
* 瑶族、重庆等地称为“三三棋”；
* 广东海康称为“走城”；
* 云南大理称为“乘棋”、“城棋”；
* 湖北麻城称为“龙棋”、成龙棋”；
* 北京称为“连儿棋”；
* 其他地区还有“花窗棋”、“风车棋”、“删棋”、“三子棋”、“连三”、“九子棋”、“十二子棋”等称呼。

各地直棋游戏变体都依循的共通游戏规则为，开始将手中的棋子以双方轮流的顺序摆到棋盘上。当手中的棋子都已经摆完后，才可以移动棋子。因此直棋游戏至少拥有两个不同阶段。如果造成三个己方棋子连成一线，俗称此情况为“直”，或“三连”，就可以吃掉棋盘上对方的一颗棋子，并且吃掉的棋子不能再放回棋盘上。游戏进行至某一方无棋子可移动，或是盘面上的棋子少于两颗，则该方判定为输。因为双方轮流移动棋子，所以有机会发生走过的盘面又再一次出现，造成循环的盘面，在双方都不改变行子方式的情形下有可能产生和棋的结果。

本游戏支持各种不同的规则变体设置，让玩家能设置自己熟悉的规则畅玩，例如：

* 双方手中各拥有几颗棋子？可选9颗、10颗、11颗、12颗等；
* 棋盘上是否有左上、左下、右上、右下4条斜线，还是全为直线？十二子直棋棋盘通常带斜线，天生倾向以消灭对方吃子能力为多，并且先放子方的优势更大；九子直棋通常不带斜线，与其说是吃子棋，倒不如看成是以困毙为主要胜利方式的棋类。
* 当发生“直”时，是否限制不能吃掉三颗棋子连成一线中的任何一颗棋子？此规在摆子阶段可避免局面反复, 以及避免在走子阶段出现一面倒，亦提供玩家可用弃子防御、阻碍散子等增加策略变化。
* 是否摆子阶段被吃的对方的棋不立即移除，而是先作标记等至摆完子后、走子前再一齐移除？此规则可降低先摆子玩家的优势，避免移除阻碍己方成形的对方的棋，逼对方下着被动再下该位；以及让之后可行棋的空位呈现散布，而不是在摆子阶段末时集中在某处而容易阻塞。这种规则的有无，造成在摆子阶段的策略大不同。 标示吃子的直棋，是以形成在走子阶段能连续吃子的棋形为目标；立即提子则是以包围对方的棋不能活动为目标。
* 在走子阶段若剩余三颗子时是否允许“飞棋”？即能自由移动到任意空点。在棋盘无斜线情况下，走子阶段，如一方少于8颗子，一方剩余3颗子，容易僵持不下最终和棋，所以尽量围住对方剩下的4颗子。
* 满盘时先摆子方是否输掉游戏？此为处罚无能的先摆子方。
* 走子阶段是否由后摆子方先走？以弥补后摆子方弱势。

### 哲学

直棋与中国古代文化和思维的方式有不少契合之处。

古语有云：“夫美者，上下、内外、大小、远近皆无害焉，故曰美。”里里外外皆均衡妥帖，方为“美”。直棋棋盘体现出和谐、庄重和对称美。棋盘上有三个圈。我们的世界，万事万物都在循环，日出日落、月盈月亏、四季更替、等等，都是循环发展的。整个世界就是活动着数不清的圆圈。

“3” 在直棋中是一个重要的数字，棋盘上有内圈、中圈、外圈共三圈，成三即可吃子，棋子数少于三则负。

在中国文化里，“三”表示“多”，事不过三、三省吾身、三思而行、举一反三、三人行必有我师。很多时候，三具有典型性，如：三甲，也是一条界线。三连在一起就成了“丰”、“王”。

棋盘上有24个点。二十四在中国文化中也是一个重要的数字。如二十四节气，此为是古人留下的一串密码，在劳动人民解读自然规律的同时，贵生意识、阴阳五行思想、天人和谐理念等中国特有的哲学理念成为万能的密码本，为中国人理解世界提供广泛的灵感。

和其他棋类不同，直棋是违反直觉的，尤其是九子直棋。以下列举几点：

* 执后手比先手容易得多，因为后手方可以在摆棋阶段战略性地放置最后一枚棋子，进入走棋阶段后更容易控制局面。

* 不要试图成为首先成三的一方。通常在摆棋阶段成三的一方很容易被封锁。

* 多子未必就占优，三对四的局面说不定对于三枚子的一方是必胜局。哪怕开局先让对方吃一子，也未必会影响局势。此所谓“**愚者求子，智者求势**”。

* 关键的一点：你试图赢，你就会输。不能想着赢棋。先瞄准和棋的目标，让自己避免输棋，观察对手，还可以轻轻将对手引诱到容易犯错的局面中，等对方露出破绽，便抓住机会轻轻推动，这样你就赢了。

这和孙子兵法的思想是相通的。

孙子曰：“**昔之善战者，先为不可胜，以待敌之可胜。不可胜在己，可胜在敌。**”

孙子说，古代真正善于作战的人，先规划自己，让自己成为不可战胜的，这叫“先为不可胜，以待敌之可胜。”然后再等待敌人可以被战胜的时机。 “不可胜在己”，完全在于自己，而什么时候敌人可胜呢？那完全在于敌人，不归自己管。

孙子曰：“**故善战者，能为不可胜，不能使敌之可胜。故曰：胜可知，而不可为。**”

古代真正善于作战的人，最大的本事到什么程度？就是能让自己成为不可战胜的，但是没有本事让敌人一定可以被战胜。所以说， “胜可知而不可为”，胜利是可以提前知道的。 但是如果说不可胜呢？这是不可强求的，不能把不可胜变成可胜的。

后面还有一句话，叫“**善战者，胜已败之敌也**”，对方自己已经败了，这时候赶紧去推一把，叫“胜已败之敌”。

概括一下孙子的思想：**敌人是不可战胜的。** 后面再加一句，**只能等他自己败**。

如果对方也一直不犯错，怎么办呢？

兵法就四个字 “**多方以误**”，就是想方设法地去引诱对方犯错误。

别人对我“多方以误”，我怎么能不上对方的当呢？兵法上面有一句话叫“**不忘本谋**”，本来是怎么谋划的，别忘了。

## 目录结构

Sanmill 的此发行版包含以下文件：

* README.md，您当前正在阅读的文件。

* Copying.txt，包含 GNU 通用公共许可证版本 3 的文本文件。

* src，包含完整源代码的子目录，包括可用于在类 Unix 系统上编译 Sanmill 命令行程序的 Makefile。

* src/ui/flutter_app，包含 Flutter 前端的子目录。

* src/ui/qt，包含 Qt 前端的子目录。

## 如何构建

### 命令行程序

Sanmill 命令行程序支持 32 位或 64 位 CPU、某些硬件指令、Power PC 等大端机器和其他平台。

可以简单地在类 Unix 系统上使用包含在文件夹 `src` 中的 Makefile 直接从源代码编译 Sanmill。通常，建议运行 `make help` 以查看带有相应描述的 make 目标列表。

```shell
cd src
make help
make build ARCH=x86-64-modern
```

报告问题或错误时，请告诉我们您用于创建可执行文件的版本和编译器。可以通过在控制台中键入以下命令来找到此信息：

```shell
./sanmill compiler
```

### Qt 应用程序

如果您已经开始使用 Ubuntu 或任何基于 Ubuntu 的 Linux 发行版，则必须通过以 root 身份运行以下命令来安装 Qt：

```shell
sudo apt-get install qt5-default qtmultimedia5-dev qtcreator
```

使用 Qt Creator 打开 `millgame.pro` ，或使用 Visual Studio 打开 `millgame.sln` 来构建 Qt 应用程序。

### Flutter App

运行`./flutter-init.sh`，复制`src/ui/flutter_app/android/key.properties.example`到`src/ui/flutter_app/android/key.properties`，修改，然后使用 Android Studio 或 Visual Studio Code 打开 `src/ui/flutter_app` 来构建 Flutter App。

我们使用编译期环境配置来启用代码的特定部分：

* `test` 为 Monkey 和 Appium 测试准备的应用程序。 （对外部站点的点击将被禁用。）
* `dev_mode` 在 app 上显示开发者模式，无需先启用它。
* `catcher` 控制 Catcher 的使用。 （这是默认开启的，需要时可以禁用。）

所有环境配置都可以组合起来，并采用布尔值，例如：

```shell
flutter run --dart-define catcher=false dev_mode=true
```

为了便于使用，可以使用一些 Android Studio 或 Visual Studio Code 的启动配置。只需
在“运行和调试”或“运行/调试配置”选项卡中选择所需要一个。

## 了解代码库并参与项目

在社区的加持下，Sanmill 在过去几年中得到了迅速地改进。有下述几种方法可以帮助项目发展。

### 改进代码

如果您想帮助改进代码，有几个有价值的资源：

* [在这个 wiki 中](https://gitee.com/calcitem/Sanmill/wikis/Home)，有在 Sanmill 中使用的很多相关技术的背景信息的说明。

* 最新的源代码总是可以在 [GitHub](https://github.com/calcitem/Sanmill) 上找到。

* 关于 Sanmill 的讨论在 [Issues](https://gitee.com/calcitem/Sanmill/issues) 中进行。

## 使用条款

Sanmill 是免费的，并根据 **GNU 通用公共许可证版本 3**（GPL v3）分发。 从本质上讲，这意味着您可以自由地使用该程序并几乎完全按照您的意愿进行操作，包括在您的朋友中分发它、使其可从您的网站下载、出售（单独或作为某些更大软件包的一部分）， 或将其用作您自己的软件项目的起点。

唯一真正的限制是，每当您以某种方式分发 Sanmill 时，您必须始终包含完整的源代码或指向可以找到源代码的位置的链接。 如果您对源代码进行任何更改，这些更改也必须在 GPL 下可用。

有关详细信息，请阅读在名为 *Copying.txt* 的文件中找到的 GPL v3 副本。
