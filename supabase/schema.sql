-- ignite-brief — esquema de Supabase (Postgres)
-- Ejecutar en: Supabase Dashboard → tu proyecto → SQL Editor → New query → pegar y correr.
--
-- Decisión de acceso (ver specs/005-brief-campana-ignite.md): MVP sin autenticación.
-- Las políticas de abajo permiten a CUALQUIERA con la clave anon (pública, la que
-- va en config.js) insertar, leer y actualizar el estado de los briefs. Es una
-- decisión de producto explícita para esta primera versión, no un descuido —
-- endurecerla (login, RLS por usuario) es un paso posterior si hace falta.

-- Este archivo es idempotente: correrlo de nuevo sobre una base ya creada no
-- rompe nada. Cuando se agrega un campo nuevo al formulario, se suma acá tanto
-- a la definición de "create table" (para instalaciones nuevas) como a un
-- "alter table ... add column if not exists" (para las que ya existen) —
-- así una sola corrida de este archivo deja cualquier base al día.

create extension if not exists "pgcrypto";

create table if not exists public.campaign_briefs (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),

  -- Campaña
  nombre_campana text not null,
  solicitado_por text not null,
  email_solicitante text not null,

  -- Contexto
  contexto text,

  -- Objetivo
  objetivos text[] default '{}',
  objetivo_otro text,

  -- Audiencia objetivo
  audiencia_demografica text,
  audiencia_geografica text,
  audiencia_psicografia text,
  audiencia_comportamientos text,

  -- Embudo y destino
  etapa_embudo text,
  pagina_destino text,

  -- Presupuesto y duración
  presupuesto numeric,
  duracion_fechas date[] default '{}',

  -- Canales y entregables
  canales text[] default '{}',
  entregables text[] default '{}',
  entregable_otro text,

  -- Mensaje
  mensaje_central text,
  mensaje_principal text,
  piezas_titulares text,
  mensajes_secundarios text,
  llamados_accion text,

  -- Dirección estratégica y creativa
  direccion_creativa text,

  -- Preferencias e identidad
  preferencias_identidad text[] default '{}',
  preferencias_otro text,
  elementos_marca text[] default '{}',

  -- Adicional
  informacion_adicional text,
  recursos_clave text,

  -- Triage operativo del panel
  estado text not null default 'Nuevo' check (estado in ('Nuevo', 'En revisión', 'Aprobado'))
);

-- Migración idempotente: agrega columnas nuevas a una tabla que ya existía
-- antes de que se sumaran estos campos al formulario (2026-09-14).
alter table public.campaign_briefs
  add column if not exists presupuesto numeric,
  add column if not exists duracion_fechas date[] default '{}';

create index if not exists campaign_briefs_created_at_idx on public.campaign_briefs (created_at desc);

alter table public.campaign_briefs enable row level security;

-- Cualquiera (rol anon) puede insertar un brief nuevo.
drop policy if exists "anon puede insertar briefs" on public.campaign_briefs;
create policy "anon puede insertar briefs"
  on public.campaign_briefs for insert
  to anon
  with check (true);

-- Cualquiera (rol anon) puede leer todos los briefs — panel sin login (MVP).
drop policy if exists "anon puede leer briefs" on public.campaign_briefs;
create policy "anon puede leer briefs"
  on public.campaign_briefs for select
  to anon
  using (true);

-- Cualquiera (rol anon) puede actualizar el estado desde el panel — MVP sin login.
drop policy if exists "anon puede actualizar estado" on public.campaign_briefs;
create policy "anon puede actualizar estado"
  on public.campaign_briefs for update
  to anon
  using (true)
  with check (true);

-- ============================================================
-- Storage: bucket para los archivos subidos en "Recursos clave"
-- ============================================================

-- Bucket público (2026-09-14): los archivos que se suben desde el
-- botón "Subir archivo" del formulario se guardan acá. Es público para
-- que el link funcione directo en el panel sin pedir login — mismo
-- criterio de acceso "MVP sin protección" que el resto de esta spec.
insert into storage.buckets (id, name, public)
values ('briefs-recursos', 'briefs-recursos', true)
on conflict (id) do nothing;

drop policy if exists "anon puede subir archivos de brief" on storage.objects;
create policy "anon puede subir archivos de brief"
  on storage.objects for insert
  to anon
  with check (bucket_id = 'briefs-recursos');

-- Deliberadamente SIN política de select: el bucket ya es público, así que
-- los links directos (getPublicUrl) funcionan sin ninguna política. Sumar
-- una política de select acá habilitaría además *listar* todos los archivos
-- del bucket vía API — Supabase lo marca como advertencia de seguridad
-- ("Clients can list all files in this bucket") porque no hace falta para
-- este caso de uso y expone más de lo necesario.
