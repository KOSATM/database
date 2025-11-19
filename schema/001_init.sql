-- =========================================
-- 0) VECTOR 확장
-- =========================================
CREATE EXTENSION IF NOT EXISTS vector;

-- =========================================
-- 1) 스키마 선택
-- =========================================
SET search_path TO public;

-- =========================================
-- 2) ENUM 타입
-- =========================================
DROP TYPE IF EXISTS image_action_type CASCADE;
DROP TYPE IF EXISTS checklist_category CASCADE;

CREATE TYPE image_action_type AS ENUM ('SAVE_ONLY', 'EDIT_ITINERARY', 'REPLACE');
CREATE TYPE checklist_category AS ENUM ('PACKING', 'CLOTHES', 'DOCUMENT', 'ETC');

-- =========================================
-- 3) TABLE 생성 (PK 이름 전체 id 통일)
-- =========================================

CREATE TABLE users (
    id BIGSERIAL NOT NULL,
    is_active BOOLEAN,
    last_login_at TIMESTAMPTZ,
    name VARCHAR(50),
    email VARCHAR(1000),
    profile_image VARCHAR(1000),
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ,
    nationality VARCHAR(50)
);

CREATE TABLE travel_plan_snapshot (
    id BIGSERIAL NOT NULL,
    uid BIGINT NOT NULL,
    version_no INT NOT NULL,
    snapshot_json JSON NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE travel_plans (
    id BIGSERIAL NOT NULL,
    uid BIGINT NOT NULL,
    start_date TIMESTAMPTZ,
    end_date TIMESTAMPTZ,
    timezone VARCHAR(20) DEFAULT 'KST',
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    is_ended BOOLEAN
);

CREATE TABLE travel_days (
    id BIGSERIAL NOT NULL,
    trip_id BIGINT,
    day_index SMALLINT,
    title VARCHAR(50),
    date VARCHAR(50)
);

CREATE TABLE travel_spot (
    id BIGSERIAL NOT NULL,
    day_id BIGINT NOT NULL,
    title VARCHAR(150) NOT NULL,
    start_at_utc TIMESTAMPTZ,
    end_at_utc TIMESTAMPTZ,
    place_name VARCHAR(64),
    address VARCHAR(200),
    lat NUMERIC(10,7),
    lng NUMERIC(10,7),
    cost BIGINT
);

CREATE TABLE current_activity (
    id BIGSERIAL NOT NULL,
    travelspot_id BIGINT NOT NULL,
    actual_cost BIGINT,
    review TEXT
);

CREATE TABLE posts (
    id BIGSERIAL NOT NULL,
    caption TEXT NOT NULL,
    is_posted BOOLEAN NOT NULL,
    post_url TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    plan_id BIGINT NOT NULL,
    style_id BIGINT NOT NULL
);

CREATE TABLE photo_groups (
    id BIGSERIAL NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    post_id BIGINT NOT NULL
);

CREATE TABLE photos (
    id BIGSERIAL NOT NULL,
    file_url TEXT NOT NULL,
    lat NUMERIC(10,6),
    lng NUMERIC(10,6),
    taken_at TIMESTAMPTZ,
    order_index INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    group_id BIGINT NOT NULL
);

CREATE TABLE hashtag_groups (
    id BIGSERIAL NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    post_id BIGINT NOT NULL
);

CREATE TABLE hashtags (
    id BIGSERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    is_selected BOOLEAN NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    group_id BIGINT NOT NULL
);

CREATE TABLE ai_post_analysis (
    id BIGSERIAL NOT NULL,
    prompt_text TEXT NOT NULL,
    input_json JSONB NOT NULL,
    output_json JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    uid BIGINT NOT NULL,
    post_id BIGINT NOT NULL
);

CREATE TABLE ai_style_recommendation (
    id BIGSERIAL NOT NULL,
    name VARCHAR(150) NOT NULL,
    confidence NUMERIC(4,3) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    analysis_id BIGINT NOT NULL
);

CREATE TABLE ai_hashtag_recommendation (
    id BIGSERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    confidence NUMERIC(4,3) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    analysis_id BIGINT NOT NULL
);

CREATE TABLE image_place_searches (
    id BIGSERIAL NOT NULL,
    uid BIGINT NOT NULL,
    searched_at TIMESTAMPTZ NOT NULL,
    action_type image_action_type NOT NULL
);

CREATE TABLE place (
    id BIGSERIAL NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000),
    lat NUMERIC(10,7) NOT NULL,
    lng NUMERIC(10,7) NOT NULL,
    address VARCHAR(500) NOT NULL,
    place_type VARCHAR(500) NOT NULL,
    image_url VARCHAR(1000),
    thumbnail_url VARCHAR(1000)
);

