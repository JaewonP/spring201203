<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../include/header.jsp" %>
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">DataTables 예제</h6>
              <button id="regBtn" type="button" class="btn btn-xs pull-right">
                신규 게시글 등록
              </button>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered dt-responsive nowrap" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>#번호</th>
                      <th>제목</th>
                      <th>작성자</th>
                      <th>작성일</th>
                      <th>수정일</th>
                    </tr>
                  </thead>

          <c:forEach items="${list}" var="board">
            <tr>
              <td><c:out value="${board.bno}" /></td>
               <td>
                  <a class='move' href='<c:out value="${board.bno}"/>'>
                  <c:out value="${board.title}" />   <b>[  <c:out value="${board.replyCnt}" />  ]</b>
                  </a>
              <td><c:out value="${board.writer}" /></td>
              <td><fmt:formatDate pattern="yyyy-MM-dd"
                  value="${board.regDate}" /></td>
              <td><fmt:formatDate pattern="yyyy-MM-dd"
                  value="${board.updateDate}" /></td>
            </tr>
          </c:forEach>
              </table>
                <!-- End of DataTales Example -->
  
      <div class="row">
        <div class="col-lg-12">
          <form id="searchform' action="/board/list" method="get">
          <select name='type'>
          	<option value=""  		>--</option>
          	<option value="T"
          		<c:out value = "${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
          	<option value="C">내용</option>
          	<option value="W"
          		>작성자</option>
          	<option value="TC"
          		>>제목 or 내용</option>
          	<option value="TW"
  >제목 or 작성자</option>
          	<option value="TWC"
          		>제목 or 작성자 or 내용</option>
          </select>
          <input type="text" name='keyword' value='<c:out value = "${pageMaker.cri.keyword}"/>' />
            <input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum}"/>' />
            <input type="hidden" name="amount" value='<c:out value="${pageMaker.cri.amount}"/>' />
            <button class='btn btn-default'>Search</button>
          </form>
        </div>
      </div>
      <form id='actionForm' action="/board/list" method='get'>
      	 <input type="hidden" name="pageNum" value='${pageMaker.cri.pageNum}'> 
         <input type="hidden" name="amount" value='${pageMaker.cri.amount}'> 
         <input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}"/>'> 
         <input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
      </form>
      <div class="pull-right">
        <ul class="pagination">
          <c:if test="${pageMaker.prev}">
            <li class="paginate_button previous"><a href="${pageMaker.startPage-1}">이전</a></li>
          </c:if>
          <c:forEach var="num" begin="${pageMaker.startPage}"
                  end="${pageMaker.endPage}">
            <li class="paginate_button ${pageMaker.cri.pageNum==num ? "active":""}">
            	<a href=""${num}">${num}</a></li>
          </c:forEach>
          <c:if test="${pageMaker.next}">
            <li class="paginate_button next"><a href="${pageMaker.endPage+1}">다음</a></li>
          </c:if>
        </ul>
      </div>  <!-- End of pagination -->      
<div class="modal" id="myModal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Modal title</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>작업이 완료되었습니다.</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Save changes</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

  <!-- Scroll to Top Button-->
  <a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
  </a>
  
  <script>
  	$(document).ready(function(){//257페이지 history로 수정 
  		var result = '<c:out value="${result}"/>';
  		checkModal(result);
      history.replaceState({} ,null,null) ;// 추가
      //history가 스택에 쌓이는 상태는 모달창을 보여주지 않기 위해 추가함  
  		function checkModal(result) {

  			if (result === '' || history.state) { //수정 , result에 값이 없거나
        //history 의 state가 스택(LIFO(last Input First Output) 에 있으면 true가 되므로함수 종료 
  				return;
  			}
  			
  			if (parseInt(result) > 0) {
  				$(".modal-body").html(
  						"게시글 " + parseInt(result)
  								+ " 번이 등록되었습니다.");
  			}
  	 		
  			$("#myModal").modal("show");
      }
      
      $("#regBtn").on("click", function(){
        self.location ="/board/register";
      });

      var actionForm = $("#actionForm");

      $(".paginate_button a").on("click" ,function(e){
        e.preventDefault();
        console.log('click이 찎히나 보자 ' +$(this).attr("href"));
        actionForm.find("input[name='pageNum']").val($(this).attr("href"));

        //id 가 actionForm (Form ,  input type =hidden )
        //class 가 paginate_button 하위요소의 a태그 눌리면 , a의 속성값 href
        //찾고 그값(url) 가져도  actionForm > input type name = pageNum
        //찾은 url을 저장 
      });

      $(".move")
		.on(
				"click",
				function(e) {

					e.preventDefault();
					actionForm
							.append("<input type='hidden' name='bno' value='"
									+ $(this).attr(
											"href")
									+ "'>");
					actionForm.attr("action",
							"/board/get");
					actionForm.submit();

				});
  			
  	var searchForm = $("#searchForm");

	$("#searchForm button").on(
			"click",
			function(e) {

				if (!searchForm.find("option:selected")
						.val()) {
					alert("검색종류를 선택하세요");
					return false;
				}

				if (!searchForm.find(
						"input[name='keyword']").val()) {
					alert("키워드를 입력하세요");
					return false;
				}

				searchForm.find("input[name='pageNum']")
						.val("1");
				e.preventDefault();

				searchForm.submit();

			});

});
  
  
  </script>

  <%@ include file="../include/footer.jsp" %>