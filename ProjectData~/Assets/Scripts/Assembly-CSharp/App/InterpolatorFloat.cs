using UnityEngine;

namespace App
{
	public class InterpolatorFloat
	{
		public enum CurveType // TypeDefIndex: 9182
		{
			Linear = 0,
			Accel = 1,
			Decel = 2,
			AccelDecel = 3,
			DecelAccel = 4,
			LinearDecel = 5,
			LinearAccel = 6,
			DecelLinear = 7,
			AccelLinear = 8
		}

		protected float m_Time; // 0x10
		protected float m_Tick; // 0x14
		protected CurveType m_Type; // 0x18
		protected int m_Num; // 0x1C
		protected bool m_IsFirst; // 0x20
		protected bool m_IsDirty; // 0x21

		protected float m_Prev; // 0x0
		protected float m_Next; // 0x0
	}
}