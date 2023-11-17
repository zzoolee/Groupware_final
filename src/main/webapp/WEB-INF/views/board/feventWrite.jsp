<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>

	<c:set value="등록" var="name"/>
	<c:if test="${status eq 'u'}">
		<c:set value="수정" var="name"/>
	</c:if>
	<h2>경조사게시판 ${name}</h2>
		<div class="card mt-7" style="border-radius:20px; padding:30px;">
			<div class="container-fluid">
					<section>
						<form action="/insertfevent" method="post" id="feventForm" enctype="multipart/form-data">
						<c:if test="${status eq 'u'}">
							<input type="hidden" name="feNo" id="feNo" value="${fevent.feNo}"/>
						</c:if>
						<div class="row" style="margin: 20px 0px 0px 0px;">
							<div class="col"></div>
							<div class="col-10">
								<input class="form-control form-control" id="feTitle" name="feTitle" value="${fevent.feTitle}"
									type="text" placeholder="제목을 입력해주세요." />
							</div>
							<div class="col"></div>
						</div>
						<div class="card-body">
							<div class="row">
								<div class="col-1"></div>
									<div class="col-10">
										<textarea class="form-control" id="feContent" name="feContent"
											style="height: 1000px;">${fevent.feContent}</textarea>
									</div>
								<div class="col-1"></div>
							</div>
						</div>
						<div class="row">
							<div class="col-1"></div>
							<div class="col-10">
								<div class="mb-3  px-4 pb-5">
  									<input class="form-control form-control-sm" id="feFile" name="feFile" multiple="multiple" type="file" />
								</div>
							</div>
						</div>
						<sec:csrfInput/>
					</form>
					<c:if test="${status eq 'u'}">
<!-- 						<div class="card-footer bg-white"> -->
							<ul class="feventbox-attachmets d-flex align-item-stretch clearfix">
								<c:if test="${not empty file}">
									<c:forEach items="${file}" var="file" varStatus="vs">
										<div>
											<div class="feventbox-attachment-info ms-14" id="feventbox-attachment-info">
												<span class="feventbox-attachment-name">
													<i class="feather-box"></i>${file.fileOrgname}
												</span>
												<span class="feventbox-attachment-size clearfix mt-1">
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
<!-- 					<button class="btn btn-info me-1 mb-1" type="button" id="modifyBtn">수정</button> -->
<!-- 					<button class="btn btn-outline-info me-1 mb-1" type="button" id="listBtn">취소</button> -->
<%-- 				</c:if> --%>
<!-- 			</div> -->
<!-- 		</div> -->

<script type="text/javascript">
$(function(){
	CKEDITOR.config.height="400px";
	CKEDITOR.replace('feContent' , {
		filebrowserUploadUrl : "/imageUpload.do"                                                  
    });
	
	var fileDiv = $("#feventbox-attachment-info");
	var feventForm = $("#feventForm");
	var registerBtn = $('#registerBtn');
	var listBtn = $('#listBtn');
	
	listBtn.on('click', function(){
		location.href="/feventmain.do";
	});
	
	var modifyBtn = $('#modifyBtn');
	modifyBtn.on('click', function(){
		feventForm.attr("action", "/feventModify");
		feventForm.submit();
	});
	
	registerBtn.on('click', function(){
		var feTitle = $("#feTitle").val();
		var feContent = CKEDITOR.instances.feContent.getData();
		var feFile = $("#feFile").val();

		console.log("feTitle" +feTitle);
		console.log("feContent" +feContent);
		console.log("feFile" +feFile);
		
		if(feTitle == null || feTitle == ""){
			alert("제목을 입력해주세요");
			return false;
		}
		if(feContent == null || feContent == ""){
			alert("내용을 입력해주세요");
			return false;
		}
		feventForm.submit();
	});
	
	$(".fileDelete").on("click", function(){
		var fileSec = $(this).data("file-sec");
		console.log("fileSec : " + fileSec);
		var hiddenInput = "<input type='hidden' name='fileSec' value='" + fileSec + "' />";
	    feventForm.append(hiddenInput);
	    $(this).closest("div[class='feventbox-attachment-info ms-14']").parent().hide();
	});
});
</script>




