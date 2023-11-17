<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="mb-9">
	<div class="row g-2 mb-4">
		<div class="col-auto">
			<h2 class="mb-0">계정목록</h2>
		</div>
	</div>
	<div class="card">
	<div class="card-body">
	<div id="tableExample4" data-list='{"valueNames":["empNo","empName","empDept","empRank","empLevel","empWorkse","empHire"],"page":10,"pagination":true,"filter":{"key":"empDept"}}'>
		<div class="row justify-content-end g-0">
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
					<option value="SW개발팀">SW개발팀</option>
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
			<table class="table mb-0" id="tb_01">
				<thead>
					<tr class="bg-light text-center">
						<th class="sort border-top ps-3" data-sort="empNo">사번</th>
						<th class="sort border-top" data-sort="empName">이름</th>
						<th class="sort border-top" data-sort="empDept">부서</th>
						<th class="sort border-top" data-sort="empRank">직급</th>
						<th class="sort border-top" data-sort="empLevel">접근권한 레벨</th>
						<th class="sort border-top" data-sort="empWorkse">상태</th>
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
									<td class="align-middle ps-3 empNo"><a href="/adminEmpSelect.do?empNo=${emp.empNo }">${emp.empNo }</a></td>
									<td class="align-middle empName">${emp.empName }</td>
									<td class="align-middle empDept">
										<div class="badge badge-phoenix fs--2 badge-phoenix-primary">
											<span class="fw-bold" style="font-size:15px">${emp.deptVO.deptName }</span><span class="ms-1 fas fa-stream"></span>
										</div>
									</td>
									<td class="align-middle empRank">${emp.codeVO.cdName }</td>
									<td class="align-middle empLevel">${emp.empLevel }</td>
									<td class="align-middle empWorkse text-primary" data-no=${emp.empNo }>
										<c:if test="${emp.empWorkse eq 1 }">
										재직
										</c:if>
										<c:if test="${emp.empWorkse eq 0 }">
										퇴사
										</c:if>
									</td>
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
		<div class="row">
			<div class="col-6 d-flex justify-content-end mt-3">
				<button class="page-link" data-list-pagination="prev">
					<span class="fas fa-chevron-left"></span>
				</button>
				<ul class="mb-0 pagination"></ul>
				<button class="page-link pe-0" data-list-pagination="next">
					<span class="fas fa-chevron-right"></span>
				</button>
			</div>
			<div class="col-5 d-flex justify-content-end mt-3"></div>
			<div class="col-1 d-flex justify-content-start mt-3">
	            <button class="btn btn-info" type="button" data-bs-toggle="modal" data-bs-target="#verticallyCentered">적용</button>
	            <div class="modal fade" id="verticallyCentered" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true" style="display: none;">
	              <div class="modal-dialog modal-dialog-centered">
	                <div class="modal-content">
	                  <div class="justify-content-center modal-header">
	                    <h5 class="modal-title" id="verticallyCenteredModalLabel">적용하시겠습니까?</h5>
	                    <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"></button>
	                  </div>
	                  <div class="modal-footer">
	                    <button class="btn btn-info" type="button" id="okBtn">적용</button>
	                    <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
	                  </div>
	                </div>
	              </div>
	            </div>
			</div>
		</div>
		<form action="/empWorkseUpdate.do" method="post" id="empWorkseUdt"></form>
	</div>
	</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	
	// 재직 여부 변경을 위한 버튼
	var okBtn = $("#okBtn");
	var html = ""; 
	
	console.log('호출됨..........')
	// 테이블의 재직여부 td 클릭 시 selectbox 생성
	$("#tb_01").on("click", ".empWorkse", function(){
		var empNo = $(this).data("no");
		$(this).removeClass("empWorkse");
		
		var selctBox = ""; 
		selctBox +='<select class="text-primary empWrokseSelect form-select"  style="width:10em; margin:0 auto;"  name="empWorkse" data-no="'+empNo+'">';
		selctBox +='<option value="1">재직</option>';
		selctBox +='<option value="0">퇴사</option></select>';
		$(this).html(selctBox);
		
	});
	
	// 재직 여부 변경 실행
	okBtn.on("click", function(){
// 		$(".empWrokseSelect").map(function(i,e){
			
// 			html += "<input type='hidden' name='empWorkse' value='"+e.dataset.no + "," + e.value +"'>";
// 		});
// 		console.log("e.dataset.no:{}",e.dataset.no);
// 		console.log("e.value:{}",e.value);
		// selectbox의 data-no 와 selected 된 value 값을 가져온다.
		$(".empWrokseSelect").each(function(i,e){
			var empNo = $(e).data("no");
			var value = $(e).val();
			console.log("empNo:{}",empNo);
			console.log("value:{}",value);
			// empNo,value 합쳐준다.
			var eVlaue = empNo+"@"+value;
			// input을 생성하고 value로 eValue를 넣어준다. 
			html += "<input type='hidden' name='empWorkse' value='"+eVlaue+"'>";
		});
		$("#empWorkseUdt").html(html).submit();
	});
	
	
});

</script>