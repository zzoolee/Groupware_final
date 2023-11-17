<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- chatSocketJS CDN -->
<script src="https://cdn.jsdelivr.net/sockjs/1/sockjs/min.js"></script>
<!-- jstree cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<style>
.custom-button {
   display: inline-block;
    padding: 5px 20px;
    background-color: transparent; /* 배경색을 투명하게 설정 */
    border: none; /* 테두리 제거 */
    cursor: pointer;
    width: 100%; /* 버튼을 부모 요소(li)에 맞추기 위해 너비 100% 설정 */
    text-align: center; /* 텍스트를 왼쪽 정렬 */
    background-clip: content-box;
}
.nav-item.room {
    display: flex;
    flex-direction: row;
    text-align: left;
}
.nav-item.room .avatar {
    margin-right: 2px; /* 이미지와 텍스트 사이의 간격 설정 */
}
.chatRoomDtl{
	list-style: none;
}

</style>

<div class="chat d-flex phoenix-offcanvas-container pt-1 mt-n1 mb-9">
<sec:authentication property="principal.emp.empNo" var="empNo"/>
	<div class="card p-3 p-xl-1 mt-xl-n1 chat-sidebar me-3 phoenix-offcanvas phoenix-offcanvas-start" id="chat-sidebar">
		<button class="btn d-none d-sm-block d-xl-none mb-2" data-bs-toggle="modal" data-bs-target="#chatSearchBoxModal">
		</button>
		<div class="d-none d-sm-block d-xl-none mb-5">
			<button class="btn w-100 mx-auto" type="button" data-bs-toggle="dropdown" data-boundary="window"
				aria-haspopup="true" aria-expanded="false" data-bs-reference="parent">
			</button>
		</div>
		<div>
			<button class="btn btn-primary me-1 mb-1 btn-sm align-items-end" type="button" style="width: 110px; float: right;" id="groupChatBtn">그룹채팅방 +</button>
		</div>
		<div class="form-icon-container mb-4 d-sm-none d-xl-block">
		    <!-- 검색폼 시작 -->
		    <form class="position-relative" action="/chatListSearch" method="post" data-bs-toggle="search" data-bs-display="static">
		        <input class="form-control search-input search" type="text" name="chatListSearch" id="chatListSearch" aria-label="Search" placeholder="People, Groups and Messages" />
		    </form>
		    <!-- 검색폼 끝 -->
		</div>
		
		<!-- aria-selected="true" = 버튼이 눌린상태 -->
		<ul class="nav nav-phoenix-pills mb-5 d-sm-none d-xl-flex" id="contactListTab" 
		    data-chat-thread-tab="data-chat-thread-tab" role="tablist">
		    <li class="nav-item" role="presentation">
		        <!-- 사원 탭을 클릭할 때 -->
		        <button class="custom-button" id="searchUser" role="tab" data-chat-thread-list="user" data-bs-toggle="tab">사원</button>
		    </li>
		    <li class="nav-item" role="presentation">
		        <!-- 채팅방 탭을 클릭할 때 -->
		        <button class="custom-button" id="searchRoom" role="tab" data-chat-thread-list="room" data-bs-toggle="tab">채팅방</button>
		    </li>
		</ul>
	    <div class="scrollbar">
		    <!-- 채팅방 리스트 범위 시작 -->
		    <div class="tab-content" id="contactListTabContent">
			    <div data-chat-thread-tab-content="data-chat-thread-tab-content" id="chatListBox" data-id="개똥이">
			        <ul class="nav chat-thread-tab flex-column list" id="chatUl">
			            <c:choose>
			                <c:when test="${empty chatList}">
			                    <li class="nav-item read" role="presentation">
			                        <p>말하던 상대가 없네요...</p>
			                    </li>
			                </c:when>
			                <c:otherwise>
			                    <c:forEach var="chatList" items="${chatList}">
			                        <li class="nav-item read" role="presentation" style="margin-bottom: 10px;">
			                            <a class="nav-link d-flex align-items-center p-2" data-bs-toggle="tab" data-chat-thread="data-chat-thread" href="#" role="tab" aria-selected="true" id="chatUser" data-crno="${chatList.crNo}" data-empno="${chatList.empNo}">
			                               	<c:choose>
				                                <c:when test="${chatList.atStatus == '업무'}">
					                                <div class="avatar avatar-xl status-online position-relative me-2 me-sm-0 me-xl-2">
				                                </c:when>
				                                <c:otherwise>
					                                <div class="avatar avatar-xl status-offline position-relative me-2 me-sm-0 me-xl-2">
				                                </c:otherwise>
			                               	</c:choose>
			                               	<c:choose>
			                               		<c:when test="${chatList.empPhoto == null}">
				                                    <img class="rounded-circle border border-2 border-white" src="../resources/assets/img/team/avatar-rounded.webp" alt="${chatList.empName}" />
			                               		</c:when>
			                               		<c:otherwise>
				                                    <img class="rounded-circle border border-2 border-white" src="..${chatList.empPhoto}" alt="${chatList.empName}" />
			                               		</c:otherwise>
			                               	</c:choose>
			                                </div>
			                                <div class="flex-1 d-sm-none d-xl-block text-start" style="margin-left: 50px; line-height: 0px;">
			                                    <div class="d-flex flex-column justify-content-between">
			                                        <h5 class="text-1000 fw-normal name mb-1" style="font-size: 1rem;">${chatList.empName}</h5>
			                                        <p class="fs--2 text-600 mb-0 text-end" style="margin-top: -5px;">${chatList.deptName}</p>
			                                        <p class="fs--1 line-clamp-1 text-600 message" style="margin-top: 5px;">${chatList.chatMsg}</p>
			                                    </div>
			                                </div>
			                            </a>
			                        </li>
							        <input type="hidden" name="chatListBoxCrNo" id="chatListBoxCrNo" value="${chatList.crNo}"/> 
			                        <hr style="margin: 15px; border-color: #f1f2f6;">
			                    </c:forEach>
			                </c:otherwise>
			            </c:choose>
			        </ul>
			    </div>
			</div>
		    <!-- 유저리스트 범위 끝 -->
		</div>
	</div>
	<div class="chat-content tab-content flex-1">
	<!-- 채팅구역 시작 -->
		<div class="tab-pane h-100 fade active show" id="tab-thread-1"
			role="tabpanel" aria-labelledby="tab-thread-1">
			<div class="card flex-1 h-100 phoenix-offcanvas-container">
				<div class="card-header p-3 p-md-4 d-flex flex-between-center">
					<div class="d-flex align-items-center">
						<button class="btn ps-0 pe-2 text-700 d-sm-none"
							data-phoenix-toggle="offcanvas"
							data-phoenix-target="#chat-sidebar">
							<span class="fa-solid fa-chevron-left"></span>
						</button>
						<div class="d-flex flex-column flex-md-row align-items-md-center">
							<button class="btn fs-1 fw-semi-bold text-1100 d-flex align-items-center p-0 me-3 text-start">
								<span class="line-clamp-1" id="titleBox"></span>
							</button>
							<p class="fs--1 mb-0 me-2">
							<div>
								<button class="btn d-block p-0 fw-semi-bold mb-3" id="nickNameModifyBtn" data-crno = "${chatRoomDtlList.crNo}"><span class="fa-solid fa-user-pen me-3"></span>방 제목 변경</button>
							</div>
						</div>
					</div>
					<div class="btn-group">
					    <button class="btn btn-secondary dropdown-toggle" type="button" id="userList-dropdown" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" data-bs-reference="parent">
						    user List
						</button>
						<div class="dropdown-menu" aria-labelledby="userList-dropdown" id="userListDropdown">
						    <!-- 여기에 유저 리스트 아이템들을 추가 -->
						    <!-- 유저 리스트가 여기에 동적으로 추가될 것입니다. -->
						</div>
					</div>
				</div>
					<div class="card-body p-3 p-sm-4 scrollbar" id="chatMessageBody">
						<c:forEach items="${chatRoomDtlList}" var="chatMessage">
						</c:forEach>
					</div>
				<div class="card-footer">
					<textarea id="messageInput" style="width:100%;border: none;outline: none; resize: none;" placeholder="채팅입력..." ></textarea>
					<div class="d-flex justify-content-between align-items-end">
						<div>
							<label class="btn btn-link py-0 px-2 text-900 fs--1" for="chatPhotos-0">
							<span class="fa-solid fa-image"></span>
							<input class="d-none" type="file" accept="image/*" id="chatPhotos" /> 
							</label>
							<label class="btn btn-link py-0 px-2 text-900 fs--1" for="chatAttachment-0"> 
							<span class="fa-solid fa-paperclip"></span>
							<input class="d-none" type="file" id="chatAttachment" />
							</label> 
						</div>
						<div>
							<button class="btn btn-primary fs--2" type="button" id="sendMessageBtn">Send<span class="fa-solid fa-paper-plane ms-1"></span>
							</button>
						</div>
					</div>
				</div>
			</div>
        </div>
         <!-- 채팅구역 끝 -->
	</div>
