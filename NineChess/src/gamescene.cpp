﻿#include "gamescene.h"
#include "pieceitem.h"
#include "boarditem.h"
#include "graphicsconst.h"
#include <QGraphicsItem>
#include <QGraphicsScene>
#include <QGraphicsSceneMouseEvent>
#include <QKeyEvent>
#include <QDebug>

GameScene::GameScene(QObject *parent) : QGraphicsScene(parent),
	board(NULL),
	pos_p1(LINE_INTERVAL * 4, LINE_INTERVAL * 6),
	pos_p1_g(LINE_INTERVAL* (-4), LINE_INTERVAL * 6),
	pos_p2(LINE_INTERVAL * (-4), LINE_INTERVAL * (-6)),
	pos_p2_g(LINE_INTERVAL * 4, LINE_INTERVAL * (-6))
{
    // 添加棋盘
    board = new BoardItem;
    board->setDiagonal(false);
    addItem(board);
}

GameScene::~GameScene()
{
    if(board)
        delete board;
}

void GameScene::keyPressEvent(QKeyEvent *keyEvent)
{
    // 屏蔽掉Shift和Control按键，事实证明没用，按键事件未必由试图类处理
    if(keyEvent->key() == Qt::Key_Shift || keyEvent->key() == Qt::Key_Control)
        return;
    QGraphicsScene::keyPressEvent(keyEvent);
}

void GameScene::mouseDoubleClickEvent(QGraphicsSceneMouseEvent *mouseEvent)
{
    //什么也不做，屏蔽双击事件
}

void GameScene::mousePressEvent(QGraphicsSceneMouseEvent *mouseEvent)
{
    // 只处理左键事件
    if(mouseEvent->button() != Qt::LeftButton)
        return;
    // 调用默认事件处理函数
    QGraphicsScene::mousePressEvent(mouseEvent);

    // 如果不是棋子则结束
    QGraphicsItem *item = itemAt(mouseEvent->scenePos(), QTransform());
    if (!item || item->type() != PieceItem::Type)
    {
        return;
    }

    // 取消其它棋子的选中状态
    //for (QGraphicsItem * item: selectedItems())
    //{
    //    item->setSelected(false);
    //}
}

void GameScene::mouseReleaseEvent(QGraphicsSceneMouseEvent *mouseEvent)
{
    // 只处理左键事件
    if(mouseEvent->button() != Qt::LeftButton)
        return;
    // 调用默认事件处理函数
    QGraphicsScene::mouseReleaseEvent(mouseEvent);

    // 如果是棋盘
    QGraphicsItem *item = itemAt(mouseEvent->scenePos(), QTransform());
    if (!item || item->type() == BoardItem::Type)
    {
        QPointF p = mouseEvent->scenePos();
        p = board->nearestPosition(p);
        if (p != QPointF(0, 0))
            // 发送鼠标点最近的落子点
            emit mouseReleased(p);
    }// 如果是棋子
    else if (item->type() == PieceItem::Type)
    {
        // 将当前棋子在场景中的位置发送出去
        emit mouseReleased(item->scenePos());
    }
}

QPointF GameScene::cp2pos(int c, int p)
{
    return board->cp2pos(c, p);
}

bool GameScene::pos2cp(QPointF pos, int &c, int &p)
{
    return board->pos2cp(pos, c, p);
}

void GameScene::setDiagonal(bool arg /*= true*/)
{
    if (board)
        board->setDiagonal(arg);
}
