select * from sample21;
desc sample21;

# 6. 조건
select no, name from sample21;
select * from sample21 where no=2;
select * from sample21 where no<>2;
select * from sample21 where no<2;
select * from sample21 where no<=2;
select * from sample21 where name='박준용';
select * from sample21 where birthday is NULL;
select * from sample21 where birthday is not NULL;

# 7. 조건 조합
select * from sample24 where a<>0 and b<>0;
select * from sample24 where no=1 or no=2;
select * from sample24 where not(a<>0 or b<>0);

# 8. 패턴 매칭 OR 부분 검색
select * from sample25;
select * from sample25 where text like 'sql%';
select * from sample25 where text like '%sql%';
select * from sample25 where text like '%\%%'; # 이스케이프

# 9. 정렬 - ORDER BY
# 10. 복수의 열을 지정해 정렬하기
select * FROM sample31;
select * from sample31 order by age;
select * from sample31 order by address;
select * from sample31 order by age desc; # 내림차순
select * from sample31 order by age asc; # 오름차순
select * from sample311 order by a; # a : 문자열로 저장
select * from sample311 order by b; # b : 수치형으로 저장

select * from sample32;
select * from sample32 order by a; # a가 동일한 b들은 정렬이 되지 않음
select * from sample32 order by a,b;
select * from sample32 order by b,a;
select * from sample32 order by a asc, b desc; # default : ASC (그래도 가독성을 위해서 적자)

# 11. 결과 행 제한하기 - LIMIT, OFFSET
select * from sample33;
select * from sample33 limit 3; # 최대행수 지정
select * from sample33 order by no DESC limit 3;

select * from sample33 limit 3 offset 0;
select * from sample33 limit 3 offset 3; # index 3부터 시작(0 1 2 3 ...)

# 12. 수치 연산
select * from sample34;
select *, price*quantity from sample34;
select *, price*quantity as amount from sample34; # 키워드 AS 생략 가능
select *, price*quantity "금액" from sample34; # ASCII 문자 이외의 것을 포함할 경우는 ""로 둘러싸서 지정
# 객체명 : " ", 문자열 상수 : ' '

select *, price*quantity as amount from sample34 where price*quantity >= 2000;
# 조건을 amount로 주면 안됨. 처리 순서 : where 구 -> select 구
# select 구에서 지정한 별명은 where 구 안에서 사용할 수 없음
# NULL로 연산하면 결고는 무조건 NULL

select *, price*quantity as amount from sample34 order by price*quantity desc;
select *, price*quantity as amount from sample34 order by amount desc; # select 구에서 지정한 별명을 order by 구에서 사용 가능

select amount, round(amount) from sample341;
select amount, round(amount, 1) from sample341; # 소수점 둘째 자리를 반올림
select amount, round(amount, -2) from sample341;
select amount, truncate(amount) from sample341;

# 13. 문자열 연산
SELECT * FROM sample35;
SELECT CONCAT(quantity, unit) FROM sample35;
# SUBSTRING('20140125001', 1, 4) -> '2014'
# SUBSTRING('20140125001', 5, 2) -> '01'
# TRIM('ABC    ') -> 'ABC'
# CHARACTER_LENGTH : 문자열 길이
# OCTET_LENGTH : 문자열의 길이를 바이트 단위로 계산
# 문자열 데이터의 길이는 문자세트에 따라 다르다!

# 14. 날짜 연산
SELECT current_timestamp();
# TO_DATE('2014/01/25', 'YYYY/MM/DD')
SELECT CURRENT_DATE + INTERVAL 1 DAY;
SELECT CURRENT_DATE - INTERVAL 1 DAY;
# DATEDIFF('2014-02-28', '2014-01-01')

