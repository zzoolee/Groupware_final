<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>

	<c:set value="등록" var="name"/>
	<c:if test="${status eq 'u'}">
		<c:set value="수정" var="name"/>
	</c:if>
	<h2>자유게시판 ${name}</h2>
		<div class="card mt-7" style="border-radius:20px; padding:30px;">
			<div class="container-fluid">
					<section>
						<form action="/insertFree" method="post" id="freeForm" enctype="multipart/form-data">
							<c:if test="${status eq 'u'}">
								<input type="hidden" name="frNo" id="frNo" value="${free.frNo}"/>
							</c:if>
<!-- 							<div> -->
<!-- 							<div class="form-check" style=""> -->
								
<!-- 							</div> -->
<!-- 							<hr> -->
<!-- 						</div> -->
						<div class="row" style="margin: 20px 0px 0px 0px;">
							<div style="width: 130px;"></div>
							<div class="col-9">
								<input class="form-control form-control" id="frTitle" name="frTitle" value="${free.frTitle}" type="text" placeholder="제목을 입력해주세요." />
							</div>
							<div class="col">
								<input class="form-check-input" id="frAnonySe" type="checkbox" value="Y" name="frAnonySe"/>
								<label class="form-check-label" for="flexCheckDefault">익명사용</label>
							</div>
						</div>
						<div class="card-body">
							<div class="row">
								<div class="col-1"></div>
									<div class="col-10">
										<textarea class="form-control" id="frContent" name="frContent"
											style="height: 1000px;">${free.frContent}</textarea>
									</div>
								<div class="col-1"></div>
							</div>
						</div>
						<div class="row">
							<div class="col-1"></div>
							<div class="col-10">
								<div class="px-4 pb-5">
  									<input class="form-control form-control-sm" id="frFile" name="frFile" multiple="multiple" type="file" />
								</div>
							</div>
						</div>
						<sec:csrfInput/>
					</form>
					<c:if test="${status eq 'u'}">
<!-- 						<div class="card-footer bg-white"> -->
							<ul class="freebox-attachmets d-flex align-item-stretch clearfix">
								<c:if test="${not empty file}">
									<c:forEach items="${file}" var="file" varStatus="vs">
										<div>
											<div class="freebox-attachment-info ms-14" id="freebox-attachment-info">
												<span class="freebox-attachment-name">
													<i class="feather-box"></i>${file.fileOrgname}
												</span>
												<span class="freebox-attachment-size clearfix mt-1">
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
<!-- 						</div> -->
					</c:if>
				</section>
			</div>
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
<!-- 		<div class="row align-items-center py-1"> -->
<!-- 		</div> -->
<!-- 		<div class="row" style="margin: 15px 0px 20px 0px;"> -->
<!-- 			<div class="col-9"></div> -->
<!-- 			<div class="col-3 text-end"> -->
<%-- 				<c:if test="${status ne 'u'}"> --%>
<!-- 					<button class="btn btn-info me-1 mb-1" type="button" id="registerBtn">등록</button> -->
<!-- 					<button class="btn btn-outline-info me-1 mb-1" type="button" id="listBtn">목록</button> -->
<%-- 				</c:if> --%>
<%-- 				<c:if test="${status eq 'u'}"> --%>
<!-- 					<button class="btn btn-primary me-1 mb-1" type="button" id="modifyBtn">수정</button> -->
<!-- 					<button class="btn btn-primary me-1 mb-1" type="button" id="listBtn">취소</button> -->
<%-- 				</c:if> --%>
<!-- 			</div> -->
<!-- 		</div> -->

<script type="text/javascript">
$(function(){
	CKEDITOR.config.height="400px";
	CKEDITOR.replace('frContent' , {
		filebrowserUploadUrl : "/imageUpload.do"                                                  
    });
	
	var fileDiv = $("#freebox-attachment-info");
	var freeForm = $("#freeForm");
	var registerBtn = $('#registerBtn');
	var listBtn = $('#listBtn');
	
	listBtn.on('click', function(){
		location.href="/freemain.do";
	});
	
	var modifyBtn = $('#modifyBtn');
	modifyBtn.on('click', function(){
		freeForm.attr("action", "/freeModify");
		freeForm.submit();
	});
	
	registerBtn.on('click', function(){
		var frTitle = $("#frTitle").val();
		var frAnonySe = $("#frAnonySe").val();
		var frContent = CKEDITOR.instances.frContent.getData();
		var frFile = $("#frFile").val();

		console.log("frTitle" +frTitle);
		console.log("frAnonySe" +frAnonySe);
		console.log("frContent" +frContent);
		console.log("frFile" +frFile);
		
		if(frTitle == null || frTitle == ""){
			alert("제목을 입력해주세요");
			return false;
		}
		if(frContent == null || frContent == ""){
			alert("내용을 입력해주세요");
			return false;
		}
		freeForm.submit();
	});
	
	$(".fileDelete").on("click", function(){
		var fileSec = $(this).data("file-sec");
		console.log("fileSec : " + fileSec);
		var hiddenInput = "<input type='hidden' name='fileSec' value='" + fileSec + "' />";
	    freeForm.append(hiddenInput);
	    $(this).closest("div[class='freebox-attachment-info ms-14']").parent().hide();
	});
});
</script>




