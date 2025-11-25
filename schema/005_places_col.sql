-- =========================================
-- 1. EXTENSIONS
-- =========================================
CREATE EXTENSION IF NOT EXISTS vector;


-- =========================================
-- 2. ENUM TYPES
-- =========================================
DROP TYPE IF EXISTS image_action_type CASCADE;
DROP TYPE IF EXISTS checklist_category CASCADE;
DROP TYPE IF EXISTS image_status_enum CASCADE;

CREATE TYPE image_action_type AS ENUM ('SAVE_ONLY', 'EDIT_ITINERARY', 'REPLACE');
CREATE TYPE checklist_category AS ENUM ('PACKING', 'CLOTHES', 'DOCUMENT', 'ETC');
CREATE TYPE image_status_enum AS ENUM ('PENDING', 'READY', 'FAILED');


-- =========================================
-- 3. CREATE TABLES (NO FKs)
-- =========================================

-- USERS
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    is_active BOOLEAN,
    last_login_at TIMESTAMPTZ,
    name VARCHAR(50),
    email VARCHAR(1000),
    profile_image_url VARCHAR(1000),
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ
);

CREATE TABLE user_identities (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    provider VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, provider)
);

CREATE TABLE sns_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    user_access_token TEXT NOT NULL,
    page_access_token TEXT,
    expires_at TIMESTAMPTZ,
    account_type VARCHAR(50),
    ig_business_account VARCHAR(100),
    creator_account VARCHAR(100),
    publish_account VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- TRAVEL PLAN
CREATE TABLE travel_plan_snapshots (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    version_no INT NOT NULL,
    snapshot_json JSON NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE travel_plans (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    budget DECIMAL(19,2) NOT NULL,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    is_ended BOOLEAN
);

CREATE TABLE travel_days (
    id BIGSERIAL PRIMARY KEY,
    travel_plan_id BIGINT,
    day_index SMALLINT,
    title VARCHAR(50),
    plan_date DATE
);

CREATE TABLE travel_places (
    id BIGSERIAL PRIMARY KEY,
    day_id BIGINT NOT NULL,
    title VARCHAR(150) NOT NULL,
    start_at TIMESTAMPTZ,
    end_at TIMESTAMPTZ,
    place_name VARCHAR(64),
    address VARCHAR(200),
    lat NUMERIC(10,7),
    lng NUMERIC(10,7),
    expected_cost DECIMAL(19,2)
);

CREATE TABLE current_activities (
    id BIGSERIAL PRIMARY KEY,
    travel_place_id BIGINT NOT NULL,
    actual_cost DECIMAL(19,2),
    memo TEXT,
    ended_at TIMESTAMPTZ
);


-- REVIEW POSTS
CREATE TABLE review_posts (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    is_posted BOOLEAN NOT NULL,
    review_post_url TEXT,
    created_at TIMESTAMPTZ NOT NULL,
    travel_plan_id BIGINT NOT NULL,
    style_id BIGINT NOT NULL
);

CREATE TABLE review_photo_groups (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL,
    review_post_id BIGINT NOT NULL
);

CREATE TABLE review_photos (
    id BIGSERIAL PRIMARY KEY,
    file_url TEXT NOT NULL,
    lat NUMERIC(10,7),
    lng NUMERIC(10,7),
    taken_at TIMESTAMPTZ,
    order_index INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    group_id BIGINT NOT NULL
);

CREATE TABLE hashtag_groups (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL,
    review_post_id BIGINT NOT NULL
);

CREATE TABLE hashtags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    is_selected BOOLEAN NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    group_id BIGINT NOT NULL
);


-- AI ANALYSIS
CREATE TABLE ai_review_analysis (
    id BIGSERIAL PRIMARY KEY,
    prompt_text TEXT NOT NULL,
    input_json JSONB NOT NULL,
    output_json JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    user_id BIGINT NOT NULL,
    review_post_id BIGINT NOT NULL
);

CREATE TABLE ai_styles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    review_analysis_id BIGINT NOT NULL
);

CREATE TABLE ai_hashtags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    review_analysis_id BIGINT NOT NULL
);


-- PLACES
CREATE TABLE places (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    content VARCHAR(1000),
    lat NUMERIC(10,7) NOT NULL,
    lng NUMERIC(10,7) NOT NULL,
    address VARCHAR(500) NOT NULL,
    place_type VARCHAR(500) NOT NULL,
    internal_original_url VARCHAR(1000),
    internal_thumbnail_url VARCHAR(1000),
    external_image_url TEXT,
    image_status image_status_enum
);

CREATE TABLE image_searches (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    action_type image_action_type NOT NULL
);

CREATE TABLE image_search_results (
    id BIGSERIAL PRIMARY KEY,
    history_id BIGINT NOT NULL,
    place_id BIGINT NOT NULL,
    is_selected BOOLEAN NOT NULL DEFAULT false,
    rank BIGINT NOT NULL
);


-- CHECKLIST
CREATE TABLE checklists (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    day_index BIGINT,
    created_at TIMESTAMPTZ
);

CREATE TABLE checklist_items (
    id BIGSERIAL PRIMARY KEY,
    checklist_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    category checklist_category NOT NULL,
    is_checked BOOLEAN NOT NULL,
    created_at TIMESTAMPTZ NOT NULL
);


-- CHAT MEMORY
CREATE TABLE chat_memories (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    agent_id BIGINT NOT NULL,
    order_index INT NOT NULL,
    content TEXT NOT NULL,
    token_usage BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    role VARCHAR(10) NOT NULL
);

CREATE TABLE chat_memory_vectors (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    agent_id BIGINT NOT NULL,
    order_index INT NOT NULL,
    content TEXT NOT NULL,
    token_usage BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    role VARCHAR(10) NOT NULL,
    embedding vector(1536)
);


-- HOTEL & PAYMENT
CREATE TABLE hotel_bookings (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    external_booking_id VARCHAR(100),
    hotel_id BIGINT NOT NULL,
    room_type_id BIGINT NOT NULL,
    rate_plan_id BIGINT NOT NULL,
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    nights INTEGER NOT NULL,
    adults_count INTEGER NOT NULL,
    children_count INTEGER NOT NULL,
    currency CHAR(3) NOT NULL,
    total_price NUMERIC(12,2) NOT NULL,
    tax_amount NUMERIC(12,2) NOT NULL,
    fee_amount NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    guest_name VARCHAR(200),
    guest_email VARCHAR(100),
    guest_phone VARCHAR(50),
    provider_booking_meta JSONB,
    booked_at TIMESTAMPTZ NOT NULL,
    cancelled_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE payment_transactions (
    id BIGSERIAL PRIMARY KEY,
    hotel_booking_id BIGINT NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    provider_payment_id VARCHAR(100),
    amount DECIMAL(19,2) NOT NULL,
    currency CHAR(3) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    requested_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    raw_response JSONB,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL
);


-- TOILETS
CREATE TABLE toilets (
    id BIGSERIAL PRIMARY K
