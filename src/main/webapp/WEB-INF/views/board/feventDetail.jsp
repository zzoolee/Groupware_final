<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<style>
.hidden {
    display: none !important;
}
</style>
<c:if test="${not empty message}">
<script>
	$(document).ready(function(){
		alert('${message}');
	});
</script>
</c:if>

<sec:authentication property='principal.emp.empPhoto' var="empPhoto"/>


<!-- 	<div class="pb-5"> -->
<!-- 		<div class="row g-4"> -->
<!-- 			<div class="col-12 col-xxl-6"> -->
				<h2>경조사게시판</h2>
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
	<div class="card mt-7" style="border-radius:20px; padding:50px;">
		<div data-list='{"valueNames":["product","customer","rating","review","time"],"page":6}'>
			<div>
				<div class="container-fluid">
					<div class="row d-flex justify-content-center text-center" style="padding:20px;">
						<h3 id="title">${fevent.feTitle}</h3>
					</div>
				</div>
				<div class="d-flex justify-content-between align-items-center border-0" style="padding:30px;">
						<fmt:formatDate value="${fevent.feDate}" pattern="yyyy-MM-dd" var="feventDate"/>
				        <div><span>${fevent.empName}</span> / <span>${feventDate}</span></div>
				        <input type="hidden" value="${fevent.feWriterEmpNo}" id="empNo">
					  <div>조회수 : ${fevent.feHit}<span></span></div>
					</div>
				</div>
				<div class="row" style="margin: 15px 0px 20px 0px;">
					<div class="col-7"></div>
						<div class="col-5 text-end">
						<!-- 작성자일떄 -->
						<c:choose>
						  <c:when test="${fevent.feWriterEmpNo eq user}">
<!-- 						    <button class="btn btn-info me-1 mb-1" type="button" id="modifyBtn2">수정</button> -->
<!-- 						    <button class="btn btn-info me-1 mb-1" type="button" id="deleteBtn2">삭제</button> -->
<!-- 						    <button class="btn btn-outline-info me-1 mb-1" type="button" id="listBtn2">목록</button> -->
						    <!-- 작성자일떄 끝 -->
						  	<button class="btn btn-phoenix-secondary" id="modifyBtn2">
						      <svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><!-- <span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com --> 수정
						    </button>
						    <button class="btn btn-phoenix-danger" id="deleteBtn2">
						      <svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --> 삭제
						    </button>
						  </c:when>
						  <c:otherwise>
<!-- 						  	<button class="btn btn-outline-info me-1 mb-1" type="button" id="listBtn2">목록</button> -->
						  </c:otherwise>
						</c:choose>
					</div>
				</div>
					<div class="row">
						<div class="col-12">
							<hr>
						</div>
					</div>
						
						<form id="quickForm" novalidate="novalidate">
							<div class="card-body" style="padding:30px;">${fevent.feContent}</div>
								<div>
									<ul class="feventbox-attachments d-flex align-item-stretch clearfix">
										<c:if test="${not empty file}">
											<c:forEach items="${file}" var="file" varStatus="vs">
												<input type="hidden" name="fileNo" id="fileNo" value="${file.fileNo}">
												<div class="btn btn-sm btn-phoenix-secondary rounded-pill me-2" style="height: 50px; text-align: center;">
												<span class="arrow-down-circle">
													<!-- 미리보기 가능하면 a태그 클릭시 미리보기 가능하기 -->
													<span class="feventbox-attachment-name">
														<i class="fw-normal text-end"></i> ${file.fileOrgname}
													</span>
												</span>
												<c:url value="/feventdownload.do?${_csrf.parameterName}=${_csrf.token}" var="downloadURL">
													<c:param name="fileNo" value="${file.fileNo}"/>
													<c:param name="fileSec" value="${file.fileSec}"/>
												</c:url>
												<a href="${downloadURL}">
													<span class="btn btn-default btn-sm float-right">
														<i class="fas fa-download"></i>
													</span>
												</a>
