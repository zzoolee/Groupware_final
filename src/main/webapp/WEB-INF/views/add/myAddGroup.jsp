<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- jstree cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<h2><a href="/add/myadd.do">즐겨찾는주소록</a> > 그룹관리</h2>
<br>

<!-- 검색창 포함 테이블 -->
<div id="addressTable" data-list='{"valueNames":["group","dept","rank","name","mail","hp"],"page":8,"pagination":true,"filter":{"key":"group"}}'> <!-- 검색, 페이징, 셀렉트 설정 -->
	<div class="row align-items-center justify-content-between g-3 mb-4">
	    <div class="d-flex justify-content-between align-items-center border-0">
	    	<div>
				<button class="btn btn-outline-info me-1 mb-1 dropdown-toggle dropdown-caret-none transition-none btn-reveal" type="button" data-bs-toggle="dropdown" data-boundary="window" aria-haspopup="true" aria-expanded="false" data-bs-reference="parent">
					그룹이동
				</button>
				<div class="dropdown-menu dropdown-menu-end py-2">
					<c:if test="${!empty groupList }">
						<c:forEach items="${groupList }" var="group" varStatus="i">
							<button class="dropdown-item" name="moveGroup" data-grcd="${group.mygrCd }">${group.mygrName }</button> 
<!-- 							<a class="dropdown-item" href="#!">채팅하기</a> -->
						</c:forEach>
					</c:if>
				</div>
		    	<button class="btn btn-info me-1 mb-1" id="myGroupBtn">내그룹관리</button>
	    	</div>
	    	<!-- 검색창 -->
	    	<div class="search-box">
		      <form class="position-relative" data-bs-toggle="search" data-bs-display="static">
		        <input class="form-control search-input search" type="search" placeholder="Search members" aria-label="Search">
		        <span class="fas fa-search search-box-icon"></span>
		      </form>
	    	</div>
		    <!-- selectbox -->
		    <select class="form-select form-select-sm" style="width:200px;" data-list-filter="data-list-filter"> <!-- data-list-filter 적용 -->
		        <option selected="" value="">그룹을 선택해 주세요</option>
		        <c:if test="${!empty groupList }">
				  	<c:forEach items="${groupList }" var="group" varStatus="i">
				  		<option value="${group.mygrName }">${group.mygrName }</option> <!-- 셀렉트 : value에 필터명 -->
				  	</c:forEach>
			  	</c:if>
	      	</select>
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
	      <th scope="col"></th>
	    </tr>
	  </thead>
	  <tbody class="list"> <!-- 클래스 지정, td에 class 지정(valueNames로) -->
	  	<c:if test="${empty memberList}">
	  	  <tr style="text-align: center;"><td colspan="8">추가된 직원이 존재하지 않습니다.</tr>
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
						<input type="hidden" name="mygrCd" value="${mem.mygrCd }" />
				    </td>
				    <td class="group col-2">${mem.mygrName }</td> <!-- 그룹 반복문에서 가져옴 -->
				    <td class="dept col-2">${mem.groupMember[stat2.index].empVO.deptVO.deptName }</td>
				    <td class="rank col-1">${mem.groupMember[stat2.index].empVO.codeVO.cdName }</td>
					<td class="name col-1" data-empno="${mem.groupMember[stat2.index].mygrEmpno }">${mem.groupMember[stat2.index].empVO.empName }</td>
					<td class="mail col-2">${mem.groupMember[stat2.index].empVO.empEmail }</td>
					<td class="hp col-2">${mem.groupMember[stat2.index].empVO.empHp }</td>
					<td class="col-1">
				    	<button class="btn btn-phoenix-info btn-sm" name="myDelButton">해제</button>
					</td>
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

<!-- 그룹이동 모달창 시작 -->
<div class="modal fade" id="moveGroupModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">그룹이동</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0"><span id="moveMember" class="text-info" style="font-weight: bold;"></span>님을</p>
        <p class="text-700 lh-lg mb-0"><span id="moveGroupName" class="text-info" style="font-weight: bold;"></span> 그룹으로 이동하시겠습니까?</p><br>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="button" id="moveConfirmButton">이동</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 그룹이동 모달창 끝 -->

