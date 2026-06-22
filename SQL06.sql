use my_shop;
select * from sample;
set sql_safe_updates=1; -- 수정/삭제 할 수 있도록 비활성화
start TRANSACTION; -- 취소가 가능하도록 안전구역 설정
DELETE from sample; -- 모든 데이터 삭제
select * from sample;
rollback; -- 실행 취소
commit; -- 확정