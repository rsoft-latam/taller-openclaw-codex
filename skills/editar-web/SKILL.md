---
name: editar-web
description: "Edita la web Cafe del Mar con Codex a partir de una instruccion en lenguaje natural (textos, colores, secciones, menu, footer). Usala cuando el usuario pida un cambio de codigo en la web que NO necesite generar imagenes, p. ej. 'cambia el boton a verde', 'agrega un item al menu', 'cambia el horario del footer', 'pon el telefono en negrita'."
version: 2.0.0
category: "Desarrollo"
metadata: {"openclaw":{"emoji":"🛠️"}}
---

# Editar web con Codex 🛠️

Aplica un cambio de codigo en la web Cafe del Mar (HTML/CSS/JS) usando Codex. Skill BASICA:
no usa Canva ni genera imagenes. La logica de Codex vive en `scripts/editar.sh`.
Completa el cambio en una sola corrida, sin pedir confirmacion.

## Cuando activarte
- "cambia el boton de 'Ver menu' a color verde"
- "agrega un item al menu: Te Chai 3.50"
- "cambia el horario del footer a 7am-9pm"
- "pon el titulo del hero mas grande"

## Pasos OBLIGATORIOS
1. Toma la INSTRUCCION del usuario tal cual (que cambiar y como).
2. Ejecuta el script con la herramienta `exec` (pasa la instruccion entre comillas):
   `bash "/Users/ricardopari/.openclaw/workspace/skills/editar-web/scripts/editar.sh" "INSTRUCCION_DEL_USUARIO"`
3. Responde breve: que el cambio ya quedo en la web y pide refrescar.

## Reglas
- NO te detengas hasta terminar el paso 3. No pidas confirmacion.
- Usa SOLO `scripts/editar.sh` para editar (no generes imagenes; para eso esta `promo-festivo`).
- No toques archivos fuera del repo.
