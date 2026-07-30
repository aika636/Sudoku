#!/usr/bin/env bash
# Заливает текущее рабочее дерево Sudoku на тестовый SillyTavern, который крутится
# в докере на home-services. После запуска достаточно хардрелоада вкладки
# http://10.10.10.20:8800
set -euo pipefail

HOST="${SUDOKU_HOST:-home-services}"
# Per-user каталог расширений (ST 1.18: type 'local'). Только он лежит на смонтированном
# томе — public/scripts/extensions/third-party внутри контейнера обнуляется при
# обновлении образа.
EXT_DIR="/srv/dockers/sillytavern/data/default-user/extensions"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$HOME/.ssh/agent.sock}"

echo "→ Sudoku → $HOST:$EXT_DIR/Sudoku"
rsync -az --delete \
    --exclude '.git' --exclude '.claude' --exclude '.gitignore' \
    --exclude 'docs' --exclude 'deploy.sh' --exclude 'node_modules' \
    --exclude 'CLAUDE.md' --exclude 'AGENTS.md' \
    --exclude 'tests' --exclude 'package-lock.json' \
    --exclude '.ai' --exclude '.mcp.json' --exclude '.agents' --exclude '.codex' --exclude '.serena' \
    "$SRC/" "$HOST:$EXT_DIR/Sudoku/"

echo "✓ готово — хардрелоад http://10.10.10.20:8800"
