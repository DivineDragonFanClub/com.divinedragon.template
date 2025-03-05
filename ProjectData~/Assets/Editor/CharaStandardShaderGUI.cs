using System;
using UnityEngine;
using UnityEditor;
using UnityEngine.Rendering;

public class CharaStandardShaderGUI : MaterialEditor
{
    #region Enums
    public enum PresetType
    {
        Normal = 0,
        Unk1,
        Job,
        Unk3,
        Emissive,
        Emblem,
        Skin,
        Corrupted
    }
    #endregion

    #region Variables
    protected MaterialProperty presetProp { get; set; }
    protected MaterialProperty baseColorProp { get; set; }
    protected MaterialProperty baseMapProp { get; set; }
    protected MaterialProperty multiMapProp { get; set; }
    protected MaterialProperty normalMapProp { get; set; }
    protected MaterialProperty bumpMapScaleProp { get; set; }
    protected MaterialProperty occlusionIntensityProp { get; set; }
    protected MaterialProperty toonRampProp { get; set; }
    protected MaterialProperty toonRampMetalProp { get; set; }
    protected MaterialProperty toonShadowColorProp { get; set; }
    protected MaterialProperty bumpCameraAttenuationProp { get; set; }
    protected MaterialProperty outlineColorProp { get; set; }
    protected MaterialProperty outlineScaleProp { get; set; }
    protected MaterialProperty outlineTexMipLevelProp { get; set; }
    protected MaterialProperty outlineOriginalColorRateProp { get; set; }
    protected MaterialProperty lightColorToWhiteProp { get; set; }
    protected MaterialProperty lightShadowToWhiteProp { get; set; }
    protected MaterialProperty lightColorProp { get; set; }
    protected MaterialProperty shadowColorProp { get; set; }
    protected MaterialProperty rimLightScaleProp { get; set; }
    protected MaterialProperty rimLightBlendProp { get; set; }
    protected MaterialProperty engageEmissionColorProp { get; set; }
    protected MaterialProperty makeupScaleProp { get; set; }
    protected MaterialProperty morphDressKeyProp { get; set; }
    protected MaterialProperty toonRampMorphProp { get; set; }
    protected MaterialProperty toonRampMetalMorphProp { get; set; }
    protected MaterialProperty emissionMapProp { get; set; }
    protected MaterialProperty emissionColorProp { get; set; }
    protected MaterialProperty colorChangeMaskKeyProp { get; set; }
    protected MaterialProperty colorChangeMask100Prop { get; set; }
    protected MaterialProperty colorChangeMask75Prop { get; set; }
    protected MaterialProperty colorChangeMask50Prop { get; set; }
    protected MaterialProperty colorChangeMask25Prop { get; set; }
    protected MaterialProperty standardSkinKeyProp { get; set; }
    protected MaterialProperty ditherAlphaKeyProp { get; set; }


    bool m_PrimaryMapsFoldout = true;
    bool m_RampFoldout = true;
    bool m_BumpAttenuationFoldout = true;
    bool m_OutlineFoldout = true;
    bool m_OptionsFoldout = true;
    bool m_UnitOptionsFoldout = true;
    bool m_AdvancedOptionsFoldout = true;
    bool m_MorphFoldout = true;
    bool m_EmissionFoldout = true;
    bool m_ColorMaskFoldout = true;
    #endregion