# 15. CASE 문으로 데이터 변환하기
# ELSE 생략하면 ELSE NULL 이 됨 -> 생략하지 않고 지정하는 편이 낫다
# NULL 값 판단하려면 검색 CASE 문 사용해야함
# 검색 CASE : 'CASE WHEN 조건식 THEN 식 ...'
# 단순 CASE : 'CASE 식 WHEN 식 THEN 식 ...'
SELECT a FROM sample37;
SELECT a, CASE WHEN a IS NULL THEN 0 ELSE a END "a(null=0)" FROM sample37;
SELECT a, COALESCE(a,0) FROM sample37;

# 검색 CASE
SELECT a AS "코드",
CASE
	WHEN a=1 THEN '남자'
    WHEN a=2 THEN '여자'
    ELSE '미지정'
END AS "성별" FROM sample37;

# 단순 CASE
SELECT a AS "코드",
CASE a
	WHEN 1 THEN '남자'
    WHEN 2 THEN '여자'
    ELSE '미지정'
END AS "성별" FROM sample37;

# 16. 행 추가하기 - INSERT
SELECT * FROM sample41;
DESC sample41;

INSERT INTO sample41 VALUES(1, 'ABC', '2014-01-25'); # 해당 열의 데이터 형식에 맞도록 값을 지정
SELECT * FROM sample41;

INSERT INTO sample41(a, no) VALUES('XYZ', 2);
SELECT * FROM sample41;

# NOT NULL 제약이 걸려있는 열은 NULL 값을 허용하지 않음 -> NULL을 허용하고 싶지 않다면 NOT NULL 제약을 걸어두는 편이 좋음
INSERT INTO sample41(no, a, b) VALUES(NULL, NULL, NULL); # Error 발생
INSERT INTO sample41(no, a, b) VALUES(3, NULL, NULL);
SELECT * FROM sample41;

DESC sample411; # default 주의해서 보기
INSERT INTO sample411(no,d) VALUES (1,1);
SELECT * FROM sample411;
INSERT INTO sample411(no, d) VALUES(2, DEFAULT); # 명시적으로 디폴트 지정
SELECT * FROM sample411;
INSERT INTO sample411(no) VALUEs(3); # 암묵적으로 디폴트 지정
SELECT * FROM sample411;

# 17. 삭제하기 - DELETE
# DELETE 명령은 WHERE 조건에 일치하는 '모든 행'을 삭제한다!
# MySQL에서는 DELETE 명령에서 ORDER BY 구와 LIMIT 구를 사용해 삭제할 행을 지정할 수 있음
SELECT * FROM sample41;
DELETE FROM sample41 WHERE no=3;
# DELETE FROM sample41 WHERE no=1 or no=2; 
SELECT * FROM sample41;

# 18. 데이터 갱신하기 - UPDATE
# UPDATE 명령에서는 WHERE 조건에 일치하는 '모든 행'이 갱신된다!
SELECT * FROM sample41;
UPDATE sample41 SET b='2014-09-07' WHERE no=2;
SELECT * FROM sample41;

UPDATE sample41 SET no = no+1;
SELECT * FROM sample41;

UPDATE sample41 SET a='xxx', b='2014-01-01' WHERE no=2;
SELECT * FROM sample41;

# 두 결과가 다름
# 갱신식 안에서 열을 참조할 때는 처리 순서를 고려할 필요가 있음
UPDATE sample41 SET no=no+1, a=no;
UPDATE sample41 SET a=no, no=no+1;

# 19. 물리삭제와 논리삭제
# 물리삭제 : SQL의 DELETE 명령을 사용해 직접 데이터를 삭제하자는 사고 방식
# 논리삭제 : 테이블에 '삭제플래그'와 같은 열을 미리 준비, 실제로 삭제하는 대신 UPDATE 명령을 이용해 삭제플래그의 값을 갱신

# 20. COUNT, DISTINCT
# 집계함수는 집합 안에 NULL 값이 있을 경우 무시한다!
SELECT * FROM sample51;
SELECT COUNT(*) FROM sample51; # 행 개수

