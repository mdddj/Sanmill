/*
  Sanmill, a mill game playing engine derived from NineChess 1.5
  Copyright (C) 2015-2018 liuweilhy (NineChess author)
  Copyright (C) 2019-2020 Calcitem <calcitem@outlook.com>

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

#include "movepick.h"
#include "option.h"
#include "types.h"
#include "config.h"

// partial_insertion_sort() sorts moves in descending order up to and including
// a given limit. The order of moves smaller than the limit is left unspecified.
void partial_insertion_sort(ExtMove *begin, ExtMove *end, int limit)
{
    for (ExtMove *sortedEnd = begin, *p = begin + 1; p < end; ++p)
        if (p->value >= limit) {
            ExtMove tmp = *p, *q;
            *p = *++sortedEnd;
            for (q = sortedEnd; q != begin && *(q - 1) < tmp; --q)
                *q = *(q - 1);
            *q = tmp;
        }
}

MovePicker::MovePicker(Position *pos, ExtMove *extMove)
{
    position = pos;
    cur = extMove;

#ifdef HOSTORY_HEURISTIC
    clearHistoryScore();
#endif
}

void MovePicker::score()
{
    while (cur++->move != MOVE_NONE) {
        Move m = cur->move;

        Square sq = to_sq(m);
        Square sqsrc = from_sq(m);
        
        // if stat before moving, moving phrase maybe from @-0-@ to 0-@-@, but no mill, so need sqsrc to judge
        int nOurMills = position->board.inHowManyMills(sq, position->sideToMove, sqsrc);
        int nTheirMills = 0;

    #ifdef SORT_MOVE_WITH_HUMAN_KNOWLEDGES
        // TODO: rule.allowRemoveMultiPiecesWhenCloseMultiMill adapt other rules
        if (type_of(m) != MOVETYPE_REMOVE) {
            // all phrase, check if place sq can close mill
            if (nOurMills > 0) {
    #ifdef ALPHABETA_AI
                cur->rating += static_cast<Rating>(RATING_ONE_MILL * nOurMills);
    #endif
            } else if (position->getPhase() == PHASE_PLACING) {
                // placing phrase, check if place sq can block their close mill
                nTheirMills = position->board.inHowManyMills(sq, position->them);
    #ifdef ALPHABETA_AI
                cur->rating += static_cast<Rating>(RATING_BLOCK_ONE_MILL * nTheirMills);
    #endif
            }
    #if 1
            else if (position->getPhase() == PHASE_MOVING) {
                // moving phrase, check if place sq can block their close mill
                nTheirMills = position->board.inHowManyMills(sq, position->them);

                if (nTheirMills) {
                    int nOurPieces = 0;
                    int nTheirPieces = 0;
                    int nBanned = 0;
                    int nEmpty = 0;

                    position->board.getSurroundedPieceCount(sq, position->sideToMove,
                                                            nOurPieces, nTheirPieces, nBanned, nEmpty);

    #ifdef ALPHABETA_AI
                    if (sq % 2 == 0 && nTheirPieces == 3) {
                        cur->rating += static_cast<Rating>(RATING_BLOCK_ONE_MILL * nTheirMills);
                    } else if (sq % 2 == 1 && nTheirPieces == 2 && rule.nTotalPiecesEachSide == 12) {
                        cur->rating += static_cast<Rating>(RATING_BLOCK_ONE_MILL * nTheirMills);
                    }
    #endif
                }
            }
    #endif

            //newNode->rating += static_cast<Rating>(nBanned);  // placing phrase, place nearby ban point

            // for 12 men, white 's 2nd move place star point is as important as close mill (TODO)
    #ifdef ALPHABETA_AI
            if (rule.nTotalPiecesEachSide == 12 &&
                position->getPiecesOnBoardCount(WHITE) < 2 &&    // patch: only when white's 2nd move
                Board::isStar(static_cast<Square>(m))) {
                cur->rating += RATING_STAR_SQUARE;
            }
    #endif
        } else { // Remove
            int nOurPieces = 0;
            int nTheirPieces = 0;
            int nBanned = 0;
            int nEmpty = 0;

            position->board.getSurroundedPieceCount(sq, position->sideToMove,
                                                    nOurPieces, nTheirPieces, nBanned, nEmpty);

    #ifdef ALPHABETA_AI
            if (nOurMills > 0) {
                // remove point is in our mill
                //newNode->rating += static_cast<Rating>(RATING_REMOVE_ONE_MILL * nOurMills);

                if (nTheirPieces == 0) {
                    // if remove point nearby has no their stone, preferred.
                    cur->rating += static_cast<Rating>(1);
                    if (nOurPieces > 0) {
                        // if remove point nearby our stone, preferred
                        cur->rating += static_cast<Rating>(nOurPieces);
                    }
                }
            }

            // remove point is in their mill
            nTheirMills = position->board.inHowManyMills(sq, position->them);
            if (nTheirMills) {
                if (nTheirPieces >= 2) {
                    // if nearby their piece, prefer do not remove
                    cur->rating -= static_cast<Rating>(nTheirPieces);

                    if (nOurPieces == 0) {
                        // if nearby has no our piece, more prefer do not remove
                        cur->rating -= static_cast<Rating>(1);
                    }
                }
            }

            // prefer remove piece that mobility is strong 
            cur->rating += static_cast<Rating>(nEmpty);
    #endif
        }
    #endif // SORT_MOVE_WITH_HUMAN_KNOWLEDGES
        }
}

#ifdef HOSTORY_HEURISTIC
Score MovePicker::getHistoryScore(Move move)
{
    Score ret = 0;

    if (move < 0) {
#ifndef HOSTORY_HEURISTIC_ACTION_MOVE_ONLY
        ret = placeHistory[-move];
#endif
    } else if (move & 0x7f00) {
        ret = moveHistory[move];
    } else {
#ifndef HOSTORY_HEURISTIC_ACTION_MOVE_ONLY
        ret = placeHistory[move];
#endif
    }

    return ret;
}

void MovePicker::setHistoryScore(Move move, Depth depth)
{
    if (move == MOVE_NONE) {
        return;
    }

#ifdef HOSTORY_HEURISTIC_SCORE_HIGH_WHEN_DEEPER
    Score score = 1 << (32 - depth);
#else
    Score score = 1 << depth;
#endif

    if (move < 0) {
#ifndef HOSTORY_HEURISTIC_ACTION_MOVE_ONLY
        placeHistory[-move] += score;
#endif
    } else if (move & 0x7f00) {
        moveHistory[move] += score;
    } else {
#ifndef HOSTORY_HEURISTIC_ACTION_MOVE_ONLY
        moveHistory[move] += score;
#endif
    }
}

void MovePicker::clearHistoryScore()
{
#ifndef HOSTORY_HEURISTIC_ACTION_MOVE_ONLY
    memset(placeHistory, 0, sizeof(placeHistory));
    memset(removeHistory, 0, sizeof(removeHistory));
#endif
    memset(moveHistory, 0, sizeof(moveHistory));
}
#endif // HOSTORY_HEURISTIC
