package com.green.service;

import java.util.List;

import com.green.domain.Criteria;
import com.green.domain.ReplyPageDTO;
import com.green.domain.ReplyVO;

public interface ReplyService {
	public int register(ReplyVO vo);
	public ReplyVO get(Long rno);
	public int modify(ReplyVO vo);
	public int remove(Long rno);
	public List<ReplyVO> getList(Criteria cri ,Long bno);
	
	public ReplyPageDTO getListPage(Criteria cri, Long bno);
}
