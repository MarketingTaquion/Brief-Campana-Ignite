# Modelo de datos (Data Model)

Todo lo que define `supabase/schema.sql`: la tabla `campaign_briefs`, sus políticas de acceso, y el bucket de Storage para archivos adjuntos.

## Tabla `campaign_briefs`

| Columna | Tipo | Corresponde al campo del formulario (`name`) | Notas |
|---|---|---|---|
| `id` | `uuid` (PK) | — | `gen_random_uuid()` por defecto |
| `created_at` | `timestamptz` | — | `now()` por defecto; indexada (`campaign_briefs_created_at_idx`) para ordenar el panel por fecha |
| `nombre_campana` | `text`, obligatorio | `nombre_campana` | |
| `solicitado_por` | `text`, obligatorio | `solicitado_por` | |
| `email_solicitante` | `text`, obligatorio | `email_solicitante` | |
| `contexto` | `text` | `contexto` | |
| `objetivos` | `text[]` | `objetivos` (checkbox múltiple) | array de las opciones marcadas |
| `objetivo_otro` | `text` | `objetivo_otro` | |
| `audiencia_demografica` | `text` | `audiencia_demografica` | |
| `audiencia_geografica` | `text` | `audiencia_geografica` | |
| `audiencia_psicografia` | `text` | `audiencia_psicografia` | |
| `audiencia_comportamientos` | `text` | `audiencia_comportamientos` | |
| `etapa_embudo` | `text` | `etapa_embudo` (select) | |
| `pagina_destino` | `text` | `pagina_destino` | |
| `presupuesto` | `numeric` | `presupuesto` (radio: 5M/12M/20M) | agregada en una migración posterior al MVP (2026-09-14) |
| `duracion_fechas` | `date[]` | `duracion_fechas` (hidden, poblado por un calendario propio) | días sueltos marcados, no un rango — agregada en la misma migración que `presupuesto` |
| `canales` | `text[]` | `canales` (checkbox múltiple) | Google Display, Meta, LinkedIn, Twitter/X, Quora, Reddit |
| `entregables` | `text[]` | `entregables` (checkbox múltiple) | Estático, Display - Adaptable, Display - Personalizado, Carrusel |
| `entregable_otro` | `text` | `entregable_otro` | |
| `mensaje_central` | `text` | `mensaje_central` | |
| `mensaje_principal` | `text` | `mensaje_principal` | |
| `piezas_titulares` | `text` | `piezas_titulares` | |
| `mensajes_secundarios` | `text` | `mensajes_secundarios` | |
| `llamados_accion` | `text` | `llamados_accion` | |
| `direccion_creativa` | `text` | `direccion_creativa` (radio) | |
| `preferencias_identidad` | `text[]` | `preferencias_identidad` (checkbox múltiple) | |
| `preferencias_otro` | `text` | `preferencias_otro` | |
| `elementos_marca` | `text[]` | `elementos_marca` (checkbox múltiple) | |
| `informacion_adicional` | `text` | `informacion_adicional` | |
| `recursos_clave` | `text` | `recursos_clave` (links, uno por línea) + los links de archivos subidos (ver Storage abajo) se agregan automáticamente a este mismo campo | |
| `estado` | `text`, obligatorio | — (lo escribe el panel, no el formulario) | `check` a nivel de base: solo acepta `'Nuevo'`, `'En revisión'`, `'Aprobado'`; default `'Nuevo'` |

El archivo es **idempotente**: correrlo de nuevo sobre una base ya creada no rompe nada (usa `if not exists` / `add column if not exists` en todos lados). Cuando se agrega un campo nuevo al formulario, la convención es sumarlo en los dos lugares del archivo (`create table` + `alter table`) — ver [Agregar un campo al formulario](../how-to/agregar-un-campo-al-formulario.md).

## Políticas de acceso (Row Level Security)

RLS está habilitado en `campaign_briefs`, pero las tres políticas actuales son deliberadamente abiertas a cualquiera con la clave `anon` — es la decisión de "MVP sin autenticación" (ver [Decisiones de arquitectura](../explanation/decisiones-de-arquitectura.md)):

| Política | Operación | A quién | Condición |
|---|---|---|---|
| "anon puede insertar briefs" | `insert` | `anon` | siempre |
| "anon puede leer briefs" | `select` | `anon` | siempre |
| "anon puede actualizar estado" | `update` | `anon` | siempre |

No hay política de `delete` — nadie puede borrar filas vía la clave `anon` (la limpieza de filas de prueba se hace a mano desde el Table Editor de Supabase, con las credenciales del proyecto).

## Storage: bucket `briefs-recursos`

Bucket público, creado por el mismo `schema.sql`, para los archivos que se suben desde el botón "Subir archivo" del formulario (tope 15 MB por archivo). Su link público se agrega automáticamente a `recursos_clave` junto con los links tipeados a mano.

Tiene una sola política, de `insert` para `anon` — **deliberadamente sin política de `select`**: como el bucket ya es público, `getPublicUrl()` funciona sin ninguna política, y agregar una de `select` habilitaría además *listar* todos los archivos del bucket vía API (Supabase lo marca como advertencia de seguridad — "Clients can list all files in this bucket" — porque no hace falta para este caso de uso).
