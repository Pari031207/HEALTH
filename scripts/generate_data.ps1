$rng = New-Object System.Random(42)
$data = [System.Collections.Generic.List[PSCustomObject]]::new()

$genders = @("Male", "Female")
$smokingVals = @("Yes", "No")
$alcoholVals = @("Frequent", "Occasional", "None")
$exerciseVals = @("Sedentary", "Moderate", "Active")
$binaryVals = @("Yes", "No")

for ($i = 1; $i -le 1000; $i++) {
    $id = "P{0:D4}" -f $i
    $age = $rng.Next(18, 85)
    $gender = $genders[$rng.Next(0, $genders.Count)]
    
    # BMI normally distributed around 27
    $u1 = 1.0 - $rng.NextDouble()
    $u2 = 1.0 - $rng.NextDouble()
    $randStdNormal = [Math]::Sqrt(-2.0 * [Math]::Log($u1)) * [Math]::Sin(2.0 * [Math]::PI * $u2)
    $bmi = [Math]::Round(26.5 + ($randStdNormal * 4.8), 1)
    if ($bmi -lt 16.0) { $bmi = 16.0 }
    if ($bmi -gt 45.0) { $bmi = 45.0 }

    # Lifestyle
    $smoking = if ($rng.NextDouble() -lt 0.28) { "Yes" } else { "No" }
    $alcohol = $alcoholVals[$rng.Next(0, $alcoholVals.Count)]
    $exercise = $exerciseVals[$rng.Next(0, $exerciseVals.Count)]
    
    # Blood pressure depends on age and BMI
    $bpBase = 100 + ($age * 0.4) + (($bmi - 22) * 0.8)
    $bp = [Math]::Round($bpBase + ($rng.NextDouble() * 24 - 12))
    if ($bp -lt 90) { $bp = 90 }
    if ($bp -gt 195) { $bp = 195 }

    # Cholesterol
    $cholBase = 160 + ($age * 0.6) + (if ($smoking -eq "Yes") { 15 } else { 0 })
    $cholesterol = [Math]::Round($cholBase + ($rng.NextDouble() * 30 - 15))
    if ($cholesterol -lt 120) { $cholesterol = 120 }
    if ($cholesterol -gt 310) { $cholesterol = 310 }

    # Glucose
    $gluBase = 85 + (($bmi - 20) * 1.5) + ($age * 0.3)
    $glucose = [Math]::Round($gluBase + ($rng.NextDouble() * 30 - 15))
    if ($glucose -lt 70) { $glucose = 70 }
    if ($glucose -gt 260) { $glucose = 260 }

    # Disease probabilities
    $heartProb = 0.03 + ($age / 350.0) + (if ($smoking -eq "Yes") { 0.08 } else { 0 }) + (if ($bp -ge 140) { 0.09 } else { 0 }) + (if ($cholesterol -ge 240) { 0.08 } else { 0 })
    $diabProb = 0.02 + (if ($bmi -ge 30) { 0.16 } elseif ($bmi -ge 25) { 0.07 } else { 0 }) + (if ($glucose -ge 140) { 0.22 } else { 0 })
    $strokeProb = 0.01 + ($age / 400.0) + (if ($bp -ge 150) { 0.12 } else { 0 }) + (if ($smoking -eq "Yes") { 0.06 } else { 0 })

    $roll = $rng.NextDouble()
    $disease = "None"
    if ($roll -lt $heartProb) {
        $disease = "Heart disease"
    } elseif ($roll -lt ($heartProb + $diabProb)) {
        $disease = "Diabetes"
    } elseif ($roll -lt ($heartProb + $diabProb + $strokeProb)) {
        $disease = "Stroke"
    } else {
        $disease = "None"
    }

    # Symptoms
    $chestProb = if ($disease -eq "Heart disease") { 0.65 } elseif ($bp -ge 150) { 0.30 } else { 0.08 }
    $fatigueProb = if ($disease -ne "None") { 0.58 } elseif ($exercise -eq "Sedentary") { 0.35 } else { 0.15 }
    $dizzyProb = if ($disease -eq "Stroke") { 0.60 } elseif ($bp -ge 160) { 0.40 } else { 0.10 }

    $chestPain = if ($rng.NextDouble() -lt $chestProb) { "Yes" } else { "No" }
    $fatigue = if ($rng.NextDouble() -lt $fatigueProb) { "Yes" } else { "No" }
    $dizziness = if ($rng.NextDouble() -lt $dizzyProb) { "Yes" } else { "No" }

    # Derived: AgeGroup (<30, 30-44, 45-59, 60+)
    $ageGroup = if ($age -lt 30) { "<30" }
                elseif ($age -le 44) { "30-44" }
                elseif ($age -le 59) { "45-59" }
                else { "60+" }

    # Derived: BMICategory (Underweight/Normal/Overweight/Obese)
    $bmiCategory = if ($bmi -lt 18.5) { "Underweight" }
                   elseif ($bmi -lt 25.0) { "Normal" }
                   elseif ($bmi -lt 30.0) { "Overweight" }
                   else { "Obese" }

    # Derived: HighRisk (high BP >= 140, cholesterol >= 240, or glucose >= 140 PLUS disease != 'None' or any symptom)
    $hasVitalsRisk = ($bp -ge 140) -or ($cholesterol -ge 240) -or ($glucose -ge 140)
    $hasClinicalCond = ($disease -ne "None") -or ($chestPain -eq "Yes") -or ($fatigue -eq "Yes") -or ($dizziness -eq "Yes")
    $highRisk = if ($hasVitalsRisk -and $hasClinicalCond) { "Yes" } else { "No" }

    $data.Add([PSCustomObject]@{
        PatientID = $id
        Age = $age
        Gender = $gender
        BMI = $bmi
        BloodPressure = $bp
        Cholesterol = $cholesterol
        Glucose = $glucose
        Smoking = $smoking
        Alcohol = $alcohol
        ExerciseLevel = $exercise
        Fatigue = $fatigue
        ChestPain = $chestPain
        Dizziness = $dizziness
        Disease = $disease
        AgeGroup = $ageGroup
        BMICategory = $bmiCategory
        HighRisk = $highRisk
    })
}

$cleanPath = "C:\Users\Priyanshi\.gemini\antigravity\scratch\HEALTH\data\cleaned_patients_data.csv"
$data | Export-Csv -Path $cleanPath -NoTypeInformation -Encoding utf8

# Also create raw data (without derived columns)
$rawPath = "C:\Users\Priyanshi\.gemini\antigravity\scratch\HEALTH\data\raw_patients_data.csv"
$data | Select-Object PatientID, Age, Gender, BMI, BloodPressure, Cholesterol, Glucose, Smoking, Alcohol, ExerciseLevel, Fatigue, ChestPain, Dizziness, Disease | Export-Csv -Path $rawPath -NoTypeInformation -Encoding utf8

Write-Output "Successfully generated $($data.Count) patient records."
