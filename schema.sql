-- ==============================================================================
-- ATALAT — SISTEMA DE GESTÃO DE VISITAS A PRODUTORES DE LEITE
-- SCRIPT DE CRIAÇÃO DE TABELAS, USUÁRIOS E POLÍTICAS NO SUPABASE (POSTGRESQL)
-- ==============================================================================
-- Como usar:
-- 1. Acesse seu painel no Supabase (https://supabase.com/dashboard/project/lfrdwmrkzlrvzvhmqvhz/sql)
-- 2. Cole este código no SQL Editor e clique em "Run" (Executar).
-- ==============================================================================

-- 1. TABELA DE VISITAS (Registros de campo, prospecção e relacionamento)
CREATE TABLE IF NOT EXISTS public.visitas (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  producer_name TEXT,
  property_name TEXT,
  visit_date DATE,
  responsible TEXT,
  route_city TEXT,
  daily_volume NUMERIC DEFAULT 0,
  risk_level TEXT,
  completed BOOLEAN DEFAULT false,
  data JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. TABELA DE TIPOS DE VISITA CUSTOMIZADOS (Formulários personalizados criados pelos usuários)
CREATE TABLE IF NOT EXISTS public.tipos_visitas (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  short_label TEXT NOT NULL,
  color TEXT DEFAULT '#357EC4',
  sections JSONB NOT NULL DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. TABELA DE USUÁRIOS E AUTORIZAÇÃO DE ACESSO
CREATE TABLE IF NOT EXISTS public.usuarios (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  usuario TEXT UNIQUE NOT NULL,
  senha TEXT NOT NULL,
  email_contato TEXT,
  cargo TEXT DEFAULT 'Comprador / Técnico',
  role TEXT DEFAULT 'membro',       -- 'admin' (pode autorizar membros) ou 'membro' (comprador/técnico)
  status TEXT DEFAULT 'pendente',   -- 'aprovado', 'pendente', 'bloqueado'
  autorizado_por TEXT,
  created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. ÍNDICES DE PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_visitas_type ON public.visitas(type);
CREATE INDEX IF NOT EXISTS idx_visitas_visit_date ON public.visitas(visit_date DESC);
CREATE INDEX IF NOT EXISTS idx_visitas_producer_name ON public.visitas(producer_name);
CREATE INDEX IF NOT EXISTS idx_visitas_risk_level ON public.visitas(risk_level);
CREATE INDEX IF NOT EXISTS idx_visitas_completed ON public.visitas(completed);
CREATE INDEX IF NOT EXISTS idx_usuarios_usuario ON public.usuarios(usuario);
CREATE INDEX IF NOT EXISTS idx_usuarios_status ON public.usuarios(status);

-- 5. HABILITAR ROW LEVEL SECURITY (RLS)
ALTER TABLE public.visitas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tipos_visitas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;

-- 6. POLÍTICAS DE ACESSO (Permitir Leitura e Gravação com Chave Anônima)
DROP POLICY IF EXISTS "Permitir leitura pública de visitas" ON public.visitas;
CREATE POLICY "Permitir leitura pública de visitas" ON public.visitas FOR SELECT USING (true);

DROP POLICY IF EXISTS "Permitir inserção pública de visitas" ON public.visitas;
CREATE POLICY "Permitir inserção pública de visitas" ON public.visitas FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Permitir atualização pública de visitas" ON public.visitas;
CREATE POLICY "Permitir atualização pública de visitas" ON public.visitas FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Permitir exclusão pública de visitas" ON public.visitas;
CREATE POLICY "Permitir exclusão pública de visitas" ON public.visitas FOR DELETE USING (true);

DROP POLICY IF EXISTS "Permitir leitura pública de tipos" ON public.tipos_visitas;
CREATE POLICY "Permitir leitura pública de tipos" ON public.tipos_visitas FOR SELECT USING (true);

DROP POLICY IF EXISTS "Permitir inserção pública de tipos" ON public.tipos_visitas;
CREATE POLICY "Permitir inserção pública de tipos" ON public.tipos_visitas FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Permitir atualização pública de tipos" ON public.tipos_visitas;
CREATE POLICY "Permitir atualização pública de tipos" ON public.tipos_visitas FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Permitir exclusão pública de tipos" ON public.tipos_visitas;
CREATE POLICY "Permitir exclusão pública de tipos" ON public.tipos_visitas FOR DELETE USING (true);

DROP POLICY IF EXISTS "Permitir leitura pública de usuarios" ON public.usuarios;
CREATE POLICY "Permitir leitura pública de usuarios" ON public.usuarios FOR SELECT USING (true);

DROP POLICY IF EXISTS "Permitir inserção pública de usuarios" ON public.usuarios;
CREATE POLICY "Permitir inserção pública de usuarios" ON public.usuarios FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Permitir atualização pública de usuarios" ON public.usuarios;
CREATE POLICY "Permitir atualização pública de usuarios" ON public.usuarios FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Permitir exclusão pública de usuarios" ON public.usuarios;
CREATE POLICY "Permitir exclusão pública de usuarios" ON public.usuarios FOR DELETE USING (true);

-- 7. HABILITAR REALTIME
ALTER PUBLICATION supabase_realtime ADD TABLE public.visitas;
ALTER PUBLICATION supabase_realtime ADD TABLE public.tipos_visitas;
ALTER PUBLICATION supabase_realtime ADD TABLE public.usuarios;

-- 8. INSERIR USUÁRIOS ADMINISTRADORES PADRÃO (SE NÃO EXISTIREM)
INSERT INTO public.usuarios (id, nome, usuario, senha, email_contato, cargo, role, status, autorizado_por)
VALUES 
(
  'usr_italo_admin',
  'Ítalo Silva',
  'italo.pauloip01@gmail.com',
  '75648054',
  'italo.pauloip01@gmail.com',
  'Administrador Geral',
  'admin',
  'aprovado',
  'Sistema Atalat'
),
(
  'usr_admin_master',
  'Administrador Atalat',
  'admin',
  'atalat2026',
  'admin@atalat.com.br',
  'Diretoria / Gestão',
  'admin',
  'aprovado',
  'Sistema Atalat'
)
ON CONFLICT (usuario) DO NOTHING;
