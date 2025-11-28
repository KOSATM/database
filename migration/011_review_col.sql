ALTER TABLE ai_review_analysis DROP COLUMN prompt_text;
ALTER TABLE ai_review_styles DROP COLUMN embedding;
ALTER TABLE ai_review_styles DROP COLUMN is_trendy;

ALTER TABLE ai_review_styles RENAME COLUMN description to caption;
ALTER TABLE review_posts RENAME COLUMN content to caption;
ALTER TABLE ai_review_hashtags DROP CONSTRAINT fk_ai_review_hashtags_analysis;
ALTER TABLE ai_review_hashtags DROP COLUMN review_analysis_id;