    #region General Functions
    public virtual void FindProperties(MaterialProperty[] properties)
    {
        presetProp = FindProperty("_Preset", properties);
        baseMapProp = FindProperty("_BaseMap", properties);
        baseColorProp = FindProperty("_BaseColor", properties);
        multiMapProp = FindProperty("_MultiMap", properties);
        normalMapProp = FindProperty("_BumpMap", properties);
        bumpMapScaleProp = FindProperty("_BumpScale", properties);
        occlusionIntensityProp = FindProperty("_OcclusionIntensity", properties);
        toonRampProp = FindProperty("_ToonRamp", properties);
        toonRampMetalProp = FindProperty("_ToonRampMetal", properties);
        toonShadowColorProp = FindProperty("_ToonShadowColor", properties);
        bumpCameraAttenuationProp = FindProperty("_BumpCameraAttenuation", properties);
        outlineColorProp = FindProperty("_OutlineColor", properties);
        outlineScaleProp = FindProperty("_OutlineScale", properties);
        outlineTexMipLevelProp = FindProperty("_OutlineTexMipLevel", properties);
        outlineOriginalColorRateProp = FindProperty("_OutlineOriginalColorRate", properties);
        lightColorToWhiteProp = FindProperty("_LightColorToWhite", properties);
        lightShadowToWhiteProp = FindProperty("_LightShadowToWhite", properties);
        lightColorProp = FindProperty("_RimLightColorLight", properties);
        shadowColorProp = FindProperty("_RimLightColorShadow", properties);
        rimLightScaleProp = FindProperty("_RimLightScale", properties);
        rimLightBlendProp = FindProperty("_RimLightBlend", properties);
        engageEmissionColorProp = FindProperty("_EngageEmissionColor", properties);
        makeupScaleProp = FindProperty("_Makeup", properties);
        // Morph
        morphDressKeyProp = FindProperty("_S_Key_MorphDress", properties);
        toonRampMorphProp = FindProperty("_ToonRamp_Morph", properties);
        toonRampMetalMorphProp = FindProperty("_ToonRampMetal_Morph", properties);
        // Emission
        emissionMapProp = FindProperty("_EmissionMap", properties);
        emissionColorProp = FindProperty("_EmissionColor", properties);
        // ColorChange
        colorChangeMaskKeyProp = FindProperty("_S_Key_ColorChangeMask", properties);
        colorChangeMask100Prop = FindProperty("_ColorChangeMask100", properties);
        colorChangeMask75Prop = FindProperty("_ColorChangeMask075", properties);
        colorChangeMask50Prop = FindProperty("_ColorChangeMask050", properties);
        colorChangeMask25Prop = FindProperty("_ColorChangeMask025", properties);
        // StandardSkin
        standardSkinKeyProp = FindProperty("_S_Key_StandardSkin", properties);

        ditherAlphaKeyProp = FindProperty("_Key_DitherAlpha", properties);
    }

