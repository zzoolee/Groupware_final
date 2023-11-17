<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- jstree cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<h2>전사주소록</h2>
<br>

<c:if test="${not empty message }">
	<script type="text/javascript">
		alert("${message}");
		<c:remove var="message" scope="request"/>
		<c:remove var="message" scope="session"/>
	</script>
</c:if>

<!-- 검색창 포함 테이블 -->
<div id="addressTable" data-list='{"valueNames":["dept","rank","name","mail","hp"],"page":8,"pagination":true}'> <!-- 검색, 페이징 설정 -->
	<div class="row align-items-center justify-content-between g-3 mb-4">
	  <div class="d-flex justify-content-between align-items-center border-0">
	      <button class="btn btn-outline-primary rounded-pill me-1 mb-1" onclick="location.href='/add/exceldownload.do'"><svg class="svg-inline--fa fa-file-export fs--1 me-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="file-export" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512" data-fa-i2svg=""><path fill="currentColor" d="M192 312C192 298.8 202.8 288 216 288H384V160H256c-17.67 0-32-14.33-32-32L224 0H48C21.49 0 0 21.49 0 48v416C0 490.5 21.49 512 48 512h288c26.51 0 48-21.49 48-48v-128H216C202.8 336 192 325.3 192 312zM256 0v128h128L256 0zM568.1 295l-80-80c-9.375-9.375-24.56-9.375-33.94 0s-9.375 24.56 0 33.94L494.1 288H384v48h110.1l-39.03 39.03C450.3 379.7 448 385.8 448 392s2.344 12.28 7.031 16.97c9.375 9.375 24.56 9.375 33.94 0l80-80C578.3 319.6 578.3 304.4 568.1 295z"></path></svg>엑셀로 내보내기</button>
	    <!-- 검색창 -->
	    <div class="search-box">
	      <form class="position-relative" data-bs-toggle="search" data-bs-display="static">
	        <input class="form-control search-input search" type="search" placeholder="Search members" aria-label="Search">
	        <span class="fas fa-search search-box-icon"></span>
	      </form>
	    </div>
	    <div class="d-flex justify-content-center">
	    	<button class="btn btn-info me-1 mb-1" type="button" id="treeButton">조직도</button>
		</div>	  
	  </div>
	</div>
	
	<div class="table-responsive"> <!-- 클래스 지정 -->
	<table class="table table-hover" style="vertical-align: middle;">
	  <thead>
	    <tr>
	      <th scope="col"></th>
	      <th scope="col">부서</th>
	      <th scope="col">직급</th>
	      <th scope="col">이름</th>
	      <th scope="col">메일주소</th>
	      <th scope="col">연락처</th>
	    </tr>
	  </thead>
	  <tbody class="list"> <!-- 클래스 지정, td에 class 지정(valueNames로) -->
	  	<c:if test="${empty empList}">
	  	  <tr style="text-align: center;"><td colspan="6">직원이 존재하지 않습니다.</tr>
	  	</c:if>
	  	<c:if test="${!empty empList }">
	  	<c:forEach items="${empList }" var="emp">
		    <tr class="hover-actions-trigger btn-reveal-trigger position-static">
		      <td class="col-1"></td>
		      <td class="dept col-2">${emp.deptVO.deptName }</td>
		      <td class="rank col-2">${emp.codeVO.cdName }</td>
		      <td class="name col-2">
		      	<div class="font-sans-serif btn-reveal-trigger position-static">
		      	<span>${emp.empName }</span>
	              <button class="btn btn-sm dropdown-toggle dropdown-caret-none transition-none btn-reveal fs--2" type="button" data-bs-toggle="dropdown" data-boundary="window" aria-haspopup="true" aria-expanded="false" data-bs-reference="parent"><span class="far fa-comment-alt"></span></button>
	              <div class="dropdown-menu dropdown-menu-end py-2">
	              	<a class="dropdown-item" href="/sendmail.do?mailrEmpno=${emp.empNo }">내부메일보내기</a>
	              	<a class="dropdown-item" href="#!"onclick="aClick3('${emp.empNo}')">채팅하기</a>
<!-- 	                <div class="dropdown-divider"></div><a class="dropdown-item text-danger" href="#!">Remove</a> -->
	              </div>
	            </div>
		      </td>	
		      <td class="mail col-3">${emp.empEmail }</td>
		      <td class="hp col-2">${emp.empHp }</td>
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

<!-- 조직도 모달창 시작 -->
<div class="modal fade" id="treeModal" tabindex="-1" style="display: none;" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">조직도</h5>
      	<input class="form-control" style="width:200px;" id="search_input" type="search" placeholder="Search..." aria-label="Search">
