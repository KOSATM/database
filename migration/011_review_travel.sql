ALTER TABLE ai_review_analysis DROP COLUMN prompt_text;
ALTER TABLE ai_review_styles DROP COLUMN embedding;
ALTER TABLE ai_review_styles DROP COLUMN is_trendy;

ALTER TABLE ai_review_styles RENAME COLUMN description to caption;
ALTER TABLE review_posts RENAME COLUMN content to caption;
ALTER TABLE ai_review_hashtags DROP CONSTRAINT fk_ai_review_hashtags_analysis;
ALTER TABLE ai_review_hashtags DROP COLUMN review_analysis_id;

ALTER TABLE review_posts
ADD COLUMN photo_group_id BIGINT;

ALTER TABLE review_posts
ADD COLUMN hashtag_group_id BIGINT;

ALTER TABLE review_posts
ADD CONSTRAINT fk_review_posts_photo_group
FOREIGN KEY (photo_group_id)
REFERENCES review_photo_groups(id)
ON DELETE SET NULL;

ALTER TABLE review_posts
ADD CONSTRAINT fk_review_posts_hashtag_group
FOREIGN KEY (hashtag_group_id)
REFERENCES review_hashtag_groups(id)
ON DELETE SET NULL;

ALTER TABLE review_photos RENAME COLUMN group_id to photo_group_id;
ALTER TABLE review_hashtags RENAME COLUMN group_id to hashtag_group_id;

-- 카테고리 정규화 칼럼 추가 --
ALTER TABLE travel_places
ADD COLUMN normalized_category TEXT;

-- 카테고리 정규화 Update문 --
UPDATE travel_places tp
SET normalized_category =
    CASE
        /*------------------------- SPOT -------------------------*/
        WHEN c.code LIKE 'A01%' THEN 'SPOT'
        WHEN c.code LIKE 'A0201%' THEN 'SPOT'
        WHEN c.code LIKE 'A0202%' 
             AND c.code NOT LIKE 'A020207%' 
             AND c.code NOT LIKE 'A020208%' 
        THEN 'SPOT'
        WHEN c.code LIKE 'A0203%' THEN 'SPOT'
        WHEN c.code LIKE 'A0204%' THEN 'SPOT'
        WHEN c.code LIKE 'A0205%' THEN 'SPOT'
        WHEN c.code LIKE 'A0206%' THEN 'SPOT'
        WHEN c.code LIKE 'A03%' THEN 'SPOT'

        /*------------------------- EVENT -------------------------*/
        WHEN c.code LIKE 'A0207%' OR c.code LIKE 'A0208%' THEN 'EVENT'

        /*------------------------- FOOD / CAFE -------------------------*/
        WHEN c.code LIKE 'A050209%' THEN 'CAFE'
        WHEN c.code LIKE 'A0502%' THEN 'FOOD'

        /*------------------------- SHOPPING -------------------------*/
        WHEN c.code LIKE 'A04%' THEN 'SHOPPING'

        /*------------------------- STAY -------------------------*/
        WHEN c.code LIKE 'B02%' THEN 'STAY'

        /*------------------------- COURSE -------------------------*/
        WHEN c.code LIKE 'C01%' THEN 'COURSE'

        /*------------------------- ETC -------------------------*/
        ELSE 'ETC'
    END
FROM travel_place_categories c
WHERE tp.category_code = c.code;
