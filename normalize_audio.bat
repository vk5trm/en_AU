@echo off
REM ============================================================================
REM Audio File Normalization Script for SVXLink
REM Description: Searches each directory for WAV files and normalizes them
REM              to -20 dB RMS at 16kHz sample rate using SoX
REM Requirements: SoX executable in same directory or in PATH
REM ============================================================================

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "TARGET_RMS=-9"
set "SAMPLE_RATE=16000"
set "OUTPUT_FORMAT=16"

set "SOX_PATH="

if exist "%SCRIPT_DIR%sox.exe" (
    set "SOX_PATH=%SCRIPT_DIR%sox.exe"
    echo Found SoX in script directory
) else if exist "%SCRIPT_DIR%sox\sox.exe" (
    set "SOX_PATH=%SCRIPT_DIR%sox\sox.exe"
    echo Found SoX in sox subdirectory
) else (
    for /f "delims=" %%A in ('where sox 2^>nul') do set "SOX_PATH=%%A"
)

echo.
echo ============================================================================
echo Audio File Normalization Utility
echo ============================================================================
echo Script Directory: %SCRIPT_DIR%
echo Target RMS Level: %TARGET_RMS% dB
echo Sample Rate: %SAMPLE_RATE% Hz
echo Output Format: %OUTPUT_FORMAT%-bit
echo.

if "!SOX_PATH!"=="" (
    echo ERROR: SoX not found!
    echo.
    echo Solutions:
    echo 1. Install SoX globally: http://sox.sourceforge.net/
    echo 2. Place sox.exe in the same directory as this script
    echo 3. Create a "sox" subdirectory and place sox.exe there
    echo.
    pause
    exit /b 1
)

echo SoX found at: !SOX_PATH!
"!SOX_PATH!" --version
echo.
echo Proceeding with normalization...
echo.

set "TOTAL_FILES=0"
set "PROCESSED_FILES=0"
set "ERROR_FILES=0"

cd /d "%SCRIPT_DIR%"

for /d %%D in (Core Default DtmfRepeater EchoLink Frn Help MetarInfo Parrot PropagationMonitor SelCallEnc TclVoiceMail Trx) do (
    if exist "%%D" (
        echo.
        echo Processing directory: %%D
        echo -----------------------------------------------
        
        pushd "%%D"
        
        for /r . %%F in (*.wav) do (
            set /a TOTAL_FILES+=1
            set "INFILE=%%F"
            set "OUTFILE=%%~nF.temp"
            
            echo Processing: %%~nF
            
            "!SOX_PATH!" "!INFILE!" -b %OUTPUT_FORMAT% -r %SAMPLE_RATE% -D "!OUTFILE!.wav" gain -n %TARGET_RMS% 2>nul
            
            if errorlevel 1 (
                echo   [ERROR] Failed to process %%~nF
                if exist "!OUTFILE!.wav" del "!OUTFILE!.wav"
                set /a ERROR_FILES+=1
            ) else (
                del "!INFILE!"
                ren "!OUTFILE!.wav" "%%~nF"
                echo   [OK] Normalized and saved
                set /a PROCESSED_FILES+=1
            )
        )
        
        popd
    ) else (
        echo Directory not found: %%D (skipping)
    )
)

echo.
echo ============================================================================
echo Processing Complete
echo ============================================================================
echo Total files found:     !TOTAL_FILES!
echo Successfully processed: !PROCESSED_FILES!
echo Errors encountered:    !ERROR_FILES!
echo ============================================================================
echo.

pause
endlocal
