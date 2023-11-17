
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<h2>직원관리 > 근태관리</h2>
<p>
	<span class="text-danger" data-feather="check"></span>
	전사원 근태에 대해 확인/관리 가능합니다.
</p>

<div class="card mt-7" style="border-radius:20px; padding:20px;">

<div id="tableExample4" data-list='{"valueNames":["empNo","empName","empDept","empRank","atType","atOver","atLate","atOff"],"page":10,"pagination":true,"filter":{"key":"empDept"}}'>
		<div class="row justify-content-end g-0">
			<div class="col-auto px-3">
			<form action="/adminattend.do" method="POST" id="yearInfoForm">
				<select class="form-select form-select-sm mb-3" name="atDate" id="yearSelect">
					<option value="날짜를 선택해주세요">날짜를 선택해주세요</option>
					<c:forEach items="${attendYear }" var="year" varStatus="status">
						<fmt:formatDate value="${year.atDate }" pattern="YYYY-MM" var="format"/>
						
						<!-- GET방식으로 넘어와서 POST에서 담아주는 모델값이 없다면 -->
						<c:if test="${empty atDateStr }">
							<!-- 가장 첫번째에 해당하는 값은(최신값은) -->
							<c:if test="${status.first }">
								<!-- 선택되어진 상태로 한다. -->
								<option value="${format }"  selected="" class="">${format }</option>
							</c:if>
							<!-- 첫번째가 아닐경우(최신값이 아닐경우) -->
							<c:if test="${not status.first }">
								<!-- 셀렉티드 속성이 없다. -->
								<option value="${format }" class="">${format }</option>
							</c:if>
						</c:if>
						
						<!-- POST방식으로 넘어와서 POST에서 담아주는 모델값이 있다면 -->
						<c:if test="${not empty atDateStr }">
							<!-- 포스트에서 넘겨준 셀렉트했던 내용인 atDateStr과 내용의 값이 일치하다면 -->
							<c:if test="${atDateStr eq format }">
								<!-- 선택했던 값이 그대로 선택이 되도록한다 -->
								<option value="${format }"  selected="" class="">${format }</option>
							</c:if>	
							<!-- 그이외의 값들은 -->
							<c:if test="${atDateStr ne format }">
								<!-- 셀렉트상태가 아닌상태로 한다. -->
								<option value="${format }" class="">${format }</option>
							</c:if>	
						</c:if>
					</c:forEach>
				</select>
			</form>
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
						<th class="sort border-top ps-3" data-sort="empNo">사번</th>
						<th class="sort border-top" data-sort="empName">이름</th>
						<th class="sort border-top" data-sort="empDept">부서</th>
						<th class="sort border-top" data-sort="empRank">직급</th>
						<c:if test="${attendList[0].atType ne ''}">
							<th class="sort border-top" data-sort="atType">현재근무유형</th>
						</c:if>
						<th class="sort border-top" data-sort="atOver">연장근무시간</th>
						<th class="sort border-top" data-sort="atLate">지각횟수</th>
						<th class="sort border-top" data-sort="atOff">조퇴횟수</th>
						<th class="border-top">비고</th>
					</tr>
				</thead>
				
				<tbody class="list">
					<c:choose>
						<c:when test="${empty attendList }">
							<tr class="text-center">
								<td class="align-middle ps-3 empNo" colspan="10">사원 정보가 존재하지 않습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach items="${attendList }" var="attend">
								<tr class="text-center">
									<td class="align-middle ps-3 empNo">${attend.empNo }</a></td>
									<td class="align-middle empName">${attend.empName }</td>
									<td class="align-middle empDept">
										<div class="badge badge-phoenix fs--2 badge-phoenix-primary">
											<span class="fw-bold" style="font-size:15px">${attend.deptName }</span><span class="ms-1 fas fa-stream"></span>
										</div>
									</td>
									<td class="align-middle empRank">${attend.cdName }</td>
									<c:if test="${attend.atType ne '' }">
										<td class="align-middle atType">${attend.atType }</td>
									</c:if>
									<td class="align-middle atOver">${attend.sumOvertime }시간</td>
									<td class="align-middle atLate">${attend.sumResultlate }회</td>
									<td class="align-middle atOff">${attend.sumResultoff }회</td>
									<td class="align-middle"><button class="btn btn-phoenix-info me-1 mb-1 detailBtn" type="button" data-name="${attend.empName }" data-value="${attend.empNo }">상세보기</button></td>
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
	</div>