<!-- 내그룹관리 모달창 시작 -->
<div class="modal fade" id="myGroupMngModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">내그룹관리</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <table class="table table-sm" style="vertical-align: middle;">
		  <tbody>
		  	<tr style="text-align:center;">
		  		<td></td>
		  		<td>
			  		<button class="btn btn-info me-1 mb-1" id="addGroupButton"><svg class="svg-inline--fa fa-plus me-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="plus" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg=""><path fill="currentColor" d="M432 256c0 17.69-14.33 32.01-32 32.01H256v144c0 17.69-14.33 31.99-32 31.99s-32-14.3-32-31.99v-144H48c-17.67 0-32-14.32-32-32.01s14.33-31.99 32-31.99H192v-144c0-17.69 14.33-32.01 32-32.01s32 14.32 32 32.01v144h144C417.7 224 432 238.3 432 256z"></path></svg><!-- <span class="fas fa-plus me-2"></span> Font Awesome fontawesome.com -->그룹 추가</button>
		  		</td>
		  	</tr>
		  <c:forEach items="${groupList }" var="group" varStatus="i">
		    <tr style="text-align:center;">
		      <td style="width:200px;">${group.mygrName }</td>
		      <td data-grcd="${group.mygrCd }" data-grname="${group.mygrName }" style="width:200px;">
		      	<c:if test="${group.mygrSe != 'basic'}">
		      	<button class="btn btn-phoenix-secondary btn-sm" name="modifyGroupButton">
			      <svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><!-- <span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com --> 수정
			    </button>
			    <button class="btn btn-phoenix-danger btn-sm" name="deleteGroupButton">
			      <svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --> 삭제
			    </button>
			    </c:if>
		      </td>
		    </tr>
		  </c:forEach>
		  </tbody>
		</table>
  		<div class="d-flex justify-content-center">
  			<div class="mb-4" id="newGroup">
  			<!-- 새로운 그룹 추가 input 들어갈 곳 -->
  			</div>
      	</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="button" id="groupConfirmBtn">저장</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 내그룹관리 모달창 끝 -->

<!-- 내그룹관리 - 수정 모달 시작 -->
<div class="modal fade" id="modifyGroupModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">그룹수정</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
      <p class="text-700 lh-lg mb-0"><span id="existGroupName" class="text-info" style="font-weight: bold;"></span>그룹의</p>
        <p class="text-700 lh-lg mb-0">새로운 그룹명을 입력해주세요</p><br>
        <div class="d-flex justify-content-center">
        	<input class="form-control form-control" style="width:380px;" id="newGrName" type="text"/>
      	</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-phoenix-info btn-sm" id="newGroupConfirmBtn">저장</button>
	    <button class="btn btn-phoenix-secondary btn-sm" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 내그룹관리 - 수정 모달 시작 -->

<script type="text/javascript">

let newGrCd; // 그룹이동시 새로운 그룹 코드
let groupMngModal; // 나의그룹 모달창
let newNameModal; // 나의그룹 모달창 - 그룹수정 모달창

$("button[name='myDelButton']").on("click", function(event){ // 해제 버튼
	var $tr = $(this).closest('tr'); // 클릭한 버튼이 속한 tr 요소를 찾음
    var mygrCd = $tr.find('input[name="mygrCd"]').val();
    var mygrEmpno = $tr.find('.name').data('empno');
    
    var delData = 
   	[
	   	{
	   		"mygrCd" : mygrCd,
	   		"mygrEmpno" : mygrEmpno
	   	}
    ];
    
    $.ajax({
		type: "post",
		url: "/add/delgroupmem.do",
		data: JSON.stringify(delData),
		contentType: "application/json; charset=utf-8",
		success: function(result){
			console.log(result);
			if(result == "SUCCESS"){
				$("#resultModal .modal-title").text("내 주소록에서 해제");
				$("#resultSpace").text("정상적으로 해제되었습니다.");
				new window.bootstrap.Modal(resultModal).show();
			}
		}
	});
});

// 결과 모달 닫힐 때 이벤트 처리 -> 새로고침
resultModal.addEventListener('hide.bs.modal', function (event) {
	location.href="/add/myaddgroup.do";
});

$("button[name='moveGroup']").on("click", function(event){ // 그룹이동 버튼 - 이동할 그룹 선택 버튼
	if($('input[type="checkbox"]:checked').length == 0){
		alert("이동할 직원을 선택해주세요");
		return;
	}
	
	newGrCd = $(this).data("grcd");
	
	$("#moveMember").text(""); // 이동 직원 이름 나타나는 곳 지워준다
	$('input[type="checkbox"]:checked').each(function() {
	    var name = $(this).closest('td').siblings('.name').text();
	    var moveMemberText = $("#moveMember").text();
	    moveMemberText += (name + " ");
	    $("#moveMember").text(moveMemberText); // 이름 나타내기
// 	    $(".modal-body").append(`<input type="hidden" name="mygrEmpno" value="`+$(this).val()+`">`); // 폼에 넣어주기
	});
	
	$("#moveGroupName").text($(this).text() + " ");
	
	moveModal = new window.bootstrap.Modal(moveGroupModal);
	moveModal.show();
});

