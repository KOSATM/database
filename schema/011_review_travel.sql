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

-- User, auth

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
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- plans

CREATE TABLE plans (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(100),
    budget NUMERIC(19,2) NOT NULL,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    is_ended BOOLEAN
);

CREATE TABLE plan_days (
    id BIGSERIAL PRIMARY KEY,
    plan_id BIGINT,
    day_index SMALLINT,
    title VARCHAR(50),
    plan_date DATE
);

CREATE TABLE plan_places (
    id BIGSERIAL PRIMARY KEY,
    day_id BIGINT NOT NULL,
    title VARCHAR(150) NOT NULL,
    start_at TIMESTAMPTZ,
    end_at TIMESTAMPTZ,
    place_name VARCHAR(64),
    address VARCHAR(200),
    lat NUMERIC(10,7),
    lng NUMERIC(10,7),
    expected_cost NUMERIC(19,2)
);

CREATE TABLE current_activities (
    id BIGSERIAL PRIMARY KEY,
    plan_place_id BIGINT NOT NULL,
    actual_cost NUMERIC(19,2),
    memo TEXT,
    ended_at TIMESTAMPTZ
);

CREATE TABLE plan_snapshots (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    version_no INT NOT NULL,
    snapshot_json JSON NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

-- travel, categories, image_search

CREATE TABLE travel_place_categories (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    parent_code TEXT,
    level INTEGER NOT NULL,
    category_type TEXT
);

CREATE TABLE travel_places (
    id BIGSERIAL PRIMARY KEY,
    content_id TEXT NOT NULL,
    title TEXT NOT NULL,
    address TEXT,
    tel TEXT,
    first_image TEXT,
    first_image2 TEXT,
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    category_code TEXT NOT NULL,
    description TEXT,
    tags JSONB,
    embedding VECTOR(3072),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    detail_info TEXT,
    UNIQUE (content_id)
);

CREATE TRIGGER trigger_update_timestamp
BEFORE UPDATE ON travel_places
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TABLE image_places (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    content VARCHAR(1000),
    lat NUMERIC(10,7) NOT NULL,
    lng NUMERIC(10,7) NOT NULL,
    address VARCHAR(500) NOT NULL,
    place_type VARCHAR(500) NOT NULL,
    internal_original_url TEXT,
    internal_thumbnail_url TEXT,
    external_image_url TEXT,
    image_status image_status_enum DEFAULT 'PENDING' NOT NULL
);

CREATE TABLE image_search_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    action_type image_action_type NOT NULL
);

CREATE TABLE image_search_candidates (
    id BIGSERIAL PRIMARY KEY,
    image_search_place_id BIGINT NOT NULL,
    image_place_id BIGINT NOT NULL,
    is_selected BOOLEAN DEFAULT false NOT NULL,
    rank BIGINT NOT NULL
);

-- review

CREATE TABLE review_posts (
    id BIGSERIAL PRIMARY KEY,
    content TEXT,
    is_posted BOOLEAN DEFAULT false NOT NULL,
    review_post_url TEXT,
    created_at TIMESTAMPTZ NOT NULL,
    plan_id BIGINT NOT NULL,
    review_style_id BIGINT,
    photo_group_id BIGINT,
    hashtag_group_id BIGINT
);

CREATE TABLE review_photo_groups (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL,
    review_post_id BIGINT NOT NULL
);

CREATE TABLE review_photos (
    id BIGSERIAL PRIMARY KEY,
    file_url TEXT NOT NULL,
    order_index INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    photo_group_id BIGINT NOT NULL
);

CREATE TABLE review_hashtag_groups (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL,
    review_post_id BIGINT NOT NULL
);

CREATE TABLE review_hashtags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    hashtag_group_id BIGINT NOT NULL
);

-- ai review

CREATE TABLE ai_review_analysis (
    id BIGSERIAL PRIMARY KEY,
    input_json JSONB NOT NULL,
    output_json JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    review_post_id BIGINT NOT NULL
);

CREATE TABLE ai_review_styles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    review_analysis_id BIGINT NOT NULL,
    tone_code VARCHAR(50),
    caption TEXT,
    embedding VECTOR(1536)
);

CREATE TABLE ai_review_hashtags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    review_analysis_id BIGINT NOT NULL,
    review_style_id BIGINT
);

-- checklists

CREATE TABLE checklists (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    day_index SMALLINT,
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

-- chat memory

CREATE TABLE chat_memories (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    agent_name VARCHAR(50) NOT NULL,
    order_index INT NOT NULL,
    content TEXT NOT NULL,
    token_usage BIGINT,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    role VARCHAR(10) NOT NULL
);

CREATE TABLE chat_memory_vectors (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    agent_name VARCHAR(50) NOT NULL,
    order_index BIGINT NOT NULL,
    content TEXT NOT NULL,
    token_usage BIGINT,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    role VARCHAR(10) NOT NULL,
    embedding VECTOR(1536)
);

-- constraints

ALTER TABLE user_identities ADD FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE sns_tokens ADD FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE plans ADD FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE plan_days ADD FOREIGN KEY (plan_id) REFERENCES plans(id);
ALTER TABLE plan_places ADD FOREIGN KEY (day_id) REFERENCES plan_days(id);
ALTER TABLE current_activities ADD FOREIGN KEY (plan_place_id) REFERENCES plan_places(id);
ALTER TABLE plan_snapshots ADD FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE travel_places ADD FOREIGN KEY (category_code) REFERENCES travel_place_categories(code);

ALTER TABLE image_search_sessions ADD FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE image_search_candidates ADD FOREIGN KEY (image_place_id) REFERENCES image_places(id);
ALTER TABLE image_search_candidates ADD FOREIGN KEY (image_search_place_id) REFERENCES image_search_sessions(id);

ALTER TABLE review_posts ADD FOREIGN KEY (plan_id) REFERENCES plans(id);
ALTER TABLE review_posts ADD FOREIGN KEY (review_style_id) REFERENCES ai_review_styles(id);
ALTER TABLE review_posts ADD FOREIGN KEY (photo_group_id) REFERENCES review_photo_groups(id);
ALTER TABLE review_posts ADD FOREIGN KEY (hashtag_group_id) REFERENCES review_hashtag_groups(id);

ALTER TABLE review_photo_groups ADD FOREIGN KEY (review_post_id) REFERENCES review_posts(id);
ALTER TABLE review_photos ADD FOREIGN KEY (photo_group_id) REFERENCES review_photo_groups(id);

ALTER TABLE review_hashtag_groups ADD FOREIGN KEY (review_post_id) REFERENCES review_posts(id);
ALTER TABLE review_hashtags ADD FOREIGN KEY (hashtag_group_id) REFERENCES review_hashtag_groups(id);

ALTER TABLE ai_review_analysis ADD FOREIGN KEY (review_post_id) REFERENCES review_posts(id);

ALTER TABLE ai_review_styles ADD FOREIGN KEY (review_analysis_id) REFERENCES ai_review_analysis(id);

ALTER TABLE ai_review_hashtags ADD FOREIGN KEY (review_analysis_id) REFERENCES ai_review_analysis(id);
ALTER TABLE ai_review_hashtags ADD FOREIGN KEY (review_style_id) REFERENCES ai_review_styles(id);

ALTER TABLE checklists ADD FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE checklist_items ADD FOREIGN KEY (checklist_id) REFERENCES checklists(id);

ALTER TABLE chat_memories ADD FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE chat_memory_vectors ADD FOREIGN KEY (user_id) REFERENCES users(id);
