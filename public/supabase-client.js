// Cliente de Supabase compartido por index.html (formulario) y panel.html.
// SUPABASE_URL / SUPABASE_ANON_KEY vienen de config.js, generado en build time
// desde variables de entorno (ver scripts/generate-config.js y README.md).
// La clave anon es pública por diseño de Supabase: la protección real la dan
// las políticas de RLS de supabase/schema.sql, no el secreto de esta clave.

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

function getConfig() {
  const cfg = window.IGNITE_BRIEF_CONFIG || {};
  if (!cfg.SUPABASE_URL || !cfg.SUPABASE_ANON_KEY) {
    return null;
  }
  return cfg;
}

export function isConfigured() {
  return getConfig() !== null;
}

let _client = null;
export function getSupabase() {
  if (_client) return _client;
  const cfg = getConfig();
  if (!cfg) return null;
  _client = createClient(cfg.SUPABASE_URL, cfg.SUPABASE_ANON_KEY);
  return _client;
}
