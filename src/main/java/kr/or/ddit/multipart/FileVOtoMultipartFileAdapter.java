package kr.or.ddit.multipart;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.FileVO;

public class FileVOtoMultipartFileAdapter implements MultipartFile{
	private final FileVO fileVO;

	public FileVOtoMultipartFileAdapter(FileVO fileVO) {
		this.fileVO = fileVO;
	}
	
	@Override
	public String getName() {
		return fileVO.getFileNo();
	}

	@Override
	public String getOriginalFilename() {
		return fileVO.getFileOrgname();
	}

	@Override
	public String getContentType() {
		return fileVO.getFileMime();
	}

	@Override
	public boolean isEmpty() {
		return false;
	}

	@Override
	public long getSize() {
		return fileVO.getFileSize();
	}

	@Override
	public byte[] getBytes() throws IOException {
		return null;
	}

	@Override
	public InputStream getInputStream() throws IOException {
		return null;
	}

	@Override
	public void transferTo(File dest) throws IOException, IllegalStateException {
	}
}
