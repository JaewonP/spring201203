package com.green.service;

import java.util.List;

import com.green.domain.BoardAttachVO;
import com.green.domain.BoardVO;
import com.green.domain.Criteria;

public interface BoardService {
	//public List<BoardVO> getList();
	public BoardVO printTitle(Long bno);
	// ���ڰ� "�׸�"�� ���� ������ �ֿܼ� ����ϴ� ��� 
	public void register(BoardVO board);
	public BoardVO get(Long bno);
	public boolean modify(BoardVO board);
	public boolean remove(Long bno);
	
	public List<BoardVO> getList(Criteria cri);

	public int getTotal(Criteria cri);
	
	public List<BoardAttachVO> getAttachList(Long bno);
	
}
