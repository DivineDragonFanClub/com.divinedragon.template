using System;
using UnityEngine;
using System.Collections.Generic;
using App;

namespace App
{
    public abstract class MapFadeManager : SingletonMonoBehaviour<MapFadeManager>
    {
        public List<CharacterCollision> m_Transparents; // 0x20
        public List<CharacterCollision> m_Destructions; // 0x28
        public List<MapCollision> m_Transparented; // 0x30
        public List<MapCollision> m_TempCollisions; // 0x38
        public Dictionary<MapCollision, float> m_AlphaCollisions; // 0x40
        public List<MapObject> m_FadeObjects; // 0x48
        public Collider[] m_Colliders; // 0x50
        public int m_LayerDestructionMask; // 0x58
        public int m_LayerTransparentMask; // 0x5C
        public Vector3 m_CameraPosition; // 0x60
        public Quaternion m_CameraRotation; // 0x6C
        public float m_FadeSpeed; // 0x7C
    }
}