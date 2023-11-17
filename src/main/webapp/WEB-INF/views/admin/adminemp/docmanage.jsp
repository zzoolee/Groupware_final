<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="mb-9">
	<div class="row g-2 mb-4">
		<div class="col-auto">
			<h2 class="mb-0">급여명세서관리</h2>
		</div>
	</div>
	</br>
	</br>
	<c:if test="${not empty msg }">
		<script type="text/javascript">
			alert("${msg }");
			<c:remove var="msg" scope="request"/>
			<c:remove var="msg" scope="session"/>
		</script>
	</c:if>
	<div class="card">
		<div class="card-body">
			<div id="tableExample4" data-list='{"valueNames":["empNo","empName","empDept","empRank","empLevel","empWorkse","empHire"],"page":10,"pagination":true,"filter":{"key":"empDept"}}'>
				<div class="row g-0">
					<div class="col-auto px-3">
						<select class="form-select form-select-sm mb-3"
							data-list-filter="data-list-filter">
							<option selected="" value="">부서전체조회</option>
							<option value="경영지원팀">경영지원팀</option>
							<option value="인사총무팀">인사총무팀</option>
							<option value="구매조달팀">구매조달팀</option>
							<option value="콜센터">콜센터</option>
							<option value="시스템영업팀">시스템영업팀</option>
							<option value="공공영업팀">공공영업팀</option>
							<option value="기술지원팀">기술지원팀</option>
							<option value="교육운영팀">교육운영팀</option>
							<option value="보안개발팀">보안개발팀</option>
							<option value="개발팀">SW개발팀</option>
							<option value="사업기획팀">사업기획팀</option>
							<option value="SM영업1팀">SM영업1팀</option>
							<option value="SM영업2팀">SM영업2팀</option>
							<option value="서비스센터">서비스센터</option>
							<option value="수도권">수도권</option>
							<option value="중부권">중부권</option>
							<option value="서부권">서부권</option>
							<option value="동부권">동부권</option>
							<option value="연구개발본부">연구개발본부</option>
						</select>
					</div>
					<div class="col-auto px-3 ms-auto">
			            <button class="btn btn-primary" type="button" id="formDownBtn">명세서 양식 다운로드</button>
			            <button class="btn btn-primary" type="button" id="fileUploadBtn">명세서 업로드</button>
					</div>
				</div>
				<div class="table-responsive">
					<table class="table mb-0" id="tb_02">
						<thead>
							<tr class="bg-light text-center">
								<th class="sort border-top ps-3" data-sort="empNo">사번</th>
								<th class="sort border-top" data-sort="empName">이름</th>
								<th class="sort border-top" data-sort="empDept">부서</th>
								<th class="sort border-top" data-sort="empRank">직급</th>
								<th class="sort border-top" data-sort="empHire">입사일</th>
							</tr>
						</thead>
						
						<tbody class="list" id="tBody">
							<c:set var="empList" value="${empList }"></c:set>
							<c:choose>
								<c:when test="${empty empList }">
									<tr class="text-center">
										<td class="align-middle ps-3 empNo" colspan="7">사원 정보가 존재하지 않습니다.</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:forEach items="${empList }" var="emp">
										<tr class="text-center">
											<td class="align-middle ps-3 empNo">
												<button class="btn btn-link me-1 mb-1 selectPaystubBtn" type="button" style="font-size:1em;">${emp.empNo }</button>
											</td>
											<td class="align-middle empName">${emp.empName }</td>
											<td class="align-middle empDept">
												<div class="badge badge-phoenix fs--2 badge-phoenix-primary">
													<span class="fw-bold" style="font-size:1.5em;">${emp.deptVO.deptName }</span><span class="ms-1 fas fa-stream"></span>
												</div>
											</td>
											<td class="align-middle empRank">${emp.codeVO.cdName }</td>
											<td class="align-middle empHire">
												<fmt:formatDate value="${emp.empHire }" pattern="yyyy-MM-dd"/>
											</td>
										</tr>							
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
						
					</table>
				</div>
					<div class="col-12 d-flex justify-content-center mt-3">
						<button class="page-link" data-list-pagination="prev">
							<span class="fas fa-chevron-left"></span>
						</button>
						<ul class="mb-0 pagination"></ul>
						<button class="page-link pe-0" data-list-pagination="next">
							<span class="fas fa-chevron-right"></span>
						</button>
					</div>
			</div>
		</div>
	</div>
</div>
<!-- 파일 업로드 모달창  -->
<div class="modal fade" id="FileUploadModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="verticallyCenteredModalLabel">파일 업로드</h5>
			</div>
			<div class="modal-body">
				<form class="needs-validation" novalidate="" action="/uploadPayFile.do" method="post" enctype="multipart/form-data" id="FormUploadFile">
					<p class="text-700 lh-lg mb-0"> 업로드할 엑셀파일을 선택해주세요
					<input class="form-control" name="empExcel" id="empExcel" type="file" accept=".xlsx, .xls" required=""/>
					<div class="checkExcelFile text-danger text-center"></div>
					</p>
				</form>
			</div>
			<div class="modal-footer">
				<button class="btn btn-primary" type="button" id="excelUploadBtn">Okay</button>
				<button class="btn btn-outline-primary" type="button" data-bs-dismiss="modal">Cancel</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	// 최근급여명세서가져오는 버튼
// 	var selectPaystubBtn = $(".selectPaystubBtn");
	// 양식 다운로드 버튼
	var formDownBtn = $("#formDownBtn");
	// 모달창 띄우기 버튼
	var fileUploadBtn = $("#fileUploadBtn");
	// 파일 전송
	var excelUploadBtn = $("#excelUploadBtn");
	// 모달 띄우기
	fileUploadBtn.on("click", function(){
	$("#FileUploadModal").modal("show");
	});
	// 파일 전송
	excelUploadBtn.on("click",function(){
		if($("#empExcel").val() == null || $("#empExcel").val() == ""){
			$(".checkExcelFile").text("업로드 할 파일을 등록해주세요!");
			return;
		}
		$('#FormUploadFile').submit();
	});
	
	formDownBtn.on("click", function(){
		location.href="/excelFormDown.do";
// 		$.ajax({
// 			type : "post",
// 			url : "/excelFormDown.do",
// 			success : function(res){
// 				if(res === "ok"){
// 				alert("양식을 다운로드하였습니다.\n 저장경로 : D: > temp");
// 				}
// 			}
// 		});
	});
	
	
	$("#tb_02").on("click",".selectPaystubBtn", function(){
		var empNo = $(this).text();
		console.log("empNo 넘어오는지 확인 : ",empNo);
		var data = {
				empNo : empNo
		};
		
		$.ajax({
			type : "post",
			url : "/selectRecentPaystub.do",
			data : JSON.stringify(data),
			contentType : "application/json; charset=utf-8",
			success : function(res){
				console.log("ajax로 가져온 값  : ", res);
				if(res.includes("sal")){
					openPopup(res,empNo);
				}else{
					alert(res);
				}
			}
		});
		
	});


function openPopup(salNo,empNo){
	console.log("salNo 확인 : ",salNo);
	 window.open('${pageContext.request.contextPath}/payStubAdmin.do?salNo='+salNo+"&empNo="+empNo, 'document', 'left=600, width=810, height=800, scrollbars=yes');

}

});



</script>