</div>

<br>

<!-- 미리보기를 띄워줄 모달 -->
<div class="modal fade" id="attendModal" tabindex="-1"
	aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="verticallyCenteredModalLabel">사원 근태 상세보기</h5>
				<button class="btn p-1" type="button" data-bs-dismiss="modal"
					aria-label="Close">
					<span class="fas fa-times fs--1"></span>
				</button>
			</div>
			<div
				class="modal-body d-flex justify-content-center align-items-center">
				<form action="/ayannUpdate.do" method="POST" id="ayannForm">
					<div class="row" >
						<form action="" method="" id="">
							<table class="table table-striped">
								<thead>
									<tr>
										<th scope="col" class="text-center">날짜</th>
										<th scope="col" class="text-center">사번</th>
										<th scope="col" class="text-center">이름</th>
										<th scope="col" class="text-center">출근</th>
										<th scope="col" class="text-center">퇴근</th>
										<th scope="col" class="text-center">연장</th>
										<th scope="col" class="text-center">유형</th>
										<th scope="col" class="text-center">결과</th>
										<th scope="col" class="text-center">주차</th>
									</tr>
								</thead>
								<tbody id="dataDiv">
									<!-- 데이터 들어갈곳. -->
								</tbody>
							</table>
						</form>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button class="btn btn-info downloadFileBtn" type="button"
					id="excelDownBtn">엑셀다운로드</button>
				<button class="btn btn-danger" type="button" data-bs-dismiss="modal"
					id="modalFileCancleBtn">취소</button>
			</div>
		</div>
	</div>
</div>
<!-- 엑셀데이터를 폼으로 쏴줄 히든 공간 -->
<form action="/adminPOIForm.do" method="POST" id="poiForm">
	<input type="hidden" value="" name="excelAtDate" id="excelAtDate" />
	<input type="hidden" value="" name="excelEmpNo" id="excelEmpNo" />
	<input type="hidden" value="" name="excelEmpName" id="excelEmpName" />
	<input type="hidden" value="" name="excelStartHour" id="excelStartHour" />
	<input type="hidden" value="" name="excelEndHour" id="excelEndHour" />
	<input type="hidden" value="" name="excelOvertime" id="excelOvertime" />
	<input type="hidden" value="" name="excelAtType" id="excelAtType" />
	<input type="hidden" value="" name="excelAtResult" id="excelAtResult" />
	<input type="hidden" value="" name="excelAtWeek" id="excelAtWeek" />
