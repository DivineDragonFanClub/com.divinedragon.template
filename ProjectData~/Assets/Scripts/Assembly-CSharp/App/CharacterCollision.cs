using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace App {
    public abstract class CharacterCollision : MonoBehaviour
    {
        public enum Kinds // TypeDefIndex: 14031
        {
            無し = 0,
            透過 = 1,
            破壊 = 2,
        }

        public Kinds m_Kinds; // 0x18
        public Color m_Color; // 0x1C
        private float m_Radius; // 0x2C
        private float m_Result; // 0x30
    }
}