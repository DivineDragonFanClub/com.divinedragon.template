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
        public static HashSet<string> MaleConditions = new HashSet<string>
        {
            "MPID_Lueur;男装;", "MPID_Rafale;", "MPID_Alfred;",
            "MPID_Boucheron;", "MPID_Louis;", "MPID_Jean;",
            "MPID_Diamand;", "MPID_Staluke;", "MPID_Morion;",
            "MPID_Umber;", "MPID_Hyacinth;", "MPID_Zelkova;",
            "MPID_Kagetsu;", "MPID_Rosado;", "MPID_Linden;",
            "MPID_Fogato;", "MPID_Pandoro;", "MPID_Bonet;",
            "MPID_Seadas;", "MPID_Vandre;", "MPID_Clan;",
            "MPID_Mauve;", "MPID_Gris;", "MPID_Gregory;"
        };

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
                if (MaleConditions.Contains(condition?.Value))
                {
                    var parsedLine = AssetTableLineReader.LoadLineIntoProportionData(node.ToString());
                    Debug.Log(parsedLine);
                    CreateProportionParametersScriptableObject(parsedLine, 0);
                } else if (FemaleConditions.Contains(condition?.Value))
                {
                    var parsedLine = AssetTableLineReader.LoadLineIntoProportionData(node.ToString());
                    Debug.Log(parsedLine);
                    CreateProportionParametersScriptableObject(parsedLine, 1);
                }
            }
        }

        public static void CreateProportionParametersScriptableObject(ProportionParameters pp, int gender)
        {
            var asset = ScriptableObject.CreateInstance<ProportionParametersScriptableObject>();
            asset.proportionParameters = pp;
            asset.Name = pp.Conditions;
            asset.Gender = gender;
            AssetDatabase.CreateAsset(asset, "Assets/Resources/Proportions/" + pp.Conditions + ".asset");
        }
    }
}