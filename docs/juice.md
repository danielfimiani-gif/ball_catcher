# Game Juice & Polish — TP1 Catch Ball

Plan de trabajo para llevar el juego a Tier Plata/Oro con énfasis en estética, UI, feedback y audio.

Las fases están ordenadas por costo/impacto. No es obligatorio hacerlas en orden estricto, pero la propuesta es priorizar la base (audio + game feel) antes que los refinamientos visuales.

---

## Fase 0 — Decisión inicial (bloqueante)

- [x] Definir estrategia de assets: **externos** (sitios free), **procedurales** (solo código), o **mix** → **Externos**

---

## Fase 1 — Audio (base)

- [ ] Configurar AudioBuses (Master / Music / SFX) en `audio_bus_layout.tres`
- [ ] Crear autoload `AudioManager` para reproducir música/SFX desde cualquier escena
- [ ] Música del menú (loop)
- [ ] Música del gameplay (loop)
- [ ] SFX hover botón
- [ ] SFX click botón
- [ ] SFX atrapar manzana
- [ ] SFX atrapar huevo
- [ ] SFX atrapar poción
- [ ] SFX recibir hacha
- [ ] SFX victoria
- [ ] SFX derrota
- [ ] SFX nuevo récord

## Fase 2 — Game Feel

- [x] Screen shake genérico (utilitario reusable en `Camera2D` o nodo dedicado)
- [x] Screen shake al recibir hacha (intensidad media)
- [x] Screen shake al ganar/perder (intensidad fuerte y corta)
- [x] Shake adicional al parallax (CanvasLayer) con intensidad menor para coherencia
- [x] Hit-stop (~80ms) al recibir hacha (`Engine.time_scale`)
- [x] Color flash del catcher al recibir daño (modulate rojo + tween)
- [ ] (Opcional) Flash verde sutil del catcher al atrapar item (feedback positivo)

## Fase 3 — Partículas

- [x] Partículas al atrapar item (verde/dorado, suave) — `CPUParticles2D` (GL Compatibility no soporta GPU)
- [x] Partículas al recibir hacha (rojo, agresivo + más cantidad)
- [x] Escena reusable + auto-free al terminar (`auto_free_particles.gd`)
- [ ] Variante de partículas por tipo de item (opcional)
- [ ] Polish de tweaks (cantidad, dispersión, vida útil, gravity)

## Fase 4 — Microinteracciones

- [x] Floating combo text "+10" / "-1" al atrapar (label que sube y se desvanece)
- [x] Squash & stretch del catcher al moverse (al arrancar o cambiar dirección)
- [x] Squash al atrapar item / stretch al recibir hacha
- [x] HUD de vidas reemplazado por corazones animados (pop + scale 0 + fade al perder)
- [x] Squash horizontal del catcher al chocar con el borde de la pantalla
- [x] Mini screen shake al chocar con el borde (muy sutil)
- [ ] Partícula de "polvo/rebote" al chocar con el borde (opcional, pendiente)

## Fase 5 — UI Pulida

- [ ] Transición fade entre escenas (centralizada en `SceneManager`)
- [ ] Botones animados (hover: escala + tint, click: squash + sound)
- [x] Tipografía custom (Pixelify Sans desde Google Fonts) + theme global
- [x] Animación de entrada del título del menú (pop + stagger cascade de botones e info)
- [x] Mejorar animación del Score al subir (squash anisotrópico + flash dorado + rebote)
- [x] Botón con focus visible para navegación con teclado/joystick (hover+focus unificados + auto-focus al entrar)

## Fase 6 — Visual / Assets

- [ ] Definir paleta cohesiva (5–6 colores)
- [ ] Background del menú (atmosférico)
- [ ] Background del gameplay (gradiente o parallax suave)
- [ ] Sprites mejorados (si hace falta reemplazar los actuales)
- [ ] Iconos coherentes con el estilo

## Fase 7 — Refinamientos finales

- [ ] Cuenta regresiva "3, 2, 1, GO!" al iniciar partida
- [x] Vidas como íconos (corazones) en vez de texto "Lives: 3"
- [ ] Ícono al lado del Score (estrella, moneda, etc.)
- [ ] Pulido del HUD (alineación, márgenes, jerarquía visual)

## Fase 8 — Mecánicas diferenciales (gameplay)

Mecánicas nuevas que diferencian al juego del clásico Catch Ball. Apuntan a Tier Oro.

### 8.A — Power-Ups
Sistema de items especiales que caen ocasionalmente y otorgan habilidades temporales al catcher.

- [ ] **Speed Boost** — duplica la velocidad del catcher por X segundos. Cambia animación a `run`. (confirmado)
- [ ] Slow Motion — ralentiza la caída de los items por X segundos
- [ ] Magnet — atrae items hacia el catcher en un radio
- [ ] Shield — protege de un hacha (consumible single-use)
- [ ] Score Multiplier x2 — duplica puntos por X segundos
- [ ] Extra Life — vida instantánea (consumible)
- [ ] HUD indicator del power-up activo (ícono + barra de tiempo restante)
- [ ] SFX de activación de power-up
- [ ] Partícula/aura visual en el catcher mientras dura el power-up

### 8.B — Hook (a definir)
Mecánica de gancho. Implementación pendiente de diseño. Posibles ideas a evaluar:
- Disparar un gancho hacia arriba que atrape un item específico y lo traiga
- Gancho que se engancha en un punto y desplaza al catcher horizontalmente
- Gancho como "lazo" que abarca un área para atrapar múltiples items

- [ ] Definir comportamiento del hook
- [ ] Implementar input (¿clic? ¿barra espaciadora? ¿flecha arriba?)
- [ ] Visual del gancho (sprite + cuerda/línea)
- [ ] SFX de disparo y enganche
- [ ] Cooldown / consumible / siempre disponible (decidir)

---

## Mapa a la consigna del TP

- **Tier Plata — Game juice (partículas + screen shake)**: Fases 2 y 3
- **Tier Plata — Itch.io con screenshots y descripción**: tomar capturas tras Fase 6
- **Tier Oro — Polish y mecánica innovadora**: las Fases 4, 5, 7 aportan polish, y **la Fase 8 (Power-Ups + Hook) son las mecánicas diferenciales**

---

## Notas

- Ir tildando los items a medida que se completan.
- Si surge una idea nueva durante el desarrollo, agregarla en la fase que corresponda.
- Si se descarta una idea, dejarla tildada con nota `~~descartado~~` en vez de borrarla, para tener trazabilidad.
