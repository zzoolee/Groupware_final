<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>





<c:if test="${not empty message }">
	<script type="text/javascript">
		alert("${message}");
		<c:remove var="message" scope="request"/>
		<c:remove var="message" scope="session"/>
	</script>
</c:if>

<c:set var="now" value="<%=new java.util.Date()%>" />

<h2>예약현황</h2>
<br>

<c:if test="${tab eq 'room' }">
	<c:set value="active" var="roomActive"/>
	<c:set value="show active" var="roomShowActive"/>
</c:if>
<c:if test="${tab eq 'asset' }">
	<c:set value="active" var="assetActive"/>
	<c:set value="show active" var="assetShowActive"/>
</c:if>
<c:if test="${tab eq 'freeseat' }">
	<c:set value="active" var="freeseatActive"/>
	<c:set value="show active" var="freeseatShowActive"/>
</c:if>

<ul class="nav nav-underline" id="myTab" role="tablist">
   	<li class="nav-item">
	    <a class="nav-link fs-2 ${roomActive}" id="roomTab" data-bs-toggle="tab" href="#tab-room" role="tab" aria-controls="tab-room" aria-selected="false" data-tab="room">
	        회의실
	    </a>
	</li>
	<li class="nav-item">
	    <a class="nav-link fs-2 ${assetActive}" id="assetTab" data-bs-toggle="tab" href="#tab-asset" role="tab" aria-controls="tab-asset" aria-selected="false" data-tab="asset">
	        자산
	    </a>
	</li>
	<li class="nav-item">
	    <a class="nav-link fs-2 ${freeseatActive}" id="freeseatTab" data-bs-toggle="tab" href="#tab-freeseat" role="tab" aria-controls="tab-freeseat" aria-selected="false" data-tab="freeseat">
	        자율좌석
	    </a>
	</li>

</ul>



<c:set var="tdate">
	<fmt:formatDate value="${today}" pattern="yyyy-MM-dd" />
</c:set> 

<div class="tab-content mt-3" id="myTabContent">
  
  <div class="tab-pane fade ${roomShowActive }" id="tab-room" role="tabpanel" aria-labelledby="room-tab">
  	<p>
    	<span class="text-danger" data-feather="check"></span>
    	예약 시간이 현재 시간보다 경과된 경우, 취소가 불가합니다.
    	<br>
    </p>
  	<!-- 회의실 -->
  	<div style="margin-left:100px; width:80%">
  	<form id="roomSearchForm" method="post">
  		<input type="hidden" name="page" id="page"/>
  		<input type="hidden" name="tab" id="tab" value="room" value="1"/>
	  	<div class="mb-5 d-flex justify-content-end">
		  	<input class="form-control" type="date" id="dateSelect" name="dateSelect" style="width:200px;" value="">
	  	</div>
<!-- 	  	<input type="submit" value="검색"/> -->
  	</form>
  	<c:set value="${pagingVO.dataList }" var="roomList"/>
  	<c:if test="${empty roomList }">
	  	<span class="text-info" data-feather="alert-circle" style="height: 30px; width: 30px;"></span>
	  	예약 내역이 존재하지 않습니다.
  	</c:if>
  	<c:if test="${not empty roomList }">
 	<div class="mx-n4 mx-lg-n6 mb-5 border-bottom border-300">
		<c:forEach items="${roomList }" var="room">
    	<div class="d-flex align-items-center justify-content-between py-3 border-300 px-lg-6 px-4 notification-card border-top read">
	         <div class="d-flex">
	           <div class="me-3 flex-1 mt-2">
	             <p style="font-size:18px;"><span class="fw-bold">날짜 : </span><fmt:formatDate var="roomDate" value="${room.rrDate }" pattern="yyyy-MM-dd"/>${roomDate }<span style="margin-left:40px;" class="fw-bold">시간 :</span> ${room.rrStarttime} ~ ${room.rrEndtime }</p>
