# Agregar un campo al formulario

Un campo nuevo en el brief de campaña toca cuatro lugares distintos — si te olvidás uno, el dato se pierde en algún punto del camino sin error visible. Esta guía es la checklist completa, en orden.

## 1. El formulario (`public/index.html`)

Agregá el input/checkbox/radio correspondiente, con su `name` correspondiente en snake_case (así sale directo como columna en Supabase). Mirá [Modelo de datos](../reference/modelo-de-datos.md) para los tipos de campo que ya existen (texto simple, textarea, checkbox múltiple, radio, etc.) y seguí el mismo patrón que un campo similar.

## 2. La tabla de Supabase (`supabase/schema.sql`)

Sumá la columna nueva en **dos** lugares del mismo archivo:
- En el bloque `create table if not exists` (para que instalaciones nuevas la tengan desde el arranque).
- En un `alter table ... add column if not exists` (para que correr el archivo de nuevo sobre una base ya creada la agregue sin romper nada).

Volvé a correr el archivo completo en el **SQL Editor** de Supabase de producción — es idempotente, no rompe lo que ya existe.

## 3. Si la automatización de n8n está activa

Si el workflow de generación de documentos ([Configurar la automatización de n8n](./configurar-automatizacion-n8n.md)) está corriendo, el campo nuevo también tiene que llegar al documento generado:

1. En el nodo **Normalizar Datos del Brief**: agregar un assignment nuevo leyendo `$json.body.record.<nombre_de_tu_columna>`.
2. En el nodo **Armar Placeholders del Brief**: agregar el placeholder correspondiente.
3. En la plantilla de Google Docs: agregar el placeholder nuevo en el lugar donde debe aparecer el dato (ver [`n8n/Plantilla-Google-Docs-Brief-Campana.md`](../../n8n/Plantilla-Google-Docs-Brief-Campana.md) para el formato exacto de los placeholders existentes).

Si la automatización no está activa todavía, podés saltear este paso — no hay nada corriendo que dependa del campo nuevo.

## 4. Verificar de punta a punta

1. Completá el formulario con datos de prueba, incluyendo el campo nuevo.
2. Confirmá en el **Table Editor** de Supabase que el valor llegó a la columna nueva.
3. Si la automatización de n8n está activa, confirmá que el documento generado tiene el valor en el lugar correcto (sin ningún `{{placeholder}}` sin reemplazar).
4. Borrá la fila de prueba.
