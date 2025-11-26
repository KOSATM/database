-- ai_review_styles: Style package 확장 + 임베딩 추가

ALTER TABLE ai_review_styles
    ADD COLUMN tone_code VARCHAR(50);

ALTER TABLE ai_review_styles
    ADD COLUMN is_trendy BOOLEAN DEFAULT FALSE;

ALTER TABLE ai_review_styles
    ADD COLUMN description TEXT;

ALTER TABLE ai_review_styles
    ADD COLUMN embedding VECTOR(1536);

-- ai_review_hashtags: review_style_id 추가, FK 연결

ALTER TABLE ai_review_hashtags
    ADD COLUMN review_style_id BIGINT;

ALTER TABLE ai_review_hashtags
    ADD CONSTRAINT fk_ai_review_hashtags_review_style
        FOREIGN KEY (review_style_id) REFERENCES ai_review_styles(id);

-- ai_review_styles ↔ ai_review_analysis 관계 FK
ALTER TABLE ai_review_styles
    ADD CONSTRAINT fk_ai_review_styles_analysis
        FOREIGN KEY (review_analysis_id) REFERENCES ai_review_analysis(id);

commit;