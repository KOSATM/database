-- 1번 사용자 강제 삽입
INSERT INTO users (id, name, email, created_at, is_active)
VALUES (1, '테스트유저', 'test@example.com', NOW(), true);

-- (옵션) 시퀀스 값 조정 (나중에 충돌 방지)
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));