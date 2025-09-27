using UnityEngine;

namespace App
{
	public class HubParams : MonoBehaviour
	{
		public int m_DisplayUnitNum;
		public float m_PadThreshold; // 0x1C
		public float m_MaxSpeed; // 0x20
		public float m_Accel; // 0x24
		public float m_Decel; // 0x28
		public float m_RotateSpeedRate; // 0x2C
		public float m_DashStopTime; // 0x30
		public AnimationCurve m_SpeedCurve; // 0x38
		public float m_DashSpeedIntensity; // 0x40
		public float m_GravityY; // 0x44
		public AnimationCurve m_TurnCurve; // 0x48
		public float m_MinLookAtDist; // 0x50
		public float m_MaxLookAtDist; // 0x54
		public float m_PlayerBodyWeight; // 0x58
		public float m_PlayerHeadWeight; // 0x5C
		public float m_OthersBodyWeight; // 0x60
		public float m_OthersHeadWeight; // 0x64
		public float m_Allowance; // 0x68
	}
}