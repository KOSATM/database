-- =========================================
-- NEW FOREIGN KEY CONSTRAINTS (NORMALIZED NAMING)
-- =========================================

-- Users & Auth
ALTER TABLE user_identities
    ADD CONSTRAINT fk_user_identities_user
    FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE sns_tokens
    ADD CONSTRAINT fk_sns_tokens_user
    FOREIGN KEY (user_id) REFERENCES users(id);


-- Travel Planning
ALTER TABLE travel_plan_snapshots
    ADD CONSTRAINT fk_travel_plan_snapshots_user
    FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE travel_plans
    ADD CONSTRAINT fk_travel_plans_user
    FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE travel_days
    ADD CONSTRAINT fk_travel_days_plan
    FOREIGN KEY (travel_plan_id) REFERENCES travel_plans(id);

ALTER TABLE travel_places
    ADD CONSTRAINT fk_travel_places_day
    FOREIGN KEY (day_id) REFERENCES travel_days(id);

ALTER TABLE current_activities
    ADD CONSTRAINT fk_current_activities_place
    FOREIGN KEY (travel_place_id) REFERENCES travel_places(id);


-- Review & Posts
ALTER TABLE review_posts
    ADD CONSTRAINT fk_review_posts_plan
    FOREIGN KEY (travel_plan_id) REFERENCES travel_plans(id);

ALTER TABLE review_photo_groups
    ADD CONSTRAINT fk_review_photo_groups_post
    FOREIGN KEY (review_post_id) REFERENCES review_posts(id);

ALTER TABLE review_photos
    ADD CONSTRAINT fk_review_photos_group
    FOREIGN KEY (group_id) REFERENCES review_photo_groups(id);

ALTER TABLE review_hashtag_groups
    ADD CONSTRAINT fk_review_hashtag_groups_post
    FOREIGN KEY (review_post_id) REFERENCES review_posts(id);

ALTER TABLE review_hashtags
    ADD CONSTRAINT fk_review_hashtags_group
    FOREIGN KEY (group_id) REFERENCES review_hashtag_groups(id);

ALTER TABLE review_posts
    ADD CONSTRAINT fk_review_posts_style
    FOREIGN KEY (review_style_id) REFERENCES ai_review_styles(id);


-- AI Analysis
ALTER TABLE ai_review_analysis
    ADD CONSTRAINT fk_ai_review_analysis_user
    FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE ai_review_analysis
    ADD CONSTRAINT fk_ai_review_analysis_post
    FOREIGN KEY (review_post_id) REFERENCES review_posts(id);

ALTER TABLE ai_review_styles
    ADD CONSTRAINT fk_ai_review_styles_analysis
    FOREIGN KEY (review_analysis_id) REFERENCES ai_review_analysis(id);

ALTER TABLE ai_review_hashtags
    ADD CONSTRAINT fk_ai_review_hashtags_analysis
    FOREIGN KEY (review_analysis_id) REFERENCES ai_review_analysis(id);

ALTER TABLE ai_review_hashtags
    ADD CONSTRAINT fk_ai_review_hashtags_style
    FOREIGN KEY (review_style_id) REFERENCES ai_review_styles(id);


-- Places & Search
ALTER TABLE image_search_places
    ADD CONSTRAINT fk_image_search_places_user
    FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE image_search_results
    ADD CONSTRAINT fk_image_search_results_search_place
    FOREIGN KEY (image_search_place_id) REFERENCES image_search_places(id);

ALTER TABLE image_search_results
    ADD CONSTRAINT fk_image_search_results_place
    FOREIGN KEY (place_id) REFERENCES places(id);


-- Chat Memory
ALTER TABLE chat_memories
    ADD CONSTRAINT fk_chat_memories_user
    FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE chat_memory_vectors
    ADD CONSTRAINT fk_chat_memory_vectors_user
    FOREIGN KEY (user_id) REFERENCES users(id);


-- Checklist
ALTER TABLE checklists
    ADD CONSTRAINT fk_checklists_user
    FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE checklist_items
    ADD CONSTRAINT fk_checklist_items_checklist
    FOREIGN KEY (checklist_id) REFERENCES checklists(id);


-- Hotel & Payment
ALTER TABLE hotel_bookings
    ADD CONSTRAINT fk_hotel_bookings_user
    FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE payment_transactions
    ADD CONSTRAINT fk_payment_transactions_booking
    FOREIGN KEY (hotel_booking_id) REFERENCES hotel_bookings(id);
