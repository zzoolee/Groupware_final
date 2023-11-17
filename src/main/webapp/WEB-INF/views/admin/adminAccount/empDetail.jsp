<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<div class="pb-9">
	<c:choose>
		<c:when test="${empty status}">
			<c:set var="disabledType" value="disabled"/>
			<c:set var="btnName" value="수정"/>
		</c:when>
		<c:otherwise>
			<c:set var="disabledType" value=""/>
			<c:set var="btnName" value="수정사항 저장"/>
		</c:otherwise>
	</c:choose>
	<div class="row">
		<div class="col-12">
			<div class="row align-items-center justify-content-between g-3 mb-3">
				<div class="col-12 col-md-auto">
					<h2 class="mb-0"><a href="/adminEmpList.do">계정목록</a> > 개인정보</h2>
				</div>
			</div>
		</div>
	</div>
	<c:if test="${not empty msg }">
		<script type="text/javascript">
			alert("${msg}");
			<c:remove var="msg" scope="request"/>
			<c:remove var="msg" scope="session"/>
		</script>
	</c:if>
	<div class="row col-12 mt-3">
	<div class="row col-7 justify-content-center">
		<div class="col-md-5 col-lg-5 col-xl-4">
		<form action="empUpdate.do" method="post" id=updateForm>
		<input type="hidden" name="empNo" value="${empVO.empNo }">
			<div class="card mb-3">
				<div class="card-body">
					<div class="row align-items-center g-3 text-center text-xxl-start">
						<div class="col-12 col-xxl-auto">
							<div class="avatar avatar-5xl">
								<c:choose>
									<c:when test="${not empty empVO.empPhoto }">
										<img class="rounded-soft" src="${empVO.empPhoto }" alt="profileImg" id="imgProfile"/>
									</c:when>
									<c:otherwise>
										<img class="rounded-soft" src="/resources/assets/gw/profile.png" alt="profileImg" id="imgProfile"/>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="col-12 col-sm-auto flex-1">
							<div class="d-flex align-items-center">
								<h3 class="fw-bolder mb-2">${empVO.empName }</h3>
								<button class="btn btn-link" id="updatFormBtn" type="button">${btnName }</button>
							</div>
							<p class="mb-0">사번 : <span class="fw-bold text-info" id="empNoVal">${empVO.empNo }</span></p>
							<p class="mb-0">직급 : <span>								
									<select class="form-select form-select-sm mb-3 fw-bold" name="empRank" id="empRank" ${disabledType}>
											<option value="A201" <c:if test="${empVO.codeVO.cdName eq '사원'}">selected</c:if>>사원</option>
											<option value="A202" <c:if test="${empVO.codeVO.cdName eq '대리'}">selected</c:if>>대리</option>
											<option value="A203" <c:if test="${empVO.codeVO.cdName eq '과장'}">selected</c:if>>과장</option>
											<option value="A204" <c:if test="${empVO.codeVO.cdName eq '차장'}">selected</c:if>>차장</option>
											<option value="A205" <c:if test="${empVO.codeVO.cdName eq '부장'}">selected</c:if>>부장</option>
											<option value="A206" <c:if test="${empVO.codeVO.cdName eq '임원'}">selected</c:if>>임원</option>
									</select>
								</span>
							</p>	
							<p class="mb-0">소속 :
								<select class="form-select form-select-sm mb-3 fw-bold" data-list-filter="data-list-filter" id="deptCd" name="deptCd" ${disabledType}>
									<option value="A011" <c:if test="${empVO.deptVO.deptName eq '경영지원팀'}">selected</c:if>>경영지원팀</option>
									<option value="A012" <c:if test="${empVO.deptVO.deptName eq '인사총무팀'}">selected</c:if>>인사총무팀</option>
									<option value="A013" <c:if test="${empVO.deptVO.deptName eq '구매조달팀'}">selected</c:if>>구매조달팀</option>
									<option value="A014" <c:if test="${empVO.deptVO.deptName eq '콜센터'}">selected</c:if>>콜센터</option>
									<option value="B011" <c:if test="${empVO.deptVO.deptName eq '시스템영업팀'}">selected</c:if>>시스템영업팀</option>
									<option value="B012" <c:if test="${empVO.deptVO.deptName eq '공공영업팀'}">selected</c:if>>공공영업팀</option>
									<option value="B013" <c:if test="${empVO.deptVO.deptName eq '기술지원팀'}">selected</c:if>>기술지원팀</option>
									<option value="B014" <c:if test="${empVO.deptVO.deptName eq '교육운영팀'}">selected</c:if>>교육운영팀</option>
									<option value="C011" <c:if test="${empVO.deptVO.deptName eq '보안개발팀'}">selected</c:if>>보안개발팀</option>
									<option value="C012" <c:if test="${empVO.deptVO.deptName eq 'SW개발팀'}">selected</c:if>>SW개발팀</option>
									<option value="D011" <c:if test="${empVO.deptVO.deptName eq '사업기획팀'}">selected</c:if>>사업기획팀</option>
									<option value="D012" <c:if test="${empVO.deptVO.deptName eq 'SM영업1팀'}">selected</c:if>>SM영업1팀</option>
									<option value="D013" <c:if test="${empVO.deptVO.deptName eq 'SM영업2팀'}">selected</c:if>>SM영업2팀</option>
									<option value="D014" <c:if test="${empVO.deptVO.deptName eq '서비스센터'}">selected</c:if>>서비스센터</option>
									<option value="E011" <c:if test="${empVO.deptVO.deptName eq '수도권'}">selected</c:if>>수도권</option>
									<option value="E012" <c:if test="${empVO.deptVO.deptName eq '중부권'}">selected</c:if>>중부권</option>
									<option value="E013" <c:if test="${empVO.deptVO.deptName eq '서부권'}">selected</c:if>>서부권</option>
									<option value="E014" <c:if test="${empVO.deptVO.deptName eq '동부권'}">selected</c:if>>동부권</option>
									<option value="F01" <c:if test="${empVO.deptVO.deptName eq '연구개발본부'}">selected</c:if>>연구개발본부</option>
								</select>
							</p>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
		<div class="row col-7">	
			<div class="card mb-3">
				<div class="card-body">
					<div class="d-flex align-items-center mb-5">
						<h3>사원 정보</h3>
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
							<span class="me-2 uil uil-user"> </span>
							<h5 class="text-1000 mb-0">주민번호</h5>
						</div>
						<p class="mb-0 text-800">${fn:substring(empVO.empRegno, 0, 7)}-*******</p>
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
						<p class="mb-0 text-800"><fmt:formatDate value="${empVO.empHire }" pattern="yyyy-MM-dd"/></p>
					</div>
					<div class="mb-4">
						<div class="d-flex align-items-center mb-1">
							<span class="me-2 uil uil-nerd"> </span>
							<h5 class="text-1000 mb-0">당해연차</h5>
						</div>
						<p class="mb-0 text-800">12</p>
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
		<!-- 아이웍스 사진  -->
		<div class="row col-4">
			<div>
				<img alt="" src="${pageContext.request.contextPath }/resources/assets/gw/i-works3.png" style="height: 600px;">
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">

var updatFormBtn = $("#updatFormBtn");
var updateForm = $("#updateForm");

console.log(updatFormBtn.text());
updatFormBtn.on("click", function(){
	
	if(updatFormBtn.text() == '수정'){
	 location.href="/adminEmpSelect.do?empNo=${empVO.empNo}&msg=msg";
	}else{
		updateForm.submit();
	}
 
});

</script>