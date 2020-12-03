package com.green.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.green.domain.BoardVO;
import com.green.domain.Criteria;

public interface BoardMapper {
	// xml �ȸ��鋚 ���°� @Select("")
	//@Select("select * from tbl_board where bno > 0")
	public List<BoardVO> getList();
	public void insert(BoardVO board);
	public void insertSelectKey(BoardVO board);
	//���⿡ �ش��ϴ� xml ������ �Ƿ���(sql���� ��)
	
	public BoardVO read(Long bno);
	public int delete(Long bno);
	
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public int update(BoardVO board);
	
	public int getTotalCount(Criteria cri);
	
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}
