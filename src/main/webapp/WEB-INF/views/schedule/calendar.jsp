<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row g-0 mb-4 align-items-center">
  <div class="col-5 col-md-6">
    <h4 class="mb-0 text-1100 fw-bold fs-md-2">
      <span class="calendar-day d-block d-md-inline mb-1"></span>
      <span class="px-3 fw-thin text-400 d-none d-md-inline">|</span><span class="calendar-date"></span>
    </h4>
  </div>
  <div class="col-7 col-md-6 d-flex justify-content-end" id="scSeChkbox">
  	<div class="form-check form-check-inline">
	  <input class="form-check-input" id="inlineCheckbox1" type="checkbox" value="comSelect" checked/>
	  <label class="form-check-label text-primary" for="inlineCheckbox1">회사일정</label>
	</div>
	<div class="form-check form-check-inline">
	  <input class="form-check-input" id="inlineCheckbox2" type="checkbox" value="deptSelect" checked/>
	  <label class="form-check-label text-success" for="inlineCheckbox2">부서일정</label>
	</div>
	<div class="form-check form-check-inline">
	  <input class="form-check-input" id="inlineCheckbox3" type="checkbox" value="empSelect" checked/>
	  <label class="form-check-label text-secondary" for="inlineCheckbox3">개인일정</label>
	</div>
    <button class="btn btn-info me-1 mb-1" type="button" data-bs-toggle="modal" data-bs-target="#addEventModal">
    <span class="fas fa-plus pe-2 fs--2"></span>일정 등록</button>
  </div>
</div>
<div class="mx-n4 px-4 mx-lg-n6 px-lg-6 border-y border-200">
	<div class="calendar-outline mt-6 mb-9" id="calendar"></div>
</div>

<c:if test="${!empty resultMsg }">
	<script>
		$(document).ready(function(){
			$('#resultModal').modal('show');
// 			new window.bootstrap.Modal(resultModal).show(); // 둘 다 가능
		});
	</script>
</c:if>

<!-- 결과 모달 시작 -->
<div class="modal fade" id="resultModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">${resultTitle }</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">${resultMsg }</p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="button" data-bs-dismiss="modal">확인</button>
      </div>
    </div>
  </div>
</div>
<!-- 결과 모달 끝 -->

<!-- 일정 등록 모달창 시작 -->
<div class="modal fade" id="addEventModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content border">
      <form id="addEventForm" autocomplete="off" class="needs-validation" novalidate="" action="/addschedule.do" method="post">
        <div class="modal-header px-card border-0">
          <div class="w-100 d-flex justify-content-between align-items-start">
            <div>
              <h5 class="mb-0 lh-sm text-1000">일정 등록</h5>

              <div class="mt-2">
              	<!-- 사용자 부분 -->
                <div class="form-check form-check-inline">
                  <input class="form-check-input" id="inlineRadio2" type="radio" name="scSe" value="A103" checked="checked" />
                  <label class="form-check-label" for="inlineRadio2">개인</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" id="inlineRadio1" type="radio" name="scSe" value="A102" />
                  <label class="form-check-label" for="inlineRadio1">부서</label>
                </div>
                <!-- 사용자 부분 -->
                <p class="form-check-label">* 부서 일정 추가시 부서의 모든 직원이 일정을 확인할 수 있습니다.</p>
              </div>
            </div>
            <button class="btn p-1 fs--2 text-900" type="button" data-bs-dismiss="modal" aria-label="Close">취소 </button>
          </div>
        </div>
        <div class="modal-body p-card py-0">
          <div class="flatpickr-input-container mb-3">
            <div class="form">
            <label class="form-check-label">일정 제목</label>
              <input class="form-control" id="eventTitle" type="text" name="scTitle" required="required" />
            </div>
          </div>
          <div class="flatpickr-input-container mb-3">
            <div class="form">
          	<label class="form-check-label" for="eventStartDate">시작 날짜</label>
              <input class="form-control" id="eventStartDate" type="date" name="scStartdate" required="required" />
            </div>
          </div>
          <div class="flatpickr-input-container mb-3">
            <label class="form-check-label" for="eventEndDate">종료 날짜</label>
            <div class="form">
              <input class="form-control" id="eventEndDate" type="date" name="scEnddate" required="required" />
            </div>
          </div>
          <div class="form">
          <label class="form-check-label" for="eventDescription">일정 내용</label>
            <textarea class="form-control" id="eventDescription" name="scContent" style="height: 128px"></textarea>
          </div>
        </div>
        <div class="modal-footer d-flex justify-content-between align-items-center border-0 float-end">
          <button class="btn btn-info me-1 mb-1" type="submit">저장</button>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- 일정 등록 모달창 끝 -->

