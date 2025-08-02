using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RootMotion.FinalIK {
    public abstract class RotationLimitSpline : RotationLimit
    {
        [RangeAttribute(0, 1)] // RVA: 0x191700 Offset: 0x191801 VA: 0x191700
        public float twistLimit; // 0x38
        [SerializeField] // RVA: 0x191720 Offset: 0x191821 VA: 0x191720
        [HideInInspector] // RVA: 0x191720 Offset: 0x191821 VA: 0x191720
        public AnimationCurve spline; // 0x40

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