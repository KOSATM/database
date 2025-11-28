-- PostgreSQL database dump
--

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg12+1)
-- Dumped by pg_dump version 17.6 (Debian 17.6-1.pgdg12+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- FK 제약 조건 활성화/비활성화를 제어 (선택 사항이나, DDL 재구성 흐름상 필요할 수 있음)
SET session_replication_role = replica;

-- =========================================
-- 1. SCHEMA & EXTENSIONS
-- =========================================

-- Name: public; Type: SCHEMA
CREATE SCHEMA public;
ALTER SCHEMA public OWNER TO pg_database_owner;
COMMENT ON SCHEMA public IS 'standard public schema';

-- pgvector 확장 모듈 (DDL에 명시되지 않았으나 테이블에 사용됨)
-- CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;

-- =========================================
-- 2. ENUM TYPES
-- =========================================

-- Name: checklist_category; Type: TYPE
CREATE TYPE public.checklist_category AS ENUM (
    'PACKING',
    'CLOTHES',
    'DOCUMENT',
    'ETC'
);
ALTER TYPE public.checklist_category OWNER TO postgres;

-- Name: image_action_type; Type: TYPE
CREATE TYPE public.image_action_type AS ENUM (
    'SAVE_ONLY',
    'EDIT_ITINERARY',
    'REPLACE'
);
ALTER TYPE public.image_action_type OWNER TO postgres;

-- Name: image_status_enum; Type: TYPE
CREATE TYPE public.image_status_enum AS ENUM (
    'PENDING',
    'READY',
    'FAILED'
);
ALTER TYPE public.image_status_enum OWNER TO postgres;

-- =========================================
-- 3. FUNCTIONS
-- =========================================

-- Name: update_timestamp(); Type: FUNCTION
CREATE FUNCTION public.update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;
ALTER FUNCTION public.update_timestamp() OWNER TO postgres;

-- =========================================
-- 4. CREATE SEQUENCES
-- =========================================

CREATE SEQUENCE public.ai_review_analysis_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.ai_review_analysis_id_seq OWNER TO postgres;

CREATE SEQUENCE public.ai_review_hashtags_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.ai_review_hashtags_id_seq OWNER TO postgres;

CREATE SEQUENCE public.ai_review_styles_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.ai_review_styles_id_seq OWNER TO postgres;

CREATE SEQUENCE public.chat_memories_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.chat_memories_id_seq OWNER TO postgres;

CREATE SEQUENCE public.chat_memory_vectors_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.chat_memory_vectors_id_seq OWNER TO postgres;

CREATE SEQUENCE public.checklist_items_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.checklist_items_id_seq OWNER TO postgres;

CREATE SEQUENCE public.checklists_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.checklists_id_seq OWNER TO postgres;

CREATE SEQUENCE public.current_activities_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.current_activities_id_seq OWNER TO postgres;

CREATE SEQUENCE public.hotel_bookings_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.hotel_bookings_id_seq OWNER TO postgres;

CREATE SEQUENCE public.hotel_rate_plan_prices_rate_plan_price_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.hotel_rate_plan_prices_rate_plan_price_id_seq OWNER TO postgres;

CREATE SEQUENCE public.hotel_rate_plans_rate_plan_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.hotel_rate_plans_rate_plan_id_seq OWNER TO postgres;

CREATE SEQUENCE public.hotel_rooms_room_type_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.hotel_rooms_room_type_id_seq OWNER TO postgres;

CREATE SEQUENCE public.hotels_hotel_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.hotels_hotel_id_seq OWNER TO postgres;

CREATE SEQUENCE public.image_search_places_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.image_search_places_id_seq OWNER TO postgres;

CREATE SEQUENCE public.image_search_results_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.image_search_results_id_seq OWNER TO postgres;

CREATE SEQUENCE public.payment_transactions_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.payment_transactions_id_seq OWNER TO postgres;

CREATE SEQUENCE public.places_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.places_id_seq OWNER TO postgres;

CREATE SEQUENCE public.review_hashtag_groups_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.review_hashtag_groups_id_seq OWNER TO postgres;

CREATE SEQUENCE public.review_hashtags_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.review_hashtags_id_seq OWNER TO postgres;

CREATE SEQUENCE public.review_photo_groups_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.review_photo_groups_id_seq OWNER TO postgres;

CREATE SEQUENCE public.review_photos_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.review_photos_id_seq OWNER TO postgres;

CREATE SEQUENCE public.review_posts_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.review_posts_id_seq OWNER TO postgres;

CREATE SEQUENCE public.sns_tokens_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.sns_tokens_id_seq OWNER TO postgres;

CREATE SEQUENCE public.toilets_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.toilets_id_seq OWNER TO postgres;

CREATE SEQUENCE public.travel_days_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.travel_days_id_seq OWNER TO postgres;

CREATE SEQUENCE public.travel_places_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.travel_places_id_seq OWNER TO postgres;

CREATE SEQUENCE public.travel_places_id_seq1
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.travel_places_id_seq1 OWNER TO postgres;

CREATE SEQUENCE public.travel_plan_snapshots_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.travel_plan_snapshots_id_seq OWNER TO postgres;

CREATE SEQUENCE public.plans_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.plans_id_seq OWNER TO postgres;

CREATE SEQUENCE public.user_identities_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.user_identities_id_seq OWNER TO postgres;

CREATE SEQUENCE public.users_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.users_id_seq OWNER TO postgres;


-- =========================================
-- 5. CREATE TABLES (WITH DEFAULT VALUES/IDENTITY, NO CONSTRAINTS)
-- =========================================

SET default_tablespace = '';
SET default_table_access_method = heap;

-- Name: ai_review_analysis; Type: TABLE
CREATE TABLE public.ai_review_analysis (
    id bigint DEFAULT nextval('public.ai_review_analysis_id_seq'::regclass) NOT NULL,
    prompt_text text NOT NULL,
    input_json jsonb NOT NULL,
    output_json jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_id bigint NOT NULL,
    review_post_id bigint NOT NULL
);
ALTER TABLE public.ai_review_analysis OWNER TO postgres;

-- Name: ai_review_hashtags; Type: TABLE
CREATE TABLE public.ai_review_hashtags (
    id bigint DEFAULT nextval('public.ai_review_hashtags_id_seq'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    review_analysis_id bigint NOT NULL,
    review_style_id bigint
);
ALTER TABLE public.ai_review_hashtags OWNER TO postgres;

-- Name: ai_review_styles; Type: TABLE
CREATE TABLE public.ai_review_styles (
    id bigint DEFAULT nextval('public.ai_review_styles_id_seq'::regclass) NOT NULL,
    name character varying(150) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    review_analysis_id bigint NOT NULL,
    tone_code character varying(50),
    is_trendy boolean DEFAULT false,
    description text,
    embedding public.vector(1536)
);
ALTER TABLE public.ai_review_styles OWNER TO postgres;

-- Name: chat_memories; Type: TABLE
CREATE TABLE public.chat_memories (
    id bigint DEFAULT nextval('public.chat_memories_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    agent_name character varying(50) NOT NULL,
    order_index integer NOT NULL,
    content text NOT NULL,
    token_usage bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    role character varying(10) NOT NULL
);
ALTER TABLE public.chat_memories OWNER TO postgres;

-- Name: chat_memory_vectors; Type: TABLE
CREATE TABLE public.chat_memory_vectors (
    id bigint DEFAULT nextval('public.chat_memory_vectors_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    agent_name character varying(50) NOT NULL,
    order_index bigint NOT NULL,
    content text NOT NULL,
    token_usage bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    role character varying(10) NOT NULL,
    embedding public.vector(1536)
);
ALTER TABLE public.chat_memory_vectors OWNER TO postgres;

-- Name: checklist_items; Type: TABLE
CREATE TABLE public.checklist_items (
    id bigint DEFAULT nextval('public.checklist_items_id_seq'::regclass) NOT NULL,
    checklist_id bigint NOT NULL,
    content text NOT NULL,
    category public.checklist_category NOT NULL,
    is_checked boolean NOT NULL,
    created_at timestamp with time zone NOT NULL
);
ALTER TABLE public.checklist_items OWNER TO postgres;

-- Name: checklists; Type: TABLE
CREATE TABLE public.checklists (
    id bigint DEFAULT nextval('public.checklists_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    day_index smallint,
    created_at timestamp with time zone
);
ALTER TABLE public.checklists OWNER TO postgres;

-- Name: current_activities; Type: TABLE
CREATE TABLE public.current_activities (
    id bigint DEFAULT nextval('public.current_activities_id_seq'::regclass) NOT NULL,
    travel_place_id bigint NOT NULL,
    actual_cost numeric(19,2),
    memo text,
    ended_at timestamp with time zone
);
ALTER TABLE public.current_activities OWNER TO postgres;

-- Name: hotel_bookings; Type: TABLE
CREATE TABLE public.hotel_bookings (
    id bigint DEFAULT nextval('public.hotel_bookings_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    external_booking_id character varying(100),
    hotel_id bigint NOT NULL,
    room_type_id bigint NOT NULL,
    rate_plan_id bigint NOT NULL,
    checkin_date date NOT NULL,
    checkout_date date NOT NULL,
    nights integer NOT NULL,
    adults_count integer NOT NULL,
    children_count integer NOT NULL,
    currency character(3) NOT NULL,
    total_price numeric(12,2) NOT NULL,
    tax_amount numeric(12,2) NOT NULL,
    fee_amount numeric(12,2) NOT NULL,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    payment_status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    guest_name character varying(200),
    guest_email character varying(100),
    guest_phone character varying(50),
    provider_booking_meta jsonb,
    booked_at timestamp with time zone NOT NULL,
    cancelled_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);
ALTER TABLE public.hotel_bookings OWNER TO postgres;

-- Name: hotel_rate_plan_prices; Type: TABLE
CREATE TABLE public.hotel_rate_plan_prices (
    id bigint NOT NULL DEFAULT nextval('public.hotel_rate_plan_prices_rate_plan_price_id_seq'::regclass),
    rate_plan_id bigint NOT NULL,
    stay_date date NOT NULL,
    price numeric(12,2) NOT NULL,
    tax_amount numeric(12,2) DEFAULT 0 NOT NULL,
    fee_amount numeric(12,2) DEFAULT 0 NOT NULL,
    remaining_rooms integer,
    is_closed boolean DEFAULT false NOT NULL,
    fetched_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.hotel_rate_plan_prices OWNER TO postgres;

-- Name: hotel_rate_plans; Type: TABLE
CREATE TABLE public.hotel_rate_plans (
    id bigint NOT NULL DEFAULT nextval('public.hotel_rate_plans_rate_plan_id_seq'::regclass),
    hotel_id bigint NOT NULL,
    room_type_id bigint NOT NULL,
    external_rate_plan_id character varying(100) NOT NULL,
    name character varying(200),
    description text,
    meal_plan character varying(50),
    includes_breakfast boolean DEFAULT false NOT NULL,
    refundable_type character varying(20) DEFAULT 'REFUNDABLE'::character varying NOT NULL,
    free_cancel_until timestamp with time zone,
    payment_type character varying(20) DEFAULT 'PREPAID'::character varying NOT NULL,
    requires_full_prepayment boolean DEFAULT false NOT NULL,
    base_occupancy integer DEFAULT 2 NOT NULL,
    max_occupancy integer DEFAULT 2 NOT NULL,
    currency character(3) NOT NULL,
    tax_included boolean DEFAULT true NOT NULL,
    fee_included boolean DEFAULT true NOT NULL,
    base_price numeric(12,2),
    provider_rate_meta jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.hotel_rate_plans OWNER TO postgres;

-- Name: hotel_rooms; Type: TABLE
CREATE TABLE public.hotel_rooms (
    id bigint NOT NULL DEFAULT nextval('public.hotel_rooms_room_type_id_seq'::regclass),
    hotel_id bigint NOT NULL,
    external_room_type_id character varying(100) NOT NULL,
    name character varying(200) NOT NULL,
    name_local character varying(200),
    description text,
    max_occupancy integer NOT NULL,
    adults_max integer,
    children_max integer,
    room_size_sqm numeric(5,1),
    bed_type character varying(50),
    bed_count integer,
    extra_bed_available boolean DEFAULT false NOT NULL,
    has_private_bathroom boolean DEFAULT true NOT NULL,
    has_bathtub boolean DEFAULT false NOT NULL,
    has_shower_only boolean DEFAULT false NOT NULL,
    has_kitchenette boolean DEFAULT false NOT NULL,
    has_washing_machine boolean DEFAULT false NOT NULL,
    is_smoking_allowed boolean DEFAULT false NOT NULL,
    is_accessible_room boolean DEFAULT false NOT NULL,
    connecting_available boolean DEFAULT false NOT NULL,
    provider_room_meta jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.hotel_rooms OWNER TO postgres;

-- Name: hotels; Type: TABLE
CREATE TABLE public.hotels (
    id bigint NOT NULL DEFAULT nextval('public.hotels_hotel_id_seq'::regclass),
    external_hotel_id character varying(100) NOT NULL,
    name character varying(200) NOT NULL,
    name_local character varying(200),
    star_rating numeric(2,1),
    rating_score numeric(3,2),
    review_count integer,
    description text,
    country_code character(2) NOT NULL,
    city character varying(100),
    district character varying(100),
    neighborhood character varying(100),
    address_line1 character varying(200),
    address_line2 character varying(200),
    postal_code character varying(20),
    latitude numeric(10,7),
    longitude numeric(10,7),
    near_metro boolean DEFAULT false NOT NULL,
    metro_station_name character varying(100),
    metro_distance_m integer,
    airport_distance_km numeric(5,2),
    has_airport_bus boolean DEFAULT false NOT NULL,
    checkin_from time without time zone,
    checkout_until time without time zone,
    timezone character varying(50),
    has_24h_frontdesk boolean DEFAULT true NOT NULL,
    has_english_staff boolean DEFAULT false NOT NULL,
    has_japanese_staff boolean DEFAULT false NOT NULL,
    has_chinese_staff boolean DEFAULT false NOT NULL,
    has_free_wifi boolean DEFAULT true NOT NULL,
    has_breakfast_restaurant boolean DEFAULT false NOT NULL,
    has_parking boolean DEFAULT false NOT NULL,
    is_family_friendly boolean DEFAULT false NOT NULL,
    is_pet_friendly boolean DEFAULT false NOT NULL,
    phone character varying(50),
    email character varying(100),
    website_url character varying(300),
    provider_tags jsonb,
    provider_raw_meta jsonb,
    llm_summary text,
    llm_tags jsonb,
    llm_last_updated_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.hotels OWNER TO postgres;

-- Name: image_places; Type: TABLE
CREATE TABLE public.image_places (
    id bigint DEFAULT nextval('public.places_id_seq'::regclass) NOT NULL,
    name character varying(255) NOT NULL,
    content character varying(1000),
    lat numeric(10,7) NOT NULL,
    lng numeric(10,7) NOT NULL,
    address character varying(500) NOT NULL,
    place_type character varying(500) NOT NULL,
    internal_original_url text,
    internal_thumbnail_url text,
    external_image_url text,
    image_status public.image_status_enum DEFAULT 'PENDING'::public.image_status_enum NOT NULL
);
ALTER TABLE public.image_places OWNER TO postgres;

-- Name: image_search_candidates; Type: TABLE
CREATE TABLE public.image_search_candidates (
    id bigint DEFAULT nextval('public.image_search_results_id_seq'::regclass) NOT NULL,
    image_search_session_id bigint NOT NULL,
    image_place_id bigint NOT NULL,
    is_selected boolean DEFAULT false NOT NULL,
    rank bigint NOT NULL
);
ALTER TABLE public.image_search_candidates OWNER TO postgres;

-- Name: image_search_sessions; Type: TABLE
CREATE TABLE public.image_search_sessions (
    id bigint DEFAULT nextval('public.image_search_places_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    action_type public.image_action_type NOT NULL
);
ALTER TABLE public.image_search_sessions OWNER TO postgres;

-- Name: payment_transactions; Type: TABLE
CREATE TABLE public.payment_transactions (
    id bigint DEFAULT nextval('public.payment_transactions_id_seq'::regclass) NOT NULL,
    hotel_booking_id bigint NOT NULL,
    payment_method character varying(30) NOT NULL,
    provider_payment_id character varying(100),
    amount numeric(19,2) NOT NULL,
    currency character(3) NOT NULL,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    requested_at timestamp with time zone NOT NULL,
    completed_at timestamp with time zone,
    cancelled_at timestamp with time zone,
    raw_response jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);
ALTER TABLE public.payment_transactions OWNER TO postgres;

-- Name: plan_days; Type: TABLE
CREATE TABLE public.plan_days (
    id bigint DEFAULT nextval('public.travel_days_id_seq'::regclass) NOT NULL,
    plan_id bigint,
    day_index smallint,
    title character varying(50),
    plan_date date
);
ALTER TABLE public.plan_days OWNER TO postgres;

-- Name: plan_places; Type: TABLE
CREATE TABLE public.plan_places (
    id bigint DEFAULT nextval('public.travel_places_id_seq'::regclass) NOT NULL,
    day_id bigint NOT NULL,
    title character varying(150) NOT NULL,
    start_at timestamp with time zone,
    end_at timestamp with time zone,
    place_name character varying(64),
    address character varying(200),
    lat numeric(10,7),
    lng numeric(10,7),
    expected_cost numeric(19,2)
);
ALTER TABLE public.plan_places OWNER TO postgres;

-- Name: plan_snapshots; Type: TABLE
CREATE TABLE public.plan_snapshots (
    id bigint DEFAULT nextval('public.travel_plan_snapshots_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    version_no integer NOT NULL,
    snapshot_json json NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.plan_snapshots OWNER TO postgres;

-- Name: plans; Type: TABLE
CREATE TABLE public.plans (
    id bigint DEFAULT nextval('public.plans_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    title VARCHAR(100),
    budget numeric(19,2) NOT NULL,
    start_date date,
    end_date date,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    is_ended boolean
);
ALTER TABLE public.plans OWNER TO postgres;

-- Name: review_hashtag_groups; Type: TABLE
CREATE TABLE public.review_hashtag_groups (
    id bigint DEFAULT nextval('public.review_hashtag_groups_id_seq'::regclass) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    review_post_id bigint NOT NULL
);
ALTER TABLE public.review_hashtag_groups OWNER TO postgres;

-- Name: review_hashtags; Type: TABLE
CREATE TABLE public.review_hashtags (
    id bigint DEFAULT nextval('public.review_hashtags_id_seq'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    group_id bigint NOT NULL
);
ALTER TABLE public.review_hashtags OWNER TO postgres;

-- Name: review_photo_groups; Type: TABLE
CREATE TABLE public.review_photo_groups (
    id bigint DEFAULT nextval('public.review_photo_groups_id_seq'::regclass) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    review_post_id bigint NOT NULL
);
ALTER TABLE public.review_photo_groups OWNER TO postgres;

-- Name: review_photos; Type: TABLE
CREATE TABLE public.review_photos (
    id bigint DEFAULT nextval('public.review_photos_id_seq'::regclass) NOT NULL,
    file_url text NOT NULL,
    order_index integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    group_id bigint NOT NULL
);
ALTER TABLE public.review_photos OWNER TO postgres;

-- Name: review_posts; Type: TABLE
CREATE TABLE public.review_posts (
    id bigint DEFAULT nextval('public.review_posts_id_seq'::regclass) NOT NULL,
    content text,
    is_posted boolean DEFAULT false NOT NULL,
    review_post_url text,
    created_at timestamp with time zone NOT NULL,
    plan_id bigint NOT NULL,
    review_style_id bigint
);
ALTER TABLE public.review_posts OWNER TO postgres;

-- Name: sns_tokens; Type: TABLE
CREATE TABLE public.sns_tokens (
    id bigint DEFAULT nextval('public.sns_tokens_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    user_access_token text NOT NULL,
    page_access_token text,
    expires_at timestamp with time zone,
    account_type character varying(50),
    ig_business_account character varying(100),
    creator_account character varying(100),
    publish_account character varying(100),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.sns_tokens OWNER TO postgres;

-- Name: toilets; Type: TABLE
CREATE TABLE public.toilets (
    id bigint DEFAULT nextval('public.toilets_id_seq'::regclass) NOT NULL,
    name character varying(255) NOT NULL,
    lat numeric(10,7) NOT NULL,
    lng numeric(10,7) NOT NULL,
    address character varying(500) NOT NULL
);
ALTER TABLE public.toilets OWNER TO postgres;

-- Name: travel_place_categories; Type: TABLE
CREATE TABLE public.travel_place_categories (
    code text NOT NULL,
    name text NOT NULL,
    parent_code text,
    level integer NOT NULL,
    category_type text
);
ALTER TABLE public.travel_place_categories OWNER TO postgres;

-- Name: travel_places; Type: TABLE
CREATE TABLE public.travel_places (
    id bigint DEFAULT nextval('public.travel_places_id_seq1'::regclass) NOT NULL,
    content_id text NOT NULL,
    title text NOT NULL,
    address text,
    tel text,
    first_image text,
    first_image2 text,
    lat double precision,
    lng double precision,
    category_code text NOT NULL,
    description text,
    tags jsonb,
    embedding public.vector(3072),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    detail_info text
);
ALTER TABLE public.travel_places OWNER TO postgres;

-- Name: user_identities; Type: TABLE
CREATE TABLE public.user_identities (
    id bigint DEFAULT nextval('public.user_identities_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    provider character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.user_identities OWNER TO postgres;

-- Name: users; Type: TABLE
CREATE TABLE public.users (
    id bigint DEFAULT nextval('public.users_id_seq'::regclass) NOT NULL,
    is_active boolean,
    last_login_at timestamp with time zone,
    name character varying(50),
    email character varying(1000),
    profile_image_url character varying(1000),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);
ALTER TABLE public.users OWNER TO postgres;


-- =========================================
-- 6. PRIMARY KEYS & UNIQUE CONSTRAINTS (ALTER TABLE)
-- =========================================

-- Primary Keys
ALTER TABLE ONLY public.ai_review_analysis ADD CONSTRAINT ai_review_analysis_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ai_review_hashtags ADD CONSTRAINT ai_review_hashtags_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ai_review_styles ADD CONSTRAINT ai_review_styles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.chat_memories ADD CONSTRAINT chat_memories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.chat_memory_vectors ADD CONSTRAINT chat_memory_vectors_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.checklist_items ADD CONSTRAINT checklist_items_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.checklists ADD CONSTRAINT checklists_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.current_activities ADD CONSTRAINT current_activities_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.hotel_bookings ADD CONSTRAINT hotel_bookings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.hotel_rate_plan_prices ADD CONSTRAINT hotel_rate_plan_prices_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.hotel_rate_plans ADD CONSTRAINT hotel_rate_plans_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.hotel_rooms ADD CONSTRAINT hotel_rooms_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.hotels ADD CONSTRAINT hotels_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.image_search_sessions ADD CONSTRAINT image_search_places_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.image_search_candidates ADD CONSTRAINT image_search_results_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.payment_transactions ADD CONSTRAINT payment_transactions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.image_places ADD CONSTRAINT places_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.review_hashtag_groups ADD CONSTRAINT review_hashtag_groups_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.review_hashtags ADD CONSTRAINT review_hashtags_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.review_photo_groups ADD CONSTRAINT review_photo_groups_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.review_photos ADD CONSTRAINT review_photos_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.review_posts ADD CONSTRAINT review_posts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.sns_tokens ADD CONSTRAINT sns_tokens_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.toilets ADD CONSTRAINT toilets_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.plan_days ADD CONSTRAINT plan_days_pkey PRIMARY KEY (id); -- Original DDL name
ALTER TABLE ONLY public.travel_place_categories ADD CONSTRAINT travel_place_categories_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.plan_places ADD CONSTRAINT plan_places_pkey PRIMARY KEY (id); -- Original DDL name
ALTER TABLE ONLY public.travel_places ADD CONSTRAINT travel_places_pkey1 PRIMARY KEY (id);
ALTER TABLE ONLY public.plan_snapshots ADD CONSTRAINT plan_snapshots_pkey PRIMARY KEY (id); -- Original DDL name
ALTER TABLE ONLY public.plans ADD CONSTRAINT plans_pkey PRIMARY KEY (id); -- Original DDL name
ALTER TABLE ONLY public.user_identities ADD CONSTRAINT user_identities_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_pkey PRIMARY KEY (id);

-- Unique Constraints
ALTER TABLE ONLY public.hotels ADD CONSTRAINT hotels_external_hotel_id_key UNIQUE (external_hotel_id);
ALTER TABLE ONLY public.travel_places ADD CONSTRAINT travel_places_content_id_key UNIQUE (content_id);
ALTER TABLE ONLY public.hotel_rate_plan_prices ADD CONSTRAINT uq_rate_plan_prices_unique UNIQUE (rate_plan_id, stay_date);
ALTER TABLE ONLY public.hotel_rate_plans ADD CONSTRAINT uq_rate_plans_external UNIQUE (hotel_id, external_rate_plan_id);
ALTER TABLE ONLY public.hotel_rooms ADD CONSTRAINT uq_rooms_external UNIQUE (hotel_id, external_room_type_id);
ALTER TABLE ONLY public.user_identities ADD CONSTRAINT user_identities_user_id_provider_key UNIQUE (user_id, provider);


-- Check Constraints
ALTER TABLE ONLY public.hotels ADD CONSTRAINT chk_hotels_rating_score CHECK (((rating_score IS NULL) OR ((rating_score >= (0)::numeric) AND (rating_score <= (10)::numeric))));
ALTER TABLE ONLY public.hotels ADD CONSTRAINT chk_hotels_star_rating CHECK (((star_rating IS NULL) OR ((star_rating >= (0)::numeric) AND (star_rating <= (5)::numeric))));


-- =========================================
-- 7. INDEXES
-- =========================================

CREATE INDEX idx_hotel_rooms_hotel_id ON public.hotel_rooms USING btree (hotel_id);
CREATE INDEX idx_hotels_country_city ON public.hotels USING btree (country_code, city);
CREATE INDEX idx_hotels_is_active_city ON public.hotels USING btree (is_active, city);
CREATE INDEX idx_rate_plan_prices_plan_id ON public.hotel_rate_plan_prices USING btree (rate_plan_id);
CREATE INDEX idx_rate_plans_hotel_id ON public.hotel_rate_plans USING btree (hotel_id);
CREATE INDEX idx_rate_plans_room_type_id ON public.hotel_rate_plans USING btree (room_type_id);


-- =========================================
-- 8. FOREIGN KEY CONSTRAINTS (ALTER TABLE)
-- =========================================

-- users, hotels, places
ALTER TABLE ONLY public.ai_review_analysis ADD CONSTRAINT fk_ai_review_analysis_user FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.chat_memories ADD CONSTRAINT fk_chat_memories_user FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.chat_memory_vectors ADD CONSTRAINT fk_chat_memory_vectors_user FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.checklists ADD CONSTRAINT fk_checklists_user FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.image_search_sessions ADD CONSTRAINT fk_image_search_places_user FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.plan_snapshots ADD CONSTRAINT fk_plan_snapshots_user FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.plans ADD CONSTRAINT fk_plans_user FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.sns_tokens ADD CONSTRAINT fk_sns_tokens_user FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.user_identities ADD CONSTRAINT fk_user_identities_user FOREIGN KEY (user_id) REFERENCES public.users(id);

ALTER TABLE ONLY public.hotel_rooms ADD CONSTRAINT fk_rooms_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.hotel_rate_plans ADD CONSTRAINT fk_rate_plans_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(id);
ALTER TABLE ONLY public.hotel_bookings ADD CONSTRAINT fk_hotel_bookings_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(id);
ALTER TABLE ONLY public.travel_places ADD CONSTRAINT travel_places_category_code_fkey FOREIGN KEY (category_code) REFERENCES public.travel_place_categories(code);

-- plan/day/place hierarchy
ALTER TABLE ONLY public.plan_days ADD CONSTRAINT fk_plan_days_plan FOREIGN KEY (plan_id) REFERENCES public.plans(id);
ALTER TABLE ONLY public.plan_places ADD CONSTRAINT fk_plan_places_day FOREIGN KEY (day_id) REFERENCES public.plan_days(id);
ALTER TABLE ONLY public.current_activities ADD CONSTRAINT fk_current_activities_place FOREIGN KEY (travel_place_id) REFERENCES public.plan_places(id);
ALTER TABLE ONLY public.image_search_candidates ADD CONSTRAINT fk_image_search_results_place FOREIGN KEY (image_place_id) REFERENCES public.image_places(id);
ALTER TABLE ONLY public.image_search_candidates ADD CONSTRAINT fk_image_search_results_search_place FOREIGN KEY (image_search_session_id) REFERENCES public.image_search_sessions(id);

-- hotel bookings & rates
ALTER TABLE ONLY public.hotel_bookings ADD CONSTRAINT fk_hotel_bookings_room FOREIGN KEY (room_type_id) REFERENCES public.hotel_rooms(id);
ALTER TABLE ONLY public.hotel_bookings ADD CONSTRAINT fk_hotel_bookings_rate_plan FOREIGN KEY (rate_plan_id) REFERENCES public.hotel_rate_plans(id);
ALTER TABLE ONLY public.hotel_rate_plans ADD CONSTRAINT fk_rate_plans_room_type FOREIGN KEY (room_type_id) REFERENCES public.hotel_rooms(id);
ALTER TABLE ONLY public.hotel_rate_plan_prices ADD CONSTRAINT fk_rate_plan_prices_plan FOREIGN KEY (rate_plan_id) REFERENCES public.hotel_rate_plans(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.payment_transactions ADD CONSTRAINT fk_payment_transactions_booking FOREIGN KEY (hotel_booking_id) REFERENCES public.hotel_bookings(id);

-- review related
ALTER TABLE ONLY public.ai_review_analysis ADD CONSTRAINT fk_ai_review_analysis_post FOREIGN KEY (review_post_id) REFERENCES public.review_posts(id);
ALTER TABLE ONLY public.ai_review_hashtags ADD CONSTRAINT fk_ai_review_hashtags_analysis FOREIGN KEY (review_analysis_id) REFERENCES public.ai_review_analysis(id);
ALTER TABLE ONLY public.ai_review_hashtags ADD CONSTRAINT fk_ai_review_hashtags_style FOREIGN KEY (review_style_id) REFERENCES public.ai_review_styles(id);
ALTER TABLE ONLY public.ai_review_styles ADD CONSTRAINT fk_ai_review_styles_analysis FOREIGN KEY (review_analysis_id) REFERENCES public.ai_review_analysis(id);
ALTER TABLE ONLY public.review_hashtag_groups ADD CONSTRAINT fk_review_hashtag_groups_post FOREIGN KEY (review_post_id) REFERENCES public.review_posts(id);
ALTER TABLE ONLY public.review_hashtags ADD CONSTRAINT fk_review_hashtags_group FOREIGN KEY (group_id) REFERENCES public.review_hashtag_groups(id);
ALTER TABLE ONLY public.review_photo_groups ADD CONSTRAINT fk_review_photo_groups_post FOREIGN KEY (review_post_id) REFERENCES public.review_posts(id);
ALTER TABLE ONLY public.review_photos ADD CONSTRAINT fk_review_photos_group FOREIGN KEY (group_id) REFERENCES public.review_photo_groups(id);
ALTER TABLE ONLY public.review_posts ADD CONSTRAINT fk_review_posts_plan FOREIGN KEY (plan_id) REFERENCES public.plans(id);
ALTER TABLE ONLY public.review_posts ADD CONSTRAINT fk_review_posts_style FOREIGN KEY (review_style_id) REFERENCES public.ai_review_styles(id);


-- =========================================
-- 9. TRIGGERS (Re-enable FK checks and create triggers)
-- =========================================

-- FK 체크를 다시 활성화합니다.
SET session_replication_role = DEFAULT;

-- Name: travel_places trigger_update_timestamp; Type: TRIGGER
CREATE TRIGGER trigger_update_timestamp BEFORE UPDATE ON public.travel_places FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();

-- PostgreSQL database dump complete