<!-- 상세보기 모달창 시작 -->
<div class="modal fade" id="eventDetailsModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border">
        <div class="modal-header ps-card border-bottom">
          <h4 class="modal-title text-1000 mb-0"><!-- 데이터 세팅되는 곳 : 제목 --></h4>
          <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
        </div>
        <div class="modal-body px-card pb-card pt-1 fs--1">
        	<div class="mt-3 border-bottom pb-3">
		        <h5 class="mb-0 text-800">내용</h5>
		        <p class="mb-0 mt-2">
		          <!-- 데이터 세팅되는 곳 : 내용 -->
		        </p>
	        </div>
        	<div class="mt-4 ">
        		<h5 class="mb-0 text-800">일자</h5>
			    <p class="mb-1 mt-2">
			      <!-- 데이터 세팅되는 곳 : 시작일자 - 종료일자 -->
			 	</p>
			</div>
        </div>
        <div class="modal-footer d-flex justify-content-end px-card pt-0 border-top-0">
		  	<button class="btn btn-phoenix-secondary btn-sm" id="modifyEventButton">
		      <svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><!-- <span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com --> 수정
		    </button>
		    <button class="btn btn-phoenix-danger btn-sm" id="deleteEventButton">
		      <svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --> 삭제
		    </button>
		</div>
    </div>
  </div>
</div>
<!-- 상세보기 모달창 끝 -->

<!-- 일정 수정 모달창 시작 -->
<div class="modal fade" id="modifyEventModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border" style="padding:10px;">
    	<form class="row g-3 needs-validation" novalidate="" id="eventDetailsForm" action="/modifyschedule.do" method="post" >
          <input type="hidden" name="scCd" value=""><!-- 데이터 세팅되는 곳 : 코드 -->
	        <div class="modal-header ps-card border-bottom">
	          <input class="form-control" type="text" name="scTitle" value="" required="" style="width:400px;"><!-- 데이터 세팅되는 곳 : 제목 -->
<!-- 	          <div class="invalid-feedback">제목은 필수 입력 항목입니다.</div> -->
	          <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
	        </div>
	        <div class="modal-body px-card pb-card pt-1 fs--1">
	        	<div>
	        		<div class="form-check form-check-inline">
	                  <input class="form-check-input" id="inlineRadio2" type="radio" name="scSe" value="A103" disabled/><!-- 데이터 세팅되는 곳 : 유형 -->
	                  <label class="form-check-label" for="inlineRadio2">개인</label>
	                </div>
	                <div class="form-check form-check-inline">
	                  <input class="form-check-input" id="inlineRadio1" type="radio" name="scSe" value="A102" disabled/><!-- 데이터 세팅되는 곳 : 유형 -->
	                  <label class="form-check-label" for="inlineRadio1">부서</label>
	                </div>
		            <span>* 일정 유형은 변경할 수 없습니다.</span>
	          	</div>
	        	<div class="mt-4">
			        <h5 class="mb-0 text-800">내용</h5><br>
			        <textarea class="form-control" name="scContent" rows="3"> </textarea>
			        <!-- 데이터 세팅되는 곳 : 내용 -->
		        </div>
	        	<div class="mt-4">
	        		<h5 class="mb-0 text-800">일자</h5><br>
	        		<div class="d-flex justify-content-between align-items-center border-0">
				    <input class="form-control" id="datepicker" type="date" name="scStartdate" value="" required="" style="width:200px;">
				     ~ <input class="form-control" id="datepicker" type="date" name="scEnddate" value="" required="" style="width:200px;">
					</div>
				</div>
	        </div>
	        <div class="modal-footer d-flex justify-content-end px-card pt-0 border-top-0">
			  	<button class="btn btn-phoenix-info btn-sm" type="submit">저장</button>
			    <button class="btn btn-phoenix-secondary btn-sm" type="button" data-bs-dismiss="modal">취소</button>
			</div>
        </form>
    </div>
  </div>