</form>
<script type="text/javascript">
$(function(){
	
	$(document).on('change', '#yearSelect', function(){
		console.log($('#yearSelect').val());
		if($('#yearSelect').val() == "날짜를 선택해주세요") {
			return false;
		}else {
			$('#yearInfoForm').submit();
		}
	});
	
	
	// 엑셀에 넣을 데이터를 담아놓을 배열들.
	var excelAtDate = [];
	var excelEmpNo = [];
	var excelEmpName = [];
	var excelStartHour = [];
	var excelEndHour = [];
	var excelOvertime = [];
	var excelAtType = [];
	var excelAtResult = [];
	var excelAtWeek = [];
	
	var empName = "";
	var yearDate = "";
	$(document).on('click', '.detailBtn', function(){
		if($('#yearSelect').val() == "날짜를 선택해주세요") {
			alert("날짜를 선택해주세요.");
			return false;
		}
		var empNo = $(this).data('value');
		console.log("이엠피넘버 : "+empNo);
		empName = $(this).data('name');
		var str = "";
		var dataDiv = $('#dataDiv');
		var year = $('#yearSelect').val();
		yearDate = year;
		var data = {
				"empNo" : empNo,
				"year" : year
		}
		
		// 엑셀에 담을 데이터를 보관할 배열 초기화.
		excelAtDate = [];
		excelEmpNo = [];
		excelEmpName = [];
		excelStartHour = [];
		excelEndHour = [];
		excelOvertime = [];
		excelAtType = [];
		excelAtResult = [];
		excelAtWeek = [];
		
		$.ajax({
			type : "POST",
			url : "/selectAdminAjaxAttend.do",
			data : JSON.stringify(data),
			contentType : "application/json; charset=utf-8",
			success : function(result){
				dataDiv.html('');
				if(result.attendList.length <= 0) {
					alert("근태정보가 없습니다");
					return false;
				}
				result.attendList.forEach(function(item){
					// 근무 일자를 포멧데이터로 처리
					var formatDate = new Date(item.atDate); // dateStr는 Date 객체로 변환할 문자열입니다.
					var year = formatDate.getFullYear(); // 연도
					var month = (formatDate.getMonth() + 1).toString().padStart(2, '0'); // 월 (0부터 시작하므로 1을 더합니다)
					var day = formatDate.getDate().toString().padStart(2, '0');
					
					// 시작 일자를 포멧데이터로 처리
					var formatDate = new Date(item.atStart);
					var startHour = formatDate.getHours().toString().padStart(2, '0');
					var startMinute = formatDate.getMinutes().toString().padStart(2, '0');
					
					// 퇴근시간을 포멧데이터로 처리
					var formatDate = new Date(item.atEnd);
					var endHour = formatDate.getHours().toString().padStart(2, '0');
					var endMinute = formatDate.getMinutes().toString().padStart(2, '0');
					
					str += '<tr class="text-center">';
					str += '<th scope="row">'+year+'.'+month+'.'+day+'.'+'</th>';
					str += '<td>'+item.empNo+'</td>';
					str += '<td>'+empName+'</td>';
					str += '<td>'+startHour+':'+startMinute+'</td>';
					str += '<td>'+endHour+':'+endMinute+'</td>';
					str += '<td>'+item.atOvertime+'</td>';
					str += '<td>'+item.atType+'</td>';
					str += '<td>'+item.atResult+'</td>';
					str += '<td>'+item.atWeek+'</td>';
					str += '</tr>';
					
					// 엑셀에 넣을 데이터를 하나씩 널어준다.
					excelAtDate.push(year+'.'+month+'.'+day+'.');
					excelEmpNo.push(item.empNo);
					excelEmpName.push(empName);
					excelStartHour.push(startHour+':'+startMinute);
					excelEndHour.push(endHour+':'+endMinute);
					excelOvertime.push(item.atOvertime);
					excelAtType.push(item.atType);
					excelAtResult.push(item.atResult);
					excelAtWeek.push(item.atWeek);
					
				})
				dataDiv.html(str);
				$('#attendModal').modal('show');
			}
		})
	});
	
	
	$(document).on('click', '#excelDownBtn', function(){
		$('#excelAtDate').val(excelAtDate);
		$('#excelEmpNo').val(excelEmpNo);
		$('#excelEmpName').val(excelEmpName);
		$('#excelStartHour').val(excelStartHour);
		$('#excelEndHour').val(excelEndHour);
		$('#excelOvertime').val(excelOvertime);
		$('#excelAtType').val(excelAtType);
		$('#excelAtResult').val(excelAtResult);
		$('#excelAtWeek').val(excelAtWeek);
		$('#poiForm').submit();
		alert(empName+'사원의 '+yearDate+' 근태현황 \n 엑셀다운로드를 완료했습니다')
	});
	
});
</script>









