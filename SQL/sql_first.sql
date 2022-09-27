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