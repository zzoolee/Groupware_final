<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<c:if test="${not empty message }">
	<script type="text/javascript">
		alert("${message}");
		<c:remove var="message" scope="request"/>
		<c:remove var="message" scope="session"/>
	</script>
</c:if>

<h2>동호회개설</h2>
<br>

<sec:authentication property='principal.emp.empNo' var="empNo"/>
<sec:authentication property='principal.emp.empName' var="empName"/>

<form class="row g-3 needs-validation" novalidate="" method="post" action="/createclub.do" enctype="multipart/form-data">
<div class="col-12 col-xl-4 container-small">
	<div class="row g-2">
		<div class="col-12 col-xl-12">
			<div class="card mb-3">
				<div class="card-body">
					<div class="row gx-3">
						<div class="col-12 col-sm-6 col-xl-12">
							<div class="mb-4">
								<div class="d-flex flex-wrap mb-2">
									<h5 class="mb-0 text-1000 me-2">동호회명</h5><span class="text-danger">*</span>
								</div>
								<input class="form-control mb-xl-3" type="text" name="clubName" required="">
							</div>
						</div>
						<div class="col-12 col-sm-6 col-xl-12">
							<div class="mb-4">
								<div class="d-flex flex-wrap mb-2">
									<h5 class="mb-0 text-1000 me-2">동호회장</h5><span class="text-danger">*</span>
								</div>
								<span class="text-secondary">${empName }</span>
							</div>
						</div>
						<div class="col-12 col-sm-6 col-xl-12">
							<div class="mb-4">
								<div class="d-flex flex-wrap mb-2">
									<h5 class="mb-0 text-1000 me-2">동호회 소개글</h5><span class="text-danger">*</span>
								</div>
								<textarea class="form-control" name="clubInfo" rows="3" required=""></textarea>
							</div>
						</div>
						<div class="col-12 col-sm-6 col-xl-12">
							<div class="mb-4">
								<div class="d-flex flex-wrap mb-2">
									<h5 class="mb-0 text-1000 me-2">동호회 대표사진</h5><span class="text-danger">*</span>
								</div>
								<input class="form-control" type="file" name="picture" required="">
							</div>
						</div>
						<div class="col-12 col-sm-6 col-xl-12">
							<div class="mb-4">
								<div class="d-flex flex-wrap mb-2">
									<h5 class="mb-0 text-1000 me-2">동호회 개설사유</h5>
								</div>
								<textarea class="form-control" id="exampleTextarea" rows="5" name="clubReason"></textarea>
							</div>
						</div>
						<div class="col-12 col-sm-6 col-xl-12">
							<div class="mb-4">
								<input class="form-check-input" id="invalidCheck" type="checkbox" value="" required="" />
      							<label class="form-check-label mb-0" for="invalidCheck">동호회 운영정책에 동의합니다.</label>&nbsp;<span class="text-danger">*</span>
      							<div class="invalid-feedback">정책에 동의하셔야 개설이 완료됩니다.</div>
							</div>
						</div>
						<div>
							<button class="btn btn-info me-1 mb-1 container-small" type="submit" style="width:100px;">개설요청</button>
							<button class="btn btn-outline-info me-1 mb-1 container-small" id="fillBtn" type="button" style="width:100px;">자동완성</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
		

<script type="text/javascript">
$("#fillBtn").on("click",function(){
	$("input[name='clubName']").val("댄스동호회");
	$("textarea[name='clubInfo']").val("스우파 이기자");
	$("textarea[name='clubReason']").val("신나게 춤추고 싶습니다!");
});
</script>