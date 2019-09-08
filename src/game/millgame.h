﻿/*****************************************************************************
 * Copyright (C) 2018-2019 MillGame authors
 *
 * Authors: liuweilhy <liuweilhy@163.com>
 *          Calcitem <calcitem@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

#ifndef MILLGAME_H
#define MILLGAME_H

#include <string>
#include <cstring>
#include <list>

#include "config.h"
#include "types.h"
#include "rule.h"
#include "board.h"

using namespace std;


// 棋局结构体，算法相关，包含当前棋盘数据
// 单独分离出来供AI判断局面用，生成置换表时使用
class GameContext
{
public:
    Board board;

#if ((defined TRANSPOSITION_TABLE_ENABLE) || (defined BOOK_LEARNING) || (defined THREEFOLD_REPETITION))
    // 局面的哈希值
    hash_t hash{};

    // Zobrist 数组
    hash_t zobrist[Board::N_POINTS][POINT_TYPE_COUNT]{};
#endif /* TRANSPOSITION_TABLE_ENABLE */

    // 局面阶段标识
    enum GameStage stage;

    // 轮流状态标识
    enum Player turn;

    // 动作状态标识
    enum Action action
    {
    };

    // 玩家1剩余未放置子数
    int nPiecesInHand_1{};

    // 玩家2剩余未放置子数
    int nPiecesInHand_2{};

    // 玩家1盘面剩余子数
    int nPiecesOnBoard_1{};

    // 玩家1盘面剩余子数
    int nPiecesOnBoard_2{};

    // 尚待去除的子数
    int nPiecesNeedRemove{};
};

// 棋类（在数据模型内，玩家只分先后手，不分黑白）
// 注意：MillGame类不是线程安全的！
// 所以不能跨线程修改MillGame类的静态成员变量，切记！
class MillGame
{
    // AI友元类
    friend class MillGameAi_ab;

public:
    // 赢盘数
    int score_1 {};
    int score_2 {};
    int score_draw {};

    uint64_t rand64() {
        return static_cast<uint64_t>(rand()) ^
                (static_cast<uint64_t>(rand()) << 15) ^
                (static_cast<uint64_t>(rand()) << 30) ^
                (static_cast<uint64_t>(rand()) << 45) ^
                (static_cast<uint64_t>(rand()) << 60);
    }

    uint64_t rand56()
    {
        return rand64() << 8;
    }

    static int playerToId(enum Player player);

    static Player getOpponent(enum Player player);

private:

    // 创建哈希值
    void constructHash();

public:
    explicit MillGame();
    virtual ~MillGame();

    // 拷贝构造函数
    explicit MillGame(const MillGame &);

    // 运算符重载
    MillGame &operator=(const MillGame &);

    // 设置配置
    bool configure(bool giveUpIfMostLose, bool randomMove);

    // 设置棋局状态和棋盘上下文，用于初始化
    bool setContext(const struct Rule *rule,
                 step_t maxStepsLedToDraw = 0,     // 限制步数
                 int maxTimeLedToLose = 0,      // 限制时间
                 step_t initialStep = 0,           // 默认起始步数为0
                 int flags = GAME_NOTSTARTED | PLAYER1 | ACTION_PLACE, // 默认状态
                 const char *board = nullptr,   // 默认空棋盘
                 int nPiecesInHand_1 = 12,      // 玩家1剩余未放置子数
                 int nPiecesInHand_2 = 12,      // 玩家2剩余未放置子数
                 int nPiecesNeedRemove = 0      // 尚待去除的子数
    );

    // 获取棋局状态和棋盘上下文
    void getContext(struct Rule &rule, step_t &step, int &flags, int *&board,
                    int &nPiecesInHand_1, int &nPiecesInHand_2, int &nPiecesNeedRemove);

    // 获取当前规则
    const struct Rule *getRule() const
    {
        return &currentRule;
    }

    // 获取棋盘数据
    const int *getBoard() const
    {
        return context.board.board_;
    }

    // 获取当前棋子位置点
    int getCurrentPos() const
    {
        return currentPos;
    }

    // 判断位置点是否为星位 (星位是经常会先占的位置)
    static bool isStarPoint(int pos)
    {
        return (pos == 17 || pos == 19 || pos == 21 || pos == 23);
    }

    // 获取当前步数
    int getStep() const
    {
        return currentStep;
    }

    // 获取从上次吃子开始经历的移动步数
    int getMoveStep() const
    {
        return moveStep;
    } 

    // 获取是否必败时认输
    bool getGiveUpIfMostLose() const
    {
        return giveUpIfMostLose_;
    }

    // 获取 AI 是否随机走子
    bool getRandomMove() const
    {
        return randomMove_;
    }

    // 获取局面阶段标识
    enum GameStage getStage() const
    {
        return context.stage;
    }

    // 获取轮流状态标识
    enum Player whosTurn() const
    {
        return context.turn;
    }

    // 获取动作状态标识
    enum Action getAction() const
    {
        return context.action;
    }

