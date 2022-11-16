#26. 테이블 작성, 삭제, 변경
# 테이블 작성
CREATE TABLE sample62 (
	no INTEGER NOT NULL,
    a VARCHAR(30),
    b DATE);
DESC sample62;

# 열 추가
ALTER TABLE sample62 ADD newcol INTEGER;
DESC sample62;
# 열 속성 변경
ALTER TABLE sample62 MODIFY newcol VARCHAR(20);
DESC sample62;
# 열 이름 변경
ALTER TABLE sample62 CHANGE newcol c VARCHAR(20);
DESC sample62;
# 열 삭제
ALTER TABLE sample62 DROP c;
DESC sample62;

#27. 제약
# 열 제약
CREATE TABLE sample631 (
	a INTEGER NOT NULL,
    b INTEGER NOT NULL UNIQUE,
    c VARCHAR(30)
);
# 테이블 제약 : 한 개의 제약으로 복수의 열에 제약
CREATE TABLE sample632 (
	no INTEGER NOT NULL,
    sub_no INTEGER NOT NULL,
    name VARCHAR(30),
    CONSTRAINT pkey_sample PRIMARY KEY (no, sub_no) # 테이블 제약에 이름 붙이기
);

# 제약 추가 : 기존 테이블에도 나중에 제약을 추가
# 열 제약 추가
ALTER TABLE sample631 MODIFY c VARCHAR (30) NOT NULL;
# 테이블 제약 추가
ALTER TABLE sample631 ADD CONSTRAINT pkey_sample631 PRIMARY KEY(a);

# 제약 삭제
# 열 제약 삭제
ALTER TABLE sample631 MODIFY c VARCHAR(30);
# 테이블 제약 삭제
ALTER TABLE sample631 DROP CONSTRAINT pkey_sample631;
ALTER TABLE sample631 DROP PRIMARY KEY; # 기본키는 테이블당 하나만 설정할 수 있기 때문에 굳이 제약명을 지정하지 않고도 삭제 가능

# 기본키 제약
# 기본키로 지정할 열을 NOT NULL 제약이 설정되어있어야함
# 기본키는 테이블의 행 한개를 특정할 수 있는 검색키
# 기본키로 설정된 열이 중복하는 데이터 값을 가지면 제약에 위반
# INSERT, UPDATE 명령에 이미 존재하는 값으로 추가하면 키본키 제약에 위반되어 실행되지 않음
# 이처럼 열을 기본키로 지정해 유일한 값을 가지도록 하는 구조가 기본키 제약 (유일성 제약이라고도 불림)
# 기본키를 a열과 b열로 지정했을 때, a 열만 봤을 때는 중복하는 값이 있어도, b 열이 다르면 키 전체로서 중복하지 않는다고 간주되기 때문에 기본키 제약에 위반되지 않음
CREATE TABLE sample634(
	p INTEGER NOT NULL,
    a VARCHAR(30),
    CONSTRAINT pkey_sample634 PRIMARY KEY(p)
);

#28. 인덱스 구조
# 인덱스 : 테이블에 붙여진 색인
# 인덱스의 역할은 검색속도의 향상, WHERE로 조건이 지정된 SELECT 명령의 처리 속도가 향상
# 데이터베이스의 인덱스에는 검색 시에 쓰이는 키워드와 대응하는 데이터 행의 장소가 저장되어 있음
# 인덱스는 테이블과는 별개로 독립된 데이터베이스 객체로 작성됨, 하지만 인덱스는 테이블에 의존하는 객체라 할 수 있음.
# 대부분의 데이터베이스에서는 테이블을 삭제하면 인덱스도 같이 삭제됨
# 일반적으로는 테이블에 인덱스를 작성하면 테이블 데이터와는 별개로 인덱스용 데이터가 저장장치에 만들어짐
# 이때, 이진 트리라는 데이터 구조로 작성됨

#29. 인덱스 작성과 삭제
# 인덱스는 데이터베이스 객체의 하나로 DDL을 사용해서 작성하거나 삭제함
# 인덱스 자체가 데이터베이스 제품에 의존하는 선택적인 항목으로 취급됨. 표준 SQL에는 CREATE INDEX 명령 없음
# MySQL에서 인덱스는 테이블 내의 객체. 따라서 테이블 내에 이름이 중복되지 않도록 지정해 관리함
# 인덱스를 작성할 때는 해당 인덱스가 어느 테이블의 어느 열에 관한 것인지 지정할 필요가 있음
# 인덱스 작성
CREATE INDEX isample65 ON sample62(no);
# 인덱스 삭제
DROP INDEX isample65 ON sample62;
# EXPLAIN으로 인덱스 사용 확인
EXPLAIN SELECT * FROM sample62 WHERE a='a';
EXPLAIN SELECT * FROM sample62 WHERE no>10;

