using System.Collections.Generic;
using UnityEngine;


namespace App
{
	[ExecuteInEditMode] 
	public abstract class PostProcessManager : SingletonMonoBehaviour<PostProcessManager>
	{
        // This class is originally from UnityEngine.Rendering,  but it blocks the template from opening properly when depended on.
        // If PostProcessManager does not work as expected, this is the first thing to investigate.
        public class Volume : MonoBehaviour
        {
            public bool isGlobal = true;

            public float priority;

            public float blendDistance;

            [Range(0f, 1f)]
            public float weight = 1f;
        }

        private Volume m_Root; // 0x20
		private Volume m_Bmap; // 0x28
		private Volume m_Combat; // 0x30
		public float BmapCombatChangeTime; // 0x38
		public AnimationCurve CurveInterpolate; // 0x40
		public AnimationCurve CurveBlur; // 0x48
	}
}