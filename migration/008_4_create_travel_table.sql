CREATE TABLE travel_place_categories (
    code TEXT PRIMARY KEY,          -- 예: A05020100
    name TEXT NOT NULL,          -- 예: "한식"
    parent_code TEXT,               -- 상위 카테고리 코드 (nullable)
    level INT NOT NULL,             -- 1 = 대분류, 2 = 중분류, 3 = 소분류
    category_type TEXT              -- A / B / C (cat1의 그룹)
);

CREATE TABLE travel_places (
    id BIGSERIAL PRIMARY KEY,

    -- 공공데이터 식별자 (중복 방지)
    content_id TEXT UNIQUE NOT NULL,

    -- 기본 정보
    title TEXT NOT NULL,
    address TEXT,
    tel TEXT,
    first_image TEXT,     -- 첫 번째 이미지 URL
    first_image2 TEXT,    -- 두 번째 이미지 URL

    -- 위치 정보
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,

    -- 카테고리 (cat3 기준)
    category_code TEXT NOT NULL REFERENCES travel_place_categories(code),

    -- tour api 개요
    description TEXT,
    tags JSONB,

    -- 벡터 정보
    embedding VECTOR(3072),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
		-- 원문 상세 정보 (엑셀 전체 텍스트 등)
    detail_info TEXT    
);