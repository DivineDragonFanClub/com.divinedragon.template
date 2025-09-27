using System.Collections.Generic;
using UnityEngine;

namespace App
{
	public class HubAccessData
	{
		// Fields
		public string AID; // 0x10
		private GameObject DisposData; // 0x18
		private bool IsStory; // 0x20
		private bool IsReliance; // 0x21
		private bool IsGod; // 0x22
		private bool IsUnit; // 0x23
		private bool IsAnimal; // 0x24
		private bool IsPerson; // 0x25
		private int ResultTalkIndex; // 0x28
		private bool IsHeroBirthday; // 0x2C
		private string TalkItem; // 0x30
		private int ItemCount; // 0x38
		private string m_flagName; // 0x40
		private List<string> m_messages; // 0x48
		private static List<string> ignoreUsedPattern; // 0x0
	}
}