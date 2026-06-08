-- ============================================
-- ダイエットアプリ Supabase セットアップSQL
-- お金管理アプリと同じプロジェクトの SQL Editor で実行してください
-- （お金のテーブルとは別。diet_ で始まる専用テーブルを作ります）
--
-- このSQLは何度実行してもOK（毎回きれいに作り直します）。
-- diet_ テーブルだけを対象にしており、お金のテーブルには触れません。
-- ============================================

-- 既存の diet_ テーブルをいったん削除（空なので安全に作り直せます）
DROP TABLE IF EXISTS diet_weights   CASCADE;
DROP TABLE IF EXISTS diet_meals     CASCADE;
DROP TABLE IF EXISTS diet_exercises CASCADE;
DROP TABLE IF EXISTS diet_water     CASCADE;
DROP TABLE IF EXISTS diet_habits    CASCADE;

-- 体重テーブル（1日1件・同じ日は上書き）
CREATE TABLE diet_weights (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  day DATE NOT NULL UNIQUE,
  value NUMERIC NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 食事テーブル（1日に複数件）
CREATE TABLE diet_meals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  day DATE NOT NULL,
  mtype TEXT NOT NULL,
  name TEXT NOT NULL,
  kcal INTEGER NOT NULL DEFAULT 0,
  prot INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 運動テーブル（1日に複数件）
CREATE TABLE diet_exercises (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  day DATE NOT NULL,
  name TEXT NOT NULL,
  minutes INTEGER NOT NULL DEFAULT 0,
  steps INTEGER NOT NULL DEFAULT 0,
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 水分テーブル（1日1件・同じ日は上書き）
CREATE TABLE diet_water (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  day DATE NOT NULL UNIQUE,
  cups INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 習慣テーブル（睡眠・むくみ対策／1日1件・同じ日は上書き）
CREATE TABLE diet_habits (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  day DATE NOT NULL UNIQUE,
  sleep NUMERIC NOT NULL DEFAULT 0,
  salt BOOLEAN NOT NULL DEFAULT false,
  alcohol BOOLEAN NOT NULL DEFAULT false,
  carb BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security を有効化
ALTER TABLE diet_weights   ENABLE ROW LEVEL SECURITY;
ALTER TABLE diet_meals     ENABLE ROW LEVEL SECURITY;
ALTER TABLE diet_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE diet_water     ENABLE ROW LEVEL SECURITY;
ALTER TABLE diet_habits    ENABLE ROW LEVEL SECURITY;

-- 匿名ユーザー（ログインなし）に全操作を許可
CREATE POLICY "anon_all_diet_weights"   ON diet_weights   FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_diet_meals"     ON diet_meals     FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_diet_exercises" ON diet_exercises FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_diet_water"     ON diet_water     FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_diet_habits"    ON diet_habits    FOR ALL TO anon USING (true) WITH CHECK (true);

-- PostgREST のスキーマキャッシュを更新（これをしないと「列が見つからない」エラーが残ることがあります）
NOTIFY pgrst, 'reload schema';
