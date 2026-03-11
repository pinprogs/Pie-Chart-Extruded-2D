Shader "Custom/PieChartExtruded2D"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {} // Required for UI Image materials

        _Color0("Slice 0 Color", Color) = (1, 1, 1, 1)
        _Percent0("Slice 0 Percent", Float) = 0.1

        _Color1("Slice 1 Color", Color) = (1, 1, 1, 1)
        _Percent1("Slice 1 Percent", Float) = 0.1

        _Color2("Slice 2 Color", Color) = (1, 1, 1, 1)
        _Percent2("Slice 2 Percent", Float) = 0.1

        _Color3("Slice 3 Color", Color) = (1, 1, 1, 1)
        _Percent3("Slice 3 Percent", Float) = 0.1

        _Color4("Slice 4 Color", Color) = (1, 1, 1, 1)
        _Percent4("Slice 4 Percent", Float) = 0.1

        _Color5("Slice 5 Color", Color) = (1, 1, 1, 1)
        _Percent5("Slice 5 Percent", Float) = 0.1

        _Color6("Slice 6 Color", Color) = (1, 1, 1, 1)
        _Percent6("Slice 6 Percent", Float) = 0.1

        _Color7("Slice 7 Color", Color) = (1, 1, 1, 1)
        _Percent7("Slice 7 Percent", Float) = 0.1

        _Color8("Slice 8 Color", Color) = (1, 1, 1, 1)
        _Percent8("Slice 8 Percent", Float) = 0.1

        _Color9("Slice 9 Color", Color) = (1, 1, 1, 1)
        _Percent9("Slice 9 Percent", Float) = 0.1

        _Layers("Extrude Layers", Float) = 64
        _InnerRadius("Inner Radius", Float) = 0.25
        _FillAmount("Fill Height", Float) = 0.5
        _Squash("Y Squash", Float) = 2.0
        _DarkenColor("Darken Color", Color) = (0.5, 0.5, 0.5, 1)
    }

    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" "PreviewType"="Plane" "CanUseSpriteAtlas"="False" }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _Color0; float _Percent0;
            fixed4 _Color1; float _Percent1;
            fixed4 _Color2; float _Percent2;
            fixed4 _Color3; float _Percent3;
            fixed4 _Color4; float _Percent4;
            fixed4 _Color5; float _Percent5;
            fixed4 _Color6; float _Percent6;
            fixed4 _Color7; float _Percent7;
            fixed4 _Color8; float _Percent8;
            fixed4 _Color9; float _Percent9;

            float _Layers;
            float _InnerRadius;
            float _FillAmount;
            float _Squash;
            fixed4 _DarkenColor;

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 GetSliceColor(float angle)
            {
                float p[10] = {
                    _Percent0, _Percent1, _Percent2, _Percent3, _Percent4,
                    _Percent5, _Percent6, _Percent7, _Percent8, _Percent9
                };

                fixed4 c[10] = {
                    _Color0, _Color1, _Color2, _Color3, _Color4,
                    _Color5, _Color6, _Color7, _Color8, _Color9
                };

                float total = 0.0;
                for (int i = 0; i < 10; i++)
                {
                    float next = total + p[i];
                    if (angle >= total && angle < next)
                        return c[i];
                    total = next;
                }

                return fixed4(0, 0, 0, 0); // fallback
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float layerCount = _Layers;
                float layerStep = _FillAmount / layerCount;
                float2 uv = i.uv;

                bool hit = false;
                fixed4 finalColor = 0;

                for (int l = 0; l < 128; l++)
                {
                    if (l >= layerCount) break;

                    float offsetY = l * layerStep;
                    float2 centerUV = uv;
                    centerUV.y -= offsetY;
                    centerUV.y += (_FillAmount / _Squash);
                    centerUV = centerUV * 2.0 - 1.0;
                    centerUV.y *= _Squash;

                    float dist = length(centerUV);
                    if (dist > 1.0 || dist < _InnerRadius) continue;

                    float angle = atan2(centerUV.y, centerUV.x);
                    angle = (angle + UNITY_PI) / (2.0 * UNITY_PI);
                    angle = frac(angle + 0.25);
                    angle = 1.0 - angle;

                    fixed4 col = GetSliceColor(angle);

                    if (l == (int)(layerCount - 1))
                        return col;

                    finalColor = col * _DarkenColor;
                    hit = true;
                }

                if (hit) return finalColor;
                discard;
                return _Color9;
            }
            ENDCG
        }
    }

    CustomEditor "PieChartExtruded2DGUI"
}
