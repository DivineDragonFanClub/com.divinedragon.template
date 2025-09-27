using System;
using UnityEngine;

namespace Combat {
    [DisallowMultipleComponent]
    [ExecuteInEditMode]
    public sealed class CharacterProportion : MonoBehaviour
    {
        public ProportionParameters ProportionParameters;
        
        void Start()
        {
            Transform c_trans = gameObject.transform.Find("c_trans");
            float size = ProportionParameters.ScaleAll * ProportionParameters.ScaleLegs;
            c_trans.localScale = new Vector3(size, size, size);

            Transform c_head_jnt = RecursiveFindChild(c_trans, "c_head_jnt");
            size = (ProportionParameters.ScaleHead / ProportionParameters.ScaleNeck);
            c_head_jnt.localScale = new Vector3(size, size, size);

            Transform c_spine1_jnt = RecursiveFindChild(c_trans, "c_spine1_jnt");
            size = (float)((ProportionParameters.ScaleLegs * 0.5 + 0.5) * ((ProportionParameters.ScaleTorso * 0.2 + 0.8) / ProportionParameters.ScaleLegs) / ((ProportionParameters.HipJointHeight * ProportionParameters.ScaleFeet - ProportionParameters.HipJointHeight) + 1.0));
            c_spine1_jnt.localScale = new Vector3(size, size, size);

            Transform c_spine2_jnt = RecursiveFindChild(c_trans, "c_spine2_jnt");
            size = (float)((ProportionParameters.ScaleTorso * 0.8 + 0.2) / (ProportionParameters.ScaleLegs * 0.5 + 0.5));
            c_spine2_jnt.localScale = new Vector3(size, size, size);

            Transform l_leg1_jnt = RecursiveFindChild(c_trans, "l_leg1_jnt");
            size = (float)(1.0f / ((ProportionParameters.HipJointHeight * ProportionParameters.ScaleFeet - ProportionParameters.HipJointHeight) + 1.0));
            l_leg1_jnt.localScale = new Vector3(size, size, size);

            Transform r_leg1_jnt = RecursiveFindChild(c_trans, "r_leg1_jnt");
            size = (float)(1.0f / ((ProportionParameters.HipJointHeight * ProportionParameters.ScaleFeet - ProportionParameters.HipJointHeight) + 1.0));
            r_leg1_jnt.localScale = new Vector3(size, size, size);

            Transform l_cla_jnt = RecursiveFindChild(c_trans, "l_cla_jnt");
            size = ProportionParameters.ScaleShoulders;
            l_cla_jnt.localScale = new Vector3(size, size, size);

            Transform r_cla_jnt = RecursiveFindChild(c_trans, "r_cla_jnt");
            size = ProportionParameters.ScaleShoulders;
            r_cla_jnt.localScale = new Vector3(size, size, size);

            Transform l_leg3_jnt = RecursiveFindChild(c_trans, "l_leg3_jnt");
            size = ProportionParameters.ScaleFeet;
            l_leg3_jnt.localScale = new Vector3(size, size, size);

            Transform r_leg3_jnt = RecursiveFindChild(c_trans, "r_leg3_jnt");
            size = ProportionParameters.ScaleFeet;
            r_leg3_jnt.localScale = new Vector3(size, size, size);

            Transform l_arm1_jnt = RecursiveFindChild(c_trans, "l_arm1_jnt");
            size = (float)(ProportionParameters.ScaleArms / ProportionParameters.ScaleShoulders / ProportionParameters.ScaleTorso);
            l_arm1_jnt.localScale = new Vector3(size, size, size);

            Transform r_arm1_jnt = RecursiveFindChild(c_trans, "r_arm1_jnt");
            size = (float)(ProportionParameters.ScaleArms / ProportionParameters.ScaleShoulders / ProportionParameters.ScaleTorso);
            r_arm1_jnt.localScale = new Vector3(size, size, size);

            Transform l_arm3_jnt = RecursiveFindChild(c_trans, "l_arm3_jnt");
            size = ProportionParameters.ScaleHands;
            l_arm3_jnt.localScale = new Vector3(size, size, size);

            Transform r_arm3_jnt = RecursiveFindChild(c_trans, "r_arm3_jnt");
            size = ProportionParameters.ScaleHands;
            r_arm3_jnt.localScale = new Vector3(size, size, size);

            // Volumes
            // TODO: Check if c_spine1vol_jnt bone exists before applying these
            Transform l_shldrArmr_jnt = RecursiveFindChild(c_trans, "l_shldrArmr_jnt");
            size = ProportionParameters.VolumeArms;
            l_shldrArmr_jnt.localScale = new Vector3(1.0f, size, size);

            Transform r_shldrArmr_jnt = RecursiveFindChild(c_trans, "r_shldrArmr_jnt");
            size = ProportionParameters.VolumeArms;
            r_shldrArmr_jnt.localScale = new Vector3(1.0f, size, size);

            Transform l_arm1vol_jnt = RecursiveFindChild(c_trans, "l_arm1vol_jnt");
            size = ProportionParameters.VolumeArms;
            l_arm1vol_jnt.localScale = new Vector3(1.0f, size, size);

            Transform r_arm1vol_jnt = RecursiveFindChild(c_trans, "r_arm1vol_jnt");
            size = ProportionParameters.VolumeArms;
            r_arm1vol_jnt.localScale = new Vector3(1.0f, size, size);

            Transform l_arm2vol_jnt = RecursiveFindChild(c_trans, "l_arm2vol_jnt");
            size = ProportionParameters.VolumeArms;
            l_arm2vol_jnt.localScale = new Vector3(1.0f, size, size);

            Transform r_arm2vol_jnt = RecursiveFindChild(c_trans, "r_arm2vol_jnt");
            size = ProportionParameters.VolumeArms;
            r_arm2vol_jnt.localScale = new Vector3(1.0f, size, size);

            Transform l_leg1vol_jnt = RecursiveFindChild(c_trans, "l_leg1vol_jnt");
            size = ProportionParameters.VolumeLegs;
            l_leg1vol_jnt.localScale = new Vector3(1.0f, size, size);

            Transform l_leg2vol_jnt = RecursiveFindChild(c_trans, "l_leg2vol_jnt");
            size = ProportionParameters.VolumeLegs;
            l_leg2vol_jnt.localScale = new Vector3(1.0f, size, size);

            Transform r_leg1vol_jnt = RecursiveFindChild(c_trans, "r_leg1vol_jnt");
            size = ProportionParameters.VolumeLegs;
            r_leg1vol_jnt.localScale = new Vector3(1.0f, size, size);

            Transform r_leg2vol_jnt = RecursiveFindChild(c_trans, "r_leg2vol_jnt");
            size = ProportionParameters.VolumeLegs;
            r_leg2vol_jnt.localScale = new Vector3(1.0f, size, size);

            Transform r_bust = RecursiveFindChild(c_trans, "r_bust_jnt");
            size = ProportionParameters.VolumeBust;
            r_bust.localScale = new Vector3(size, size, size);

            Transform l_bust = RecursiveFindChild(c_trans, "l_bust_jnt");
            size = ProportionParameters.VolumeBust;
            l_bust.localScale = new Vector3(size, size, size);

            Transform c_spine1vol_jnt = RecursiveFindChild(c_trans, "c_spine1vol_jnt");
            size = (float)(ProportionParameters.VolumeAbdomen * 1.9 + -0.9);
            c_spine1vol_jnt.localScale = new Vector3(1.0f, size, ProportionParameters.VolumeAbdomen);

            Transform c_spine2vol_jnt = RecursiveFindChild(c_trans, "c_spine2vol_jnt");
            size = ProportionParameters.VolumeTorso;
            c_spine2vol_jnt.localScale = new Vector3(1.0f, size, size);
        }

        // Update is called once per frame
        void LateUpdate()
        {
            Start();
        }

        Transform RecursiveFindChild(Transform parent, string childName)
        {
            foreach (Transform child in parent)
            {
                if(child.name == childName)
                {
                    return child;
                }
                else
                {
                    Transform found = RecursiveFindChild(child, childName);
                    if (found != null)
                    {
                        return found;
                    }
                }
            }

            return null;
        }
    }
}