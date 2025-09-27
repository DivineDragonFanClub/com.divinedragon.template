using System;
using UnityEngine;

public class LightProbeGenerator : MonoBehaviour
{
    [Serializable]
    public class LightProbeArea // TypeDefIndex: 7797
    {
        // Fields
        public Bounds ProbeVolume; // 0x10
        public Vector3 Subdivisions; // 0x28
        public int RandomCount; // 0x34
    }
    
    // Namespace: 
    public enum LightProbePlacementType // TypeDefIndex: 7798
    {
        Grid = 0,
        Random = 1
    }

    public LightProbeArea[] LightProbeVolumes; // 0x18
    public LightProbePlacementType PlacementAlgorithm; // 0x20
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