</div>
<!-- 방제목 변경 모달 -->
<div class="modal" id="nicknameModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">채팅방 제목 변경</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="text" id="nicknameInput" class="form-control" placeholder="바꿀 제목을 입력하세요">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="confirmNicknameBtn">확인</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>
<!-- 그룹채팅방 개설 모달(조직도) 시작 -->
<div class="modal fade" id="groupChatModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true" data-empno="${empNo }">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">조직도</h5>
        <div>
	      	<button class="btn btn-soft-info me-1 mb-1 groupChat_setAll" type="button" data-value="openStatus">전체열기/닫기</button>
	      	<button class="btn btn-soft-info me-1 mb-1 groupChat_setAll" type="button" data-value="checkStatus">전체선택/해제</button>
<!--         <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" data-fa-i2svg=""><path fill="currentColor" d="M310.6 361.4c12.5 12.5 12.5 32.75 0 45.25C304.4 412.9 296.2 416 288 416s-16.38-3.125-22.62-9.375L160 301.3L54.63 406.6C48.38 412.9 40.19 416 32 416S15.63 412.9 9.375 406.6c-12.5-12.5-12.5-32.75 0-45.25l105.4-105.4L9.375 150.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 210.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0s12.5 32.75 0 45.25l-105.4 105.4L310.6 361.4z"></path></svg><span class="fas fa-times fs--1"></span> Font Awesome fontawesome.com</button> -->
      	</div>
      </div>
      <div class="modal-body">
        <div class="d-flex justify-content-end">
	      	<input class="form-control" style="width:250px;" id="groupChat_search_input" type="search" placeholder="Search..." aria-label="Search">
        </div>
        <hr>
        <p class="text-700 lh-lg mb-0">
        	<!-- 조직도 들어가는 곳 -->
        </p>
      </div>
      <div class="modal-footer">
      	<button class="btn btn-info me-1 mb-1" type="button" id="groupChat_selectTree">만들기</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 그룹채팅방 개설 모달(조직도) 끝 -->

