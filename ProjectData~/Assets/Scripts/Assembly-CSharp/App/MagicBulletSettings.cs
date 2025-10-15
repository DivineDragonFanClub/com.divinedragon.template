using App;
using System;

namespace Combat {
    public enum MagicArrivalType
    {
        Flying = 0,
        ConstantTime = 1,
    }
    
    [Serializable]
    public sealed class MagicBulletSettings
    {
        public string HomeNodeName; // 0x10
        public string TargetNodeName; // 0x18
        public float DecayFrame; // 0x20
        public MagicArrivalType ArrivalType; // 0x24
        public float MoveSpeed; // 0x28
        public Curve.Type EaseType; // 0x2C
        public int EasePower; // 0x30
        public float ConstantArrivalFrame; // 0x34
    }
}