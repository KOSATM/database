-- =========================================
-- EXTENSIONS
-- =========================================
CREATE EXTENSION IF NOT EXISTS vector;

-- =========================================
-- ENUM TYPES (updated with migration)
-- =========================================
DROP TYPE IF EXISTS public.checklist_category_enum CASCADE;
DROP TYPE IF EXISTS public.image_action_type_enum CASCADE;
DROP TYPE IF EXISTS public.image_status_enum CASCADE;

CREATE TYPE public.checklist_category_enum AS ENUM ('LOCATION', 'GENERAL', 'WEATHER');
CREATE TYPE public.image_action_type_enum AS ENUM ('SAVE_ONLY', 'EDIT_ITINERARY', 'REPLACE');
CREATE TYPE public.image_status_enum AS ENUM ('PENDING', 'READY', 'FAILED');

-- 신규 ENUM
CREATE TYPE travel_type_enum AS ENUM ('SOLO', 'GROUP', 'UNCLEAR');

-- =========================================
-- TABLES
-- =========================================

-- Users
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
    created_at TIMESTAMPTZ NOT NULL 
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

-- Plans
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

-- Travel Places
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
    normalized_category TEXT,
    UNIQUE (content_id)
);
-- Image places
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
    image_status public.image_status_enum DEFAULT 'PENDING' NOT NULL
);

CREATE TABLE image_search_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    action_type public.image_action_type_enum NOT NULL
);

CREATE TABLE image_search_candidates (
    id BIGSERIAL PRIMARY KEY,
    image_search_place_id BIGINT NOT NULL,
    image_place_id BIGINT NOT NULL,
    is_selected BOOLEAN DEFAULT false NOT NULL,
    rank BIGINT NOT NULL
);

-- Review System
CREATE TABLE review_posts (
    id BIGSERIAL PRIMARY KEY,
    caption TEXT,
    is_posted BOOLEAN DEFAULT false NOT NULL,
    review_post_url TEXT,
    created_at TIMESTAMPTZ NOT NULL,
    plan_id BIGINT NOT NULL,
    review_style_id BIGINT,
    photo_group_id BIGINT,
    hashtag_group_id BIGINT,
    travel_type travel_type_enum,      -- (NEW)
    overall_moods TEXT                 -- (NEW)
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
    photo_group_id BIGINT NOT NULL,
    summary TEXT       -- (NEW)
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

-- AI Review
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

-- Checklists
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
    category public.checklist_category_enum NOT NULL,
    is_checked BOOLEAN NOT NULL,
    created_at TIMESTAMPTZ NOT NULL
);

-- Chat Memory
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
-- Name: toilets; Type: TABLE
CREATE TABLE public.toilets (
    id BIGSERIAL NOT NULL,
    name character varying(255) NOT NULL,
    lat numeric(10,7) NOT NULL,
    lng numeric(10,7) NOT NULL,
    address character varying(500) NOT NULL
);
ALTER TABLE public.toilets OWNER TO postgres;


-- Table: public.hotels

-- DROP TABLE IF EXISTS public.hotels;

