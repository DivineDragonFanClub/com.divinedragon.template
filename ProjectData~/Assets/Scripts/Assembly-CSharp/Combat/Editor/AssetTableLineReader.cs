using System.Xml;
using Combat;

namespace Code.Combat.Editor
{
    public class AssetTableLineReader
    {
        // Parse in a line like 
        // 	<Param Out="" PresetName="" Mode="0" Conditions="MPID_Goldmary;" BodyModel="" DressModel="" MaskColor100R="255" MaskColor100G="207" MaskColor100B="104" MaskColor075R="250" MaskColor075G="250" MaskColor075B="250" MaskColor050R="71" MaskColor050G="43" MaskColor050B="26" MaskColor025R="226" MaskColor025G="226" MaskColor025B="228" HeadModel="" HairModel="" HairR="0" HairG="0" HairB="0" GradR="0" GradG="0" GradB="0" SkinR="255" SkinG="224" SkinB="209" ToonR="0" ToonG="0" ToonB="0" RideModel="" RideDressModel="" LeftHand="" RightHand="" Trail="" Magic="" Acc1.Locator="" Acc1.Model="" Acc2.Locator="" Acc2.Model="" Acc3.Locator="" Acc3.Model="" Acc4.Locator="" Acc4.Model="" Acc5.Locator="" Acc5.Model="" Acc6.Locator="" Acc6.Model="" Acc7.Locator="" Acc7.Model="" Acc8.Locator="" Acc8.Model="" BodyAnim="" InfoAnim="" TalkAnim="" DemoAnim="" HubAnim="" ScaleAll="1.1" ScaleHead="0.94" ScaleNeck="1.02" ScaleTorso="1" ScaleShoulders="0.9" ScaleArms="0.95" ScaleHands="1" ScaleLegs="0.98" ScaleFeet="1" VolumeArms="1.1" VolumeLegs="1.04" VolumeBust="1.75" VolumeAbdomen="0.88" VolumeTorso="1" VolumeScaleArms="0" VolumeScaleLegs="0" MapScaleAll="0" MapScaleHead="0" MapScaleWing="0" Voice="Goldmary" FootStep="" Material="" Comment="ゴルドマリー" />
        // and return a ProportionParameters object
        public static ProportionParameters LoadLineIntoProportionData(string xmlLine)
        {
            var pp = new ProportionParameters();
            // Load the line using XML parsing
            var xml = new XmlDocument();
            xml.LoadXml(xmlLine);
            var node = xml.DocumentElement;
            // check over all attributes
            foreach (XmlAttribute attr in node.Attributes)
                // Set the value of pp based on the attribute name
                switch (attr.Name)
                {
                    case "ScaleAll":
                        pp.ScaleAll = float.Parse(attr.Value);
                        break;
                    case "ScaleHead":
                        pp.ScaleHead = float.Parse(attr.Value);
                        break;
                    case "ScaleNeck":
                        pp.ScaleNeck = float.Parse(attr.Value);
                        break;
                    case "ScaleTorso":
                        pp.ScaleTorso = float.Parse(attr.Value);
                        break;
                    case "ScaleShoulders":
                        pp.ScaleShoulders = float.Parse(attr.Value);
                        break;
                    case "ScaleArms":
                        pp.ScaleArms = float.Parse(attr.Value);
                        break;
                    case "ScaleHands":
                        pp.ScaleHands = float.Parse(attr.Value);
                        break;
                    case "ScaleLegs":
                        pp.ScaleLegs = float.Parse(attr.Value);
                        break;
                    case "ScaleFeet":
                        pp.ScaleFeet = float.Parse(attr.Value);
                        break;
                    case "VolumeArms":
                        pp.VolumeArms = float.Parse(attr.Value);
                        break;
                    case "VolumeLegs":
                        pp.VolumeLegs = float.Parse(attr.Value);
                        break;
                    case "VolumeBust":
                        pp.VolumeBust = float.Parse(attr.Value);
                        break;
                    case "VolumeAbdomen":
                        pp.VolumeAbdomen = float.Parse(attr.Value);
                        break;
                    case "VolumeTorso":
                        pp.VolumeTorso = float.Parse(attr.Value);
                        break;
                    case "HipJointHeight":
                        pp.HipJointHeight = float.Parse(attr.Value);
                        break;
                }

            pp.Conditions = node.Attributes["Conditions"].Value;
            pp.Comment = node.Attributes["Comment"].Value;
            return pp;
        }
    }
}