package com.green.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.green.domain.BoardAttachVO;
import com.green.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Component
public class FileCheckTest {
	
	@Setter(onMethod_ = {@Autowired})
	private BoardAttachMapper attachMapper;
	
	private String getFolderYesterDay() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar cal = Calendar.getInstance(); //Calendar 클래스, 클래스에 바로 접근 못함, getInstance()로 객체를 하나 만듬 -> singletone 디자인패턴
		//캘린더 클래스는 추상 클래스라 객체를 바로 생성할 수 없음 
		cal.add(Calendar.DATE, -1); //singletone = 객체를 하나만 만들어서 공유하고자 함  
		//TodoBuilder 패턴에서도
		//private TodoBuiler() {} //생성자이고 외부에서 접근 불가
		
		String str = sdf.format(cal.getTime());
		
		return str.replace("-", File.separator);
		
	}
	
	@Scheduled(cron = "0 * * * * *") // 작업 스케줄 설정 -> 시간을 1분으로 
	public void checkFiles() throws Exception{
		log.warn("File check task run ..........................");
		log.warn("==============================================");
		
		//데이터베이스의 파일 목록
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		//데이터베이스 파일 목록으로 디렉토리에 파일이 있는지 확인함 
		List<Path> fileListPaths = fileList.stream()
				.map(vo -> Paths.get("c:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
				.collect(Collectors.toList());
		
		//썸네일 이미지 파일
		fileList.stream().filter(vo -> vo.isFileType() == true)
		.map(vo -> Paths.get("c:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName()))
		.forEach(p -> fileListPaths.add(p));
		
		log.warn("=======================================");
		
		fileListPaths.forEach(p->log.warn(p + ""));
		
		//어제 디렉토리에 있는 파일들 
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		log.warn("========================================");
		
		for (File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			
			file.delete();
		}
	}
	
}
