# taller-openclaw-codex

Demo del taller **"Desarrollo de Agentes Inteligentes con OpenClaw y Codex"** (Data Science Research Perú, 24 jun 2026).

Web de prueba: landing estática **"Café del Mar"** (HTML/CSS/JS plano, sin frameworks).
Demo estrella: desde **Telegram** le pides una promo y un agente (OpenClaw + Canva + Codex) **edita la web solo**.

---

## Stack de esta corrida

| Pieza | Valor |
|---|---|
| OS | macOS (Apple Silicon) |
| Node | v24.18.0 (nvm) — OpenClaw exige **≥ 22.19** |
| OpenClaw | 2026.6.9 (npm global bajo nvm) |
| Codex | Homebrew (`brew install codex`) — login con cuenta ChatGPT Plus |
| Canal | Telegram (bot de @BotFather) |
| Modelo orquestador | **`openai/gpt-5.4-mini`** (primary) + fallback `openai/gpt-5.5` — runtime nativo `openclaw` |
| Bot | `@example_taller_bot` (el tuyo de @BotFather) |

> ⚠️ **OpenClaw es npm** (bajo nvm). **Codex es brew.** No confundir.

---

## Setup desde cero (en orden del taller)

> 📝 **Placeholders** (reemplázalos por los tuyos): `<RUTA_DEL_REPO>` = la ruta donde clonaste este
> repo (ej. `~/taller-openclaw-codex`; si tiene espacios, mantenlo entre comillas) · `<TU_CODE>` = el
> código que da `openclaw pairing list` · `@example_taller_bot` = el username de tu bot de @BotFather.

### 1. Prerrequisitos

**1.a) Node ≥ 22.19**
```bash
node -v                               # >= 22.19 (usamos v24.18.0)
# si quedó en un node viejo:  nvm use 24 && nvm alias default 24
```

**1.b) Codex (Homebrew)**
```bash
brew install codex
codex --version                       # 0.142.0+
codex login                           # login con tu cuenta ChatGPT Plus — NO API key
codex /status                         # confirma cuenta + límites 5h/semanal
```
> ⚠️ Codex es **brew** (no npm). Con **login de ChatGPT (Plus)** el trabajo de código **no gasta API**.
> Si da `token_expired`: `codex logout` + `codex login`. En Windows/Linux: instalador `.exe` / brew igual.

