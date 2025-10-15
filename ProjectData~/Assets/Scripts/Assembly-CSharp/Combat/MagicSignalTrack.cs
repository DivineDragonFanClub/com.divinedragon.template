using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Combat
{
    [Serializable]
    public class MagicSignalTrack
    {
        private string m_Title; // 0x10
        private string m_Help; // 0x18
        private bool m_IsSubBullet; // 0x20
        public List<MagicSignal> Signals; // 0x28

        // Properties
        public float EndTime { get; set; }
    }
}