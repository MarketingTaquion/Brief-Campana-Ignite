# Plantilla de Brief de Campaña — Google Docs

El workflow (`Brief-Campana-Ignite-Supabase-Webhook.json`) copia este documento y reemplaza cada placeholder por el dato guardado en `campaign_briefs` (nodo **Completar Brief de Campaña (Google Docs API)**, vía `documents:batchUpdate` → `replaceAllText`). Los placeholders son **case-sensitive** y deben escribirse exactamente así, con doble llave.

## Cómo crearla

1. Creá un Google Doc nuevo en la carpeta de Drive que vayas a usar como carpeta de briefs de campaña.
2. Armá el diseño con el texto y la estructura de abajo (podés aplicar el estilo Taquion: tipografía Archivo, encabezados en negro/gris profesional — ver `Taquion 2026 Design System/`).
3. Reemplazá cada campo variable por su placeholder literal (tabla más abajo).
4. Copiá el ID del documento desde la URL (`docs.google.com/document/d/`**`ESTE_ID`**`/edit`) y cargalo en el nodo **Copiar Plantilla de Brief de Campaña**.
5. Copiá el ID de la carpeta de Drive destino y cargalo en ese mismo nodo (`options.parents`) y en **Guardar PDF en Drive**.

> El documento original nunca se edita: el workflow siempre trabaja sobre una **copia** nueva por cada brief, así la plantilla queda intacta para el próximo envío.

## Placeholders disponibles

| Placeholder | Contenido |
|---|---|
| `{{ID_BRIEF}}` | UUID del registro en `campaign_briefs` |
| `{{FECHA}}` | Fecha y hora en que se guardó el brief |
| `{{NOMBRE_CAMPANA}}` | Nombre de la campaña |
| `{{SOLICITADO_POR}}` | Quién completó el formulario |
| `{{EMAIL_SOLICITANTE}}` | Email de quien lo completó |
| `{{CONTEXTO}}` | Contexto de la campaña |
| `{{OBJETIVOS}}` | Objetivos marcados, separados por `·` |
| `{{OBJETIVO_OTRO}}` | Objetivo adicional en texto libre |
| `{{AUDIENCIA_DEMOGRAFICA}}` | Datos demográficos de la audiencia |
| `{{AUDIENCIA_GEOGRAFICA}}` | Datos geográficos de la audiencia |
| `{{AUDIENCIA_PSICOGRAFIA}}` | Psicografía de la audiencia |
| `{{AUDIENCIA_COMPORTAMIENTOS}}` | Comportamientos de la audiencia |
| `{{ETAPA_EMBUDO}}` | Prospección / Consideración / Conversión / Retención |
| `{{PAGINA_DESTINO}}` | Landing page de la campaña |
| `{{PRESUPUESTO}}` | Presupuesto elegido, formateado ($ 5.000.000 / $ 12.000.000 / $ 20.000.000) |
| `{{DURACION_FECHAS}}` | Días puntuales de la campaña (dd/mm/aaaa separados por coma, no necesariamente consecutivos) |
| `{{CANALES}}` | Canales marcados, separados por `·` |
| `{{ENTREGABLES}}` | Entregables marcados, separados por `·` |
| `{{ENTREGABLE_OTRO}}` | Entregable adicional en texto libre |
| `{{MENSAJE_CENTRAL}}` | Mensaje central y tono de voz |
| `{{MENSAJE_PRINCIPAL}}` | Mensaje principal |
| `{{PIEZAS_TITULARES}}` | Piezas y titulares |
| `{{MENSAJES_SECUNDARIOS}}` | Mensajes secundarios |
| `{{LLAMADOS_ACCION}}` | Llamados a la acción |
| `{{DIRECCION_CREATIVA}}` | Dirección estratégica y creativa elegida |
| `{{PREFERENCIAS_IDENTIDAD}}` | Preferencias de identidad y ejecución, separadas por `·` |
| `{{PREFERENCIAS_OTRO}}` | Otras preferencias en texto libre |
| `{{ELEMENTOS_MARCA}}` | Elementos de marca y campaña, separados por `·` |
| `{{INFORMACION_ADICIONAL}}` | Información adicional |
| `{{RECURSOS_CLAVE}}` | Enlaces cargados (uno por línea) |
| `{{ESTADO}}` | Estado en el panel al momento del envío (siempre "Nuevo", porque el workflow solo dispara en INSERT) |

Campos vacíos se completan con **"— sin completar —"** en vez de dejar el placeholder sin reemplazar o un espacio en blanco confuso.

## Estructura sugerida del documento

```
BRIEF DE CAMPAÑA — {{NOMBRE_CAMPANA}}
ID: {{ID_BRIEF}}          Fecha: {{FECHA}}
Solicitado por: {{SOLICITADO_POR}} ({{EMAIL_SOLICITANTE}})

────────────────────────────────────────

1. CONTEXTO
{{CONTEXTO}}

2. OBJETIVO DE LA CAMPAÑA
{{OBJETIVOS}}
Otro objetivo: {{OBJETIVO_OTRO}}

3. AUDIENCIA OBJETIVO
Datos demográficos:   {{AUDIENCIA_DEMOGRAFICA}}
Datos geográficos:    {{AUDIENCIA_GEOGRAFICA}}
Psicografía:          {{AUDIENCIA_PSICOGRAFIA}}
Comportamientos:      {{AUDIENCIA_COMPORTAMIENTOS}}

4. EMBUDO Y DESTINO
Etapa del embudo:  {{ETAPA_EMBUDO}}
Página de destino: {{PAGINA_DESTINO}}

5. PRESUPUESTO Y DURACIÓN
Presupuesto:       {{PRESUPUESTO}}
Días de campaña:   {{DURACION_FECHAS}}

6. CANALES Y ENTREGABLES
Canales:     {{CANALES}}
Entregables: {{ENTREGABLES}}
Otro entregable: {{ENTREGABLE_OTRO}}

7. MENSAJE
Mensaje central y tono: {{MENSAJE_CENTRAL}}
Mensaje principal:      {{MENSAJE_PRINCIPAL}}
Piezas y titulares:     {{PIEZAS_TITULARES}}
Mensajes secundarios:   {{MENSAJES_SECUNDARIOS}}
Llamados a la acción:   {{LLAMADOS_ACCION}}

8. DIRECCIÓN ESTRATÉGICA Y CREATIVA
{{DIRECCION_CREATIVA}}

9. PREFERENCIAS DE IDENTIDAD Y ELEMENTOS DE MARCA
Preferencias de identidad y ejecución: {{PREFERENCIAS_IDENTIDAD}}
Otras preferencias:                    {{PREFERENCIAS_OTRO}}
Elementos de marca y campaña:          {{ELEMENTOS_MARCA}}

10. INFORMACIÓN ADICIONAL
{{INFORMACION_ADICIONAL}}

11. RECURSOS CLAVE
{{RECURSOS_CLAVE}}

────────────────────────────────────────
Generado automáticamente a partir del formulario de brief de campaña de Ignite.
Ver el registro completo, con estado actualizado, en el panel interno de ignite-brief.
```
