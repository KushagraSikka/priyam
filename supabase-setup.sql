-- Run this in your Supabase SQL Editor (Dashboard > SQL Editor > New Query)

-- 1. Comments / Fan Wall posts table
CREATE TABLE fan_wall (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL DEFAULT 'Anonymous Stan',
    message TEXT NOT NULL,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable Row Level Security
ALTER TABLE fan_wall ENABLE ROW LEVEL SECURITY;

-- 3. Allow anyone to read posts
CREATE POLICY "Anyone can read fan wall"
    ON fan_wall FOR SELECT
    USING (true);

-- 4. Allow anyone to insert posts
CREATE POLICY "Anyone can post to fan wall"
    ON fan_wall FOR INSERT
    WITH CHECK (true);

-- 5. Create storage bucket for uploaded images
INSERT INTO storage.buckets (id, name, public)
VALUES ('fan-uploads', 'fan-uploads', true);

-- 6. Allow anyone to upload to the bucket
CREATE POLICY "Anyone can upload fan images"
    ON storage.objects FOR INSERT
    WITH CHECK (bucket_id = 'fan-uploads');

-- 7. Allow anyone to view uploaded images
CREATE POLICY "Anyone can view fan images"
    ON storage.objects FOR SELECT
    USING (bucket_id = 'fan-uploads');
