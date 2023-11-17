<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내업무현황</title>
</head>

<!-- jstree cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<body>

<sec:authentication property='principal.emp.empNo' var="empNo"/>

	<div class="container">
		<h2><a href="/task.do">내업무현황</a> > <a href="/taskdetail.do?taskCd=${taskVO.taskCd }">업무상세</a> > 업무수정</h2>

		<br>
		<br>
		<!-- 		<div class="form-floating mb-3">
			<input class="form-control" id="floatingInput" type="email"
				placeholder="name@example.com" /> <label for="floatingInput">프로젝트명</label>
		</div> -->

<%-- 		<form:form modelAttribute="taskVO" method="post" action="/taskinsert.do" > --%>
		<form id="taskform" method="post" name="testForm" action="/updatetask.do?taskCd=${taskVO.taskCd }" onsubmit='return formSubmit()'>
			<div class="col-12 col-xl-4 container-small">
				<div class="row g-2">
					<div class="col-12 col-xl-12">
						<div class="card mb-3">
							<div class="card-body">
<!-- 								<h3 class="card-title mb-4">업무 수정</h3> -->
								
								
								<div class="row gx-3">
									<div class="col-12 col-sm-6 col-xl-12">
										<div class="mb-4">
											<div class="d-flex flex-wrap mb-2">
												<h5 class="mb-0 text-1000 me-2">*프로젝트명</h5>
											</div>
											 <input class="form-control mb-xl-3" type="text"  placeholder="프로젝트명" id="taskTitle" name="taskTitle" value="${taskVO.taskTitle}" />
											<c:if test="${empty error['taskTitle']}">
											  <form:errors path="taskTitle" cssClass="error" />
											</c:if>
										</div>
									</div>

									<c:set var="startdate" value="${taskVO.taskStartdate}"/> 
									<c:set var="enddate" value="${taskVO.taskEnddate}"/> 
									<div class="col-12 col-sm-6 col-xl-12">
										<div class="mb-4">
											<h5 class="mb-2 text-1000">*프로젝트 시작~종료 일자</h5>
											<div class="float">
												<div class="d-flex align-items-center">
													<div class="form-group row align-middle">
														<div class="col">
															<input class="form-control" id="basic-form-dob" type="date" name="taskStartdate" value="${fn:substring(startdate,0,10)}"/>
														</div>
														<div class="col text-center align-self-center">~</div>
														<div class="col">
															<input class="form-control" id="basic-form-dob" type="date" name="taskEnddate" value="${fn:substring(enddate,0,10)}" />
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div class="col-12 col-sm-6 col-xl-12">
										<div class="mb-4">
											<h5 class="mb-2 text-1000">업무 유형</h5>
											<input class="form-control mb-xl-3" type="text" placeholder="업무 유형" name="taskType" value="${taskVO.taskType }"/>
										</div>
									</div>

									<div class="col-12 col-sm-6 col-xl-12">
										<div class="mb-4">
											<h5 class="mb-2 text-1000">프로젝트 내용</h5>
  											<textarea class="form-control" id="exampleTextarea" rows="3" name="taskContent" placeholder="프로젝트 내용">${taskVO.taskContent }</textarea>
										</div>
									</div>

									<div class="col-12 col-sm-6 col-xl-12">
										<div class="mb-4">
											<h5 class="mb-2 text-1000">비고</h5>
											<textarea class="form-control" id="exampleTextarea" rows="3" name="taskMemo" placeholder="비고">${taskVO.taskMemo }</textarea>
										</div>
									</div>

									<!-- 주소록 완성되면 진행 -->
									<div class="col-12 col-sm-6 col-xl-12">
									    <div class="mb-4">
									        <h5 class="mb-2 text-1000">팀원 추가</h5>
											<div class="input-group mb-1">
												<span class="input-group-text" id="teamEmpBtn" style="cursor: pointer;">팀원 추가</span>
												<div class="form-control" type="text" id="teamEmpPlace" data-empno="${empNo }">
													<!-- 팀원 들어가는 곳 -->
												</div>
											</div>
									    </div>
									</div>

									<!-- 세부업무에 등록되지 않은 팀원만 노출 -->
