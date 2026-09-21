# Estructura del proyecto

```
ignite-brief/
├── public/                        ← esto es lo que se deploya (outputDirectory)
│   ├── index.html                  formulario
│   ├── panel.html                  panel interno (lista + detalle + estado)
│   ├── tokens.css                  subset de Taquion 2026 Design System
│   ├── app.css                     estilos compartidos (mismo patrón que el form de intake de pedidos)
│   ├── supabase-client.js          cliente de Supabase (ESM vía CDN, sin build de JS)
│   ├── fonts/                      Archivo (Regular/Medium/SemiBold/Bold/Black)
│   └── config.example.js           plantilla — NO se commitea el config.js real
├── scripts/
│   └── generate-config.js          genera public/config.js en cada build, desde env vars
├── supabase/
│   └── schema.sql                  tabla + políticas RLS + bucket de Storage — correr en el SQL Editor de Supabase
├── n8n/                             automatización opcional: brief → Google Doc/PDF en Drive
│   ├── Brief-Campana-Ignite-Supabase-Webhook.json
│   ├── Plantilla-Google-Docs-Brief-Campana.md
│   └── README-Instalacion.md
├── docs/                            esta documentación (Diátaxis)
├── package.json                     scripts "build" y "dev"
├── vercel.json                      build command + output directory (Vercel)
└── netlify.toml                     build command + publish directory (Netlify)
```

No hay backend propio: es un sitio estático (HTML/CSS/JS, sin framework ni bundler) que habla directo con Supabase desde el navegador usando la clave `anon`. Ver [Decisiones de arquitectura](../explanation/decisiones-de-arquitectura.md) para por qué.
