ALTER TABLE places
RENAME TO image_places;

ALTER TABLE image_search_places
RENAME TO image_search_session;

ALTER TABLE image_search_results
RENAME TO image_search_candidates;