    public override void OnInspectorGUI()
    {
        Material material = this.target as Material;
        FindProperties(GetMaterialProperties(this.targets));

        //base.OnInspectorGUI();

        EditorGUI.BeginChangeCheck();

        var preset = (PresetType)presetProp.floatValue;

        preset = (PresetType)EditorGUILayout.EnumPopup("Preset", preset);

        if (EditorGUI.EndChangeCheck())
        {
            presetProp.floatValue = (float)preset;

            switch (preset)
            {
                case PresetType.Normal:
                    lightColorToWhiteProp.floatValue = 0;
                    lightShadowToWhiteProp.floatValue = 0;
                    rimLightBlendProp.floatValue = 0.25f;
                    rimLightScaleProp.floatValue = 0.45f;
                    outlineOriginalColorRateProp.floatValue = 0;

                    emissionColorProp.colorValue = Color.black;
                    outlineColorProp.colorValue = new Color(0.294f, 0.243f, 0.243f, 1);
                    lightColorProp.colorValue = new Color(0.690f, 0.7098f, 0.8980f);
                    shadowColorProp.colorValue = new Color(0.4588f, 0.4784f, 0.6588f);


                    morphDressKeyProp.floatValue = 0;
                    colorChangeMaskKeyProp.floatValue = 0;
                    standardSkinKeyProp.floatValue = 0;

                    material.DisableKeyword("_EMISSION");
                    material.EnableKeyword("_NORMALMAP");
                    material.EnableKeyword("_S_KEY_BUMP_ATTENUATION");
                    material.DisableKeyword("_S_KEY_MORPH_DRESS");
                    material.DisableKeyword("_S_KEY_COLOR_CHANGE_MASK");
                    material.DisableKeyword("_S_KEY_STANDARD_SKIN");

                    break;
                case PresetType.Job:
                    morphDressKeyProp.floatValue = 0;
                    colorChangeMaskKeyProp.floatValue = 1;
                    standardSkinKeyProp.floatValue = 0;

                    material.DisableKeyword("_EMISSION");
                    material.EnableKeyword("_NORMALMAP");
                    material.EnableKeyword("_S_KEY_BUMP_ATTENUATION");
                    material.EnableKeyword("_S_KEY_COLOR_CHANGE_MASK");
                    material.DisableKeyword("_S_KEY_MORPH_DRESS");
                    material.DisableKeyword("_S_KEY_STANDARD_SKIN");

                    break;
                case PresetType.Emissive:
                    morphDressKeyProp.floatValue = 0;
                    colorChangeMaskKeyProp.floatValue = 0;
                    standardSkinKeyProp.floatValue = 0;

                    material.EnableKeyword("_EMISSION");
                    material.DisableKeyword("_NORMALMAP");
                    material.DisableKeyword("_S_KEY_BUMP_ATTENUATION");
                    material.DisableKeyword("_S_KEY_MORPH_DRESS");
                    material.DisableKeyword("_S_KEY_COLOR_CHANGE_MASK");
                    material.DisableKeyword("_S_KEY_STANDARD_SKIN");
                    break;
                case PresetType.Emblem:
                    lightColorToWhiteProp.floatValue = 0.8f;
                    lightShadowToWhiteProp.floatValue = 0.8f;
                    rimLightBlendProp.floatValue = 0.45f;
                    rimLightScaleProp.floatValue = 1;
                    outlineOriginalColorRateProp.floatValue = 1;
                    emissionColorProp.colorValue = new Color(0.1725f, 0.1686f, 0.30980f);
                    outlineColorProp.colorValue = new Color(0.6509f, 0.7137f, 0.9254f);
                    lightColorProp.colorValue = new Color(0.2122f, 0.8795f, 1);
                    shadowColorProp.colorValue = new Color(0.1027f, 0.5745f, 0.6603f);


                    morphDressKeyProp.floatValue = 0;
                    colorChangeMaskKeyProp.floatValue = 0;
                    standardSkinKeyProp.floatValue = 0;

                    material.EnableKeyword("_EMISSION");
                    material.EnableKeyword("_NORMALMAP");
                    material.EnableKeyword("_S_KEY_BUMP_ATTENUATION");
                    material.DisableKeyword("_S_KEY_MORPH_DRESS");
                    material.DisableKeyword("_S_KEY_COLOR_CHANGE_MASK");
                    material.DisableKeyword("_S_KEY_STANDARD_SKIN");
                    break;
                case PresetType.Skin:
                    morphDressKeyProp.floatValue = 0;
                    colorChangeMaskKeyProp.floatValue = 0;
                    standardSkinKeyProp.floatValue = 1;

                    material.DisableKeyword("_EMISSION");
                    material.EnableKeyword("_NORMALMAP");
                    material.EnableKeyword("_S_KEY_BUMP_ATTENUATION");
                    material.DisableKeyword("_S_KEY_MORPH_DRESS");
                    material.DisableKeyword("_S_KEY_COLOR_CHANGE_MASK");
                    material.EnableKeyword("_S_KEY_STANDARD_SKIN");

                    break;
                case PresetType.Corrupted:
                    morphDressKeyProp.floatValue = 1;
                    colorChangeMaskKeyProp.floatValue = 1;
                    standardSkinKeyProp.floatValue = 0;

                    material.DisableKeyword("_EMISSION");
                    material.EnableKeyword("_NORMALMAP");
                    material.EnableKeyword("_S_KEY_BUMP_ATTENUATION");
                    material.EnableKeyword("_S_KEY_MORPH_DRESS");
                    material.EnableKeyword("_S_KEY_COLOR_CHANGE_MASK");
                    material.DisableKeyword("_S_KEY_STANDARD_SKIN");

                    break;
                default:
                    break;
            }

        }

        EditorGUILayout.Space();

        m_PrimaryMapsFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_PrimaryMapsFoldout, "Primary Maps");

