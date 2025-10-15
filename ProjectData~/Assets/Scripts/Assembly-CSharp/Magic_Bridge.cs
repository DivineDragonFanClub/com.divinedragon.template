
using UnityEngine;
using Combat;
using App;

public class Magic_Bridge : MonoBehaviour
{
    public MagicBulletSettings BulletSettings; // 0x38
    private MagicSignalProcessor m_SignalProcessor; // 0x40
    public MagicSignalTrack Track開始時処理; // 0x60
    public MagicSignalTrack Track魔法動作1処理; // 0x68
    public MagicSignalTrack Track魔法動作2処理; // 0x70
    public MagicSignalTrack Track魔法動作3処理; // 0x78
    public MagicSignalTrack Trackヒット時処理; // 0x80
    public MagicSignalTrack Trackミス時処理; // 0x88
    public MagicSignalTrack Trackガード時処理; // 0x90
    public MagicSignalTrack Trackパリィ時処理; // 0x98
    public MagicSignalTrack Track衝突時処理; // 0xA0
    public MagicSignalTrack Track自然消滅処理; // 0xA8
    public MagicSignalTrack Track打撃命中処理; // 0xB0
    private Transform _homeNode; // 0xB8
    private Transform _targetNode; // 0xC0
    public Vector3 InitialStartPos { get; set; }
    public Vector3 InitialEndPos { get; set; }
    public Transform HomeNode { get; }
    public Transform TargetNode { get; }
   public Vector3 TargetPosition { get; }
}