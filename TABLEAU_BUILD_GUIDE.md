# Chronic Disease Risk Dashboard – Tableau Step-by-Step Build Guide

This guide provides exact calculated fields, chart shelf placements, formatting, and dashboard layouts for Tableau Desktop and Tableau Public (Tasks 1–14).

---

## E1: Data Preparation
- **Raw File**: `data/raw_patients_data.csv` (1,000 patient records).
- **Cleaned File**: `data/cleaned_patients_data.csv` (No nulls, validated ranges).
- **Derived Fields**:
  - `AgeGroup`: `<30`, `30-44`, `45-59`, `60+`
  - `BMICategory`: `Underweight` (<18.5), `Normal` (18.5–24.9), `Overweight` (25.0–29.9), `Obese` (30.0+)
  - `HighRisk`: `Yes` if (BloodPressure ≥ 140 OR Cholesterol ≥ 240 OR Glucose ≥ 140) AND (Disease ≠ 'None' OR ChestPain = 'Yes' OR Fatigue = 'Yes' OR Dizziness = 'Yes'), else `No`.

---

## E2: Connect Data in Tableau (Task 3)
1. Open Tableau Desktop / Tableau Public.
2. Select **Connect > To a File > Text file** and choose `data/cleaned_patients_data.csv`.
3. Verify Field Roles & Data Types:
   - **Dimensions (Strings)**: `PatientID`, `Gender`, `Smoking`, `Alcohol`, `ExerciseLevel`, `Fatigue`, `ChestPain`, `Dizziness`, `Disease`, `AgeGroup`, `BMICategory`, `HighRisk`.
   - **Measures (Numbers)**: `Age` (Int), `BMI` (Decimal), `BloodPressure` (Int), `Cholesterol` (Int), `Glucose` (Int).

---

## Calculated Fields Setup
Create these 4 Calculated Fields in Tableau (**Analysis > Create Calculated Field**):

1. **High Risk Flag Num**:
   ```tableau
   IIF([HighRisk] = "Yes", 1, 0)
   ```
2. **Disease Flag Num**:
   ```tableau
   IIF([Disease] != "None", 1, 0)
   ```
3. **High Risk %**:
   ```tableau
   SUM([HighRisk Flag Num]) / COUNT([PatientID])
   ```
   *(Format: Percentage, 1 decimal place)*
4. **Disease Prevalence %**:
   ```tableau
   SUM([Disease Flag Num]) / COUNT([PatientID])
   ```
   *(Format: Percentage, 1 decimal place)*

---

## E3: KPI Cards (Task 4)
**Sheet Name:** `KPI_Cards`
- **Columns**: `Measure Names`
- **Text / Label**: `Measure Values`
- **Filter `Measure Names` to**:
  1. `CNT(PatientID)` (Total Patients: **1,000**)
  2. `AGG(High Risk %)` (**8.0%**)
  3. `AGG(Disease Prevalence %)` (**43.9%**)
  4. `AVG(BMI)` (**26.5**)
  5. `AVG(BloodPressure)` (**123.9 mmHg**)
- **Mark Type**: Text / Square KPI tile.

---

## E4: Disease Prevalence (Tasks 5–6)

### Task 5: Prevalence by Age Group
- **Sheet Name**: `Prevalence_by_AgeGroup`
- **Columns**: `CNT(PatientID)`
- **Rows**: `AgeGroup` (Sort: `<30`, `30-44`, `45-59`, `60+`)
- **Color**: `Disease` (Heart disease: Red/Coral `#E15759`, Diabetes: Blue `#4E79A7`, Stroke: Orange `#F28E2B`, None: Grey `#BAB0AC`)
- **Mark**: Horizontal Bar.
- **Label**: Show `CNT(PatientID)`.

### Task 6: Prevalence by BMI Category
- **Sheet Name**: `Prevalence_by_BMICategory`
- **Columns**: `BMICategory` (Sort: `Underweight`, `Normal`, `Overweight`, `Obese`)
- **Rows**: `CNT(PatientID)`
- **Color**: `Disease`
- **Mark**: Stacked Vertical Bar.
- **Label**: Percent of Total across BMICategory.

---

