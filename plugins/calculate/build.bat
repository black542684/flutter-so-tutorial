@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   Flutter SO库编译脚本
echo ========================================
echo.

set "NDK_PATH=D:\Sdk\Android\ndk\28.2.13676358"
set "PROJECT_DIR=%~dp0"
set "PROJECT_DIR=%PROJECT_DIR:~0,-1%"
set "ANDROID_DIR=%PROJECT_DIR%\..\..\android"
set "JNILIBS_DIR=%ANDROID_DIR%\app\src\main\jniLibs"

echo 项目目录: %PROJECT_DIR%
echo JNI库目录: %JNILIBS_DIR%
echo.

if not exist "%NDK_PATH%\build\cmake\android.toolchain.cmake" (
    echo 错误: 找不到Android NDK！
    echo NDK路径: %NDK_PATH%
    echo.
    pause
    exit /b 1
)

echo 使用NDK路径: %NDK_PATH%
echo.

set "TOOLCHAIN_FILE=%NDK_PATH%\build\cmake\android.toolchain.cmake"

echo 开始编译...
echo.

set SUCCESS_COUNT=0
set FAILED_ARCHS=

echo ----------------------------------------
echo 编译架构: arm64-v8a
echo ----------------------------------------
call :compile_arch arm64-v8a
if errorlevel 1 set FAILED_ARCHS=!FAILED_ARCHS! arm64-v8a

echo ----------------------------------------
echo 编译架构: armeabi-v7a
echo ----------------------------------------
call :compile_arch armeabi-v7a
if errorlevel 1 set FAILED_ARCHS=!FAILED_ARCHS! armeabi-v7a

echo ----------------------------------------
echo 编译架构: x86_64
echo ----------------------------------------
call :compile_arch x86_64
if errorlevel 1 set FAILED_ARCHS=!FAILED_ARCHS! x86_64

echo ----------------------------------------
echo 编译架构: x86
echo ----------------------------------------
call :compile_arch x86
if errorlevel 1 set FAILED_ARCHS=!FAILED_ARCHS! x86

echo ========================================
echo   编译完成
echo ========================================
echo.
echo 成功: %SUCCESS_COUNT%/4

if not "%FAILED_ARCHS%"=="" (
    echo 失败的架构:%FAILED_ARCHS%
)

echo.
echo SO库输出目录: %JNILIBS_DIR%
echo.

if %SUCCESS_COUNT%==4 (
    echo 所有架构编译成功！
    pause
    exit /b 0
) else (
    echo 部分架构编译失败，请检查错误信息！
    pause
    exit /b 1
)

:compile_arch
set "ABI=%1"
set "BUILD_DIR=%PROJECT_DIR%\build\%ABI%"
set "OUTPUT_DIR=%JNILIBS_DIR%\%ABI%"

if exist "%BUILD_DIR%" (
    rmdir /s /q "%BUILD_DIR%"
)
mkdir "%BUILD_DIR%"

cd /d "%BUILD_DIR%"

echo 运行CMake配置...
cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE="%TOOLCHAIN_FILE%" -DANDROID_ABI=%ABI% -DANDROID_PLATFORM=android-21 "%PROJECT_DIR%"
if errorlevel 1 (
    echo CMake配置失败！
    cd /d "%PROJECT_DIR%"
    exit /b 1
)

echo 运行Ninja编译...
ninja
if errorlevel 1 (
    echo Ninja编译失败！
    cd /d "%PROJECT_DIR%"
    exit /b 1
)

if not exist "%BUILD_DIR%\libcalculate.so" (
    echo 错误: 找不到编译输出的so文件: %BUILD_DIR%\libcalculate.so
    cd /d "%PROJECT_DIR%"
    exit /b 1
)

if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
)

copy "%BUILD_DIR%\libcalculate.so" "%OUTPUT_DIR%" >nul
echo 成功编译并复制到: %OUTPUT_DIR%

set /a SUCCESS_COUNT+=1

cd /d "%PROJECT_DIR%"
echo.

exit /b 0
