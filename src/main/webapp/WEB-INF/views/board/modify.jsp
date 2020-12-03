<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
        <h1 class="page-header">게시글 수정 </h1>
    </div>
</div>
<div class="bigPictureWrapper">
	<div class="bigPicture"></div>
</div>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Files</div>
            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <input type="file" name="uploadFile" multiple="multiple">
                </div>
                <div class="uploadResult">
                    <ul>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading"> 게시글 수정 </div>

            <div class="panel-body">
                <form action="/board/modify" role="form" method="post">
                    <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
                    <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
                    <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
                    <input type="hidden"  name="keyword" value='<c:out value="${cri.keyword}"/>'>
                    <div class="form-group">
                        <label>번호</label>
                        <input type="text" class="form-control" name="bno"
                            value='<c:out value="${board.bno}"/>' 
                                readonly= "readonly">
                    </div>
                    <div class="form-group">
                        <label>제목</label>
                        <input type="text" class="form-control" name="title"
                            value='<c:out value="${board.title}"/>'>
                    </div>
                    <div class="form-group">
                        <label>내용</label>
                        <textarea class="form-control" rows="3" name="content">
                            <c:out value="${board.content}"/>
                        </textarea>
                    </div>
                    <div class="form-group">
                        <label>저자</label>
                        <input type="text" class="form-control" name="writer"
                            value='<c:out value="${board.writer}"/>' 
                                readonly= "readonly">
                    </div>
                    <div class="form-group">
                        <label>등록일</label>
                        <input type="text" class="form-control" name="regDate"
                            value='<fmt:formatDate  pattern="yyyy/MM/dd" 
                                value="${board.regDate}"/>' readonly="readonly">
                    </div>
                    <div class="form-group">
                        <label>수정일</label>
                        <input type="text" class="form-control" name="updateDate"
                            value='<fmt:formatDate  pattern="yyyy/MM/dd" 
                                value="${board.updateDate}"/>' readonly="readonly">
                    </div>
                    <!-- 여기의 data-oper의 oper는 다른 곳에서 jquery로 value(modify/remove/list) 를 얻음  -->
                    <button type="submit" data-oper="modify" class="btn btn-default">수정</button>
                    <button type="submit" data-oper="remove" class="btn btn-danger">삭제</button>
                    <button type="submit" data-oper="list" class="btn btn-info">목록</button>
                </form>
            </div><%--panel-body의 끝 --%>
        </div><%--panel의 끝 --%>
    </div><%-- col-lg-12의 끝 --%>
</div><%-- row의 끝 --%>
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
                    console.log("여기가 찍히는가 if 문 내의  7)  " + attach.image);
                    var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);
                    str += "<li ";
                    str += "data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.image+"' ><div>";
                    str += "<span> "+ attach.fileName+"</span>";
                    str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' "; 
                    str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";            
                    str += "<img src='/board/display?fileName="+fileCallPath+"'>";
                    str += "</div>";
                    str += "</li>";
                }else{
                    var fileCallPath =  encodeURIComponent( attach.uploadPath+"/"+ attach.uuid +"_"+attach.fileName);			      
                    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
                        
                    str += "<li ";
                    str += "data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.image+"' ><div>";
                    str += "<span> "+ attach.fileName+"</span>";
                    str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' ";
                    str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                    str += "<img src='/resources/img/1.png'></a>";
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
    $(document).ready(function(){ //590p
        var formObj = $("form"); //form 태그 찾아서 jquery 객체화함 
        $('button').on("click", function(e){ //버튼이 눌리면 
            e.preventDefault();//이벤트 중지시키고 
            var operation = $(this).data("oper"); //modify.jsp에서의 정보를 얻어옴
            console.log(operation);
            if(operation === 'remove'){
                formObj.attr("action","/board/remove"); //form tag의 action 값을 변경
            } else if(operation === 'list'){
                //리스트 목록으로 이동 
                formObj.attr("action" ,"/board/list")
                	.attr("method" ,"get"); //action과 method 변경함 
                var pageNumTag =$("input[name='pageNum']").clone();
                var amountTag = $("input[name='amount']").clone();
                var keywordTag = $("input[name='keyword']").clone();
                var typeTage = $("input[name='type']").clone();
                formObj.empty();//form 태그의 내용을 다 비움 
                formObj.append(pageNumTag);
                formObj.append(amountTag);
                formObj.append(keywordTag);
                formObj.append(typeTage);//추가 
                //return ;
            } 
            else if(operation === 'modify'){
                console.log("수정 전송 버튼 클릭");
                var str = "";
                $(".uploadResult ul li").each(function(i, obj){
                    var jobj = $(obj);
                    
                    console.dir(jobj);
                    str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
                    str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
                    str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
                    str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
                });                
                formObj.append(str).submit();//input 태그를 hidden으로 숨겨서 컨트롤러로 전송함
            }
			formObj.submit();
        });
        //588P
        $(".uploadResult").on("click", "button", function(e){
            console.log("파일 삭제");
            if(confirm("Remove this file? ")){
                var targetLi = $(this).closest("li");
                targetLi.remove();
            }
        });
        
        //첨부파일 추가        
        var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
        var maxSize = 5242880; //5MB
        
        function checkExtension(fileName, fileSize){
            if(fileSize >= maxSize){
                alert("파일 사이즈 초과");
                return false;
            }
            if(regex.test(fileName)){
            alert("해당 종류의 파일은 업로드할 수 없습니다.");
            return false;
            }
            return true;
        }
        
        $("input[type='file']").change(function(e){
            var formData = new FormData();
            var inputFile = $("input[name='uploadFile']");
            var files = inputFile[0].files;
            for(var i = 0; i < files.length; i++){
                if(!checkExtension(files[i].name, files[i].size) ){
                    return false;
                }
                formData.append("uploadFile", files[i]);
            }
            console.log("여기는 들어오는데 ? ")
            
            //파일이 변경되면 여기가 실행되는데? 
            $.ajax({
                    url: '/board/uploadAjaxAction',
                    processData: false, 
                    contentType: false,
                    data: formData,
                    type: 'POST',
                    dataType:'json',
                    success: function(result){
                        console.log("여기 성공결과가 나오나요 result? "+ result); 
                        showUploadResult(result);
                }
            }); //$.ajax
    	});  //change 이벤트
        function showUploadResult(uploadResultArr){
            if(!uploadResultArr || uploadResultArr.length ==0){return ;}
            var uploadURL = $(".uploadResult ul");
            var str ="";
            $(uploadResultArr).each(function(i,obj){
                    //image 타입 체크
                if(obj.image){
                    var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
                    str += "<li data-path='"+obj.uploadPath+"'";
                    str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
                    str +" ><div>";
                    str += "<span> "+ obj.fileName+"</span>";
                    str += "<button type='button' data-file=\'"+fileCallPath+"\' "
                    str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                    str += "<img src='/board/display?fileName="+fileCallPath+"'>";
                    str += "</div>";
                    str += "</li>";
                }else{
                    var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
                    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
                        
                    str += "<li "
                    str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
                    str += "<span> "+ obj.fileName+"</span>";
                    str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' " 
                    str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                    str += "<img src='/resources/img/attatch.PNG'></a>";
                    str += "</div>";
                    str += "</li>";
                }
            });
            uploadURL.append(str); //변경 
        }
    });
</script>