<script type="text/javascript">
        
        $(document).ready(function () {
        	
            var chatListSearch = $('#chatListSearch');
            var contactListTabContent = $('#contactListTabContent');
            var selectedTab = 'user'; 
            
            $("#contactListTab").on("click", ".custom-button", function(){
                console.log("contactListTab->chat-thread-list : " + $(this).data("chat-thread-list"));
                var tab = $(this).data("chat-thread-list");
				
                selectedTab = tab;
                
                console.log("244번째줄->selectedTab : " + selectedTab);
                
                // 클릭 이벤트에서 바로 서버에 전송
                sendSearchRequest();
            });

            $(document).on("keyup", "#chatListSearch", function () {
                var chatSearchKeyword = chatListSearch.val();
                console.log("chatSearchKeyword : " + chatSearchKeyword);
                console.log("selectedTab : " + selectedTab); // 업데이트된 selectedTab 값 확인

                // 키업 이벤트에서 서버에 전송
                sendSearchRequest(chatSearchKeyword);
            });

            function sendSearchRequest(keyword) {
                var chatSearchData = {
                    "keyword": keyword || chatListSearch.val(),
                    "tab": selectedTab
                };
                //chatSearchData: {"keyword":"ㅁㅁ","tab":"user"}
                console.log("chatSearchData: " + JSON.stringify(chatSearchData));

                var ajaxConfig = {
                    type: 'POST',
                    url: '/searchChat.do',
                    data: JSON.stringify(chatSearchData),
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        console.log("result : " + response);
                        console.log('에이잭스 결과값 반환');
//                         contactListTabContent.html('');
                        if (response && response.length > 0) {
                            var html = "";
                            for (var i = 0; i < response.length; i++) {
                                if (selectedTab === 'user') {
                                    sessionStorage.setItem("chatUserCrNo" + i, response[i].crNo);
                                    html += '<div class="nav-item user" role="presentation">';
                                    html += '    <a class="nav-link d-flex align-items-center justify-content-center p-2 active"';
                                    html += '    data-bs-toggle="tab" data-chat-thread="data-chat-thread"';
                                    html += '    href="" aria-selected="true"';
                                    html += '    id="chatUser" data-crno="' + response[i].crNo + '" data-empno="' + response[i].empNo + '">';
                                    html += '        <div class="flex-1 d-sm-none d-xl-block">';
                                    html += '            <div class="chat-info">';
                                    html += '                <div class="d-flex justify-content-between align-items-center">';
                                    if (response[i].atStatus == "업무") {
                                        html += '                    <div class="avatar avatar-xl status-online position-relative me-2 me-sm-0 me-xl-2">';
                                    } else {
                                        html += '                    <div class="avatar avatar-xl status-offline position-relative me-2 me-sm-0 me-xl-2">';
                                    }
                                    if (response[i].empPhoto == null) {
                                        html += '                        <img class="rounded-circle border border-2 border-white" src="../resources/assets/img/team/avatar-rounded.webp" alt="' + response[i].empName + '">';
                                    } else {
                                        html += '                        <img class="rounded-circle border border-2 border-white" src="..' + response[i].empPhoto + '" alt="' + response[i].empName + '">';
                                    }
                                    html += '                    </div>';
                                    html += '                    <div class="chat-info-header">';
                                    html += '                        <p>' + (response[i].empName ? response[i].empName : response[i].crcmTitle) + '</p>';
                                    html += '                    </div>';
                                    html += '                    <p class="fs--2 text-600 mb-0 text-nowrap">' + response[i].deptName + '</p>';
                                    html += '                </div>';
                                    html += '            </div>';
                                    html += '            <div class="chat-info-body">';
                                    html += '            </div>';
                                    html += '        </div>';
                                    html += '    </a>';
                                    html += '</div>';
                                    html += '<input type="hidden" name="chatListBoxCrNo" id="chatListBoxCrNo" value=" ' + response[i].crNo + '"/>';
                                    html += '<p></p>';
                                    html += '<hr/>';
                                    html += '<p></p>';
                                } else if(response[i].chatMsg != null && response[i].chasenderEmpno != 'Y') {
                                    html += '<div class="nav-item room" role="presentation" style="flex-direction: column;">';
                                    html += '    <a class="nav-link align-items-center justify-content-center p-2 active"';
                                    html += '    data-bs-toggle="tab" data-chat-thread="data-chat-thread"';
                                    html += '    href="" role="tab" aria-selected="true"';
                                    html += '    data-crno="' + response[i].crNo + '" data-empno="' + response[i].empNo + '"';
                                    html += '    id="chatRoomDtl' + response[i].crNo + '">';
                                    html += '        <div class="flex-1 d-sm-none d-xl-block">';
                                    html += '            <div class="chat-info">';
                                    html += '                <div class="d-flex justify-content-between align-items-center">';
                                    html += '                    <div class="avatar avatar-xl position-relative me-2 me-sm-0 me-xl-2">';
                                    if (response[i].crSe == '그룹') {
                                        html += '                        <img class="rounded-circle border border-2 border-white" src="../resources/assets/img/team/pngegg.png" alt="">';
                                    } else {
                                        html += '                        <img class="rounded-circle border border-2 border-white" src="../resources/assets/img/team/avatar-rounded.webp" alt="">';
                                    }
                                    html += '                    </div>';
                                    html += '                    <div class="chat-info-header" style="justify-content:center;">';
                                    html += '                        <p>' + (response[i].empName ? response[i].empName : response[i].crcmTitle) + '</p>';
                                    html += '                    </div>';
                                    html += '                    <p class="fs--2 text-600 mb-0 text-nowrap">' + (response[i].chatMsg ? response[i].chatDate : "") + '</p>';
                                    html += '                </div>';
                                    html += '            </div>';
                                    html += '            <div class="chat-info-body">';
                                    if (response[i].chasenderEmpno == 'YS') {
                                        html += '';
                                    } else {
                                        html += '                <p class="fs--1 mb-0 line-clamp-1 text-600 message" style="text-align : left;">' + response[i].chatMsg + '</p>';
                                    }
                                    html += '            </div>';
                                    html += '        </div>';
                                    html += '    </a>';
                                    html += '</div>';
                                    html += '<input type="hidden" name="chatListBoxCrNo" id="chatListBoxCrNo" value=" ' + response[i].crNo + '"/>';
                                    html += '<p></p>';
                                    html += '<hr/>';
                                    html += '<p></p>';
                                }
                            }
                            $("#chatListBox").html(html);
                        }
                    },
                    error: function (error) {
                        console.error("에러 발생 !! :", error);
                    }
                };
                $.ajax(ajaxConfig);
            }

                
                
            $("#userList-dropdown").click(function () {
                var crNo =  $("#chatMsgBoxesCrNo").val();
                console.log("crno!!!" + crNo);
				if(crNo != null){
	                fetchUserList(crNo);
				}
            });

            function fetchUserList(crNo) {
                $.ajax({
                    type: "POST",
                    url: "/getUserList.do", 
                    data: JSON.stringify({ crNo: crNo }),
                    contentType : "application/json; charset=utf-8",
                    success: function (response) {
                    	console.log("ajax실행 : " + response);
                        var userListDropdown = $("#userListDropdown");
                        userListDropdown.empty();

                        for (var i = 0; i < response.length; i++) {
                            var userItem = $("<p class='dropdown-item'>" + response[i].empName + "</p>");
                            userListDropdown.append(userItem);
                        }
                    },
                    error: function (error) {
                        console.error("Error 발생 !!", error);
                    }
                });
            }
            fetchUserList();
            
        	$("#nickNameModifyBtn").click(function (event) {
        	    // 모달 열기
        	    $("#nicknameModal").modal('show');
        	});

        	// 확인 버튼 클릭 시
        	$("#confirmNicknameBtn").click(function () {
        	    var crNo = $("#chatMsgBoxesCrNo").val();
        	    console.log("바꾸는 채팅방 번호 : ", crNo);
        	    var crcmTitle = $("#nicknameInput").val();
        	    console.log("바뀐 채팅방 제목: ", crcmTitle);
        	    var data = {
        	        crcmTitle: crcmTitle,
        	        crNo: crNo
        	    };
        	    if (crNo != null) {
        	        // $.ajax
        	        $.ajax({
        	            type: "POST",
        	            url: "/crcmModify.do",
        	            contentType: "application/json; charset=utf-8",
        	            data: JSON.stringify(data),
        	            success: function (response) {
        	                console.log("ajax 실행 여부 확인,,, ", response);
        	                $("#crcmTitle").html("");
        	                $("#titleBox").text(response.crcmTitle);

        	                var html = "";
        	                for (var i = 0; i < response.chatList.length; i++) {
        	                    if (response.chatList[i].chatMsg != null && response.chatList[i].chasenderEmpno != 'Y') {
        	                        html += '<div class="nav-item room" role="presentation" style="flex-direction: column;">';
        	                        html += '    <a class="nav-link align-items-center justify-content-center p-2 active"';
        	                        html += '    data-bs-toggle="tab" data-chat-thread="data-chat-thread"';
        	                        html += '    href="" role="tab" aria-selected="true"';
        	                        html += '				data-crno="' + response.chatList[i].crNo + '" data-empno="' + response.chatList[i].empNo + '"';
        	                        html += '				id="chatRoomDtl' + response.chatList[i].crNo + '">';
        	                        html += '        <div class="flex-1 d-sm-none d-xl-block">';
        	                        html += '            <div class="chat-info">';
        	                        html += '                <div class="d-flex justify-content-between align-items-center">';
        	                        html += '                    <div class="avatar avatar-xl position-relative me-2 me-sm-0 me-xl-2">';
        	                        if (response.chatList[i].crSe == '그룹') {
        	                            html += '                        <img class="rounded-circle border border-2 border-white" src="../resources/assets/img/team/pngegg.png" alt="">';
        	                        } else {
        	                            html += '                        <img class="rounded-circle border border-2 border-white" src="../resources/assets/img/team/avatar-rounded.webp" alt="">';
        	                        }
        	                        html += '                    </div>';
        	                        html += '                    <div class="chat-info-header" style="justify-content:center;">';
        	                        html += '                        <p>' + (response.chatList[i].empName ? response.chatList[i].empName : response.chatList[i].crcmTitle) + '</p>';
        	                        html += '                    </div>';
        	                        html += '                    <p class="fs--2 text-600 mb-0 text-nowrap">' + (response.chatList[i].chatMsg ? response.chatList[i].chatDate : "") + '</p>';
        	                        html += '                </div>';
        	                        html += '            </div>';
        	                        html += '            <div class="chat-info-body">';
        	                        if (response.chatList[i].chasenderEmpno == 'YS') {
        	                            html += '';
        	                        } else {
        	                            html += '                <p class="fs--1 mb-0 line-clamp-1 text-600 message" style="text-align : left;">' + response.chatList[i].chatMsg + '</p>';
        	                        }
        	                        html += '            </div>';
        	                        html += '        </div>';
        	                        html += '    </a>';
        	                        html += '</div>';
        	                        html += '<input type="hidden" name="chatListBoxCrNo" id="chatListBoxCrNo" value=" ' + response.chatList[i].crNo + '"/>';
        	                        html += '<p></p>';
        	                        html += '<hr/>';
        	                        html += '<p></p>';
        	                    } else {
        	                        html += '';
        	                    }
        	                }
        	                $("#chatListBox").html(html);
        	            }
        	        });
        	    } else {
        	        alert("방을 선택해 주세요.");
        	    }
        	    $("#nicknameModal").modal('hide');
        	});

      	$("#searchRoom").click(function () {
                $.ajax({
                    url: '/selectChatRoom',
                    type: 'POST',
                    success: function (response) {
                        $("#chatListBox").html("");
                        console.log("searchRoom->채팅방 리스트: " + response);
                        if (response && response.length > 0) {
                            var html = "";
                            for (var i = 0; i < response.length; i++) {
                            	if(response[i].chatMsg != null && response[i].chasenderEmpno != 'Y'){
	                                html += '<div class="nav-item room" role="presentation" style="flex-direction: column;">';
	                                html += '    <a class="nav-link align-items-center justify-content-center p-2 active"';
	                                html += '    data-bs-toggle="tab" data-chat-thread="data-chat-thread"';
	                                html += '    href="" role="tab" aria-selected="true"';
	                                html += '				data-crno="' + response[i].crNo + '" data-empno="' + response[i].empNo +'"';
	                                html += '				id="chatRoomDtl' + response[i].crNo +'">';
	                                html += '        <div class="flex-1 d-sm-none d-xl-block">';
	                                html += '            <div class="chat-info">';
	                                html += '                <div class="d-flex justify-content-between align-items-center">';
	                                html += '                    <div class="avatar avatar-xl position-relative me-2 me-sm-0 me-xl-2">';
	                                if(response[i].crSe == '그룹'){
		                                html += '                        <img class="rounded-circle border border-2 border-white" src="../resources/assets/img/team/pngegg.png" alt="">';
	                                }else{
		                                html += '                        <img class="rounded-circle border border-2 border-white" src="../resources/assets/img/team/avatar-rounded.webp" alt="">';
	                                }
	                                html += '                    </div>';
	                                html += '                    <div class="chat-info-header" style="justify-content:center;">';
	                                html += '                        <p>' + (response[i].empName ? response[i].empName : response[i].crcmTitle) + '</p>';
	                                html += '                    </div>';
	                                html += '                    <p class="fs--2 text-600 mb-0 text-nowrap">' + (response[i].chatMsg ? response[i].chatDate : "") + '</p>';
	                                html += '                </div>';
	                                html += '            </div>';
	                                html += '            <div class="chat-info-body">';
	                                if(response[i].chasenderEmpno == 'YS'){
	                                	html += '';
	                                }else {
		                                html += '                <p class="fs--1 mb-0 line-clamp-1 text-600 message" style="text-align : left;">' + response[i].chatMsg + '</p>';
	                                }
	                                html += '            </div>';
	                                html += '        </div>';	
	                                html += '    </a>';
	                                html += '</div>';
	                        		html += '<input type="hidden" name="chatListBoxCrNo" id="chatListBoxCrNo" value=" '+ response[i].crNo + '"/>';
	                        		html += '<p></p>';
	                        		html += '<hr/>';
	                        		html += '<p></p>';
                            	}else{
	                        		html += '';
                            	}
                            }
                        }
                        $("#chatListBox").html(html); 
                    	},
                	});
           	 	});
        	});
        
	    	$("#searchUser").click(function(){
				$.ajax({
					url: '/selectChatUser',
					type: 'POST',
					success: function(response){
						$("#chatListBox").html("");
//                         console.log("searchUser->채팅방 리스트: " + response);
                        if (response && response.length > 0) {
                        	console.log("searchUser->if안에 들어옴, response.length : " + response.length);
                            var html = "";
                            for (var i = 0; i < response.length; i++) {
								var crNo = response[i].crNo;
                                sessionStorage.setItem("chatUserCrNo" + i, crNo);
                            	html += '<div class="nav-item user" role="presentation">';
                                html += '    <a class="nav-link d-flex align-items-center justify-content-center p-2 active"';
                                html += '    data-bs-toggle="tab" data-chat-thread="data-chat-thread"';
                                html += '    href="" aria-selected="true"';
                                html += '	 id="chatUser" data-crno="' + response[i].crNo + '" data-empno="' + response[i].empNo + '">';
                                html += '        <div class="flex-1 d-sm-none d-xl-block">';
                                html += '            <div class="chat-info">';
                                html += '                <div class="d-flex justify-content-between align-items-center">';
	                               if(response[i].atStatus == "업무"){
	                              	 	html += '                    <div class="avatar avatar-xl status-online position-relative me-2 me-sm-0 me-xl-2">';
	                               }else{
	                               		html += '                    <div class="avatar avatar-xl status-offline position-relative me-2 me-sm-0 me-xl-2">';
	                               }
	                            	if(response[i].empPhoto == null){
		                                html += '                        <img class="rounded-circle border border-2 border-white" src="../resources/assets/img/team/pngegg221.webp" alt="'+response[i].empName+'">';
	                            	}else{
		                                html += '                        <img class="rounded-circle border border-2 border-white" src="..'+ response[i].empPhoto +'" alt="'+response[i].empName+'">';
	                            	}
                                html += '                    </div>';
                                html += '                    <div class="chat-info-header">';
                                html += '                        <p>' + (response[i].empName ? response[i].empName : response[i].crcmTitle) + '</p>';
                                html += '                    </div>';
                                html += '                    <p class="fs--2 text-600 mb-0 text-nowrap">' + response[i].deptName + '</p>';
                                html += '                </div>';
                                html += '            </div>';
                                html += '            <div class="chat-info-body">';
                                html += '            </div>';
                                html += '        </div>';
                                html += '    </a>';
                                html += '</div>';
                        		html += '<input type="hidden" name="chatListBoxCrNo" id="chatListBoxCrNo" value=" '+ response[i].crNo + '"/>';
                        		html += '<p></p>';
                        		html += '<hr/>';
                        		html += '<p></p>';
                            }//end for
                        }//end if
                        console.log("searchUser->html : " + html);
                        $("#chatListBox").html(html); // jQuery 문법 사용
                    	},
                	});
           	 	});
