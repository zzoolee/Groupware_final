<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- jstree cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<h2>즐겨찾는주소록</h2>
<br>

<!-- 검색창 포함 테이블 -->
<div id="addressTable" data-list='{"valueNames":["group","dept","rank","name","mail","hp"],"page":8,"pagination":true,"filter":{"key":"group"}}'> <!-- 검색, 페이징, 셀렉트 설정 -->
	<div class="row align-items-center justify-content-between g-3 mb-4">
	    <div class="d-flex justify-content-between align-items-center border-0">
	    	<button class="btn btn-info me-1 mb-1" id="myDelButton">내 주소록에서 해제</button>
	    	<!-- 검색창 -->
	    	<div class="search-box">
		      <form class="position-relative" data-bs-toggle="search" data-bs-display="static">
		        <input class="form-control search-input search" type="search" placeholder="Search members" aria-label="Search">
		        <span class="fas fa-search search-box-icon"></span>
		      </form>
	    	</div>
	    	<div class="d-flex justify-content-center">
			    <!-- selectbox -->
			    <select class="form-select form-select-sm" style="width:200px;" data-list-filter="data-list-filter"> <!-- data-list-filter 적용 -->
			        <option selected="" value="">그룹을 선택해 주세요</option>
			        <c:if test="${!empty groupList }">
					  	<c:forEach items="${groupList }" var="group" varStatus="i">
					  		<option value="${group.mygrName }">${group.mygrName }</option> <!-- 셀렉트 : value에 필터명 -->
					  	</c:forEach>
				  	</c:if>
		      	</select>
		      	&nbsp;&nbsp;&nbsp;
		      	<button class="btn btn-success me-1 mb-1" type="button" onclick="location.href='/add/myaddgroup.do'">그룹관리</button>
	      	</div>
	    </div>
	</div>
	  
	<div class="table-responsive"> <!-- 클래스 지정 -->
	<table class="table table-hover" style="vertical-align: middle;">
	  <thead>
	    <tr>
	      <th scope="col"></th>
	      <th scope="col">그룹</th>
	      <th scope="col">부서</th>
	      <th scope="col">직급</th>
	      <th scope="col">이름</th>
	      <th scope="col">메일주소</th>
	      <th scope="col">연락처</th>
	    </tr>
	  </thead>
	  <tbody class="list"> <!-- 클래스 지정, td에 class 지정(valueNames로) -->
	  	<c:if test="${empty memberList}">
	  	  <tr style="text-align: center;"><td colspan="7">추가된 직원이 존재하지 않습니다.</tr>
	  	</c:if>
	  	<c:if test="${!empty memberList }">
	  	<c:forEach items="${memberList }" var="mem" varStatus="stat1"> <!-- 그룹 반복 -->
			<tr class="hover-actions-trigger btn-reveal-trigger position-static">
	  			<c:forEach items="${mem.groupMember }" var="groupMember" varStatus="stat2"> <!-- 그룹 멤버 반복 -->
	  				<c:if test="${stat2.count > 1 }"> <!-- 2번째부터 실행 -->
	  					<tr class="hover-actions-trigger btn-reveal-trigger position-static">		
	  				</c:if>
	  				<td class="col-1" style="text-align: center;">
						<input class="form-check-input" id="flexCheckDefault" type="checkbox" value="${mem.groupMember[stat2.index].mygrEmpno }" />
						<input type="hidden" value="${mem.mygrCd }" />
				    </td>
				    <td class="group col-2">${mem.mygrName }</td> <!-- 그룹 반복문에서 가져옴 -->
				    <td class="dept col-2">${mem.groupMember[stat2.index].empVO.deptVO.deptName }</td>
				    <td class="rank col-1">${mem.groupMember[stat2.index].empVO.codeVO.cdName }</td>
					<td class="name col-2" data-empno="${mem.groupMember[stat2.index].mygrEmpno }"> <!-- 데이터 이렇게 심어줘도 됨 -->
						<div class="font-sans-serif btn-reveal-trigger position-static">
							<span>${mem.groupMember[stat2.index].empVO.empName }</span>
							<button class="btn btn-sm dropdown-toggle dropdown-caret-none transition-none btn-reveal fs--2" type="button" data-bs-toggle="dropdown" data-boundary="window" aria-haspopup="true" aria-expanded="false" data-bs-reference="parent">
								<span class="far fa-comment-alt"></span>
							</button>
							<div class="dropdown-menu dropdown-menu-end py-2">
								<a class="dropdown-item" href="/sendmail.do?mailrEmpno=${mem.groupMember[stat2.index].mygrEmpno }">내부메일보내기</a> 
								<a class="dropdown-item" href="#!" onclick="aClick2('${mem.groupMember[stat2.index].mygrEmpno}')">채팅하기</a>
							</div>
						</div>
					</td>
					<td class="mail col-2">${mem.groupMember[stat2.index].empVO.empEmail }</td>
					<td class="hp col-2">${mem.groupMember[stat2.index].empVO.empHp }</td>
					<c:if test="${fn:length(mem.groupMember) > 1 and stat2.count != fn:length(mem.groupMember) }">
						</tr> <!-- 그룹 멤버 반복시에 실행, 그룹 멤버 마지막에 실행X(마지막에 count랑 length랑 같아짐) -->
					</c:if>
				</c:forEach>
  			</tr>	
	    </c:forEach>
	    </c:if>
	  </tbody>
	</table>
	</div>
    <div class="d-flex justify-content-center mt-3">
      <button class="page-link" data-list-pagination="prev"><span class="fas fa-chevron-left"></span></button>
      <ul class="mb-0 pagination"></ul>
      <button class="page-link pe-0" data-list-pagination="next"><span class="fas fa-chevron-right"></span></button>
    </div>
    <br>
