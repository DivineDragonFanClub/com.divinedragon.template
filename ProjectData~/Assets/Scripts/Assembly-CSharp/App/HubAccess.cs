using System.Collections.Generic;
using UnityEngine;

namespace App
{
	public class HubAccess : MonoBehaviour
	{
		[SerializeField] // RVA: 0x180A70 Offset: 0x180B71 VA: 0x180A70
		public string AID; // 0x18
		private Transform PlayerTransform; // 0x20
		private Transform TargetTransform; // 0x28
		private Vector3 HelpOffset; // 0x30
		private bool IsWall; // 0x3C
		private Vector3 OrigPosition; // 0x40
		private Quaternion OrigRotation; // 0x4C
		private HubAccessData m_accessData; // 0x60
		private GameObject ItemEffect; // 0x68
		private GameObject AccessCursorObject; // 0x70
		private HubAccessCursor AccessCursor; // 0x78
	}
}