<%-- 									<div class="float">
										<div class="mb-4">
									        <h5 class="mb-2 text-1000">팀원 삭제</h5>
									    <p style="font-size: 12px; color: red;">세부업무 담당자로 지정된 팀원은 삭제하실 수 없어 노출되지 않습니다.</p>
									    </div>
										<div class="d-flex align-items-center">
											<div class="form-group row align-middle">
												<div class="col position-relative">
													<c:forEach items="${noTdEmpList }" var="teamEmp">
														<div class="avatar avatar-xl me-4" data-empNo="${teamEmp.empNo}">
															<img class="rounded-circle" src="${pageContext.request.contextPath }/resources/assets/gw/profile/${teamEmp.empPhoto}" alt="" />
															<button id="" style="margin-left: 20px; margin-top: -20px;" class="btn btn-link text-danger position-absolute" onclick="deleteImage(this)">x</button>
															
														</div>
													</c:forEach>
												</div>
											</div>
										</div>
									</div> --%>



									<div class="float">
										<div class="mb-4">
									        <h5 class="mb-2 text-1000">팀원 삭제</h5>
									    <p style="font-size: 12px; color: red;">세부업무 담당자로 지정된 팀원은 삭제하실 수 없습니다.</p>
									    </div>
										<div class="d-flex align-items-center">
											<div class="form-group row align-middle">
												<div class="col position-relative" id="teamEmpList">
													<c:forEach items="${TdSepEmpList }" var="tdSepEmp">
														<div class="avatar avatar-xl me-4"   data-empNo="${tdSepEmp.empNo}">
															<img class="rounded-circle" data-bs-toggle="tooltip" data-bs-placement="top" title="${tdSepEmp.empName }(${tdSepEmp.empNo })" src="${pageContext.request.contextPath }${tdSepEmp.empPhoto}" alt="" />
<!-- 															<button id="" style="margin-left: 20px; margin-top: -20px;" class="btn btn-link text-danger position-absolute">x</button> -->
<%-- 																								<input type="text" value="${teamEmp.empNo }"> --%>
															<c:if test="${tdSepEmp.statusEmp eq 2}">
																<button id="" style="margin-left: 20px; margin-top: -20px;" class="btn btn-link text-danger position-absolute" onclick="deleteImage(this)">x</button>
															</c:if>
<%-- 															<input type="hidden" name="employeeNumber" value="${teamEmp.empNo}" /> --%>
<%-- 															<input type="text" name="teamEmp" value="${tdSepEmp.empNo}" /> --%>
<%-- 														<span>${tdSepEmp.statusEmp }</span> --%>
<%-- 														<span>${tdSepEmp.empNo }</span> --%>
<!-- 															<input type="text" name="teamEmp" value=""> -->
														</div>
													</c:forEach>
<%-- 															<input type="text" name="teamEmp" value="${TdSepEmpList.empNo}" /> --%>
													<input type="hidden" id="deletedTeamMembers" name="delEmpList" value="" />

												</div>
											</div>
										</div>
									</div>

									

									<!-- <button class="btn btn-soft-info me-1 mb-1 container-small" type="button" style="width:70px;">등록</button> -->
									<button class="btn btn-outline-info me-1 mb-1 container-small" type="submit" style="width:70px;">수정</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
<%-- <sec:csrfInput/> --%>
		</form>

	</div>

<!-- 팀원 추가 모달(조직도) 시작 -->
<div class="modal fade" id="teamEmpModal" tabindex="-1" style="display: none;" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">조직도</h5>
        <div>
	      	<button class="btn btn-soft-info me-1 mb-1 teamEmp_setAll" type="button" data-value="openStatus">전체열기/닫기</button>
	      	<button class="btn btn-soft-info me-1 mb-1 teamEmp_setAll" type="button" data-value="checkStatus">전체선택/해제</button>
<!--         <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" data-fa-i2svg=""><path fill="currentColor" d="M310.6 361.4c12.5 12.5 12.5 32.75 0 45.25C304.4 412.9 296.2 416 288 416s-16.38-3.125-22.62-9.375L160 301.3L54.63 406.6C48.38 412.9 40.19 416 32 416S15.63 412.9 9.375 406.6c-12.5-12.5-12.5-32.75 0-45.25l105.4-105.4L9.375 150.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 210.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0s12.5 32.75 0 45.25l-105.4 105.4L310.6 361.4z"></path></svg><span class="fas fa-times fs--1"></span> Font Awesome fontawesome.com</button> -->
      	</div>
      </div>
      <div class="modal-body">
        <div class="d-flex justify-content-end">
	      	<input class="form-control" style="width:250px;" id="teamEmp_search_input" type="search" placeholder="Search..." aria-label="Search">
        </div>
        <hr>
        <p class="text-700 lh-lg mb-0">
        	<!-- 조직도 들어가는 곳 -->
        </p>
      </div>
      <div class="modal-footer">
      	<button class="btn btn-info me-1 mb-1" type="button" id="teamEmp_selectTree">선택</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 팀원 추가 모달(조직도) 끝 -->

