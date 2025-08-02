using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace App {
    public abstract class EventCharacterMouthController : MonoBehaviour
    {
        private string[] LayerNameArray; // 0x18
        private Animator m_animator; // 0x20
        private int[] m_animLayerIndexArray; // 0x28
        private WeightFader[] m_weight; // 0x30
        private string m_voiceEventName; // 0x38
        [SerializeField] // RVA: 0x17B410 Offset: 0x17B511 VA: 0x17B410
        private AnimationCurve m_weight_a; // 0x40
        [SerializeField] // RVA: 0x17B420 Offset: 0x17B521 VA: 0x17B420
        private AnimationCurve m_weight_i; // 0x48
        [SerializeField] // RVA: 0x17B430 Offset: 0x17B531 VA: 0x17B430
        private AnimationCurve m_weight_u; // 0x50
        [SerializeField] // RVA: 0x17B440 Offset: 0x17B541 VA: 0x17B440
        private AnimationCurve m_weight_e; // 0x58
        [SerializeField] // RVA: 0x17B450 Offset: 0x17B551 VA: 0x17B450
        private AnimationCurve m_weight_o; // 0x60
        [SerializeField] // RVA: 0x17B460 Offset: 0x17B561 VA: 0x17B460
        private AnimationCurve m_weightScale_vol; // 0x68
        [SerializeField] // RVA: 0x17B470 Offset: 0x17B571 VA: 0x17B470
        private AnimationCurve m_weightOffset_vol; // 0x70

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