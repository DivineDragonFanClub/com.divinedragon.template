using System;
using Code.Combat.Editor;
using UnityEditor;
using UnityEngine;

namespace Combat
{
    [CreateAssetMenu(fileName = "Proportion", menuName = "Divine Dragon/ProportionParametersScriptableObject",
        order = 1)]
    public class ProportionParametersScriptableObject : ScriptableObject
    {
        public string Name;
        public ProportionParameters proportionParameters;
    }
#if UNITY_EDITOR
    [CustomEditor(typeof(ProportionParametersScriptableObject))]
    public class ProportionParametersScriptableObjectEditor : Editor
    {
        private string xmlInput;

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            xmlInput = EditorGUILayout.TextField("AssetTable XML line", xmlInput);

            if (GUILayout.Button("Load line"))
            {
                var loadedPp = AssetTableLineReader.LoadLineIntoProportionData(xmlInput) ??
                               throw new ArgumentNullException(
                                   "AssetTableLineReader.LoadLineIntoProportionData(xmlInput)");
                var cp = target as ProportionParametersScriptableObject;
                cp.proportionParameters = loadedPp;
                EditorApplication.QueuePlayerLoopUpdate();
                // SceneView.RepaintAll();
            }
        }
    }
#endif
}