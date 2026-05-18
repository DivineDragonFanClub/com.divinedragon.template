﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Combat
{
    public enum MagicLevels // TypeDefIndex: 8784
    {
        _ = 0,
        _1 = 1,
        _2 = 2,
        _12 = 3,
        _3 = 4,
        _13 = 5,
        _23 = 6,
        _123 = 7,
    }

    public enum MagicCommand // TypeDefIndex: 8782
    {
        [InspectorName("None")]
        なし = 0,
        [InspectorName("Create Effect")]
        エフェ生成 = 1,
        [InspectorName("Delete Effect")]
        エフェ削除 = 2,
        [InspectorName("Fire Magic Bullet")]
        魔弾発射 = 3,
        [InspectorName("Magic Bullet Impact")]
        魔弾衝突 = 4,
        [InspectorName("Stop Magic Bullet")]
        魔弾停止 = 5,
        [InspectorName("Change Target")]
        目標変更 = 6,
        [InspectorName("Sound")]
        サウンド = 7,
        [InspectorName("Switch Cut")]
        カット切替 = 8,
        [InspectorName("Camera")]
        カメラ = 9,
        [InspectorName("Restore Camera")]
        カメラ戻す = 10,
        [InspectorName("Radial Blur")]
        ラジブラー = 11,
        [InspectorName("Background Darkness")]
        背景暗さ = 12,
        [InspectorName("Move Node")]
        ノード移動 = 13,
        [InspectorName("Create New Effect")]
        新エフェ生成 = 14,
    }

    public enum ParticleConnect // TypeDefIndex: 8783
    {
        [InspectorName("Unset")]
        未設定 = 0,
        [InspectorName("Connect To")]
        に接続 = 1,
        [InspectorName("Match Orientation")]
        の姿勢 = 2,
        [InspectorName("Match Position")]
        の位置 = 3,
        [InspectorName("Match Ground")]
        の地面 = 4,
        [InspectorName("Tiki Claws")]
        チキ爪 = 5,
        [InspectorName("Match Ground Horizontal")]
        の地面水平 = 6,
    }

    [Serializable]
    public class MagicSignal
    {
        public MagicLevels level; // 0x10
        public float frame; // 0x14
        public MagicCommand command; // 0x18
        public GameObject prefab; // 0x20
        public string parentName; // 0x28
        public ParticleConnect connect; // 0x30
        public int intParameter; // 0x34
        public float floatParameter; // 0x38
        public string stringParameter; // 0x40
    }
}