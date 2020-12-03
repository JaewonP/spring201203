package com.green.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.green.domain.Criteria;
import com.green.domain.ReplyPageDTO;
import com.green.domain.ReplyVO;
import com.green.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/replies/")
@RestController
@Slf4j
@Log4j
@AllArgsConstructor
public class ReplyController {
	
	private ReplyService service;
	
	@PostMapping(value = "/new", consumes ="application/json", produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
		log.info("ReplyVO: " + vo);
		
		int insertCount = service.register(vo);
		log.info("Reply Insert Count : " + insertCount);
		
		return insertCount == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
						:new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		//���� ������ ó�� 
	}
	
//	@GetMapping(value = "/pages/{bno}/{page}", produces = {
//			MediaType.APPLICATION_XML_VALUE,
//			MediaType.APPLICATION_JSON_UTF8_VALUE
//	})
//	public ResponseEntity<List<ReplyVO>> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno)
//	 {
//			log.info("getList.....................");
//			Criteria cri = new Criteria(page, 10);
//			log.info(cri.getKeyword());
//			return new ResponseEntity<>(service.getList(cri, bno), HttpStatus.OK);
//		}
	
	@GetMapping(value = "/pages/{bno}/{page}", produces = {
			MediaType.APPLICATION_XML_VALUE,
			MediaType.APPLICATION_JSON_UTF8_VALUE
	})
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno)
	 {
			log.info("getList.....................");
			Criteria cri = new Criteria(page, 10);
			log.info(cri.getKeyword());
			return new ResponseEntity<>(service.getListPage(cri, bno), HttpStatus.OK);
		}
	
	@GetMapping(value = "/{rno}", produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {
		log.info("get : " + rno);
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}
	
	@DeleteMapping(value="/{rno}", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno) {
		log.info("remove :" + rno);
		return service.remove(rno) == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
						: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
//	@PatchMapping(value ="/{rno}", consumes ="application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
//	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {
//		vo.setRno(3L);
//		log.info("댓글 컨트롤러에서의 수정 " + rno + "vo : " + vo);
//		return service.modify(vo) == 1 ?
//				new ResponseEntity<>("success", HttpStatus.OK) :
//					new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
//	}
	
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH}, 
			value = "/{rno}",
			consumes = "application/json",
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(
			@RequestBody ReplyVO vo,
			@PathVariable("rno") Long rno) {
		vo.setRno(rno);
		log.info("rno: " + rno);
		
		return service.modify(vo) == 1 ?
				new ResponseEntity<>("success", HttpStatus.OK) :
					new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
	}

