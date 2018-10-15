# jsp-board (테스트)

### - 개선해야 할 사항
 - 쿠키 사용방식 (현재는 계정 로그인시 쿠키값 value를 받아서 파라메터로 넘겨서 계정을 인증하는 방식)
   - 추후는 DB에 쿠키 테이블(쿠키 vaule값, 유지 기간등)을 생성하여 임시적으로 쿠키 값을 발급 받은후(random vaule값) 해당 값을 통하여
     계정 로그인 유무 및 다른 페이지 호출시 정상적으로 그 계정이 유지 되게 해야함.
    
 - 게시글 정령 방식
   - 현재 게시글은 게시글의 parent(id값) 기준으로 order by하여 오름 차순 정렬이후 
     parent 값을 기준으로 정렬에 사용할 쿼리 정보를 sort 컬럼에 update 쿼리문으로 오름차순 정렬값을 넣어서
     sort 값 기준으로 페이징 갯수 많큼 oder by 하여 오름차순 정렬 하는 방식
   
   - 추후 parent값 기준으로 grouping하여 쿼리 하나로 처리 할 예정(계층 구조 쿼리 connect by를 사용하여 부모행과 자식행 관계를 정리 할 예정)
   

