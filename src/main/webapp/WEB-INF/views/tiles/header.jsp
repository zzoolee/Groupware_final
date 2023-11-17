<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
  	.swal2-title {
  	margin:40px 0px 10px 0px;
	font-size:17px;
	}
	
	.swal2-styled {
/* 	padding : 10px 40px 10px 40px; */
/* 	margin : 0px; */
	width : 100px;
	height : 40px;
	}
	
	div:where(.swal2-container) button:where(.swal2-styled).swal2-confirm{
		background-color: #1E90FF; !important
	}
	
	.swal2-confirm {
/* 		padding : 40px; */
		text-align : center;
	}
	.swal2-cancel {
/* 		padding : 40px; */
		text-align : center;
	}
	
	.scrollbar-overlay {
        max-height: 100%; /* 초기 높이 설정 */
        overflow-y: auto; /* 스크롤바 활성화 */
    }
 </style>
 <script>
 
 
 function customConfirm(text) {
	    return new Promise((resolve, reject) => {
	        Swal.fire({
	            text: text,
	            icon: 'warning',
	            showCancelButton: true,
	            confirmButtonColor: '#1E90FF',
	            cancelButtonColor: '#A52A2A',
	            confirmButtonText: '확인',
	            cancelButtonText: '취소'
	        }).then((result) => {
	            if (result.isConfirmed) {
	                resolve(true); // 사용자가 "YES"를 클릭한 경우
	            } else {
	                resolve(false); // 사용자가 "NO"를 클릭한 경우 또는 창을 닫은 경우
	            }
	        });
	    });
	}
 
 
  async function alert(msg) {
       try
       {
             if(!$(Swal.getTitle()).html()) {
                   sourcePlayground_Cnt = 0;
             }

             if(typeof sourcePlayground_Cnt !== "undefined" && sourcePlayground_Cnt > 0) {  //이미 실행중인 경우
                   if(sourcePlayground_Cnt == 1) {
                         msg = "<span style='font-weight:normal'>("+sourcePlayground_Cnt+")</span> " + $(Swal.getTitle()).html() + "<Br>" + "<span style='font-weight:normal'>("+(sourcePlayground_Cnt+1)+")</span> " + "<h3>"+msg+"</h3>";
                   }
                   else {
                         msg = $(Swal.getTitle()).html() + "<Br>" + "<span style='font-weight:normal'>("+(sourcePlayground_Cnt+1)+")</span> " + "<h3>"+msg+"</h3>";
                   }
                   sourcePlayground_Cnt++;
             }
             else {
                   sourcePlayground_Cnt = 1;
             }

             await Swal.fire({
                   "title": msg, 
                   "returnFocus": false,
                   didOpen: () => {
                         window.localStorage.setItem("sourceplaygroumd_myfocusobj", document.activeElement.id)
                   },
                   willClose: () => {
                         var myfocusobj = window.localStorage.getItem("sourceplaygroumd_myfocusobj");
                         if(myfocusobj && myfocusobj != null) {
                               document.getElementById(myfocusobj).focus();
                         }
                   }
            });
            sourcePlayground_Cnt--;
       }
       catch (e)
       {
             try
             {
                   Swal.isVisible(); 
             }
             catch (e_inner)
             {
                   sourcePlayground_Cnt = 0;
                   setTimeout(function(){alert(msg);}, 500);
             } 
       }
 }
  
  
