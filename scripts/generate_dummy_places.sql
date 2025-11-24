DO $$
DECLARE 
    i INT;
    lat_min NUMERIC := 37.450000;
    lat_max NUMERIC := 37.700000;
    lng_min NUMERIC := 126.800000;
    lng_max NUMERIC := 127.200000;

    place_names TEXT[] := ARRAY[
        '경복궁', '창덕궁', '북촌한옥마을', '광화문광장', '명동거리', '남산타워', '롯데타워', '청계천', '홍대거리',
        '연남동 골목', '해운대 해수욕장', '광안리', '서면 거리', '제주 성산일출봉', '한라산 국립공원',
        '전주 한옥마을', '속초 해변', '부산 감천문화마을', '인사동 문화거리', '삼청동 카페거리',
        '서울숲', '올림픽공원', '노량진 수산시장', '가로수길', '여의도 한강공원'
    ];

    place_types TEXT[] := ARRAY[
        'attraction', 'restaurant', 'landmark', 'museum', 'shopping', 'nature', 'cafe'
    ];

BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO places (
            name,
            description,
            lat,
            lng,
            address,
            place_type,
            image_url,
            thumbnail_url
        )
        VALUES (
            place_names[ floor(random() * array_length(place_names, 1) + 1) ],
            '자동 생성된 랜덤 여행지 설명입니다 #' || i,
            lat_min + random() * (lat_max - lat_min),
            lng_min + random() * (lng_max - lng_min),
            '서울특별시 랜덤 주소 ' || i,
            place_types[ floor(random() * array_length(place_types, 1) + 1) ],
            'https://picsum.photos/seed/place' || i || '/800/600',
            'https://picsum.photos/seed/thumb' || i || '/400/300'
        );
    END LOOP;
END $$;
