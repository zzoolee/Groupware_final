<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>

	<c:set value="등록 " var="name"/>
	<c:if test="${status eq 'u'}">
		<c:set value="수정" var="name"/>
	</c:if>
	<h2>공지사항 ${name}</h2>
		<div class="card mt-7" style="border-radius:20px; padding:30px;">
			<form action="/insertNotice" method="post" id="noticeForm" enctype="multipart/form-data">
				<section>
					<c:if test="${status eq 'u'}">
						<input type="hidden" name="noNo" id="noNo" value="${notice.noNo}"/>
					</c:if>
<!-- 					<div style="margin-left: 80px;"> -->
					  	
<!-- 					</div> -->
					<div class="row" style="margin: 20px 0px 0px 0px;">
						<div style="width: 130px;"></div>
						<div class="col-9" >
							<input class="form-control form-control" id="noTitle" name="noTitle" type="text" value="${notice.noTitle}" placeholder="제목을 입력해주세요." />
						</div>
						<div class="col">
							<input class="form-check-input" name ="noFix" id="flexCheckDefault" type="checkbox" value="1" <c:if test="${not empty notice.noFix }">checked</c:if>/>
					  		<label class="form-check-label" for="flexCheckDefault">상단고정</label>
						</div>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-1"></div>
							<div class="col-10">
								<textarea class="form-control" id="noContent" name="noContent"
									style="height: 1000px;">${notice.noContent}</textarea>
							</div>
							<div class="col-1"></div>
						</div>
					</div>
					<div class="row">
						<div class="col-1"></div>
						<div class="col-10">
							<div class="px-4 pb-5">
 									<input class="form-control form-control-sm" id="noFile" multiple="multiple" name="noFile" type="file" />
							</div>
						</div>
					</div>
					<sec:csrfInput/>
				<c:if test="${status eq 'u'}">
<!-- 					<div class="card-footer bg-white"> -->
						<ul class="noticebox-attachmets d-flex align-item-stretch clearfix">
							<c:if test="${not empty file}">
								<c:forEach items="${file}" var="file" varStatus="vs">
									<div>
										<div class="noticebox-attachment-info ms-14" id="noticebox-attachment-info">
											<span class="noticebox-attachment-name">
												<i class="feather-box"></i>${file.fileOrgname}
											</span>
											<span class="noticebox-attachment-size clearfix mt-1">
												<span>${file.fileSize}</span>
												<span class="btn btn-default btn-sm float-right attachmentFileDel"
													id="span_${file.fileSec}">
													<button type="button" class="btn btn-link text-danger fileDelete" data-file-sec="${file.fileSec}">
													<i class="fas fa-times"></i>
													</button>
												</span>
											</span>
										</div>
									</div>
								</c:forEach>
							</c:if>
						</ul>
<!-- 					</div> -->
				</c:if>
				</section>
		</form>
		<div style="text-align: center;">
			<c:if test="${status ne 'u'}">
				<button class="btn btn-info me-1 mb-1" type="button" id="registerBtn">등록</button>
				<button class="btn btn-outline-info me-1 mb-1" type="button" id="listBtn">목록</button>
			</c:if>
			<c:if test="${status eq 'u'}">
				<button class="btn btn-info me-1 mb-1" type="button" id="modifyBtn">수정</button>
				<button class="btn btn-outline-info me-1 mb-1" type="button" id="listBtn">취소</button>
			</c:if>
		</div>
	</div>
<br>	
<!-- 	<div class="d-flex justify-content-end mt-3"> -->
<%-- 		<c:if test="${status ne 'u'}"> --%>
<!-- 			<button class="btn btn-info me-1 mb-1" type="button" id="registerBtn">등록</button> -->
<!-- 			<button class="btn btn-outline-infoy me-1 mb-1" type="button" id="listBtn">목록</button> -->
<%-- 		</c:if> --%>
<%-- 		<c:if test="${status eq 'u'}"> --%>
<!-- 			<button class="btn btn-info me-1 mb-1" type="button" id="modifyBtn">수정</button> -->
<!-- 			<button class="btn btn-outline-info me-1 mb-1" type="button" id="listBtn">취소</button> -->
<%-- 		</c:if> --%>
<!-- 	</div> -->

<script type="text/javascript">
$(function(){
	CKEDITOR.config.height="400px";
	CKEDITOR.replace('noContent', {
		filebrowserUploadUrl : "/imageUpload.do"                               
    });
		var fileDiv = $("#noticebox-attachment-info");
		var noticeForm = $("#noticeForm");
		var registerBtn = $('#registerBtn');
		registerBtn.on('click', function(){
			var noTitle = $("#noTitle").val();
			var noContent = CKEDITOR.instances.noContent.getData();
			var noFile = $("#noFile").val();
		
		if(noTitle == null || noTitle == ""){
			alert("제목을 입력해주세요");
			return false;
		}
		if(noContent == null || noContent == ""){
			alert("내용을 입력해주세요");
			return false;
		}
		noticeForm.submit();
	});
	
	var listBtn = $('#listBtn');
	listBtn.on('click', function(){
		location.href="/noticemain.do";
	});
	
	var modifyBtn = $('#modifyBtn');
	modifyBtn.on('click', function(){
		noticeForm.attr("action", "/noticeModify");
		noticeForm.submit();
	});
	
	$(".fileDelete").on("click", function(){
		var fileSec = $(this).data("file-sec");
		console.log("fileSec : " + fileSec);
		var hiddenInput = "<input type='hidden' name='fileSec' value='" + fileSec + "' />";
	    noticeForm.append(hiddenInput);
	    $(this).closest("div[class='noticebox-attachment-info ms-14']").parent().hide();
	});
});
</script>