<!--         <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" data-fa-i2svg=""><path fill="currentColor" d="M310.6 361.4c12.5 12.5 12.5 32.75 0 45.25C304.4 412.9 296.2 416 288 416s-16.38-3.125-22.62-9.375L160 301.3L54.63 406.6C48.38 412.9 40.19 416 32 416S15.63 412.9 9.375 406.6c-12.5-12.5-12.5-32.75 0-45.25l105.4-105.4L9.375 150.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 210.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0s12.5 32.75 0 45.25l-105.4 105.4L310.6 361.4z"></path></svg><span class="fas fa-times fs--1"></span> Font Awesome fontawesome.com</button> -->
      </div>
      <div class="modal-body" id="modal-tree">
      	<div class="d-flex justify-content-end">
	      	<button class="btn btn-soft-info me-1 mb-1 setAll" type="button" data-value="openStatus">전체열기/닫기</button>
<!-- 	      	<button class="btn btn-soft-info me-1 mb-1 setAll" type="button" data-value="checkStatus">전체선택/해제</button> -->
        </div>
        <hr>
        <p class="text-700 lh-lg mb-0">
        	<!-- 조직도 들어가는 곳 -->
        </p>
      </div>
<!--       <div class="modal-footer"> -->
<!--         <button class="btn btn-info me-1 mb-1" type="button" id="selectTree">선택</button> -->
<!--         <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button> -->
<!--       </div> -->
    </div>
  </div>
</div>
<!-- 조직도 모달창 끝 -->

<script type="text/javascript">

/////////////// 조직도 ///////////////
let treeContent;
let select; // 선택된 사람들이 객체로 들어있음
let modal;
let openFlag = false;
let checkFlag = false;

function aClick3(empNo) {
	
	console.log("aClick3->empNo : " + empNo);
	document.getElementById("chatIcon").click();


	updateChatWindow3(empNo);
};

function updateChatWindow3(empNo) {
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

$("#treeButton").on("click", function(){
	treeContent = $("#modal-tree > p");
	treeContent.jstree({
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
        "conditionalselect" : function (node, event) {
            return false;
        },
		"plugins" : ["search", "types", "state", "changed", "conditionalselect"]
	});
	
	treeContent.bind("loaded.jstree", function(e, data) {
		console.log("트리 로딩 완료");
		var model = treeContent.jstree(true)._model.data;
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
							treeContent.jstree(true).create_node(idata.id, result[i], "last", function(){
								console.log("노드 생성 성공");
							});
						}
					}
				}
			});
		});
	}.bind(this));
	
	// 해당 id의 노드를 open 상태로 바꿉니다.
	treeContent.on("ready.jstree", function(){
		$(this).jstree("open_node", "#"); // 이 경우 id가 1번인 root노드를 열린 상태로 로드함
	});
	
	treeContent.on("changed.jstree", function (e, data) {
	    console.log("changed id : " + data.node.id);
	    console.log("changed node childeren : " + data.node.children);

// 	    if(data.node.children.length == 0){
// 			$.ajax({
// 				type: "get",
// 				url: "/deptemp.do?deptCd=" + data.node.id,
// 				dataType : "json",
// 				success: function(result){
// 					if(result != null && result.length != 0){
// 						console.log("result : " + JSON.stringify(result));
// 						for(var i = 0; i < result.length; i++){
// 							console.log(data.node.id + "에 " + result[i] + " 추가할 것");
// 							treeContent.jstree(true).create_node(data.node.id, result[i], "last", function () {
// 							    // 노드 생성에 성공하면 실행
// 							    treeContent.jstree(true).open_node(data.node.id); // 자식 노드 추가 후 열린 상태로 만듭니다.
// 							});
// 						}
// 					}
// 				}
// 			});
// 		}
	});
	
	treeContent.bind("select_node.jstree", function (e, data) {
		console.log("select id : " + data.node.id);
		console.log("select node childeren : " + data.node.children);
	});

	var to = false;
	$('#search_input').keyup(function () {
	    if(to) { clearTimeout(to); } // to 변수가 false가 아니면 (즉, 어떠한 값이든 가지고 있으면) if 조건은 참으로 평가
	    to = setTimeout(function () {
	      var v = $('#search_input').val();
	      treeContent.jstree(true).search(v);
	    }, 250);
	});
	
	modal = new window.bootstrap.Modal(treeModal);
	modal.show();
});

$("#selectTree").on("click", function(){
	select = treeContent.jstree('get_selected',true);
	console.log(select); // 선택된 사람들 리스트
	console.log("선택된 사람[0] 아이디 : " + select[0].id);
	console.log("선택된 사람[0] 이름 : " + select[0].text);

	modal.hide();
});

$(".setAll").on("click", function(){
	var value = $(this).data("value"); // data-value 값을 가져옵니다.
	console.log(value);
	if(value == "openStatus"){
		if(!openFlag){
			openFlag = true;
			treeContent.jstree("open_all");
		}else{
			openFlag = false;
			treeContent.jstree("close_all");
		}
	}
	if(value == "checkStatus"){
		if(!checkFlag){
			checkFlag = true;
			treeContent.jstree("check_all");
		}else{
			checkFlag = false;
			treeContent.jstree("uncheck_all");
		}
	}	
});
/////////////// 조직도 ///////////////

</script>