<!-- 												<span class="col-12 d-flex justify-content-end"> -->
<%-- 													<span>${file.fileSize}</span> --%>
<!-- 												</span> -->
												</div>
											</c:forEach>
										</c:if>
									</ul>
								</div>
							</form>
						<br>
						<!-- 댓글 포문 돌릴 곳 -->
						<div class="bg-100 border-top border-bottom m-3 p-sm-4">
					    <div id="comment">
					        <!-- 댓글 들어가는 곳 -->
							<c:if test="${!empty 'comment'}">
								<c:forEach items="${comment}" var="comment">
									<div class="d-flex align-items-start mb-3">
							            <div class="avatar avatar-m  me-2">
							              <img class="rounded-circle" src="..${comment.empPhoto}">
							            </div>
							            <div class="flex-1">
							              <div class="d-flex justify-content-between align-items-center">
								              <div class="d-flex align-items-center">
								              	  <p class="fw-bold mb-0 text-black">${comment.empName}</p>
        	  								      <fmt:formatDate value="${comment.cmDate}" var="cmDate" pattern="yyyy-MM-dd HH:mm"/>
									              <span class="text-600 fw-semi-bold fs--2 ms-2">${cmDate }</span>
								              </div>
								              <c:choose>
								              	<c:when test="${comment.cmwriterEmpno eq user}">
								              <div class="d-flex justify-content-end closeGroup" data-cmno="${comment.cmNo}">
									  		  	<button class="btn btn-phoenix-secondary btn-sm me-1 mb-1" data-cmno="${comment.cmNo}" name="modifyCommentBtn" data-cmNo="${comment.cmNo}" style="display: block;">
									  		      <svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg>수정
									  		    </button>
									  		    &nbsp;
									  		    <button class="btn btn-phoenix-danger btn-sm me-1 mb-1" data-cmno="${comment.cmNo}" id="delCommentBtn" name="delCommentBtn" style="display: block;">
									  		      <svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --> 삭제
									  		    </button>
							  		   		  </div>
							  		   		  </c:when>
							  		   		  </c:choose>
							  		   		  <div class="d-flex justify-content-end openGroup hidden">
								  		  	<button class="btn btn-phoenix-info btn-sm" name="modifyCommentConfirmBtn" data-cmno="${comment.cmNo}" style="display: block;">저장</button>
								  		    &nbsp;
								  		    <button class="btn btn-phoenix-secondary btn-sm" name="cancleCommentBtn" data-cmno="${comment.cmNo}" style="display: block;">취소</button>
						  		   		  </div>
							              </div>
							              <p class="mb-0 closeGroup">${comment.cmContent}</p>
							              <input class="form-control openGroup hidden" type="text" name="cmContent" value="${comment.cmContent}">
							            </div>
							          </div>
								</c:forEach>
							</c:if>
					    </div>
					    <div class="d-flex align-items-center">
					        <div class="avatar avatar-m  me-2">
					            <img class="rounded-circle" src="${empPhoto }">
					        </div>
					        <div class="flex-1">
					            <div class="d-flex">
					                <input class="form-control" type="text" placeholder="댓글을 남겨주세요" name="cmContent" id="cmContent">
					                <button class="btn btn-phoenix-info btn-sm" style="width:100px;" name="commentBtn2" id="commentBtn2">등록</button>
					            </div>
					        </div>
					    </div>
					</div>
						<!-- 댓글포문 끝 -->
				</div>
				<br>
				<div style="text-align: center;">
					<button class="btn btn-outline-info me-1 mb-1" type="button" id="listBtn2">목록</button>
				</div>
			</div>
		<form action="/feventDelete.do" id="delForm" method="post">
			<input type="hidden" name="feNo" id="feNo" value="${fevent.feNo}">	
	</form>
<br>
			
