package com.green.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	//JPA(java persistent API(@Entity))
	private Long bno;
	private String title;
	private String content;
	private String writer;
	private Date regDate;
	private Date updateDate;
	private int replyCnt; // 댓글 갯수
	
	
	private List<BoardAttachVO> attachList; //첨부파일 여러개가 하나의 게시글에 연결됨 
}
