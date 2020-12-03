package com.green.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.green.domain.BoardAttachVO;
import com.green.domain.BoardVO;
import com.green.domain.Criteria;
import com.green.mapper.BoardAttachMapper;
import com.green.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService{
	@Setter(onMethod_=@Autowired)
	private BoardMapper mapper;
	
	
	@Setter(onMethod_=@Autowired)
	private BoardAttachMapper attachMapper;
	
	
//	@Override
//	public List<BoardVO> getList() {
//		//��Ʈ�ѷ����� �ٷ� mybatis�� ���� ���� �ƴ϶�
//		//���񽺷��̾�� ������ �����Ͻ� ������ �����ϰ�
//		//�װ���� DB�� �����ϴ� ���̾�� �������� presentation ���̾� 
//		
//		for(BoardVO i : mapper.getList()) {
//			if(i.getWriter().equals("�׸�"))
//				System.out.println(i.getTitle());
//		}
//		
//		return mapper.getList();
//	}
	

	@Override
	public BoardVO printTitle(Long bno) {
		// TODO Auto-generated method stub
		
		
		return mapper.read(bno);
	}

	@Transactional
	@Override
	public void register(BoardVO board) {
		// TODO Auto-generated method stub
		
		log.info("register...." + board);
		
		Long max = 0L;
		for(int i =0; i< mapper.getList().size(); i++) {
			if(i<mapper.getList().get(i).getBno()) {
				max = mapper.getList().get(i).getBno();
				System.out.println("번호" + max);
			}

		}
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <=0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
		
	}


	@Override
	public BoardVO get(Long bno) {
		// TODO Auto-generated method stub
		return mapper.read(bno);
	}

	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		// TODO Auto-generated method stub
		
		attachMapper.deleteAll(board.getBno());
		
		boolean modifyResult = mapper.update(board) == 1;
		
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		// TODO Auto-generated method stub
		
		attachMapper.deleteAll(bno);
		
		return mapper.delete(bno) == 1;
	}


	@Override
	public List<BoardVO> getList(Criteria cri) {
		// TODO Auto-generated method stub
		log.info("Criteria�� ���񽺿��� ������ ��ü ��ȸ " + cri);
		//cri.setAmount(10);
		//cri.setPageNum(2);
		return mapper.getListWithPaging(cri);
	}


	@Override
	public int getTotal(Criteria cri) {
		// TODO Auto-generated method stub
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		// TODO Auto-generated method stub
		
		log.info("get Attach list by bno"  + bno);
		
		return attachMapper.findByBno(bno);
	}

	


}
