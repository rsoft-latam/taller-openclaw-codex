# Formato del banner en Canva (para que encaje en el carrusel)

El slide del hero es **ancho** (~2.35:1). Si la imagen sale vertical/cuadrada, `cover` la recorta feo.

## Reglas de formato
- `canva__generate-design` **exige `design_type`** y por defecto usa `instagram_post` =
  **1080x1350 (vertical 4:5)** -> NO encaja. Hay que forzar formato horizontal.
- Usar **`design_type: "youtube_thumbnail"`** (horizontal 16:9, alta resolucion).
  NUNCA `instagram_post`, `your_story`, `pinterest_pin` (salen verticales).
- `generate-design` **NO acepta pixeles libres** (solo `design_type` de una lista).
  Para un **tamano especifico** se usa **`resize-design`** con `design_type: {type:"custom", width, height}`.
- Tras generar, **`resize-design` a custom `1920x820`** (~2.34:1) -> aspecto exacto del hero, alta res.
- En la `query` pedir: texto y elementos **centrados con margenes (zona segura)**, porque `cover`
  recorta un poco arriba y abajo.

## Tipos "portada" apaisados (alternativas)
- `facebook_cover` (~820x360) -> apaisado pero baja resolucion.
- `youtube_banner` -> muy ancho pero con mucha zona segura.

## CSS resultante del slide
```css
.hero-slide-promo { background: url('assets/promo-banner.png') center/cover; }
.hero-slide-promo::before { display: none; }
```
