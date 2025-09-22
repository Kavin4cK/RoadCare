-- Location: supabase/migrations/20250921133403_roadcare_complete_integration.sql
-- Schema Analysis: Fresh project - no existing schema
-- Integration Type: Complete new schema for RoadCare civic infrastructure management
-- Module: Authentication + Infrastructure Management + Storage

-- 1. Create Types
CREATE TYPE public.user_role AS ENUM ('citizen', 'worker', 'supervisor', 'admin');
CREATE TYPE public.issue_category AS ENUM ('pothole', 'streetlight', 'drainage', 'road_damage', 'traffic_sign', 'sidewalk', 'other');
CREATE TYPE public.priority_level AS ENUM ('low', 'medium', 'high', 'urgent');
CREATE TYPE public.issue_status AS ENUM ('reported', 'acknowledged', 'in_progress', 'completed', 'rejected');

-- 2. Core Tables

-- Critical intermediary table for authentication
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    phone TEXT,
    role public.user_role DEFAULT 'citizen'::public.user_role,
    avatar_url TEXT,
    address TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Issue reports table
CREATE TABLE public.issues (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    assigned_worker_id UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT,
    category public.issue_category NOT NULL,
    priority public.priority_level DEFAULT 'medium'::public.priority_level,
    status public.issue_status DEFAULT 'reported'::public.issue_status,
    location_latitude DECIMAL(10, 8),
    location_longitude DECIMAL(11, 8),
    location_address TEXT,
    before_image_url TEXT,
    after_image_url TEXT,
    estimated_cost DECIMAL(10, 2),
    actual_cost DECIMAL(10, 2),
    estimated_completion_date DATE,
    completion_date DATE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Issue comments table
CREATE TABLE public.issue_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    issue_id UUID REFERENCES public.issues(id) ON DELETE CASCADE,
    commenter_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    comment TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Issue votes table for community voting
CREATE TABLE public.issue_votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    issue_id UUID REFERENCES public.issues(id) ON DELETE CASCADE,
    voter_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    vote_type TEXT CHECK (vote_type IN ('upvote', 'downvote')),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(issue_id, voter_id)
);

-- Worker profiles for specialized information
CREATE TABLE public.worker_profiles (
    id UUID PRIMARY KEY REFERENCES public.user_profiles(id),
    specialization TEXT[],
    experience_years INTEGER,
    availability_status TEXT DEFAULT 'available',
    current_workload INTEGER DEFAULT 0,
    rating DECIMAL(3, 2) DEFAULT 5.00,
    total_issues_completed INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Essential Indexes
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX idx_issues_reporter_id ON public.issues(reporter_id);
CREATE INDEX idx_issues_assigned_worker_id ON public.issues(assigned_worker_id);
CREATE INDEX idx_issues_status ON public.issues(status);
CREATE INDEX idx_issues_category ON public.issues(category);
CREATE INDEX idx_issues_priority ON public.issues(priority);
CREATE INDEX idx_issues_created_at ON public.issues(created_at);
CREATE INDEX idx_issue_comments_issue_id ON public.issue_comments(issue_id);
CREATE INDEX idx_issue_votes_issue_id ON public.issue_votes(issue_id);

-- 4. Storage Buckets
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'issue-images',
    'issue-images',
    true,
    10485760, -- 10MB limit
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/jpg']
);

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'user-avatars',
    'user-avatars',
    true,
    5242880, -- 5MB limit
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/jpg']
);

-- 5. RLS Setup
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.issues ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.issue_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.issue_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.worker_profiles ENABLE ROW LEVEL SECURITY;

-- 6. RLS Policies

-- Pattern 1: Core user table (user_profiles) - Simple only, no functions
CREATE POLICY "users_manage_own_user_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Pattern 4: Public read, private write for issues
CREATE POLICY "public_can_read_issues"
ON public.issues
FOR SELECT
TO public
USING (true);

CREATE POLICY "users_manage_own_issues"
ON public.issues
FOR INSERT
TO authenticated
WITH CHECK (reporter_id = auth.uid());

CREATE POLICY "reporters_update_own_issues"
ON public.issues
FOR UPDATE
TO authenticated
USING (reporter_id = auth.uid())
WITH CHECK (reporter_id = auth.uid());

CREATE POLICY "workers_update_assigned_issues"
ON public.issues
FOR UPDATE
TO authenticated
USING (assigned_worker_id = auth.uid())
WITH CHECK (assigned_worker_id = auth.uid());

-- Pattern 2: Simple user ownership for comments
CREATE POLICY "users_manage_own_comments"
ON public.issue_comments
FOR ALL
TO authenticated
USING (commenter_id = auth.uid())
WITH CHECK (commenter_id = auth.uid());

