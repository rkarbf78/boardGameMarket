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
	
	// ÷������ ���ε�
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
			//��¥ ���� ���
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date date = new Date();
			String str = sdf.format(date);
			String datePath = str.replace("-", File.separator);
			//���� ����
			File uploadPath = new File(uploadFolder,datePath);
			if(uploadPath.exists()==false) {
				uploadPath.mkdirs();
			}
			//�̹��� ���� ��� ��ü
			AttachFileDTO attach = new AttachFileDTO();
			//���� �̸�
			String uploadFileName = uploadFile.getOriginalFilename();
			
			//view�ܿ� ���������� ��ü ä��� 1,2
			attach.setFileName(uploadFileName);
			attach.setUploadPath(datePath);
			
			//uuid ����
			String uuid = UUID.randomUUID().toString();
			
			//view�ܿ� ���������� ��ü ä��� 3
			attach.setUuid(uuid);
			
			uploadFileName = uuid + "_" + uploadFileName;
			//���� ��ġ, ���� �̸��� ��ģ File ��ü
			File saveFile = new File(uploadPath,uploadFileName);
			//���� ����
			try {
				uploadFile.transferTo(saveFile);
				//����� ����
				File thumbnailFile = new File(uploadPath, "s_" + uploadFileName);
				BufferedImage bo_image = ImageIO.read(saveFile);
				//����� ����
				double ratio = 3;
				//����� ���� ���� ����
				int width = (int) (bo_image.getWidth()/ratio);
				int height = (int) (bo_image.getHeight()/ratio);
				
				/* ���̺귯�� �����ϰ� ����� �۾��ϴ� ����
				BufferedImage bt_image = new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR);
				Graphics2D graphic = bt_image.createGraphics();
				graphic.drawImage(bo_image, 0, 0, width, height, null);
				ImageIO.write(bt_image, "jpg", thumbnailFile); */
				
				//���̺귯�� ���� ��������
				Thumbnails.of(saveFile).size(width, height).toFile(thumbnailFile);
				
			}catch(Exception e) {
				e.printStackTrace();
			}
			
			ResponseEntity<AttachFileDTO> result = new ResponseEntity<AttachFileDTO>(attach,HttpStatus.OK);
			return result;
				
		}
		
		//�̹��� ���
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
		
		//�̹��� ����
		@PostMapping("/deleteFile")
		public ResponseEntity<String> deleteFile(String fileName){
			log.info("deleteFile..." + fileName);
			File file = null;
			try {
				//����� ���� ����
				file = new File("c:\\upload\\" + URLDecoder.decode(fileName,"UTF-8"));
				file.delete();
				//���� ���� ����
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
		
		//�̹��� ���� ��ȯ
		@GetMapping(value="/getAttachFile" , produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
		public ResponseEntity<AttachFileDTO> getAttachFile(int product_id){
			return new ResponseEntity<>(service.getAttachFile(product_id),HttpStatus.OK);
		}
		
}
