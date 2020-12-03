package com.green.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.xml.crypto.URIDereferencer;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.green.domain.AttachFileDTO;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Slf4j
public class UploadController {
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info(" 업로드 form  컨트롤러에 들어왔어요 !! ");
	}
	
	//form tag에서 선택한 파일이 배열에 추가되고 현재 한글이 적용안되므로 파일명이 영문이나 숫자파일로 테스트 
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile , Model model) {
		String uploadFolder ="c:\\upload";
		for(MultipartFile multipartFile :uploadFile) {
			log.info("---------------------------");
			log.info("업로드 파일명 : " +multipartFile.getOriginalFilename());//파일명 가져오는 메서드 
			log.info("업로드 파일 크기는 "  +multipartFile.getSize()) ;//파일크기 가져오는 메서드 
			File saveFile = new File(uploadFolder ,multipartFile.getOriginalFilename());//첫번째 파라미터(폴더),두번째 파라미터(파일명)
			//객체 생성시 2개의 파라미터를 이용하여 File 객체 생성 
			//file 및 database 접근시 try catch문 적용함 
			try {
				multipartFile.transferTo(saveFile);//파일 저장 
				
			}catch(Exception e) {
				log.error(e.getMessage());
			}//end catch
		}//end for 
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("업로드 ajax");//uploadAjax.jsp파일 생성하여 안녕하세요 
	}
	//오늘 날짜의 경로를 문자열로 생성 
	//생성된 경로는 폴더 경로로 수정된뒤 반환 
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date  date = new Date();
		String str = sdf.format(date);
		System.out.println("여기서 문자열은 무언가? " +str);
		return str.replace("-", File.separator); //문자열에서  "-"를 기준으로 분리(separator/분리자) 함
	}
	//특정 파일이 이미지 파일인지 아닌지 체크함 
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image"); //image로 시작하면 true(이미지),그렇지않으면 false(이미지 아님)
		} catch(IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	@PostMapping(value="/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		log.info("update ajax post...................");
		List<AttachFileDTO> list = new ArrayList<AttachFileDTO>();//타입 추론이 가능 
		String uploadFolder ="c:\\upload";
		String uploadFolderPath = getFolder() ;// 4) 변경 
		File uploadPath  = new File(uploadFolder, uploadFolderPath); //기존에 있던 코드 
		log.info("업로드되는 경로 :" +uploadPath);
		if(uploadPath.exists() ==false) {// 경로가 없으면 
			uploadPath.mkdirs();//폴더 생성 
		} //년도/월/일의 형태로 생성됨 
		for(MultipartFile multipartFile :uploadFile) {
			AttachFileDTO attachDTO = new AttachFileDTO(); //추가 1) 
			log.info("---------------------------");
			log.info("업로드 파일명 : " +multipartFile.getOriginalFilename());//파일명 가져오는 메서드 
			log.info("업로드 파일 크기는 "  +multipartFile.getSize()) ;//파일크기 가져오는 메서드 
			String uploadFileName  = multipartFile.getOriginalFilename();
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +1); 
			log.info("파일 명만 가져옴 " + uploadFileName); //위에서  \\으로 구분하여 최종 문자열만 추출하면 파일명이 됨 
			attachDTO.setFileName(uploadFileName); //추가 2) 
			UUID uuid =UUID.randomUUID();//고유 식별자 생성 
			uploadFileName =uuid.toString() + "_" + uploadFileName; // uuid와 위에서 만든 파일명을 _로 결합하여 하나의 문자열 생성 
			try {
				File saveFile = new File(uploadPath,uploadFileName);
				multipartFile.transferTo(saveFile);//파일 저장 
				attachDTO.setUuid(uuid.toString()); //추가 3)
				attachDTO.setUploadPath(uploadFolderPath); //추가 5)
				if(checkImageType(saveFile)) {
					attachDTO.setImage(true); // 추가 6)
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath,"s_" +uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail,100,100);
					thumbnail.close();
				}
				list.add(attachDTO);//목록에 추가 , 추가 7)
			}catch(Exception e) {
				log.error(e.getMessage());
			}//end catch
		}//end for 
		
		list.forEach(i->log.info(""+i));
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	//문자열로 파일의 경로가 포함된 fileName을 파라미터로 받도 byte[] 을 전송
	//MIME 타입이 파일의 종류에 따라 달라지는 것을 header에 추가해서 받는 측에서 그것을 활용함 
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		log.info("파일명 " +fileName);
		File file = new File("c:\\upload\\" + fileName);
		log.info("파일 :" + file);
		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file) ,header,HttpStatus.OK);
		} catch(IOException e) {
			e.printStackTrace();
		}
		
		return result;
		
	}
	
	@GetMapping(value="/download" , produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent ,String fileName){//1)수정
		log.info("download file : " + fileName);
		Resource resource = new FileSystemResource("c:\\upload\\" +fileName);//다형성
		log.info("resouce :"  + resource);
		if(resource.exists()== false) { //2) 추가 ,파일이 존재하지 않으면 
			return new ResponseEntity<>(HttpStatus.NOT_FOUND); //발견되지 않음을 Header에 싫어서 보내고 함수 종료 
		}
		System.out.println("이미지를 누르면 여기 컨트롤러(download) 에 들어오는가 ? " +fileName);
		String resourceName =resource.getFilename();	
		//UUID 삭제 (추가)
		String resourceOriginName = resourceName.substring(resourceName.indexOf("_") +1 ); // _를 기준으로 문자열 추출 
		HttpHeaders headers = new HttpHeaders();
		try {
			String downloadName = null;//3) 추가
			//4) 아래 코드 추가 ,이것을 IE/edge에 관련된 내용으로 그냥 이해하지 않으셔도 됩니다.
			if(userAgent.contains("Trident")) {
				log.info("IE 브라우저" );
				downloadName = URLEncoder.encode(resourceOriginName, "UTF-8").replace("\\+", " "); //+   => 공백으로 대체 
			} else if(userAgent.contains("Edge")) {
				log.info("Edge  브라우저 ");
				downloadName = URLEncoder.encode(resourceOriginName, "UTF-8");
			}
			else {//여기만 크롬 브라우저 
				log.info("크롬   브라우저 ");
				downloadName = new String(resourceOriginName.getBytes("UTF-8"), "ISO-8859-1");//객체 생성 후 변수에 저장함	
			}
			log.info("다운로드 이름 :" + downloadName);//4) 추가 
			headers.add("Content-Disposition" , "attatchment;fileName=" + downloadName); //5)변경 
		} catch(UnsupportedEncodingException e ) {
			e.printStackTrace();
		}
		ResponseEntity<Resource> entity = new ResponseEntity<Resource>(resource , headers , HttpStatus.OK);//콘솔창에서 우선확인하기 위함  /download?fileName =
		System.out.println("download 컨틀롤러에서의 return문 마지막 statement "+ entity.toString()); //컨틀롤러에서 어떻게 찍히는 지 확인해보자 
		return entity;
	}//다 하신 분은 테스트 하세요 ,uuid 부분을 잘라내서 저장되는지 확인 
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		log.info("컨트롤러에서의 삭제 파일 : " +fileName);
		File file;
		try {
			file = new File("c:\\upload\\" + URLDecoder.decode(fileName,"UTF-8"));
			file.delete(); //원본 파일 삭제 
			if(type.equals("image")) { //이미지 일 겨우 
				String largeFileName = file.getAbsolutePath().replace("s_", ""); // thumbnail 시 추가한 파일명 제거하고 원래 파일 명 추출하기 위해 공백으로 대체   
				log.info("largeFileName : " + largeFileName);
				file = new File(largeFileName); // 그 문자로 파일 객체 생성
				file.delete(); //섬네일 파일 삭제 
			}
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND); //지원되지 않는 인코딩 시 예외 발생시 파일이 없다고 response 의 header에 추가하여 client에 전달 
		}	
		
		return new ResponseEntity<String>("deleted " , HttpStatus.OK); //정상적일경우 client에 상태를 OK(200)전달 
	}
}
