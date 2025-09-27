using UnityEngine;

namespace App
{
	public class HubCamera : MonoBehaviour
	{
		public AnimationCurve m_CameraTargetHeight; // 0x18
		public AnimationCurve m_OffsetCurveX; // 0x20
		public AnimationCurve m_DistanceCurve; // 0x28
		public AnimationCurve m_FovCurve; // 0x30
		public AnimationCurve m_TalkCurve; // 0x38
		public float m_NearClip; // 0x40
		public float m_RotateSpeed; // 0x44
		public float m_PitchSpeed; // 0x48
		public float m_RotateFollowSpeed; // 0x4C
		public float m_FollowRate; // 0x50
		public float m_PredictionLimitAngle; // 0x54
		public float m_SideOffsetIndex; // 0x58
		public static float m_DefaultAngleX; // 0x0
		private Camera m_Camera; // 0x60
		private bool IsStop; // 0x68
		public HubPlayerController PlayerController; // 0x70
		public float SideLength; // 0x78
		private InterpolatorFloat m_AngleX; // 0x80
		private InterpolatorVector3 m_TargetPosition; // 0x88
		private InterpolatorVector3 m_Position; // 0x90
		private InterpolatorRotation m_AngleY; // 0x98
		private InterpolatorFloat m_Distance; // 0xA0
		private InterpolatorFloat m_Fov; // 0xA8
		private InterpolatorFloat m_DistanceRatio; // 0xB0
		private InterpolatorFloat m_HeightRatio; // 0xB8
		private InterpolatorFloat m_TalkTail; // 0xC0
		private InterpolatorFloat m_SideOffset; // 0xC8
		private InterpolatorFloat m_PredictionPitch; // 0xD0
		private readonly string CameraRoateteParamName; // 0xD8
		private int ObjectCollisionLayerMask; // 0xE0
		private int HeightLayerMask; // 0xE4
		private RaycastHit[] hresults; // 0xE8
		private RaycastHit[] rayhits; // 0xF0
		private Vector3 m_position; // 0xF8
		private float m_angleX; // 0x104
		private float m_angleY; // 0x108
		private float m_distance; // 0x10C
		private float m_zoom; // 0x110
		private float m_fov; // 0x114
		private float TalkCameraMoveTime; // 0x118
		private float TalkCameraReturnTime; // 0x11C
		private float NormalTalkDistanceRatio; // 0x120
		private float NormalTalkAngleX; // 0x124
		private float NormalTalkAngleY; // 0x128
		private float NormalTalkZoom; // 0x12C
		private float NormalTalkSeparateDistance; // 0x130
		private float NormalTalkOffsetY; // 0x134
		private float ShopTalkDistanceRatio; // 0x138
		private float ShopTalkAngleX; // 0x13C
		private float ShopTalkAngleY; // 0x140
		private float ShopTalkZoom; // 0x144
		private float ShopTalkSeparateDistance; // 0x148
		private float ShopTalkOffsetY; // 0x14C
	}
}