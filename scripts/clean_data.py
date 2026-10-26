"""
Data Cleaning and Feature Engineering Script for Chronic Disease Risk Dashboard
Epic 1: Data Preparation & Derived Fields
"""
import pandas as pd
import numpy as np

def clean_and_derive_data(input_csv="data/raw_patients_data.csv", output_csv="data/cleaned_patients_data.csv"):
    df = pd.read_csv(input_csv)
    
    # 1. Check & Handle missing values and duplicates
    df = df.drop_duplicates()
    df['BMI'] = df['BMI'].fillna(df['BMI'].median())
    df['BloodPressure'] = df['BloodPressure'].fillna(df['BloodPressure'].median())
    df['Cholesterol'] = df['Cholesterol'].fillna(df['Cholesterol'].median())
    df['Glucose'] = df['Glucose'].fillna(df['Glucose'].median())
    
    # 2. Derive AgeGroup
    bins_age = [0, 29, 44, 59, 120]
    labels_age = ['<30', '30-44', '45-59', '60+']
    df['AgeGroup'] = pd.cut(df['Age'], bins=bins_age, labels=labels_age, right=True)
    
    # 3. Derive BMICategory
    bins_bmi = [0, 18.49, 24.99, 29.99, 100]
    labels_bmi = ['Underweight', 'Normal', 'Overweight', 'Obese']
    df['BMICategory'] = pd.cut(df['BMI'], bins=bins_bmi, labels=labels_bmi, right=True)
    
    # 4. Derive HighRisk Flag
    # High risk: High BP (>=140) OR Cholesterol (>=240) OR Glucose (>=140)
    # AND Disease != 'None' OR any acute symptom (ChestPain=='Yes' | Fatigue=='Yes' | Dizziness=='Yes')
    vitals_risk = (df['BloodPressure'] >= 140) | (df['Cholesterol'] >= 240) | (df['Glucose'] >= 140)
    clinical_risk = (df['Disease'] != 'None') | (df['ChestPain'] == 'Yes') | (df['Fatigue'] == 'Yes') | (df['Dizziness'] == 'Yes')
    df['HighRisk'] = np.where(vitals_risk & clinical_risk, 'Yes', 'No')
    
    df.to_csv(output_csv, index=False)
    print(f"Data successfully cleaned and saved to {output_csv}. Total records: {len(df)}")

if __name__ == "__main__":
    clean_and_derive_data()
