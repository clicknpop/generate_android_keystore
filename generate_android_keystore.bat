@echo off
REM Set encoding to UTF-8
chcp 65001 >nul
REM Set console font to support Chinese characters
reg add "HKEY_CURRENT_USER\Console\%cd:~0,2%" /v "FaceName" /t REG_SZ /d "新細明體" /f >nul 2>&1
REM Clear screen
cls
echo ========================================
echo Android Keystore Generator Tool
echo ========================================
echo.

REM Check if Java is installed
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Java environment not found, please install Java JDK first
    echo Please visit: https://www.oracle.com/java/technologies/downloads/
    pause
    exit /b 1
)

echo Java environment check passed
echo.

REM Set default values
set /p KEYSTORE_PATH="Enter keystore file path (default: android_release_key.keystore): "
if "%KEYSTORE_PATH%"=="" set KEYSTORE_PATH=android_release_key.keystore

set /p KEY_ALIAS="Enter key alias (default: android_key): "
if "%KEY_ALIAS%"=="" set KEY_ALIAS=android_key

set /p KEY_PASSWORD="Enter key password (default: 123123): "
if "%KEY_PASSWORD%"=="" set KEY_PASSWORD=123123

set /p STORE_PASSWORD="Enter store password (default: 123123): "
if "%STORE_PASSWORD%"=="" set STORE_PASSWORD=123123

set /p VALIDITY="Enter key validity days (default: 36500): "
if "%VALIDITY%"=="" set VALIDITY=36500

set /p COMMON_NAME="Enter common name (default: clicknpop): "
if "%COMMON_NAME%"=="" set COMMON_NAME=clicknpop

set /p ORGANIZATIONAL_UNIT="Enter organizational unit (default: clicknpop): "
if "%ORGANIZATIONAL_UNIT%"=="" set ORGANIZATIONAL_UNIT=clicknpop

set /p ORGANIZATION="Enter organization name (default: clicknpop): "
if "%ORGANIZATION%"=="" set ORGANIZATION=clicknpop

set /p CITY="Enter city (default: Taipei): "
if "%CITY%"=="" set CITY=Taipei

set /p STATE="Enter state/province (default: Taiwan): "
if "%STATE%"=="" set STATE=Taiwan

set /p COUNTRY_CODE="Enter country code (default: TW): "
if "%COUNTRY_CODE%"=="" set COUNTRY_CODE=TW

echo.
echo ========================================
echo Generation Parameters Confirmation
echo ========================================
echo Keystore path: %KEYSTORE_PATH%
echo Key alias: %KEY_ALIAS%
echo Key password: %KEY_PASSWORD%
echo Store password: %STORE_PASSWORD%
echo Validity: %VALIDITY% days
echo Common name: %COMMON_NAME%
echo Organizational unit: %ORGANIZATIONAL_UNIT%
echo Organization: %ORGANIZATION%
echo City: %CITY%
echo State/Province: %STATE%
echo Country code: %COUNTRY_CODE%
echo ========================================
echo.

set /p CONFIRM="Confirm above parameters? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo Operation cancelled
    pause
    exit /b 0
)

echo.
echo Generating Android keystore...
echo.

REM Generate keystore
keytool -genkey -v -keystore "%KEYSTORE_PATH%" -alias "%KEY_ALIAS%" -keyalg RSA -keysize 2048 -validity %VALIDITY% -storepass "%STORE_PASSWORD%" -keypass "%KEY_PASSWORD%" -dname "CN=%COMMON_NAME%, OU=%ORGANIZATIONAL_UNIT%, O=%ORGANIZATION%, L=%CITY%, ST=%STATE%, C=%COUNTRY_CODE%"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Keystore generated successfully!
    echo ========================================
    echo Keystore file: %KEYSTORE_PATH%
    echo Key alias: %KEY_ALIAS%
    echo Validity: %VALIDITY% days
    echo.
    
    REM Ask if need to rename file
    set /p FINAL_NAME="Enter final keystore filename (leave empty to keep original): "
    if not "%FINAL_NAME%"=="" (
        if not "%FINAL_NAME:~-8%"==".keystore" set FINAL_NAME=%FINAL_NAME%.keystore
        ren "%KEYSTORE_PATH%" "%FINAL_NAME%"
        if %errorlevel% equ 0 (
            echo File successfully renamed to: %FINAL_NAME%
            echo.
            echo Please keep safe the following information:
            echo - Keystore file path: %FINAL_NAME%
            echo - Key alias: %KEY_ALIAS%
            echo - Key password: %KEY_PASSWORD%
            echo - Store password: %STORE_PASSWORD%
        ) else (
            echo Warning: File rename failed, please rename manually
            echo.
            echo Please keep safe the following information:
            echo - Keystore file path: %KEYSTORE_PATH%
            echo - Key alias: %KEY_ALIAS%
            echo - Key password: %KEY_PASSWORD%
            echo - Store password: %STORE_PASSWORD%
        )
    ) else (
        echo Please keep safe the following information:
        echo - Keystore file path: %KEYSTORE_PATH%
        echo - Key alias: %KEY_ALIAS%
        echo - Key password: %KEY_PASSWORD%
        echo - Store password: %STORE_PASSWORD%
    )
    echo.
    echo Note: This keystore is used to sign your Android app, please do not lose it!
    echo ========================================
) else (
    echo.
    echo Error: Keystore generation failed, please check parameters
)

echo.
pause