<%-- 	             <p class="fs-1"><span class="fw-bold">시간 : </span>${room.rrStarttime} ~ ${room.rrEndtime }</p> --%>
	             <p style="font-size:18px;"><span class="fw-bold">회의실 이름 : </span>${room.roomName }</p>
	             <p style="font-size:18px;"><span class="fw-bold">예약자 : </span>${room.fullname}</p>
	             <p style="font-size:18px;"><span class="fw-bold">대여사유 : </span>${room.rrReason }</p>
	           </div>
	         </div>
	         <div class="font-sans-serif">
	         	<c:set var="today" value="<%=new java.util.Date()%>" />
				<c:set var="tdate">
					<fmt:formatDate value="${today}" pattern="yyyy-MM-dd" />
				</c:set> 
				<c:set var="ttime">
					<fmt:formatDate value="${today}" pattern="HH:mm:ss" />
				</c:set>
	          	<c:if test="${(roomDate eq tdate and room.rrStarttime > ttime) or (roomDate eq tdate and room.rrEndtime > ttime)}">
		           <button class="btn btn-phoenix-danger btn-sm" onclick="location.href='/adminroomcancle.do?rrCd=${room.rrCd}'" name="cancleBtn" data-cd="${room.rrCd }">
				      <span class="text-danger" data-feather="x-circle"></span> 취소
				   </button>
	           	</c:if>
	           
	         </div>
    	</div>
		</c:forEach>
   	</div>
  	</c:if>
  	</div>
  	<nav aria-label="Page navigation example" id="roomPagingArea">
		${pagingVO.pagingHTML }
	</nav>
  </div>



  <div class="tab-pane fade ${assetShowActive }" id="tab-asset" role="tabpanel" aria-labelledby="asset-tab">
<!--   	자산 -->
	<p>
    	<span class="text-danger" data-feather="check"></span>
    	예약 시간이 현재 시간보다 경과된 경우, 취소가 불가합니다.
    	<br>
    </p>
  	<div style="margin-left:100px; width:80%">
<!--   	<div class="mb-5 d-flex justify-content-end"> -->
<!-- 	  	<input class="form-control" name="dateSelect" type="date" style="width:200px;" value=""> -->
<!--   	</div> -->
  	
  	
  	<form id="assetSearchForm" method="post">
  		<input type="hidden" name="page" id="page"/>
  		<input type="hidden" name="tab" id="tab" value="assets" value="1"/>
	  	<div class="mb-5 d-flex justify-content-end">
		  	<input class="form-control" type="date" id="assdateSelect" name="assdateSelect" style="width:200px;" value="">
	  	</div>
  	</form>
  	
  	<c:set value="${asspagingVO.dataList }" var="assetList"/>
  	<c:if test="${empty assetList }">
	  	<span class="text-info" data-feather="alert-circle" style="height: 30px; width: 30px;"></span>
	  	자산 대여 내역이 존재하지 않습니다.
  	</c:if>
  	<c:if test="${not empty assetList }">
 	<div class="mx-n4 mx-lg-n6 mb-5 border-bottom border-300">
		<c:forEach items="${assetList }" var="asset">
    	<div class="d-flex align-items-center justify-content-between py-3 border-300 px-lg-6 px-4 notification-card border-top read">
	         <div class="d-flex">
	           <div class="me-3 flex-1 mt-2">
	             <p style="font-size:18px;"><span class="fw-bold">날짜 : </span><fmt:formatDate var="assetDate" value="${asset.asrDate }" pattern="yyyy-MM-dd"/>${assetDate }<span class="fw-bold" style="margin-left:40px;">시간 : </span>${asset.asrStarttime} ~ ${asset.asrEndtime }</p>
<%-- 	             <p class="fs-1"><span class="fw-bold">시간 : </span>${asset.asrStarttime} ~ ${asset.asrEndtime }</p> --%>
	             <p style="font-size:18px;"><span class="fw-bold">자산 종류 : </span>${asset.asSe }<span class="fw-bold" style="margin-left:50px;">자산 이름 : </span>${asset.asName }</p>
