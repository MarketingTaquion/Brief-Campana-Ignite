# Desarrollar en local

Para probar cambios al formulario o al panel sin deployar cada vez.

## 1. Configurar credenciales locales

```bash
cp public/config.example.js public/config.js
```

Completá `public/config.js` con la `SUPABASE_URL` y `SUPABASE_ANON_KEY` reales (ver [Variables de entorno](../reference/variables-de-entorno.md) para dónde conseguirlas). Este archivo está en `.gitignore` — nunca se commitea, así que no hay riesgo de subir credenciales por accidente.

## 2. Levantar el servidor local

```bash
npm run dev
```

Esto corre `scripts/generate-config.js` (que en este caso no pisa el `config.js` que acabás de crear a mano — solo lo regenera si hay variables de entorno en el shell) y levanta un servidor estático en `http://localhost:5173` sirviendo la carpeta `public/`.

<!-- TODO(humano): confirmar el comportamiento exacto de `npm run dev` cuando `public/config.js` ya existe a mano Y hay variables de entorno SUPABASE_* seteadas en el shell local al mismo tiempo — por lectura de scripts/generate-config.js el script no distingue el origen, así que probablemente sobreescriba el config.js manual con lo que haya (o no haya) en el entorno. No se pudo ejecutar el comando para verificarlo en el entorno donde se escribió esta guía (sin Node disponible). -->

## 3. Probar el flujo completo

1. Abrí `http://localhost:5173` → deberías ver el formulario apuntando a tu proyecto real de Supabase (no a uno de prueba — no hay modo mock en este proyecto).
2. Completá y enviá un brief de prueba.
3. Abrí `http://localhost:5173/panel.html` → el brief debería aparecer ahí.
4. Borrá la fila de prueba desde el **Table Editor** de Supabase cuando termines.
