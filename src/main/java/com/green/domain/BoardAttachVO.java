package com.green.domain;

import lombok.Data;

@Data
public class BoardAttachVO {

	
	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType; //이미지인지 아닌지
	
	private Long bno; // 게시글 번호 0
}