-- Public can read non-internal comments
CREATE POLICY "public_can_read_public_comments"
ON public.issue_comments
FOR SELECT
TO public
USING (is_internal = false);

-- Pattern 2: Simple user ownership for votes
CREATE POLICY "users_manage_own_votes"
ON public.issue_votes
FOR ALL
TO authenticated
USING (voter_id = auth.uid())
WITH CHECK (voter_id = auth.uid());

-- Public can read votes
CREATE POLICY "public_can_read_votes"
ON public.issue_votes
FOR SELECT
TO public
USING (true);

-- Pattern 1: Worker profiles - Simple ownership
CREATE POLICY "workers_manage_own_profiles"
ON public.worker_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Public can read worker profiles
CREATE POLICY "public_can_read_worker_profiles"
ON public.worker_profiles
FOR SELECT
TO public
USING (true);

-- 7. Storage RLS Policies

-- Issue images - Public bucket, anyone can view, authenticated users can upload
CREATE POLICY "public_can_view_issue_images"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'issue-images');

CREATE POLICY "authenticated_users_upload_issue_images"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'issue-images');

CREATE POLICY "users_manage_own_issue_images"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'issue-images' AND owner = auth.uid())
WITH CHECK (bucket_id = 'issue-images' AND owner = auth.uid());

CREATE POLICY "users_delete_own_issue_images"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'issue-images' AND owner = auth.uid());

-- User avatars - Public bucket, anyone can view, users manage their own
CREATE POLICY "public_can_view_user_avatars"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'user-avatars');

CREATE POLICY "users_upload_own_avatars"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'user-avatars' 
    AND owner = auth.uid()
    AND (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "users_manage_own_avatars"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'user-avatars' AND owner = auth.uid())
WITH CHECK (bucket_id = 'user-avatars' AND owner = auth.uid());

CREATE POLICY "users_delete_own_avatars"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'user-avatars' AND owner = auth.uid());

-- 8. Functions for automatic profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name, role)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'role', 'citizen')::public.user_role
  );
  RETURN NEW;
END;
$$;

-- Trigger for new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 9. Complete Mock Data
DO $$
DECLARE
    citizen_uuid UUID := gen_random_uuid();
    worker_uuid UUID := gen_random_uuid();
    supervisor_uuid UUID := gen_random_uuid();
    admin_uuid UUID := gen_random_uuid();
    issue1_uuid UUID := gen_random_uuid();
    issue2_uuid UUID := gen_random_uuid();
BEGIN
    -- Create auth users with required fields
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (citizen_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'citizen@roadcare.com', crypt('citizen123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "John Citizen", "role": "citizen"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (worker_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'worker@roadcare.com', crypt('worker123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Mike Worker", "role": "worker"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (supervisor_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'supervisor@roadcare.com', crypt('super123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Sarah Supervisor", "role": "supervisor"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (admin_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@roadcare.com', crypt('admin123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Admin User", "role": "admin"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Create sample issues
    INSERT INTO public.issues (id, reporter_id, assigned_worker_id, title, description, category, priority, status, location_latitude, location_longitude, location_address)
    VALUES
        (issue1_uuid, citizen_uuid, worker_uuid, 'Large pothole on Main Street', 'Deep pothole causing vehicle damage near intersection with Oak Avenue', 'pothole'::public.issue_category, 'high'::public.priority_level, 'in_progress'::public.issue_status, 40.7128, -74.0060, '123 Main Street, City Center'),
        (issue2_uuid, citizen_uuid, null, 'Broken streetlight in Park District', 'Streetlight has been out for 3 weeks, creating safety concerns for pedestrians', 'streetlight'::public.issue_category, 'medium'::public.priority_level, 'reported'::public.issue_status, 40.7589, -73.9851, '456 Park Avenue, Park District');

    -- Create worker profile
    INSERT INTO public.worker_profiles (id, specialization, experience_years, rating, total_issues_completed)
    VALUES (worker_uuid, ARRAY['pothole_repair', 'road_maintenance'], 5, 4.8, 150);

    -- Create sample comments
    INSERT INTO public.issue_comments (issue_id, commenter_id, comment)
    VALUES 
        (issue1_uuid, worker_uuid, 'Started work on this issue. Materials ordered and crew scheduled.'),
        (issue1_uuid, citizen_uuid, 'Thank you for the quick response! Looking forward to the repair.');

    -- Create sample votes
    INSERT INTO public.issue_votes (issue_id, voter_id, vote_type)
    VALUES 
        (issue1_uuid, citizen_uuid, 'upvote'),
        (issue2_uuid, citizen_uuid, 'upvote');

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;