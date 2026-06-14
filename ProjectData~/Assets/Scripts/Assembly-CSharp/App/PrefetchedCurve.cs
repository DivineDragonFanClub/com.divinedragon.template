using System;
using UnityEngine;

public class PrefetchedCurve: ScriptableObject
{
    [SerializeField] // RVA: 0x172470 Offset: 0x172571 VA: 0x172470
    public TrailTrack RightHand; // 0x18
    [SerializeField] // RVA: 0x172480 Offset: 0x172581 VA: 0x172480
    public TrailTrack LeftHand; // 0x20
}

[Serializable] 
public class TrailTrack
{
    public AnimationCurve RootX; // 0x10
    public AnimationCurve RootY; // 0x18
    public AnimationCurve RootZ; // 0x20
    public AnimationCurve TipX; // 0x28
    public AnimationCurve TipY; // 0x30
    public AnimationCurve TipZ; // 0x38
}
