
DROP TABLE IF EXISTS public.hotels;

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
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.hotels
    OWNER to postgres;
-- Index: idx_hotels_country_city

DROP INDEX IF EXISTS public.idx_hotels_country_city;

CREATE INDEX IF NOT EXISTS idx_hotels_country_city
    ON public.hotels USING btree
    (country_code COLLATE pg_catalog."default" ASC NULLS LAST, city COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: idx_hotels_is_active_city

DROP INDEX IF EXISTS public.idx_hotels_is_active_city;

CREATE INDEX IF NOT EXISTS idx_hotels_is_active_city
    ON public.hotels USING btree
    (is_active ASC NULLS LAST, city COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;

DROP TABLE IF EXISTS public.hotel_rooms;

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

DROP INDEX IF EXISTS public.idx_hotel_rooms_hotel_id;

CREATE INDEX IF NOT EXISTS idx_hotel_rooms_hotel_id
    ON public.hotel_rooms USING btree
    (hotel_id ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;

DROP TABLE IF EXISTS public.hotel_rate_plans;

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

DROP INDEX IF EXISTS public.idx_rate_plans_hotel_id;

CREATE INDEX IF NOT EXISTS idx_rate_plans_hotel_id
    ON public.hotel_rate_plans USING btree
    (hotel_id ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: idx_rate_plans_room_type_id

DROP INDEX IF EXISTS public.idx_rate_plans_room_type_id;

CREATE INDEX IF NOT EXISTS idx_rate_plans_room_type_id
    ON public.hotel_rate_plans USING btree
    (room_type_id ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;

DROP TABLE IF EXISTS public.hotel_rate_plan_prices;

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

DROP INDEX IF EXISTS public.idx_rate_plan_prices_plan_id;

CREATE INDEX IF NOT EXISTS idx_rate_plan_prices_plan_id
    ON public.hotel_rate_plan_prices USING btree
    (rate_plan_id ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;