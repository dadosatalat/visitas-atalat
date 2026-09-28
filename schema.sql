-- ==============================================================================
-- ATALAT — SISTEMA DE GESTÃO DE VISITAS A PRODUTORES DE LEITE
-- SCRIPT DE CRIAÇÃO DE TABELAS E POLÍTICAS NO SUPABASE (POSTGRESQL)
-- ==============================================================================
-- Como usar:
-- 1. Acesse seu painel no Supabase (https://supabase.com)
-- 2. Vá em "SQL Editor" no menu lateral esquerdo
-- 3. Clique em "New query", cole todo este código e clique em "Run" (Executar).
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

-- 3. ÍNDICES DE PERFORMANCE PARA BUSCA E RELATÓRIOS
CREATE INDEX IF NOT EXISTS idx_visitas_type ON public.visitas(type);
CREATE INDEX IF NOT EXISTS idx_visitas_visit_date ON public.visitas(visit_date DESC);
CREATE INDEX IF NOT EXISTS idx_visitas_producer_name ON public.visitas(producer_name);
CREATE INDEX IF NOT EXISTS idx_visitas_risk_level ON public.visitas(risk_level);
CREATE INDEX IF NOT EXISTS idx_visitas_completed ON public.visitas(completed);

-- 4. HABILITAR ROW LEVEL SECURITY (RLS)
ALTER TABLE public.visitas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tipos_visitas ENABLE ROW LEVEL SECURITY;

-- 5. POLÍTICAS DE ACESSO (Permitir Leitura e Gravação com Chave Anônima)
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

-- 6. HABILITAR REALTIME (Opcional - para sincronização instantânea entre múltiplos dispositivos)
ALTER PUBLICATION supabase_realtime ADD TABLE public.visitas;
ALTER PUBLICATION supabase_realtime ADD TABLE public.tipos_visitas;

COMMENT ON TABLE public.visitas IS 'Tabela de visitas a produtores de leite da Atalat (Compra, Relacionamento, Comercial, Defesa, Perda).';
COMMENT ON TABLE public.tipos_visitas IS 'Modelos de formulários customizados para questionários dinâmicos da Atalat.';
