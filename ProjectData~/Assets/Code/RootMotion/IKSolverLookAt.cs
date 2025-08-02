using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RootMotion.FinalIK {
    [Serializable]
    public class IKSolverLookAt : IKSolver
    {
        [Serializable]
        public class LookAtBone: IKSolver.Bone {
            public Vector3 baseForwardOffsetEuler;
        }

        public Transform target; // 0x58
        public LookAtBone[] spine; // 0x60
        public LookAtBone head; // 0x68
        public LookAtBone[] eyes; // 0x70
        [RangeAttribute(0, 1)]
        public float bodyWeight; // 0x78
        [RangeAttribute(0, 1)]
        public float headWeight; // 0x7C
        [RangeAttribute(0, 1)]
        public float eyesWeight; // 0x80
        [RangeAttribute(0, 1)]
        public float clampWeight; // 0x84
        [RangeAttribute(0, 1)]
        public float clampWeightHead; // 0x88
        [RangeAttribute(0, 1)]
        public float clampWeightEyes; // 0x8C
        [RangeAttribute(0, 1)]
        public int clampSmoothing; // 0x90
        public AnimationCurve spineWeightCurve; // 0x98
        public Vector3 spineTargetOffset; // 0xA0
        protected Vector3[] spineForwards; // 0xB0
        protected Vector3[] headForwards; // 0xB8
        protected Vector3[] eyeForward; // 0xC0
        private bool isDirty; // 0xC8

        // Start is called before the first frame update
        void Start()
        {
            
        }
    
        // Update is called once per frame
        void Update()
        {
            
        }
    }
}