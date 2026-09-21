# ignite-brief — Brief de Campaña (Ignite)

Formulario online + panel interno para el brief de campaña de Taquion. Implementación de [`specs/005-brief-campana-ignite.md`](../SDD-TAQUION/specs/005-brief-campana-ignite.md) (repo hermano) — esa spec da el contexto y los criterios de aceptación originales.

Sitio estático (HTML/CSS/JS, sin framework) + [Supabase](https://supabase.com) como base de datos: el navegador habla directo con Supabase usando la clave `anon` (pública por diseño; la protección real la dan las políticas de RLS en `supabase/schema.sql`).

**Estado de acceso: MVP sin protección.** El formulario y el panel son públicos para cualquiera que tenga el link — decisión explícita, ver [Decisiones de arquitectura](docs/explanation/decisiones-de-arquitectura.md).

## Documentación

La documentación completa está en [`docs/`](docs/index.md), organizada con la metodología Diátaxis:

- **[Tutoriales (Tutorials)](docs/tutorials/primer-despliegue.md)** — de cero a tener el proyecto funcionando en producción.
- **[Guías prácticas (How-To Guides)](docs/how-to/)** — desarrollar en local, agregar un campo al formulario, activar la automatización de n8n.
- **[Referencia (Reference)](docs/reference/)** — modelo de datos, variables de entorno, estructura del proyecto.
- **[Explicación (Explanation)](docs/explanation/)** — decisiones de arquitectura, historial del proyecto.

Empezá por [`docs/index.md`](docs/index.md) si no sabés por dónde arrancar.
