using System.Collections.Generic;
using UnityEngine;

using Combat;

namespace App
{
	public class HubPlayerController
	{
		private float Dir; // 0x10
		private float PrevDir; // 0x14
		private float ZRotate; // 0x18
		private bool IsStop; // 0x1C
		private Character Character; // 0x20
		private GameObject m_PlayerRoot; // 0x28
		private GameObject m_PlayerCollider; // 0x30
		private GameObject m_GroupRoot; // 0x38
		private GameObject m_Camera; // 0x40
		private GameObject m_ButtonNavi; // 0x48
		private GameObject m_LookAt; // 0x50
		private GameObject m_UnitController; // 0x58
		private List<Collider> m_Colliders; // 0x60
		private HubCamera m_HubCamera; // 0x68
		private HubAccess m_LastAccess; // 0x70
		private Animator m_Animator; // 0x78
		private CharacterJoint[] m_CharacterJoints; // 0x80
		private GameObject[] m_LookAtIKs; // 0x88
		private float m_Speed; // 0x90
		private Vector3 m_MoveTarget; // 0x94
		private Vector3 m_MoveDirection; // 0xA0
		private bool m_DashStop; // 0xAC
		private float m_DashStopTime; // 0xB0
		private float m_DashStopDelay; // 0xB4
		private float m_DashTime; // 0xB8
		private float m_TimeWithNoTarget; // 0xBC
		private string m_QuickTurnAnimName; // 0xC0
		private float m_AccessDelay; // 0xC8
		private GameObject m_CullingCollider; // 0xD0
		private GameObject[] m_GrassManagers; // 0xD8
		private int ObjectCollisionLayerMask; // 0xE0
		private int GroundCollisionLayerMask; // 0xE4
		private int SlopeCollisionLayerMask; // 0xE8
		private readonly float DefaultRadius; // 0xEC
		private int m_hash; // 0xF0
		private bool IsCharacterLoading; // 0xF4
		private RaycastHit[] results; // 0xF8
		private Collider[] overlapColliders; // 0x100
		private Collider[] accessColliders; // 0x108
		private Collider accessCollider; // 0x110
		private float distanceSpeed; // 0x118
		private Coroutine m_procIdleCoroutin; // 0x120
		private bool m_enableProc; // 0x128
		private float m_WallInterval; // 0x12C
	}
}