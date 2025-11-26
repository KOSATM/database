ALTER TABLE review_photos DROP COLUMN lat;
ALTER TABLE review_photos DROP COLUMN lng;
ALTER TABLE review_photos DROP COLUMN taken_at;

ALTER TABLE review_posts
ALTER COLUMN content DROP NOT NULL,
ALTER COLUMN review_style_id DROP NOT NULL;
ALTER TABLE review_posts
ALTER COLUMN is_posted SET DEFAULT false;

ALTER TABLE review_hashtags DROP COLUMN is_selected;

commit;