</div>
<!-- 일정 수정 모달창 끝 -->

<!-- 달력에서 클릭이벤트로 실행되는 모달 -->
<!-- 일정 등록 모달창 시작 -->
<div class="modal fade" id="c_addEventModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content border">
      <form id="c_addEventForm" autocomplete="off" class="needs-validation" novalidate="" action="/addschedule.do" method="post">
        <div class="modal-header px-card border-0">
          <div class="w-100 d-flex justify-content-between align-items-start">
            <div>
              <h5 class="mb-0 lh-sm text-1000">일정 등록</h5>

              <div class="mt-2">
              	<!-- 사용자 부분 -->
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="scSe" value="A103" checked="checked" />
                  <label class="form-check-label" for="inlineRadio2">개인</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="scSe" value="A102" />
                  <label class="form-check-label" for="inlineRadio1">부서</label>
                </div>
                <!-- 사용자 부분 -->
                <p class="form-check-label">* 부서 일정 추가시 부서의 모든 직원이 일정을 확인할 수 있습니다.</p>
              </div>
            </div>
            <button class="btn p-1 fs--2 text-900" type="button" data-bs-dismiss="modal" aria-label="Close">취소 </button>
          </div>
        </div>
        <div class="modal-body p-card py-0">
          <div class="flatpickr-input-container mb-3">
            <div class="form">
            <label class="form-check-label">일정 제목</label>
              <input class="form-control" id="c_eventTitle" type="text" name="scTitle" required="required" />
            </div>
          </div>
          <div class="flatpickr-input-container mb-3">
            <div class="form">
          	<label class="form-check-label" for="eventStartDate">시작 날짜</label>
              <input class="form-control" id="c_eventStartDate" type="date" name="scStartdate" required="required" />
            </div>
          </div>
          <div class="flatpickr-input-container mb-3">
            <label class="form-check-label" for="eventEndDate">종료 날짜</label>
            <div class="form">
              <input class="form-control" id="c_eventEndDate" type="date" name="scEnddate" required="required" />
            </div>
          </div>
          <div class="form">
          <label class="form-check-label" for="eventDescription">일정 내용</label>
            <textarea class="form-control" id="c_eventDescription" name="scContent" style="height: 128px"></textarea>
          </div>
        </div>
        <div class="modal-footer d-flex justify-content-between align-items-center border-0 float-end">
          <button class="btn btn-info me-1 mb-1" type="submit">저장</button>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- 일정 등록 모달창 끝 -->

<script>

let calendar; // 캘린더

// 상세보기 데이터 //
let scCd;
let scSe;
let scTitle;
let scContent;
let scStartdate;
let scEnddate;
// 상세보기 데이터 //

var buttons = document.querySelectorAll("#eventDetailsModal .modal-footer button"); // 수정, 삭제 버튼

let eventDetailM; // 상세보기 모달