<%-- 	             <p class="fs-1"><span class="fw-bold">이름 : </span>${asset.asName }</p> --%>
	             <p style="font-size:18px;"><span class="fw-bold">사원 : </span>${asset.fullname }</p>
	             <p style="font-size:18px;"><span class="fw-bold">대여사유 : </span>${asset.asrReason }</p>
	           </div>
	         </div>
	         <div class="font-sans-serif">
           	   <c:if test="${(assetDate eq tdate and asset.asrStarttime > ttime) or (assetDate eq tdate and asset.asrEndtime > ttime)}">
		           <button class="btn btn-phoenix-danger btn-sm" onclick="location.href='/adminassetcancle.do?asrCd=${asset.asrCd}'" name="cancleBtn" data-cd="${asset.asrCd }">
				      <span class="text-danger" data-feather="x-circle"></span> 취소
				   </button>
	           	</c:if>
	         </div>
    	</div>
		</c:forEach>
   	</div>
   	<nav aria-label="Page navigation example" id="assetPagingArea">
		${asspagingVO.pagingHTML }
	</nav>
  	</c:if>
  	</div>
  </div>
  
  
  <div class="tab-pane fade ${freeseatShowActive }" id="tab-freeseat" role="tabpanel" aria-labelledby="freeseat-tab">
  	<!-- 자율좌석 -->
  	<p>
    	<span class="text-danger" data-feather="check"></span>
    	오늘 예약한 좌석만 취소 가능합니다.
    	<br>
    </p>
  	<div style="margin-left:100px; width:80%">
  	<div class="mb-5 d-flex justify-content-end">
	  	<input class="form-control" name="dateSearch" type="date" style="width:200px;" value="">
  	</div>
  	<div id="freeseatPlace">
  	<c:if test="${empty freeseatList }">
	  	<span class="text-info" data-feather="alert-circle" style="height: 30px; width: 30px;"></span>
	  	예약 내역이 존재하지 않습니다.
  	</c:if>
  	<c:if test="${not empty freeseatList }">
 	<div class="mx-n4 mx-lg-n6 mb-5 border-bottom border-300">
		<c:forEach items="${freeseatList }" var="freeseat">
    	<div class="d-flex align-items-center justify-content-between py-3 border-300 px-lg-6 px-4 notification-card border-top read">
	         <div class="d-flex">
	<!--            <div class="avatar avatar-xl me-3"><img class="rounded-circle" src="../assets/img/team/30.webp" alt=""> -->
	<!--            </div> -->
	           <div class="me-3 flex-1 mt-2">
	             <p style="font-size:18px;"><span class="fw-bold">날짜 : </span><fmt:formatDate value="${freeseat.srDate }" pattern="yyyy-MM-dd"/></p>
	             <c:set value="${freeseat.offCd}" var="offCd"/>
	             <p style="font-size:18px;"><span class="fw-bold">좌석 유형 : </span>${freeseat.offSe }<span class="fw-bold" style="margin-left:40px;">위치 : </span>${fn:substring(offCd,0,2)} ${freeseat.offLoc }</p>
<%-- 	             <p style="font-size:18px;"><span class="fw-bold">위치 : </span>${fn:substring(offCd,0,2)} ${freeseat.offLoc }</p> --%>
	             <p style="font-size:18px;"><span class="fw-bold">좌석 : </span>${freeseat.srNo }</p>
	             <p style="font-size:18px;"><span class="fw-bold">예약자 : </span>${freeseat.fullname }</p>
	           </div>
	         </div>
	         <div class="font-sans-serif">
           	   <div style="display: none;" name="datePlace"><fmt:formatDate value="${freeseat.srDate }" pattern="yyyy-MM-dd"/></div>
	           <button class="btn btn-phoenix-danger btn-sm" name="cancleBtn" data-cd="${freeseat.srCd }" style="display: block;">
			      <span class="text-danger" data-feather="x-circle"></span> 취소
			   </button>
	         </div>
    	</div>
		</c:forEach>
   	</div>
  	</c:if>
  	</div>
  	</div>
  </div>
