package com.boardGameMarket.project.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.boardGameMarket.project.domain.AttachFileDTO;
import com.boardGameMarket.project.mapper.ProductMapper;
import com.boardGameMarket.project.service.ProductService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnails;

@Controller
@RequestMapping("/pages/*")
@Log4j
public class UploadController {
	
	@Setter(onMethod_=@Autowired)
	private ProductService service;
	
	// 첨부파일 업로드
		@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
		public ResponseEntity<AttachFileDTO> uploadAjaxActionPOST(MultipartFile uploadFile) {
			File checkfile = new File(uploadFile.getOriginalFilename());
			String type = null;
			
			try {
				type = Files.probeContentType(checkfile.toPath());
				log.info("MIME TYPE : " + type);
			} catch (IOException e) {
				e.printStackTrace();
			}
			if(!type.startsWith("image")) {
				AttachFileDTO attach = null;
				return new ResponseEntity<>(attach,HttpStatus.BAD_REQUEST);
			}
			
			String uploadFolder = "C:\\upload";
			//날짜 폴더 경로
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date date = new Date();
			String str = sdf.format(date);
			String datePath = str.replace("-", File.separator);
			//폴더 생성
			File uploadPath = new File(uploadFolder,datePath);
			if(uploadPath.exists()==false) {
				uploadPath.mkdirs();
			}
			//이미지 정보 담는 객체
			AttachFileDTO attach = new AttachFileDTO();
			//파일 이름
			String uploadFileName = uploadFile.getOriginalFilename();
			
			//view단에 보내기위해 객체 채우기 1,2
			attach.setFileName(uploadFileName);
			attach.setUploadPath(datePath);
			
			//uuid 적용
			String uuid = UUID.randomUUID().toString();
			
			//view단에 보내기위해 객체 채우기 3
			attach.setUuid(uuid);
			
			uploadFileName = uuid + "_" + uploadFileName;
			//파일 위치, 파일 이름을 합친 File 객체
			File saveFile = new File(uploadPath,uploadFileName);
			//파일 저장
			try {
				uploadFile.transferTo(saveFile);
				//썸네일 생성
				File thumbnailFile = new File(uploadPath, "s_" + uploadFileName);
				BufferedImage bo_image = ImageIO.read(saveFile);
				//썸네일 비율
				double ratio = 3;
				//썸네일 비율 넓이 높이
				int width = (int) (bo_image.getWidth()/ratio);
				int height = (int) (bo_image.getHeight()/ratio);
				
				/* 라이브러리 사용안하고 썸네일 작업하는 로직
				BufferedImage bt_image = new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR);
				Graphics2D graphic = bt_image.createGraphics();
				graphic.drawImage(bo_image, 0, 0, width, height, null);
				ImageIO.write(bt_image, "jpg", thumbnailFile); */
				
				//라이브러리 사용시 간단해짐
				Thumbnails.of(saveFile).size(width, height).toFile(thumbnailFile);
				
			}catch(Exception e) {
				e.printStackTrace();
			}
			
			ResponseEntity<AttachFileDTO> result = new ResponseEntity<AttachFileDTO>(attach,HttpStatus.OK);
			return result;
				
		}
		
		//이미지 출력
		@GetMapping("/display")
		public ResponseEntity<byte[]> getImage(String fileName){
			log.info("getImage()...." + fileName);
			File file = new File("c:\\upload\\" + fileName);
			ResponseEntity<byte[]> result = null;
			try {
				HttpHeaders header = new HttpHeaders();
				header.add("Content-type", Files.probeContentType(file.toPath()));
				result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
			}catch(IOException e) {
				e.printStackTrace();
			}
			return result;
		}
		
		//이미지 삭제
		@PostMapping("/deleteFile")
		public ResponseEntity<String> deleteFile(String fileName){
			log.info("deleteFile..." + fileName);
			File file = null;
			try {
				//썸네일 파일 삭제
				file = new File("c:\\upload\\" + URLDecoder.decode(fileName,"UTF-8"));
				file.delete();
				//원본 파일 삭제
				String originFileName = file.getAbsolutePath().replace("s_", "");
				log.info("originFileName : " + originFileName);
				file = new File(originFileName);
				file.delete();
			}catch(Exception e) {
				e.printStackTrace();
				return new ResponseEntity<String>("fail" , HttpStatus.NOT_IMPLEMENTED);
			}
			return new ResponseEntity<String>("success",HttpStatus.OK);
		}
		
		//이미지 정보 반환
		@GetMapping(value="/getAttachFile" , produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
		public ResponseEntity<AttachFileDTO> getAttachFile(int product_id){
			return new ResponseEntity(service.getAttachFile(product_id),HttpStatus.OK);
		}
		
}
