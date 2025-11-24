DO $$
DECLARE
    u RECORD;
    plan_i INT;
    new_plan_id BIGINT;
    new_day_id BIGINT;

    day_count INT;
    start_date DATE;
    day_i INT;

    place_count INT;
    place_i INT;

    selected_place RECORD;
BEGIN
    -- 1) id 1~10인 유저만 대상 선정
    FOR u IN (
        SELECT id FROM users WHERE id BETWEEN 1 AND 10
    )
    LOOP

        -- 2) 각 유저에게 여행 플랜 3개 생성
        FOR plan_i IN 1..3 LOOP

            -- 여행 일수 3~7일 랜덤
            day_count := (3 + floor(random() * 5))::int;

            -- 여행 시작일: 앞으로 60일 중 랜덤
            start_date := CURRENT_DATE + ((random() * 60)::int);

            -- travel_plan 생성
            INSERT INTO travel_plans (
                user_id,
                budget,
                start_date,
                end_date,
                created_at,
                is_ended
            )
            VALUES (
                u.id,
                300000 + (random()*1500000),
                start_date,
                start_date + (day_count - 1),
                NOW(),
                FALSE
            )
            RETURNING id INTO new_plan_id;

            -- travel_days + travel_places 생성
            FOR day_i IN 0..(day_count - 1) LOOP

                -- DAY insert
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

                -- 하루에 2~5개의 랜덤 장소 생성
                place_count := (2 + floor(random() * 4))::int;

                FOR place_i IN 1..place_count LOOP

                    -- places 테이블에서 랜덤 장소 1개 가져오기
                    SELECT *
                    INTO selected_place
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
                        selected_place.name,
                        (start_date + day_i) + ((8 + place_i)::text || ' hour')::interval,
                        (start_date + day_i) + ((9 + place_i)::text || ' hour')::interval,
                        selected_place.name,
                        selected_place.address,
                        selected_place.lat,
                        selected_place.lng,
                        5000 + (random()*40000)
                    );

                END LOOP;

            END LOOP;

        END LOOP;

    END LOOP;

END $$;
