@echo off
chcp 65001
echo ========================================
echo 编译 plugin_lib SO库
echo ========================================
echo.

REM 设置NDK路径（根据你的实际安装路径修改）
set NDK_HOME=D:\Sdk\Android\ndk\28.2.13676358

REM 检查NDK路径是否存在
if not exist "%NDK_HOME%" (
    echo [错误] NDK路径不存在: %NDK_HOME%
    echo 请修改脚本中的NDK_HOME变量为你的NDK安装路径
    pause
    exit /b 1
)

echo [信息] NDK路径: %NDK_HOME%
echo.

REM 创建build目录
echo [步骤1] 创建build目录...
if not exist "build\arm64-v8a" mkdir "build\arm64-v8a"
if not exist "build\armeabi-v7a" mkdir "build\armeabi-v7a"
if not exist "build\x86" mkdir "build\x86"
if not exist "build\x86_64" mkdir "build\x86_64"
echo [完成] build目录创建完成
echo.

REM 编译arm64-v8a架构
echo [步骤2] 编译 arm64-v8a 架构...
"%NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin\aarch64-linux-android21-clang.cmd" -shared -fPIC plugin_lib.c -o build\arm64-v8a\libplugin_lib.so
if %errorlevel% neq 0 (
    echo [错误] arm64-v8a 编译失败
    pause
    exit /b 1
)
echo [完成] arm64-v8a 编译成功
echo.

REM 编译armeabi-v7a架构
echo [步骤3] 编译 armeabi-v7a 构构...
"%NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin\armv7a-linux-androideabi21-clang.cmd" -shared -fPIC plugin_lib.c -o build\armeabi-v7a\libplugin_lib.so
if %errorlevel% neq 0 (
    echo [错误] armeabi-v7a 编译失败
    pause
    exit /b 1
)
echo [完成] armeabi-v7a 编译成功
echo.

REM 编译x86架构
echo [步骤4] 编译 x86 构构...
"%NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin\i686-linux-android21-clang.cmd" -shared -fPIC plugin_lib.c -o build\x86\libplugin_lib.so
if %errorlevel% neq 0 (
    echo [错误] x86 编译失败
    pause
    exit /b 1
)
echo [完成] x86 编译成功
echo.

REM 编译x86_64架构
echo [步骤5] 编译 x86_64 构构...
"%NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin\x86_64-linux-android21-clang.cmd" -shared -fPIC plugin_lib.c -o build\x86_64\libplugin_lib.so
if %errorlevel% neq 0 (
    echo [错误] x86_64 编译失败
    pause
    exit /b 1
)
echo [完成] x86_64 编译成功
echo.

REM 复制到插件目录
echo [步骤6] 复制SO库到插件目录...
set PLUGIN_DIR=..\..\\load_so_plugin\\android\\src\\main\\jniLibs

REM 复制arm64-v8a
copy /Y "build\arm64-v8a\libplugin_lib.so" "%PLUGIN_DIR%\arm64-v8a\"
if %errorlevel% neq 0 (
    echo [错误] 复制 arm64-v8a 失败
    pause
    exit /b 1
)
echo [完成] arm64-v8a 复制成功

REM 复制armeabi-v7a
copy /Y "build\armeabi-v7a\libplugin_lib.so" "%PLUGIN_DIR%\armeabi-v7a\"
if %errorlevel% neq 0 (
    echo [错误] 复制 armeabi-v7a 失败
    pause
    exit /b 1
)
echo [完成] armeabi-v7a 复制成功

REM 复制x86
copy /Y "build\x86\libplugin_lib.so" "%PLUGIN_DIR%\x86\"
if %errorlevel% neq 0 (
    echo [错误] 复制 x86 失败
    pause
    exit /b 1
)
echo [完成] x86 复制成功

REM 复制x86_64
copy /Y "build\x86_64\libplugin_lib.so" "%PLUGIN_DIR%\x86_64\"
if %errorlevel% neq 0 (
    echo [错误] 复制 x86_64 失败
    pause
    exit /b 1
)
echo [完成] x86_64 复制成功
echo.

echo ========================================
echo [成功] 所有SO库编译和复制完成！
echo ========================================
echo.
echo 编译的SO库已复制到以下目录：
echo %PLUGIN_DIR%
echo.
pause
