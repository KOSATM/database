-- 1. 확장 기능 설정
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. 기존 타입 및 테이블 삭제 (초기화용)
DROP TABLE IF EXISTS payment_transactions, hotel_bookings, hotel_rate_plan_prices, hotel_rate_plans, hotel_rooms, hotels CASCADE;
DROP TABLE IF EXISTS chat_memory_vectors, chat_memories, checklist_items, checklists CASCADE;
DROP TABLE IF EXISTS ai_review_hashtags, ai_review_styles, ai_review_analysis CASCADE;
DROP TABLE IF EXISTS review_hashtags, review_hashtag_groups, review_photos, review_photo_groups, review_posts CASCADE;
DROP TABLE IF EXISTS image_search_candidates, image_search_sessions, image_places CASCADE;
DROP TABLE IF EXISTS toilets, travel_places, travel_place_categories CASCADE;
DROP TABLE IF EXISTS plan_snapshots, current_activities, plan_places, plan_days, plans CASCADE;
DROP TABLE IF EXISTS sns_tokens, user_identities, users CASCADE;

DROP TYPE IF EXISTS public.checklist_category_enum CASCADE;
DROP TYPE IF EXISTS public.image_action_type_enum CASCADE;
DROP TYPE IF EXISTS public.image_status_enum CASCADE;
DROP TYPE IF EXISTS travel_type_enum CASCADE;

-- 3. ENUM 타입 생성
CREATE TYPE public.checklist_category_enum AS ENUM ('LOCATION', 'GENERAL', 'WEATHER');
CREATE TYPE public.image_action_type_enum AS ENUM ('SAVE_ONLY', 'EDIT_ITINERARY', 'REPLACE');
CREATE TYPE public.image_status_enum AS ENUM ('PENDING', 'READY', 'FAILED');
CREATE TYPE travel_type_enum AS ENUM ('SOLO', 'GROUP', 'UNCLEAR');

-- 4. 테이블 생성 (의존성 순서 준수)

-- [사용자 계정 계층]
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    is_active BOOLEAN DEFAULT true,
    last_login_at TIMESTAMPTZ,
    name VARCHAR(50),
    email VARCHAR(1000) UNIQUE,
    profile_image_url VARCHAR(1000),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

CREATE TABLE user_identities (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    provider VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, provider)
);

CREATE TABLE sns_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    user_access_token TEXT NOT NULL,
    page_access_token TEXT,
    expires_at TIMESTAMPTZ,
    account_type VARCHAR(50),
    ig_business_account VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- [여행 장소 및 카테고리]
CREATE TABLE travel_place_categories (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    parent_code TEXT,
    level INTEGER NOT NULL,
    category_type TEXT
);

CREATE TABLE travel_places (
    id BIGSERIAL PRIMARY KEY,
    content_id TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    address TEXT,
    tel TEXT,
    zone_id VARCHAR(20), -- [추가된 컬럼]
    first_image TEXT,
    first_image2 TEXT,
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    category_code TEXT NOT NULL REFERENCES travel_place_categories(code),
    description TEXT,
    tags JSONB,
    embedding VECTOR(3072),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- [여행 계획 계층]
CREATE TABLE plans (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    title VARCHAR(100),
    budget NUMERIC(19,2) NOT NULL,
    start_date DATE,
    end_date DATE,
    is_ended BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE plan_days (
    id BIGSERIAL PRIMARY KEY,
    plan_id BIGINT REFERENCES plans(id),
    day_index SMALLINT,
    title VARCHAR(50),
    plan_date DATE
);

CREATE TABLE plan_places (
    id BIGSERIAL PRIMARY KEY, -- [TEXT에서 수정됨]
    day_id BIGINT NOT NULL REFERENCES plan_days(id),
    title VARCHAR(150) NOT NULL,
    place_name VARCHAR(64),
    address VARCHAR(200),
    first_image TEXT,  -- [추가된 컬럼]
    first_image2 TEXT, -- [추가된 컬럼]
    lat NUMERIC(10,7),
    lng NUMERIC(10,7),
    expected_cost NUMERIC(19,2),
    start_at TIMESTAMPTZ,
    end_at TIMESTAMPTZ
);

-- [호텔 및 예약 시스템]
CREATE TABLE hotels (
    id BIGSERIAL PRIMARY KEY,
    external_hotel_id VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    star_rating NUMERIC(2,1),
    address_line1 VARCHAR(200),
    latitude NUMERIC(10,7),
    longitude NUMERIC(10,7),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE hotel_rooms (
    id BIGSERIAL PRIMARY KEY,
    hotel_id BIGINT NOT NULL REFERENCES hotels(id),
    external_room_type_id VARCHAR(100) NOT NULL,
    name VARCHAR(200) NOT NULL,
    max_occupancy INTEGER NOT NULL,
    UNIQUE (hotel_id, external_room_type_id)
);

CREATE TABLE hotel_rate_plans (
    id BIGSERIAL PRIMARY KEY,
    hotel_id BIGINT NOT NULL REFERENCES hotels(id),
    room_type_id BIGINT NOT NULL REFERENCES hotel_rooms(id),
    external_rate_plan_id VARCHAR(100) NOT NULL,
    currency CHAR(3) NOT NULL,
    base_price NUMERIC(12,2),
    UNIQUE (hotel_id, external_rate_plan_id)
);

CREATE TABLE hotel_bookings (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    hotel_id BIGINT NOT NULL REFERENCES hotels(id),
    room_type_id BIGINT NOT NULL REFERENCES hotel_rooms(id),
    rate_plan_id BIGINT NOT NULL REFERENCES hotel_rate_plans(id),
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    total_price NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- [리뷰 및 AI 분석]
CREATE TABLE review_posts (
    id BIGSERIAL PRIMARY KEY,
    plan_id BIGINT NOT NULL REFERENCES plans(id),
    caption TEXT,
    travel_type travel_type_enum,
    overall_moods TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE ai_review_analysis (
    id BIGSERIAL PRIMARY KEY,
    review_post_id BIGINT NOT NULL REFERENCES review_posts(id),
    input_json JSONB,
    output_json JSONB,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- [기타 유틸리티: 체크리스트, 채팅 메모리, 화장실]
CREATE TABLE checklists (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    day_index SMALLINT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE checklist_items (
    id BIGSERIAL PRIMARY KEY,
    checklist_id BIGINT NOT NULL REFERENCES checklists(id),
    content TEXT NOT NULL,
    category public.checklist_category_enum NOT NULL,
    is_checked BOOLEAN DEFAULT false
);

CREATE TABLE chat_memories (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    role VARCHAR(10) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE chat_memory_vectors (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    content TEXT NOT NULL,
    embedding VECTOR(1536),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE toilets (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    lat NUMERIC(10,7) NOT NULL,
    lng NUMERIC(10,7) NOT NULL,
    address VARCHAR(500)
);