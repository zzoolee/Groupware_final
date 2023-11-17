<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
Date now = new Date();
pageContext.setAttribute("now", now);
%>
<fmt:formatDate value="${now}" pattern="HH:mm" var="formattedDate" />

<c:if test="${not empty massage }">
<script>
$(document).ready(function(){
	alert('${massage}');
});
</script>
</c:if>

<c:if test="${not empty message }">
	<script>
$(document).ready(function(){
	var messageModal = $('#messageModal');
	messageModal.modal('show');
});
</script>
</c:if>

<c:set value="${attendVO }" var="attendVO" />
<c:set value="${attendSum }" var="attendSum" />
<c:set value="${monthExist }" var="monthExist" />
<c:set value="${monthList }" var="monthList" />

<h2>직원관리 > 연차관리</h2>
<p>
	<span class="text-danger" data-feather="check"></span>
	당해연도 연차에 대해 확인/관리 가능합니다.
</p>

<div class="card mt-7" style="border-radius:20px; padding:20px;">
<!-- 	<div class="row pb-3 pt-3"> -->
<!-- 		<div class="col-1"></div> -->
<!-- 		<div class="col-2"> -->
<!-- 		 	<button class="btn btn-phoenix-secondary me-1 mb-3" type="button" id="draftBtn"> -->
<!-- 		 	연차부여 -->
<!-- 		 	</button> -->
<!-- 		</div> -->
<!-- 		<div class="col-2"> -->
		
<!-- 		</div> -->
<!-- 		<div class="col-3"></div> -->
<!-- 		<div class="col-3"> -->
<!-- 			<form action="/attendance.do" method="POST" id="yearMonthForm"> -->
<!-- 				<select class="form-select mb-3 text-center" -->
<!-- 					aria-label=".form-select-lg example" name="yearMonth" -->
<!-- 					id="deptSelect"> -->
<!-- 					if문으로 돌리기 -->
<!-- 					<option>부서를 선택하세요</option> -->
<!-- 					부서이름 forEach -->
<!-- 					부서이름 forEach -->
<!-- 					부서이름 forEach -->
<%-- 					<c:forEach var="deptList" items="${deptList}" varStatus="status"> --%>
<%-- 						<c:if test="${fn:length(deptList.deptCd) == 4 }"> --%>
<%-- 						<option value="${deptList.deptCd }">${deptList.deptName }</option> --%>
<%-- 						</c:if> --%>
<%-- 					</c:forEach> --%>
<!-- 				</select> -->
<!-- 			</form> -->
<!-- 		</div> -->
<!-- 	</div> -->

<!-- 	<div class="row"> -->
<!-- 		<div class="col-1"></div> -->
<!-- 		<div class="col-10 d-flex justify-content-center text-center pb-5"> -->
<!-- 			<table class="table table-striped text-center"> -->
<!-- 				<thead> -->
<!-- 					<tr> -->
<!-- 						<th scope="col">부서명</th> -->
<!-- 						<th scope="col">사원명</th> -->
<!-- 						<th scope="col">총연차</th> -->
<!-- 						<th scope="col">사용연차</th> -->
<!-- 						<th scope="col">잔여연차</th> -->
<!-- 						<th scope="col"></th> -->
<!-- 						<th scope="col"></th> -->
<!-- 					</tr> -->
<!-- 				</thead> -->
<!-- 				<tbody id="attendBody"> -->

<!-- 				</tbody> -->
<!-- 			</table> -->
<!-- 		</div> -->
<!-- 	</div> -->

