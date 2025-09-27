using System;
using UnityEngine;

namespace Combat
{
    [Serializable]
    public class ProportionParameters
    {
        [RangeAttribute(0.1f, 2.0f)] public float ScaleAll = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float ScaleHead = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float ScaleNeck = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float ScaleTorso = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float ScaleShoulders = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float ScaleArms = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float ScaleHands = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float ScaleLegs = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float ScaleFeet = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float VolumeArms = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float VolumeLegs = 1.0f;

        [RangeAttribute(0.1f, 3.0f)] public float VolumeBust = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float VolumeAbdomen = 1.0f;

        [RangeAttribute(0.1f, 2.0f)] public float VolumeTorso = 1.0f;

        public float HipJointHeight = 0.1098901f;

        public string Conditions = "";

        public string Comment = "";

        // Unused
        // public float AnkleHeight;
        public override string ToString()
        {
            return JsonUtility.ToJson(this);
        }
    }
}