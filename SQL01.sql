-- <쇼핑몰 테이블>
/*쇼핑몰 테이블 실전 설계
고객 (customers)
- 고객 id, 이름, 이메일, 비밀번호, 주소, 가입 시각 
상품 (products)
- 상품 id, 상품명, 설명, 가격, 재고 수량 
주문 (orders)
- 주문 id, 주문 고객, 주문 상품, 주문 수량, 주문 시각, 주문 상태

- 주문이 등록되면 최초의 주문 상태는 주문상태가 된다
- 한 번의 주문 시에 한 종류의 상품만 주문할 수 있다. 한 종류의 상품을 여러 개 주문하는 것은 가능하다.*/
use my_shop;
-- desc sample;
-- select * from sample;
create table customers(
	customer_id int auto_increment primary key, -- 고객 id, auto_increment: 자동번호부여, primary key:기본키
    c_name varchar(50) not null, -- 고객 이름, varchar(50):가변, 최대 50/char(50):고정
    email varchar(100) not null unique, -- email, not null:공백 안됨(꼭 입력), unique:중복 안됨(고유의 하나)
    pass varchar(255) not null, -- 암호
    address varchar(200) not null, -- 주소
    join_date datetime default current_timestamp -- 가입일시, date:날짜, datetime:날짜/시간, default:기본값(입력하지 않으면 기본으로 들어가 있는 값), current_timestamp:현재 지금 날짜/시간
    );
    desc customers; -- desc :구조
    
    create table products(
		product_id int auto_increment primary key,
        p_name varchar(100) not null,
        descr text, -- 긴 문자열(설명)
        price int not null,
        stock_quantity int not null default 0 -- 재고수량
        );
	desc products;
    
    create table orders(
		order_id int auto_increment primary key,
        customer_id int not null,
        product_id int not null,
        
        quantity int not null -- 주문수량
        constraint chk_order_quan check(quantity >= 1),
        -- constraint:제약조건/ chk_order_quan(이름 명명)
        -- check(quantity >= 1):수량이 1개 이상 체크
        
        order_date datetime default current_timestamp,
        o_status varchar(20) not null default '주문접수',
		
        constraint fk_orders_customers foreign key (customer_id)
			references customers(customer_id)
            -- 주문테이블(orders)의 customer_id(외래키)-고객테이블의 costomer_id 연결
             -- fk_orders_customers:제약조건마다 이름을 정함(우리가 정한 제약조건이름)/fk=foreign key_해당테이블_연결할 테이블
            on update cascade,
            -- cascade:연결된(부모)테이블이 갱신(수정)/삭제되면 다른 연결된(자식)테이블도 같이 수정/삭제
            
		constraint fk_orders_products foreign key(product_id)
			references products(product_id)
            -- 주문테이블(orders)의 products_id(외래키)-고객테이블의 product_id 연결
            -- fk_orders_products:제약조건마다 이름을 정함(우리가 정한 제약조건이름)/fk=foreign key_해당테이블_연결할 테이블
            on update cascade
		);
        
        use my_shop;
        desc customers;
        desc products;
        desc orders;
        
        -- alter table:이미 만든 테이블 구조 변경
        -- 열추가:add column
        alter table customers
        add column point int not null default 0; -- 속성 추가
        select * from customers;
        
        -- 열(속성, 필드) 수정:modify column
        alter table customers
        modify column address varchar(300) not null;
        
        -- 열 삭제:drop column
        alter table customers
        drop column point;
        
        alter table orders
        alter o_status set default '주문접수 완료';
        
        insert into customers 
        (c_name, email, pass, address, join_date) values
		('이순신', 'sunsin@naver.com', 'password123', '서울특별시 중구 세종대로', '2026-05-01 10:30:00'),
		('세종대왕', 'sejong@naver.com', 'password456', '서울특별시 종로구 사직로', '2025-04-01'),
		('장영실', 'young@naver.com', 'password789', '부산광역시 동래구 복천동', '2026-03-10');
        select * from customers;
        insert into customers 
        (c_name, email, pass, address) values
        ('강감찬', 'kang@naver.com','password777','인천 남동구 구월동');
        
        insert into products
        (p_name,descr,price,stock_quantity) values
        ('갤럭시','최신 AI 기능이 탑재된 고성능 스마트폰',1000000, 55);
        select * from products;
        insert into products
        (p_name,descr,price,stock_quantity) values
        ('LG 그램', '초경량 디자인과 강력한 성능을 자랑하는 노트북', 500000, 35),
		('아이폰', '직관적인 사용자 경험을 제공하는 스마트폰', 800000, 55),
		('에어팟', '편리한 사용성의 무선 이어폰', 200000, 110),
		('알뜰폰', NULL, 300000, 100);
        
        desc orders;
        insert into orders
        (customer_id, product_id,quantity) values
        (1,1,1);
        select * from orders;
        insert into orders
        (customer_id, product_id,quantity) values
        (2, 2, 1), 
		(3, 3, 1), 
		(1, 4, 2), 
		(2, 2, 1);
        
        update customers set customer_id=10 where customer_id=4;
        select * from customers;
        update customers set pass='password100' where customer_id=10;
        
        -- delete from customers where customer_id=10;
        
        update customers set pass='password333' where c_name='장영실';
        SET SQL_SAFE_UPDATES = 1; -- 안전 모드 해제 (0 = OFF)
        
        -- 인덱스 생성
        create index i_price on products(price);
        select * from products where price>=500000;
        -- view(뷰):데이터를 따로 저장 안함, 필요한 것만 꺼내와서 사용자에게 보여줌
        create view v_masking as
			select 
			customer_id,
            c_name,
            email,
            join_date
            from customers;
            select * from v_masking;
            
		create view v_seoul as
			select customer_id, c_name, address
            from customers
            where address like '%서울%';
            -- like:와 같다, %:모든 문자를 대체(공백도 대체)
		select * from v_seoul;
        
        select * from products;
        
        -- p_name, descr, price 조건:설명 중 AI가 들어감
        create view find_products_descr as
			select p_name, descr, price
            from products
            where descr like '%AI%';
            
		select * from find_products_descr;
        
        create view v_order_details as
        select 
			  o.order_id,
              c.c_name as 고객이름,
              p.p_name as 상품명,
              o.order_date as 주문일시,
              o.o_status as 주문상태
			from orders o
			join customers c on o.customer_id=c.customer_id
			join products p on o.product_id=p.product_id;
		
        select * from v_order_details;
        
        -- order => a  customers => b
        -- order_id, customer_id, c_name, quantity
        -- 주문번호 , 고객번호, 고객명, 수량
        -- 주문 테이블의 고객번호=고객테이블의 고객번호
        create view v_order_customers as
		select
			 a.order_id as 주문번호,
             a.quantity as 수량,
             b.customer_id as 고객번호,
             b.c_name as 고객명
			from orders a
			join customers b on a.customer_id=b.customer_id;
            
		select * from v_order_customers;
        
        drop view v_masking;
        
        select c_name, address from customers;
        select * from products where price >= 700000;
        
        -- customers => join_date 가 2026-1-1 이후 조회
        select * from customers where join_date >= '2026-1-1';
        
        -- (price)가격이 50만원 이상이면서 (stock_quantity)재고수량이 50이상
        select * from products
        where price >= 500000 and stock_quantity >= 50;
        -- where 조건, between 0 and 10:범위
        select * from products
        where price not between 500000 and 1000000;
        -- in:포함, not in:포함안됨
        select * from products
        where p_name not in ('갤럭시', '아이폰','아이폰18');
        
        select * from customers
        where c_name like '강%';
        -- _(밑줄):한글자(글자수 많큼 밑줄 사용)
        select * from customers
        where address not like '서울특별시%';
        
        select * from customers;
        select * from products;
        select * from orders;
        -- products 상품명이 아로 시작 3글자 조회
        select * from products
        where p_name like '아__';
        -- products-> 상품명이 아로 시작 모든 데이터 조회
        select * from products
        where p_name like '아%';
        -- produts->price 500000미만이거나 800000 초과 조회
        select * from products
        where price not between 500000 and 800000;
        -- 상품명이 ('갤럭시','아이폰','에어팟')일치하면 조회
        select * from products
        where p_name in ('갤럭시','아이폰','에어팟');
        
        -- 정렬(order by):axc(오름차순, 기본이라 생략가능), desc(내림차순)
        
        -- customers -> join_date(가입일시) 최근순으로 나열
        select * from customers
        order by join_date desc;
        -- products->price 작은 금액부터 나오게 나열
        select * from products
        order by price asc;
        -- 다중 열 정렬(stock_quantity(재고수량) 큰것부터=> 가격(price) 작은거부터)
        select * from products
        order by stock_quantity desc, price asc;
        -- 가격이 가장 비싼 상품 나열
        select * from products
        order by price desc limit 2; -- limit:개수제한
        -- 재고수량이 작은 상품 3개 조회
        select * from products
        order by stock_quantity asc limit 3;
        
        select * from products
        order by product_id asc limit 2,2; -- limit 2,2: 2개를 건너뛰고 2개를 보여줌
        
        -- distinct:중복제거, 속성명(열이름)앞
        select distinct customer_id from orders;
        SELECT DISTINCT product_id FROM orders;
        select * from products
        where descr is null; -- null:알수없음
        -- null값을 검사하기 위해서는 is null 사용
        select * from products
        where descr is not null;
        select product_id, p_name, descr is null from products;
        -- descr in null:(null0참이면 1 거짓이면 0
        
        -- descr(설명)을 오름차순으로 정렬ALTER
        select * from products
        order by descr desc;
        -- null 값은 크기순으로 가장 작은 값
        
        -- 주소가 인천인 고객에 대해 고객테이블에서 이름과 주소 검색
        select c_name, address from customers
        where c_name in (select c_name from customers where address like '인천%');
        
        -- 상품명, 가격(상품테이블)-> 조건 상푸코드 일치(in)
        -- 주문테이블에서 상품코드 3인 것의 상품코드
        select p_name, price from products
        where product_id in (select product_id from orders where product_id=3);
        
        SELECT p_name, price, stock_quantity from products
        where p_name not in ('갤럭시','아이패드');
        
        SELECT * from products
        where product_id in (SELECT product_id from orders);
        