</script>
      <nav class="navbar navbar-top fixed-top navbar-expand <sec:authorize access="hasRole('ROLE_ADMIN')">navbar-darker</sec:authorize>" id="navbarDefault">
        <div class="collapse navbar-collapse justify-content-between">
          <div class="navbar-logo">
          	<sec:authorize access="hasRole('ROLE_ADMIN')">
            <a class="navbar-brand me-1 me-sm-3" href="/adminmain.do">
          	</sec:authorize>
          	<sec:authorize access="hasRole('ROLE_MEMBER')">
            <a class="navbar-brand me-1 me-sm-3" href="/">
          	</sec:authorize>
                <div class="d-flex align-items-center">
                  <img src="${pageContext.request.contextPath }/resources/assets/gw/IW_Logo.png" alt="i-works" width="27" />
                  <p class="logo-text ms-2 d-none d-sm-block">I-WORKS</p>
                </div>
            </a>
            <sec:authorize access="hasRole('ROLE_ADMIN')">
            	<label class="text-gradient-info me-3" style="font-size:24px;"><strong>[관리자모드]</strong></label>
          	</sec:authorize>
          </div>
          <!-- 실시간알림 멘트 출력 자리 -->
     	  <div class="alert alert-soft-primary alert-dismissible fade show text-center mt-2 notifyDiv" role="alert" style="width: 30rem; position: fixed; top: 3%; left: 50%; transform: translate(-50%, -50%); z-index: 9999; font-size:15px; display:none;">
<!--           	<button class="btn-close" type="button" data-bs-dismiss="alert" aria-label="Close"></button> -->
          </div>
          <!-- 실시간알림 멘트 출력 자리 끝 -->
          <ul class="navbar-nav navbar-nav-icons flex-row align-items-center">
          	<sec:authentication property="principal.emp.empName" var="name"/>
          	<sec:authorize access="hasRole('ROLE_MEMBER')">
          		<li><label class="text-gradient-info me-3" style="font-size:18px;"><strong>${name }님</strong> 오늘도 좋은하루 되세요!</label></li>
		 	</sec:authorize>
		 	<li class="nav-item dropdown">
              <a class="nav-link" href="/logout" style="min-width: 2.5rem" role="button" aria-haspopup="true" aria-expanded="false" data-bs-auto-close="outside"><span class="uil uil-signout fs-2"></span></a></li>
            <li class="nav-item dropdown">
              <a class="nav-link notiList" href="#" style="min-width: 2.5rem" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" data-bs-auto-close="outside"><span class="uil uil-bell fs-2"></span><span class="position-absolute start-10 translate-middle badge rounded-pill bg-primary-500 notiCnt"></span></a>
				&nbsp;&nbsp;&nbsp;&nbsp;
               <div class="dropdown-menu dropdown-menu-end notification-dropdown-menu py-0 shadow border border-300 navbar-dropdown-caret" id="navbarDropdownNotfication" aria-labelledby="navbarDropdownNotfication">
                <div class="card position-relative border-0">
                  <div class="card-header p-2">
                    <div class="d-flex justify-content-between">
                      <h5 class="text-black mb-0">알림 확인</h5>
                      <button class="btn btn-link p-0 fs--1 fw-normal" type="button" id="allCheckBtn">전부 읽음 처리</button>
                    </div>
                  </div>
                  <div class="card-body p-0">
                    <div class="scrollbar-overlay" id="notiListdiv" style="height: 100%;">
							<!-- ajax로 db조회 알림 리스트 띄어주는 자리 -->
                    </div>
                  </div>
                </div>
              </div>
            </li>
            <li>
            <sec:authorize access="hasRole('ROLE_MEMBER')">
            <a class="nav-link lh-1 pe-0" id="navbarDropdownUser" href="/myinfo.do" role="button" data-bs-auto-close="outside" aria-haspopup="true" aria-expanded="false">
                <div class="avatar avatar-l">
           			<img class="rounded-circle " id="empPhoto" src="" alt="empPhoto"/>
                </div>
            </a>
            </sec:authorize>
            <sec:authorize access="hasRole('ROLE_ADMIN')">
            	<div class="avatar avatar-l">
           			<img class="rounded-circle " id="empPhoto" src="" alt="empPhoto"/>
                </div>
            </sec:authorize>
            </li>
          </ul>
        </div>
      </nav>
      <!--알림을 보낼 타입  확인  -->
      <div id="redirectMessage" style="display:none;">${redirectMessage }</div>
      <!-- 결재 시 참조자가 있을 경우 -->
      <div id="authNoti">${authNoti }</div>
      <!-- 참조자 정보 -->
      <div id="refNoti">${refNoti }</div>
      <!-- 업무 리스트 -->
      <div id="taskempList" style="display:none;">${taskempList }</div>
