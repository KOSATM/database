--
-- PostgreSQL database dump
--

\restrict SNFtHZNHufN6cbQ5MK3949aXr6dUOzCzTgder4YKE3da0AgzbMQ8Alcf7y7rClN

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg12+1)
-- Dumped by pg_dump version 17.7 (Debian 17.7-3.pgdg12+1)

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: checklist_category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.checklist_category AS ENUM (
    'PACKING',
    'CLOTHES',
    'DOCUMENT',
    'ETC'
);


ALTER TYPE public.checklist_category OWNER TO postgres;

--
-- Name: image_action_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.image_action_type AS ENUM (
    'SAVE_ONLY',
    'EDIT_ITINERARY',
    'REPLACE'
);


ALTER TYPE public.image_action_type OWNER TO postgres;

--
-- Name: image_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.image_status_enum AS ENUM (
    'PENDING',
    'READY',
    'FAILED'
);


ALTER TYPE public.image_status_enum OWNER TO postgres;

--
-- Name: update_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_timestamp() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ai_review_analysis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ai_review_analysis (
    id bigint NOT NULL,
    prompt_text text NOT NULL,
    input_json jsonb NOT NULL,
    output_json jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_id bigint NOT NULL,
    review_post_id bigint NOT NULL
);


ALTER TABLE public.ai_review_analysis OWNER TO postgres;

--
-- Name: ai_review_analysis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ai_review_analysis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ai_review_analysis_id_seq OWNER TO postgres;

--
-- Name: ai_review_analysis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ai_review_analysis_id_seq OWNED BY public.ai_review_analysis.id;


--
-- Name: ai_review_hashtags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ai_review_hashtags (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    review_analysis_id bigint NOT NULL,
    review_style_id bigint
);


ALTER TABLE public.ai_review_hashtags OWNER TO postgres;

--
-- Name: ai_review_hashtags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ai_review_hashtags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ai_review_hashtags_id_seq OWNER TO postgres;

--
-- Name: ai_review_hashtags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ai_review_hashtags_id_seq OWNED BY public.ai_review_hashtags.id;


--
-- Name: ai_review_styles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ai_review_styles (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    review_analysis_id bigint NOT NULL,
    tone_code character varying(50),
    is_trendy boolean DEFAULT false,
    description text,
    embedding public.vector(1536)
);


ALTER TABLE public.ai_review_styles OWNER TO postgres;

--
-- Name: ai_review_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ai_review_styles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ai_review_styles_id_seq OWNER TO postgres;

--
-- Name: ai_review_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ai_review_styles_id_seq OWNED BY public.ai_review_styles.id;


--
-- Name: chat_memories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_memories (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    agent_name character varying(50) NOT NULL,
    order_index integer NOT NULL,
    content text NOT NULL,
    token_usage bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    role character varying(10) NOT NULL
);


ALTER TABLE public.chat_memories OWNER TO postgres;

--
-- Name: chat_memories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_memories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chat_memories_id_seq OWNER TO postgres;

--
-- Name: chat_memories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_memories_id_seq OWNED BY public.chat_memories.id;