</body>
<script type="text/javascript">
function formSubmit() { //submit버튼인 [전송]버튼을 클릭하면 실행된다.
	if (!document.testForm.taskTitle.value) {
		//폼의 엘리먼트중 name이 'title'인 객체에 값이 입력되어 있지 않으면 실행
		alert("제목을 입력하세요"); //메시지 표시
		//문제가 발생한 객체인 'title'에 포커스를 설정=>쉽게 수정할 수 있도록 배려
		document.testForm.taskTitle.focus();
		return false; //문제가 발생시 formTest7()함수는 여기서 끝냄. 이벤트가 발생한 곳으로 복귀
	} else if(!document.testForm.taskStartdate.value){
		alert("시작날짜를 입력하세요"); 
		document.testForm.taskStartdate.focus();
		return false;
	} else if(!document.testForm.taskEnddate.value){
		alert("종료날짜를 입력하세요");
		document.testForm.taskEnddate.focus();
		return false;
	} else if(!document.testForm.taskContent.value){
		alert("업무내용를 입력하세요");
		document.testForm.taskContent.focus();
		return false;
	}
}

function setMinimumTaskEndDate() {
  // 현재 날짜 가져오기
  var today = new Date();
  var dd = String(today.getDate()).padStart(2, '0');
  var mm = String(today.getMonth() + 1).padStart(2, '0');
  var yyyy = today.getFullYear();

  today = yyyy + '-' + mm + '-' + dd;

  // taskenddate 입력 필드 가져오기
  var taskEnddateInput = document.querySelector('input[name="taskEnddate"]');

  // taskenddate 입력 필드의 최소 날짜를 오늘로 설정
  taskEnddateInput.min = today;
}

// 페이지 로드 시 함수 실행
window.addEventListener('load', setMinimumTaskEndDate);
  
// 페이지 로드 시 실행되는 함수
window.addEventListener('load', function() {
  // taskStartdate와 taskEnddate 입력 필드 가져오기
  var taskStartdateInput = document.querySelector('input[name="taskStartdate"]');
  var taskEnddateInput = document.querySelector('input[name="taskEnddate"]');
  
  // 입력 필드 값이 변경될 때마다 검증 함수 호출
  taskStartdateInput.addEventListener('change', validateDates);
  taskEnddateInput.addEventListener('change', validateDates);
  
  // 초기 검증 실행
  validateDates();
  
  // 날짜 검증 함수
  function validateDates() {
    var startDate = new Date(taskStartdateInput.value);
    var endDate = new Date(taskEnddateInput.value);
    
    // enddate가 startdate보다 작으면 경고 표시
    if (endDate < startDate) {
      alert('종료일은 시작일과 같거나 커야합니다.');
      taskEnddateInput.value = taskStartdateInput.value;
    }
  }
});

// 이미지 x버튼 클릭시 이미지를 없애는 함수
function deleteImage(buttonElement) {
    var parentDiv = buttonElement.parentElement;
    var empNo = parentDiv.getAttribute('data-empNo');

    if (parentDiv) {
        parentDiv.remove();

        // 숨겨진(input) 입력 필드를 가져옵니다.
        var deletedTeamMembersInput = document.getElementById('deletedTeamMembers');

        // 입력 필드의 현재 값을 가져와서 empNo를 추가합니다.
        var currentDeletedTeamMembers = deletedTeamMembersInput.value;
        if (currentDeletedTeamMembers === "") {
            deletedTeamMembersInput.value = empNo;
        } else {
            deletedTeamMembersInput.value = currentDeletedTeamMembers + "," + empNo;
        }
    }
}

//팀원을 삭제하는 함수
function deleteTeamMember(deleteButton) {
    var teamMemberDiv = deleteButton.parentElement;
    var teamMemberInput = teamMemberDiv.querySelector('input[type="text"]');

    
    if (teamMemberInput) {
        // 해당 팀원의 input 필드를 삭제
        teamMemberInput.remove();
    }

    // 해당 팀원의 div를 삭제
    teamMemberDiv.remove();
}

//////////////////팀원 추가 조직도 시작 //////////////////
let teamEmp_treeContent;
let teamEmp_select; // 선택된 사람들이 객체로 들어있음
let teamEmp_modal;
let teamEmp_openFlag = false;
let teamEmp_checkFlag = false;

