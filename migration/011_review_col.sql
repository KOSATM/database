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