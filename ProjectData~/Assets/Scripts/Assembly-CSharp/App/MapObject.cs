using System;
using System.Collections.Generic;

using UnityEngine;
using UnityEngine.Serialization;

namespace App
{
	[ExecuteAlways]
	[DisallowMultipleComponent] 
	public abstract class MapObject : MonoBehaviour
	{
		public enum Kinds // TypeDefIndex: 9032
		{
			None = 0,
			Roof = 1,
			Door = 2,
			Chest = 3,
			Village = 4,
			Background = 5,
			Moveable = 6,
			Bridge = 7,
			Fortress = 8,
			Torch = 9,
			Destruction = 10,
			Ground = 11,
			Return = 12,
		}

		public enum Lods // TypeDefIndex: 9034
		{
			Unavoidable = 0,
			Alternating = 1,
			切替遅 = 2,
			Unavoidable_Cull = 3,
		}

		public enum Actions // TypeDefIndex: 9033
		{
			None = 0,
			Idle = 1,
			Done = 2,
		}

		public enum BakeTypes // TypeDefIndex: 9036
		{
			Normal = 0,
			BakeBeforeChange = 1,
			BakeAfterChange = 2,
			ForceBakeBeforeChange = 3,
			ForceBakeAfterChange = 4,
		}

		public enum LightmapScales // TypeDefIndex: 9035
		{
			Normal = 0,
			None = 1,
			Backgroundx0125 = 2,
			Contractionx05 = 3,
			Expansionx2 = 4,
			Maximumx4 = 5,
		}

		[Serializable]
		public class Pair // TypeDefIndex: 9037
		{
			// Fields
			public GameObject src; // 0x10
			public GameObject dst; // 0x18
		}

		[Serializable]
		public class State // TypeDefIndex: 9038
		{
			// Fields
			public GameObject[] 対象オブジェクト; // 0x10
			public GameObject エフェクト; // 0x18
		}

		private class RigidInfo // TypeDefIndex: 9039
		{
			// Fields
			public Transform transform; // 0x10
			public Vector3 position; // 0x18
			public Vector3 scale; // 0x24
			public Quaternion rotation; // 0x30
			public Rigidbody rigidbody; // 0x40
		}

		private class RigidList : List<RigidInfo> // TypeDefIndex: 9040
		{

		}

		private class DitherPair // TypeDefIndex: 9041
		{
			// Fields
			private Renderer m_Render; // 0x10
			private Material[] m_Shareds; // 0x18
			private Material[] m_Dithers; // 0x20
			private DitherManager m_Manager; // 0x28
			private float m_Alpha; // 0x30
		}

		private class DitherManager // TypeDefIndex: 9042
		{
			// Fields
			private List<DitherPair> m_Pairs; // 0x10
			private Dictionary<Renderer, DitherPair> m_Renderers; // 0x18
			private float m_Alpha; // 0x20
		}

		public Kinds m_Kind; // 0x18
		[HideInInspector] // RVA: 0x173DF0 Offset: 0x173EF1 VA: 0x173DF0
		public Lods m_Lods; // 0x1C
		[HideInInspector] // RVA: 0x173E00 Offset: 0x173F01 VA: 0x173E00
		public bool m_LodManual; // 0x20
		[HideInInspector] // RVA: 0x173E10 Offset: 0x173F11 VA: 0x173E10
		public bool m_LodAssign; // 0x21
		[HideInInspector] // RVA: 0x173E20 Offset: 0x173F21 VA: 0x173E20
		public bool m_DisableBake; // 0x22
		[HideInInspector] // RVA: 0x173E30 Offset: 0x173F31 VA: 0x173E30
		public bool m_DisableOccluder; // 0x23
		[HideInInspector] // RVA: 0x173E40 Offset: 0x173F41 VA: 0x173E40
		public BakeTypes m_BakeTypes; // 0x24
		[SpaceAttribute] // RVA: 0x173E50 Offset: 0x173F51 VA: 0x173E50
		[FormerlySerializedAs("エフェクト発生位置")]
		public GameObject エフェクト発生位置; // 0x28
		[FormerlySerializedAs("停止エフェクト")]
		public GameObject 停止エフェクト; // 0x30
		[FormerlySerializedAs("起動エフェクト")]
		public GameObject 起動エフェクト; // 0x38
		[FormerlySerializedAs("破壊エフェクト")]
		public GameObject 破壊エフェクト; // 0x40
		[SpaceAttribute] // RVA: 0x173E70 Offset: 0x173F71 VA: 0x173E70
		[FormerlySerializedAs("動作透過無効化")]
		public bool 動作透過無効化; // 0x48
		[RangeAttribute(0, 1)] // RVA: 0x173E90 Offset: 0x173F91 VA: 0x173E90
		[FormerlySerializedAs("動作透過遅延")]
		public float 動作透過遅延; // 0x4C
		[RangeAttribute(0, 1)] // RVA: 0x173EB0 Offset: 0x173FB1 VA: 0x173EB0
		[FormerlySerializedAs("動作透過時間")]
		public float 動作透過時間; // 0x50
		[FormerlySerializedAs("状態変化")]
		public State[] 状態変化; // 0x58
		public GameObject[] 破壊前オブジェクト; // 0x60
		public GameObject[] 破壊後オブジェクト; // 0x68
		public MapSoundLabel m_MapSoundLabel; // 0x70
		public List<Pair> m_LightmapPairs; // 0x78
		[HideInInspector] // RVA: 0x173ED0 Offset: 0x173FD1 VA: 0x173ED0
		public LightmapScales m_LightmapScale; // 0x80
		[RangeAttribute(0, 1)] // RVA: 0x173EE0 Offset: 0x173FE1 VA: 0x173EE0
		public float m_ViewDistance; // 0x84
		[RangeAttribute(0, 1)] // RVA: 0x173F00 Offset: 0x174001 VA: 0x173F00
		public float m_EditAlpha; // 0x88
		[HideInInspector] // RVA: 0x173F20 Offset: 0x174021 VA: 0x173F20
		public string m_Terrain; // 0x90
		private float m_FadeAlpha; // 0x98
		private float m_ActionAlpha; // 0x9C
		private float m_TransparentAlpha; // 0xA0
		private float m_DestructoniAlpha; // 0xA4
		private Actions m_Action; // 0xA8
		private Actions m_PreviwAction; // 0xAC
		private int m_State; // 0xB0
		private int m_PreviwState; // 0xB4
		private Animator m_Animator; // 0xB8
		private MapMaterial m_MapMaterial; // 0xC0
		private bool m_IsBroken; // 0xC8
		private RigidList m_BrokenList; // 0xD0
		private DitherManager m_DitherManager; // 0xD8
		private string SerializeKey;
	}
}