CREATE TABLE IF NOT EXISTS public.hotels
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    external_hotel_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    name character varying(200) COLLATE pg_catalog."default" NOT NULL,
    name_local character varying(200) COLLATE pg_catalog."default",
    star_rating numeric(2,1),
    rating_score numeric(3,2),
    review_count integer,
    description text COLLATE pg_catalog."default",
    country_code character(2) COLLATE pg_catalog."default" NOT NULL,
    city character varying(100) COLLATE pg_catalog."default",
    district character varying(100) COLLATE pg_catalog."default",
    neighborhood character varying(100) COLLATE pg_catalog."default",
    address_line1 character varying(200) COLLATE pg_catalog."default",
    address_line2 character varying(200) COLLATE pg_catalog."default",
    postal_code character varying(20) COLLATE pg_catalog."default",
    latitude numeric(10,7),
    longitude numeric(10,7),
    near_metro boolean NOT NULL DEFAULT false,
    metro_station_name character varying(100) COLLATE pg_catalog."default",
    metro_distance_m integer,
    airport_distance_km numeric(5,2),
    has_airport_bus boolean NOT NULL DEFAULT false,
    checkin_from time without time zone,
    checkout_until time without time zone,
    timezone character varying(50) COLLATE pg_catalog."default",
    has_24h_frontdesk boolean NOT NULL DEFAULT true,
    has_english_staff boolean NOT NULL DEFAULT false,
    has_japanese_staff boolean NOT NULL DEFAULT false,
    has_chinese_staff boolean NOT NULL DEFAULT false,
    has_free_wifi boolean NOT NULL DEFAULT true,
    has_breakfast_restaurant boolean NOT NULL DEFAULT false,
    has_parking boolean NOT NULL DEFAULT false,
    is_family_friendly boolean NOT NULL DEFAULT false,
    is_pet_friendly boolean NOT NULL DEFAULT false,
    phone character varying(50) COLLATE pg_catalog."default",
    email character varying(100) COLLATE pg_catalog."default",
    website_url character varying(300) COLLATE pg_catalog."default",
    provider_tags jsonb,
    provider_raw_meta jsonb,
    llm_summary text COLLATE pg_catalog."default",
    llm_tags jsonb,
    llm_last_updated_at timestamp with time zone,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT hotels_pkey PRIMARY KEY (id),
    CONSTRAINT hotels_external_hotel_id_key UNIQUE (external_hotel_id),
    CONSTRAINT chk_hotels_rating_score CHECK (rating_score IS NULL OR rating_score >= 0::numeric AND rating_score <= 10::numeric),
    CONSTRAINT chk_hotels_star_rating CHECK (star_rating IS NULL OR star_rating >= 0::numeric AND star_rating <= 5::numeric)
);

