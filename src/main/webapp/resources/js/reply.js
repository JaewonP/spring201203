console.log("Reply module.......");
var replyService=(function(){
	function add(reply, callback){
		console.log("reply.........");		
		$.ajax({// 비동기 처리 , asynchronous(비동기) javascript and xml
			type:'post',
			url:'/replies/new',
			data:JSON.stringify(reply),
			contentType: "application/json;charset:utf-8",
			success:function(result, status, xhr){//성공하면 호출되는 콜백
				if(callback){
					callback(result);
				}
			},
			error:function(xhr, status, er){//에러발생시 호출되는 콜백 
				if(error){
					error(er);
				}
			}
		})
	}
	function getList(param, callback, error){
		var bno = param.bno;
		var page = param.page || 1;// 아래와 같이 url을 json형태로 전송
		$.getJSON(
				"/replies/pages/" +bno +"/"+ page+".json", 
			function(data){//응답이 성공시 호출되는 함수 
					//console.log("reply.js "+ data[0].rno);
					for(var i=0; i<data.length;i++){
		    			console.log("reply.js "+ data[i]);
					}
				if(callback){ //data 는 ReplyDTO() 엔티티 타입으로 반환
					//callback(data);
					callback(data.replyCnt, data.list)
				}
			}).fail(function(xhr, status,err){ //응답이 error 발생시 호출됨 
			if(error){
				error();
			}
		});
	}
	function remove(rno,callback, error){
		$.ajax({
			type:'delete',
			url:"/replies/" +rno,
			success :function(deleteResult,status, xhr){
				if(callback){
					callback(deleteResult);
				}    			
			},
			error:function (xhr,status, er){
				if(error){
					error(er);
				}
			}	
		});
	}
	
	
	function update(reply, callback, error) {
		
		console.log("RNO : " + reply.rno);
		
		$.ajax({ //ReplyController의 PatchMapping의 /{rno}로 전달되어 수정됨 
			type: 'put',
			url : '/replies/' + reply.rno,
			data : JSON.stringify(reply),
			contentType :  "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	
	function get(rno, callback, error) {
		$.get("/replies/" + rno + ".json", function(result) {
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err){
			if (error) {
				error();
			}
		});
	}
	
	function displayTime(timeValue) {
		var today = new Date();
		
		var gap = today.getTime() - timeValue;
		
		var dateObj = new Date(timeValue);
		var str = "";
		
		if(gap <(1000 * 60 * 60 *24)) {
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [ (hh>9?'':'0') + hh,  ":", (mi>9?'':'0') + mi, ":", (ss>9?'':'0')+ ss ].join('');
		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1;
			var dd = dateObj.getDate();
			
			return [ yy,  '/', (mi>9?'':'0') + mm, '/', (dd>9?'':'0')+ dd ].join('');
		}
	}
	
	return {
		add:add,
		getList:getList,
		remove:remove,
		update : update,
		get : get,
		displayTime : displayTime
		}; //여기 add키는 get에서 호출하려는 함수명,value(add)는 
	//여기에서 정의된 함수 
})(); //IIFE(선언과 동시에 실행 )
//Immediately(즉석) Invoked(호출) Function Expression(표현식)’