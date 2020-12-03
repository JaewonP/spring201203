package com.green.mapper;

import java.util.List;

import com.green.domain.BoardAttachVO;

public interface BoardAttachMapper {

	public void insert(BoardAttachVO vo);
	
	public void delete(String uuid);
	
	public List<BoardAttachVO> findByBno(Long bno); //게시글 번호로 첨부파일 검색 
	
	public void deleteAll(Long bno);
	
	public List<BoardAttachVO> getOldFiles();
	
}
