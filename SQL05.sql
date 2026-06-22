CREATE USER 'test_user'@'localhost' IDENTIFIED by 'sql12345';
-- 새로운 아이디와 비밀번호 부여
GRANT SELECT -- grant:권한부여 select:조회 권한
on my_shop.* -- my_shop 데이터베이스-> 모든 테이블 대상
to 'test_user'@'localhost';

-- 권한 새로고침
flush PRIVILEGES;