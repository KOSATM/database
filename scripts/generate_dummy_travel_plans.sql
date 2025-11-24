DO $$
DECLARE
    -- USER
    new_user_id BIGINT;

    -- TRAVEL PLAN
    new_plan_id BIGINT;
    day_count INT := floor(3 + random() * 5); -- 3~7일 여행
    start_date DATE := CURRENT_DATE + (floor(random() * 30)); -- 앞으로 30일 이내 랜덤 시작일
    end_date DATE;

    -- DAY LOOP
    new_day_id BIGINT;
    day_i INT;

    -- PLACE LOOP
    place_count INT;
    place_i INT;

    -- Random arrays
    place_names TEXT[] := ARRAY[
        '경복궁', '창덕궁', '북촌한옥마을', '광화문광장', '명동거리', 
        '남산타워', '롯데타워', '청계천', '홍대거리',
        '연남동 골목', '성수 카페거리', '여의도 한강공원',
        '잠실 롯데월드', '올림픽공원', '서울숲',
        '속초 해변', '부산 해운대', '전주 한옥마을'
    ];

    addresses TEXT[] := ARRAY[
        '서울 종로구', '서울 강남구', '서울 마포구', '서울 용산구', '서울 송파구',
        '서울 성동구', '서울 영등포구', '부산 해운대구', '속초시'
    ];

    place_types TEXT[] := ARRAY['attraction', 'landmark', 'shopping', 'restaurant', 'nature'];
BEGIN
    -- 1) USER 생성
    INSERT INTO users (is_active, last_login_at, name, email, profile_image_url, created_at)
    VALUES (
        true,
        NOW(),
        'Random Traveler ' || floor(random()*1000),
        'traveler_' || floor(random()*100000) || '@example.com',
        'https://picsum.photos/seed/user' || floor(random()*999) || '/200',
        NOW()
    )
    RETURNING id INTO new_user_id;


    -- 2) TRAVEL PLAN 생성
    end_date := start_date + (day_count - 1);

    INSERT INTO travel_plans (user_id, budget, start_date, end_date, created_at, is_ended)
    VALUES (
        new_user_id,
        500000 + (random()*2000000),  -- 50만원~250만원 랜덤 예산
        start_date,
        end_date,
        NOW(),
        false
    )
    RETURNING id INTO new_plan_id;


    -- 3) DAY + PLACE LOOP
    FOR day_i IN 0..(day_count-1) LOOP

        -- DAY INSERT
        INSERT INTO travel_days (travel_plan_id, day_index, title, plan_date)
        VALUES (
            new_plan_id,
            day_i + 1,
            'Day ' || (day_i + 1),
            start_date + day_i
        )
        RETURNING id INTO new_day_id;

        -- 하루 장소 2~5개 랜덤 생성
        place_count := floor(2 + random() * 4);

        FOR place_i IN 1..place_count LOOP
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
                place_names[ floor(random()*array_length(place_names,1) + 1) ],
                (start_date + day_i) + (place_i || ' hours')::interval,
                (start_date + day_i) + ((place_i+1) || ' hours')::interval,
                place_names[ floor(random()*array_length(place_names,1) + 1) ],
                addresses[ floor(random()*array_length(addresses,1) + 1) ],
                37.45 + random()*0.25,   -- 서울 중심 랜덤 좌표
                126.80 + random()*0.35,
                5000 + (random()*45000) -- 5천원~5만원
            );
        END LOOP;

    END LOOP;

END $$;