</div>

<!-- 내 주소록에서 해제 결과 모달 시작 -->
<div class="modal fade" id="resultModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">내 주소록에서 해제</h5>
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
<!-- 내 주소록에서 해제 결과 모달 끝 -->

<!-- 외부관계자 등록 모달 시작 -->
<div class="modal fade" id="addExtModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">외부관계자 등록</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body" style="padding:20px;">
      	<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-user"></span>
				<h5 class="text-1000 mb-0">이름</h5>
			</div>
			<input class="form-control" type="text" id="empPw" name="empPw" placeholder="비밀번호(생년월일8자리)" value="">
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-lock"> </span>
				<h5 class="text-1000 mb-0">비밀번호</h5>
			</div>
			<input class="form-control" type="text" id="empPw" name="empPw" placeholder="비밀번호(생년월일8자리)" value="">
			<div class="d-flex align-items-center mb-1"></div>
			<input class="form-control" type="text" id="empPwCheck" name="empPwCheck" placeholder="비밀번호 재확인" value="">
			<div class="checkPw text-danger text-center"></div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-phone"> </span>
				<h5 class="text-1000 mb-0">연락처</h5>
			</div>
			<input class="form-control" type="text" id="empHp" name="empHp" placeholder="010-1234-1234" value="">
			<div class="checkHp text-danger text-center"></div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-user"></span>
				<h5 class="text-1000 mb-0">주민번호</h5>
			</div>
			<p class="mb-0 text-800"><input class="form-control" type="text" id="empRegno" name="empRegno" placeholder="123456-1234567" value=""></p>
			<div class="checkRegNo text-danger text-center"></div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-user"></span>
				<h5 class="text-1000 mb-0">성별</h5>
			</div>
			<p class="mb-0 text-800">
				</p><div class="form-check form-check-inline">
				  <input class="form-check-input" id="empGender1" type="radio" name="empGender" value="남성">
				  <label class="form-check-label" for="empGender1">남성</label>
				</div>
				<div class="form-check form-check-inline">
				  <input class="form-check-input" id="empGender2" type="radio" name="empGender" value="여성">
				  <label class="form-check-label" for="empGender2">여성</label>
				</div>
			<p></p>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-user"></span>
				<h5 class="text-1000 mb-0">내/외국인</h5>
			</div>
			<p class="mb-0 text-800">
				</p><div class="form-check form-check-inline">
				  <input class="form-check-input" id="empForeig1" type="radio" name="empForeig" value="내국인">
				  <label class="form-check-label" for="empForeig1">내국인</label>
				</div>
				<div class="form-check form-check-inline">
				  <input class="form-check-input" id="empForeig2" type="radio" name="empForeig" value="외국인">
				  <label class="form-check-label" for="empForeig2">외국인</label>
				</div>
			<p></p>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-user"></span>
				<h5 class="text-1000 mb-0">입사일자</h5>
			</div>
			<p class="mb-0 text-800"><input class="form-control" type="date" id="empHire" name="empHire" placeholder="입사일자" value=""></p>
			<div class="checkHire text-danger text-center"></div>
		</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="button">등록</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 외부관계자 등록 모달 끝 -->

<script type="text/javascript">


