<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

    .uploadResult {
        width: 100%;
        background-color: gray;
    }
    
    .uploadResult ul{
        display: flex;
        flex-flow: row;
        justify-content: center;
        align-items: center;
    }
    
    .uploadResult ul li{
        list-style: none;
        padding: 10px;
        align-context: center;
        text-align: center;
    }
    
    .uploadResult ul li img{
        width: 100px;
    }
    
    .uploadResult ul li span {
    	color:white;
    }
    .bigPictureWrapper {
    	position: absolute;
    	display: none;
    	justify-content: center;
    	align-items: center;
    	top:0%;
    	width:100%;
    	height:100%;
    	background-color: gray;
    	z-index: 100;
    	background:rgba(255,255,255,0.5);
    }
    .bigPicture{
    	position: relative;
    	display: flex;
    	justify-content: center;
    	alig-itmes: center;
    }
    .bigPicture img{
    	width:600px;
    }
    
    
</style>
</head>
<body>
<h1>Upload with Ajax</h1>

<div class="uploadDiv">
    <input type="file" name="uploadFile" multiple>
</div>

<div class="uploadResult">
    <ul>
        
    </ul>
</div>

<button id="uploadBtn">UPLOAD</button>

<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script>
	function showImage(fileCallPath) {
		//alert(fileCallPath);
		
		$(".bigPictureWrapper").css("display", "flex").show();
		
		$(".bigPicture")
		.html("<img src='/display?fileName=" + encodeURI(fileCallPath) + "'>")
		.animate({width:'100%', height:'100%'}, 1000);
		
	}

    $(document).ready(function() {
        
        var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
        var maxSize = 5242880; //5MB
        
        //파일 확장자나 크기의 사전처리
        function checkExtension(fileName, fileSize) {
            if(fileSize >= maxSize) {
                alert("파일 사이즈 초과");
                return false;
            }
            
            if(regex.test(fileName)) {
                alert("해당 종류의 파일은 업로드 할 수 없습니다.");
                return false;
                
            }
            
            return true;
        }
        
        var cloneObj = $(".uploadDiv").clone(); //input type = file인 객체가 포함된 div 태그를 복사하고 파일을 업록드 한 뒤 복사된 객체를 div 내에 다시 추가해서 첨부 파일 부분 초기화 
        
        var uploadResult = $(".uploadResult ul");
		function showUploadedFile(uploadResultArr) {
			var str = "";
			$(uploadResultArr).each(function(i, obj) {
				if(!obj.image){
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/"
							+ obj.uuid + "_" + obj.fileName);
                    
                    var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
                    
					str += "<li><div><a href='/download?fileName="+fileCallPath+"'><img src ='/resources/img/attach.png'>" + obj.fileName + "</a>" +"<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>" +"</div></li>";
				} else {//이미지 일 경우 
					//str += "<li>" + obj.fileName + "</li>";
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"
											+ obj.uuid + "_" + obj.fileName);
					//아래의 str 구문에서 data-file의 value는 fileCallPath이고 다른 곳에서 $.data('file')을 하면 
					//fileCallPath를 얻을 수 있음 
					//$.data('type')을 하면 data-type-'file'에서 'file'을 얻을 수 있음 
					//정규 표현식에서 g는 global을 의미하고 모든 패턴을 검색 
					// "\\" 문자열을 "/" 문자열로 대체함 
					var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
					originPath = originPath.replace(new RegExp(/\\/g), "/"); //   \\인 경로를 ㅁ두 /로 바꿔줌 g:global을 뜻하고 모든 패턴을 검색	
					console.log(originPath);
					// 앞에 \ 이 있으면 ",' 를 무시하지 말라 
					str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName=" + fileCallPath + "'></a>" + "<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span>" +"</li>";
				}
			});
			uploadResult.append(str);
		}
		
		$(".bigPictureWrapper").on("click", function(e) {
            $(".bigPicture").animate({
                width:'0%', height: '0%'
            }, 1000);
            setTimeout(() => {
                $(this).hide();
            },1000);
        });
		
        
        $("#uploadBtn").on("click", function(e) {
            var formData = new FormData(); //jquery 이용시 FormData 객체 이용하여 파일 업로드
            var inputFile = $("input[name='uploadFile']");
            
            var files = inputFile[0].files;
            console.log(files);
            
            //add filedate to formadata
            for(var i=0; i<files.length; i++) {
                
                if(!checkExtension(files[i].name, files[i].size)) {
                    return false;
                }
                
                formData.append("uploadFile", files[i]);
            }
            
            $.ajax({
                url: '/uploadAjaxAction', 
                    processData: false,
                    contentType: false, //json인지 정하는것
                    data: formData,
                    type: 'POST',
                    dataType:'json',
                    success: function(result){
                        alert("Uploaded");
                        console.log("컨트롤러에서 에러가 없이 처리되었다는 것(OK)을 와 AttachDTO의 배열(List)을 반환해줌: Uploaded : " + result);
                        
                        console.log
                        showUploadedFile(result);
                        
                        $(".uploadDiv").html(cloneObj.html());
                        //컨트롤러에서 정상으로 오면 여기서 복제한 것을 div에 추가함 
                    }
            }); //$.ajax
        });
        
        $(".uploadResult").on("click", "span", function(e) {
            var targetFile = $(this).data("file");
            var type = $(this).data("type");
            console.log("targetFile");
            
            $.ajax({
                url: '/deleteFile',
                data: {fileName: targetFile, type: type},
                dataType: 'text',
                type: 'POST',
                    success: function(result) {
                        alert(result);
                        
                        if(type == "image") {
                            $(this).parent().remove();
                        }
                        else if {
                            $(this).parent().parent().remove();
                        }
                        
                    }
            });
        });
        
    });
    
</script>

</body>
</html>