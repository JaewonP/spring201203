package com.green.controller;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.nio.file.Files;
import java.io.File;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.green.domain.BoardAttachVO;
import com.green.domain.BoardVO;
import com.green.domain.Criteria;
import com.green.domain.PageDTO;
import com.green.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	//서비스 주입
	private BoardService service; //교재 213상단에 적혀있음 ,AllArg~~,또는 setter
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) { return; }
		
		log.info("delete attach files....");
		log.info(attachList+"");
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
				
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\upload\\" + attach.getUploadPath()+ "\\s_" + attach.getUuid()+ "_" + attach.getFileName());
					
					Files.delete(thumbNail);
				}
			}catch(Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}
	
	@GetMapping("/list")
	public void list(Criteria crit, Model model) {
		log.info("컨트롤러에서 list " + crit);
		model.addAttribute("list", service.getList(crit));
		//model.addAttribute("pageMaker", new PageDTO(crit, 123));
		
		int total = service.getTotal(crit);
		System.out.println("total =" + total);
		
		model.addAttribute("pageMaker", new PageDTO(crit, total));
	}
		
	
//	@GetMapping("/register")
//	public String register1() {//board 폴더 1.jsp
//		 
//		return "/board/register";
//	}
	
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register() {
		return "/board/register";
	}
	
	
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("==================================================");
		log.info("컨틀롤러에서 등록 " +  board);
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> System.out.println(attach));
		}
		
		log.info("==================================================");
		service.register(board);//추가 
		rttr.addFlashAttribute("result" ,board.getBno());//1회용 저장 
		return "redirect:/board/list";//교재 216, response.sendRidirect호출
	}
	
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		System.out.println("getAttachList+ " +bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	
	@GetMapping({"/get", "/modify"}) //교재 218
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("crit") Criteria crit, Model model) {
		log.info("컨틀롤러에서의 /get or /modify");
		model.addAttribute("board", service.get(bno));
	}
	
	@PostMapping("modify") //post 방식의 수정
	public String modify(BoardVO board , Criteria crit, RedirectAttributes rttr) {
		log.info("컨트롤러에서의 수정 "+ board);
		if(service.modify(board)) { //성공하면 
			rttr.addFlashAttribute("result", "success");
		}
		/*
		 * rttr.addAttribute("pageNum", crit.getPageNum()); rttr.addAttribute("amount",
		 * crit.getAmount()); rttr.addAttribute("type", crit.getType());
		 * rttr.addAttribute("keyword", crit.getKeyword());
		 */
		return "redirect:/board/list" + crit.getListLink();//list에서 result에 success정보를 가지고 있음
	}
	
	@PostMapping("remove") //post방식의 삭제 
	public String remove(@RequestParam("bno") Long bno, Criteria crit,
				RedirectAttributes rttr) {
		log.info("컨트롤러에서의 삭제 "+ bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		if(service.remove(bno)) {
			
			//delete Attach Files
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "success");
		}
		/*
		 * rttr.addAttribute("pageNum", crit.getPageNum()); rttr.addAttribute("amount",
		 * crit.getAmount()); rttr.addAttribute("type", crit.getType());
		 * rttr.addAttribute("keyword", crit.getKeyword());
		 */
		return "redirect:/board/list" + crit.getListLink();
	}
	
	
}