    // 判断胜负
    enum Player whoWin() const
    {
        return winner;
    }

    // 玩家1和玩家2的用时
    void getElapsedTime(time_t &p1_ms, time_t &p2_ms);

    // 获取棋局的字符提示
    const string getTips() const
    {
        return tips;
    }

    // 获取当前着法
    const char *getCmdLine() const
    {
        return cmdline;
    }

    // 获得棋谱
    const list<string> *getCmdList() const
    {
        return &cmdlist;
    }

    // 获取开局时间
    time_t getStartTimeb() const
    {
        return startTime;
    }

    // 重新设置开局时间
    void setStartTime(int stimeb)
    {
        startTime = stimeb;
    }

    // 玩家1剩余未放置子数
    int getPiecesInHandCount_1() const
    {
        return context.nPiecesInHand_1;
    }

    // 玩家2剩余未放置子数
    int getPiecesInHandCount_2() const
    {
        return context.nPiecesInHand_2;
    }

    // 玩家1盘面剩余子数
    int getPiecesOnBoardCount_1() const
    {
        return context.nPiecesOnBoard_1;
    }

    // 玩家1盘面剩余子数
    int getPiecesOnBoardCount_2() const
    {
        return context.nPiecesOnBoard_2;
    }

    // 尚待去除的子数
    int getNum_NeedRemove() const
    {
        return context.nPiecesNeedRemove;
    }

    // 计算玩家1和玩家2的棋子活动能力之差
    int getMobilityDiff(enum Player turn, const Rule &rule, int nPiecesOnBoard_1, int nPiecesOnBoard_2, bool includeFobidden);

    // 游戏重置
    bool reset();

    // 游戏开始
    bool start();

    // 选子，在第r圈第s个位置，为迎合日常，r和s下标都从1开始
    bool choose(int r, int s);

    // 落子，在第r圈第s个位置，为迎合日常，r和s下标都从1开始
    bool _place(int r, int s, int time_p = -1);

    // 去子，在第r圈第s个位置，为迎合日常，r和s下标都从1开始
    bool _capture(int r, int s, int time_p = -1);

    // 认输
    bool giveup(Player loser);

    // 命令行解析函数
    bool command(const char *cmd);

    // 更新时间和状态，用内联函数以提高效率
    inline int update(int time_p = -1);

    // 是否分出胜负
    bool win();
    bool win(bool forceDraw);

    // 清除所有禁点
    void cleanForbiddenPoints();

    // 改变轮流
    enum Player changeTurn();

    // 设置提示
    void setTips();

    // 下面几个函数没有算法无关判断和无关操作，节约算法时间
    bool command(int move);
    bool choose(int pos);
    bool place(int pos, int time_p = -1, int8_t cp = 0);
    bool capture(int pos, int time_p = -1, int8_t cp = 0);

#if ((defined TRANSPOSITION_TABLE_ENABLE) || (defined BOOK_LEARNING) || (defined THREEFOLD_REPETITION))
    // hash相关
    hash_t getHash();
    hash_t revertHash(int pos);
    hash_t updateHash(int pos);
    hash_t updateHashMisc();
#endif

public: /* TODO: move to private */
    // 棋局上下文
    GameContext context;

    // 当前使用的规则
    struct Rule currentRule
    {
    };

    // 棋局上下文中的棋盘数据，单独提出来
    int *board_;

    // 棋谱
    list <string> cmdlist;

    // 着法命令行用于棋谱的显示和解析, 当前着法的命令行指令，即一招棋谱
    char cmdline[64]{};

    /* 
        当前着法，AI会用到，如下表示
        0x   00    00
            pos1  pos2
        开局落子：0x00??，??为棋盘上的位置
        移子：0x__??，__为移动前的位置，??为移动后的位置
        去子：0xFF??，??取位置补码，即为负数

        31 ----- 24 ----- 25
        | \       |      / |
        |  23 -- 16 -- 17  |
        |  | \    |   / |  |
        |  |  15 08 09  |  |
        30-22-14    10-18-26
        |  |  13 12 11  |  |
        |  | /    |   \ |  |
        |  21 -- 20 -- 19  |
        | /       |     \  |
        29 ----- 28 ----- 27
    */
    int32_t move_{};

    // 选中的棋子在board中的位置
    int currentPos{};

private:
    // 棋局哈希值
    // uint64_t hash;

    // 胜负标识
    enum Player winner;

    // 当前步数
    step_t currentStep {};

    // 从走子阶段开始或上次吃子起的步数
    int moveStep {};

    // 是否必败时认输
    bool giveUpIfMostLose_ {true};

    // AI 是否随机走子
    bool randomMove_ {true};

    // 游戏起始时间
    time_t startTime {};

    // 当前游戏时间
    time_t currentTime {};

    // 玩家1用时（秒）
    time_t elapsedSeconds_1 {};

    // 玩家2用时（秒）
    time_t elapsedSeconds_2 {};

    // 当前棋局的字符提示
    string tips;
};

#endif /* MILLGAME_H */
