create table if not exists pl_intakes (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),

  -- Contact Info
  contact_name text,
  email text,
  phone text,

  -- Business Info
  company text,
  team_size text,
  industry text,

  -- Pain Points & Goals
  workflow_pains text,
  workflow_goals text,
  current_tools text,
  systems_used text,

  -- Metadata
  source_url text,
  form_version text,
  user_agent text,
  ip_address text,

  -- Status
  status text default 'new'
);

create table if not exists pl_intent_classification (
  id uuid primary key default gen_random_uuid(),
  intake_id uuid references pl_intakes(id) on delete cascade,

  intent text,
  confidence numeric,
  source_url text,
  extracted_keywords text[],
  created_at timestamptz default now()
);

create table if not exists pl_lead_scores (
  id uuid primary key default gen_random_uuid(),
  intake_id uuid references pl_intakes(id) on delete cascade,

  total_score int,
  intent_score int,
  urgency_score int,
  budget_score int,
  company_size_score int,
  pain_score int,

  created_at timestamptz default now()
);