</div>

<!-- 결과 모달 시작 -->
<div class="modal fade" id="resultModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel"></h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0" id="resultSpace"></p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="button" data-bs-dismiss="modal">확인</button>
      </div>
    </div>
  </div>
</div>
<!-- 결과 모달 끝 -->

<script>
$(function(){
	initializePage();
});

$(function(){
	var roomSearchForm = $("#roomSearchForm");
	var assetSearchForm = $("#assetSearchForm");
	var roomPagingArea = $("#roomPagingArea");
	var assetPagingArea = $("#assetPagingArea");
	var roomTab = $("#roomTab");	// 회의실 탭 Element
	var assetTab = $("#assetTab");	// 회의실 탭 Element
	
	// 회의실 탭 클릭 시 이벤트 처리
	roomTab.on("click", function(){
		var tab = $(this).data("tab");
		$("#tab").val(tab); // 탭 정보를 tab 필드에 저장
		console.log(tab);
	});
	
	// 자산 탭 클릭시 이벤트 처리
	assetTab.on("click", function(){
		var tab = $(this).data("tab");
		$("#tab").val(tab);
		console.log(tab);
	});
	
	$(function() {
	    // 탭 클릭 이벤트 핸들러
	    $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
	        // 탭 간 전환 시 페이지 번호를 1로 재설정
	        var selectedTab = $(e.target).data("tab");
	        $('input[name="page"]').val(1);

	        // 페이지 번호를 재설정한 후 해당 탭에 대한 데이터의 첫 번째 페이지를 로드
	        if (selectedTab === 'room') {
	            $("#roomSearchForm").submit();
	        } else if (selectedTab === 'asset') {
	            $("#assetSearchForm").submit();
	        } else if (selectedTab === 'freeseat') {
	            $("#freeseatSearchForm").submit();
	        }
	    });
	});
	
	$("input[name='dateSelect']").change(function() {
	  var selectedDate = $(this).val();
	  console.log("선택된 날짜 : ", selectedDate);
	  roomSearchForm.submit();
	});
	
	// date에서 삭제 눌렀을 때 전체 날짜 나오게 어케 해 
	$("input[name='assdateSelect']").change(function() {
	  var assdateSelect = null; 
	  assdateSelect = $(this).val();
	  if(assdateSelect != null){
		  console.log("선택된 날짜 : ", assdateSelect);
		  assetSearchForm.submit();
	  }else if(assdateSelect == null){
		  assdateSelect = "null"; // null 값을 문자열 "null"로 설정
	  }
	});

	roomPagingArea.on("click", "a", function(event){
		event.preventDefault();
		var pageNo = $(this).data("page");
		roomSearchForm.find("#page").val(pageNo);
		roomSearchForm.submit();
	});

	assetPagingArea.on("click", "a", function(event){
		event.preventDefault();
		var pageNo = $(this).data("page");
		assetSearchForm.find("#page").val(pageNo);
		assetSearchForm.submit();
	});

});
$(function(){
	initializePage();
});

$(document).ready(function() {
	// URL의 해시 부분을 읽어와서 'hash' 변수에 저장
    var hash = window.location.hash;
    
    if (hash) {
    	// 해시 값이 존재하면 해당 탭을 활성화
    	// 예: 만약 URL이 'http://example.com#tab2'이면, '#tab2'를 읽어와 해당 탭을 활성화합니다
        $('a[data-bs-toggle="tab"][href="' + hash + '"]').tab('show');
    	
        // 'tabValue'라는 HTML 요소에 현재 활성화된 탭의 해시 값을 표시합니다
        $('#tabValue').text(hash);
        
//         $.ajax({
//             type: "GET", // HTTP 요청 방식 설정 (GET 또는 POST)
//             url: "/myrsv/list.do", // 컨트롤러의 URL로 변경해야 합니다.
//             data: {tab: selectedTab}, // 선택된 탭 값을 data로 전달
//             success: function(response) {
//                 // 서버에서 반환한 응답 처리
//                 console.log("서버 응답: " + response);
//             }
//         });
    }
});

