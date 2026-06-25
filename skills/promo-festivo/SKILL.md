---
name: promo-festivo
description: "Genera un banner APAISADO de promocion en Canva (formato horizontal) y lo publica como un slide DENTRO del carrusel de la web Cafe del Mar. Usala cuando el usuario pida una promo de un dia festivo o una oferta para la web, p. ej. 'haz la promo del Dia de la Madre', 'pon una promo 2x1 en la web'."
version: 10.0.0
category: "Marketing"
metadata: {"openclaw":{"emoji":"🎉"}}
---

# Promo Festivo -> Carrusel (Canva apaisado -> web) 🎉

Disena en Canva un banner HORIZONTAL y lo publica como un SLIDE del carrusel del hero de la web
Cafe del Mar. Las tools `canva__*` las llamas tu (abajo); la descarga (curl) y la edicion de codigo
(codex) viven en `scripts/publish.sh`. Detalles de formato/medidas en `references/canva-formato.md`.
Completa TODOS los pasos en una sola corrida, sin detenerte ni pedir confirmacion.

## Cuando activarte
- "haz la promo del Dia de la Madre"
- "pon una promo 2x1 en la web"
- "crea una oferta de Navidad para la cafeteria"

## Datos por defecto (si el usuario no los da)
- Festividad: Dia de la Madre
- Oferta: 2x1 esta semana

## Pasos OBLIGATORIOS (en orden, sin parar)

1. Determina FESTIVIDAD y OFERTA (usa los defaults si faltan).

2. `canva__generate-design` con **`design_type: "youtube_thumbnail"`** (HORIZONTAL; NUNCA
   instagram_post/your_story/pinterest_pin, que salen verticales). En `query`: banner promocional
   para FESTIVIDAD con el texto de la OFERTA legible, estilo cafeteria, paleta cafe/terracota/crema,
   texto y elementos CENTRADOS con margenes (zona segura).

3. `canva__get-design-candidates` + `canva__create-design-from-candidate` -> obtienes un `design_id` (empieza con "D").

4. `canva__resize-design` sobre ese `design_id` con
   `design_type: { "type": "custom", "width": 1920, "height": 820 }` (aspecto exacto del hero).

5. `canva__export-design` en PNG -> extrae la URL de descarga del PNG.

6. Publica con la herramienta `exec` ejecutando el script (pasa URL, festividad y oferta entre comillas):
   `bash "/Users/ricardopari/.openclaw/workspace/skills/promo-festivo/scripts/publish.sh" "URL_DEL_EXPORT" "FESTIVIDAD" "OFERTA"`

7. Responde breve: que la promo de FESTIVIDAD ya quedo como slide del carrusel y pide refrescar.

## Reglas
- La imagen DEBE ser APAISADA (design_type `youtube_thumbnail` + resize a 1920x820). Ver `references/canva-formato.md`.
- Para descargar/editar usa SOLO `scripts/publish.sh` (curl + codex). No uses python.
- NO te detengas hasta terminar el paso 7. No pidas confirmacion entre pasos.
- Idempotente: si ya existe el slide hero-slide-promo, solo se refresca la imagen (no se duplica).
- Un solo festivo por ejecucion.