//채팅하기 <a>태그 호출
function aClick2(empNo) {
// 클릭한 버튼의 empNo 가져오기

console.log("aClick2->empNo : " + empNo);
document.getElementById("chatIcon").click();


updateChatWindow2(empNo);
};
//채팅창을 수정하기 위한 함수 호출
function updateChatWindow2(empNo) {
    $.ajax({
        type: "POST",
        url: "/chatIconDetail",
        contentType: "application/json",
        data: JSON.stringify({ empNo: empNo }),
        success: function (response) {
            console.log("받아온 채팅방 정보: ", response);
            var chatListContainer = $("#chatListContainer");
            var chatRoomDtlList = response;
            console.log("받아온 채팅방 chatRoomDtlList: ", chatRoomDtlList);

            if (chatRoomDtlList != null && chatRoomDtlList.length > 0) {
                

                var html = ""; // chatHtml 초기화

                $.each(chatRoomDtlList, function (index, chatRoomDtl) {
                    html += '<div class="d-flex chat-message" style="flex-direction: column;">';
                   	$("#titleBox2").text(chatRoomDtl.crcmTitle);

                   	chatListContainer.html('');
                   	
                    if (chatRoomDtl.chatMsg != null) {
                        // chatRoomDtl.chatMsg가 null이 아닐 때만 채팅 내용 출력
                        if (chatRoomDtl.chatuser == chatRoomDtl.chasenderEmpno) {
                            html += '<div class="d-flex mb-2 justify-content-end flex-1">';
                            html += '<div class="w-100 w-xxl-75">';
                            html += '<div class="d-flex flex-end-center hover-actions-trigger">';
                            html += '<div class="chat-message-content me-2">';
                            html += '<div class="mb-1 sent-message-content light bg-primary rounded-2 p-3 text-white">';
                            html += '<p class="mb-0">' + chatRoomDtl.chatMsg + '</p>';
                            html += '</div>';
                            html += '</div>';
                            html += '<div class="text-end">';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                        }else if(chatRoomDtl.chasenderEmpno == "Y"){
                           	html += '';
                        } else{
                            html += '<div class="d-flex mb-2 flex-1">';
                            html += '<div class="w-100 w-xxl-75">';
                            html += '<div class="d-flex hover-actions-trigger">';
                            html += '<div class="avatar avatar-m me-3 flex-shrink-0" data-crno="' + chatRoomDtl.crNo + '">';
                            html += '<img class="rounded-circle" src="..' + chatRoomDtl.empPhoto + '" alt="">';
                            html += '</div>';
                            html += '<div class="chat-message-content received me-2">';
                            html += '<div class="mb-1 received-message-content border rounded-2 p-3">';
                            html += '<p class="mb-0">' + chatRoomDtl.chatMsg + '</p>';
                            html += '</div>';
                            html += '<p class="mb-0 fs--2 text-600 fw-semi-bold ms-7">' + chatRoomDtl.chatDate + '</p>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                        }
                    }

                    html += '</div>';	
                    html += "<input type='hidden' name='chatMsgBoxesCrNo2' id='chatMsgBoxesCrNo2' value='" + chatRoomDtl.crNo + "'/>";
                });

                $("#chatListContainer").html(html);
            } else {
                // 채팅 내역이 없을 경우 처리
                html += "<input type='hidden' name='chatMsgBoxesCrNo2' id='chatMsgBoxesCrNo2' value='" + chatRoomDtl.crNo + "'/>";
                $("#chatListContainer").html('<p>채팅이 아직 없네요...</p>');
            }
            chatListContainer.html(html);
        },
        error: function (error) {
            console.error("채팅방 정보를 가져오는 중 오류가 발생했습니다.", error);
        }
    });
}

$("#myDelButton").on("click", function(){ // '내 주소록에서 해제' 버튼
	if($('input[type="checkbox"]:checked').length == 0){
		alert("해제할 직원을 선택해주세요");
		return;
	}
	
	var delData = [];
	$('input[type="checkbox"]:checked').each(function() {
		let obj = new Object();
		obj.mygrEmpno = $(this).val();
		obj.mygrCd = $(this).next().val();
		delData.push(obj);
	});
	console.log(delData);

	$.ajax({
		type: "post",
		url: "/add/delgroupmem.do",
		data: JSON.stringify(delData),
		contentType: "application/json; charset=utf-8",
		success: function(result){
			console.log(result);
			if(result == "SUCCESS"){
				$("#resultSpace").text("정상적으로 해제되었습니다.");
				new window.bootstrap.Modal(resultModal).show();
			}
		}
	});
});

// 내 주소록에서 해제 결과 모달 닫힐 때 이벤트 처리
resultModal.addEventListener('hide.bs.modal', function (event) {
	location.href="/add/myadd.do";
});

$("#addGroupButton").on("click", function(){ // '내 주소록에 추가' 모달 안에 '그룹 추가' 버튼
	if($("#newGroup input").length == 0){ // 선택한 요소의 컬렉션을 반환
		$("#newGroup").append(
			`<input class="form-control form-control" style="width:380px;" name="mygrName" type="text" placeholder="새로운 그룹명을 입력해주세요"/>`
		);
	}
});

</script>