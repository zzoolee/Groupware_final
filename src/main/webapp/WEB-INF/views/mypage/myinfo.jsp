<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!-- <div class="pb-9"> -->
<!-- 	<div class="row"> -->
<!-- 		<div class="col-12"> -->
<!-- 			<div class="row align-items-center justify-content-between g-3 mb-3"> -->
<!-- 				<div class="col-12 col-md-auto"> -->
					
<!-- 				</div> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
<h2 class="mb-0">개인정보</h2><br>
<div class="row mt-1 col-12 g-0 g-md-12 g-xl-12 justify-content-center">
	<!-- 프로필이미지 -->
	<div class="mt-3 col-7 g-0 g-md-4 g-xl-6 justify-content-center">
		<div class="row">
			<div class="col-md-4 col-lg-4 col-xl-4">
			<div class="card mb-3 pb-3">
				<div class="card-body">
					<div class="row align-items-center g-3 text-center text-xxl-start">
						<div class="col-12 col-xxl-auto mb-3">
							<div class="avatar avatar-5xl">
								<c:choose>
									<c:when test="${not empty empVO.empPhoto }">
										<img class="rounded-soft" src="${empVO.empPhoto }" alt="profileImg" id="imgProfile"/>
										<div id="divImgProfile" style="display:none;">${empVO.empPhoto }</div>
									</c:when>
									<c:otherwise>
										<img class="rounded-soft" src="/resources/assets/gw/profile.png" alt="profileImg" id="imgProfile"/>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="col-12 col-sm-auto flex-1">
							<h3 class="fw-bolder mb-2">${empVO.empName }</h3>
							<p class="mb-0">사번 : <span class="fw-bold text-info">${empVO.empNo }</span></p>
							<p class="mb-0">직급 : <span class="fw-bold text-info">${empVO.codeVO.cdName }</span></p>
							<p>소속 : <span class="fw-bold text-info">${empVO.deptVO.deptName }</span></p>
						</div>
					</div>
				</div>
			</div>
			<!-- 알림 -->
				<div class="card mb-3 pb-2">
					<div class="card-body" id="notiInputDiv">
						<div class="d-flex align-items-center mb-5">
							<h3>알림설정</h3>
						</div>
						<c:if test="${not empty notiList }">
							<c:forEach items="${notiList }" var="noti">
								<c:if test="${noti eq '메일' }"><c:set value="checked" var="mailChk"/></c:if>
								<c:if test="${noti eq '업무' }"><c:set value="checked" var="workChk"/></c:if>
								<c:if test="${noti eq '결재' }"><c:set value="checked" var="applyChk"/></c:if>
								<c:if test="${noti eq '참조' }"><c:set value="checked" var="draftChk"/></c:if>
								<c:if test="${noti eq '댓글' }"><c:set value="checked" var="replyChk"/></c:if>
								<c:if test="${noti eq '일정' }"><c:set value="checked" var="scheChk"/></c:if>
							</c:forEach>
						</c:if>
						<div class="form-check form-switch">
						  <input class="form-check-input" id="flexSwitchCheckDefault" value="메일" type="checkbox" ${mailChk }/>
						  <label class="form-check-label fs-1 text-primary" for="flexSwitchCheckDefault">메일</label>
						</div>
						<div class="form-check form-switch">
						  <input class="form-check-input" id="flexSwitchCheckChecked" value="업무" type="checkbox" ${workChk }/>
						  <label class="form-check-label fs-1 text-success" for="flexSwitchCheckChecked">업무</label>
						</div>
						<div class="form-check form-switch">
						  <input class="form-check-input" id="flexSwitchCheckDisabled" value="결재" type="checkbox" ${applyChk }/>
						  <label class="form-check-label fs-1 text-danger" for="flexSwitchCheckDisabled">결재</label>
						</div>
						<div class="form-check form-switch">
						  <input class="form-check-input" id="flexSwitchCheckDisabled" value="참조" type="checkbox" ${draftChk }/>
						  <label class="form-check-label fs-1 text-danger" for="flexSwitchCheckDisabled">참조</label>
						</div>
						<div class="form-check form-switch">
						  <input class="form-check-input" id="flexSwitchCheckCheckedDisabled" value="댓글" type="checkbox" ${replyChk }/>
						  <label class="form-check-label fs-1 text-warning" for="flexSwitchCheckCheckedDisabled">댓글</label>
						</div>
						<div class="form-check form-switch">
						  <input class="form-check-input" id="flexSwitchCheckCheckedDisabled" value="일정" type="checkbox" ${scheChk }/>
						  <label class="form-check-label fs-1 text-info" for="flexSwitchCheckCheckedDisabled">회사일정</label>
						</div>
					</div>
				</div>
			</div>
			<!-- 개인정보  -->
			<div class="col-7 justify-content-center">
				<div class="card mb-3">
					<div class="card-body">
						<div class="d-flex justify-content-between align-items-center mb-5">
							<h3>내정보</h3>
							<button class="btn btn-outline-info" id="updateBtn" type="button">수정</button>
						</div>
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 uil uil-envelope-alt"> </span>
								<h5 class="text-1000 mb-0">메일</h5>
							</div>
							<p class="mb-0 text-800">${empVO.empEmail }</p>
						</div>
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 uil uil-phone"> </span>
								<h5 class="text-1000 mb-0">연락처</h5>
							</div>
							<p class="mb-0 text-800">${empVO.empHp }</p>
						</div>
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 uil uil-estate"> </span>
								<h5 class="mb-0">주소</h5>
							</div>
							<p class="mb-0 text-800">${empVO.empAdd1 }</p>
							<p class="mb-0 text-800">${empVO.empAdd2 }</p>
						</div>
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 uil uil-calendar-alt"> </span>
								<h5 class="text-1000 mb-0">입사일자</h5>
							</div>
							<p class="mb-0 text-800">
								<fmt:formatDate value="${empVO.empHire }" pattern="yyyy-MM-dd"/>
							</p>
						</div>
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 uil uil-nerd"> </span>
								<h5 class="text-1000 mb-0">당해연차</h5>
							</div>
							<p class="mb-0 text-800">${ayannList.ayannCnt }</p>
						</div>
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 fas fa-file-signature"> </span>
								<h5 class="text-1000 mb-0">서명이미지</h5>
							</div>
							<div class="avatar avatar-5xl">
								<c:if test="${not empty empVO.empSign }">
									<img class="rounded-soft" src="${empVO.empSign }" alt="signImg" id="signImg"/>
								</c:if>
								<c:if test="${empty empVO.empSign }">
									<img class="rounded-soft" src="/resources/assets/gw/sign.png" alt="signImg" id="signImg"/>
								</c:if>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 아이웍스 사진  -->
		<div class="row col-4 g-0 g-md-6 g-xl-6 justify-content-end">
			<div>
				<img alt="" src="${pageContext.request.contextPath }/resources/assets/gw/i-works3.png" style="height: 600px;">
			</div>
		</div>
	</div>
			
