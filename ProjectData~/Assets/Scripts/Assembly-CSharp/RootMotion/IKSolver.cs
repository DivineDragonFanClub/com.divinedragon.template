using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RootMotion.FinalIK {
    [Serializable]
    public abstract class IKSolver
    {
        public delegate void UpdateDelegate();

        [Serializable]
        public class Point {
            public Transform transform; // 0x10
            [RangeAttribute(0, 1)]
            public float weight; // 0x18
            public Vector3 solverPosition; // 0x1C
            public Quaternion solverRotation; // 0x28
            public Vector3 defaultLocalPosition; // 0x38
            public Quaternion defaultLocalRotation; // 0x44
        }
    
        [Serializable]
        public class Bone : Point {
            public float length; // 0x54
            public float sqrMag; // 0x58
            public Vector3 axis; // 0x5C
            private RotationLimit _rotationLimit; // 0x68
            private bool isLimited; // 0x70
        }

        [HideInInspector] // RVA: 0x18E470 Offset: 0x18E571 VA: 0x18E470
        public bool executedInEditor; // 0x10
        [HideInInspector] // RVA: 0x18E480 Offset: 0x18E581 VA: 0x18E480
        public Vector3 IKPosition; // 0x14
        [RangeAttribute(0, 1)] // RVA: 0x18E490 Offset: 0x18E591 VA: 0x18E490
        public float IKPositionWeight; // 0x20
        private bool initiated; // 0x24
        public UpdateDelegate OnPreInitiate; // 0x28
        public UpdateDelegate OnPostInitiate; // 0x30
        public UpdateDelegate OnPreUpdate; // 0x38
        public UpdateDelegate OnPostUpdate; // 0x40
        protected bool firstInitiation; // 0x48
        [SerializeField] // RVA: 0x18E500 Offset: 0x18E601 VA: 0x18E500
        [HideInInspector] // RVA: 0x18E500 Offset: 0x18E601 VA: 0x18E500
        protected Transform root; // 0x50
    }
}