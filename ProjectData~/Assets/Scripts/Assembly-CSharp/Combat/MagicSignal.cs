using System;
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
        なし = 0,
        エフェ生成 = 1,
        エフェ削除 = 2,
        魔弾発射 = 3,
        魔弾衝突 = 4,
        魔弾停止 = 5,
        目標変更 = 6,
        サウンド = 7,
        カット切替 = 8,
        カメラ = 9,
        カメラ戻す = 10,
        ラジブラー = 11,
        背景暗さ = 12,
        ノード移動 = 13,
        新エフェ生成 = 14,
    }

    public enum ParticleConnect // TypeDefIndex: 8783
    {
        未設定 = 0,
        に接続 = 1,
        の姿勢 = 2,
        の位置 = 3,
        の地面 = 4,
        チキ爪 = 5,
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