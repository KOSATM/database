-- ============================================
-- TRAVEL PLANS + DAYS + PLACES FULL AUTO DUMMY
-- For users id 1~10
-- ============================================

DO $$
DECLARE
    u RECORD;                 -- user
    plan_i INT;
    new_plan_id BIGINT;
    new_day_id BIGINT;

    day_count INT;
    start_date DATE;
    day_i INT;

    place_count INT;
    place_i INT;

    selected_name TEXT;
    selected_address TEXT;
    selected_lat NUMERIC;
    selected_lng NUMERIC;
BEGIN

    -- 1) users 중 id 1~10만을 대상으로 반복
    FOR u IN (SELECT id FROM users WHERE id BETWEEN 1 AND 10) LOOP

        -- 2) 각 유저에게 여행 플랜 3개 생성
        FOR plan_i IN 1..3 LOOP

            -- 여행 일수: 3~7일 랜덤
            day_count := (3 + floor(random() * 5))::int;

            -- 여행 시작일: 향후 60일 중 랜덤
            start_date := CURRENT_DATE + ((random() * 60)::int);

            -- travel_plan 생성
            INSERT INTO travel_plans (
                user_id,
                budget,
                start_date,
                end_date,
                created_at,
                updated_at,
                is_ended
            )
            VALUES (
                u.id,
                300000 + (random()*1500000),
                start_date,
                start_date + (day_count - 1),
                NOW(),
                NOW(),
                FALSE
            )
            RETURNING id INTO new_plan_id;

            -- ================================
            -- travel_days + travel_places 생성
            -- ================================
            FOR day_i IN 0..(day_count - 1) LOOP

                INSERT INTO travel_days (
                    travel_plan_id,
                    day_index,
                    title,
                    plan_date
                )
                VALUES (
                    new_plan_id,
                    day_i + 1,
                    'Day ' || (day_i + 1),
                    start_date + day_i
                )
                RETURNING id INTO new_day_id;

                -- 하루 장소 2~5개 랜덤 생성
                place_count := (2 + floor(random() * 4))::int;

                FOR place_i IN 1..place_count LOOP

                    -- places 테이블에서 랜덤 장소 1개 선택
                    SELECT name, address, lat, lng
                    INTO selected_name, selected_address, selected_lat, selected_lng
                    FROM places
                    ORDER BY random()
                    LIMIT 1;

                    -- travel_places 생성
                    INSERT INTO travel_places (
                        day_id,
                        title,
                        start_at,
                        end_at,
                        place_name,
                        address,
                        lat,
                        lng,
                        expected_cost
                    )
                    VALUES (
                        new_day_id,
                        selected_name,
                        (start_date + day_i) + ((8 + place_i)::text || ' hour')::interval,
                        (start_date + day_i) + ((9 + place_i)::text || ' hour')::interval,
                        selected_name,
                        selected_address,
                        selected_lat,
                        selected_lng,
                        5000 + (random()*40000)
                    );

                END LOOP;

            END LOOP;

        END LOOP;

    END LOOP;

END $$;
