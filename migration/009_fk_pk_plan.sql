ALTER TABLE plan_days RENAME COLUMN travel_plan_id to plan_id;

ALTER TABLE review_posts RENAME COLUMN travel_plan_id to plan_id;
ALTER TABLE plans
RENAME CONSTRAINT fk_travel_plans_user TO fk_plans_user;

ALTER TABLE plans
RENAME CONSTRAINT travel_plans_pkey TO plans_pkey;

ALTER TABLE plan_snapshots
RENAME CONSTRAINT fk_travel_plan_snapshots_user TO fk_plan_snapshots_user;
ALTER TABLE plan_snapshots
RENAME CONSTRAINT travel_plan_snapshots_pkey TO plan_snapshots_pkey;

ALTER TABLE plan_places
RENAME CONSTRAINT fk_travel_places_day TO fk_plan_places_day;
ALTER TABLE plan_places
RENAME CONSTRAINT travel_places_pkey TO plan_places_pkey;

ALTER TABLE plan_days
RENAME CONSTRAINT fk_travel_days_plan TO fk_plan_days_plan;
ALTER TABLE plan_days
RENAME CONSTRAINT travel_days_pkey TO plan_days_pkey;
commit;