--
-- Name: chat_memory_vectors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_memory_vectors (
    id bigint NOT NULL,
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

--
-- Name: chat_memory_vectors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_memory_vectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chat_memory_vectors_id_seq OWNER TO postgres;

--
-- Name: chat_memory_vectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_memory_vectors_id_seq OWNED BY public.chat_memory_vectors.id;


--
-- Name: checklist_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.checklist_items (
    id bigint NOT NULL,
    checklist_id bigint NOT NULL,
    content text NOT NULL,
    category public.checklist_category NOT NULL,
    is_checked boolean NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.checklist_items OWNER TO postgres;

--
-- Name: checklist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.checklist_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.checklist_items_id_seq OWNER TO postgres;

--
-- Name: checklist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.checklist_items_id_seq OWNED BY public.checklist_items.id;


--
-- Name: checklists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.checklists (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    day_index smallint,
    created_at timestamp with time zone
);


ALTER TABLE public.checklists OWNER TO postgres;

--
-- Name: checklists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.checklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.checklists_id_seq OWNER TO postgres;

--
-- Name: checklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.checklists_id_seq OWNED BY public.checklists.id;


--
-- Name: current_activities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.current_activities (
    id bigint NOT NULL,
    travel_place_id bigint NOT NULL,
    actual_cost numeric(19,2),
    memo text,
    ended_at timestamp with time zone
);


ALTER TABLE public.current_activities OWNER TO postgres;

--
-- Name: current_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.current_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.current_activities_id_seq OWNER TO postgres;

--
-- Name: current_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.current_activities_id_seq OWNED BY public.current_activities.id;


--
-- Name: hotel_bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_bookings (
    id bigint NOT NULL,
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

--
-- Name: hotel_bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotel_bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hotel_bookings_id_seq OWNER TO postgres;

--
-- Name: hotel_bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotel_bookings_id_seq OWNED BY public.hotel_bookings.id;


--
-- Name: hotel_rate_plan_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_rate_plan_prices (
    id bigint NOT NULL,
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

--
-- Name: hotel_rate_plan_prices_rate_plan_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.hotel_rate_plan_prices ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.hotel_rate_plan_prices_rate_plan_price_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hotel_rate_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_rate_plans (
    id bigint NOT NULL,
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

--
-- Name: hotel_rate_plans_rate_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.hotel_rate_plans ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.hotel_rate_plans_rate_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hotel_rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_rooms (
    id bigint NOT NULL,
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

--
-- Name: hotel_rooms_room_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.hotel_rooms ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.hotel_rooms_room_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hotels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotels (
    id bigint NOT NULL,
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
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_hotels_rating_score CHECK (((rating_score IS NULL) OR ((rating_score >= (0)::numeric) AND (rating_score <= (10)::numeric)))),
    CONSTRAINT chk_hotels_star_rating CHECK (((star_rating IS NULL) OR ((star_rating >= (0)::numeric) AND (star_rating <= (5)::numeric))))
);


ALTER TABLE public.hotels OWNER TO postgres;

--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.hotels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.hotels_hotel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: image_places; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_places (
    id bigint NOT NULL,
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

--
-- Name: image_search_candidates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_search_candidates (
    id bigint NOT NULL,
    image_search_place_id bigint NOT NULL,
    place_id bigint NOT NULL,
    is_selected boolean DEFAULT false NOT NULL,
    rank bigint NOT NULL
);


ALTER TABLE public.image_search_candidates OWNER TO postgres;

--
-- Name: image_search_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_search_sessions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    action_type public.image_action_type NOT NULL
);


ALTER TABLE public.image_search_sessions OWNER TO postgres;

--
-- Name: image_search_places_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_search_places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_search_places_id_seq OWNER TO postgres;

--
-- Name: image_search_places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_search_places_id_seq OWNED BY public.image_search_sessions.id;


--
-- Name: image_search_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_search_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_search_results_id_seq OWNER TO postgres;

--
-- Name: image_search_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_search_results_id_seq OWNED BY public.image_search_candidates.id;


--
-- Name: payment_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_transactions (
    id bigint NOT NULL,
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

--
-- Name: payment_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_transactions_id_seq OWNER TO postgres;

--
-- Name: payment_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_transactions_id_seq OWNED BY public.payment_transactions.id;


--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.places_id_seq OWNER TO postgres;

--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.places_id_seq OWNED BY public.image_places.id;


--
-- Name: plan_days; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plan_days (
    id bigint NOT NULL,
    travel_plan_id bigint,
    day_index smallint,
    title character varying(50),
    plan_date date
);


ALTER TABLE public.plan_days OWNER TO postgres;

--
-- Name: plan_places; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plan_places (
    id bigint NOT NULL,
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

--
-- Name: plan_snapshots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plan_snapshots (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    version_no integer NOT NULL,
    snapshot_json json NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.plan_snapshots OWNER TO postgres;

--
-- Name: plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plans (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    budget numeric(19,2) NOT NULL,
    start_date date,
    end_date date,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    is_ended boolean
);


ALTER TABLE public.plans OWNER TO postgres;

--
-- Name: review_hashtag_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_hashtag_groups (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    review_post_id bigint NOT NULL
);


ALTER TABLE public.review_hashtag_groups OWNER TO postgres;

--
-- Name: review_hashtag_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_hashtag_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_hashtag_groups_id_seq OWNER TO postgres;

--
-- Name: review_hashtag_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_hashtag_groups_id_seq OWNED BY public.review_hashtag_groups.id;


--
-- Name: review_hashtags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_hashtags (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.review_hashtags OWNER TO postgres;

--
-- Name: review_hashtags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_hashtags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_hashtags_id_seq OWNER TO postgres;

--
-- Name: review_hashtags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_hashtags_id_seq OWNED BY public.review_hashtags.id;


--
-- Name: review_photo_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_photo_groups (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    review_post_id bigint NOT NULL
);


ALTER TABLE public.review_photo_groups OWNER TO postgres;

--
-- Name: review_photo_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_photo_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_photo_groups_id_seq OWNER TO postgres;

--
-- Name: review_photo_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_photo_groups_id_seq OWNED BY public.review_photo_groups.id;


--
-- Name: review_photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_photos (
    id bigint NOT NULL,
    file_url text NOT NULL,
    order_index integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.review_photos OWNER TO postgres;

--
-- Name: review_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_photos_id_seq OWNER TO postgres;

--
-- Name: review_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_photos_id_seq OWNED BY public.review_photos.id;


--
-- Name: review_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_posts (
    id bigint NOT NULL,
    content text,
    is_posted boolean DEFAULT false NOT NULL,
    review_post_url text,
    created_at timestamp with time zone NOT NULL,
    travel_plan_id bigint NOT NULL,
    review_style_id bigint
);


ALTER TABLE public.review_posts OWNER TO postgres;

--
-- Name: review_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_posts_id_seq OWNER TO postgres;

--
-- Name: review_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_posts_id_seq OWNED BY public.review_posts.id;


--
-- Name: sns_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sns_tokens (
    id bigint NOT NULL,
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

--
-- Name: sns_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sns_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sns_tokens_id_seq OWNER TO postgres;

--
-- Name: sns_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sns_tokens_id_seq OWNED BY public.sns_tokens.id;


--
-- Name: toilets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toilets (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    lat numeric(10,7) NOT NULL,
    lng numeric(10,7) NOT NULL,
    address character varying(500) NOT NULL
);


ALTER TABLE public.toilets OWNER TO postgres;

--
-- Name: toilets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.toilets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.toilets_id_seq OWNER TO postgres;

--
-- Name: toilets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.toilets_id_seq OWNED BY public.toilets.id;


--
-- Name: travel_days_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.travel_days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.travel_days_id_seq OWNER TO postgres;

--
-- Name: travel_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.travel_days_id_seq OWNED BY public.plan_days.id;


--
-- Name: travel_place_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.travel_place_categories (
    code text NOT NULL,
    name text NOT NULL,
    parent_code text,
    level integer NOT NULL,
    category_type text
);


ALTER TABLE public.travel_place_categories OWNER TO postgres;

--
-- Name: travel_places; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.travel_places (
    id bigint NOT NULL,
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

--
-- Name: travel_places_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.travel_places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.travel_places_id_seq OWNER TO postgres;

--
-- Name: travel_places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.travel_places_id_seq OWNED BY public.plan_places.id;


--
-- Name: travel_places_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.travel_places_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.travel_places_id_seq1 OWNER TO postgres;

--
-- Name: travel_places_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.travel_places_id_seq1 OWNED BY public.travel_places.id;


--
-- Name: travel_plan_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.travel_plan_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.travel_plan_snapshots_id_seq OWNER TO postgres;

--
-- Name: travel_plan_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.travel_plan_snapshots_id_seq OWNED BY public.plan_snapshots.id;


--
-- Name: travel_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.travel_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.travel_plans_id_seq OWNER TO postgres;

--
-- Name: travel_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.travel_plans_id_seq OWNED BY public.plans.id;


--
-- Name: user_identities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_identities (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    provider character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_identities OWNER TO postgres;

--
-- Name: user_identities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_identities_id_seq OWNER TO postgres;

--
-- Name: user_identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_identities_id_seq OWNED BY public.user_identities.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    is_active boolean,
    last_login_at timestamp with time zone,
    name character varying(50),
    email character varying(1000),
    profile_image_url character varying(1000),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: ai_review_analysis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_analysis ALTER COLUMN id SET DEFAULT nextval('public.ai_review_analysis_id_seq'::regclass);


--
-- Name: ai_review_hashtags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_hashtags ALTER COLUMN id SET DEFAULT nextval('public.ai_review_hashtags_id_seq'::regclass);


--
-- Name: ai_review_styles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_styles ALTER COLUMN id SET DEFAULT nextval('public.ai_review_styles_id_seq'::regclass);


--
-- Name: chat_memories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_memories ALTER COLUMN id SET DEFAULT nextval('public.chat_memories_id_seq'::regclass);


--
-- Name: chat_memory_vectors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_memory_vectors ALTER COLUMN id SET DEFAULT nextval('public.chat_memory_vectors_id_seq'::regclass);


--
-- Name: checklist_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checklist_items ALTER COLUMN id SET DEFAULT nextval('public.checklist_items_id_seq'::regclass);


--
-- Name: checklists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checklists ALTER COLUMN id SET DEFAULT nextval('public.checklists_id_seq'::regclass);


--
-- Name: current_activities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_activities ALTER COLUMN id SET DEFAULT nextval('public.current_activities_id_seq'::regclass);


--
-- Name: hotel_bookings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_bookings ALTER COLUMN id SET DEFAULT nextval('public.hotel_bookings_id_seq'::regclass);


--
-- Name: image_places id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_places ALTER COLUMN id SET DEFAULT nextval('public.places_id_seq'::regclass);


--
-- Name: image_search_candidates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_search_candidates ALTER COLUMN id SET DEFAULT nextval('public.image_search_results_id_seq'::regclass);


--
-- Name: image_search_sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_search_sessions ALTER COLUMN id SET DEFAULT nextval('public.image_search_places_id_seq'::regclass);


--
-- Name: payment_transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions ALTER COLUMN id SET DEFAULT nextval('public.payment_transactions_id_seq'::regclass);


--
-- Name: plan_days id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_days ALTER COLUMN id SET DEFAULT nextval('public.travel_days_id_seq'::regclass);


--
-- Name: plan_places id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_places ALTER COLUMN id SET DEFAULT nextval('public.travel_places_id_seq'::regclass);


--
-- Name: plan_snapshots id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_snapshots ALTER COLUMN id SET DEFAULT nextval('public.travel_plan_snapshots_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.travel_plans_id_seq'::regclass);


--
-- Name: review_hashtag_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_hashtag_groups ALTER COLUMN id SET DEFAULT nextval('public.review_hashtag_groups_id_seq'::regclass);


--
-- Name: review_hashtags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_hashtags ALTER COLUMN id SET DEFAULT nextval('public.review_hashtags_id_seq'::regclass);


--
-- Name: review_photo_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_photo_groups ALTER COLUMN id SET DEFAULT nextval('public.review_photo_groups_id_seq'::regclass);


--
-- Name: review_photos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_photos ALTER COLUMN id SET DEFAULT nextval('public.review_photos_id_seq'::regclass);


--
-- Name: review_posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_posts ALTER COLUMN id SET DEFAULT nextval('public.review_posts_id_seq'::regclass);


--
-- Name: sns_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sns_tokens ALTER COLUMN id SET DEFAULT nextval('public.sns_tokens_id_seq'::regclass);


--
-- Name: toilets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toilets ALTER COLUMN id SET DEFAULT nextval('public.toilets_id_seq'::regclass);


--
-- Name: travel_places id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_places ALTER COLUMN id SET DEFAULT nextval('public.travel_places_id_seq1'::regclass);


--
-- Name: user_identities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_identities ALTER COLUMN id SET DEFAULT nextval('public.user_identities_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ai_review_analysis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ai_review_analysis (id, prompt_text, input_json, output_json, created_at, user_id, review_post_id) FROM stdin;
\.


--
-- Data for Name: ai_review_hashtags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ai_review_hashtags (id, name, created_at, review_analysis_id, review_style_id) FROM stdin;
\.


--
-- Data for Name: ai_review_styles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ai_review_styles (id, name, created_at, review_analysis_id, tone_code, is_trendy, description, embedding) FROM stdin;
\.


--
-- Data for Name: chat_memories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_memories (id, user_id, agent_name, order_index, content, token_usage, created_at, role) FROM stdin;
\.


--
-- Data for Name: chat_memory_vectors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_memory_vectors (id, user_id, agent_name, order_index, content, token_usage, created_at, role, embedding) FROM stdin;
\.


--
-- Data for Name: checklist_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.checklist_items (id, checklist_id, content, category, is_checked, created_at) FROM stdin;
\.


--
-- Data for Name: checklists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.checklists (id, user_id, day_index, created_at) FROM stdin;
\.


--
-- Data for Name: current_activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.current_activities (id, travel_place_id, actual_cost, memo, ended_at) FROM stdin;
\.


--
-- Data for Name: hotel_bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotel_bookings (id, user_id, external_booking_id, hotel_id, room_type_id, rate_plan_id, checkin_date, checkout_date, nights, adults_count, children_count, currency, total_price, tax_amount, fee_amount, status, payment_status, guest_name, guest_email, guest_phone, provider_booking_meta, booked_at, cancelled_at, created_at, updated_at) FROM stdin;
\.


---
-- Data for Name: travel_places; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.travel_places (id, content_id, title, address, tel, first_image, first_image2, lat, lng, category_code, description, tags, embedding, created_at, updated_at, detail_info) FROM stdin;
\.



--
-- Name: ai_review_analysis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ai_review_analysis_id_seq', 1, false);


--
-- Name: ai_review_hashtags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ai_review_hashtags_id_seq', 1, false);


--
-- Name: ai_review_styles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ai_review_styles_id_seq', 1, false);


--
-- Name: chat_memories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_memories_id_seq', 1, false);


--
-- Name: chat_memory_vectors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_memory_vectors_id_seq', 1, false);


--
-- Name: checklist_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.checklist_items_id_seq', 1, false);


--
-- Name: checklists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.checklists_id_seq', 1, false);


--
-- Name: current_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.current_activities_id_seq', 1, false);


--
-- Name: hotel_bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotel_bookings_id_seq', 5, true);


--
-- Name: hotel_rate_plan_prices_rate_plan_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotel_rate_plan_prices_rate_plan_price_id_seq', 282, true);


--
-- Name: hotel_rate_plans_rate_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotel_rate_plans_rate_plan_id_seq', 40, true);


--
-- Name: hotel_rooms_room_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotel_rooms_room_type_id_seq', 40, true);


--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotels_hotel_id_seq', 20, true);


--
-- Name: image_search_places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.image_search_places_id_seq', 1, false);


--
-- Name: image_search_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.image_search_results_id_seq', 1, false);


--
-- Name: payment_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_transactions_id_seq', 1, false);


--
-- Name: places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.places_id_seq', 50, true);


--
-- Name: review_hashtag_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_hashtag_groups_id_seq', 1, false);


--
-- Name: review_hashtags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_hashtags_id_seq', 1, false);


--
-- Name: review_photo_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_photo_groups_id_seq', 16, true);


--
-- Name: review_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_photos_id_seq', 29, true);


--
-- Name: review_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_posts_id_seq', 15, true);


--
-- Name: sns_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sns_tokens_id_seq', 1, false);


--
-- Name: toilets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.toilets_id_seq', 4376, true);


--
-- Name: travel_days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.travel_days_id_seq', 132, true);


--
-- Name: travel_places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.travel_places_id_seq', 474, true);


--
-- Name: travel_places_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.travel_places_id_seq1', 1, false);


--
-- Name: travel_plan_snapshots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.travel_plan_snapshots_id_seq', 3, true);


--
-- Name: travel_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.travel_plans_id_seq', 29, true);


--
-- Name: user_identities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_identities_id_seq', 10, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 11, true);


--
-- Name: ai_review_analysis ai_review_analysis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_analysis
    ADD CONSTRAINT ai_review_analysis_pkey PRIMARY KEY (id);


--
-- Name: ai_review_hashtags ai_review_hashtags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_hashtags
    ADD CONSTRAINT ai_review_hashtags_pkey PRIMARY KEY (id);


--
-- Name: ai_review_styles ai_review_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_styles
    ADD CONSTRAINT ai_review_styles_pkey PRIMARY KEY (id);


--
-- Name: chat_memories chat_memories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_memories
    ADD CONSTRAINT chat_memories_pkey PRIMARY KEY (id);


--
-- Name: chat_memory_vectors chat_memory_vectors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_memory_vectors
    ADD CONSTRAINT chat_memory_vectors_pkey PRIMARY KEY (id);


--
-- Name: checklist_items checklist_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checklist_items
    ADD CONSTRAINT checklist_items_pkey PRIMARY KEY (id);


--
-- Name: checklists checklists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checklists
    ADD CONSTRAINT checklists_pkey PRIMARY KEY (id);


--
-- Name: current_activities current_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_activities
    ADD CONSTRAINT current_activities_pkey PRIMARY KEY (id);


--
-- Name: hotel_bookings hotel_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_bookings
    ADD CONSTRAINT hotel_bookings_pkey PRIMARY KEY (id);


--
-- Name: hotel_rate_plan_prices hotel_rate_plan_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_rate_plan_prices
    ADD CONSTRAINT hotel_rate_plan_prices_pkey PRIMARY KEY (id);


--
-- Name: hotel_rate_plans hotel_rate_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_rate_plans
    ADD CONSTRAINT hotel_rate_plans_pkey PRIMARY KEY (id);


--
-- Name: hotel_rooms hotel_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_rooms
    ADD CONSTRAINT hotel_rooms_pkey PRIMARY KEY (id);


--
-- Name: hotels hotels_external_hotel_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_external_hotel_id_key UNIQUE (external_hotel_id);


--
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (id);


--
-- Name: image_search_sessions image_search_places_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_search_sessions
    ADD CONSTRAINT image_search_places_pkey PRIMARY KEY (id);


--
-- Name: image_search_candidates image_search_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_search_candidates
    ADD CONSTRAINT image_search_results_pkey PRIMARY KEY (id);


--
-- Name: payment_transactions payment_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_pkey PRIMARY KEY (id);


--
-- Name: image_places places_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: review_hashtag_groups review_hashtag_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_hashtag_groups
    ADD CONSTRAINT review_hashtag_groups_pkey PRIMARY KEY (id);


--
-- Name: review_hashtags review_hashtags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_hashtags
    ADD CONSTRAINT review_hashtags_pkey PRIMARY KEY (id);


--
-- Name: review_photo_groups review_photo_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_photo_groups
    ADD CONSTRAINT review_photo_groups_pkey PRIMARY KEY (id);


--
-- Name: review_photos review_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_photos
    ADD CONSTRAINT review_photos_pkey PRIMARY KEY (id);


--
-- Name: review_posts review_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_posts
    ADD CONSTRAINT review_posts_pkey PRIMARY KEY (id);


--
-- Name: sns_tokens sns_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sns_tokens
    ADD CONSTRAINT sns_tokens_pkey PRIMARY KEY (id);


--
-- Name: toilets toilets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toilets
    ADD CONSTRAINT toilets_pkey PRIMARY KEY (id);


--
-- Name: plan_days travel_days_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_days
    ADD CONSTRAINT travel_days_pkey PRIMARY KEY (id);


--
-- Name: travel_place_categories travel_place_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_place_categories
    ADD CONSTRAINT travel_place_categories_pkey PRIMARY KEY (code);


--
-- Name: travel_places travel_places_content_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_places
    ADD CONSTRAINT travel_places_content_id_key UNIQUE (content_id);


--
-- Name: plan_places travel_places_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_places
    ADD CONSTRAINT travel_places_pkey PRIMARY KEY (id);


--
-- Name: travel_places travel_places_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_places
    ADD CONSTRAINT travel_places_pkey1 PRIMARY KEY (id);


--
-- Name: plan_snapshots travel_plan_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_snapshots
    ADD CONSTRAINT travel_plan_snapshots_pkey PRIMARY KEY (id);


--
-- Name: plans travel_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT travel_plans_pkey PRIMARY KEY (id);


--
-- Name: hotel_rate_plan_prices uq_rate_plan_prices_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_rate_plan_prices
    ADD CONSTRAINT uq_rate_plan_prices_unique UNIQUE (rate_plan_id, stay_date);


--
-- Name: hotel_rate_plans uq_rate_plans_external; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_rate_plans
    ADD CONSTRAINT uq_rate_plans_external UNIQUE (hotel_id, external_rate_plan_id);


--
-- Name: hotel_rooms uq_rooms_external; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_rooms
    ADD CONSTRAINT uq_rooms_external UNIQUE (hotel_id, external_room_type_id);


--
-- Name: user_identities user_identities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_identities
    ADD CONSTRAINT user_identities_pkey PRIMARY KEY (id);


--
-- Name: user_identities user_identities_user_id_provider_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_identities
    ADD CONSTRAINT user_identities_user_id_provider_key UNIQUE (user_id, provider);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_hotel_rooms_hotel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotel_rooms_hotel_id ON public.hotel_rooms USING btree (hotel_id);


--
-- Name: idx_hotels_country_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_country_city ON public.hotels USING btree (country_code, city);


--
-- Name: idx_hotels_is_active_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_is_active_city ON public.hotels USING btree (is_active, city);


--
-- Name: idx_rate_plan_prices_plan_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rate_plan_prices_plan_id ON public.hotel_rate_plan_prices USING btree (rate_plan_id);


--
-- Name: idx_rate_plans_hotel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rate_plans_hotel_id ON public.hotel_rate_plans USING btree (hotel_id);


--
-- Name: idx_rate_plans_room_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rate_plans_room_type_id ON public.hotel_rate_plans USING btree (room_type_id);


--
-- Name: travel_places trigger_update_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_timestamp BEFORE UPDATE ON public.travel_places FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: ai_review_analysis fk_ai_review_analysis_post; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_analysis
    ADD CONSTRAINT fk_ai_review_analysis_post FOREIGN KEY (review_post_id) REFERENCES public.review_posts(id);


--
-- Name: ai_review_analysis fk_ai_review_analysis_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_analysis
    ADD CONSTRAINT fk_ai_review_analysis_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: ai_review_hashtags fk_ai_review_hashtags_analysis; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_hashtags
    ADD CONSTRAINT fk_ai_review_hashtags_analysis FOREIGN KEY (review_analysis_id) REFERENCES public.ai_review_analysis(id);


--
-- Name: ai_review_hashtags fk_ai_review_hashtags_style; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_hashtags
    ADD CONSTRAINT fk_ai_review_hashtags_style FOREIGN KEY (review_style_id) REFERENCES public.ai_review_styles(id);


--
-- Name: ai_review_styles fk_ai_review_styles_analysis; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_review_styles
    ADD CONSTRAINT fk_ai_review_styles_analysis FOREIGN KEY (review_analysis_id) REFERENCES public.ai_review_analysis(id);


--
-- Name: chat_memories fk_chat_memories_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_memories
    ADD CONSTRAINT fk_chat_memories_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: chat_memory_vectors fk_chat_memory_vectors_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_memory_vectors
    ADD CONSTRAINT fk_chat_memory_vectors_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: checklist_items fk_checklist_items_checklist; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checklist_items
    ADD CONSTRAINT fk_checklist_items_checklist FOREIGN KEY (checklist_id) REFERENCES public.checklists(id);


--
-- Name: checklists fk_checklists_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checklists
    ADD CONSTRAINT fk_checklists_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: current_activities fk_current_activities_place; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_activities
    ADD CONSTRAINT fk_current_activities_place FOREIGN KEY (travel_place_id) REFERENCES public.plan_places(id);


--
-- Name: hotel_bookings fk_hotel_bookings_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_bookings
    ADD CONSTRAINT fk_hotel_bookings_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: image_search_sessions fk_image_search_places_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_search_sessions
    ADD CONSTRAINT fk_image_search_places_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: image_search_candidates fk_image_search_results_place; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_search_candidates
    ADD CONSTRAINT fk_image_search_results_place FOREIGN KEY (place_id) REFERENCES public.image_places(id);


--
-- Name: image_search_candidates fk_image_search_results_search_place; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_search_candidates
    ADD CONSTRAINT fk_image_search_results_search_place FOREIGN KEY (image_search_place_id) REFERENCES public.image_search_sessions(id);


--
-- Name: payment_transactions fk_payment_transactions_booking; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT fk_payment_transactions_booking FOREIGN KEY (hotel_booking_id) REFERENCES public.hotel_bookings(id);


--
-- Name: hotel_rate_plan_prices fk_rate_plan_prices_plan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_rate_plan_prices
    ADD CONSTRAINT fk_rate_plan_prices_plan FOREIGN KEY (rate_plan_id) REFERENCES public.hotel_rate_plans(id) ON DELETE CASCADE;


--
-- Name: review_hashtag_groups fk_review_hashtag_groups_post; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_hashtag_groups
    ADD CONSTRAINT fk_review_hashtag_groups_post FOREIGN KEY (review_post_id) REFERENCES public.review_posts(id);


--
-- Name: review_hashtags fk_review_hashtags_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_hashtags
    ADD CONSTRAINT fk_review_hashtags_group FOREIGN KEY (group_id) REFERENCES public.review_hashtag_groups(id);


--
-- Name: review_photo_groups fk_review_photo_groups_post; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_photo_groups
    ADD CONSTRAINT fk_review_photo_groups_post FOREIGN KEY (review_post_id) REFERENCES public.review_posts(id);


--
-- Name: review_photos fk_review_photos_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_photos
    ADD CONSTRAINT fk_review_photos_group FOREIGN KEY (group_id) REFERENCES public.review_photo_groups(id);


--
-- Name: review_posts fk_review_posts_plan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_posts
    ADD CONSTRAINT fk_review_posts_plan FOREIGN KEY (travel_plan_id) REFERENCES public.plans(id);


--
-- Name: review_posts fk_review_posts_style; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_posts
    ADD CONSTRAINT fk_review_posts_style FOREIGN KEY (review_style_id) REFERENCES public.ai_review_styles(id);


--
-- Name: hotel_rooms fk_rooms_hotel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_rooms
    ADD CONSTRAINT fk_rooms_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(id) ON DELETE CASCADE;


--
-- Name: sns_tokens fk_sns_tokens_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sns_tokens
    ADD CONSTRAINT fk_sns_tokens_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: plan_days fk_travel_days_plan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_days
    ADD CONSTRAINT fk_travel_days_plan FOREIGN KEY (travel_plan_id) REFERENCES public.plans(id);


--
-- Name: plan_places fk_travel_places_day; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_places
    ADD CONSTRAINT fk_travel_places_day FOREIGN KEY (day_id) REFERENCES public.plan_days(id);


--
-- Name: plan_snapshots fk_travel_plan_snapshots_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_snapshots
    ADD CONSTRAINT fk_travel_plan_snapshots_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: plans fk_travel_plans_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT fk_travel_plans_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_identities fk_user_identities_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_identities
    ADD CONSTRAINT fk_user_identities_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: travel_places travel_places_category_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_places
    ADD CONSTRAINT travel_places_category_code_fkey FOREIGN KEY (category_code) REFERENCES public.travel_place_categories(code);


--
-- PostgreSQL database dump complete
--

\unrestrict SNFtHZNHufN6cbQ5MK3949aXr6dUOzCzTgder4YKE3da0AgzbMQ8Alcf7y7rClN

-- ENUMS
CREATE TYPE checklist_category AS ENUM ('PACKING', 'CLOTHES', 'DOCUMENT', 'ETC');
CREATE TYPE image_action_type AS ENUM ('SAVE_ONLY', 'EDIT_ITINERARY', 'REPLACE');
CREATE TYPE image_status_enum AS ENUM ('PENDING', 'READY', 'FAILED');

-- Trigger Function
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS trigger AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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
    UNIQUE (user_id, provider),
    FOREIGN KEY (user_id) REFERENCES users(id)
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
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE plans (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(100),
    budget NUMERIC(19,2) NOT NULL,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    is_ended BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE plan_days (
    id BIGSERIAL PRIMARY KEY,
    travel_plan_id BIGINT,
    day_index SMALLINT,
    title VARCHAR(50),
    plan_date DATE,
    FOREIGN KEY (travel_plan_id) REFERENCES plans(id)
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
    expected_cost NUMERIC(19,2),
    FOREIGN KEY (day_id) REFERENCES plan_days(id)
);

CREATE TABLE current_activities (
    id BIGSERIAL PRIMARY KEY,
    travel_place_id BIGINT NOT NULL,
    actual_cost NUMERIC(19,2),
    memo TEXT,
    ended_at TIMESTAMPTZ,
    FOREIGN KEY (travel_place_id) REFERENCES plan_places(id)
);

CREATE TABLE plan_snapshots (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    version_no INT NOT NULL,
    snapshot_json JSON NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
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
    UNIQUE (content_id),
    FOREIGN KEY (category_code) REFERENCES travel_place_categories(code)
);

CREATE TRIGGER trigger_update_timestamp
BEFORE UPDATE ON travel_places
FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TABLE review_posts (
    id BIGSERIAL PRIMARY KEY,
    content TEXT,
    is_posted BOOLEAN DEFAULT false NOT NULL,
    review_post_url TEXT,
    created_at TIMESTAMPTZ NOT NULL,
    plan_id BIGINT NOT NULL,
    review_style_id BIGINT,
    photo_group_id BIGINT,
    hashtag_group_id BIGINT,
    FOREIGN KEY (plan_id) REFERENCES plans(id),
    FOREIGN KEY (photo_group_id) REFERENCES photo_groups(id),
    FOREIGN KEY (hashtag_group_id) REFERENCES hashtag_groups(id),
    FOREIGN KEY (review_style_id) REFERENCES ai_review_styles(id)
);

CREATE TABLE review_photo_groups (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL,
    review_post_id BIGINT NOT NULL,
    FOREIGN KEY (review_post_id) REFERENCES review_posts(id)
);

CREATE TABLE review_photos (
    id BIGSERIAL PRIMARY KEY,
    file_url TEXT NOT NULL,
    order_index INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    photo_group_id BIGINT NOT NULL,
    FOREIGN KEY (photo_group_id) REFERENCES review_photo_groups(id)
);

CREATE TABLE review_hashtag_groups (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL,
    review_post_id BIGINT NOT NULL,
    FOREIGN KEY (review_post_id) REFERENCES review_posts(id)
);

CREATE TABLE review_hashtags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    hashtag_group_id BIGINT NOT NULL,
    FOREIGN KEY (hashtag_group_id) REFERENCES review_hashtag_groups(id)
);
CREATE TABLE ai_review_analysis (
    id BIGSERIAL PRIMARY KEY,
    input_json JSONB NOT NULL,
    output_json JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    user_id BIGINT NOT NULL,
    review_post_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (review_post_id) REFERENCES review_posts(id)
);

CREATE TABLE ai_review_styles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    review_analysis_id BIGINT NOT NULL,
    tone_code VARCHAR(50),
    caption TEXT,
    embedding VECTOR(1536),
    FOREIGN KEY (review_analysis_id) REFERENCES ai_review_analysis(id)
);

CREATE TABLE ai_review_hashtags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    review_analysis_id BIGINT NOT NULL,
    review_style_id BIGINT,
    FOREIGN KEY (review_analysis_id) REFERENCES ai_review_analysis(id),
    FOREIGN KEY (review_style_id) REFERENCES ai_review_styles(id)
);
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
    action_type image_action_type NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE image_search_candidates (
    id BIGSERIAL PRIMARY KEY,
    image_search_place_id BIGINT NOT NULL,
    place_id BIGINT NOT NULL,
    is_selected BOOLEAN DEFAULT false NOT NULL,
    rank BIGINT NOT NULL,
    FOREIGN KEY (place_id) REFERENCES image_places(id),
    FOREIGN KEY (image_search_place_id) REFERENCES image_search_sessions(id)
);
CREATE TABLE hotels (
    id BIGSERIAL PRIMARY KEY,
    external_hotel_id VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(200) NOT NULL,
    country_code CHAR(2) NOT NULL,
    city VARCHAR(100),
    district VARCHAR(100),
    neighborhood VARCHAR(100),
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),
    postal_code VARCHAR(20),
    star_rating NUMERIC(2,1),
    rating_score NUMERIC(3,2),
    review_count INT,
    phone VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    CHECK (rating_score IS NULL OR (rating_score >= 0 AND rating_score <= 10)),
    CHECK (star_rating IS NULL OR (star_rating >= 0 AND star_rating <= 5))
);

CREATE TABLE hotel_rooms (
    id BIGSERIAL PRIMARY KEY,
    hotel_id BIGINT NOT NULL,
    external_room_type_id VARCHAR(100) NOT NULL,
    name VARCHAR(200) NOT NULL,
    name_local VARCHAR(200),
    description TEXT,
    max_occupancy INT NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
    UNIQUE (hotel_id, external_room_type_id)
);

CREATE TABLE hotel_rate_plans (
    id BIGSERIAL PRIMARY KEY,
    hotel_id BIGINT NOT NULL,
    room_type_id BIGINT NOT NULL,
    external_rate_plan_id VARCHAR(100) NOT NULL,
    name VARCHAR(200),
    description TEXT,
    currency CHAR(3) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id),
    FOREIGN KEY (room_type_id) REFERENCES hotel_rooms(id),
    UNIQUE (hotel_id, external_rate_plan_id)
);

CREATE TABLE hotel_rate_plan_prices (
    id BIGSERIAL PRIMARY KEY,
    rate_plan_id BIGINT NOT NULL,
    stay_date DATE NOT NULL,
    price NUMERIC(12,2) NOT NULL,
    tax_amount NUMERIC(12,2) DEFAULT 0 NOT NULL,
    fee_amount NUMERIC(12,2) DEFAULT 0 NOT NULL,
    remaining_rooms INT,
    is_closed BOOLEAN DEFAULT false NOT NULL,
    fetched_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    UNIQUE (rate_plan_id, stay_date),
    FOREIGN KEY (rate_plan_id) REFERENCES hotel_rate_plans(id) ON DELETE CASCADE
);

CREATE TABLE hotel_bookings (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    external_booking_id VARCHAR(100),
    hotel_id BIGINT NOT NULL,
    room_type_id BIGINT NOT NULL,
    rate_plan_id BIGINT NOT NULL,
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    nights INT NOT NULL,
    adults_count INT NOT NULL,
    children_count INT NOT NULL,
    currency CHAR(3) NOT NULL,
    total_price NUMERIC(12,2) NOT NULL,
    tax_amount NUMERIC(12,2) NOT NULL,
    fee_amount NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'PENDING' NOT NULL,
    booked_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE payment_transactions (
    id BIGSERIAL PRIMARY KEY,
    hotel_booking_id BIGINT NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    provider_payment_id VARCHAR(100),
    amount NUMERIC(19,2) NOT NULL,
    currency CHAR(3) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    requested_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    raw_response JSONB,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (hotel_booking_id) REFERENCES hotel_bookings(id)
);
CREATE TABLE checklists (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    day_index SMALLINT,
    created_at TIMESTAMPTZ,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE checklist_items (
    id BIGSERIAL PRIMARY KEY,
    checklist_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    category checklist_category NOT NULL,
    is_checked BOOLEAN NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (checklist_id) REFERENCES checklists(id)
);
CREATE TABLE chat_memories (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    agent_name VARCHAR(50) NOT NULL,
    order_index INT NOT NULL,
    content TEXT NOT NULL,
    token_usage BIGINT,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    role VARCHAR(10) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
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
    embedding VECTOR(1536),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
