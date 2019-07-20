#ifndef CONFIG_H
#define CONFIG_H

//#define DEBUG_MODE

#define RANDOM_MOVE

//#define DEAL_WITH_HORIZON_EFFECT

#define IDS_SUPPORT

#define HASH_MAP_ENABLE

//#define BOOK_LEARNING

//#define DONOT_DELETE_TREE

#define MOVE_PRIORITY_TABLE_SUPPORT

#ifdef DEBUG_MODE
#define DONOT_PLAY_SOUND
#define DEBUG_AB_TREE
#endif

//#define DONOT_PLAY_SOUND

#ifdef DEBUG_MODE
#define GAME_PLACING_FIXED_DEPTH  3
#endif

#ifdef DEBUG_MODE
#define GAME_MOVING_FIXED_DEPTH  3
#else // DEBUG
#ifdef DEAL_WITH_HORIZON_EFFECT
#ifdef HASH_MAP_ENABLE
#define GAME_MOVING_FIXED_DEPTH 9
#else
#define GAME_MOVING_FIXED_DEPTH 9
#endif // HASH_MAP_ENABLE
#else // DEAL_WITH_HORIZON_EFFECT
#ifdef HASH_MAP_ENABLE
#define GAME_MOVING_FIXED_DEPTH  11
#else
#define GAME_MOVING_FIXED_DEPTH  10
#endif
#endif // DEAL_WITH_HORIZON_EFFECT
#endif // DEBUG

#ifndef DEBUG_MODE
#define GAME_PLACING_DYNAMIC_DEPTH
#endif

#ifdef DEBUG_MODE
#define DRAW_SEAT_NUMBER
#endif

#define SAVE_CHESSBOOK_WHEN_ACTION_NEW_TRIGGERED

// #define DONOT_PLAY_WIN_SOUND

// 摆棋阶段在叉下面显示被吃的子
//#define GAME_PLACING_SHOW_CAPTURED_PIECES

// 启动时窗口最大化
//#define SHOW_MAXIMIZED_ON_LOAD

// 不使用哈希桶
#define DISABLE_HASHBUCKET

#endif // CONFIG_H