        if (m_PrimaryMapsFoldout)
        {
            EditorGUI.indentLevel++;
            TexturePropertySingleLine(new GUIContent("Albedo", ""), baseMapProp, baseColorProp);
            TexturePropertySingleLine(new GUIContent("Multi Map", ""), multiMapProp);
            TexturePropertySingleLine(new GUIContent("Normal Map", ""), normalMapProp, bumpMapScaleProp);
            occlusionIntensityProp.floatValue = EditorGUILayout.Slider("Occlusion Intensity", occlusionIntensityProp.floatValue, 0, 1);

            EditorGUILayout.Space(10);

            TextureScaleOffsetProperty(baseMapProp);

            EditorGUI.indentLevel--;

        }

        EditorGUILayout.EndFoldoutHeaderGroup();

        m_RampFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_RampFoldout, "Ramp");

        if (m_RampFoldout)
        {
            EditorGUI.indentLevel++;

            TexturePropertySingleLine(new GUIContent("Toon Ramp", ""), toonRampProp);
            TexturePropertySingleLine(new GUIContent("Toon Ramp Metal", ""), toonRampMetalProp);
            ColorProperty(toonShadowColorProp, "Toon Shadow Color");

            EditorGUI.indentLevel--;
        }

        EditorGUILayout.EndFoldoutHeaderGroup();

        if (material.IsKeywordEnabled("_EMISSION"))
        {
            m_EmissionFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_EmissionFoldout, "Emission");

            if (m_EmissionFoldout)
            {
                EditorGUI.indentLevel++;
                
                TexturePropertySingleLine(new GUIContent("Emission Map", ""), emissionMapProp, emissionColorProp);

                EditorGUI.indentLevel--;
            }

            EditorGUILayout.EndFoldoutHeaderGroup();
        }

        if (morphDressKeyProp.floatValue == 1)
        {
            m_MorphFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_MorphFoldout, "Morph");

            if (m_MorphFoldout)
            {
                EditorGUI.indentLevel++;

                TexturePropertySingleLine(new GUIContent("Toon Ramp (Morph)", ""), toonRampMorphProp);
                TexturePropertySingleLine(new GUIContent("Toon Ramp Metal (Morph)", ""), toonRampMetalMorphProp);

                EditorGUI.indentLevel--;
            }

            EditorGUILayout.EndFoldoutHeaderGroup();
        }

        m_BumpAttenuationFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_BumpAttenuationFoldout, "Bump Attenuation");

        if (m_BumpAttenuationFoldout)
        {
            EditorGUI.indentLevel++;

            bumpCameraAttenuationProp.floatValue = EditorGUILayout.Slider("Bump Camera Attenuation", bumpCameraAttenuationProp.floatValue, 0, 1);

            EditorGUI.indentLevel--;
        }

        EditorGUILayout.EndFoldoutHeaderGroup();

        if (colorChangeMaskKeyProp.floatValue == 1)
        {
            m_ColorMaskFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_ColorMaskFoldout, "Color Mask");

            if (m_ColorMaskFoldout)
            {
                EditorGUI.indentLevel++;

                ColorProperty(colorChangeMask100Prop, "Color Mask (100%)");
                ColorProperty(colorChangeMask75Prop, "Color Mask (75%)");
                ColorProperty(colorChangeMask50Prop, "Color Mask (50%)");
                ColorProperty(colorChangeMask25Prop, "Color Mask (25%)");

                EditorGUI.indentLevel--;
            }

            EditorGUILayout.EndFoldoutHeaderGroup();
        }

        m_OutlineFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_OutlineFoldout, "Outline");

        if (m_OutlineFoldout)
        {
            EditorGUI.indentLevel++;

            ColorProperty(outlineColorProp, "Outline Color");
            outlineScaleProp.floatValue = EditorGUILayout.Slider("Outline Scale", outlineScaleProp.floatValue, 0, 10);
            outlineTexMipLevelProp.floatValue = EditorGUILayout.Slider("Outline Tex Mip Level", outlineTexMipLevelProp.floatValue, 0, 12);
            outlineOriginalColorRateProp.floatValue = EditorGUILayout.Slider("Outline Original Color Rate", outlineOriginalColorRateProp.floatValue, 0, 10);

            EditorGUI.indentLevel--;
        }

        EditorGUILayout.EndFoldoutHeaderGroup();

        m_OptionsFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_OptionsFoldout, "Options");

        if (m_OptionsFoldout)
        {
            EditorGUI.indentLevel++;

            lightColorToWhiteProp.floatValue = EditorGUILayout.Slider("Light Color To White", lightColorToWhiteProp.floatValue, 0, 10);
            lightShadowToWhiteProp.floatValue = EditorGUILayout.Slider("Light Shadow To White", lightShadowToWhiteProp.floatValue, 0, 10);

            EditorGUILayout.LabelField("Rim Light");

            EditorGUI.indentLevel++;
            ColorProperty(lightColorProp, "Light Color");
            ColorProperty(shadowColorProp, "Shadow Color");
            rimLightScaleProp.floatValue = EditorGUILayout.Slider("Rim Light Scale", rimLightScaleProp.floatValue, 0, 1);
            rimLightBlendProp.floatValue = EditorGUILayout.Slider("Rim Light Blend", rimLightBlendProp.floatValue, 0, 1);
            EditorGUI.indentLevel--;

            EditorGUILayout.Space(10);

            var ditherAlphaEnabled = ditherAlphaKeyProp.floatValue == 1;

            EditorGUI.BeginChangeCheck();
            EditorGUILayout.Toggle("Use Dither Alpha", ditherAlphaEnabled);

            if (EditorGUI.EndChangeCheck())
            {
                if (ditherAlphaEnabled)
                    ditherAlphaKeyProp.floatValue = 0; // Toggle off
                else
                    ditherAlphaKeyProp.floatValue = 1;

                ditherAlphaEnabled = !ditherAlphaEnabled;
            }

            ColorProperty(engageEmissionColorProp, "Engage Emission Color");


            EditorGUI.indentLevel--;
        }

        EditorGUILayout.EndFoldoutHeaderGroup();

        m_UnitOptionsFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_UnitOptionsFoldout, "Unit Options");

        if (m_UnitOptionsFoldout)
        {
            EditorGUI.indentLevel++;

            makeupScaleProp.floatValue = EditorGUILayout.Slider("Makeup", makeupScaleProp.floatValue, 0, 1);

            EditorGUI.indentLevel--;
        }

        EditorGUILayout.EndFoldoutHeaderGroup();

        m_AdvancedOptionsFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_AdvancedOptionsFoldout, "Advanced Options");

        if (m_AdvancedOptionsFoldout)
        {
            EditorGUI.indentLevel++;

            RenderQueueField();
            DoubleSidedGIField();

            EditorGUI.indentLevel--;
        }

        EditorGUILayout.EndFoldoutHeaderGroup();
    }
    #endregion

    #region Helper Functions
    public static MaterialProperty FindProperty(string propertyName, MaterialProperty[] properties)
    {
        return FindProperty(propertyName, properties, true);
    }

    public static MaterialProperty FindProperty(string propertyName, MaterialProperty[] properties, bool propertyIsMandatory)
    {
        for (int index = 0; index < properties.Length; ++index)
        {
            if (properties[index] != null && properties[index].name == propertyName)
                return properties[index];
        }
        if (propertyIsMandatory)
            throw new ArgumentException("Could not find MaterialProperty: '" + propertyName + "', Num properties: " + (object)properties.Length);
        return null;
    }
    #endregion
}