CREATE TABLE image_place_search_results (
    id BIGSERIAL NOT NULL,
    image_search_history_id BIGINT NOT NULL,
    place_id BIGINT NOT NULL,
    is_selected BOOLEAN NOT NULL DEFAULT FALSE,
    rank BIGINT NOT NULL
);

CREATE TABLE chat_memory (
    id BIGSERIAL NOT NULL,
    uid BIGINT NOT NULL,
    agent_id VARCHAR(50) NOT NULL,
    turn_index INT NOT NULL,
    content TEXT NOT NULL,
    token_count INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    role VARCHAR(10) NOT NULL
);

CREATE TABLE chat_memory_vector (
    id BIGSERIAL NOT NULL,
    uid BIGINT NOT NULL,
    agent_id VARCHAR(50) NOT NULL,
    turn_index INT NOT NULL,
    content TEXT NOT NULL,
    token_count INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    role VARCHAR(10) NOT NULL,
    embedding VECTOR(1536)
);

CREATE TABLE checklists (
    id BIGSERIAL NOT NULL,
    uid BIGINT NOT NULL,
    day_index BIGINT,
    created_at DATE
);

CREATE TABLE checklist_items (
    id BIGSERIAL NOT NULL,
    checklist_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    category checklist_category NOT NULL,
    is_checked BOOLEAN NOT NULL,
    created_at DATE NOT NULL
);

CREATE TABLE sns_tokens (
    id BIGSERIAL NOT NULL,
    access_token TEXT NOT NULL,
    refresh_token TEXT,
    expires_at TIMESTAMPTZ,
    account_type TEXT,
    ig_business_id TEXT,
    created_at TIMESTAMPTZ,
    uid BIGINT NOT NULL
);

CREATE TABLE hotel_bookings (
    id BIGSERIAL NOT NULL,
    uid BIGINT NOT NULL,
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
    id BIGSERIAL NOT NULL,
    booking_id BIGINT NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    provider_payment_id VARCHAR(100),
    amount NUMERIC(12,2) NOT NULL,
    currency CHAR(3) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    requested_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    raw_response JSONB,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE user_identities (
    id BIGSERIAL NOT NULL,
    uid BIGINT NOT NULL,
    provider VARCHAR(50),
    created_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE toilets (
    id BIGSERIAL NOT NULL,
    name VARCHAR(255) NOT NULL,
    lat NUMERIC(10,7) NOT NULL,
    lng NUMERIC(10,7) NOT NULL,
    address VARCHAR(500) NOT NULL
);

-- =========================================
-- 4) PRIMARY KEY
-- =========================================

ALTER TABLE users ADD PRIMARY KEY (id);
ALTER TABLE travel_plan_snapshot ADD PRIMARY KEY (id);
ALTER TABLE travel_plans ADD PRIMARY KEY (id);
ALTER TABLE travel_days ADD PRIMARY KEY (id);
ALTER TABLE travel_spot ADD PRIMARY KEY (id);
ALTER TABLE current_activity ADD PRIMARY KEY (id);
ALTER TABLE posts ADD PRIMARY KEY (id);
ALTER TABLE photo_groups ADD PRIMARY KEY (id);
ALTER TABLE photos ADD PRIMARY KEY (id);
ALTER TABLE hashtag_groups ADD PRIMARY KEY (id);
ALTER TABLE hashtags ADD PRIMARY KEY (id);
ALTER TABLE ai_post_analysis ADD PRIMARY KEY (id);
ALTER TABLE ai_style_recommendation ADD PRIMARY KEY (id);
ALTER TABLE ai_hashtag_recommendation ADD PRIMARY KEY (id);
ALTER TABLE image_place_searches ADD PRIMARY KEY (id);
ALTER TABLE place ADD PRIMARY KEY (id);
ALTER TABLE image_place_search_results ADD PRIMARY KEY (id);
ALTER TABLE chat_memory ADD PRIMARY KEY (id);
ALTER TABLE chat_memory_vector ADD PRIMARY KEY (id);
ALTER TABLE checklists ADD PRIMARY KEY (id);
ALTER TABLE checklist_items ADD PRIMARY KEY (id);
ALTER TABLE sns_tokens ADD PRIMARY KEY (id);
ALTER TABLE hotel_bookings ADD PRIMARY KEY (id);
ALTER TABLE payment_transactions ADD PRIMARY KEY (id);
ALTER TABLE user_identities ADD PRIMARY KEY (id);
ALTER TABLE toilets ADD PRIMARY KEY (id);

-- =========================================
-- 5) FOREIGN KEY
-- =========================================