<script>

// var hostSocketUrl = window.location.host;

var ws; 
// var chatSocket = new WebSocket("ws://"+ hostSocketUrl +"/chat");
var chatSocket = new WebSocket("ws://192.168.144.40/chat");

chatSocket.onopen = function (event) {
    console.log("WebSocket 연결완료.");
};

chatSocket.onerror = function (event) {
    console.error("WebSocket 오류 발생: " + event);
    
};

// 웹 소켓 연결이 닫혔을 때 호출되는 함수
chatSocket.onclose = function (event) {
    if (event.wasClean) {
        console.log("WebSocket 연결이 정상적으로 닫혔습니다.");
    } else {
        console.error("WebSocket 연결이 오류로 인해 닫혔습니다.");
    }
};

// 페이지를 닫을 때 웹 소켓 연결을 닫음
window.onbeforeunload = function () {
	chatSocket.close();
};

$(function(){
	var allCheckBtn = $("#allCheckBtn");
	
	console.log("여기는 헤더!");
	
	//회원정보 가져오기
	$.ajax({
		url:"/forHeader",
		type:"post",
		dataType:"json",
		success:function(rslt){
			console.log("rslt : " + JSON.stringify(rslt));
			
// 			if(rslt.empName == '관리자'){
				
// 				$("#empPhoto").attr("src","/resources/assets/gw/IW_Logo.png");
// 			}else{
				
				$("#empPhoto").attr("src",rslt.empPhoto);
				$("#dropDownEmpName").html(rslt.empName);
// 			}
			
		}
	});
	

	
//  	ws = new WebSocket("ws://"+ hostSocketUrl +"/alarm");
 	ws = new WebSocket("ws://192.168.144.40/alarm");
	
	// 세션 연결	
	connection();
	// 로그인 되자마자 미확인 알림 갯수 가져오기 
	notiSelectCnt();
	
	// 알림 드롭다운박스 사이즈 조절
	setNotiDropdownHeight();
	
	// 벨 이미지 클릭 시 알림 리스트 가져오기 
	$(".notiList").on("click",function(){
		
		$.ajax({
			type : "post",
			url : "/selectNotifyList.do",
			success : function(res){
				console.log("리스트 가져오는지 확인",res);
				
				var divHtml =""
				
				if(!res.length) {
					divHtml +=`
						<div class="border-300">
                        <div class="px-2 px-sm-3 py-3 border-300 notification-card position-relative read border-bottom">
                          <div class="d-flex align-items-center justify-content-between position-relative">
                            <div class="d-flex">
                              <div class="flex-1 me-sm-3">
                                <h4 class="fs--1 text-1000 mb-2 mb-sm-3 fw-bold">미확인 알림이 없습니다.</h4>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
					`;
				}else{
					for(var i=0; i<res.length; i++){
						var notiList = res[i];
						var notiDate = moment(notiList.notifyDate).format("yyyy-MM-D");
						divHtml +=`
							<div class="border-300" data-value="\${notiList.notifyCd}" onclick="updateNotiCkse(\${notiList.notifyCd})">
	                        <div class="px-2 px-sm-3 py-3 border-300 notification-card position-relative read border-bottom">
	                          <div class="d-flex align-items-center justify-content-between position-relative">
	                            <div class="d-flex">
	                              <div class="flex-1 me-sm-3">
	                                <h4 class="fs--1 text-1000 mb-2 mb-sm-3 fw-bold">\${notiList.notifyContent}</h4>
	                                <p class="text-800 fs--1 mb-0"><span class="me-1 fas fa-clock"></span><span class="fw-normal">\${notiDate}</span></p>
	                              </div>
	                            </div>
	                          </div>
	                        </div>
	                      </div>
	                      `;
					}
				}
				$("#notiListdiv").html(divHtml);
			}
		})
		
	});
	
	// 알림 전체 확인 버튼 클릿 시 알림 상태값 전체 변경
	allCheckBtn.on("click", function(){
		
			$.ajax({
				type : "post",
				url : "/notiAllCheck.do",
				success: function(res){
					var divHtml =""
					console.log(res)
					// 업데이트 성공시 
					if(res > 0){
						divHtml +=`
							<div class="border-300">
	                        <div class="px-2 px-sm-3 py-3 border-300 notification-card position-relative read border-bottom">
	                          <div class="d-flex align-items-center justify-content-between position-relative">
	                            <div class="d-flex">
	                              <div class="flex-1 me-sm-3">
	                                <h4 class="fs--1 text-1000 mb-2 mb-sm-3 fw-bold">미확인 알림이 없습니다.</h4>
	                              </div>
	                            </div>
	                          </div>
	                        </div>
	                      </div>
						`;
						
					}
					$("#notiListdiv").html("");
					$("#notiListdiv").html(divHtml);
					// 알람 아이콘 위 숫자 없애기 
					$(".notiCnt").text("");
				}
			});
	});

});

