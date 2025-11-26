-- style_id -> review_style_id로 컬럼명 변경, FK 연결\

ALTER TABLE review_posts
    RENAME COLUMN style_id TO review_style_id;

ALTER TABLE review_posts
    ADD CONSTRAINT fk_review_posts_review_style
        FOREIGN KEY (review_style_id) REFERENCES ai_styles(id);

-- ai_styles: Style package 확장 + 임베딩 추가

ALTER TABLE ai_styles
    ADD COLUMN tone_code VARCHAR(50);

ALTER TABLE ai_styles
    ADD COLUMN is_trendy BOOLEAN DEFAULT FALSE;

ALTER TABLE ai_styles
    ADD COLUMN description TEXT;

ALTER TABLE ai_styles
    ADD COLUMN embedding VECTOR(1536);

-- ai_hashtags: review_style_id 추가, FK 연결

ALTER TABLE ai_hashtags
    ADD COLUMN review_style_id BIGINT;

ALTER TABLE ai_hashtags
    ADD CONSTRAINT fk_ai_hashtags_review_style
        FOREIGN KEY (review_style_id) REFERENCES ai_styles(id);

-- ai_review_styles ↔ ai_review_analysis 관계 FK
ALTER TABLE ai_styles
    ADD CONSTRAINT fk_ai_styles_analysis
        FOREIGN KEY (review_analysis_id) REFERENCES ai_review_analysis(id);

-- ai_styles, ai_hashtags 테이블 이름에 review 추가해 더 의미가 명확해지도록 함 
ALTER TABLE ai_styles RENAME TO ai_review_styles;
ALTER TABLE ai_hashtags RENAME TO ai_review_hashtags;