//페이지 요소가 모두 로드된 후 실행
$(function() {
	// 탭이 변경될 때의 이벤트 리스너를 추가
    $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
    	// 선택된 탭의 href를 읽어옴
        var selectedTab = $(e.target).attr('href');
    	
    	// 'tabvalue' 요소에 선택한 탭의 해시 값을 표시
        $('#tabValue').text(selectedTab);

        // URL 해시 값을 업데이트하여 현재 활성화된 탭을 식별
        window.location.hash = selectedTab;
    });
});


function initializePage(){
	// 예약날짜가 과거인 경우 취소 버튼 안보이도록 //
	var today = new Date();
	var todayNoTime = new Date(today.getFullYear(), today.getMonth(), today.getDate()); // 시간 구성 요소를 0으로 설정
	$("div[name='datePlace']").each(function(){ // 날짜만 비교
		var reservedDateStr = $(this).text(); // 2023-10-18 형식 문자열을
		var reservedDate = new Date(reservedDateStr); // 날짜 데이터로 바꾼다
		var reservedDateNoTime = new Date(reservedDate.getFullYear(), reservedDate.getMonth(), reservedDate.getDate()); // 시간 구성 요소를 0으로 설정
		console.log("예약날짜 : " + reservedDateNoTime);
	    console.log("오늘날짜 : " + todayNoTime);
	    console.log(reservedDateNoTime < todayNoTime);
	    if (reservedDateNoTime < todayNoTime) { // 예약날짜가 오늘보다 과거이면
	    	console.log("과거임");
	        $(this).siblings("button[name='cancleBtn']").css("display", "none");
	    }
	});
	
	$("div[name='datetimePlace']").each(function(){ // 날짜+시간 비교
		var reservedDateStr = $(this).text(); // 2023-10-18 형식 문자열을
		var reservedDate = new Date(reservedDateStr); // 날짜 데이터로 바꾼다
		console.log("예약날짜 : " + reservedDate);
	    console.log("오늘날짜 : " + today);
	    console.log(reservedDate < today);
	    if (reservedDate < today) { // 예약날짜가 오늘보다 과거이면
	    	console.log("과거임");
	        $(this).siblings("button[name='cancleBtn']").css("display", "none");
	    }
	});
 	// 예약날짜가 과거인 경우 취소 버튼 안보이도록 //
 	
	// 취소하기
	$("button[name='cancleBtn']").on("click", function(){
		var code = $(this).data("cd"); // data-cd 속성에서 코드 가져오기
	    var tabId = $(this).closest(".tab-pane").attr("id"); // 버튼이 있는 탭의 id 가져오기
	    console.log("버튼이 있는 탭의 ID: " + tabId);
	    
	    var cancleUrl;
	    if(tabId == 'tab-room'){
	    	
	    }else if(tabId == 'tab-asset'){
	    	
	    }else if(tabId == 'tab-freeseat'){
	    	cancleUrl = "/rsv/cancleseat.do";
	    }
	    
	    $.ajax({
	    	type: "get",
			url: cancleUrl + "?code=" + code,
			success: function(result){
				console.log(result);
				if(result == "SUCCESS"){
					$("#resultModal .modal-title").text("예약 취소");
					$("#resultSpace").text("정상적으로 취소되었습니다.");
					new window.bootstrap.Modal(resultModal).show();
				}
			}
	    });
	});
}

