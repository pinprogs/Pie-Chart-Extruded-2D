# Pie Chart Extruded 2D

이 프로젝트는 **Unity UI** 환경에서 사용할 수 있는 간단한 **2.5D Pie / Donut Chart 셰이더 예제**입니다.  
실제 3D 메시를 생성하지 않고, **Shader 기반으로 원형 차트와 두께감(Extrusion)** 을 표현합니다.

<img width="800" height="500" alt="image" src="https://github.com/user-attachments/assets/7a950c49-931c-4230-8a10-c2b2700a2fa8" />
<img width="800" height="420" alt="image" src="https://github.com/user-attachments/assets/af46fbe9-9052-4ead-af07-9303eaa9eb94" />


## 특징

- **Pie Chart / Donut Chart** 둘 다 표현할 수 있습니다.
- 기본적으로 최대 **10개 Slice**를 지원하며, 이 수치는 **코드 수정으로 확장할 수 있습니다.**
- 각 Slice의 **색상과 비율**을 개별적으로 설정할 수 있습니다.
- `Inner Radius` 값으로 **도넛 형태의 중앙 구멍 크기**를 조절할 수 있습니다.
- `Extrude Layers`, `Fill Height`, `Y Squash` 값으로 **2.5D 두께감**을 조절할 수 있습니다.
- `Darken Color`를 이용해 측면을 더 어둡게 표현할 수 있습니다.
- `ShaderGUI` 기반의 **커스텀 머티리얼 인스펙터**가 포함되어 있어 Unity Inspector에서 바로 조정할 수 있습니다.

## 동작 방식

이 프로젝트는 실제 원형 메시를 생성하는 대신,  
UI 이미지의 UV 좌표를 기준으로 **반지름 거리와 각도(angle)** 를 계산하여 각 Slice의 색상을 결정합니다.

또한 프래그먼트 셰이더 내부에서 여러 레이어를 아래 방향으로 누적해 검사함으로써,  
차트가 위에서 아래로 두께를 가진 것처럼 보이는 **Extruded 2D 표현**을 만듭니다.

즉, 복잡한 모델링 없이  
**하나의 셰이더와 머티리얼만으로 2.5D 원형 차트**를 구현하는 구조입니다.

## 구현 개요

### `PieChartExtruded2D.shader`
차트의 각도, 반지름, 내부 반경을 계산해 Slice 색상을 결정하고,  
레이어 반복을 통해 두께감이 있는 Pie / Donut Chart를 표현합니다.

### `PieChartExtruded2DGUI.cs`
각 Slice의 색상과 비율, 그리고 Extrude 관련 옵션을  
Unity Inspector에서 편하게 수정할 수 있도록 커스텀 GUI를 제공합니다.

### `PieChartExtruded2D.mat`
기본 **Pie Chart** 프리셋 머티리얼입니다.

### `DonutChartExtruded2D.mat`
`Inner Radius`가 적용된 기본 **Donut Chart** 프리셋 머티리얼입니다.

## 사용 방법

1. 프로젝트를 Unity에서 엽니다.
2. `Assets/Materials` 폴더의 머티리얼을 확인합니다.
3. `PieChartExtruded2D.mat` 또는 `DonutChartExtruded2D.mat`를 UI 오브젝트에 적용합니다.
4. Inspector에서 Slice 색상, 비율, 두께 값을 조정합니다.

## 조절 가능한 값

- **Slice 0 ~ 9 Color**: 각 조각의 색상
- **Slice 0 ~ 9 Percent**: 각 조각의 비율
- **Extrude Layers**: 두께 표현을 위한 레이어 수
- **Inner Radius**: 도넛 형태의 중앙 구멍 크기
- **Fill Height**: 차트의 세로 두께
- **Y Squash**: 세로 압축 비율
- **Darken Color**: 측면 음영 색상

## 제한 사항

- 현재 기본 구성은 **최대 10개 Slice** 기준입니다.
- Slice 개수는 셰이더와 커스텀 GUI를 함께 수정해야 확장할 수 있습니다.
- 실제 3D 메시가 아니라 **시각적으로 두께를 표현하는 2.5D 방식**입니다.

## 개발 환경

- **Unity 6** (`6000.3.9f1`)
- **UGUI 기반 Shader 예제**
