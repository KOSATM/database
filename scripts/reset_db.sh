#!/bin/bash

echo "========================================="
echo "🧹 RESET DATABASE - WARNING"
echo "========================================="

read -p "Reset all tables? (yes/no): " ans
if [ "$ans" != "yes" ]; then
  echo "Cancelled."
  exit 0
fi

echo "▶ Resetting all tables..."

psql << 'EOF'
SET session_replication_role = 'replica';

TRUNCATE
  ai_review_hashtags,
  ai_review_styles,
  ai_review_analysis,
  review_hashtags,
  review_hashtag_groups,
  review_photos,
  review_photo_groups,
  review_posts,
  current_activities,
  travel_places,
  travel_days,
  travel_plan_snapshots,
  travel_plans,
  image_search_results,
  image_search_places,
  chat_memory_vectors,
  chat_memories,
  checklists,
  checklist_items,
  payment_transactions,
  hotel_bookings,
  sns_tokens,
  user_identities,
  places,
  users
RESTART IDENTITY CASCADE;

SET session_replication_role = 'origin';
EOF

echo "🎯 Database reset complete."
