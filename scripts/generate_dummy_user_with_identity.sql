-- ============================================
-- GOOGLE 로그인 유저 10명 자동 생성 SQL
-- ============================================

DO $$
DECLARE
    i INT;
    new_user_id BIGINT;
BEGIN
    FOR i IN 1..10 LOOP

        -- 1) users 생성
        INSERT INTO users (
            is_active,
            last_login_at,
            name,
            email,
            profile_image_url,
            created_at
        )
        VALUES (
            TRUE,
            NOW(),
            'Google User ' || floor(random() * 100000),
            'google_user_' || floor(random() * 999999) || '@gmail.com',
            'https://picsum.photos/seed/google_user_' || floor(random()*1000000) || '/200',
            NOW()
        )
        RETURNING id INTO new_user_id;

        -- 2) GOOGLE identity 연결
        INSERT INTO user_identities (
            user_id,
            provider,
            created_at
        )
        VALUES (
            new_user_id,
            'GOOGLE',
            NOW()
        );

    END LOOP;
END $$;