$("#teamEmpBtn").on("click", function(){
	teamEmp_treeContent = $("#teamEmpModal .modal-body > p");
	teamEmp_treeContent.jstree({
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
	
	teamEmp_treeContent.bind("loaded.jstree", function(e, data) {
		console.log("트리 로딩 완료");
		var model = teamEmp_treeContent.jstree(true)._model.data;
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
							teamEmp_treeContent.jstree(true).create_node(idata.id, result[i], "last", function(){
								console.log("노드 생성 성공");
							});
						}
					}
				}
			});
		});
	}.bind(this));
	
	// 해당 id의 노드를 open 상태로 바꿉니다.
	teamEmp_treeContent.on("ready.jstree", function(){
		$(this).jstree("open_node", "#"); // 이 경우 id가 1번인 root노드를 열린 상태로 로드함
	});
	
	teamEmp_treeContent.on("changed.jstree", function (e, data) {
	    console.log("changed id : " + data.node.id);
	    console.log("changed node childeren : " + data.node.children);
	});
	
	teamEmp_treeContent.bind("select_node.jstree", function (e, data) {
		console.log("select id : " + data.node.id);
		console.log("select node childeren : " + data.node.children);
	});

  	var to = false;
  	$('#teamEmp_search_input').keyup(function () {
  	    if(to) { clearTimeout(to); }
  	    to = setTimeout(function () {
  	      var v = $('#teamEmp_search_input').val();
  	      teamEmp_treeContent.jstree(true).search(v);
  	    }, 250);
  	});
	  	
  	teamEmp_modal = new window.bootstrap.Modal(teamEmpModal);
  	teamEmp_modal.show();
});

$("#teamEmp_selectTree").on("click", function(){
	teamEmp_select = teamEmp_treeContent.jstree('get_selected',true);
	console.log(teamEmp_select); // 선택된 사람들 리스트
//  	console.log("선택된 사람[0] 아이디 : " + teamEmp_select[0].id);
//  	console.log("선택된 사람[0] 이름 : " + teamEmp_select[0].text);
//  	console.log("선택된 사람[0] 부서 : " + teamEmp_select[0].original.deptVO);
	
	$("#teamEmpPlace").text(""); // 페이지의 참조자 지워주고
	
	let cnt = 0;
	for(var i = 0; i < teamEmp_select.length; i++){
		var isMe = false;
		if(teamEmp_select[i].id == $("#teamEmpPlace").data("empno")){ // 본인을 팀원으로 선택하면
			var isMe = true;
		}
		if(isMe){
			cnt++;
			continue;
		}
		var isDuplicate = false;
		$("#teamEmpList div").each(function(){ // 이미 등록되어 있는 팀원을 선택하면
			console.log($(this).data("empno"));
			if($(this).data("empno") == teamEmp_select[i].id){
				isDuplicate = true;
			}
		});
		if(isDuplicate){
			cnt++;
			continue;
		}
		if(teamEmp_select[i].original.deptVO != null){ // 팀 제외한 직원만 추가
			$("#teamEmpPlace").append(`<span class="btn btn-sm btn-phoenix-secondary rounded-pill me-1 mb-1">`+teamEmp_select[i].text+`/`+teamEmp_select[i].original.deptVO.text+`</span>`);
			$("#teamEmpPlace").append(`<input type="hidden" name="teamEmpList" value="`+teamEmp_select[i].id+`">`);
		}
	}
	if(cnt != 0){
		alert("이미 등록되어있는 팀원을 제외하고 추가합니다.");
	}

	teamEmp_modal.hide();
});

$(".teamEmp_setAll").on("click", function(){
	var value = $(this).data("value"); // data-value 값을 가져옵니다.
	console.log(value);
	if(value == "openStatus"){
		if(!teamEmp_openFlag){
			teamEmp_openFlag = true;
			teamEmp_treeContent.jstree("open_all");
		}else{
			teamEmp_openFlag = false;
			teamEmp_treeContent.jstree("close_all");
		}
	}
	if(value == "checkStatus"){
		if(!teamEmp_checkFlag){
			teamEmp_checkFlag = true;
			teamEmp_treeContent.jstree("check_all");
		}else{
			teamEmp_checkFlag = false;
			teamEmp_treeContent.jstree("uncheck_all");
		}
	}	
});
////////////////// 팀원 추가 조직도 끝 ////////////////////

</script>
</html>
