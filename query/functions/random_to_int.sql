-- 랜덤 정수 추출 함수
CREATE OR REPLACE FUNCTION random_int(min INT, max INT)
RETURNS INT AS $$
BEGIN
    RETURN floor(random() * (max - min + 1))::INT + min;
END;
$$ LANGUAGE plpgsql;