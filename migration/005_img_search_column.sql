ALTER TABLE places RENAME COLUMN description TO content;
ALTER TABLE places ADD COLUMN external_image_url TEXT;
ALTER TABLE places RENAME COLUMN image_url TO internal_original_url;
ALTER TABLE places RENAME COLUMN thumbnail_url TO internal_thumbnail_url;

-- 1) enum 타입 생성
CREATE TYPE image_status_enum AS ENUM ('PENDING', 'READY', 'FAILED');

-- 2) enum 컬럼 추가
ALTER TABLE places ADD COLUMN image_status image_status_enum;

COMMIT;