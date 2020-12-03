<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<ul>
	<c:forEach items="${lists}" var = "i">
		<li>댓글번호 <c:out value="${i.rno}"/>
			게시글번호 <c:out value="${i.bno}"/>
			댓글 작성자 <c:out value="${i.replyer}"/>
			댓글 내용 <c:out value="${i.reply}"/>
			댓글 작성일<fmt:formatDate pattern="yyyy-MM-dd" 
                          value="${i.replyDate}"/>
            댓글 수정일 <fmt:formatDate pattern="yyyy-MM-dd" 
                          value="${i.updateDate}"/>
		</li>
	</c:forEach>
	</ul>
</body>
</html>