-- Table: public.hotel_rooms
CREATE TABLE hotel_bookings (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    -- 양식을 따른 것이므로 id BIGINT를 사용하지 않음
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
    -- 양식을 따른 것이므로 id BIGINT를 사용하지 않음
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


-- DROP TABLE IF EXISTS public.hotel_rooms;

CREATE TABLE IF NOT EXISTS public.hotel_rooms
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    hotel_id bigint NOT NULL,
    external_room_type_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    name character varying(200) COLLATE pg_catalog."default" NOT NULL,
    name_local character varying(200) COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    max_occupancy integer NOT NULL,
    adults_max integer,
    children_max integer,
    room_size_sqm numeric(5,1),
    bed_type character varying(50) COLLATE pg_catalog."default",
    bed_count integer,
    extra_bed_available boolean NOT NULL DEFAULT false,
    has_private_bathroom boolean NOT NULL DEFAULT true,
    has_bathtub boolean NOT NULL DEFAULT false,
    has_shower_only boolean NOT NULL DEFAULT false,
    has_kitchenette boolean NOT NULL DEFAULT false,
    has_washing_machine boolean NOT NULL DEFAULT false,
    is_smoking_allowed boolean NOT NULL DEFAULT false,
    is_accessible_room boolean NOT NULL DEFAULT false,
    connecting_available boolean NOT NULL DEFAULT false,
    provider_room_meta jsonb,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT hotel_rooms_pkey PRIMARY KEY (id),
    CONSTRAINT uq_rooms_external UNIQUE (hotel_id, external_room_type_id),
    CONSTRAINT fk_rooms_hotel FOREIGN KEY (hotel_id)
        REFERENCES public.hotels (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.hotel_rooms
    OWNER to postgres;
-- Index: idx_hotel_rooms_hotel_id

-- DROP INDEX IF EXISTS public.idx_hotel_rooms_hotel_id;

CREATE INDEX IF NOT EXISTS idx_hotel_rooms_hotel_id
    ON public.hotel_rooms USING btree
    (hotel_id ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;


ALTER TABLE IF EXISTS public.hotels
    OWNER to postgres;
-- Index: idx_hotels_country_city

-- DROP INDEX IF EXISTS public.idx_hotels_country_city;

CREATE INDEX IF NOT EXISTS idx_hotels_country_city
    ON public.hotels USING btree
    (country_code COLLATE pg_catalog."default" ASC NULLS LAST, city COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: idx_hotels_is_active_city

-- DROP INDEX IF EXISTS public.idx_hotels_is_active_city;

CREATE INDEX IF NOT EXISTS idx_hotels_is_active_city
    ON public.hotels USING btree
    (is_active ASC NULLS LAST, city COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;

-- Table: public.hotel_rate_plans

-- DROP TABLE IF EXISTS public.hotel_rate_plans;

CREATE TABLE IF NOT EXISTS public.hotel_rate_plans
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    hotel_id bigint NOT NULL,
    room_type_id bigint NOT NULL,
    external_rate_plan_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    name character varying(200) COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    meal_plan character varying(50) COLLATE pg_catalog."default",
    includes_breakfast boolean NOT NULL DEFAULT false,
    refundable_type character varying(20) COLLATE pg_catalog."default" NOT NULL DEFAULT 'REFUNDABLE'::character varying,
    free_cancel_until timestamp with time zone,
    payment_type character varying(20) COLLATE pg_catalog."default" NOT NULL DEFAULT 'PREPAID'::character varying,
    requires_full_prepayment boolean NOT NULL DEFAULT false,
    base_occupancy integer NOT NULL DEFAULT 2,
    max_occupancy integer NOT NULL DEFAULT 2,
    currency character(3) COLLATE pg_catalog."default" NOT NULL,
    tax_included boolean NOT NULL DEFAULT true,
    fee_included boolean NOT NULL DEFAULT true,
    base_price numeric(12,2),
    provider_rate_meta jsonb,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT hotel_rate_plans_pkey PRIMARY KEY (id),
    CONSTRAINT uq_rate_plans_external UNIQUE (hotel_id, external_rate_plan_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.hotel_rate_plans
    OWNER to postgres;
-- Index: idx_rate_plans_hotel_id

-- DROP INDEX IF EXISTS public.idx_rate_plans_hotel_id;

CREATE INDEX IF NOT EXISTS idx_rate_plans_hotel_id
    ON public.hotel_rate_plans USING btree
    (hotel_id ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: idx_rate_plans_room_type_id

-- DROP INDEX IF EXISTS public.idx_rate_plans_room_type_id;

CREATE INDEX IF NOT EXISTS idx_rate_plans_room_type_id
    ON public.hotel_rate_plans USING btree
    (room_type_id ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;


-- Table: public.hotel_rate_plan_prices

-- DROP TABLE IF EXISTS public.hotel_rate_plan_prices;

CREATE TABLE IF NOT EXISTS public.hotel_rate_plan_prices
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    rate_plan_id bigint NOT NULL,
    stay_date date NOT NULL,
    price numeric(12,2) NOT NULL,
    tax_amount numeric(12,2) NOT NULL DEFAULT 0,
    fee_amount numeric(12,2) NOT NULL DEFAULT 0,
    remaining_rooms integer,
    is_closed boolean NOT NULL DEFAULT false,
    fetched_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT hotel_rate_plan_prices_pkey PRIMARY KEY (id),
    CONSTRAINT uq_rate_plan_prices_unique UNIQUE (rate_plan_id, stay_date),
    CONSTRAINT fk_rate_plan_prices_plan FOREIGN KEY (rate_plan_id)
        REFERENCES public.hotel_rate_plans (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.hotel_rate_plan_prices
    OWNER to postgres;
-- Index: idx_rate_plan_prices_plan_id

-- DROP INDEX IF EXISTS public.idx_rate_plan_prices_plan_id;

CREATE INDEX IF NOT EXISTS idx_rate_plan_prices_plan_id
    ON public.hotel_rate_plan_prices USING btree
    (rate_plan_id ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;




-- =========================================
-- FOREIGN KEYS
-- =========================================
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