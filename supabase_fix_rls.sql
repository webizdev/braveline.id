-- Universal fix for Braveline tables to allow full access for admin roles (anon/authenticated)
-- Applied on 2026-03-27

-- Fix braveline_katalog
DROP POLICY IF EXISTS "anon_all" ON "braveline_katalog";
CREATE POLICY "anon_all" ON "braveline_katalog" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- Fix braveline_testimonials
DROP POLICY IF EXISTS "anon_all" ON "braveline_testimonials";
DROP POLICY IF EXISTS "Anon write" ON "braveline_testimonials";
CREATE POLICY "anon_all" ON "braveline_testimonials" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- Fix braveline_site_settings
DROP POLICY IF EXISTS "Anon write" ON "braveline_site_settings";
CREATE POLICY "anon_all" ON "braveline_site_settings" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- Fix braveline_hero
DROP POLICY IF EXISTS "anon_all" ON "braveline_hero";
CREATE POLICY "anon_all" ON "braveline_hero" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- Fix other relevant tables to prevent future issues
DROP POLICY IF EXISTS "anon_all" ON "braveline_usp_cards";
CREATE POLICY "anon_all" ON "braveline_usp_cards" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_all" ON "braveline_harga_paket";
CREATE POLICY "anon_all" ON "braveline_harga_paket" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_all" ON "braveline_carousel";
CREATE POLICY "anon_all" ON "braveline_carousel" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_all" ON "braveline_faq";
CREATE POLICY "anon_all" ON "braveline_faq" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_all" ON "braveline_proses_order";
CREATE POLICY "anon_all" ON "braveline_proses_order" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_all" ON "braveline_carousel_foto";
CREATE POLICY "anon_all" ON "braveline_carousel_foto" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_all" ON "braveline_kategori";
CREATE POLICY "anon_all" ON "braveline_kategori" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_all" ON "braveline_footer_info";
CREATE POLICY "anon_all" ON "braveline_footer_info" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- Fix Storage RLS Policies for Braveline buckets
-- Applied on 2026-03-27

-- Allow public insert/upload to braveline buckets
CREATE POLICY "Braveline public upload" ON storage.objects
FOR INSERT TO public WITH CHECK (bucket_id IN ('braveline-katalog', 'braveline-carousel', 'braveline-avatar'));

-- Allow public read access to braveline buckets
CREATE POLICY "Braveline public read" ON storage.objects
FOR SELECT TO public USING (bucket_id IN ('braveline-katalog', 'braveline-carousel', 'braveline-avatar'));

-- Allow public update access to braveline buckets
CREATE POLICY "Braveline public update" ON storage.objects
FOR UPDATE TO public USING (bucket_id IN ('braveline-katalog', 'braveline-carousel', 'braveline-avatar'));

-- Allow public delete access to braveline buckets
CREATE POLICY "Braveline public delete" ON storage.objects
FOR DELETE TO public USING (bucket_id IN ('braveline-katalog', 'braveline-carousel', 'braveline-avatar'));

