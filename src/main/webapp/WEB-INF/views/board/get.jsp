<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>  
<%@ include file="../include/header.jsp" %>
<style>
    .uploadResult{
        width:1000px;
        background-color: gray;
    }
    .uploadResult ul{
        display:flex;
        flex-flow:row;
        justify-content:center;
        align-items:center;
    }
    .uploadResult ul li{
        list-style:none;
        padding:10px;
        align-content: center;
        text-align: center;
    }
    .uploadResult ul li img{
        width:200px;
    }
    .uploadResult ul li span{
        color: white;
    }
    .bigPictureWrapper{
        position: absolute;
        display: none;
        justify-content: center;
        align-items: center;
        top: 0%;
        width: 100%;
        height: 100%;
        background-color: gray;
        z-index: 100;
        background:rgba(255, 255, 255, 0.5);
    }
    .bigPicture{
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .bicPicture img{
        width: 600px;
    }
</style>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header"> 게시글 </h1>
    </div>
</div>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">File</div>
                <div class="panel-body">
                	<div class="uploadResult">
                		<ul>
                			
                		</ul>
                	</div>
                    <div class="form-group">
                        <label>Bno</label> <input class="form-control" name='bno' value='<c:out value="${board.bno }"/>' readonly="readonly">
                    </div>

                    <div class="form-group">
                        <label>Title</label> <input cl ass="form-control" name='title' value='<c:out value="${board.title }"/>' readonly="readonly">
                    </div>

                    <div class="form-group">
                        <label>Text area</label> <textarea class="form-control" rows="3" name='content' readonly ="readonly"><c:out value="${board.content }"/> </textarea>
                    </div>

                    <div class="form-group">
                        <label>Writer</label> <input class="form-control" name='writer' value='<c:out value="${board.writer }"/>' readonly="readonly">
                    </div>
<%--                     <button data-oper='modify' class="btn btn-info" 
                        onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">Modify</button>
                    <button data-oper='list' class="btn btn-primary"
                        onclick ="location.href='/board/list'">List</button> --%>
                       <sec:authentication property="principal" var="pinfo"/>
                       <sec:authorize access="isAuthenticated()">
                       	<c:if test="${pinfo.username eq board.writer}">
                       		<button data-oper='modify' class="btn btn-default">수정</button>
                       	</c:if>
                       </sec:authorize>
                     <button data-oper='list' class="btn btn-default">목록</button>
                    <form id='operForm' action="/board/modify" id="operForm" method="get">
                        <input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>'>
                        <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
                        <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
                        <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
                        <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
                    </form>
                </div>
        </div>
    </div>
</div>
<div class="row col-lg-12"> <!--  교재 414페이지 -->
	<!-- panel --> 
	<div class="panel panel-default">
		<div class="panel-heading"><i class="fa fa-comments fa-fw">댓글</i></div>
		<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>댓글 등록</button>
	</div>
	<!-- panel-body-->
	<div class="panel-body">
		<ul class="chat">
			<li class="left clearfix" data-rno="12">
				<div>
					<div class="header">
						<strong class="primary-font"></strong>
							<small class="pull-right text-muted">2020-11-20 16:45</small>
						</div>
						<p> 잘했어요 </p>
				</div>
			</li>
			<!-- end-reply -->
		</ul>
		<!-- end ul -->
	</div>
	<!-- end panel .chat-panel  -->
	<!-- panel-footer -->
	<div class="panel-footer"></div>
</div>
	<!-- end row -->
<div class ='bigPictureWrapper'>
	<div class = 'bigPicture'>
	</div>
</div>
<!-- modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class =modal-dialog>	
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times</button>
				<h4 class="modal-title" id="myModalLabel">Modal 댓글 </h4>
			</div><!-- modal header --> 
			<div class="modal-body">
				<div class="form-group">
					<label>댓글</label>
					<input class="form-control" name="reply" value="New Reply!!!">
				</div>
				<div class="form-group">
					<label>댓글작성자</label>
					<input class="form-control" name="replyer" value="replyer">
				</div>
				<div class="form-group">
					<label>댓글작성일</label>
					<input class="form-control" name="replyDate" value="">
				</div>
			</div> <!-- modal body -->
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning">수정 </button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger">삭제 </button>
				<button id="modalRegisterBtn" type="button" class="btn btn-primary">등록 </button>
				<button id="modalCloseBtn" type="button" class="btn btn-default">닫기</button>
			</div> <!-- modal footer -->
		</div>  <!-- modal content  -->
	</div> <!-- modal dialog  -->
</div> <!-- modal   -->
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
	$(document).ready(function(){
		(function(){
			var bno = '<c:out value="${board.bno}"/>';
			$.getJSON("/board/getAttachList", {bno:bno}, function(arr){
				console.log(arr);
				//controller에서 성공하면 여기에서 추가된 첨부 파일의 목록을 크롬 개발자 도구에서 확인 가능
				str = "";
				$(arr).each(function(i, attach){
					//이미지 타입 체크
					if(attach.fileType){
						var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" 
								+ attach.fileName);
	                    
	                    str += "<li data-path='" + attach.uploadPath + "'";
	                    str += "data-uuid='" +attach.uuid+"' data-fileName='" 
	                    	+attach.fileName+"' data-type='" +attach.fileType+"'><div>";
	                    str += "<img src='/board/display?fileName=" + fileCallPath + "'>";
	                    str += "</div>";
	                    str += "</li>";
					}
					else {
	                    var fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_"
	                    		+ attach.fileName); 
	                    var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

	                    str += "<li data-path='" + attach.uploadPath + "' data-uuid='" +attach.uuid+"' data-fileName='" 
                    		+attach.fileName+"' data-type='" +attach.fileType+"'><div>";
                    	str += "<span>" + attach.fileName + "</span><br/>";
	                    str += "<img src='/resources/img/1.png'>";
	                    str += "</div>";
	                    str += "</li>";
	                }
				});
				$(".uploadResult ul").html(str);
			});//end getjson
		})();//end function
	})
