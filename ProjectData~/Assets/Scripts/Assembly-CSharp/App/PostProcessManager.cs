using UnityEngine;
using UnityEngine.Rendering;

namespace App
{
	[ExecuteInEditMode] 
	public abstract class PostProcessManager : SingletonMonoBehaviour<PostProcessManager>
	{
		private Volume m_Root; // 0x20
		private Volume m_Bmap; // 0x28
		private Volume m_Combat; // 0x30
		public float BmapCombatChangeTime; // 0x38
		public AnimationCurve CurveInterpolate; // 0x40
		public AnimationCurve CurveBlur; // 0x48
	}
}