SELECT * FROM sample51 WHERE name='A';
SELECT COUNT(*) FROM sample51 WHERE name='A';

SELECT COUNT(no), COUNT(name) FROM sample51;

SELECT ALL name FROM sample51;
SELECT DISTINCT name FROM sample51;
SELECT COUNT(ALL name), COUNT(DISTINCT name) FROM sample51;

# 21. SUM, AVG, MIN MAX
SELECT * FROM sample51;

SELECT SUM(quantity) FROM sample51;

SELECT AVG(quantity), SUM(quantity)/COUNT(quantity) FROM sample51;
SELECT AVG(CASE WHEN quantity IS NULL THEN 0 ELSE quantity END) AS avgnull0 FROM sample51; # NULL을 0으로 변환

SELECT MIN(quantity), MAX(quantity), MIN(name), MAX(name) FROM sample51;

# 22. GROUP BY
# WHERE 구에서는 집계함수를 사용할 수 없다!
# 집계함수를 사용할 경우 HAVING 구로 검색조건을 지정한다!
# GROUP BY에서 지정한 열 이외의 열은 집계함수를 사용하지 않은 채 SELECT 구에 지정할 수 없다!
SELECT * FROM sample51;

SELECT name FROM sample51 GROUP BY name;

SELECT name, COUNT(name), SUM(quantity) FROM sample51 GROUP BY name;

SELECT name, COUNT(name) FROM sample51 GROUP BY name;
SELECT name, COUNT(name) FROM sample51 GROUP BY name HAVING COUNT(name)=1; # WHERE 대신 HAVING으로 조건 부여

SELECT MIN(no), name, SUM(quantity) FROM sample51 GROUP BY name;
SELECT no, quantity FROM sample51 GROUP BY no, quantity;

SELECT name, COUNT(name), SUM(quantity) FROM sample51 GROUP BY name ORDER BY SUM(quantity) DESC;

# 23. 서브쿼리
# 서브쿼리는 SELECT 명령에 의한 데이터 질의로, 상부가 아닌 하부의 부수적인 질의를 의미 ( (SELECT 명령) )
# = 연산자를 사용하여 비교할 경우에는 스칼라 값끼리 비교할 필요가 있다!
# 스칼라 서브쿼리는 WHERE구에 사용할 수 있다.
SELECT * FROM sample54;

SELECT MIN(a) FROM sample54;
SELECT * FROM sample54 WHERE a = (SELECT MIN(a) FROM sample54);

SELECT 
	(SELECT COUNT(*) FROM sample51) AS sq1,
    (SELECT COUNT(*) FROM sample54) AS sq2;

SELECT * FROM (SELECT * FROM sample54) sq; # sq : 테이블 별명

INSERT INTO sample541 VALUES(
	(SELECT COUNT(*) FROM sample51),
    (SELECT COUNT(*) FROM sample54)
);
SELECT * FROM sample541;

INSERT INTO sample541 SELECT 1,2;
SELECT * FROM sample541;

INSERT INTO sample542 SELECT * FROM sample543; # 열 구성이 똑같은 테이블 사이에 복사하기

# 24. 상관 서브쿼리
# 상관 서브쿼리는 부모 명령과 연관되어 처리되기 때문에 서브쿼리 부분만을 따로 떼어내어 실행시킬 수 없음
SELECT * FROM sample551;
SELECT * FROM sample552;

UPDATE sample551 SET a='있음' WHERE 
	EXISTS (SELECT * FROM sample552 WHERE no2=no);
SELECT * FROM sample551;

UPDATE sample551 SET a='없음' WHERE 
	NOT EXISTS (SELECT * FROM sample552 WHERE sample552.no2=sample551.no);
SELECT * FROM sample551;

SELECT * FROM sample551 WHERE no IN(3,5); # WHERE no=3 OR no=5
SELECT * FROM sample551 WHERE no IN(SELECT no2 FROM sample552);