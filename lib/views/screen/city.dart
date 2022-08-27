import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';

import '../../gloabal.dart';
import '../../model/flag.dart';
import '../widget/joystick_controller.dart';
import '../widget/map_chip.dart';
import '../widget/player_sprite.dart';

class CityScreen extends FlameGame
    with DoubleTapDetector, HasTappables, HasDraggables, HasCollisionDetection {
  // プレイヤー
  PlayerSprite? playerSprite;
  // コントローラー
  MyJoystickController? myJoystickController;
  // マップ
  MapChip? mapChip;
  // フラグ
  FlagModel flag;

  CityScreen(this.flag);

  @override
  Future<void>? onLoad() async {
    // マップ
    mapChip = MapChip("city.tmx", mySpriteSize, flag);
    await add(mapChip!); // 非同期処理にしないとエラー

    // プレイヤー初期化
    playerSprite = PlayerSprite("character/sample011.png", mySpriteSize);
    add(playerSprite!);

    // playerSprite!.SetPos(mapChip!.respawnPoint!.point!);

    // カメラの追尾対象を設定
    // camera.followComponent(playerSprite!);

    // コントーローラー
    myJoystickController = MyJoystickController(
        knobRadius: 30.0,
        knobPaint: BasicPalette.white.withAlpha(200).paint(),
        backgroundRadius: 100.0,
        backgroundPaint: BasicPalette.white.withAlpha(100).paint(),
        margin: const EdgeInsets.only(left: 40.0, bottom: 40.0));
    await add(myJoystickController!);

    await super.onLoad();
  }

  @override
  void update(double dt) async {
    super.update(dt);
    // リスポーン
    if (flag.testFlag) {
      playerSprite!.SetPos(mapChip!.respawnPoint!.point!);
      flag.testFlag = false;
    }
    playerSprite!.SetMove((myJoystickController!.GetValue() * 10.0));
  }
}