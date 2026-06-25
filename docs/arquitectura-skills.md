# Arquitectura de orquestación de Skills (estado del arte 2026)

Ejemplo sencillo: un café recibe por chat **"haz la promo del Día de la Madre"**.

---

## 1) El modelo de 3 capas (qué puede / cómo / qué no)

```
        ┌──────────────────────────────────────────────────────────┐
        │                      USUARIO (Telegram)                   │
        │             "haz la promo del Día de la Madre"            │
        └───────────────────────────┬──────────────────────────────┘
                                     ▼
   ╔══════════════════════════════════════════════════════════════════╗
   ║                    ORQUESTADOR  (agente principal)                ║
   ║         mantiene el CONTEXTO global y decide qué activar           ║
   ╚══════════════════════════════════════════════════════════════════╝
        │                         │                          │
   ┌────┴─────┐            ┌───────┴────────┐         ┌───────┴────────┐
   │  RULES   │            │     SKILLS     │         │      MCP        │
   │ qué NO   │            │   CÓMO hacerlo │         │  qué PUEDE      │
   │ se puede │            │  (playbooks)   │         │  hacer (acceso) │
   ├──────────┤            ├────────────────┤         ├────────────────┤
   │ no prod  │            │ promo-festivo  │         │ Canva  (diseña) │
   │ no borrar│            │ editar-web     │         │ exec   (shell)  │
   │ sandbox  │            │ ...            │         │ web    (red)    │
   └──────────┘            └────────────────┘         └────────────────┘
        ▲                         ▲                          ▲
   restricciones            conocimiento               conectividad
   (guardrails)             procedimental              (sistema nervioso)
```

> **Regla de oro:** MCP = *lo que puede hacer* · Skills = *cómo hacerlo* · Rules = *lo que no puede*.
> Se mantienen en planos separados → componibles.

---

## 2) Progressive disclosure (las skills cargan por capas)

```
   ARRANQUE            ACTIVACIÓN              EJECUCIÓN
   (Discovery)         (Activation)            (Execution)
   ~80 tok/skill       <5000 tok               solo lo necesario
   ┌──────────┐        ┌──────────────┐        ┌──────────────────┐
   │ name +   │  match │  cuerpo del  │  corre │ scripts/  refs/  │
   │ descrip. │ ─────▶ │   SKILL.md   │ ─────▶ │ assets/ (on dem.)│
   │ (todas)  │        │ (la elegida) │        │                  │
   └──────────┘        └──────────────┘        └──────────────────┘
   "sé que existen"    "leo cómo se hace"      "uso solo lo que toca"
```

---

## 3) Orquestación: skill que llama MCP + script + SUB-SKILL

Flujo real de `promo-festivo` (un skill que orquesta otras piezas):

```
  ORQUESTADOR
      │  activa
      ▼
  ┌─────────────────────────────── SKILL: promo-festivo ───────────────────────────────┐
  │                                                                                     │
  │  paso 2-5 ──▶  ╔═══════════╗   diseña → redimensiona → exporta                      │
  │   (agente)     ║  MCP Canva ║   generate-design · resize-design · export-design      │
  │                ╚═══════════╝   ─────────────────────────────▶  URL del PNG          │
  │                                                                     │               │
  │  paso 6  ──▶   ┌───────────────┐   curl (baja PNG) + codex exec (edita la web)       │
  │   (shell)      │ scripts/      │ ◀────────────────────────────────┘                 │
  │                │ publish.sh    │                                                     │
  │                └───────────────┘                                                     │
  │                                                                                     │
  │  (opcional) ──▶ ┌──────────────────────┐   si además hay que ajustar texto/CSS,      │
  │                 │ SUB-SKILL: editar-web │   delega en otra skill (composición)        │
  │                 └──────────────────────┘                                             │
  └─────────────────────────────────────────────────────────────────────────────────────┘
      │
      ▼
  Responde "listo" → la web cambió (banner en el carrusel)
```

---

## 4) Patrones de composición (cómo se combinan skills)

```
  SERIAL          PARALELO          CONDICIONAL         RECURSIVO
  A → B → C       ┌─ A ─┐           ¿festivo?           skill
                  │     │            ├─ sí → promo       └─ llama → sub-skill
                  ├─ B ─┤            └─ no → editar           └─ llama → sub-skill
                  └─ C ─┘
  un paso tras    varias a la       elige rama          una skill invoca
  otro            vez (subagentes)  según el caso       otra (anidado)
```

> **Subagente** = agente fresco que recibe una tarea acotada, la resuelve **aislado** y devuelve
> SÓLO la síntesis (no todo el transcript) → no contamina el contexto del orquestador.

---

## 5) Principios clave (2026)
- **Una skill debe caber en tu cabeza**: si necesita más de un párrafo de doc, son dos skills.
- **SKILL.md corto**: lo pesado va a `scripts/` (ejecutable) y `references/` (doc on-demand).
- **MCP y Skills en planos separados** (sin estado compartido) → componibilidad.
- **Ciclo load → execute → unload**: el contexto sigue el paso actual, no todo el workflow.
- **Seguridad**: una skill maliciosa corre con TODOS los permisos del agente → firmar, revisar, sandbox.
