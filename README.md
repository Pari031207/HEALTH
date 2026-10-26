# Chronic Disease Risk Dashboard

Early detection and triage platform for Chronic Diseases (Heart Disease, Diabetes, Stroke) built with Tableau, Python, and synthetic clinical patient data.

## Project Structure

```
HEALTH/
├── data/
│   ├── raw_patients_data.csv        # 1,000 raw patient records
│   └── cleaned_patients_data.csv    # Cleaned dataset with derived features (AgeGroup, BMICategory, HighRisk)
├── tableau/
│   ├── chronic_disease_risk.twb     # Tableau workbook (XML)
│   └── chronic_disease_risk.twbx    # Packaged Tableau workbook with bundled data
├── scripts/
│   ├── clean_data.py                # Python/pandas data cleaning script
│   └── generate_data.ps1            # Synthetic dataset generator
├── TABLEAU_BUILD_GUIDE.md           # Step-by-step build spec (Tasks 1-14)
├── INSIGHTS_SUMMARY.md              # Executive clinical & public health summary
└── README.md                        # Project documentation
```

## Dataset & Derived Fields
- **Cohort**: 1,000 patient records with clinical measurements and lifestyle indicators.
- **Features**: `Age`, `Gender`, `BMI`, `BloodPressure`, `Cholesterol`, `Glucose`, `Smoking`, `Alcohol`, `ExerciseLevel`, `Fatigue`, `ChestPain`, `Dizziness`, `Disease`.
- **Derived Fields**:
  - `AgeGroup`: `<30`, `30-44`, `45-59`, `60+`
  - `BMICategory`: `Underweight`, `Normal`, `Overweight`, `Obese`
  - `HighRisk`: `Yes` if vitals exceed thresholds (BP ≥ 140, Chol ≥ 240, Glucose ≥ 140) and patient has diagnosed disease or acute symptoms.

## Persona Dashboards (Tableau)
1. **Clinical Risk Dashboard** (*Dr. Michael Carter*): High-risk patient triage roster, vitals heatmap, and alert KPIs.
2. **Lifestyle Analysis Dashboard** (*Emily Rodriguez*): Behavioral comparisons (smoking, alcohol, exercise) against disease outcomes.
3. **Population Health Dashboard** (*Dr. Priya Nair*): Demographic distribution across age groups, BMI brackets, and symptoms.

## How to Open & View
- **Tableau Desktop / Tableau Public**: Open `tableau/chronic_disease_risk.twbx` directly or follow `TABLEAU_BUILD_GUIDE.md` to replicate the worksheets.

## How to Push to GitHub (`https://github.com/Pari031207/HEALTH.git`)
If git is installed on your computer, run the following in this folder:

```bash
git init
git remote add origin https://github.com/Pari031207/HEALTH.git
git add .
git commit -m "Complete Chronic Disease Risk Dashboard project"
git branch -M main
git push -u origin main --force
```
*(Alternatively, drag and drop the files into GitHub at https://github.com/Pari031207/HEALTH).*