$("#moveConfirmButton").on("click", function(){ // '그룹이동' 모달 안에 '이동' 버튼(완료)
	var moveData = [];
	$('input[type="checkbox"]:checked').each(function() {
		let obj = new Object();
		obj.mygrEmpno = $(this).val();
		obj.mygrCd = $(this).next("input[name='mygrCd']").val();
		moveData.push(obj);
	});
	console.log("newGrCd : " + newGrCd);
	
	$.ajax({
		type: "post",
		url: "/add/movegroupmem.do?newGrCd="+newGrCd,
		data: JSON.stringify(moveData),
		contentType: "application/json; charset=utf-8",
		success: function(result){
			console.log(result);
			$('input[type="checkbox"]:checked').each(function() {
				$(this).prop('checked', false);
			});
			if(result == "SUCCESS" || result == "HALFSUCCESS"){
				// 기존 모달 내용 바꾸기 -> 바뀐채로 지속되어 문제...
				// 기존 모달 닫고 새로운 모달 열기
				$("#resultModal .modal-title").text("그룹이동");
				$("#resultSpace").text("정상적으로 이동되었습니다.");
				moveModal.hide(); // 닫기 필수
				new window.bootstrap.Modal(resultModal).show();
			}
		}
	});
});

$("#myGroupBtn").on("click", function(){ // 나의그룹 버튼
	$("#newGroup").text(""); // 새로 생성된 인풋창 지워준다
	
	groupMngModal = new window.bootstrap.Modal(myGroupMngModal)
	groupMngModal.show();
});
$("#addGroupButton").on("click", function(){ // '나의그룹' 모달 안에 '그룹 추가' 버튼
	$("#newGroup").append(
		`<input class="form-control form-control" style="width:380px;" name="mygrName" type="text" placeholder="새로운 그룹명을 입력해주세요"/>`
	);
});
$("#groupConfirmBtn").on("click", function(){ // '나의그룹' 모달 안에 '저장' 버튼
	var groupName = [];
	$("#newGroup input").each(function() {
		groupName.push($(this).val());
	});
	
	$.ajax({
		type: "post",
		url: "/add/createnewgroup.do",
		data: JSON.stringify(groupName),
		contentType: "application/json; charset=utf-8",
		success: function(result){
			console.log(result);
			if(result == "SUCCESS"){
				$("#resultModal .modal-title").text("그룹추가");
				$("#resultSpace").text("입력하신 그룹이 정상적으로 추가되었습니다.");
				groupMngModal.hide(); // 닫기 필수
				new window.bootstrap.Modal(resultModal).show();
			} else if(result == "NOTINSERT"){
				$("#resultModal .modal-title").text("그룹추가");
				$("#resultSpace").text("입력하신 그룹이 존재하지 않아 추가되지 않았습니다.");
				groupMngModal.hide(); // 닫기 필수
				new window.bootstrap.Modal(resultModal).show();
			}
		}
	});
});

$("button[name='deleteGroupButton']").on("click", function(event){ // '나의그룹 ' 모달 안에 '삭제' 버튼
	var grcd = $(this).parent().data("grcd");
	var grname = $(this).parent().data("grname");
	
	customConfirm('정말 삭제하시겠습니까?').then((userConfirmed) => {
        if (userConfirmed) {
        	$.ajax({
        		type: "get",
        		url: "/add/delgroup.do?mygrCd=" + grcd,
        		success: function(result){
        			console.log(result);
        			if(result == "SUCCESS"){
        				$("#resultModal .modal-title").text("그룹삭제");
        				$("#resultSpace").text("정상적으로 삭제되었습니다.");
        				groupMngModal.hide(); // 닫기 필수
        				new window.bootstrap.Modal(resultModal).show();
        			}
        		}
        	});
        }
    });
	
	
});

$("button[name='modifyGroupButton']").on("click", function(event){ // '나의그룹 ' 모달 안에 '수정' 버튼
	var grcd = $(this).parent().data("grcd");
	var grname = $(this).parent().data("grname");
	console.log(grcd);
	
	$("#existGroupName").text(grname + " ");
	$("#modifyGroupModal .modal-body input").val("");
	$("#modifyGroupModal .modal-body input").attr("data-grcd", grcd); // data 속성 설정
	groupMngModal.hide(); // 닫기 필수
	newNameModal = new window.bootstrap.Modal(modifyGroupModal)
	newNameModal.show();
});

$("#newGroupConfirmBtn").on("click", function(){ // '나의그룹 ' 모달 안에 '수정모달' 안에 저장 버튼
	var mygrCd = $("#modifyGroupModal .modal-body input").data("grcd");
	var mygrName = $("#modifyGroupModal .modal-body input").val();
	
	$.ajax({
		type: "post",
		url: "/add/modifygroup.do",
		data: 
		{
			"mygrCd" : mygrCd,
			"mygrName" : mygrName
		},
		success: function(result){
			console.log(result);
			if(result == "SUCCESS"){
				$("#resultModal .modal-title").text("그룹수정");
				$("#resultSpace").text("정상적으로 수정되었습니다.");
				newNameModal.hide(); // 닫기 필수
				new window.bootstrap.Modal(resultModal).show();
			}
		}
	});
});
</script>