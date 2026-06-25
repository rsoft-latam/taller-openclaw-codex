#!/usr/bin/env bash
# Edita la web Cafe del Mar con Codex segun una instruccion en lenguaje natural.
# Uso: editar.sh "<instruccion>"
# Nota: codex va por ruta absoluta (el gateway de OpenClaw no tiene homebrew en PATH).
set -euo pipefail

REPO="/Users/ricardopari/Documents/Projects RSoft Latam/Projects Artificial Intelligence/taller-openclaw-codex"
INSTR="${1:?Falta la instruccion. Uso: editar.sh \"<instruccion>\"}"

/opt/homebrew/bin/codex exec --sandbox workspace-write --skip-git-repo-check --cd "$REPO" \
  "$INSTR. Edita solo index.html, styles.css o script.js segun corresponda; manten el estilo y el layout existentes; no rompas el carrusel ni el responsive."
