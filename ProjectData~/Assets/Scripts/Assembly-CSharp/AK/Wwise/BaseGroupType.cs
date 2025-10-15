using System;
using UnityEngine;
using AK.Wwise;

namespace AK.Wwise
{
	public abstract class BaseGroupType : BaseType
	{
		private int groupIdInternal;
		private byte[] groupGuidInternal;
		public WwiseObjectReference GroupWwiseObjectReference;
		public WwiseObjectType WwiseObjectGroupType;
		public uint GroupId;
		public int groupID;
		public byte[] groupGuid;
	}
}
