@echo off
TITLE BiciPredict Coruna - Automated Pipeline
COLOR 0A

echo ========================================================
echo   BICIPREDICT CORUNA - AUTOMATED ANALYSIS PIPELINE
echo ========================================================
echo.
echo Installing dependencies...
pip install -r requirements.txt > nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install dependencies. Check your Python installation.
    pause
    exit /b
)
echo [OK] Dependencies ready.
echo.

echo [1/3] Running Threshold Optimization Experiment...
echo       Determining optimal "empty" definition (< 2 vs < 5 bikes)
python -m src.models.compare_thresholds
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Threshold experiment failed.
    pause
    exit /b
)
echo.
echo Press any key to continue to Model Comparison...
pause > nul

echo.
echo [2/3] Running Transfer Learning Analysis...
echo       Comparing Local Model (Coruna) vs Pre-trained (Barcelona)
python -m src.models.compare_classifiers
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Model comparison failed.
    pause
    exit /b
)
echo.
echo Press any key to generate final visualizations...
pause > nul

echo.
echo [3/4] Training Final Production Model...
echo       Training LightGBM on full dataset (Horizon: 30 min)
python -m src.models.classifier_final
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Model training failed.
    pause
    exit /b
)
echo.
echo Press any key to generate final visualizations...
pause > nul

echo.
echo [4/4] Generating Advanced Analytics & Maps...
echo       Creating Flow Map and Station Clusters
python -m src.evaluation.analisis_avanzado
echo       Generating Scientific Plots (Elbow & Heatmaps)...
python src/evaluation/analisis_codo.py
python src/visualization/storytelling_plots.py
echo       Generating Business Impact Report (ROI)...
python -m src.evaluation.impacto_negocio
echo       Compiling Final Technical Report...
python -m src.evaluation.analisis_bicicoruna
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Analytics generation failed.
    pause
    exit /b
)

echo.
echo ========================================================
echo   PIPELINE COMPLETED SUCCESSFULLY!
echo ========================================================
echo.
echo check 'ANALYSIS_REPORT.md' for insights.
echo check 'dashboard/mapa_flujos.html' for visual results.
echo.
pause
