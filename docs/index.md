# Documentación de ignite-brief

Esta documentación está organizada siguiendo **Diátaxis**, un método que separa
el contenido en cuatro categorías según lo que la persona que lee necesita en
ese momento — no según el tema. Antes todo vivía mezclado en el `README.md`;
ahora cada tipo de contenido tiene su propia carpeta:

| Carpeta | Responde a... | Cuándo mirarla |
|---|---|---|
| [`tutorials/`](./tutorials/primer-despliegue.md) | "Nunca configuré esto, guiame de punta a punta" | La primera vez que ponés el proyecto en marcha (Supabase + hosting) |
| [`how-to/`](#guías-prácticas-how-to-guides) | "Ya sé cómo funciona, ¿cómo hago X en particular?" | Cuando tenés una tarea puntual: agregar un campo, activar la automatización, correr todo en local |
| [`reference/`](#referencia-reference) | "Necesito el dato exacto" | Cuando ya sabés qué buscás: un nombre de columna, una variable de entorno |
| [`explanation/`](#explicación-explanation) | "Quiero entender el porqué" | Cuando necesitás contexto de una decisión o la historia del proyecto |

## Tutoriales (Tutorials)

- [Primer despliegue](./tutorials/primer-despliegue.md) — de cero a tener el formulario y el panel funcionando en producción: crear el proyecto de Supabase, cargar el esquema, y deployar a Vercel o Netlify.

## Guías prácticas (How-To Guides)

- [Desarrollar en local](./how-to/desarrollar-en-local.md) — correr el formulario y el panel en tu máquina.
- [Agregar un campo al formulario](./how-to/agregar-un-campo-al-formulario.md) — todos los lugares que hay que tocar para que un campo nuevo llegue de punta a punta.
- [Configurar la automatización de n8n](./how-to/configurar-automatizacion-n8n.md) — activar la generación automática de un Google Doc/PDF por cada brief nuevo.

## Referencia (Reference)

- [Modelo de datos](./reference/modelo-de-datos.md) — tabla `campaign_briefs`, políticas de acceso (RLS) y el bucket de Storage.
- [Variables de entorno](./reference/variables-de-entorno.md) — `SUPABASE_URL` y `SUPABASE_ANON_KEY`.
- [Estructura del proyecto](./reference/estructura-del-proyecto.md) — mapa de carpetas y archivos.

## Explicación (Explanation)

- [Decisiones de arquitectura](./explanation/decisiones-de-arquitectura.md) — por qué sin framework, por qué Supabase y no una API propia, por qué sin autenticación en esta versión.
- [Historial del proyecto](./explanation/historial-del-proyecto.md) — cómo evolucionó el proyecto desde el MVP hasta hoy, y qué queda como posible próximo paso.

## Fuera de este repo

- **Spec de producto:** [`SDD-TAQUION/specs/005-brief-campana-ignite.md`](../SDD-TAQUION/specs/005-brief-campana-ignite.md) — leerla primero da el contexto completo y los criterios de aceptación originales. Apunta a un repo hermano y no se pudo verificar desde acá.
