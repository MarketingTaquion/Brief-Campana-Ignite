# Decisiones de arquitectura

Contexto de por qué el proyecto está armado como está. Para el detalle completo de requisitos y criterios de aceptación originales, ver la spec de producto (`SDD-TAQUION/specs/005-brief-campana-ignite.md`, repo hermano).

## Sin framework ni backend propio

El sitio es HTML/CSS/JS estático, sin React/Vue/etc. y sin servidor propio. La razón: las políticas de Supabase (Row Level Security) ya resuelven los permisos de acceso a los datos, así que no hace falta lógica de servidor para eso — y sin esa necesidad, un framework solo agregaría superficie de mantenimiento (dependencias, build más complejo) sin resolver un problema real de este proyecto.

## Supabase, no una API propia

Mismo patrón que otro proyecto interno (`specs/003-dashboard-consumos.md`, repo hermano): Postgres + RLS en vez de armar autenticación/almacenamiento a mano. El navegador habla directo con Supabase usando la clave `anon` — eso es seguro porque la clave `anon` está pensada para ser pública (a diferencia de la `service_role`, que nunca debe llegar al frontend); la protección real de qué se puede hacer con esa clave la dan las políticas de RLS, no el secreto de la clave. Ver [Modelo de datos](../reference/modelo-de-datos.md) para las políticas exactas.

## Sin autenticación en esta versión (MVP)

Decisión explícita de producto (2026-09-13), no un descuido: el formulario y el panel son públicos para cualquiera con el link. Las políticas de RLS reflejan esto a propósito — cualquiera con la clave `anon` puede insertar, leer y actualizar el estado de los briefs.

Si más adelante hace falta protegerlo, la spec original ya deja anotadas dos rutas:
- **Más simple:** una contraseña compartida vía variable de entorno, consumida por un pequeño middleware/Edge Function.
- **Más robusta:** Supabase Auth + RLS por usuario (mismo patrón documentado en `specs/003` del repo hermano).

<!-- TODO(humano): al momento de escribir esta documentación no hay una fecha ni disparador concreto definido para pasar de "MVP sin protección" a alguna de estas dos rutas — si ya se decidió algo desde entonces, actualizar esta sección. -->

## Storage sin política de lectura (`select`)

El bucket `briefs-recursos` es público pero deliberadamente no tiene una política de `select` en Supabase Storage. El motivo: como el bucket ya es público, los links directos (`getPublicUrl()`) funcionan sin ninguna política — agregar una de `select` habilitaría además que cualquiera pueda *listar* todos los archivos subidos vía API, no solo acceder a los que ya tiene el link. Supabase marca la ausencia de esa política como advertencia de seguridad por defecto, pero en este caso es la decisión correcta: listar todo el bucket no es necesario para el caso de uso, y exponerlo sería dar más acceso del que hace falta.

## Por qué el disparador de la automatización es Supabase y no el formulario

La automatización de n8n (ver [Configurar la automatización de n8n](../how-to/configurar-automatizacion-n8n.md)) escucha los inserts de la tabla `campaign_briefs` vía un Database Webhook de Supabase, en vez de que `public/index.html` le hable directo a n8n. Ventajas de este orden:
- Cero cambios en el formulario ya deployado ni redeploy necesario para activar/desactivar la automatización.
- Si n8n está caído o mal configurado, el brief igual queda guardado y visible en el panel — no se pierde nada, solo no se genera el documento todavía.
- Supabase reintenta el webhook automáticamente si n8n no responde con un código 2xx.
