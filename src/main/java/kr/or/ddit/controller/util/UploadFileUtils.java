package kr.or.ddit.controller.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.springframework.util.FileCopyUtils;

public class UploadFileUtils {

	public static String uploadFile(String uploadPath, String originalName, byte[] fileData) throws IOException {
		UUID uuid = UUID.randomUUID(); // 파일명 만들기 위함
		
		String savedName = uuid.toString()+"_"+originalName;
		// 2023/09/04 폴더 경로를 만들고, /2023/09/04 폴더 경로를 리턴한다.
		String savedPath = calcPath(uploadPath);
		File target = new File(uploadPath+savedPath, savedName);
		
		FileCopyUtils.copy(fileData, target); // 위에서 만들어진 경로와 파일명을 가지고 파일 복사를 진행
		
		//확장자 추출 - 이미지 파일인지 구분
		String formatName = originalName.substring(originalName.lastIndexOf(".")+1); // 확장자 추출
		// \2023\09\04 경로를 /경로로 변경 후 원본 파일명을 붙인다.
		String uploadedFileName = savedPath.replace(File.separatorChar, '/')+"/"+savedName;
		
		//확장자가 이미지 파일이면 's_'가 붙은 파일의 썸네일 이미지 파일을 생성한다..
		if(MediaUtils.getMediaType(formatName) != null) {
			makeThumnail(uploadPath, savedPath, savedName);
		}
		return uploadedFileName;
	}
	
	// 2023/09/04 경로 생성 
	private static String calcPath(String uploadPath) {
		Calendar cal = Calendar.getInstance();
		String yearPath = File.separator + cal.get(Calendar.YEAR);
		
		//DecimalFormat("00") ::  두자리에서 빈자리는 0으로 채움
		String monthPath = yearPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.MONTH)+1);
		String datePath = monthPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));
		
		makeDir(uploadPath, yearPath, monthPath, datePath);
		
		return datePath;
	}
	
	
	// 가변인자 
	// 키워드'...'를 사용한다.
	// [사용번] 타입 ... 변수명 형태로 사용
	// 순서대로 yearPath, monthPath, datePath가 배열로 들어가 처리
	private static void makeDir(String uploadPath, String ...paths) {
		if(new File(paths[paths.length-1]).exists()) {
			return;
		}
		
		for(String path : paths) {
			File dirPath =new File(uploadPath+path);
			
			// /2023/09/04 와 같은 경로에 각 폴더가 없으면 각각 만들어준다.
			if(!dirPath.exists()) {
				dirPath.mkdirs();
			}
		}
	}
	
	private static void makeThumnail(String uploadPath, String path, String fileName) throws IOException {
		// 썸네일 이미지를 만들기 위해 원본 이미지를 읽는다.
		BufferedImage sourceImg = ImageIO.read(new File(uploadPath+path, fileName));
		
		
		// Method.AUTOMATIC : 최소 시간 내에 가장 잘 보이는 이미지를 얻기 위한 사용 방식
		// Mode.FIT_TO_HEIGHT : 이미지 방향과 상관없이 주어진 높이 내에서 가장 잘 맞는 이미지로 계산
		// targetSize : 값 100, 정사작형 사이즈로 100X100
		BufferedImage destImg = Scalr.resize(sourceImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT,100);
		// 업로드한 원본 이미지를 가지고 "s_"를 붙여서 임시 파일로 만들기 위해 썸네일 경로 + 파일며을 작성한다.
		String thumnailName = uploadPath + path + File.separator+"s_"+fileName;
		
		File newFile = new File(thumnailName);
		String formatName = fileName.substring(fileName.lastIndexOf(".")+1);
		
		// "s_"가 붙은 썸네일 이미지를 만든다
		ImageIO.write(destImg, formatName.toUpperCase(), newFile);
		
	}



}




