**1.c) Canva — crear cuenta (para la demo del banner)**
- Crea (o usa) una cuenta gratis en **[canva.com](https://www.canva.com)**.
- No se instala nada local: Canva se conecta como **MCP remoto** (AI Connector) vía OAuth en el **paso 9**.

### 2. Instalar OpenClaw
```bash
npm install -g openclaw@2026.6.9
which openclaw && openclaw --version  # debe quedar bajo ~/.nvm/.../v24.18.0/bin
```

### 3. Crear el bot de Telegram (BotFather) — ANTES del onboarding
El onboarding te pedirá el **token del bot**, créalo primero:
1. En Telegram busca **@BotFather** (oficial, check azul) → entra al chat.
2. Envía `/newbot` → te pide un **nombre** (ej. `Café del Mar Bot`).
3. Luego un **username** único que **termine en `bot`** (ej. `example_taller_bot`).
4. Te da el **token** (`8123456789:AAE...`). **Cópialo completo** — va en el onboarding.

> Reusar un bot: `/mybots` → tu bot → **API Token**. El token es **secreto** (`/revoke` si se filtra).
> El **username** es público; el bot se abre en `https://t.me/<username>`.

### 4. Onboarding (OpenAI + Telegram + gateway)
```bash
openclaw onboard
```
Respuestas del asistente:
1. **QuickStart / Gateway** → defaults (puerto `18789`, loopback, auth por token).
2. **Model/auth provider** → **OpenAI** → **"OpenAI API key"** → pega tu key de [platform.openai.com](https://platform.openai.com).
3. **Default model** → **`openai/gpt-5.4-mini`** (el económico).
4. **Select channel** → **Telegram** → **"Enter Telegram bot token"** → pega el token de @BotFather.
5. **Web search** → **Skip for now**.
6. **Configure skills now?** → **No** (usamos nuestras skills propias, ver `skills/`).
7. **Enable hooks?** → **Skip for now**.
8. **Hatch your agent** → **Hatch in Terminal** (saluda, le puedes dar un nombre).

> La **API key de OpenAI** (`sk-proj-...`) es el "cerebro" de OpenClaw — distinta del login de Codex.
> Crea una en platform.openai.com con **budget cap** (ej. $10) y **rótala** al terminar el taller.

### 5. Verificar + emparejar (pairing)
```bash
openclaw status && openclaw agents list   # gateway + canal + modelo activo
openclaw dashboard                         # (opcional) panel web con la URL tokenizada
```
El bot arranca en modo **pairing** (no le habla a cualquiera). Al escribirle responde
**"You are not authorized..."** y crea una **solicitud** que TÚ apruebas:
```bash
# 1) escribe 'hola' al bot en Telegram (genera la solicitud)
openclaw pairing list --channel telegram          # -> Code: <TU_CODE> | <tu nombre de Telegram>
openclaw pairing approve --channel telegram <TU_CODE>   # quedas como owner
```
Reenvía `hola` → el agente responde. Solo ese usuario puede darle comandos.
> ⚠️ Si el bot **recibe pero no responde**: es **red a Telegram** (logs: `sendMessage failed /
> UND_ERR_CONNECT_TIMEOUT`). Usa **VPN o hotspot** — algunas redes/ISPs capan `api.telegram.org`.

### 6. Configurar `openclaw.json` — LA CONFIG GANADORA
Edita `~/.openclaw/openclaw.json` (mezcla con lo que ya tengas; no borres tus credenciales). Junta
**todo** en un solo lugar: modelo económico + fallback, runtime nativo, sandbox abierto y exec sin prompts:

```jsonc
{
  "agents": {
    "defaults": {
      // (1) modelo: barato para chat (mini) + fallback capaz (5.5 encadena Canva)
      "model": { "primary": "openai/gpt-5.4-mini", "fallbacks": ["openai/gpt-5.5"] },
      "models": {
        // (2) runtime NATIVO en cada modelo (si no, el Codex plugin se lleva el turno y crashea)
        "openai/gpt-5.4-mini": { "agentRuntime": { "id": "openclaw" } },
        "openai/gpt-5.5":      { "agentRuntime": { "id": "openclaw" } }
      },
      // (3) abrir el sandbox para que el agente escriba en el repo
      "sandbox": { "mode": "off", "workspaceAccess": "rw" }
    }
  },
  "tools": {
    // (4) bundle-mcp + canva__* habilitan Canva (aplican cuando lo conectes, paso 9)
    "allow": ["exec","web_fetch","web_search","memory_get","message","bundle-mcp","canva__*"],
    // (5) sin prompts de aprobación que traben el flujo
    "exec": { "security": "full" }
  }
}
```
Aplicar y verificar (SIEMPRE así tras editar el JSON):
```bash
openclaw config validate                                     # debe decir: Config valid
openclaw gateway restart
openclaw sandbox explain | grep -E 'mode|workspaceAccess'    # mode: off | workspaceAccess: rw
openclaw agent --agent main -m "responde solo: hola, soy gpt y estoy vivo"
```

**Por qué cada pieza:**
- **(1) modelo** = *model routing*: OpenClaw chatea con el barato (`mini`) y delega lo pesado a Codex
  (gratis vía ChatGPT Plus). El `5.5` es fallback / para la demo de Canva (mini no encadena 5 pasos).
- **(2) `agentRuntime: openclaw`** = el fix del **Codex Harness**. Con OpenAI + Codex instalado, el
  runtime `auto` se va al Codex Harness y crashea (`codex app-server exited`). Ids válidos: `openclaw`
  (el correcto), `codex`, `copilot`, `direct`. **NO uses `"direct"`** (crashea). Con `openclaw`, Codex
  queda solo como herramienta vía `exec`.
- **(3)+(5) sandbox off + exec full** = el agente tiene **acceso total al host** para escribir en el repo.
  Es el trade-off de la demo (y el **riesgo** que enseña el taller). En producción: **nunca** así.
- **(4) tools.allow** = permite las tools `canva__*` (paso 9).

> ⚠️ `openclaw models set` a veces se cuelga → edita `model.primary`/`.fallbacks` directo en este JSON.
> Codex está en `/opt/homebrew/bin/codex`, pero el **gateway no tiene homebrew en su PATH** → en las
> instrucciones usa siempre la **ruta absoluta** de codex.

### 7. Acto 1 — cambiar la web SIN skill (manual)
Es "el dolor": sin skill hay que dar el **comando completo**. Mensaje exacto a enviar por Telegram:
```
Edita la web Café del Mar con Codex. Corre exactamente este comando con tu herramienta exec y avísame cuando termine:

/opt/homebrew/bin/codex exec --sandbox workspace-write --skip-git-repo-check --cd "<RUTA_DEL_REPO>" "Cambia el color de fondo del boton .button a verde (#2e7d32) en styles.css, manten el texto legible"
```
Flujo: OpenClaw (gpt-5.4-mini) recibe → llama su tool `exec` → corre **Codex** → Codex edita
`styles.css` → avisa. **Verificar siempre en disco** (no confiar en el "listo" del bot):
```bash
cd "<RUTA_DEL_REPO>"
git diff styles.css
```
> ✅ Probado (24 jun 2026): el botón `.button` quedó verde, editado por Codex desde Telegram.
> A veces el chat dice "falló" pero el cambio **sí se aplicó** (Codex trabajó por dentro) → verifica en disco.

### 8. Acto 2 — la skill `editar-web` (mismo cambio, UNA frase)
La skill arma sola el `codex exec` (ruta, flags, repo) — tú solo escribes una frase natural.

**8.1. Instalar la skill.** El skill está en el repo en **`skills/editar-web/`**. Copia la
**carpeta completa** (trae `SKILL.md` + `scripts/`) a `~/.openclaw/workspace/skills/`:
```bash
REPO="<RUTA_DEL_REPO>"
cp -R "$REPO/skills/editar-web" ~/.openclaw/workspace/skills/
chmod +x ~/.openclaw/workspace/skills/editar-web/scripts/*.sh
openclaw skills info editar-web        # debe decir: ✓ Ready | Visible to model: yes
openclaw gateway restart
```

**8.2. Probarla por Telegram (UNA frase):**
```
Agrega un nuevo item al menú de la web: Té Chai, $3.50
```
Verificar: `git diff index.html styles.css`.
> ✅ Probado (24 jun 2026): agregó "Té Chai · $3.50" con UNA frase.
> **Acto 1** (comando completo) vs **Acto 2** (una frase) = el contraste "dolor → solución".

> Estructura del skill: `SKILL.md` (procedimiento) + `scripts/editar.sh` (el `codex exec` por ruta
> absoluta). Codex se invoca con `/opt/homebrew/bin/codex` (el gateway no tiene homebrew en PATH).

### 9. Conectar Canva MCP
**9.a) Si ya había un MCP de Canva, elimínalo primero:**
```bash
openclaw mcp list                     # ver el id (normalmente "canva")
openclaw mcp unset canva              # quita el servidor (hace backup .bak)
openclaw mcp reload
rm -rf ~/.openclaw/mcp-oauth/*canva*   # (opcional) limpiar tokens OAuth viejos
```
**9.b) Agregar y autorizar:**
```bash
openclaw mcp add canva --url https://mcp.canva.com/mcp --transport streamable-http --auth oauth
openclaw mcp login canva              # imprime una URL -> ábrela y aprueba en Canva
#   redirige a http://127.0.0.1:8989/oauth/callback?code=XXXX&state=YYYY
#   el navegador dirá "no se puede conectar" -> es NORMAL
openclaw mcp login canva --code 'CODE_DECODIFICADO'
openclaw mcp reload
openclaw mcp status | grep -i canva        # -> canva: streamable-http oauth authorized
openclaw mcp probe canva | grep -i tools   # -> canva: 33 tools
openclaw gateway restart
```
**9.c) ⚠️ CUIDADO con los símbolos del `code`** (esto nos mordió):
- **`%3A` significa `:`** → **decodifícalo**. Ej: `...glc%3AjiIK...Ul%3A4nL5...` → `...glc:jiIK...Ul:4nL5...`
- Los `_` y `-` se **dejan igual**. Copia **SOLO el `code`** (entre `code=` y `&`); **NO** incluyas `&state=...`
  (en zsh ese `&` manda el comando a background). Pega el code **entre comillas simples**.