function initializeCalendar(data){ // 캘린더 초기화 함수
	var calendarEl = document.getElementById('calendar');
	calendar = new FullCalendar.Calendar(calendarEl, {
		// FullCalendar 설정
    	headerToolbar :{
			left : 'today',
			center : 'title',
			right : 'prev,next'
		},
    	selectable : true,
		droppable : true,
		editable : true, // 드래그로 일정 늘리거나 줄일 수 있음 -> eventResize
		events:
			data,
//			[
//			{
//				title: '파란색 회사',
//				start: '2023-10-10',
//				end: '2023-10-13',
//				className: 'text-primary',
//				description: '설명...',
//				scCd: '일정 코드'
//			},
//			{
//				title : '초록색 부서',
//				start : '2023-10-15',
//				className : 'text-success'
//			},
//			{
//				title : '검정색 개인',
//				start : '2023-10-19',
//				className : 'text-secondary'
//			}
//			],
		dateClick : function(info) {
			// 클릭한 날짜 정보
			console.log('클릭한 날짜 정보:', info.date);
		},
		eventClick : function(info) {
			// 클릭한 일정 정보
			console.log('클릭한 일정 정보:', info.event);
			console.log('클릭한 일정 정보(일정 코드):', info.event.extendedProps.scCd);
			console.log('클릭한 일정 정보(일정 유형):', info.event.classNames[0]);
			
			// 데이터 전역변수에 세팅
			scCd = info.event.extendedProps.scCd;
			scSe = info.event.extendedProps.scSe;
			scTitle = info.event.title;
			scContent = info.event.extendedProps.content;
			scStartDate = toStringByFormatting(info.event.start);
			let end = new Date(info.event.end - (1000 * 60 * 60 * 24));
			scEndDate = toStringByFormatting(end);
				
			buttons.forEach(function(button) { // 버튼 보이게 설정
			    button.style.display = "block";
			});
			
			if(scSe == 'A101'){ // 회사 일정인 경우 버튼 숨기기
			    buttons.forEach(function(button) {
			        button.style.display = "none";
			    });
			}
			
			document.querySelector("#eventDetailsModal .modal-title").innerText = scTitle;
			document.querySelector("#eventDetailsModal .modal-body > .mt-3 > p").innerText = scContent;
			document.querySelector("#eventDetailsModal .modal-body > .mt-4 > p").innerText = scStartDate + " ~ " + scEndDate;
			
			eventDetailM = new window.bootstrap.Modal(eventDetailsModal);
			eventDetailM.show();
		},
		eventDrop : function(info) { // 수정
			// 이동한 일정의 새로운 날짜 정보(기간은 그대로)
			console.log('이동한 일정 정보:', info.event);
			console.log('이동한 시작 날짜:', info.event.start);
			let enddate = info.event.start;
			if(info.event.end != null){
				enddate = new Date(info.event.end - (1000 * 60 * 60 * 24));
			}
			console.log('이동한 마지막 날짜:', enddate);
			console.log(info.event._def.extendedProps.scSe);
			
			var scSe = info.event._def.extendedProps.scSe;
			if(scSe == 'A101'){
				alert("회사 일정은 수정할 수 없습니다.");
			    setTimeout(function() {
			        location.reload();
			    }, 1000);
			    return;
			}
			
			var start = toStringByFormatting(info.event.start); // 날짜 그대로 보내면 하루씩 앞당겨짐... 왜?
			var end = toStringByFormatting(enddate);
			console.log(start);
			console.log(end);
			
			var modifyData =
			{
				"scCd" : info.event._def.extendedProps.scCd,
				"start" : start,
				"end" : end
			}
			
			$.ajax({
				type: "post",
				url: "/modifysche.do",
				data: JSON.stringify(modifyData),
				contentType: "application/json; charset=utf-8",
				success: function(result){
					console.log(result);
					if(result == "SUCCESS"){
						alert("정상적으로 수정되었습니다.");
					}
				}
			});
		},
		eventResize : function(info) { // 수정
			// 일정 마지막 날짜 조정시 새로운 마지막 날짜 정보
			console.log('날짜 조정한 일정 정보:', info.event);
			console.log('변경된 마지막 날짜:', new Date(info.event.end - (1000 * 60 * 60 * 24)));
			
			var scSe = info.event._def.extendedProps.scSe;
			if (scSe === 'A101') {
			    alert("회사 일정은 수정할 수 없습니다.");
			    setTimeout(function() {
			        location.reload();
			    }, 1000);
			    return;
			}
			
			var start = toStringByFormatting(info.event.start);
			var end = toStringByFormatting(new Date(info.event.end - (1000 * 60 * 60 * 24)));
			
			var modifyData =
			{
				"scCd" : info.event._def.extendedProps.scCd,
				"start" : start,
				"end" : end
			}
			
			$.ajax({
				type: "post",
				url: "/modifysche.do",
				data: JSON.stringify(modifyData),
				contentType: "application/json; charset=utf-8",
				success: function(result){
					console.log(result);
					if(result == "SUCCESS"){
						alert("정상적으로 수정되었습니다.");
					}
				}
			});
		},
		select : function(arg) { // -> 등록 폼으로 연결
			// 기간으로 날짜 선택시(드래그) 날짜 정보
			console.log('드래그 시작 날짜:', arg.start);
			console.log('드래그 마지막 날짜:', new Date(arg.end - (1000 * 60 * 60 * 24)));
			
			var start = toStringByFormatting(arg.start);
			var end = toStringByFormatting(new Date(arg.end - (1000 * 60 * 60 * 24)));
			
			$("#c_eventStartDate").val(start);
			$("#c_eventEndDate").val(end);
			
			new window.bootstrap.Modal(c_addEventModal).show();
		}
	});

	calendar.render();
}

