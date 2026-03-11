using UnityEngine;
using UnityEditor;

public class PieChartExtruded2DGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        // Define property lookups
        MaterialProperty[] colors = new MaterialProperty[10];
        MaterialProperty[] percents = new MaterialProperty[10];

        for (int i = 0; i < 10; i++)
        {
            colors[i] = FindProperty($"_Color{i}", props);
            percents[i] = FindProperty($"_Percent{i}", props);
        }

        MaterialProperty layers = FindProperty("_Layers", props);
        MaterialProperty innerRadius = FindProperty("_InnerRadius", props);
        MaterialProperty fillAmount = FindProperty("_FillAmount", props);
        MaterialProperty squash = FindProperty("_Squash", props);
        MaterialProperty darkenColor = FindProperty("_DarkenColor", props);

        // Header
        EditorGUILayout.LabelField("Pie Chart Slices", EditorStyles.boldLabel);

        for (int i = 0; i < 10; i++)
        {
            EditorGUILayout.BeginHorizontal();
            GUILayout.Label($"Slice {i}", GUILayout.Width(60));
            materialEditor.ColorProperty(colors[i], "");
            GUILayout.Space(16);
            percents[i].floatValue = EditorGUILayout.FloatField(percents[i].floatValue, GUILayout.Width(40));
            GUILayout.Label("%", GUILayout.Width(15));

            EditorGUILayout.EndHorizontal();
        }

        // Divider
        EditorGUILayout.Space();
        DrawLine();
        EditorGUILayout.Space();

        // Extrude Settings
        EditorGUILayout.LabelField("Extrude Settings", EditorStyles.boldLabel);
        layers.floatValue = EditorGUILayout.Slider("Extrude Layers", layers.floatValue, 8, 128);
        innerRadius.floatValue = EditorGUILayout.Slider("Inner Radius", innerRadius.floatValue, 0f, 0.9f);
        fillAmount.floatValue = EditorGUILayout.Slider("Fill Height", fillAmount.floatValue, 0.1f, 0.5f);
        squash.floatValue = EditorGUILayout.Slider("Y Squash", squash.floatValue, 2f, 10f);
        materialEditor.ColorProperty(darkenColor, "Darken Color");
    }

    void DrawLine(int height = 1)
    {
        Rect rect = EditorGUILayout.GetControlRect(false, height);
        rect.height = height;
        EditorGUI.DrawRect(rect, new Color(0.3f, 0.3f, 0.3f, 1));
    }
}
