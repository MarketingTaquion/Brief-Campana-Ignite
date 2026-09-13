# Instalación del workflow — Brief de Campaña (Ignite) → Documento en Drive

Este workflow conecta el formulario ya deployado de [`ignite-brief`](../README.md) con un proceso automático que genera un Google Doc + PDF formal por cada brief recibido, y lo guarda en una carpeta de Drive. Es un proceso **distinto** al de `automatizacion-briefs-n8n/` (ese cubre el intake de pedido de cliente; este cubre el brief de campaña ya definida) — no se fusionan.

## Por qué el disparador es Supabase y no el formulario

`ignite-brief` ya guarda cada envío en Supabase (tabla `campaign_briefs`) y lo muestra en el panel interno — esa parte no depende de n8n. Este workflow se engancha **después**, escuchando los inserts de esa misma tabla vía un **Database Webhook** de Supabase, en vez de que el formulario le hable directo a n8n. Ventajas:
- Cero cambios en `public/index.html` (ya deployado en Vercel) ni redeploy.
- Si n8n está caído o mal configurado, el brief igual quedó guardado y visible en el panel — no se pierde nada, solo no se generó el documento todavía.
- Supabase reintenta el webhook automáticamente si n8n no responde 2xx.

## 1. Importar el workflow

En n8n: **Workflows → Import from File** → `Brief-Campana-Ignite-Supabase-Webhook.json`.

## 2. Crear las credenciales necesarias

| Credencial en n8n | Tipo | Usada por |
|---|---|---|
| Header Auth (nombre libre, ej. "Supabase Webhook Secret") | `Header Auth` | Recibir Brief (Webhook) — valida que el POST venga realmente de Supabase |
| Google Drive account | `Google Drive OAuth2 API` | Copiar Plantilla de Brief de Campaña, Exportar a PDF, Guardar PDF en Drive |
| Google Docs account | `Google Docs OAuth2 API` | Completar Brief de Campaña (Google Docs API) — como *Predefined Credential Type* dentro del nodo HTTP Request |

Si Taquion ya tiene las credenciales de Google Drive/Docs creadas para `automatizacion-briefs-n8n`, **son las mismas** — no hace falta duplicarlas, solo seleccionarlas en los nodos de este workflow.

Para la credencial **Header Auth**: al crearla, n8n pide un nombre de header (ej. `X-Webhook-Secret`) y un valor (generá un string random largo). Anotá ambos — los vas a necesitar en el paso 4.

## 3. Crear la plantilla de Google Docs

Ver [`Plantilla-Google-Docs-Brief-Campana.md`](Plantilla-Google-Docs-Brief-Campana.md) para el contenido y los placeholders exactos.

Una vez creada:
1. Abrí el nodo **Copiar Plantilla de Brief de Campaña**.
2. En **File** (fileId), pegá el ID de la plantilla.
3. En **Options → Folder**, pegá el ID de la carpeta de Drive donde se van a guardar los briefs de campaña.
4. Repetí el mismo ID de carpeta en **Guardar PDF en Drive → Options → Parent Folder**.

## 4. Configurar el Database Webhook en Supabase

1. En el dashboard de Supabase del proyecto de `ignite-brief` → **Database → Webhooks → Create a new webhook**.
2. **Table**: `campaign_briefs`.
3. **Events**: marcar únicamente **Insert** (dejar Update y Delete sin marcar — si se marca Update, cada cambio de estado en el panel dispararía un documento nuevo).
4. **Type**: `HTTP Request`.
5. **URL**: la **Production URL** del nodo **Recibir Brief (Webhook)** en n8n (activá el workflow primero para que exista).
6. **HTTP Headers**: agregá el mismo header/valor que generaste en el paso 2 (ej. `X-Webhook-Secret: <el-valor-random>`).
7. Guardar.

## 5. Probar antes de activar

1. Con el workflow en modo test, completá el formulario de `ignite-brief` con datos de prueba.
2. Revisá la ejecución en n8n:
   - Que el nodo **¿Es un INSERT?** haya tomado la rama verdadera.
   - Que el documento se copie en Drive y los placeholders se reemplacen (abrilo y confirmá que no queda ningún `{{...}}` sin reemplazar).
   - Que el PDF quede guardado en la misma carpeta.
3. Recién ahí activá el workflow (toggle **Active**).

## Notas de mantenimiento

- **Agregar un campo al formulario:** sumarlo en `ignite-brief/public/index.html`, en la migración de `supabase/schema.sql` (nueva columna), en el nodo **Normalizar Datos del Brief** (nuevo assignment leyendo `$json.body.record.<columna>`) y en los `placeholders` del nodo **Armar Placeholders del Brief** — y agregar el placeholder correspondiente a la plantilla de Google Docs.
- **Cambiar la plantilla:** editar el Google Doc plantilla directamente; si se agregan placeholders nuevos, sumarlos también al Code node.
- **Reactivar el envío por email:** si más adelante se quiere notificar a alguien (Ignite, el solicitante), agregar un nodo **Gmail** después de "Guardar PDF en Drive", igual que en `automatizacion-briefs-n8n/workflow/Automatizacion-Briefs-Taquion-Webhook.json` (mismo patrón: adjuntar el binario `data` del nodo "Exportar a PDF").