// 페이지 로딩시 캘린더 초기화
document.addEventListener('DOMContentLoaded', function() {
	var request = $.ajax({
		url : "/schedule.do",
		method : "POST",
		data : JSON.stringify({comSelect : true, deptSelect : true, empSelect : true}),
		contentType : 'application/json',
		dataType : "json"
	});
	request.done(function(data){
		console.log("캘린더 데이터 : " + JSON.stringify(data));
		initializeCalendar(data);
	});
	
});

// Date 타입 변환 함수 시작 //
function leftPad(value) {
    if (value >= 10) {
        return value;
    }

//     return `0${value}`;
    return `0` + value;
}

function toStringByFormatting(source, delimiter = '-') {
    const year = source.getFullYear();
    const month = leftPad(source.getMonth() + 1);
    const day = leftPad(source.getDate());

    return [year, month, day].join(delimiter);
}
// Date 타입 변환 함수 끝 //

// 일정 등록 모달 닫힐 때 이벤트 처리 -> 데이터 지워줄 필요
addEventModal.addEventListener('hide.bs.modal', function (event) {
	$('#eventTitle').val("");
	$('#eventStartDate').val("");
	$('#eventEndDate').val("");
	$('#eventDescription').val("");
	$("#addEventModal form").attr("class", "needs-validation");
// 	location.href="/schedule.do";
});
c_addEventModal.addEventListener('hide.bs.modal', function (event) {
	$('#c_eventTitle').val("");
	$('#c_eventStartDate').val("");
	$('#c_eventEndDate').val("");
	$('#c_eventDescription').val("");
	$("#c_addEventModal form").attr("class", "needs-validation");
// 	location.href="/schedule.do";
});

$("#modifyEventButton").on("click", function(event){
	$("#modifyEventModal form").attr("class", "row g-3 needs-validation");
	
	console.log(scCd, scSe, scTitle, scContent, scStartDate, scEndDate);
	document.querySelector("#modifyEventModal input[name='scCd']").value = scCd;
	document.querySelectorAll("#modifyEventModal input[name='scSe']").forEach(function(radio) {
        if(radio.value == scSe){
        	radio.checked = true;
        }
	});
	document.querySelector("#modifyEventModal input[name='scTitle']").value = scTitle;
	document.querySelector("#modifyEventModal textarea[name='scContent']").value = scContent;
	document.querySelector("#modifyEventModal input[name='scStartdate']").value = scStartDate;
	document.querySelector("#modifyEventModal input[name='scEnddate']").value = scEndDate;
    
    eventDetailM.hide();
	new window.bootstrap.Modal(modifyEventModal).show();
});

$("#deleteEventButton").on("click", function(event){
	console.log(scCd, scSe, scTitle, scContent, scStartDate, scEndDate);
	customConfirm('정말 삭제하시겠습니까?').then((userConfirmed) => {
        if (userConfirmed) { 
			location.href="/deleteschedule.do?scCd="+scCd;
        }
    });
});

// 체크박스 이벤트에 대한 캘린더 렌더링
$("#scSeChkbox input[type='checkbox']").change(function() {
	comSelect = false;
	deptSelect = false;
	empSelect = false;
	$("#scSeChkbox input[type='checkbox']").each(function() {
		if(this.checked) {
			var scSe = $(this).val();
            if (scSe == "comSelect") {
                comSelect = true;
            } else if (scSe == "deptSelect") {
                deptSelect = true;
            } else if (scSe == "empSelect") {
                empSelect = true;
            }
		}
	});
	
	var scSeData =
	{
		"comSelect" : comSelect,
		"deptSelect" : deptSelect,
		"empSelect" : empSelect
	};
	
	console.log(scSeData);
	
	var request = $.ajax({
		url : "/schedule.do",
		method : "POST",
		data : JSON.stringify(scSeData),
		contentType : 'application/json',
		dataType : "json"
	});
	request.done(function(data){
		console.log("캘린더 데이터 : " + JSON.stringify(data));
// 		initializeCalendar(data); // 캘린더 초기화 대신(새로고침된다)

		calendar.removeAllEvents(); // 기존 이벤트 제거
		calendar.addEventSource(data); // 새로운 이벤트 데이터 추가
	});
});

</script>
