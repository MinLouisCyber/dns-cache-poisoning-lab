@echo off
setlocal
cd /d "%~dp0"

docker compose up --build -d
if errorlevel 1 (
    echo.
    echo Khong khoi dong duoc lab. Hay mo Docker Desktop va thu lai.
    pause
    exit /b 1
)

start "kali@attacker" /D "%~dp0" cmd /k "docker compose exec --user kali kali bash --rcfile /opt/lab/terminal.bashrc -i"
start "ubuntu@victim" /D "%~dp0" cmd /k "docker compose exec --user ubuntu ubuntu bash --rcfile /opt/lab/terminal.bashrc -i"

echo Da mo hai terminal Kali va Ubuntu.
