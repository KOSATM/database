ALTER TABLE review_photos ADD COLUMN summary TEXT;

DROP TYPE IF EXISTS public.checklist_category_enum CASCADE;
DROP TYPE IF EXISTS public.image_action_type_enum CASCADE;
DROP TYPE IF EXISTS public.image_status_enum CASCADE;

CREATE TYPE public.checklist_category_enum AS ENUM
    ('LOCATION', 'GENERAL', 'WEATHER');
    
CREATE TYPE public.image_action_type_enum AS ENUM
    ('SAVE_ONLY', 'EDIT_ITINERARY', 'REPLACE');
   
CREATE TYPE public.image_status_enum AS ENUM
    ('PENDING', 'READY', 'FAILED');

ALTER TABLE review_photos ADD COLUMN summary TEXT;

-- 1. ENUM 타입 정의
CREATE TYPE travel_type_enum AS ENUM ('SOLO', 'GROUP', 'UNCLEAR');

-- 2. review_posts 테이블에 컬럼 추가 및 타입 지정
ALTER TABLE review_posts
ADD COLUMN travel_type travel_type_enum;

ALTER TABLE review_posts ADD COLUMN overall_moods TEXT;