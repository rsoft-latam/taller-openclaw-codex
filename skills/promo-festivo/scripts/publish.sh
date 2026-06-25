#!/usr/bin/env bash
# Baja el PNG exportado de Canva y publica el banner como un slide del carrusel.
# Uso: publish.sh "<URL_DEL_EXPORT>" "<FESTIVIDAD>" "<OFERTA>"
# - curl: tiene red (descarga el PNG).  - codex: edita el codigo (inserta el slide).
set -euo pipefail

REPO="/Users/ricardopari/Documents/Projects RSoft Latam/Projects Artificial Intelligence/taller-openclaw-codex"
URL="${1:?Falta la URL del export de Canva}"
FEST="${2:-Dia de la Madre}"
OFERTA="${3:-2x1 esta semana}"
IMG="$REPO/assets/promo-banner.png"

# 1) Descargar el banner exportado (la imagen debe ser APAISADA: ver references/canva-formato.md)
curl -L --create-dirs -o "$IMG" "$URL"
file "$IMG" | grep -qi 'PNG image data' || { echo "ERROR: no se descargo un PNG valido"; exit 1; }

# 2) Publicar como slide dentro del carrusel (con su dot) usando Codex
/opt/homebrew/bin/codex exec --sandbox workspace-write --skip-git-repo-check --cd "$REPO" \
  "En index.html, dentro del contenedor .js-carousel: si NO existe un slide con clase hero-slide-promo, agregalo como ultimo slide con <div class='hero-slide js-slide hero-slide-promo' aria-label='Promo $FEST'></div> y agrega al final de .hero-dots un <button class='js-dot' type='button' aria-label='Mostrar promo $FEST'></button>; si YA existe, no lo dupliques. En styles.css crea o actualiza: .hero-slide-promo { background: url('assets/promo-banner.png') center/cover; } y .hero-slide-promo::before { display: none; }. NO modifiques script.js (el carrusel ya es dinamico). Manten intacto el resto del layout y el responsive."

echo "OK: banner de '$FEST' ($OFERTA) publicado en el carrusel."
