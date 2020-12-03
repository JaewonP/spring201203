<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- 1) 보안관련 추가 -->
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@ include file="../include/header.jsp" %>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header"> 게시글 등록</h1>
    </div>
</div>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">게시글 등록</div>
        </div>
        <div class="panel-body">
            <form action="/board/register" role="form" method="post">
            <!-- 3)보안 관련 csrf 추가 -->
            	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="form-group">
                    <label>제목</label><input class="form-control" name="title">
                </div>
                <div class="form-group">
                    <label>텍스트 영역</label>
                    <textarea class="form-control" rows=3  name="content"></textarea>
                </div>
                <div class="form-group">
                    <label>저자</label><input class="form-control" name="writer" 
                    		value='<sec:authentication property="principal" var="username"/>' readonly="readonly"> <!-- 2) 수정 -->
                </div>
                <button type="submit" class="btn btn-default">전송 버튼</button>
                <button type="reset" class="btn btn-default">초기화 버튼</button>
            </form>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">파일 첨부</div>
            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <input type="file" name="uploadFile" multiple>
                </div>
                <div class='uploadResult'> 
		          <ul>
		          	
		          </ul>
		        </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function (e) {
    	var formObj = $("form[role='form']");
    	  
    	  $("button[type='submit']").on("click", function(e){
    	    
    	    e.preventDefault();
    	    
    	    console.log("submit clicked1)");
    	    
    	    var str = "";
    	    
    	    $(".uploadResult ul li").each(function(i, obj){
    	      
    	    	 console.log("여기도 안찍히는 듯하고 2)");
    	      var jobj = $(obj);
    	      
    	      console.dir(jobj);
    	      console.log("-------------------------");
    	      console.log(jobj.data("filename"));
    	      
    	      
    	      str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
    	      str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
    	      str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
    	      str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
    	      
    	    });
    	    
    	    console.log("여기 문자열이 안찎 히네 3) "+ str);
    	    e.preventDefault();
    	    formObj.append(str).submit();
    	    
    	  });
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
    		console.log("여기가 찍히는가  showUploadResult 3) " +uploadResultArr);
    		if(!uploadResultArr || uploadResultArr.length ==0){return ;}
    		console.log("여기가 찍히는가 4) " +uploadResultArr);
    		var uploadURL = $(".uploadResult ul");
    		console.log("여기가 찍히는가 5) " + uploadURL);
    		var str ="";
            $(uploadResultArr).each(function(i,obj){
            	console.log("여기가 찍히는가 6)  " + obj);
					//image 타입 체크
            	if(obj.image){
            		console.log("여기가 찍히는가 if 문 내의  7)  " + obj.image);
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
        			str += "<img src='/resources/img/1.png'></a>";
        			str += "</div>";
        			str += "</li>";
        		}
            	
            });
            uploadURL.append(str); //변경 
           
        }
    	//교재 560,562  ,x 아이콘을 클릭하면 서버에서 삭제되도록 이벤트 처리 
    	$(".uploadResult").on("click" ,"button",function(e){
    		console.log("delete 파일 ");
    		var targetFile = $(this).data('file'); //<input data-file='a' data-type='file'>
    		var type= $(this).data("type"); //data-uuid = ,data-filename =, data-type= 
    		var targetLi = $(this).closest("li");
    		$.ajax({
    			url:'deleteFile',
    			data:{fileName:targetFile, type:type},
    			dataType:'text',
    			type:'POST',
    			success:function(result){
    				alert(result);
    				targetLi.remove();
    			}
    		});//$.ajax
    	}); //click 이벤트
}); //document.ready();
</script>
<%@ include file="../include/footer.jsp" %>