using System;
using UnityEngine;

namespace AK.Wwise
{
	public class BaseType
	{
		public int idInternal;
		public byte[] valueGuidInternal;
		public WwiseObjectReference WwiseObjectReference;
		private WwiseObjectType WwiseObjectType;
		private string Name;
		private uint Id;
		private static uint InvalidId;
		private int ID;
		private byte[] valueGuid;
	}
}
