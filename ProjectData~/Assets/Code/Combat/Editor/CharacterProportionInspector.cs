using System;
using Combat;
using UnityEditor;
using UnityEngine;

namespace Code.Combat.Editor
{
    [CustomEditor(typeof(CharacterProportion))]
    public class CharacterProportionInspector : UnityEditor.Editor
    {
        private string xmlInput;
        private int index;
        private string[] options;
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
            
            LoadKnownProportions();
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

        private void LoadKnownProportions()
        {
            // Find all the ProportionParametersScriptableObjects in Resources/Proportions
            var proportionParametersScriptableObjects = Resources.LoadAll<ProportionParametersScriptableObject>("Proportions");
            options = new string[proportionParametersScriptableObjects.Length];
            for (int i = 0; i < proportionParametersScriptableObjects.Length; i++)
            {
                options[i] = proportionParametersScriptableObjects[i].Name;
            }
        }
    }
}