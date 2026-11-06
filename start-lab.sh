#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$project_dir"
docker compose up --build -d

if command -v gnome-terminal >/dev/null 2>&1; then
  gnome-terminal --title="kali@attacker" -- bash -lc 'cd "$1" && exec docker compose exec --user kali kali bash --rcfile /opt/lab/terminal.bashrc -i' bash "$project_dir" &
  gnome-terminal --title="ubuntu@victim" -- bash -lc 'cd "$1" && exec docker compose exec --user ubuntu ubuntu bash --rcfile /opt/lab/terminal.bashrc -i' bash "$project_dir" &
  echo "Opened kali@attacker and ubuntu@victim terminals."
elif command -v xfce4-terminal >/dev/null 2>&1; then
  xfce4-terminal --title="kali@attacker" --command="docker compose -f '$project_dir/compose.yaml' exec --user kali kali bash --rcfile /opt/lab/terminal.bashrc -i" &
  xfce4-terminal --title="ubuntu@victim" --command="docker compose -f '$project_dir/compose.yaml' exec --user ubuntu ubuntu bash --rcfile /opt/lab/terminal.bashrc -i" &
  echo "Opened kali@attacker and ubuntu@victim terminals."
elif command -v xterm >/dev/null 2>&1; then
  xterm -T "kali@attacker" -e bash -lc "cd '$project_dir' && exec docker compose exec --user kali kali bash --rcfile /opt/lab/terminal.bashrc -i" &
  xterm -T "ubuntu@victim" -e bash -lc "cd '$project_dir' && exec docker compose exec --user ubuntu ubuntu bash --rcfile /opt/lab/terminal.bashrc -i" &
  echo "Opened kali@attacker and ubuntu@victim terminals."
else
  echo "Lab is running. Open two terminals in $project_dir and run:"
  echo "docker compose exec --user kali kali bash --rcfile /opt/lab/terminal.bashrc -i"
  echo "docker compose exec --user ubuntu ubuntu bash --rcfile /opt/lab/terminal.bashrc -i"
fi
