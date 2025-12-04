DO $$
DECLARE
    u RECORD;
    p_id BIGINT;
    day_id BIGINT;
    travel RECORD;
    day_count INT;
    place_count INT;
    d INT;
    i INT;
BEGIN
    -- 모든 user 반복
    FOR u IN SELECT id FROM users LOOP

        -- 유저마다 플랜 3개 생성
        FOR i IN 1..3 LOOP

            -- 1~7일 랜덤
            day_count := random_int(1, 7);

            -- plan 생성
            INSERT INTO plans (
                user_id, title, budget, start_date, end_date, created_at, updated_at, is_ended
            ) VALUES (
                u.id,
                null,
                random_int(500000, 3000000),                         -- 예: 50만원~300만원
                now() - (day_count + random_int(3,30)) * INTERVAL '1 day',
                now() - random_int(1, 2) * INTERVAL '1 day',
                now(), now(), true
            )
            RETURNING id INTO p_id;

            -- days 생성
            FOR d IN 1..day_count LOOP

                INSERT INTO plan_days (
                    plan_id, day_index, title, plan_date
                ) VALUES (
                    p_id,
                    d,
                    'Day ' || d,
                    now() - (day_count - d + random_int(3,30)) * INTERVAL '1 day'
                )
                RETURNING id INTO day_id;

                -- 각 날짜에 랜덤으로 1~5개 place 선택
                place_count := random_int(1, 5);

                FOR i IN 1..place_count LOOP

                    -- travel_places 중 랜덤 1개 조회
                    SELECT *
                    INTO travel
                    FROM travel_places
                    ORDER BY random()
                    LIMIT 1;

                    INSERT INTO plan_places (
                        day_id,
                        null,
                        start_at,
                        end_at,
                        place_name,
                        address,
                        lat,
                        lng,
                        expected_cost
                    ) VALUES (
                        day_id,
                        travel.title,
                        now() - random_int(1,10) * INTERVAL '1 hour',
                        now(),
                        travel.title,
                        travel.address,
                        travel.lat,
                        travel.lng,
                        random_int(0, 50000)        -- 0~5만원
                    );
                END LOOP;

            END LOOP;

        END LOOP;

    END LOOP;
END $$;
