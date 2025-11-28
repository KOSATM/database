ALTER TABLE image_search_candidates
RENAME COLUMN image_search_place_id TO image_search_session_id;

ALTER TABLE image_search_candidates
RENAME COLUMN place_id TO image_place_id;