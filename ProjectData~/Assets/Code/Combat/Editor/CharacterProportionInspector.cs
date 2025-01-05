using System;
using Combat;
using Code.Combat.Editor;
using UnityEditor;
using UnityEngine;

namespace Code.Combat.Editor
{
    [CustomEditor(typeof(CharacterProportion))]
    public class CharacterProportionInspector : UnityEditor.Editor
    {
        private string xmlInput;
        private int index;
        private int gender;
        private int size;
        private string[] options;
        private int[] genderoptions;
        private string[] label;
        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            xmlInput = EditorGUILayout.TextField("AssetTable XML line", xmlInput);

            if (GUILayout.Button("Load All"))
            {
                AssetTableParseCharacters.parseAll();
            }
            
            if (GUILayout.Button("Load line"))
            {
                var loadedPp = AssetTableLineReader.LoadLineIntoProportionData(xmlInput) ?? throw new ArgumentNullException("AssetTableLineReader.LoadLineIntoProportionData(xmlInput)");
                var cp = target as CharacterProportion;
                cp.ProportionParameters = loadedPp;
                EditorApplication.QueuePlayerLoopUpdate();
                // SceneView.RepaintAll();
            }

            var genderoptions = new int[] {0, 1};
            var label = new string[] {"Male", "Female"};
            var newgender = EditorGUILayout.IntPopup("Gender", gender, label, genderoptions);
            if (newgender != gender)
            {
                gender = newgender;
                EditorApplication.QueuePlayerLoopUpdate();
            }

            LoadKnownProportions(gender);
            // Create the dropdown
            var newIndex = EditorGUILayout.Popup("Character", index, options);
            
            // If the index has changed, update the index and load the new ProportionParameters
            if (newIndex != index)
            {
                index = newIndex;
                var cp = target as CharacterProportion;
                cp.ProportionParameters = Resources.Load<ProportionParametersScriptableObject>("Proportions/" + options[index]).proportionParameters;
                EditorApplication.QueuePlayerLoopUpdate();
                // SceneView.RepaintAll();
            }

        }

        private void LoadKnownProportions(int gender)
        {
            // Find all the ProportionParametersScriptableObjects in Resources/Proportions
            var proportionParametersScriptableObjects = Resources.LoadAll<ProportionParametersScriptableObject>("Proportions");
            
            if (gender == 0)
            {
                options = new string[AssetTableParseCharacters.MaleConditions.Count];
            } else 
            {
                options = new string[AssetTableParseCharacters.FemaleConditions.Count];
            }
  
            int j = 0;
            for (int i = 0; i < proportionParametersScriptableObjects.Length; i++)
            {
                if (proportionParametersScriptableObjects[i].Gender == gender)
                {
                    options[j] = proportionParametersScriptableObjects[i].Name;
                    j++;
                }
            }
        }
    }
}