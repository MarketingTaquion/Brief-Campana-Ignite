# ignite-brief — Brief de Campaña (Ignite)

Formulario online + panel interno para el brief de campaña de Taquion. Implementación de [`specs/005-brief-campana-ignite.md`](../SDD-TAQUION/specs/005-brief-campana-ignite.md) — leé esa spec primero para el contexto y los criterios de aceptación.

Sitio estático (HTML/CSS/JS, sin framework) + [Supabase](https://supabase.com) como base de datos. No hace falta servidor propio: el navegador habla directo con Supabase usando la clave `anon` (pública por diseño; la protección real la dan las políticas de RLS en `supabase/schema.sql`).

**Estado de acceso: MVP sin protección.** El formulario y el panel son públicos para cualquiera que tenga el link — decisión tomada explícitamente, ver la spec.

## Estructura

```
ignite-brief/
├── public/                  ← esto es lo que se deploya
│   ├── index.html            formulario
│   ├── panel.html            panel interno (lista + detalle + estado)
│   ├── tokens.css            subset de Taquion 2026 Design System
│   ├── app.css                estilos compartidos (mismo patrón que el form de intake de pedidos)
│   ├── supabase-client.js    cliente de Supabase (ESM vía CDN, sin build)
│   ├── fonts/                Archivo (Regular/Medium/SemiBold/Bold/Black)
│   └── config.example.js     plantilla — NO se commitea el config.js real
├── scripts/generate-config.js ← genera public/config.js en cada build, desde env vars
├── supabase/schema.sql        ← tabla + políticas RLS, correr una sola vez en Supabase
├── package.json                "build" corre generate-config.js
├── vercel.json / netlify.toml  build command + output directory
```

## Puesta en marcha (una sola vez)

### 1. Crear el proyecto de Supabase
1. Entrá a [supabase.com](https://supabase.com) → **New project** (plan Free alcanza).
2. Una vez creado: **SQL Editor** → **New query** → pegá el contenido de [`supabase/schema.sql`](supabase/schema.sql) → **Run**. Esto crea la tabla `campaign_briefs` y las políticas de acceso.
3. **Project Settings → API** → copiá:
   - **Project URL** → esto es `SUPABASE_URL`.
   - **anon public key** → esto es `SUPABASE_ANON_KEY` (⚠️ no la `service_role`, esa nunca va en el frontend).

### 2. Deployar (Vercel o Netlify, a elección)

**Vercel:**
1. Importá este repo en [vercel.com/new](https://vercel.com/new).
2. Vercel detecta `vercel.json` (build command `npm run build`, output `public`) automáticamente.
3. **Project Settings → Environment Variables** → agregá `SUPABASE_URL` y `SUPABASE_ANON_KEY` con los valores del paso 1.
4. Redeploy (o el primer deploy ya las toma si las cargaste antes de deployar).

**Netlify:**
1. Importá este repo en [app.netlify.com](https://app.netlify.com) → **Add new site**.
2. Netlify detecta `netlify.toml` (build command `npm run build`, publish `public`) automáticamente.
3. **Site configuration → Environment variables** → agregá `SUPABASE_URL` y `SUPABASE_ANON_KEY`.
4. Redeploy.

Sin esas dos variables, el sitio se deploya igual pero el formulario y el panel muestran un aviso de "no configurado" en vez de fallar en blanco.

### 3. Desarrollo local (opcional)
```bash
cp public/config.example.js public/config.js
# completar public/config.js con la URL y la clave anon reales
npm run dev
```
`public/config.js` está en `.gitignore` — nunca se commitea.

## Decisiones de diseño (resumen — ver la spec para el detalle)
- **Sin framework:** no hace falta lógica de servidor propia (las políticas de Supabase resuelven permisos), así que HTML/CSS/JS estático es suficiente y evita mantenimiento de dependencias.
- **Supabase, no una API propia:** mismo patrón que `specs/003-dashboard-consumos.md` (Postgres + RLS en vez de armar auth/almacenamiento a mano).
- **Sin autenticación (MVP):** decisión explícita del usuario (2026-09-13). Si más adelante hace falta protegerlo: la ruta más simple es una contraseña compartida vía variable de entorno consumida por un pequeño middleware/Edge Function; la más robusta es Supabase Auth + RLS por usuario (mismo patrón que dejó documentado `specs/003`).

## Historial
- **2026-09-13 — V1 (MVP):** primera versión, a partir de `Brief_Campaña_ignite_ops_Taquion_ES.pdf` (plantilla genérica de brief de campaña). Ver `specs/005-brief-campana-ignite.md` en `SDD-TAQUION` para el detalle completo.