</script>
<script>
    $(document).ready(function(){
		var operForm = $("#operForm");
    
		//수정 버튼이 눌리면 from tag의 action을 /board/modify로 변경하여 전송
		$("button[data-oper='modify']").on("click", function(e){
			operForm.attr("action", "/board/modify").submit();
		});

		//목록 버튼이 눌리면 form tag의 action을 /board/list로 변경하여 전송
		$("button[data-oper='list']").on("click", function(e){ 
			operForm.find("#bno").remove(); //목록 전체를 보여주어야 하므로 bno제거ㅡ ㅜ
			operForm.attr("action", "/board/list").submit();
		});

		console.log(replyService); // 추가 후 console에서 확인
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");// div 태그의  class이름이 chat인 DOM 찾고 
		showList(1); //함수 호출  <!-- 교재 415 페이지 -->
		function showList(page){//수정을 해야함 
			replyService.getList({bno:bnoValue,page:page||1},function(replyCnt ,list){//댓글 전체 목록 조회
				console.log("댓글 갯수 get.jsp에서 getList 호출함수내에서 댓글 갯수  " +replyCnt);
				console.log("댓글 갯수 get.jsp에서 getList 호출함수내에서 댓글 목록  " +list);
				//마지막 페이지일경우 (-1) 
				if(page==-1){
					pageNum = Math.ceil(replyCnt/10.0);
					showList(pageNum);//여기서 pageNum이 기존에 1이던것이 여기 pageNum의 값이 전달됨
 					return; //마지막 페이지 이면 함수 종료함 
				}
				var str="";
				if(list==null || list.length==0 ){
					replyUL.html("");
					return ;
    			}; //if문
				for(var i=0, len= list.length || 0; i<len; i++){
					str+= "<li calss='left clearfix' data-rno='" +list[i].rno+"'>";
					str+= " <div><div class='header'><strong class='primary-font'>"
					+list[i].replyer+"</strong>";
					str += "   <small class='pull-right text-muted'>" +replyService.displayTime(list[i].replyDate)
						+"</small></div>";
					str+=" <p>"+list[i].reply+"</p></div></li>";
				}; //for문 
				replyUL.html(str);
				showReplyPage(replyCnt);//아래 정의된 함수 호출 (441페이지 )
			});//end getList , 첫번쨰 파라미터는  literal 객체 ,두번째 파라미터는 익명함수 
		}; //end showList
		//440페이지 코드 추가 
		var pageNum =1;
		var replyPageFooter = $(".panel-footer");
		//이전  BoardController에서 PageDTO의 PageMaker 페이지 계산 자바의 대체용 
		
		function showReplyPage(replyCnt){  //페이지 계산 함수 정의 
			var endNum = Math.ceil(pageNum/10.0)*10;
			var startNum =endNum -9;

			var prev = startNum !=1;
			var next =false;

			if(endNum*10>=replyCnt){
				endNum = Math.ceil(replyCnt/10.0);
			}
			if(endNum*10<replyCnt){
				next =true;
			}

			var str = "<ul class='pagination pull-right'>";
			if(prev){
				str+="<li class='page-item'><a class='page-link' href ='" +(startNum-1) + "'>이전 페이지</a></li>";
			}
			for(var i=startNum ;i<=endNum ;i++){
				var active =pageNum == i ? "active":"";
				str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
			}
			if(next){
				str+="<li class='page-item'><a class='page-link' href ='" +(endNum+1) + "'>다음 페이지</a></li>";
			}
			str += "</ul></div>";
			console.log(str);
			replyPageFooter.html(str); //다 하신분은 확인해보세요 
		}


    	var modal = $(".modal"); //jquery 변수 및 객체 
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		
		$("#modalCloseBtn").on("click", function(e){//모달 닫기 버튼이 눌리면
			modal.modal('hide');//모달창 숨기기
		});
		
		$("#addReplyBtn").on("click", function(e){ //신규 댓글 등록 버튼이 눌리면 
			console.log("잘들어오나");
			modal.find("input").val("");//공백으로 초기화
			modalInputReplyDate.closest("div").hide();//가장 가까운(closest ) div 태그를 찾아서 숨겨라
			modal.find("button[id != 'modalCloseBtn' ]").hide(); //close버튼을 제외하고 숨겨라 
			modalRegisterBtn.show(); //등록 버튼을 보여라 
			$(".modal").modal("show");
		})

		//모달 등록 버튼이 눌리면 
		modalRegisterBtn.on("click", function(e){
			console.log("모달이 잘들어오나"); //추가 
			var reply= { // 리터럴 객체를 저장 
				reply:modalInputReply.val(),
				replyer:modalInputReplyer.val(),
				bno:bnoValue
			};
			replyService.add(reply,function(result){ //댓글 추가시 
				//위에서 tag로부터 jquery를 이용하여 정보를 가져오고 그 정보를 reply 객체에 저장하고 ,저장된 reply 객체를 add함수 에전달 
				alert(result);//여기에서 controller에서 정상동작하여 callback이 호출됨 
				modal.find("input").val("");//모달의 input 태그의 값을 초기화(비우기)
				modal.modal("hide"); //모달 숨기기 ,보이기는 modal("show")
				//showList(1); // 댓글 등록후 위에서 정의한 showList 내부 함수 replyerService.getList() 호출되어 전체 댓글(데이터/레코드)를 다 가져욤
				showList(-1);//마지막 페이지를 의미하는 -1을 pageNum으로 전달함 
			});
		});

		
	    //댓글 조회 클릭 이벤트 처리시 부모(.chat/ul) 아래의 li 태그를 누르면 
		$(".chat").on("click","li", function(e){
			var rno = $(this).data("rno");// data-rno의 정보에서 rno 정보만 가져와서 그에 대응되는 value
			console.log("1)여기 댓글을 누르면 들어와야 함 " + rno);
			replyService.get(rno, function(reply){
				console.log("5) get 함수의 두 번째 파라미터(콜백함수)에 들어오나? " + rno)
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate))
					.attr("readonly", "readonly");
				modal.data("rno", reply.rno);
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();

				$(".modal").modal("show");
			});
		});
    
		replyPageFooter.on("click", "li a", function(e){//li 태그로 만든 페이지 번호를 누르면
			e.preventDefault();
			console.log("페이지가 눌렸어요");

			var targetPageNum = $(this).attr("href");
			//this는 누른 페이지 li 태그이고 이 때의 li 태그의 href 속성을 얻어옴 href = "3(페이지)"

			console.log("targetPageNum: " + targetPageNum);

			pageNum = targetPageNum;
			showList(pageNum);
		});
		
		modalModBtn.on("click", function(e){//모달 수정 버튼을 누르면
			var reply = {rno:modal.data("rno"), reply:modalInputReply.val()};
			replyService.update(reply, function(result){
				alert(result);
				modal.modal("hide");//모달 숨기기
				showList(pageNum);//전체 데이터 가져오는 함수 호출 시 페이지 번호 전달하여 가져옴
			});
		});

		modalRemoveBtn.on("click", function(e){//모달 삭제 버튼을 누르면
			var rno = modal.data("rno");
			replyService.remove(rno, function(result) {
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			})
		});//4장 완료	   
		$(".uploadResult").on("click", "li", function(e){
			console.log("여기 잘 들어오나1)  view image");
			var liObj = $(this);
			var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename")); //? 
			if(liObj.data("type")){
				console.log("if 문 4) " , path , liObj.data("type") );
				showImage(path.replace(new RegExp(/\\/g), "/"));
			} else {
				console.log("else 문 5) " , path , liObj.data("type") );
				//download
				self.location = "/board/download?fileName=" +path;
				console.log(" self.location 4) " , self.location);
			}		
		});
		function showImage(fileCallPath){
			console.log("showImage 함수 내  3) " , fileCallPath);
			alert(fileCallPath);
			$(".bigPictureWrapper").css("display", "flex").show();
			
			$(".bigPicture")
				.html("<img src='/board/display?fileName=" + fileCallPath+"'>")
				.animate({width:'100%' ,height:'100%'} ,1000);
		}
		
		//577p , 원본 이미지 창 닫기
		$(".bigPictureWrapper").on("click",function(e){
			console.log("여기는 언제 들어오나 " , e.target, "그렇다면 this 는 " +$(this).find('img').attr("src"));//Event 객체의 property target
			$(".bigPicture").animate({width:'0%',height:'0%'} ,1000);
			setTimeout(function(){
				$(".bigPictureWrapper").hide();
			}, 1000);
		})
    }); //document ready 의 끝
    
</script>
<%@include file="../include/footer.jsp"%>
</body> 
</html>               