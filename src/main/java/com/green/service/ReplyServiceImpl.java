package com.green.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.green.domain.Criteria;
import com.green.domain.ReplyPageDTO;
import com.green.domain.ReplyVO;
import com.green.mapper.BoardMapper;
import com.green.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ReplyServiceImpl implements ReplyService{
	@Setter(onMethod_=@Autowired)
	private ReplyMapper mapper;
	
	@Setter(onMethod_=@Autowired)
	private BoardMapper boardMapper;
	
	@Transactional
	@Override
	public int register(ReplyVO vo) {
		log.info("댓글 서비스에서의 등록 " + vo);
		boardMapper.updateReplyCnt(vo.getBno(), 1);
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) {
		log.info("댓글 서비스에서의 데이터 하나 조회 " + rno);
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		log.info("댓글 서비스에서의  수정  " + vo);
		return mapper.update(vo);
	}

	@Transactional
	@Override
	public int remove(Long rno) {
		log.info("댓글 서비스에서의 삭제 " + rno);
		
		ReplyVO vo = mapper.read(rno);
		
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.delete(rno);
	}
	

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		log.info("댓글 서비스에서의 전체 데이터 조회  " + bno + "criteria는 " +cri);
		return mapper.getListWithPaging(cri, bno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		// TODO Auto-generated method stub
		int count = mapper.getCountByBno(bno);
		List<ReplyVO> list = mapper.getListWithPaging(cri, bno);
		System.out.println("댓글 서비스에서 페이지로 조회 시의 갯수" + count + "목적은" + list);
		
		return new ReplyPageDTO(count, list);
		//위에서의 값을 ReplyPageDTO의 생성자의 파라미터로 전달하여 객체 생성한 것을 반환 
	}

}
