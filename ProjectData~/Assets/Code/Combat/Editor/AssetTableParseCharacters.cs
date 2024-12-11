using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using Combat;
using UnityEditor;
using UnityEngine;

namespace Code.Combat.Editor
{
    public class AssetTableParseCharacters
    {
        public static HashSet<string> FemaleConditions = new HashSet<string>
        {
            "MPID_Lueur;女装;", "MPID_El;", "MPID_Celine;",
            "MPID_Eve;", "MPID_Etie;", "MPID_Chloe;",
            "MPID_Jade;", "MPID_Lapis;", "MPID_Citrinica;",
            "MPID_Yunaka;", "MPID_Saphir;", "MPID_Ivy;",
            "MPID_Hortensia;", "MPID_Goldmary;", "MPID_Misutira;",
            "MPID_Sfoglia;", "MPID_Merin;", "MPID_Panetone;",
            "MPID_Fram;", "MPID_Veyre;", "MPID_Anna;",
            "MPID_Sepia;", "MPID_Selestia;", "MPID_Marron;",
            "MPID_Madeline;", "MPID_Lumiere;"
        };

        public static void parseAll()
        {
            var doc = XDocument.Load("Assets/Resources/AssetTable.xml");

// Query the document for all 'Param' nodes under 'Sheet' with 'Mode' attribute equals to '0'
            var paramNodes = doc.Descendants("Sheet")
                .Descendants("Param")
                .Where(param => param.Attribute("Mode")?.Value == "0");

            foreach (var node in paramNodes)
            {
                var condition = node.Attribute("Conditions");
                if (FemaleConditions.Contains(condition?.Value))
                {
                    var parsedLine = AssetTableLineReader.LoadLineIntoProportionData(node.ToString());
                    Debug.Log(parsedLine);
                    CreateProportionParametersScriptableObject(parsedLine);
                }
            }
        }

        public static void CreateProportionParametersScriptableObject(ProportionParameters pp)
        {
            var asset = ScriptableObject.CreateInstance<ProportionParametersScriptableObject>();
            asset.proportionParameters = pp;
            asset.Name = pp.Conditions;
            AssetDatabase.CreateAsset(asset, "Assets/Resources/Proportions/" + pp.Conditions + ".asset");
        }
    }
}