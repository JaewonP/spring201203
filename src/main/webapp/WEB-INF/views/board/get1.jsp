<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../include/header.jsp" %>
    <div class="row">
        <div class="col-lg-12">
            <h class="page-header"> 게시글 조회</h>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">게시글 조회 페이지</div>
                <div class="panel-body">
                    <div class="form-group">
                        <label>번호</label><input type="text" class="form-control" 
                            name="bno" value='<c:out value="${board.bno}"/>' readonly='readonly'>
                    </div>
                    <div class="form-group">
                        <label>제목</label><input type="text" class="form-control" 
                            name="title" value='<c:out value="${board.title}"/>' readonly='readonly'>
                    </div>
                    <div class="form-group">
                        <label>내용</label>
                        <textarea class="form-control" rows="3" name="content" readonly="readonly">
                            <c:out value="${board.content}"/></textarea>
                    </div>
                    <div class="form-group">
                        <label>저자</label><input type="text" class="form-control" 
                            name="writer" value='<c:out value="${board.writer}"/>' readonly='readonly'>
                    </div>
                    <button data-oper="modify" class="btn btn-info"
                        onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">
                    수정</button>
                    <button data-oper="list" class="btn btn-primary" 
                       >목록</button>
                    <form action="/board/modify" id="operForm" method="get">
                        <input type="hidden" id="bno" name="bno" 
                            value='<c:out value="${board.bno}"/>'>
                    </form>
                </div> <!-- end of panel-body -->
            </div> <!-- end of panel -->
        </div> <!-- end of col-lg-12 -->
    </div> <!-- end of row -->
    <script>
        $(document).ready(function(){
            var operForm = $("#operForm");

            //수정 버튼이 눌리면  form tag의 action을 /board/modify로 변경하여 전송
            $("button[data-oper='modify']").on("click" , function(e){
                operForm.attr("action" , "/board/modify").submit();
            });
            //목록 버튼이 눌리면  form tag의 action을 /board/list로 변경하여 전송
            $("button[data-oper='list']").on("click" , function(e){
                operForm.find("#bno").remove(); //목록 전체를 보여주어야 하므로 bno제거 
                operForm.attr("action" , "/board/list").submit();
            })
        })
    </script>
<%@ include file ="../include/footer.jsp" %>