// 	    	$("[id^='chatRoomDtl']").click(function(event) {
	    	$("#chatListBox").on("click","a",function(event) {
	    	    event.preventDefault(); // 링크의 기본 동작을 중단
	    	    var crcmTitle = $(this).data("crctitle");
	    	    // 클릭한 링크의 데이터 속성에서 crNo를 가져옴
// 	    	    var titleBox = $("#titleBox").html();
	    	    var empNo = $(this).data("empno");
	    	    var crNo = $(this).data("crno");
	    	    sessionStorage.setItem("saveCrNo", crNo);
	    	    console.log("requestBody crNo : " + crNo);
	    	    console.log("requestBody empNo : " + empNo);
		        var requestData = {
		        	    empNo: empNo, // 배열처리
		        	    crNo: crNo
		        	};
		        
	    	    console.log("requestData : " + requestData);
	    	    $.ajax({
	    	        url: '/checkChat',
	    	        type: 'POST',
	    	        data: JSON.stringify(requestData),
	    	        contentType: "application/json",
	    	        dataType:"json",
	    	        success: function(response) {
	    	        	$("#chatMessageBody").html("");
	    	            console.log("채팅내역 : " + JSON.stringify(response)); // 서버에서 온 데이터 처리
	    	            if(response && response.length > 0){
   	                		$("#titleBox").text(response[0].crcmTitle);
	    	                var html = "";
	    	                for (var i = 0; i < response.length; i++) {
	    	                		if(response[0].chatMsg != null){
			    	                	if(response[i].chasenderEmpno == "${empNo}"){
	// 		    	                		titleBox.text(response[i].crcmTitle);
	// 		    	                		console.log("titleBox" + response[i].crcmTitle);
			    	                		html += '<div class="d-flex chat-message">';
			    	                		html += '	<div class="d-flex mb-2 justify-content-end flex-1">';
			    	                		html += '	  <div class="w-100 w-xxl-75">';
			    	                		html += '		<div class="d-flex flex-end-center hover-actions-trigger">';
			    	                		html += '		  <div class="chat-message-content me-2">';
			    	                		html += '			<div class="mb-1 sent-message-content light bg-primary rounded-2 p-3 text-white">';
			    	                		html += '			  <p class="mb-0">'+response[i].chatMsg+'</p>';
			    	                		html += '			</div>';
			    	                		html += '		  </div>';
			    	                		html += '		</div>';
			    	                		html += '		<div class="text-end">';
			    	                		html += '		  <p class="mb-0 fs--2 text-600 fw-semi-bold">'+response[i].chatDate+'</p>';
			    	                		html += '		</div>';
			    	                		html += '	  </div>';
			    	                		html += '	</div>';
			    	                		html += '</div>';
			    	                	}else if(response[i].chasenderEmpno == 'Y'){
			    	                		html += '';
			    	                	}else if(response[i].chasenderEmpno == 'YS'){
			    	                		html += '';
			    	                	}else{
			    	                		html += '<div class="d-flex chat-message">';
			    	                		html += '	<div class="d-flex mb-2 flex-1">';
			    	                		html += '	  <div class="w-100 w-xxl-75">';
			    	                		html += '		<div class="d-flex hover-actions-trigger">';
			    	                		html += '		  <div class="avatar avatar-m me-3 flex-shrink-0" data-empno="'+response[i].chasenderEmpno+'"><img class="rounded-circle" src="/resources/profile/'+response[i].empPhoto+'" alt=""></div>';
			    	                		html += '		  <div class="chat-message-content received me-2">';
			    	                		html += '			<div class="mb-1 received-message-content border rounded-2 p-3">';
			    	                		html += '			  <p class="mb-0">'+response[i].chatMsg+'</p>';
			    	                		html += '			</div>';
			    	                		html += '		  </div>';
			    	                		html += '		</div>';
			    	                		html += '		<p class="mb-0 fs--2 text-600 fw-semi-bold ms-7">'+response[i].chatDate+'</p>';
			    	                		html += '	  </div>';
			    	                		html += '	</div>';
			    	                		html += '</div>';
			    	                	}
	    	                		}
		    	                }//end for
		    	                html += "<input type='hidden' name='chatMsgBoxesCrNo' id='chatMsgBoxesCrNo' value='"+response[0].crNo+"'/>";
		    	                $("#chatMessageBody").html(html);
		    	             	// 스크롤을 가장 아래로 내림
		    	                scrollToBottom();
		    	            } else {
		    	                console.log("서버로부터 받은 데이터가 없음");
	    	                }//end if
	    	        },
	    	        error: function(error) {
	    	            console.error('/checkChat', error);
	    	        }
	    	    });
	    	});
        