<script type="text/javascript">
$(function(){
	CKEDITOR.replace('feContent', {
		filebrowserUploadUrl : "/imageUpload.do"                                                  
            });
	
	var listBtn = $("#listBtn2");
	var modifyBtn = $("#modifyBtn2");
	var deleteBtn = $('#deleteBtn2');
	var delForm = $('#delForm');
	var quickForm = $('#quickForm');
	
	
	listBtn.on('click', function(){
		location.href="/feventmain.do";
	});
	
	modifyBtn.on('click', function(){
		delForm.attr("action", "/feventModify.do");
		delForm.attr("method", "get");
		var fileNoInput = $('<input type="hidden" name="fileNo" value="' + $('#fileNo').val() + '">');
	    delForm.append(fileNoInput);
		delForm.submit();
	});
	
	deleteBtn.on('click', function(){
		customConfirm('해당 게시글을 삭제하시겠습니까?').then((userConfirmed) => {
	          if (userConfirmed) { // yes버튼일떄
	        	  delForm.submit();
	          } else { // no버튼일때
	           	 return false;
	          }
	      });
		
		//delForm.submit();
	});
	
});
$(document).on('click','#commentBtn2', function () {
// 	$("#commentBtn2").click(function () {
		// 알림용
		var empNo = $("#empNo").val();
		var title = $("#title").text();
		// 알림 핸들러에 쏴줄 메세지 셋팅 
		var msg = "fevnetBoard,"+title+","+empNo;
		
	
		var cmContent = $('#cmContent').val();
		console.log("cmContent : " + cmContent);
		var feNo = $("#feNo").val();
// 		var frNo = $(this).data("frno");
		console.log("feno : " + feNo);
		var data = {
			cmBno : feNo,
			cmContent : cmContent
		};
	console.log("data : " + data);
	$.ajax({
		url: "/fevent/comment/insert.do",
		type: "post",
		data: data,
// 		contentType: "application/json",
// 		dataType:"json",
		success: function(response){
// 			$("#comment").html("");
			console.log("댓글 리스트 : " + JSON.stringify(response));
			// 댓글 세팅
			var html = "";
				// 날짜를 JavaScript Date 객체로 파싱
					html +=    '<div class="d-flex align-items-start mb-3">';
					html +=    '	<div class="avatar avatar-m  me-2">';
					html +=    '		<img class="rounded-circle " src="${empPhoto }">';
					html +=    '	</div>';
					html +=    '		<div class="flex-1">';
					html +=    '			<div class="d-flex justify-content-between align-items-center">';
					html +=    '			    <div class="d-flex align-items-center">';
					html +=    '			        <p class="fw-bold mb-0 text-black">'+response.empName+'</p>';
					html +=    '				    <span class="text-600 fw-semi-bold fs--2 ms-2">'+response.cmDate+'</span>';
					html +=    '			    </div>';
					html +=    '			    <div class="d-flex justify-content-end closeGroup" data-empno="'+response.cmwriterEmpno+'">';
					html +=    '				  	<button class="btn btn-phoenix-secondary btn-sm me-1 mb-1" name="modifyCommentBtn" id="modifyCommentBtn" data-cmno="'+response.cmNo+'" style="display: block;">';
					html +=    '				  		<svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><!-- <span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com --> 수정';
					html +=    '				  	</button>';
					html +=    '				  	 &nbsp;';
					html +=    '				  	<button class="btn btn-phoenix-danger btn-sm me-1 mb-1" name="delCommentBtn" id="delCommentBtn" data-cmno="'+response.cmNo+'" style="display: block;">';
					html +=    '				  		<svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --> 삭제';
					html +=    '				  	</button>';
					html +=    '		  		 </div>';
					html +=    '              <div class="d-flex justify-content-end openGroup hidden">';
					html +=    '              <button class="btn btn-phoenix-info btn-sm" name="modifyCommentConfirmBtn" data-cmno="'+response.cmNo+'" style="display: block;">저장</button>';
					html +=    '              			 &nbsp;';
					html +=    '              		 <button class="btn btn-phoenix-secondary btn-sm" name="cancleCommentBtn" data-cmno="'+response.cmNo+'" style="display: block;">취소</button>';
					html +=    '              	 </div> ';
					html +=    '		     </div>';
					html +=    '		     <p class="mb-0 closeGroup">'+response.cmContent+'</p>';
					html +=    '		      <input class="form-control openGroup hidden" type="text" name="cmContent" value="'+response.cmContent+'">';
					html +=    '		</div>';
					html +=    '	</div>';
				$("#comment").append(html);
				$("#cmContent").val("");
				console.log("댓글 작성 여부 확인 : "+msg);
				ws.send(msg);
				}
		});	
	});
	
	$("#comment").on("click", "button[name='modifyCommentBtn']", function(){ // 폼 생성 필요
		var currentButton = $(this);
		
		currentButton.closest(".align-items-start").find(".openGroup").removeClass('hidden');
		currentButton.closest(".align-items-start").find(".closeGroup").addClass('hidden');
	});
	
	$("#comment").on("click", "button[name='modifyCommentConfirmBtn']", function(){
		var currentButton = $(this);
		
		var cmNo = currentButton.data("cmno");
		var cmContent = currentButton.closest(".align-items-start").find("input").val();
		console.log(cmNo, cmContent);
		
		var data = {
			"cmNo" : cmNo,
			"cmContent" : cmContent
		}
			
		$.ajax({
			type: "post",
			url: "/fevent/comment/modify.do",
			data: data,
			success: function(result){
				if(result == 'SUCCESS'){
					currentButton.closest(".align-items-start").find("p.closeGroup").text(cmContent);
					
					currentButton.closest(".align-items-start").find(".openGroup").addClass('hidden');
					currentButton.closest(".align-items-start").find(".closeGroup").removeClass('hidden');
					alert("정상적으로 수정되었습니다.");
				}
			}
		});
		
	});
	
	$("#comment").on("click", "button[name='cancleCommentBtn']", function(){
		var currentButton = $(this);
		console.log("currentButton" + currentButton);
		
		currentButton.closest(".align-items-start").find(".openGroup").addClass('hidden');
		currentButton.closest(".align-items-start").find(".closeGroup").removeClass('hidden');
	});
	
	$("#comment").on("click", "button[name='delCommentBtn']", function(){
		var currentButton = $(this); // 현재 버튼 요소를 변수에 저장
		
		customConfirm('정말 삭제하시겠습니까?').then((userConfirmed) => {
          if (userConfirmed) { 
        	  var cmNo = currentButton.data("cmno");
        	  console.log("cmNo : "+cmNo);
        	  $.ajax({
      			type: "get",
      			url: "/fevent/comment/remove.do?cmNo="+cmNo,
      			success: function(result){
      				if(result == 'SUCCESS'){
      					// 여기서 $(this)는 콜백 함수의 컨텍스트로, AJAX 요청이 아닌 콜백 함수 자체를 가리키게 됩니다. 
      					currentButton.parents(".align-items-start").remove(); // ^^ 왜 또 hide는 안되고...
						alert("정상적으로 삭제되었습니다.");
					}
      			}
       	  	});
          }
		})
	
	});
</script>