<!-- 				<div class="card mb-3"> -->
<!-- 					<div class="card-body" id="notiInputDiv"> -->
<!-- 						<div class="d-flex align-items-center mb-5"> -->
<!-- 							<h3>알림설정</h3> -->
<!-- 						</div> -->
<%-- 						<c:if test="${not empty notiList }"> --%>
<%-- 							<c:forEach items="${notiList }" var="noti"> --%>
<%-- 								<c:if test="${noti eq '메일' }"><c:set value="checked" var="mailChk"/></c:if> --%>
<%-- 								<c:if test="${noti eq '업무' }"><c:set value="checked" var="workChk"/></c:if> --%>
<%-- 								<c:if test="${noti eq '결재' }"><c:set value="checked" var="applyChk"/></c:if> --%>
<%-- 								<c:if test="${noti eq '참조' }"><c:set value="checked" var="draftChk"/></c:if> --%>
<%-- 								<c:if test="${noti eq '댓글' }"><c:set value="checked" var="replyChk"/></c:if> --%>
<%-- 								<c:if test="${noti eq '일정' }"><c:set value="checked" var="scheChk"/></c:if> --%>
<%-- 							</c:forEach> --%>
<%-- 						</c:if> --%>
<!-- 						<div class="form-check form-switch"> -->
<%-- 						  <input class="form-check-input" id="flexSwitchCheckDefault" value="메일" type="checkbox" ${mailChk }/> --%>
<!-- 						  <label class="form-check-label fs-1 text-primary" for="flexSwitchCheckDefault">메일</label> -->
<!-- 						</div> -->
<!-- 						<div class="form-check form-switch"> -->
<%-- 						  <input class="form-check-input" id="flexSwitchCheckChecked" value="업무" type="checkbox" ${workChk }/> --%>
<!-- 						  <label class="form-check-label fs-1 text-success" for="flexSwitchCheckChecked">업무</label> -->
<!-- 						</div> -->
<!-- 						<div class="form-check form-switch"> -->
<%-- 						  <input class="form-check-input" id="flexSwitchCheckDisabled" value="결재" type="checkbox" ${applyChk }/> --%>
<!-- 						  <label class="form-check-label fs-1 text-danger" for="flexSwitchCheckDisabled">결재</label> -->
<!-- 						</div> -->
<!-- 						<div class="form-check form-switch"> -->
<%-- 						  <input class="form-check-input" id="flexSwitchCheckDisabled" value="참조" type="checkbox" ${draftChk }/> --%>
<!-- 						  <label class="form-check-label fs-1 text-danger" for="flexSwitchCheckDisabled">참조</label> -->
<!-- 						</div> -->
<!-- 						<div class="form-check form-switch"> -->
<%-- 						  <input class="form-check-input" id="flexSwitchCheckCheckedDisabled" value="댓글" type="checkbox" ${replyChk }/> --%>
<!-- 						  <label class="form-check-label fs-1 text-warning" for="flexSwitchCheckCheckedDisabled">댓글</label> -->
<!-- 						</div> -->
<!-- 						<div class="form-check form-switch"> -->
<%-- 						  <input class="form-check-input" id="flexSwitchCheckCheckedDisabled" value="일정" type="checkbox" ${scheChk }/> --%>
<!-- 						  <label class="form-check-label fs-1 text-info" for="flexSwitchCheckCheckedDisabled">회사일정</label> -->
<!-- 						</div> -->
<!-- 					</div> -->
<!-- 				</div> -->
			
<script>
var updateBtn = $("#updateBtn");
updateBtn.on("click", function(){
	location.href="myInfoUpdateForm.do?empNo=${empVO.empNo}";
});

$("#notiInputDiv").on("change","input", function(){
	var values = [];
	
	 $("input:checked", "#notiInputDiv").each(function(){
		 values.push($(this).val());
	 });
	console.log("values : "+values);
	var data = {
			values : values
	}
	$.ajax({
		type : "post",
		url : "/updateNotiList.do",
		contentType : "application/json; charset=utf-8",
		data : JSON.stringify(data),
		success : function(res){
			console.log(res);
		}
	});
});






</script>