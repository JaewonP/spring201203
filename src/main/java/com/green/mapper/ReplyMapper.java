package com.green.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.green.domain.Criteria;
import com.green.domain.ReplyVO;

public interface ReplyMapper {
	public int insert(ReplyVO vo);
	public ReplyVO read(Long rno);
	public int delete(Long rno);
	public int update(ReplyVO reply);
	public List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri,
			@Param("bno") Long bno
			); //mybatis에서 Param을 추가 
	public int getCountByBno(Long bno);
}