function connection(){
	
	ws.onopen = function(){
		
		console.log("connection 실행 확인, connection open!");
		// 일정
		var redirectMessage = $("#redirectMessage").text();
		// 결재
		var authNoti = $("#authNoti").text();
		// 참조
		var refNoti = $("#refNoti").text();
		// 업무 
		var taskempList = $("#taskempList").text();

			
		var msg = "";
		if(redirectMessage != null && redirectMessage.includes("일정")){
			msg = redirectMessage;
			ws.send(msg);
		}else if(authNoti != null && authNoti.includes("결재")) {
			msg = authNoti
			console.log("authNoti : "+authNoti);
			ws.send(msg);
			
			if(refNoti != null && refNoti.includes("참조")) {
				console.log("refNoti : "+refNoti);
				msg = refNoti;
				ws.send(msg);
			}
		}else if(taskempList != null && taskempList.includes("업무")){
			console.log("taskempList : "+ taskempList);
			msg = taskempList;
			ws.send(taskempList);
		}

	};
	// 로그인 상태에서 알림이 오면 보여주는 부분
	ws.onmessage = function(event){
		console.log("핸들러에서 처리한 메세지를 받아주는 부분 실행 ws.onmessage 실행 : ",event.data);
		// 상대방이 이벤트를 발생 시켜 메세지를 발송하면 DB를 조회하여 알림 갯수를 가져온다. 
		notiSelectCnt();
		unreadMailCnt();
		docCnt();
		var notiMsg = event.data;
		notiMsg +=`
			<button class="btn-close" type="button" data-bs-dismiss="alert" aria-label="Close"></button>
		`
		$(".notifyDiv").css("display","block");
		$(".notifyDiv").html(notiMsg);
// 		setTimeout(function(){
// 			$(".notifyDiv").css("display","none");},2000);
	};
	
	ws.onclose = function(event){
		console.log("세션 연결 소실 ...!");
		
	};
	
};
// 알림 갯수 가져오는 함수
function notiSelectCnt(){
	$.ajax({
		type : "post",
		url : "/selecCntNotify.do",
		success : function(res){
			console.log("notifyCnt 확인"+res);
			if(res>0){
				$(".notiCnt").text(res);
			}else{
				$(".notiCnt").text("");
			}
		}
	});
} ;
// 알림 리스트 사이즈 고정 함수
function setNotiDropdownHeight(){
	var height = $(".scrollbar-overlay");
	if(height.scrollHeight > 10) {
		height.style.maxHeight = '300px';
	}
	
};

// 해당 알림 클릭 시 알림상태 확인으로 변경
function updateNotiCkse(notifyCd){
	var data = {
			notifyCd : notifyCd
	};
	
	var thidDiv = $("div[data-value='"+notifyCd+"']");

		$.ajax({
		type : "post",
		url : "/updateNotickse.do",
		data : JSON.stringify(data),
		contentType : "application/json; charset=utf-8",
		success : function(res){
			if(res != 0){
				console.log("res : ", res);
				thidDiv.remove();
				notiSelectCnt();
			}else{
				alert("서버 오류, 다시 시도해주세요!");
			}
		}
	});
}

</script>
      
