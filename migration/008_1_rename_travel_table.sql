ALTER TABLE travel_plans RENAME TO plans;
ALTER TABLE travel_days RENAME TO plan_days;
ALTER TABLE travel_places RENAME TO plan_places;
ALTER TABLE travel_plan_snapshots RENAME TO plan_snapshots;
ALTER TABLE plan_days RENAME COLUMN travel_plan_id to plan_id;