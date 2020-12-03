package com.green.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor
@Getter
public class ReplyPageDTO { //PageDTO
	private int replyCnt; //댓글 갯수
	private List<ReplyVO> list; //댓글 목록, 레코드 갯수
}