- Caduca en minutos → si falla, repite `openclaw mcp login canva` y decodifica de nuevo.
- Puerto 8989 colgado: `lsof -nP -iTCP:8989` → `kill -9 <pid>`.

> Las tools `canva__*` ya están permitidas (las pusiste en `tools.allow`, paso 6). Si no, agrégalas y
> `openclaw config validate && openclaw mcp reload && openclaw gateway restart`.

### 10. Demo estrella — skill `promo-festivo` (Canva MCP → carrusel)
**10.1. Instalar la skill + subir el modelo a `gpt-5.5`** (encadena los 5 pasos de Canva; el mini no).
El skill está en el repo en **`skills/promo-festivo/`** — copia la **carpeta completa** (trae `SKILL.md`
+ `scripts/` + `references/`):
```bash
REPO="<RUTA_DEL_REPO>"
cp -R "$REPO/skills/promo-festivo" ~/.openclaw/workspace/skills/
chmod +x ~/.openclaw/workspace/skills/promo-festivo/scripts/*.sh
openclaw skills info promo-festivo     # ✓ Ready
openclaw models set openai/gpt-5.5      # (si se cuelga: edita model.primary en el JSON)
openclaw gateway restart
```
**10.2. Probarla por Telegram (UNA frase):**
```
haz la promo del Día de la Madre
```
Flujo (5 pasos): `canva__generate-design` → `resize-design` → `export-design` → `curl` baja el PNG a
`assets/promo-banner.png` → `codex exec` inserta un slide `hero-slide-promo` DENTRO del carrusel → avisa.
Verificar: `git diff index.html styles.css && ls -la assets/`.

