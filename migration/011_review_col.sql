ALTER TABLE ai_review_analysis DROP COLUMN prompt_text;
ALTER TABLE ai_review_styles DROP COLUMN embedding;
ALTER TABLE ai_review_styles DROP COLUMN is_trendy;

ALTER TABLE ai_review_styles RENAME COLUMN description to caption;
ALTER TABLE ai_review_posts RENAME COLUMN content to caption;