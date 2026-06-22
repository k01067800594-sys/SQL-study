CREATE DATABASE db_ex;
use db_ex;
CREATE table 학생(
	학번 int PRIMARY key,
    이름 VARCHAR(30) not null,
    학과코드 varchar(30),
    선배 int ,
    성적 int
    );
CREATE table 학과(
	학과코드 varchar(30) PRIMARY key,
    학과명 varchar(50) not null
    );
create table 성적등급(
	등급 char PRIMARY key,
    최저 int not null,
    최고 int not null
    );
    desc 학생;
    desc 학과;
    desc 성적등급;
    
-- 학생 데이터 
INSERT INTO 학생 VALUES (15, '한다맨', 'com', NULL, 83);
INSERT INTO 학생 VALUES (16, '이서영', 'han', NULL, 96);
INSERT INTO 학생 VALUES (17, '장효정', 'com', 15, 95);
INSERT INTO 학생 VALUES (19, '주연국', 'han', 16, 75);
INSERT INTO 학생 VALUES (37, '신동진', null, 17, 55);

-- 학과 데이터 
INSERT INTO 학과 VALUES ('com', '컴퓨터');
INSERT INTO 학과 VALUES ('han', '국어');
INSERT INTO 학과 VALUES ('eng', '영어');


-- 성적 데이터
INSERT INTO 성적등급 VALUES ('A',90,100);
INSERT INTO 성적등급 VALUES ('B',80,89);
INSERT INTO 성적등급 VALUES ('C',60,79);
INSERT INTO 성적등급 VALUES ('D',0,59);

SELECT * from 학생;
SELECT * from 학과;
select * from 성적등급;
-- 1) where
SELECT 학번, 이름, 학생.학과코드, 학과명 from 학생, 학과
where 학생.학과코드=학과.학과코드;
-- 2) natural
select 학번, 이름, 학생.학과코드, 학과명 from 학생 NATURAL join 학과;
-- natural join:반드시 해당테이블들에 같은 값이 있어야 함
-- 조건을 쓰지 않아도 자동으로 같은 것끼리 연결
-- 3) join~using
select 학번, 이름, 학생.학과코드, 학과명 from 학생 join 학과 using(학과코드);

select 학번, 이름, 성적, 등급 from 학생, 성적등급 where 학생.성적 between 성적등급.최저 and 성적등급.최고;

select 학번, 이름, 학생.학과코드, 학과명 from 학생 left outer join 학과 on 학생.학과코드 = 학과.학과코드;
-- 왼쪽 테이블(학생) 전부 가져옴, 오른쪽 테이블(학과)는 확과코드가 같은 것만 추출
# select 학번, 이름, 학생.학과코드, 학과명 from 학생, 학과 where 학생.학과코드 = 학과.학과코드(+);

select 학번, 이름, 학생.학과코드, 학과명 from 학생 right outer join 학과 on 학과.학과코드 = 학생.학과코드;
-- 오른쪽테이블(학과) 전부 가져오고 왼쪽테이블은 학과코드 같은 것만 추출
#select 학번, 이름, 학생.학과코드, 학과명 from 학생, 학과 where 학과.학생코드(+) = 하생.학과코드;

# select 학번, 이름, 학생.학과코드, 학과명 from 학생 full outer join 학과 on 학생.학과코드 = 학과.학과코드;
select 학번, 이름, 학생.학과코드, 학과명 from 학생 left join 학과 on 학생.학과코드 = 학과.학과코드
UNION
select 학번, 이름, 학생.학과코드, 학과명 from 학생 right join 학과 on 학생.학과코드 = 학과.학과코드;

-- self join:같은 테이블에서 2개의 속성을 연결하여 EQUI JOIN 하는 JOIN 방법
select a.학번, a.이름, b.이름 as 선배 from 학생 a join 학생 b on a.선배=b.학번;
-- 하나의 테이블로 join, 학생 테이블을 가상으로 하나 더 복사
-- a->후배 테이블, b-> 선배 테이블