**10.3. ⚠️ Ajuste clave — que la imagen encaje en el carrusel.**
El hero es **ancho** (~2.35:1). `canva__generate-design` exige `design_type` y por defecto usa
**`instagram_post`** = **1080×1350 (vertical)** → no encaja. Fix:
1. `generate-design` con **`design_type: "youtube_thumbnail"`** (horizontal, alta res). NUNCA
   `instagram_post`/`your_story`/`pinterest_pin` (verticales). En la `query`: texto **centrado con
   margen (zona segura)**.
2. `get-design-candidates` + `create-design-from-candidate` → `design_id`.
3. **`canva__resize-design`** con `design_type: { "type": "custom", "width": 1920, "height": 820 }`
   → aspecto exacto del hero (~2.34:1), alta res.
4. `export-design` → `curl` → `codex` con `cover`:
   `.hero-slide-promo { background: url('assets/promo-banner.png') center/cover; }`.

> `generate-design` **NO** acepta píxeles libres (solo `design_type`); para tamaño exacto se usa
> **`resize-design` con `type:"custom"`**. Tipos "portada" apaisados: `facebook_cover` (baja res), `youtube_banner`.
> ✅ Probado (24 jun 2026): banner apaisado 1920×820 que llena el slide limpio, sin recortes.

---

## Comandos útiles
```bash
openclaw gateway start | stop | restart | status
openclaw status                       # gateway + canal + modelo + sesiones
openclaw health                       # salud detallada
openclaw channels logs | tail -30     # logs del canal (Telegram)
openclaw models status                # modelo activo
openclaw dashboard                    # panel web (URL tokenizada)
openclaw sandbox explain              # ver modo sandbox y acceso a archivos
openclaw config validate              # validar el JSON tras editarlo
```

## Skills del repo
```
skills/
├── editar-web/      SKILL.md + scripts/editar.sh                    (Acto 2 — solo Codex)
└── promo-festivo/   SKILL.md + scripts/publish.sh + references/canva-formato.md  (demo estrella — Canva MCP)
```
Diagramas de arquitectura (skills, MCP, orquestación) en `docs/`.

## Notas de seguridad (para el taller)
- Sandbox `mode: off` + `exec.security: full` = el agente tiene **acceso total al host**. Cómodo para
  la demo, pero es el **riesgo** que enseña el taller. En producción: **nunca** así.
- El **token del bot** y la **API key** son secretos: no mostrarlos en pantalla; rotarlos al terminar.
- Bot en modo **pairing** con **owner allowlist** → solo el dueño puede darle comandos.