## E5: Risk Factors (Tasks 7–8)

### Task 7: Risk Factors Heatmap
- **Sheet Name**: `Risk_Factor_Heatmap`
- **Columns**: `Measure Names` (Filtered to: `AVG(BloodPressure)`, `AVG(Cholesterol)`, `AVG(Glucose)`)
- **Rows**: `Disease`
- **Color**: `Measure Values` (Color Palette: Red-Blue Diverging or Orange-Blue, Reversed).
- **Mark**: Square.
- **Label**: `Measure Values` (rounded to 1 decimal).

### Task 8: Lifestyle Comparison vs Disease
- **Sheet Name**: `Lifestyle_vs_Disease`
- **Columns**: `Smoking`, `ExerciseLevel`
- **Rows**: `CNT(PatientID)`
- **Color**: `Disease`
- **Mark**: Bar chart.

---

## E6: Symptoms & Patient Line-List (Tasks 9–10)

### Task 9: Symptom Prevalence
- **Sheet Name**: `Symptom_Prevalence`
- **Columns**: `Measure Names` (`ChestPain`, `Fatigue`, `Dizziness`)
- **Rows**: Count of positive responses (`Yes`).
- **Color**: `HighRisk` (High Risk: `#E15759`, Normal: `#76B7B2`).
- **Mark**: Bar chart.

### Task 10: High-Risk Patient Table
- **Sheet Name**: `High_Risk_Patient_Table`
- **Filter**: Drag `HighRisk` to Filters shelf and select **Yes**.
- **Rows**: `PatientID`, `Age`, `Gender`, `BMI`, `BloodPressure`, `Cholesterol`, `Glucose`, `Disease`, `ChestPain`, `Fatigue`, `Dizziness`.
- **Sorting**: Enable sort descending by `BloodPressure` or `Glucose`.
- **Mark**: Text.

---

## E7: Dashboards (Tasks 11–13)
*Size: Fixed 1200 x 850 px.*

### Dashboard 1: Clinical Risk
**Target Persona**: Dr. Michael Carter (Risk Assessment Officer)
- **Header**: "Clinical Risk & Patient Triage Dashboard"
- **Top Row**: KPI Cards (`Total Patients`, `High Risk %`, `Avg BP`, `Avg BMI`).
- **Middle Row**: `Risk_Factor_Heatmap` (left), `Prevalence_by_AgeGroup` (right).
- **Bottom**: `High_Risk_Patient_Table` (Interactive sortable line-list for immediate intervention).

### Dashboard 2: Lifestyle Analysis
**Target Persona**: Emily Rodriguez (Data Analyst)
- **Header**: "Lifestyle & Modifiable Risk Factors Deep-Dive"
- **Top Row**: `Lifestyle_vs_Disease` (Smoking & Exercise cross-tabulation).
- **Middle Row**: `Prevalence_by_BMICategory`.
- **Bottom Row**: `Risk_Factor_Heatmap` + Scatter plot of `BMI` vs `BloodPressure`.

### Dashboard 3: Population Health
**Target Persona**: Dr. Priya Nair (Public Health Researcher)
- **Header**: "Population Health & Preventive Epidemiology"
- **Top Row**: KPI Cards + Disease Prevalence % by Demographic.
- **Middle Row**: `Prevalence_by_AgeGroup` and `Prevalence_by_BMICategory`.
- **Bottom Row**: `Symptom_Prevalence` by Exercise Level.

---

## E8: Interactivity, Filters & Publish (Task 14)
1. **Interactive Shared Filters**:
   - Add filters for `AgeGroup`, `BMICategory`, and `Disease` to all dashboards.
   - Configure: Click filter menu > **Apply to Worksheets > All Using This Data Source**.
2. **Dashboard Filter Actions**:
   - Go to **Dashboard > Actions > Add Action > Filter**.
   - Set source sheet (e.g. `Prevalence_by_AgeGroup`), target sheets (all other sheets), Run action on **Select**.
3. **Publish to Tableau Public / Tableau Cloud**:
   - Select **Server > Tableau Public > Save to Tableau Public As...**
   - Sign in with Tableau Public account credentials.
   - Publish workbook as `Chronic Disease Risk Dashboard`.