//결과 모달 닫힐 때 이벤트 처리 -> 새로고침
resultModal.addEventListener('hide.bs.modal', function (event) {
	location.href="/admin/rsvlist.do?tab=freeseat";
});

// 날짜 검색!!!!!
$("input[name='dateSearch']").change(function(){
	var date = $(this).val();
	console.log(date);
	console.log(typeof date);
	var tabId = $(this).closest(".tab-pane").attr("id"); // 버튼이 있는 탭의 id 가져오기
	if(tabId == 'tab-room'){
    	
    }else if(tabId == 'tab-asset'){
    	
    }else if(tabId == 'tab-freeseat'){
		// 요청 url    	
    	var ajaxUrl = "/dateseatlist.do";
    	// 날짜 데이터 : 널이면(삭제 눌러서 날짜 지워지면) 널 보냄, 널이 아니면(날짜 들어오면) json으로 보냄
    	var ajaxData = null;
    	if(date != null){
    		ajaxData = JSON.stringify({"srDate" : date}); // 여기 날짜 데이터 받을 변수 넣어준다
    	}
    	// 성공하면 그려주기
   		var successCallback = function(result){
    		console.log("Date 형식 변수에 세팅하려면 json으로 보내주어야 한다...ㅎ 서버가 원하는대로 보내주지 않으면 400에러(클라이언트 잘못된 요청) 뜸");
			console.log(result);
			
			let divStr = "";
			if(result.length == 0){
				divStr = `
					<svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle text-info" style="height: 30px; width: 30px;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
				  	예약 내역이 존재하지 않습니다.
				`;
			}else{
				for(let i=0; i<result.length; i++){
					let freeseat = result[i];
// 					let formatDate = toStringByFormatting(freeseat.srDate); // ajax로 올 때 포맷 설정해놓음
					let floor = (freeseat.offCd).substr(0,2);
					if(i==0){
						divStr += `<div class="mx-n4 mx-lg-n6 mb-5 border-bottom border-300">`;
					}
					divStr += `
				    	<div class="d-flex align-items-center justify-content-between py-3 border-300 px-lg-6 px-4 notification-card border-top read">
					         <div class="d-flex">
					           <div class="me-3 flex-1 mt-2">
					             <p class="fs-1"><span class="fw-bold">날짜 : </span>\${freeseat.srDate}</p>
					             <p class="fs-1"><span class="fw-bold">좌석 유형 : </span>\${freeseat.offSe }</p>
					             <c:set value="${freeseat.offCd}" var="offCd"/>
					             <p class="fs-1"><span class="fw-bold">위치 : </span>\${floor} \${freeseat.offLoc }</p>
					             <p class="fs-1"><span class="fw-bold">좌석 : </span>\${freeseat.srNo }</p>
					             <p class="fs-1"><span class="fw-bold">예약자 : </span>\${freeseat.fullname }</p>
				               </div>
					         </div>
					         <div class="font-sans-serif">
				           	   <div style="display: none;" name="datePlace">\${freeseat.srDate}</div>
					           <button class="btn btn-phoenix-danger btn-sm" name="cancleBtn" data-cd="\${freeseat.srCd }" style="display: block;">
							      <span class="text-danger" data-feather="x-circle"></span> 취소
							   </button>
					         </div>
				    	</div>
						`;
					if(i==result.length-1){
						divStr += `</div>`;
					}
				}
			}
			console.log("divStr : " + divStr);
			$("#freeseatPlace").html(divStr);
			
			// 초기화 함수 실행 : 버튼 생성, 버튼 이벤트
			initializePage();
   		}
    	
    	// 위에 세팅한 변수들로 ajax 요청
    	ajaxRequest(ajaxUrl, ajaxData, successCallback);
    }
    
});

function ajaxRequest(url, data, successCallback){
	$.ajax({
    	type: "post",
		url: url,
		data: data,
		contentType: "application/json; charset=utf-8",
		success: successCallback
	});
}

</script>