<div id="tableExample4" data-list='{"valueNames":["empNo","empName","empDept","empRank","empLevel","empWorkse","empHire"],"page":10,"pagination":true,"filter":{"key":"empDept"}}'>
		<div class="row justify-content-end g-0">
			<div class="col-auto px-3">
				<button class="btn btn-soft-warning me-1 mb-1" type="button" id="insertAllAyannBtn">사내 일괄 연차부여</button>
				<button class="btn btn-soft-success me-1 mb-1" type="button" id="ayannMailAllBtn">전체 연차촉진 메일 보내기</button>
			</div>
			<div class="col-auto px-3">
				<select class="form-select form-select-sm mb-3" data-list-filter="data-list-filter">
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
		</div>
		<div class="table-responsive">
			<table class="table mb-0">
				<thead>
					<tr class="bg-light text-center">
						<th class="sort border-top ps-3" data-sort="empNo" width="11%">사번</th>
						<th class="sort border-top" data-sort="empName" width="8%">이름</th>
						<th class="sort border-top" data-sort="empDept" width="18%">부서</th>
						<th class="sort border-top" data-sort="empRank" width="8%">직급</th>
						<th class="sort border-top" data-sort="empHire" width="13%">입사일</th>
						<th class="sort border-top" data-sort="empHire" width="8%">총연차</th>
						<th class="sort border-top" data-sort="empHire" width="8%">사용연차</th>
						<th class="sort border-top" data-sort="empHire" width="8%">잔여연차</th>
						<th class="sort border-top" data-sort="empHire" width="20%">비고</th>
					</tr>
				</thead>
				
				<tbody class="list" id="tBody">
					<c:set var="empList" value="${ayannList }"></c:set>
					<c:choose>
						<c:when test="${empty ayannList }">
							<tr class="text-center">
								<td class="align-middle ps-3 empNo" colspan="10">연차 정보가 존재하지 않습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach items="${ayannList }" var="emp">
								<tr class="text-center">
									<td class="align-middle ps-3 empNo"><a href="/adminEmpSelect.do?empNo=${emp.empNo }">${emp.empNo }</a></td>
									<td class="align-middle empName">${emp.empName }</td>
									<td class="align-middle empDept">
										<div class="badge badge-phoenix fs--2 badge-phoenix-primary">
											<span class="fw-bold" style="font-size:15px">${emp.deptName }</span><span class="ms-1 fas fa-stream"></span>
										</div>
									</td>
									<td class="align-middle empRank">${emp.cdName }</td>
									<td class="align-middle empLevel"><fmt:formatDate value="${emp.empHire }" pattern="YYYY-MM-dd" var="hireDate"/> ${hireDate }</td>
									<td class="align-middle empWorkse">${emp.ayannCnt }</td>
									<td class="align-middle empHire">${emp.ayannCnt - emp.ayannRest }</td>
									<td class="align-middle empHire">${emp.ayannRest }</td>
									<td class="align-middle empHire">
										<button class="btn btn-soft-danger  me-1 mb-1 updateAyannBtn" type="button" data-value=${emp.empNo }>연차수정</button>
									</td>
								</tr>							
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
		<div class="row">
			<div class="d-flex justify-content-center mt-3">
				<button class="page-link" data-list-pagination="prev">
					<span class="fas fa-chevron-left"></span>
				</button>
				<ul class="mb-0 pagination"></ul>
				<button class="page-link pe-0" data-list-pagination="next">
					<span class="fas fa-chevron-right"></span>
				</button>
			</div>
		</div>
		<form action="/empWorkseUpdate.do" method="post" id="empWorkseUdt"></form>
	</div>
</div>

<!-- <div class="row align-items-center py-1"> -->
<!-- 	<div class="pagination d-none"></div> -->
<!-- 	<div class="col d-flex fs--1"> -->
<!-- 		<!-- 하단부 -->

<!-- 	</div> -->
<!-- </div> -->
<!-- <div class="row" style="margin: 15px 0px 20px 0px;"> -->
<!-- 	<div class="col-9"></div> -->
<!-- 	<div class="col-3 text-end"></div> -->
<!-- </div> -->
<!-- 미리보기를 띄워줄 모달 -->
<div class="modal fade" id="updateModal" tabindex="-1"
	aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="verticallyCenteredModalLabel">연차 수정</h5>
				<button class="btn p-1" type="button" data-bs-dismiss="modal"
					aria-label="Close">
					<span class="fas fa-times fs--1"></span>
				</button>
			</div>
			<div
				class="modal-body d-flex justify-content-center align-items-center">
				<form action="/ayannUpdate.do" method="POST" id="ayannForm">
					<div class="row">
						<div class="col-6">
							<select class="form-select form-select-sm mb-3 text-start"
								id="ayannCnt" name="ayannCnt">
								<option value="총연차" selected>총연차</option>
								<option value="12">12</option>
								<option value="13">13</option>
								<option value="14">14</option>
								<option value="15">15</option>
								<option value="16">16</option>
								<option value="17">17</option>
								<option value="18">18</option>
								<option value="19">19</option>
								<option value="20">20</option>
								<option value="21">21</option>
								<option value="22">22</option>
								<option value="23">23</option>
								<option value="24">24</option>
								<option value="25">25</option>
								<option value="26">26</option>
							</select>
						</div>
						<div class="col-6">
							<select class="form-select form-select-sm mb-3 text-start"
								id="ayannRest" name="ayannRest">
								<option value="잔여연차" selected>잔여연차</option>
								<option value="0">0</option>
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
								<option value="6">6</option>
								<option value="7">7</option>
								<option value="8">8</option>
								<option value="9">9</option>
								<option value="10">10</option>
								<option value="11">11</option>
								<option value="12">12</option>
								<option value="13">13</option>
								<option value="14">14</option>
								<option value="15">15</option>
								<option value="16">16</option>
								<option value="17">17</option>
								<option value="18">18</option>
								<option value="19">19</option>
								<option value="20">20</option>
								<option value="21">21</option>
								<option value="22">22</option>
								<option value="23">23</option>
								<option value="24">24</option>
								<option value="25">25</option>
								<option value="26">26</option>
							</select>
						</div>
						<input type="hidden" value="" name="empNo" id="AyannFormId" />
						<div class="row">
							<div class="col-12">
								<input class="form-check-input" id="flexCheckChecked"
									type="checkbox" value="" /> <label class="form-check-label"
									for="flexCheckChecked"><h6>회사내규에 의한 수정이 아닐시, 징계를
										받을 수 있음에 동의합니다.</h6></label>

							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button class="btn btn-info downloadFileBtn" type="button"
					id="updateModalBtn">수정</button>
				<button class="btn btn-danger" type="button" data-bs-dismiss="modal"
					id="modalFileCancleBtn">취소</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	