///////////////// 그룹채팅방 개설(조직도) 시작 /////////////////
let groupChat_treeContent;
let groupChat_select; // 선택된 사람들이 객체로 들어있음
let groupChat_modal;
let groupChat_openFlag = false;
let groupChat_checkFlag = false;

$("#groupChatBtn").on("click", function(){
	groupChat_treeContent = $("#groupChatModal .modal-body > p");
	groupChat_treeContent.jstree({
		"core" : {
			"data" : {
				"url" : "/add/treelist.do",
				"dataType": "json"
			},
			"check_callback" : true // 동적 노드 생성 허용!!!!!
		},
		"checkbox" : {
		      "three_state" : true, // 자식 노드 선택시 부모 노드 선택
		      "keep_selected_style" : false
	    },
		"search": {
	        "show_only_matches" : false,
	        "show_only_matches_children" : false
	    },
	    "types" : {
	    	"#" : {
	    	      "max_children" : 1,
	    	      "max_depth" : 4,
	    	      "valid_children" : ["root"]
    	    },
	    	"default" : {
	    		"icon" : false
       	 	}
	    },
	    "state" : {
	         "opened" : false,
	         "selected" : false
        },
		"plugins" : ["checkbox", "search", "types", "state", "changed"]
	});
	
	groupChat_treeContent.bind("loaded.jstree", function(e, data) {
		console.log("트리 로딩 완료");
		var model = groupChat_treeContent.jstree(true)._model.data;
		$.each(model, function(idx, idata){ // 전체 객체 참조
		    console.log( idata.id );
		    $.ajax({
				type: "get",
				url: "/add/deptemp.do?deptCd=" + idata.id,
				dataType : "json",
				success: function(result){
					if(result != null && result.length != 0){
						console.log("result : " + JSON.stringify(result));
						for(var i = 0; i < result.length; i++){
							groupChat_treeContent.jstree(true).create_node(idata.id, result[i], "last", function(){
								console.log("노드 생성 성공");
							});
						}
					}
				}
			});
		});
	}.bind(this));
	
	// 해당 id의 노드를 open 상태로 바꿉니다.
	groupChat_treeContent.on("ready.jstree", function(){
		$(this).jstree("open_node", "#"); // 이 경우 id가 1번인 root노드를 열린 상태로 로드함
	});
	 
	groupChat_treeContent.on("changed.jstree", function (e, data) {
	    console.log("changed id : " + data.node.id);
	    console.log("changed node childeren : " + data.node.children);
	});
	
	groupChat_treeContent.bind("select_node.jstree", function (e, data) {
		console.log("select id : " + data.node.id);
		console.log("select node childeren : " + data.node.children);
	}); 	
  	var to = false;
  	$('#groupChat_search_input').keyup(function () {
  	    if(to) { clearTimeout(to); }
  	    to = setTimeout(function () {
  	      var v = $('#groupChat_search_input').val();
  	      groupChat_treeContent.jstree(true).search(v);
  	    }, 250);
  	});
	  	
  	groupChat_modal = new window.bootstrap.Modal(groupChatModal);
  	groupChat_modal.show();
});

