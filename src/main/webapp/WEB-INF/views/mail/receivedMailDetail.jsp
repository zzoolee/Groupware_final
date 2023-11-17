<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<h2>받은메일 상세보기</h2>
<div class="email-container pt-5">
	<div class="row g-lg-6 mb-8">
		<div class="col-12">
			<div class="card">
				<div class="card-body">
					<form class="d-flex flex-column" id="sendMailForm">
						<div class="row g-3 mb-2">

							<div class="col-9" style="padding:10px;">
								<div class="row">
									<div class="col-12 pb-3">
										<div class="d-flex align-items-center mb-1">
											<span class="me-2 uil uil-user"></span>
											<h5 class="text-1000 mb-0">보낸사람</h5>
										</div>
										<!-- 보낸직원 들어가는 곳 -->
										<span class="input-group-text">
											<span class="btn btn-sm btn-phoenix-secondary rounded-pill me-1 mb-1">${mailList.mailsEmpname }</span>
										</span>
									</div>

									<div class="col-12 pb-3">
										<div class="d-flex align-items-center mb-1">
											<span class="me-2 uil uil-user"></span>
											<h5 class="text-1000 mb-0">받는이</h5>
										</div>
										<!-- 보낸직원 들어가는 곳 -->
										<div class="form-control bg-light" type="text" id="refPlace">
											<c:forEach items="${mailList.mailRec }" var="rec">
												<span class="btn btn-sm btn-phoenix-secondary rounded-pill me-1 mb-1">${rec.mailrecEmpname }</span>
											</c:forEach>
										</div>
									</div>

									<c:if test="${!empty mailList.mailRef }">
									<div class="col-12 pb-3">
										<div class="d-flex align-items-center mb-1">
											<span class="me-2 uil uil-user"></span>
											<h5 class="text-1000 mb-0">참조자</h5>
										</div>
										<!-- 보낸직원 들어가는 곳 -->
										<div class="form-control bg-light" type="text" id="refPlace">
										<c:forEach items="${mailList.mailRef }" var="rec">
												<span class="btn btn-sm btn-phoenix-secondary rounded-pill me-1 mb-1">${rec.mailrefEmpname }</span>
										</c:forEach>
										</div>
									</div>
									</c:if>
									<div class="col-12 pb-3">
										<div class="d-flex align-items-center mb-2">
											<span class="me-2 uil uil-caret-right"></span>
											<h5 class="text-1000 mb-0">제목</h5>
										</div>
										<span class="input-group-text">${mailList.mailTitle }</span>
									</div>
								</div>
							</div>
							<div class="col-3" style="padding:20px;">
								<div class="d-flex align-items-center mb-2">
									<span class="me-2" data-feather="calendar"></span>
									<h5 class="text-1000 mb-0">수신날짜</h5>
								</div>
								<div class="d-flex align-items-center mb-4">
									<div class="form-control bg-light" type="text" id="refPlace">
									<span class="fs-1"><fmt:formatDate value="${mailList.mailDate}" pattern="yyyy-MM-dd HH:mm"/></span>
									</div>								
								</div>
								<br>
								<div class="d-flex align-items-center mb-2">
									<span class="me-2 uil uil-file"></span>
									<h5 class="text-1000 mb-0">첨부파일</h5>
								</div>
								<c:forEach items="${mailList.fileList }" var="files">
									<div class="d-flex align-items-center mb-2">
										<h6 class="ps-5 fw-normal mailViewSelect"
											data-value="${files.fileSec }" style="cursor: pointer;">${files.fileOrgname }</h6>
										<span
											class="ms-2 fs-1 uil uil-download-alt mailDownloadSelect"
											data-value="${files.fileSec }" style="cursor: pointer;"></span>
										<span class="ms-2 fs-1 uil uil-eye mailViewSelect"
											data-value="${files.fileSec }" style="cursor: pointer;"></span>
									</div>
								</c:forEach>
							</div>


							<div class="col-12">
							<div class="d-flex align-items-start mb-2" >
									<span class="me-2 uil uil-subject"></span>
									<h5 class="text-1000 mb-0">내용</h5>
								</div>
								<div class="form-control bg-light">
									<br>
									${mailList.mailContent }
								</div>
							</div>
							<div class="d-flex justify-content-between align-items-center">
								<div class="d-flex">
								</div>
								<div class="d-flex">	
									<button class="btn btn-outline-info me-1 mb-1" type="button" id="listBtn">&nbsp;&nbsp;목록&nbsp;&nbsp;</button>
									<button class="btn btn-info me-1 mb-1" type="button" data-value="${mailList.mailsEmpno }" id="mailBtn">답장보내기</button>
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 미리보기를 띄워줄 모달 -->
<div class="modal fade" id="showPictureModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">이미지 미리보기</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body d-flex justify-content-center align-items-center">
        <div class="mb-3 imgDiv" id="imgDiv">
  			
		</div>
      </div>
      <div class="modal-footer">
      <button class="btn btn-primary downloadFileBtn" type="button" id="downloadFileBtn">다운로드</button>
      <button class="btn btn-danger" type="button" data-bs-dismiss="modal" id="modalFileCancleBtn">취소</button></div>
    </div>
  </div>
</div>

<script type="text/javascript">
$(function(){
	CKEDITOR.replace('mailContent', {height: 200});
	
	 $(document).on('click', '#listBtn', function(){
// 	        location.href="/receivedmail.do";
			history.back();
	    });

	 
	 // 전역변수로 꺼내줘서 해당파일을 클릭했을때 다른파일을 클릭하기전까진.
	 // 이 파일의 데이터를 다운로드하거나 볼 수 있게해준다.
	 var isFile = 0;
	 $(document).on('click', '.mailViewSelect', function(){
		 var imgDiv = $('.imgDiv');
		 var images = ["jpg","jpeg","jfif","gif","png"]
		 var canViewFile = ["pdf"]
		 var fileSec = $(this).data('value');
		 var imgDiv = $('#imgDiv');
		 var str = "";
		 isFile = fileSec
		 var mailFile = {
				 'fileSec' : fileSec
		 }
		 var img = "";
		 console.log(fileSec);
		 
		 $.ajax({
			type : 'POST',
			url : "/mailFileViewAjax.do",
			data : JSON.stringify(mailFile),
			contentType : "application/json; charset=utf-8",
			success : function(result){
				console.log(result.fileInfo.fileType);
				imgDiv.html('');
				if(images.includes(result.fileInfo.fileType)){
					str += '<img src="'+result.fileInfo.fileSavepath+
					result.fileInfo.fileSavename+'" style="max-width: 100%;">';
				} else if (canViewFile.includes(result.fileInfo.fileType)) {
					str += '<a class="btn btn-primary" href="'+result.fileInfo.fileSavepath;
					str += result.fileInfo.fileSavename+'" target="_blank" id="fileViewBtn">파일 미리보기</a>'
				} else {
					str += '<span>해당파일은 미리보기가 불가능합니다.</span>';
				}
				imgDiv.html(str);
				$('#showPictureModal').modal('show');
			}
		 });
	 });
	 
	 $(document).on('click', '#mailBtn', function(){
		console.log($(this).data('value')); 
		location.href="/sendmail.do?mailrEmpno="+$(this).data('value');
	 });
	 
	 $(document).on('click', '.downloadFileBtn', function(){
		 location.href="/mailFileDownloadAjax.do?isFile="+isFile;
	 });
	 
	 $(document).on('click', '.mailDownloadSelect', function(){
		 isFile = $(this).data('value');
		 location.href="/mailFileDownloadAjax.do?isFile="+isFile;
	 });
})


</script>