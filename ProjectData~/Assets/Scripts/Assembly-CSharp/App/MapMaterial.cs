using UnityEngine;
using System.Collections.Generic;
using System.Reflection;

namespace App
{
    public class MapMaterial
    {
        public enum Kinds // TypeDefIndex: 12216
        {
            None = 0,
            Float = 1,
            Color = 2
        }

        public class Node // TypeDefIndex: 12217
        {
            // Fields
            public Kinds kind; // 0x10
            public string material; // 0x18
            public string property; // 0x20
            public float value; // 0x28
            public Color color; // 0x2C
        }

        private List<Node> m_List; // 0x10
    }
}
