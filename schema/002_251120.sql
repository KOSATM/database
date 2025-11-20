-- =========================================
-- EXTENSIONS
-- =========================================
CREATE EXTENSION IF NOT EXISTS vector;


-- =========================================
-- ENUM TYPES
-- =========================================
DROP TYPE IF EXISTS image_action_type CASCADE;
DROP TYPE IF EXISTS checklist_category CASCADE;

CREATE TYPE image_action_type AS ENUM ('SAVE_ONLY', 'EDIT_ITINERARY', 'REPLACE');
CREATE TYPE checklist_category AS ENUM ('PACKING', 'CLOTHES', 'DOCUMENT', 'ETC');


-- =========================================
-- USERS
-- =========================================
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


-- =========================================
-- TRAVEL PLANNING
-- =========================================
CREATE TABLE travel_plan_snapshot (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    version_no INT NOT NULL,
    snapshot_json JSON NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE travel_plans (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    start_date TIMESTAMPTZ,
    end_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    is_ended BOOLEAN,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE travel_days (
    id BIGSERIAL PRIMARY KEY,
    trip_plan_id BIGINT,
    day_index SMALLINT,
    title VARCHAR(50),
    date VARCHAR(50),
    FOREIGN KEY(trip_plan_id) REFERENCES travel_plans(id)
);

CREATE TABLE travel_spot (
    id BIGSERIAL PRIMARY KEY,
    day_id BIGINT NOT NULL,
    title VARCHAR(150) NOT NULL,
    start_at_utc TIMESTAMPTZ,
    end_at_utc TIMESTAMPTZ,
    place_name VARCHAR(64),
    address VARCHAR(200),
    lat NUMERIC(10,7),
    lng NUMERIC(10,7),
    cost BIGINT,
    FOREIGN KEY(day_id) REFERENCES travel_days(id)
);

CREATE TABLE current_activity (
    id BIGSERIAL PRIMARY KEY,
    travelspot_id BIGINT NOT NULL,
    actual_cost BIGINT,
    review TEXT,
    ended_at DATE,
    FOREIGN KEY(travelspot_id) REFERENCES travel_spot(id)
);


-- =========================================
-- TRAVELGRAM POSTS / PHOTOS / HASHTAGS
-- =========================================
CREATE TABLE post_records (
    id BIGSERIAL PRIMARY KEY,
    caption TEXT NOT NULL,
    is_posted BOOLEAN NOT NULL,
    post_url TEXT,
    created_at TIMESTAMPTZ NOT NULL,
    travel_plan_id BIGINT NOT NULL,
    style_id BIGINT NOT NULL,
    FOREIGN KEY(travel_plan_id) REFERENCES travel_plans(id)
);

CREATE TABLE photo_groups (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL,
    post_record_id BIGINT NOT NULL,
    FOREIGN KEY(post_record_id) REFERENCES post_records(id)
);

CREATE TABLE photos (
    id BIGSERIAL PRIMARY KEY,
    file_url TEXT NOT NULL,
    lat NUMERIC(10,7),
    lng NUMERIC(10,7),
    taken_at TIMESTAMPTZ,
    order_index INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    group_id BIGINT NOT NULL,
    FOREIGN KEY(group_id) REFERENCES photo_groups(id)
);

CREATE TABLE hashtag_groups (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL,
    post_record_id BIGINT NOT NULL,
    FOREIGN KEY(post_record_id) REFERENCES post_records(id)
);

CREATE TABLE hashtags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    is_selected BOOLEAN NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    group_id BIGINT NOT NULL,
    FOREIGN KEY(group_id) REFERENCES hashtag_groups(id)
);


-- =========================================
-- AI ANALYSIS (STYLE / HASHTAG)
-- =========================================
CREATE TABLE ai_post_analysis (
    id BIGSERIAL PRIMARY KEY,
    prompt_text TEXT NOT NULL,
    input_json JSONB NOT NULL,
    output_json JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    user_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(post_id) REFERENCES post_records(id)
);

CREATE TABLE ai_style_recommendation (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    confidence NUMERIC(4,3) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    analysis_id BIGINT NOT NULL,
    FOREIGN KEY(analysis_id) REFERENCES ai_post_analysis(id)
);

CREATE TABLE ai_hashtag_recommendation (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    confidence NUMERIC(4,3) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    analysis_id BIGINT NOT NULL,
    FOREIGN KEY(analysis_id) REFERENCES ai_post_analysis(id)
);


-- =========================================
-- PLACES & SEARCH
-- =========================================
CREATE TABLE places (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000),
    lat NUMERIC(10,7) NOT NULL,
    lng NUMERIC(10,7) NOT NULL,
    address VARCHAR(500) NOT NULL,
    place_type VARCHAR(500) NOT NULL,
    image_url VARCHAR(1000),
    thumbnail_url VARCHAR(1000)
);

CREATE TABLE image_place_searches (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    searched_at TIMESTAMP NOT NULL,
    action_type image_action_type NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE image_place_search_results (
    id BIGSERIAL PRIMARY KEY,
    image_search_history_id BIGINT NOT NULL,
    place_id BIGINT NOT NULL,
    is_selected BOOLEAN NOT NULL DEFAULT FALSE,
    rank BIGINT NOT NULL,
    FOREIGN KEY(image_search_history_id) REFERENCES image_place_searches(id),
    FOREIGN KEY(place_id) REFERENCES places(id)
);


-- =========================================
-- CHAT MEMORY / VECTOR MEMORY
-- =========================================
CREATE TABLE chat_memory (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    agent_id VARCHAR(50) NOT NULL,
    turn_index INT NOT NULL,
    content TEXT NOT NULL,
    token_count INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    role VARCHAR(10) NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE chat_memory_vector (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    agent_id VARCHAR(50) NOT NULL,
    turn_index INT NOT NULL,
    content TEXT NOT NULL,
    token_count INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    role VARCHAR(10) NOT NULL,
    embedding VECTOR(1536),
    FOREIGN KEY(user_id) REFERENCES users(id)
);


-- =========================================
-- CHECKLIST
-- =========================================
CREATE TABLE checklists (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    day_index BIGINT,
    created_at DATE,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE checklist_items (
    id BIGSERIAL PRIMARY KEY,
    checklist_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    category checklist_category NOT NULL,
    is_checked BOOLEAN NOT NULL,
    created_at DATE NOT NULL,
    FOREIGN KEY(checklist_id) REFERENCES checklists(id)
);


-- =========================================
-- HOTEL / PAYMENT
-- =========================================
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
    updated_at TIMESTAMPTZ NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE payment_transactions (
    id BIGSERIAL PRIMARY KEY,
    hotel_booking_id BIGINT NOT NULL,
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
    updated_at TIMESTAMPTZ NOT NULL,
    FOREIGN KEY(hotel_booking_id) REFERENCES hotel_bookings(id)
);


-- =========================================
-- TOILETS
-- =========================================
CREATE TABLE toilets (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    lat NUMERIC(10,7) NOT NULL,
    lng NUMERIC(10,7) NOT NULL,
    address VARCHAR(500) NOT NULL
);