$("#groupChat_selectTree").on("click", function(){
	groupChat_select = groupChat_treeContent.jstree('get_selected',true);
	console.log(groupChat_select); // 선택된 사람들 리스트
//  	console.log("선택된 사람[0] 아이디 : " + groupChat_select[0].id);
//  	console.log("선택된 사람[0] 이름 : " + groupChat_select[0].text);
//  	console.log("선택된 사람[0] 부서 : " + groupChat_select[0].original.deptVO);

	ChatEmpNoList.length = 0; // 배열 비워준다
	
	let cnt = 0;
	for(var i = 0; i < groupChat_select.length; i++){
		var isMe = false;
		if(groupChat_select[i].id == $("#groupChatModal").data("empno")){ // 본인을 선택하면
			var isMe = true;
		}
		if(isMe){
			cnt++;
			continue;
		}
		if(groupChat_select[i].original.deptVO != null){
			ChatEmpNoList.push(groupChat_select[i].id);
		}
	}
	if(cnt != 0){
// 		alert("본인 제외... 이건 굳이 알려주지 않아도 될 것 같아 주석 처리 합니다.");
		console.log("본인 제외됨");
	}
	console.log(ChatEmpNoList);
	
	
	$.ajax({
		url : "/groupChat",
		type: 'POST',
        data: JSON.stringify(ChatEmpNoList),
        contentType: "application/json",
		dataType: "json",
		success: function(resomse){
			}
	});
	
	groupChat_modal.hide();
});

$(".groupChat_setAll").on("click", function(){
	var value = $(this).data("value"); // data-value 값을 가져옵니다.
	console.log(value);
	if(value == "openStatus"){
		if(!groupChat_openFlag){
			groupChat_openFlag = true;
			groupChat_treeContent.jstree("open_all");
		}else{
			groupChat_openFlag = false;
			groupChat_treeContent.jstree("close_all");
		}
	}
	if(value == "checkStatus"){
		if(!groupChat_checkFlag){
			groupChat_checkFlag = true;
			groupChat_treeContent.jstree("check_all");
		}else{
			groupChat_checkFlag = false;
			groupChat_treeContent.jstree("uncheck_all");
		}
	}	
});

///////////////// 그룹채팅방 개설(조직도) 끝 /////////////////

</script>