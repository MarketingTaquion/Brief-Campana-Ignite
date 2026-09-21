# Primer despliegue

Esta guía te lleva de cero a tener el formulario y el panel de `ignite-brief` funcionando en producción. Al final vas a tener un link público donde cualquiera puede completar un brief de campaña, y un panel donde el equipo puede verlos y cambiarles el estado.

No hace falta escribir código ni tener Node instalado en tu máquina para este tutorial — todo el paso a paso ocurre en el dashboard de Supabase y en el de Vercel/Netlify.

## 1. Crear el proyecto de Supabase

1. Entrá a [supabase.com](https://supabase.com) → **New project** (el plan Free alcanza).
2. Una vez creado, abrí **SQL Editor → New query**, pegá el contenido completo de [`supabase/schema.sql`](../../supabase/schema.sql) y apretá **Run**.

   Esto crea la tabla `campaign_briefs`, las políticas de acceso, y el bucket de Storage para los archivos que se suben desde el formulario. El detalle de qué crea exactamente está en [Modelo de datos](../reference/modelo-de-datos.md) — para este tutorial alcanza con correrlo.
3. Andá a **Project Settings → API** y copiá dos valores, los vas a necesitar en el paso 3:
   - **Project URL** → esto es `SUPABASE_URL`.
   - **anon public key** → esto es `SUPABASE_ANON_KEY`.

   ⚠️ No copies la `service_role` key — esa nunca va en el frontend, solo la `anon` (pública por diseño; ver [Decisiones de arquitectura](../explanation/decisiones-de-arquitectura.md) para por qué esto es seguro).

## 2. Elegir dónde deployar

El proyecto ya viene configurado para las dos plataformas — elegí una (o las dos, no son excluyentes):

**Opción A — Vercel:**
1. Importá este repo en [vercel.com/new](https://vercel.com/new).
2. Vercel detecta `vercel.json` solo (build command `npm run build`, output `public`).

**Opción B — Netlify:**
1. Importá este repo en [app.netlify.com](https://app.netlify.com) → **Add new site**.
2. Netlify detecta `netlify.toml` solo (build command `npm run build`, publish `public`).

## 3. Cargar las variables de entorno

En la plataforma que elegiste, agregá las dos variables que copiaste en el paso 1:

| Variable | De dónde sale |
|---|---|
| `SUPABASE_URL` | Project Settings → API → Project URL |
| `SUPABASE_ANON_KEY` | Project Settings → API → anon public key |

- **Vercel:** Project Settings → Environment Variables.
- **Netlify:** Site configuration → Environment variables.

Si el proyecto ya se deployó antes de cargar las variables, hacé un redeploy después de agregarlas.

<!-- TODO(humano): tanto Vercel como Netlify tienen "Project visibility"/"Visitor access" en Private por defecto — hay que cambiarlo a público explícitamente (Vercel: Deployment Protection; Netlify: Project configuration → Visitor access) para que el link funcione sin login. Confirmar que este paso sigue siendo necesario en la versión actual de cada plataforma, puede haber cambiado. -->

## 4. Verificar que funciona

Sin las variables de entorno cargadas, el sitio se deploya igual pero el formulario y el panel muestran un aviso de "no configurado" en vez de fallar en blanco — así que si ves ese aviso después de este paso, revisá que las variables estén bien escritas (son sensibles a mayúsculas y no deben tener espacios extra).

Con las variables cargadas:
1. Abrí la URL pública del deploy → deberías ver el formulario.
2. Completalo con datos de prueba y enviá.
3. Abrí `/panel.html` en la misma URL → el brief que enviaste debería aparecer ahí.
4. Borrá la fila de prueba desde el **Table Editor** de Supabase para no dejar datos falsos en producción.

Con esto el proyecto ya está funcionando de punta a punta. La automatización opcional que genera un documento de Google Docs/PDF por cada brief nuevo no viene activada por defecto — es un paso aparte, ver [Configurar la automatización de n8n](../how-to/configurar-automatizacion-n8n.md) si la necesitás.