#30. 뷰 작성과 삭제
# 뷰는 테이블과 같은 부류의 데이터베이스 객체 중 하나
# FROM 구에 기술된 서브쿼리에 이름을 붙이고 데이터베이스 객체화하여 쓰기 쉽게 한 것을 뷰라 함
# 본래 데이터베이스 객체로 등록할 수 없는 SELECT 명령을, 객체로서 이름을 붙여 관리할 수 있도록 한 것이 뷰
# 뷰를 참조하면 그에 정의된 SELECT 명령의 실행결과를 테이블처럼 사용할 수 있음

# 서브쿼리 부분을 뷰로 대체하여 SELECT 명령을 간략하게 표현할 수 있음
# 뷰를 사용함으로써 복잡한 SELECT 명령을 데이터베이스에 등록해 두었다가 나중에 간단히 실행할 수도 있음
SELECT * FROM (SELECT * FROM sample54) sq;
SELECT * FROM sample_view_67; # 서브쿼리 부분을 뷰 객체로 만들면 다음과 같이 됨

# 뷰 작성
CREATE VIEW sample_view_67 AS SELECT * FROM sample54;
SELECT * FROM sample_view_67;
# 열을 지정해 뷰 작성하기
CREATE VIEW sample_view_672(n, v, v2) AS
	SELECT no, a, a*2 FROM sample54;
SELECT * FROM sample_view_672 WHERE n=1;
# 뷰 삭제
DROP VIEW sample_view_67;

# 뷰는 데이터베이스 객체로서 저장장치에 저장되지만 저장공간을 필요로 하지 않고, CPU 자원을 사용함
# 뷰를 참조하면 뷰에 등록되어 있는 SELECT 명령이 실행됨
# 실행 결과는 일시적으로 보존되며, 뷰를 참조할 때마다 SELECT 명령이 실행됨
# 뷰를 구성하는 SELECT 명령은 단독으로도 실행할 수 있어야함. 서브쿼리의 경우에는 뷰의 SELECT 명령으로 사용할 수 없음

#31. 집합 연산
# 합집합 : A UNION B
SELECT * FROM sample71_a;
SELECT * FROM sample71_b;

SELECT * FROM sample71_a 
UNION
SELECT * FROM sample71_b;

# 열 구성이 다른 테이블은 UNION으로 묶을 수 없음. but, *을 사용하지 않고 열을 따로 지정해서 맞춰주면 가능
SELECT a FROM sample71_a
UNION
SELECT b FROM sample71_b
UNION
SELECT age FROM sample31;

# UNION으로 SELECT 명령을 연결하는 경우, 가장 마지막 SELECT 명령에 대해서만 ORDER BY 구를 지정할 수 있음
# ORDER BY 구에 지정하는 열은 별명을 붙여 이름을 일치시킨다!
SELECT a AS c FROM sample71_a
UNION
SELECT b AS c FROM sample71_b ORDER BY c;

# 중복을 제거하지 않고 합치기 (UNION ALL), UNION의 기본동작은 ALL이 아닌 DISTINCT
# 중복이 없는 경우에는 UNION ALL을 사용하는 편이 좋은 성능을 보임
SELECT * FROM sample71_a
UNION ALL
SELECT * FROM sample71_b;

# 차집합, 교집합은 MySQL에서 지원 x

#32. 테이블 결합
# 곱집합 : 모든 경우의 수 곱 (3x3 = 9)

# 교차결합(Cross Join)
SELECT * FROM sample72_x;
SELECT * FROM sample72_y;
SELECT * FROM sample72_x, sample72_y;

# 내부결합 : 교차결합으로 계산된 곱집합에서 원하는 조합을 검색하는 것
SELECT * FROM 상품;
SELECT * FROM 재고수;
SELECT * FROM 상품, 재고수;

SELECT * 
FROM 상품, 재고수
WHERE 상품.상품코드=재고수.상품코드;

SELECT 상품.상품명, 재고수.재고수 
FROM 상품, 재고수
WHERE 상품.상품코드=재고수.상품코드 AND 상품.상품분류='식료품';

# INNER JOIN (내부결합)
# 위 방식은 구식
# INNER JOIN으로 두 개 테이블을 가로로 결합
SELECT 상품.상품명, 재고수.재고수
FROM 상품 INNER JOIN 재고수
ON 상품.상품코드=재고수.상품코드
WHERE 상품.상품분류='식료품';

# 내부결합을 활용한 데이터관리
SELECT * FROM 상품2;

SELECT S.상품명, M.메이커명
FROM 상품2 S INNER JOIN 메이커 M
ON S.메이커코드=M.메이커코드;

# 자기결합(Self Join)
SELECT S1.상품명, S2.상품명
FROM 상품 S1 INNER JOIN 상품 S2
ON S1.상품코드=S2.상품코드;

# 외부결합 : 어느 한 쪽에만 존재하는 데이터행을 어떻게 다룰지
SELECT 상품3.상품명, 재고수.재고수
FROM 상품3 LEFT JOIN 재고수
ON 상품3.상품코드=재고수.상품코드
WHERE 상품3.상품분류='식료품';