// 	$(document).on('change', '#deptSelect', function(){
// 		var deptNo = $('#deptSelect').val();
// 		var deptNo = { "deptNo" : deptNo }
// 		$.ajax({
// 			type : "POST",
// 			url : "/adminAyannAjax.do",
// 			data : JSON.stringify(deptNo),
// 			contentType : "application/json; charset=utf-8",
// 			success : function(result){
// 				console.log(result);
// 			}
// 		});
// 	});
	
	// 전체연차 부여
	$(document).on('click', '#insertAllAyannBtn', function(){
		customConfirm('입사년도에 따른 일괄 연차부여를 진행하시겠습니까?').then((userConfirmed) => {
	          if (userConfirmed) {
	        	  location.href = "/insertAllAyannBtn.do";
	          }else {
	        	 return false;
	          }
		})
	});
	// 전체 연차 촉진메일 부여
	$(document).on('click', '#ayannMailAllBtn', function(){
		var j = 0;
		customConfirm('전 사원 일괄 연차촉진 메일전송을 진행 하시겠습니까? (잔여연차가 남은 사원에 한함)').then((userConfirmed) => {
	          if (userConfirmed) {
	        	  
	        	  // 발표진행 후 삭제처리
	        	  // 발표진행 후 삭제처리
	        	  // 발표진행 후 삭제처리
	        	  // 발표진행 후 삭제처리
	        	  for(var i = 0; i < 100000000; i++) {
	        		  j += i;
	        	  }
	        	  alert('연차촉진 메일전송이 완료되었습니다');
	        	  return false;
	        	// 발표진행 후 삭제처리
	        	// 발표진행 후 삭제처리
	        	// 발표진행 후 삭제처리
	        	// 발표진행 후 삭제처리
	        	  
		location.href = "/ayannMailAllBtn.do";
		} else {
			return false;
		}
		})
	});
	var empNo = "";
	// 개인 연차 업데이트
	$(document).on('click', '.updateAyannBtn', function(){
		console.log($(this).data('value'));
		empNo = $(this).data('value');
		$('#updateModal').modal('show');
	});
	$(document).on('click', '#updateModalBtn', function(){
		var ayannList = "";
		if($('#ayannCnt').val() == '총연차') {
			alert("총 연차를 선택해주세요");
			return false;
		}
		if($('#ayannRest').val() == '잔여연차') {
			alert("잔여연차를 선택해주세요");
			return false;
		}
		if(Number($('#ayannCnt').val()) < Number($('#ayannRest').val())) {
			console.log($('#ayannCnt').val());
			console.log($('#ayannRest').val());
			alert("총연차와 잔여연차를 다시 확인해주세요")
			return false;
		}
		var flexCheckChecked = $('#flexCheckChecked');
		if(!flexCheckChecked.prop('checked')) {
			alert("연차수정 처리방안에 동의해주세요");
			return false;
		}

		customConfirm('회사내규에 따른 수정이외의 작업은 징계를 받을 수 있습니다. 수정작업을 진행하시겠습니까?').then((userConfirmed) => {
	          if (userConfirmed) {
		$('#AyannFormId').val(empNo);
		$('#ayannForm').submit();
	          }else {
	        	  return false;
	          }
		})
	});
	
});
</script>





