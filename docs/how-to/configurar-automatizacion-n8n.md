# Configurar la automatización de n8n

Esta automatización es **opcional**: el formulario y el panel funcionan igual de completo sin ella. Lo que agrega es que, por cada brief nuevo, se genera automáticamente un Google Doc + PDF formal a partir de una plantilla, guardado en una carpeta de Drive.

Es un proceso distinto al de `automatizacion-briefs-n8n/` (ese cubre el intake de pedido de cliente; este cubre el brief de campaña ya definida) — no se fusionan, aunque comparten patrón y algunas credenciales.

## 1. Importar el workflow

En n8n: **Workflows → Import from File** → [`n8n/Brief-Campana-Ignite-Supabase-Webhook.json`](../../n8n/Brief-Campana-Ignite-Supabase-Webhook.json).

## 2. Crear las credenciales necesarias

| Credencial en n8n | Tipo | Usada por |
|---|---|---|
| Header Auth (nombre libre, ej. "Supabase Webhook Secret") | `Header Auth` | Recibir Brief (Webhook) — valida que el POST venga realmente de Supabase |
| Google Drive account | `Google Drive OAuth2 API` | Copiar Plantilla de Brief de Campaña, Exportar a PDF, Guardar PDF en Drive |
| Google Docs account | `Google Docs OAuth2 API` | Completar Brief de Campaña (Google Docs API), como *Predefined Credential Type* dentro del nodo HTTP Request |

Si Taquion ya tiene las credenciales de Google Drive/Docs creadas para `automatizacion-briefs-n8n`, son las mismas — no hace falta duplicarlas, solo seleccionarlas en los nodos de este workflow.

Para la credencial Header Auth: al crearla, n8n pide un nombre de header (ej. `X-Webhook-Secret`) y un valor (generá un string random largo). Anotá ambos, los necesitás en el paso 4.

## 3. Crear la plantilla de Google Docs

Ver [`n8n/Plantilla-Google-Docs-Brief-Campana.md`](../../n8n/Plantilla-Google-Docs-Brief-Campana.md) para el contenido y los placeholders exactos.

Una vez creada:
1. Abrí el nodo **Copiar Plantilla de Brief de Campaña** → en **File** (fileId), pegá el ID de la plantilla.
2. En **Options → Folder**, pegá el ID de la carpeta de Drive donde se van a guardar los briefs de campaña.
3. Repetí el mismo ID de carpeta en **Guardar PDF en Drive → Options → Parent Folder**.

## 4. Configurar el Database Webhook en Supabase

1. Dashboard de Supabase del proyecto de `ignite-brief` → **Database → Webhooks → Create a new webhook**.
2. **Table**: `campaign_briefs`.
3. **Events**: marcar únicamente **Insert** (dejar Update y Delete sin marcar — si se marca Update, cada cambio de estado en el panel dispararía un documento nuevo).
4. **Type**: `HTTP Request`.
5. **URL**: la Production URL del nodo **Recibir Brief (Webhook)** en n8n (activá el workflow primero para que exista esa URL).
6. **HTTP Headers**: agregá el mismo header/valor que generaste en el paso 2 (ej. `X-Webhook-Secret: <el-valor-random>`).
7. Guardar.

## 5. Probar antes de activar

1. Con el workflow en modo test, completá el formulario con datos de prueba.
2. Revisá la ejecución en n8n: que el nodo **¿Es un INSERT?** haya tomado la rama verdadera, que el documento se copie en Drive con los placeholders reemplazados (sin ningún `{{...}}` sobrante), y que el PDF quede guardado en la carpeta correcta.
3. Recién ahí activá el workflow (toggle **Active**).

## Notas de mantenimiento

- **Agregar un campo al formulario:** este workflow es uno de los cuatro lugares que hay que tocar — ver la checklist completa en [Agregar un campo al formulario](./agregar-un-campo-al-formulario.md).
- **Cambiar la plantilla:** editar el Google Doc plantilla directamente; si se agregan placeholders nuevos, sumarlos también al nodo de código que arma los placeholders.
- **Reactivar el envío por email:** si más adelante se quiere notificar a alguien (Ignite, el solicitante), agregar un nodo Gmail después de "Guardar PDF en Drive" — mismo patrón que en `automatizacion-briefs-n8n/workflow/Automatizacion-Briefs-Taquion-Webhook.json` (adjuntando el binario `data` del nodo "Exportar a PDF").
