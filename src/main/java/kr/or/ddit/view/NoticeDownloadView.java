package kr.or.ddit.view;

import java.io.File;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.servlet.view.AbstractView;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class NoticeDownloadView extends AbstractView{

	/**
	 *
	 */
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		@SuppressWarnings("unchecked")
		Map<String, Object> noticeFileMap = (Map<String, Object>) model.get("noticeFileMap");
		
		log.info("noticeFileMap : {}",noticeFileMap);
		
		File saveFile = new File(noticeFileMap.get("fileSavepath").toString()+"\\"+noticeFileMap.get("fileNo").toString()
									+"\\"+noticeFileMap.get("fileSavename").toString());
		log.info("saveFile : {}" ,saveFile);

		String fileName = noticeFileMap.get("fileName").toString();
		
		String agent = request.getHeader("User-Agent");
		if(StringUtils.containsIgnoreCase(agent, "msie") || 
				StringUtils.containsIgnoreCase(agent, "trident")) {
			fileName = URLEncoder.encode(fileName, "UTF-8");
		}else {
			fileName = new String(fileName.getBytes(), "ISO-8859-1");
		}
		
		response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\"");
		response.setHeader("Content-Length", noticeFileMap.get("fileSize").toString());
		
		try(
			OutputStream os = response.getOutputStream();
		){
			FileUtils.copyFile(saveFile, os);
		}
	}
}
