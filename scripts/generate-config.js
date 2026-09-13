// Genera public/config.js a partir de variables de entorno en tiempo de build.
// Se corre en cada deploy de Vercel/Netlify (ver package.json "build" y
// vercel.json / netlify.toml) — así las claves de Supabase nunca quedan
// commiteadas en el repo, solo viven como env vars en el dashboard de hosting.
const fs = require('fs');
const path = require('path');

const url = process.env.SUPABASE_URL || '';
const anonKey = process.env.SUPABASE_ANON_KEY || '';

if (!url || !anonKey) {
  console.warn(
    '[generate-config] SUPABASE_URL y/o SUPABASE_ANON_KEY no están seteadas. ' +
    'El sitio se va a deployar igual, pero el formulario y el panel van a mostrar ' +
    'el aviso de "no configurado" hasta que se agreguen esas variables de entorno ' +
    'y se vuelva a deployar. Ver README.md.'
  );
}

const out = `// Generado automáticamente en build time por scripts/generate-config.js — no editar a mano.
window.IGNITE_BRIEF_CONFIG = {
  SUPABASE_URL: ${JSON.stringify(url)},
  SUPABASE_ANON_KEY: ${JSON.stringify(anonKey)},
};
`;

const outPath = path.join(__dirname, '..', 'public', 'config.js');
fs.writeFileSync(outPath, out);
console.log('[generate-config] public/config.js generado (' + (url ? 'con' : 'SIN') + ' credenciales).');
