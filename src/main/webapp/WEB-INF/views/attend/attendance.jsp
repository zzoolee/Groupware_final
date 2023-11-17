<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%
Date now = new Date();
pageContext.setAttribute("now", now);
%>
<fmt:formatDate value="${now}" pattern="HH:mm" var="formattedDate" />

<c:if test="${not empty mainMessage }">
<script>
$(document).ready(function(){
	var messageModal = $('#messageModal');
	messageModal.modal('show');
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

<sec:authentication property='principal.emp.empName' var="empName"/>

<c:set value="${attendVO }" var="attendVO"/>
<c:set value="${attendSum }" var="attendSum"/>
<c:set value="${monthExist }" var="monthExist"/>
<c:set value="${monthList }" var="monthList"/>
<style>   
.progress {
    position:relative;
    width:100%;
    height:30px;
    border: 1px solid #ddd;
    border-radius: 10px; 
}   
.bar {
    background-color: #B4F5B4; 
    width:0%; 
    height:30px; 
    border-radius: 3px;
}   
.percent { 
    position:absolute; 
    display:inline-block; 
    top:3px; 
    left:48%; 
} 

</style> 
<h2>출근/퇴근</h2>
<!-- 	<div> -->
<!-- 		<div class="row g-4"> -->
<!-- 			<div class="col-12 col-xxl-6"> -->
<!-- 				<div></div> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
		<div data-list='{"valueNames":["product","customer","rating","review","time"],"page":6}'>
				<div class="container-fluid pb-7">
					<div class="card mt-7" style="border-radius:20px; padding:40px;">
					<div class="row g-5">
			            <div class="col-12 col-xl-8">
			              <br>
			              <h4 class="mb-3">근무진행도</h4>
			              <div class="mb-8 progress">     
	    						<div class="bar"></div>     
	   						 	<div class="percent">0%</div> 
						  </div> 
			              <div class="mb-15">
			                <h4 class="mb-3">금일출퇴근현황</h4>
			                <div class="bg-success bg-gradient opacity-75" style="border-radius: 10px; height: 30px;">
			                <div class="row align-items-center h-100 mb-2">
								<div class="col-4 text-center">
									<h4 class="text-white">출근</h4>
								</div>
								<div class="col-4 text-center">
									<h4 class="text-white">퇴근</h4>
								</div>
								<div class="col-4 text-center">
									<h4 class="text-white">상태</h4>
								</div>
							</div>
			                <div class="row align-items-center h-100">
								<div class="col-4">
									<h4 class="text-center" id="attendTime"><fmt:formatDate value="${attendVO.atStart }" pattern="HH:mm" var="atStart" />${atStart }</h4>
								</div>
								<div class="col-4">
									<h4 class="text-center"><fmt:formatDate value="${attendVO.atEnd }" pattern="HH:mm" var="atEnd" />${atEnd }</h4>
								</div>
								<div class="col-4">
									<h4 class="text-center">${attendVO.atResult }</h4>
								</div>
							</div>
						  	</div>
			              </div>
			              <div class="mb-10">
			                <h4 class="mb-3">금주누적근무시간</h4>
			                <div class="bg-info bg-gradient opacity-75" style="border-radius: 10px; height: 30px;">
			                <div class="row align-items-center h-100 mb-2">
								<div class="col-4">
									<h4 class="text-white text-center">기본근무시간</h4>
								</div>
								<div class="col-4">
									<h4 class="text-white text-center">연장근무시간</h4>
								</div>
								<div class="col-4">
									<h4 class="text-white text-center">총근무시간</h4>
								</div>
							</div>
			                <div class="row align-items-center h-100">
								<div class="col-4">
									<h4 class="text-center">${attendSum.atSum }시간</h4>
								</div>
								<div class="col-4">
									<h4 class="text-center">${attendSum.atOverSum }시간</h4>
								</div>
								<div class="col-4">
									<h4 class="text-center">${attendSum.overallSum }시간</h4>
								</div>
							</div>
						  	</div>
			              </div>
			            </div>
			            
			            <div class="col-12 col-xl-4">
			              <div class="row g-2">
			                <div class="col-12 col-xl-12">
			                  <div class="card mb-3">
			                    <div class="card-body">
			                      <h4 class="card-title mb-4">근무관리</h4>
			                      <div class="row gx-3">
			                        <div class="col-12 col-sm-6 col-xl-12">
			                          <div class="mb-4">
			                            <div class="mb-2 align-items-center">
			                              <h5 class="mb-2 text-1000 me-2">출근/퇴근</h5>
			                              <p class="fw-bold fs--1 text-danger">
			                              	* 출근, 퇴근시 버튼을 꼭 눌러주세요<br>
			                                * 출근을 여러번 누를 경우 가장 이른 시간이 출근으로 인정되며,
			                                  퇴근을 여러번 누를 경우 가장 늦은 시간이 퇴근으로 인정됩니다.
			                              </p>
			                            </div>
											<button class="btn btn-outline-secondary me-1 mb-1" type="button" id="hiBtn">출근</button>
											<button class="btn btn-outline-secondary me-1 mb-1" type="button" id="byeBtn">퇴근</button>
			                          </div>
			                        </div>
			                        <div class="col-12 col-sm-6 col-xl-12">
			                          <div class="mb-4">
			                            <div class="d-flex flex-wrap mb-2 align-items-center">
			                              <h5 class="mb-0 text-1000 me-2">현재근무유형</h5>
			                              <span class="fw-bold fs-1 text-info">${attendVO.atType }</span>
			                            </div>
											<button class="btn btn-outline-secondary me-1 mb-1"
												style="margin: 10px 0px 0px 0px" type="button" id="mainBtn">&nbsp;&nbsp;&nbsp;&nbsp;근무유형변경&nbsp;&nbsp;&nbsp;&nbsp;</button>
										</div>
			                          </div>
			                        </div>
			                        <div class="col-12 col-sm-6 col-xl-12">
			                          <div class="mb-4">
			                            <div class="d-flex flex-wrap mb-2 align-items-center">
			                              <h5 class="mb-0 text-1000 me-2">현재근무상태</h5>
			                              <span class="fw-bold fs-1 text-info">${status.atStatus }</span>
			                            </div>
			                            <button class="btn btn-outline-secondary me-1 mb-1" style="margin: 10px 0px 0px 0px" type="button" id="attendBtn">&nbsp;&nbsp;&nbsp;&nbsp;근무상태변경&nbsp;&nbsp;&nbsp;&nbsp;</button>
												
			                          </div>
			                        </div>
			                      </div>
			                    </div>
			                  </div>
			                </div>
			               </div>

						
						<div class="col-12">
						<hr>
							<h4 class="mb-3">월간/주간 출퇴근시간 조회</h4>
							<div class="d-flex justify-content-end px-card pt-0 border-top-0">
							<form action="/attendance.do" method="POST" id="yearMonthForm">
								<select class="form-select form-select-lg mb-3 text-start" aria-label=".form-select-lg example" name="yearMonth" id="yearMonthSelect">
									<!-- if문으로 돌리기 -->
									<option value="연도와 월을 선택하세요" selected>연도와 월을 선택하세요</option>
									<c:forEach var="month" items="${monthExist}" varStatus="status">
										<option value="${month.yearMonth }">${month.yearMonth }</option>
									</c:forEach>
									<c:forEach var="month" items="${monthExist}" varStatus="status">
										<c:if test="${status.first }">
											<input type="hidden" value="${month.yearMonth }" id="lastMonth"/>
										</c:if>
									</c:forEach>
								</select>
							</form>
							&nbsp;&nbsp;
							<select class="form-select form-select-lg mb-3 text-start" style="width:200px;" aria-label=".form-select-lg example" id="weekSelect">
								<!-- if문으로 돌리기 -->
								<option selected>주차를 선택하세요</option>
							</select>
							</div>
						
							<table class="table table-striped text-center">
 									<thead>
                              			<tr>
                                  		<th scope="col">근무일자</th>
                                   		<th scope="col">근무유형</th>
                                   		<th scope="col">출근시간</th>
                                   		<th scope="col">퇴근시간</th>
                                   		<th scope="col">근무시간</th>
                                   		<th scope="col">근무결과</th>
                              			</tr>
                          			</thead>
                          			<tbody id="attendBody">
                          			
                          			</tbody>
							</table>
						</div>	
					</div>
				</div>
			</div>
			<div class="row align-items-center py-1">
				<div class="pagination d-none"></div>
				<div class="col d-flex fs--1">
					<!-- 하단부 -->
				</div>
			</div>
			<div class="row" style="margin: 15px 0px 20px 0px;">
				<div class="col-9"></div>
				<div class="col-3 text-end">
				</div>
			</div>
</div>

			          
<!-- 출근처리 확인 모달 -->
<div class="modal fade" id="hiModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
      <fmt:formatDate value="${now }" pattern="HH24:mm" var="now"/>
        <p class="text-700 lh-lg mb-0">${empName }님 <c:out value="${formattedDate}"/>에 출근처리 되었습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>

<!-- 퇴근처리 확인 모달 -->
<div class="modal fade" id="byeModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">${empName }님 <c:out value="${formattedDate}"/>에 퇴근처리 되었습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>


<!-- 출근 중복 확인 모달 -->
<div class="modal fade" id="dupModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">이미 출근처리 되었습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal">확인</button>
      </div>
    </div>
  </div>
</div>
<form action="/attendance.do" method="post" id="attendHForm">
	<input type="hidden" value="출근" name="atResult"/>
</form>
<form action="/attendance.do" method="post" id="attendBForm">
	<input type="hidden" value="퇴근" name="atResult"/>
</form>

<div class="modal fade" id="mainModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="verticallyCenteredModalLabel">근무유형변경</h5>
				<button class="btn p-1" type="button" data-bs-dismiss="modal"
					aria-label="Close">
					<span class="fas fa-times fs--1"></span>
				</button>
			</div>
			<div class="modal-body">
				<form action="/attendmain.do" method="POST" id="typeSubmit">
					<div class="row pt-3">
						<div class="col-1"></div>
						<div class="col-10">
							<select class="form-select form-select-lg mb-3 text-start"
								name="atType" id="atType" aria-label=".form-select-lg example">
								<option selected="근무">근무유형을 선택하세요</option>
								<option value="기본">기본근무 (09:00 ~ 18:00)</option>
								<option value="유연A">유연근무 A유형 (08:00 ~ 17:00)</option>
								<option value="유연B">유연근무 B유형 (10:00 ~ 19:00)</option>
								<option value="재택">재택근무 (09:00 ~ 18:00)</option>
							</select>
						</div>
					</div>
				</form>
				<div class="row pt-0 pb-10">
					<div class="col-1"></div>
					<div class="col-10">
						<div class="form-check">
							<input class="form-check-input" id="checkBtn" type="checkbox"
								value="" /> <label class="form-check-label"
								for="flexCheckChecked">근무일정은 익일 출근부터 변경되며, 근무변경으로 인한
								책임은 본인에게 있음에 동의합니다.</label>
						</div>
					</div>
				</div>
				<div class="row">
				</div>
		</div>
		<div class="modal-footer"><button class="btn btn-info" type="button" id="checkOkayBtn">확인</button>
      </div>
    </div>
  </div>
</div>




<div class="modal fade" id="attendModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">근무상태변경</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
			<div class="row pt-7 pb-3">
				<div class="col-2"></div>
				<div class="col-10">
					<div class="row">
						<div>
<!-- 							<h3 class="fw-normal">현재근무상태 :  -->
<%-- 							<c:choose> --%>
<%-- 								<c:when test="${status.atStatus eq '업무' }"> --%>
<!-- 									<span class="text-success">업무</span> -->
<%-- 								</c:when> --%>
<%-- 								<c:when test="${status.atStatus eq '출장' }"> --%>
<!-- 									<span class="text-warning">출장</span> -->
<%-- 								</c:when> --%>
<%-- 								<c:when test="${status.atStatus eq '외근' }"> --%>
<!-- 									<span style="color: #8a5227;">외근</span> -->
<%-- 								</c:when> --%>
<%-- 								<c:when test="${status.atStatus eq '자리비움' }"> --%>
<!-- 									<span class="text-danger">자리비움</span> -->
<%-- 								</c:when> --%>
<%-- 							</c:choose> --%>
<!-- 							</h3> -->
						</div>
						<div class="row pt-3 pb-3">
							<h4 class="fw-normal">변경할 근무상태를 선택하세요</h4>
						</div>
						
						<div class="row pb-1">
							
							<form action="/updateAtStatus.do" method="POST" id="statusForm">
							<div class="pt-2 pb-1">
								<div class="form-check">
									<input class="form-check-input" id="flexRadioDefault1"
										type="radio" name="atStatus" value="업무"/> <label
										class="form-check-label" for="flexRadioDefault1">
											<h4 class="pt-1 text-success">&nbsp;업무</h4>
										</label>
								</div>
							</div>
							
							
							<div class="pt-2 pb-1">
								<div class="form-check">
									<input class="form-check-input" id="flexRadioDefault1"
										type="radio" name="atStatus" value="출장"/> <label
										class="form-check-label" for="flexRadioDefault1">
											<h4 class="pt-1 text-warning">&nbsp;출장</h4>
										</label>
								</div>
							</div>
							
							
							<div class="pt-2 pb-1">
								<div class="form-check">
									<input class="form-check-input" id="flexRadioDefault1"
										type="radio" name="atStatus" value="외근" /> <label
										class="form-check-label" for="flexRadioDefault1">
											<h4 class="pt-1" style="color:#8a5227;">&nbsp;외근</h4>
										</label>
								</div>
							</div>
							
							
							<div class="pt-2 pb-1">
								<div class="form-check">
									<input class="form-check-input" id="flexRadioDefault1"
										type="radio" name="atStatus" value="자리비움" /> <label
										class="form-check-label" for="flexRadioDefault1">
											<h4 class="pt-1 text-danger">&nbsp;자리비움</h4>
										</label>
								</div>
							</div>
							</form>
						</div>
						
						<div class="row pb-7">
							<div>			
								<div class="form-check">
									<input class="form-check-input"
										type="checkbox" value="" id="checkBx"/> <label class="form-check-label"
										for="flexCheckDefault">현 근무상태와 일치한 근무상태임을 확인했습니다.</label>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>


			<div class="modal-footer"><button class="btn btn-info" type="button" id="attendOkayBtn">확인</button>
      </div>
    </div>
  </div>
</div>


<div class="modal fade" id="messageModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">${mainMessage }</p>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>

<div class="modal fade" id="notStartModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">출근등록을 하지 않았습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal">확인</button>
      </div>
    </div>
  </div>
</div>

<input type="hidden" value=${percent } id="getPercent"/>
<script type="text/javascript">
$(function(){
	var hiBtn = $('#hiBtn');
	var byeBtn = $('#byeBtn');
	var hiModal = $('#hiModal');
	var byeModal = $('#byeModal');
	var attendHForm = $('#attendHForm');
	var attendBForm = $('#attendBForm');
	var hiOkBtn = $('#hiOkBtn');
	var attendTime = $('#attendTime');
	var dupModal = $('#dupModal');
	var yearMonthSelect = $('#yearMonthSelect');
	var yearMonthForm = $('#yearMonthForm');
	var yearMonth = $('#yearMonthSelect').val();
	var weekData = $('#weekSelect').val();
	var attendBody = $('#attendBody');
	var weekSelect = $('#weekSelect');
	var mainBtn = $('#mainBtn');
	var attendBtn = $('#attendBtn');
	var mainModal = $('#mainModal');
	var attendModal = $('#attendModal');
	var checkBtn = $('#checkBtn');
	var checkOkayBtn = $('#checkOkayBtn');
	var attendOkayBtn = $('#attendOkayBtn');
	var checkBx = $('#checkBx');
	var statusForm = $('#statusForm');
	var lastMonth = $('#lastMonth').val();
	var getPercent = $('#getPercent').val();
	var bar = $('.bar');
	var percent = $('.percent');
	var getPercent0 = 0;
	var notStartModal = $('#notStartModal');

	

	setInterval(() => {	
		if(getPercent0 <= getPercent) {
		bar.width(getPercent0+'%');
		percent.sub
		percent.html(getPercent0+'%');
		getPercent0 += 1;
		}
	}, 20);
	
	
	
	attendBtn.on('click', function(){
		attendModal.modal('show');
	});
	
	attendOkayBtn.on('click', function(){
		if(!checkBx.prop('checked')) {
			alert('상태변경 확인에 동의해주세요');
		}else {
			attendModal.modal('hide');
			statusForm.submit();
		}
	});
	
	checkOkayBtn.on('click', function(){
		if(!checkBtn.prop('checked')) {
			alert('안내사항을 읽고 체크해주세요.')
		}else {
			if($('#atType') == '근무') {
				alert('근무유형을 선택해주세요');
				return false;
			}
			mainModal.modal('hide');
			typeSubmit.submit();
		}
	});
	
	mainBtn.on('click', function(){
		mainModal.modal('show');
	});
	
	yearMonthSelect.on('change', function(){
		yearMonth = $('#yearMonthSelect').val();
		if (yearMonth == '연도와 월을 선택하세요') {
			alert ("연도와 월을 선택해주세요");
			return false;
		}
		console.log(yearMonth);
		var str = "";
		var strWeek = "";
		var njOverTime = 0;
		var njAttendTime = 0;
		var monthObject = {
			yearMonth : yearMonth
		};
		
		$.ajax({ 
            type:"POST", 
            url:"/attendanceAjax.do",
            data : JSON.stringify(monthObject),
            contentType : "application/json; charset=utf-8",
            success:function(result){
            	console.log(result.weekList);
            	attendBody.html('');
            	weekSelect.html('');
            	console.log("도착");
            	if (result.monthList == null || result.monthList.length === 0) {
                    str = '<tr><td colspan="5">근무기록이 없습니다.</td></tr>';
                } else {
                	result.monthList.forEach(function(item) {
                    	// 누적에 데이터 쌓아주기
                    	njOverTime += item.atOvertime;
                        // JavaScript로 날짜 형식을 변경                  
                        var date = new Date(item.atDate); // 형식화할 날짜
                        var startData = new Date(item.atStart); // 시작날짜 형식화
                        var startHour = String(startData.getHours()).padStart(2,'0'); // 출근시간 '시간'데이터뽑기
                        var startMinute = String(startData.getMinutes()).padStart(2,'0'); // 출근시간 '분'데이터뽑기
                        
                        var endData = new Date(item.atEnd); // 시작날짜 형식화
                        var endHour = String(endData.getHours()).padStart(2,'0'); // 출근시간 '시간'데이터뽑기
                        var endMinute = String(endData.getMinutes()).padStart(2,'0'); // 출근시간 '분'데이터뽑기
                        
                        var year = String(date.getFullYear());
                        var month = String(date.getMonth() + 1).padStart(2, '0'); // 월을 2자리 숫자로
                        var day = String(date.getDate()).padStart(2, '0'); // 일을 2자리 숫자로
                        var formattedDate = year + '.' + month + '.' + day + '.';
                        
                        var diffTime = endHour-startHour;
                        if(diffTime>4) {
                        	diffTime = diffTime-1;
                        }
                        
                        if((startData.getMinutes()) > 0) {
                        	diffTime = diffTime-1;
                        }
                        
                        str += '<tr>';
                        str += '<th scope="row">' + formattedDate + '</th>';
                        str += '<td>' + item.atType + '</td>';
                        str += '<td>'+ startHour+':'+startMinute+'</td>'
                        str += '<td>' + endHour+':'+endMinute+ '</td>';
                        str += '<td>'+diffTime+'시간</td>';
                        str += '<td>' + item.atResult +'</td>,</tr>'
                    });
                }
            	attendBody.html(str);
            	
            	if(result.weekList == null || result.weekList.length === 0) {
            		strWeek += '<option selected>주차를 선택하세요</option>';
            		
            	} else {
            		strWeek += '<option selected>주차를 선택하세요</option>';
            		result.weekList.forEach(function(item) {
            			strWeek += '<option value="'+item.atWeek+'">'+item.atWeek+'주차</option>';
            		});
            	}            	
            	weekSelect.html(strWeek);
            }
        })
	});
	
	weekSelect.on('change', function(){
		var njOverTime = 0;
		var njAttendTime = 0;
		yearMonth = $('#yearMonthSelect').val();
		weekData = $('#weekSelect').val();
		if (yearMonth == '연도와 월을 선택하세요') {
			alert ("연도와 월을 선택해주세요");
			return false;
		}
		if (weekData == '주차를 선택하세요') {
			alert ("주차를 선택해주세요");
			return false;
		}
		console.log("위크데이터"+weekData);
		if(weekData.length != 1){
			weekData = null;
		}
		var strWeekAttend = "";
		var weekObject = {
			yearMonth : yearMonth
			,weekData : weekData
		};
		
		$.ajax({ 
            type:"POST", 
            url:"/attendanceAjax2.do",
            data : JSON.stringify(weekObject),
            contentType : "application/json; charset=utf-8",
            success:function(result){
            	console.log("위크어텐드 리스트"+result);
            	attendBody.html('');
            	if (result.weekAttendList == null || result.weekAttendList.length === 0) {
                    str = '<tr><td colspan="5">근무기록이 없습니다.</td></tr>';
                } else {
                	result.weekAttendList.forEach(function(item) {
                    	// 누적에 데이터 쌓아주기
                    	njOverTime += item.atOvertime;
                        // JavaScript로 날짜 형식을 변경                  
                    	var date = new Date(item.atDate); // 형식화할 날짜
                        var startData = new Date(item.atStart); // 시작날짜 형식화
                        var startHour = String(startData.getHours()).padStart(2,'0'); // 출근시간 '시간'데이터뽑기
                        var startMinute = String(startData.getMinutes()).padStart(2,'0'); // 출근시간 '분'데이터뽑기
                        
                        var endData = new Date(item.atEnd); // 시작날짜 형식화
                        var endHour = String(endData.getHours()).padStart(2,'0'); // 출근시간 '시간'데이터뽑기
                        var endMinute = String(endData.getMinutes()).padStart(2,'0'); // 출근시간 '분'데이터뽑기
                        
                        var year = String(date.getFullYear());
                        var month = String(date.getMonth() + 1).padStart(2, '0'); // 월을 2자리 숫자로
                        var day = String(date.getDate()).padStart(2, '0'); // 일을 2자리 숫자로
                        var formattedDate = year + '.' + month + '.' + day + '.';
                        
                        var diffTime = endHour-startHour;
                        if(diffTime>4) {
                        	diffTime = diffTime-1;
                        }
                        
                        if((startData.getMinutes()) > 0) {
                        	diffTime = diffTime-1;
                        }
                        
                        strWeekAttend += '<tr>';
                        strWeekAttend += '<th scope="row">' + formattedDate + '</th>';
                        strWeekAttend += '<td>' + item.atType + '</td>';
                        strWeekAttend += '<td>'+ startHour+':'+startMinute+'</td>'
                        strWeekAttend += '<td>' + endHour+':'+endMinute+ '</td>';
                        strWeekAttend += '<td>'+diffTime+'시간</td>';
                        strWeekAttend += '<td>'+item.atResult+'</td></tr>';
                    });
                }
            	attendBody.html(strWeekAttend);
            }           	
        })		
	});
	
	hiBtn.on('click', function(){
		console.log(attendTime.text());
		if(attendTime.text()!=null && attendTime.text()!="") {
			console.log('1');
			dupModal.modal('show');
			return false;
		}
		hiModal.modal('show');
		// 모달이 다시 hide 상태가되었을때
		hiModal.on('hidden.bs.modal', function(){
			console.log('2');
			attendHForm.submit();
		})
	});
	
	byeBtn.on('click', function(){
		console.log(attendTime.text().trim());
		if(attendTime.text().trim()==null || attendTime.text().trim()=="") {
			notStartModal.modal('show');
			return false;
		}
		byeModal.modal('show');
		byeModal.on('hidden.bs.modal', function(){
			attendBForm.submit();
		})
	});
	
});
$(document).ready(function(){
	var lastMonth = $('#lastMonth').val(); 
	
	console.log(lastMonth);
	$('#yearMonthSelect').val(lastMonth).trigger('change');
})
</script>