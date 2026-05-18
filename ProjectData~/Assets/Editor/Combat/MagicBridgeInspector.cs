using UnityEngine;
using Combat;
using App;
using UnityEditor;
using System;

[CustomEditor(typeof(Magic_Bridge)), CanEditMultipleObjects]
public class MagicBridgeInspector : UnityEditor.Editor
{
    SerializedProperty BulletSettings;
    SerializedProperty Track開始時処理;
    SerializedProperty Track魔法動作1処理;
    SerializedProperty Track魔法動作2処理;
    SerializedProperty Track魔法動作3処理;
    SerializedProperty Trackヒット時処理;
    SerializedProperty Trackミス時処理;
    SerializedProperty Trackガード時処理;
    SerializedProperty Trackパリィ時処理;
    SerializedProperty Track衝突時処理;
    SerializedProperty Track自然消滅処理;
    SerializedProperty Track打撃命中処理;
    SerializedProperty InitialStartPos;
    SerializedProperty InitialEndPos;
    SerializedProperty HomeNode;
    SerializedProperty TargetNode;
    SerializedProperty TargetPosition;
    
    void OnEnable()
    {
        BulletSettings = serializedObject.FindProperty("BulletSettings");
        Track開始時処理 = serializedObject.FindProperty("Track開始時処理");
        Track魔法動作1処理 = serializedObject.FindProperty("Track魔法動作1処理");
        Track魔法動作2処理 = serializedObject.FindProperty("Track魔法動作2処理");
        Track魔法動作3処理 = serializedObject.FindProperty("Track魔法動作3処理");
        Trackヒット時処理 = serializedObject.FindProperty("Trackヒット時処理");
        Trackミス時処理 = serializedObject.FindProperty("Trackミス時処理");
        Trackガード時処理 = serializedObject.FindProperty("Trackガード時処理");
        Trackパリィ時処理 = serializedObject.FindProperty("Trackパリィ時処理");
        Track衝突時処理 = serializedObject.FindProperty("Track衝突時処理");
        Track自然消滅処理 = serializedObject.FindProperty("Track自然消滅処理");
        Track打撃命中処理 = serializedObject.FindProperty("Track打撃命中処理");
        InitialStartPos = serializedObject.FindProperty("InitialStartPos");
        InitialEndPos = serializedObject.FindProperty("InitialEndPos");
        HomeNode = serializedObject.FindProperty("HomeNode");
        TargetNode = serializedObject.FindProperty("TargetNode");
        TargetPosition = serializedObject.FindProperty("TargetPosition");        
    }
        public override void OnInspectorGUI()
    {
        //base.OnInspectorGUI();

        serializedObject.Update();

        EditorGUILayout.PropertyField(BulletSettings, new GUIContent("Bullet Settings"));
        EditorGUILayout.PropertyField(Track開始時処理, new GUIContent("Track - On Start"));
        EditorGUILayout.PropertyField(Track魔法動作1処理, new GUIContent("Track - Magic Action 1"));
        EditorGUILayout.PropertyField(Track魔法動作2処理, new GUIContent("Track - Magic Action 2"));
        EditorGUILayout.PropertyField(Track魔法動作3処理, new GUIContent("Track - Magic Action 3"));
        EditorGUILayout.PropertyField(Trackヒット時処理, new GUIContent("Track - On Hit"));
        EditorGUILayout.PropertyField(Trackミス時処理, new GUIContent("Track - On Miss"));
        EditorGUILayout.PropertyField(Trackガード時処理, new GUIContent("Track - On Guard"));
        EditorGUILayout.PropertyField(Trackパリィ時処理, new GUIContent("Track - On Parry"));
        EditorGUILayout.PropertyField(Track衝突時処理, new GUIContent("Track - On Collision"));
        EditorGUILayout.PropertyField(Track自然消滅処理, new GUIContent("Track - On Expiration"));
        EditorGUILayout.PropertyField(Track打撃命中処理, new GUIContent("Track - On Melee Hit"));
        //EditorGUILayout.PropertyField(InitialStartPos, new GUIContent("Initial Start Position"));
        //EditorGUILayout.PropertyField(InitialEndPos, new GUIContent("Initial End Position"));
        //EditorGUILayout.PropertyField(HomeNode, new GUIContent("Home Node"));
        //EditorGUILayout.PropertyField(TargetNode, new GUIContent("Target Node"));
        //EditorGUILayout.PropertyField(TargetPosition, new GUIContent("Target Position"));

        serializedObject.ApplyModifiedProperties();

    }
}
    