ALTER TABLE travel_plan_snapshot
  ADD CONSTRAINT fk_tps_users FOREIGN KEY (uid) REFERENCES users(id);

ALTER TABLE travel_plans
  ADD CONSTRAINT fk_tp_users FOREIGN KEY (uid) REFERENCES users(id);

ALTER TABLE ai_post_analysis
  ADD CONSTRAINT fk_apa_users FOREIGN KEY (uid) REFERENCES users(id);

ALTER TABLE chat_memory
  ADD CONSTRAINT fk_cm_users FOREIGN KEY (uid) REFERENCES users(id);

ALTER TABLE chat_memory_vector
  ADD CONSTRAINT fk_cmv_users FOREIGN KEY (uid) REFERENCES users(id);

ALTER TABLE checklists
  ADD CONSTRAINT fk_cl_users FOREIGN KEY (uid) REFERENCES users(id);

ALTER TABLE image_place_searches
  ADD CONSTRAINT fk_ips_users FOREIGN KEY (uid) REFERENCES users(id);

ALTER TABLE sns_tokens
  ADD CONSTRAINT fk_sns_users FOREIGN KEY (uid) REFERENCES users(id);

ALTER TABLE hotel_bookings
  ADD CONSTRAINT fk_hb_users FOREIGN KEY (uid) REFERENCES users(id);

ALTER TABLE user_identities
  ADD CONSTRAINT fk_ui_users FOREIGN KEY (uid) REFERENCES users(id);

-- travel hierarchy
ALTER TABLE travel_days
  ADD CONSTRAINT fk_td_tp FOREIGN KEY (trip_id) REFERENCES travel_plans(id);

ALTER TABLE travel_spot
  ADD CONSTRAINT fk_ts_td FOREIGN KEY (day_id) REFERENCES travel_days(id);

ALTER TABLE current_activity
  ADD CONSTRAINT fk_ca_ts FOREIGN KEY (travelspot_id) REFERENCES travel_spot(id);

-- posts domain
ALTER TABLE posts
  ADD CONSTRAINT fk_posts_tp FOREIGN KEY (plan_id) REFERENCES travel_plans(id);

ALTER TABLE photo_groups
  ADD CONSTRAINT fk_pg_posts FOREIGN KEY (post_id) REFERENCES posts(id);

ALTER TABLE photos
  ADD CONSTRAINT fk_ph_pg FOREIGN KEY (group_id) REFERENCES photo_groups(id);

ALTER TABLE hashtag_groups
  ADD CONSTRAINT fk_hg_posts FOREIGN KEY (post_id) REFERENCES posts(id);

ALTER TABLE hashtags
  ADD CONSTRAINT fk_ht_hg FOREIGN KEY (group_id) REFERENCES hashtag_groups(id);

ALTER TABLE ai_post_analysis
  ADD CONSTRAINT fk_apa_posts FOREIGN KEY (post_id) REFERENCES posts(id);

ALTER TABLE ai_style_recommendation
  ADD CONSTRAINT fk_asr_apa FOREIGN KEY (analysis_id) REFERENCES ai_post_analysis(id);

ALTER TABLE ai_hashtag_recommendation
  ADD CONSTRAINT fk_ahr_apa FOREIGN KEY (analysis_id) REFERENCES ai_post_analysis(id);

-- image place search results
ALTER TABLE image_place_search_results
  ADD CONSTRAINT fk_ipsr_ips FOREIGN KEY (image_search_history_id) REFERENCES image_place_searches(id);

ALTER TABLE image_place_search_results
  ADD CONSTRAINT fk_ipsr_place FOREIGN KEY (place_id) REFERENCES place(id);

-- booking / payment
ALTER TABLE payment_transactions
  ADD CONSTRAINT fk_pt_hb FOREIGN KEY (booking_id) REFERENCES hotel_bookings(id);

-- checklists / items
ALTER TABLE checklist_items
  ADD CONSTRAINT fk_ci_cl FOREIGN KEY (checklist_id) REFERENCES checklists(id);
