# Variables de entorno

Solo dos, ambas obligatorias para que el formulario y el panel funcionen contra datos reales (sin ellas, el sitio se deploya igual pero muestra un aviso de "no configurado" en vez de fallar en blanco).

| Variable | De dónde sale | Dónde se carga |
|---|---|---|
| `SUPABASE_URL` | Supabase → Project Settings → API → **Project URL** | Env vars de Vercel/Netlify (producción), o `public/config.js` a mano (local) |
| `SUPABASE_ANON_KEY` | Supabase → Project Settings → API → **anon public key** | Igual que arriba |

⚠️ `SUPABASE_ANON_KEY` es la clave pública (`anon`), no la `service_role` — esa última nunca debe cargarse acá ni en ningún lugar que llegue al navegador. La protección real de los datos la dan las políticas de RLS (ver [Modelo de datos](./modelo-de-datos.md)), no el secreto de esta clave.

## Cómo llegan al frontend

Estas dos variables no se leen directo del entorno en el navegador — se inyectan en build time:

1. `npm run build` corre `scripts/generate-config.js`, que lee `process.env.SUPABASE_URL` / `process.env.SUPABASE_ANON_KEY` y escribe `public/config.js` con esos valores.
2. `public/config.js` (generado, no versionado — está en `.gitignore`) define `window.IGNITE_BRIEF_CONFIG`, que lee `public/supabase-client.js` para crear el cliente de Supabase.

En Vercel/Netlify, "cargar las variables de entorno" significa configurarlas en el dashboard de la plataforma (no en un archivo del repo) — ver [Primer despliegue](../tutorials/primer-despliegue.md). En local, se completan a mano en `public/config.js` — ver [Desarrollar en local](../how-to/desarrollar-en-local.md).
