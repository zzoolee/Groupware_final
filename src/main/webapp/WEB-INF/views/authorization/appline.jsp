<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>


<!-- jstree cdn -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<style type="text/css">
.left, .middle {
	width: 300px;
	height: 400px;
	float: left;
	box-sizing: border-box;
	border: 1px solid;
	margin: 10px;
	padding: 10px;
	background-color: white;
	overflow: auto;
}

.right {
	width: 600px;
	height: 400px;
	float: left;
	box-sizing: border-box;
	border: 1px solid;
	margin: 10px;
	padding: 10px;
	background-color: white;
	overflow: auto;
}

.buttons {
	width: 80px;
	display: flex;
	flex-direction: column; /* 버튼을 위 아래로 배치 */
	align-items: center; /* 가운데 정렬 */
}

.second-modal-body {
	background-color: #F0F8FF;
	padding: 20px;
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
}
</style>

<body>
<sec:authentication property="principal.emp.empName" var="empName"/>
<h2 class="">결재선관리</h2>
<span style="font-weight: bolder;">${empName }님이 <span style="color: green;">즐겨찾는 결재선</span>입니다.</span>
<br/><br/>
<form action="/auth/abmdel.do" method="post" id="delForm">
	<input type="hidden" value="" class="approvalLine" >
		<div class="card col-12" style="padding: 20px;">	
			<div id="tableExample4" data-list='{"valueNames":["abmName","appLineEmp"],"page":10,"pagination":true,"filter":{"key":"drftDate"}}'>
				<!-- 검색창 -->
				<div class="d-flex justify-content-between align-items-center border-0 d-flex" style="margin-left: 530px;">
					<div class="search-box" style="width: 500px;">
						<form class="position-relative" data-bs-toggle="search" data-bs-display="static">
							<input class="form-control search-input search" type="search" placeholder="Search" aria-label="Search"> 
								<span class="fas fa-search search-box-icon"></span>
						</form>
					</div>
				</div>
			<br>
			<div style="display: flex; margin-left: 1330px;">
				<button class="btn uil-edit-alt btn-info me-1 mb-1" type="button" id="authLineButton">등록</button>
				<button class="btn btn-phoenix-danger me-1 mb-1" type="button" id="delBtn">
				<svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg>
				삭제</button>
			</div>
				<div class="table-responsive">
					<table class="table table mb-0" style="text-align: center;">
						<thead>
							<tr class="bg-light">
								<th class="ps-8" style="width: 100px;"><input class="form-check-input" id="totalChk" type="checkbox" /></th>
								<th class="" style="width: 300px;" data-sort="abmName">즐겨찾는 결재선명</th>
								<th class="" style="width: 300px;" data-sort="appLineEmp">결재선1</th>
								<th class="" style="width: 300px;" data-sort="appLineEmp">결재선2</th>
								<th class="" style="width: 300px;" data-sort="appLineEmp">결재선3</th>
							</tr>
						</thead>
						<tbody class="list">
						<c:choose>
							<c:when test="${empty abmVO }">
								<tr>
									<td colspan="5">즐겨찾는 결재선을 지정하지 않았습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach items="${abmVO }" var="abmVO" >
									<tr>
										<td class="ps-8">
											<input class="form-check-input appLineCheckbox" type="checkbox" name="abmCd" value="${abmVO.abmCd }"/>
										</td> 
										<td class="abmName" style="text-align: left; padding-left:100px;"> ${abmVO.abmName } </td>
										<td class="appLineEmp">${abmVO.abmLineList[0].empName } ${abmVO.abmLineList[0].cdName }/${abmVO.abmLineList[0].deptName }</td>
										<td>${abmVO.abmLineList[1].empName } ${abmVO.abmLineList[1].cdName }/${abmVO.abmLineList[1].deptName }</td>
										<td>${abmVO.abmLineList[2].empName } ${abmVO.abmLineList[2].cdName }/${abmVO.abmLineList[2].deptName }</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>	
						</tbody>
					</table>
				</div>
				
				<div class="d-flex justify-content-center mt-3">
					<button class="page-link" data-list-pagination="prev">
						<span class="fas fa-chevron-left"></span>
					</button>
						<ul class="mb-0 pagination"></ul>
					<button class="page-link pe-0" data-list-pagination="next">
						<span class="fas fa-chevron-right"></span>
					</button>
				</div>
			</div>
		</div>	
	</form>
<br/>
	

<!-- 즐겨찾는 결재선 지정 모달창-->
<form action="/auth/bmline.do" method="post" id="bmForm">
	<div class="modal fade modal-xl" id="authLineModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">즐겨찾는 결재선</h5>
					<button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
						<span class="fas fa-times fs--1"></span>
					</button>
				</div>
				<div class="second-modal-body">
					<p class="text-700 lh-lg mb-0"></p>
					<div class="left">
						<ul class="nav nav-underline" id="myTab" role="tablist">
							<li class="nav-item">
								<a class="nav-link active" 	id="home-tab" data-bs-toggle="tab" href="#tab-tree" role="tab"
								aria-controls="tab-tree" aria-selected="true">조직도</a></li>
							<!-- <li class="nav-item"><a class="nav-link" id="profile-tab"
								data-bs-toggle="tab" href="#tab-authLike" role="tab"
								aria-controls="tab-authLike" aria-selected="false">자주 사용하는
									결재선</a></li> -->
						</ul>
						<div class="tab-content mt-3" id="myTabContent">
							<div class="tab-pane fade show active" id="tab-tree" role="tabpanel" aria-labelledby="tree-tab">
								<div class="d-flex justify-content-between align-items-center border-0">
									<input class="form-control" style="width: 100px;"
										id="search_input" type="search" placeholder="Search..."
										aria-label="Search">
									<button class="btn btn-soft-info me-1 mb-1 setAll"
										type="button" data-value="openStatus">전체열기/닫기</button>
								</div>
								<hr>
								<p class="text-700 lh-lg mb-0">
									<!-- 조직도 들어가는 곳 -->
								</p>
							</div>
							<div class="tab-pane fade" id="tab-authLike" role="tabpanel"
								aria-labelledby="authLike-tab">
								<!-- 자주 사용하는 결재선 들어가는 곳 -->
							</div>
						</div>
					</div>
					<div class="buttons">
						<button class="btn btn-outline-info" type="button"
							style="margin-top: 180px" id="selectAuth">선택</button>
						<!--  	<button class="btn btn-outline-info" type="button" style="margin-top: 150px" id="refer">참조</button> -->
					</div>
					<div class="right">
						<sec:authentication property='principal.emp.empName' var="empName" />
						<sec:authentication property='principal.emp.deptVO.deptName' var="deptName" />
						<sec:authentication property='principal.emp.codeVO.cdName'	var="cdName" />
						<table class="table table-hover" id="authLineTable">
							<thead>
								<tr>
									<th scope="col">순서</th>
									<th scope="col">구분</th>
									<th scope="col">부서명</th>
									<th scope="col">이름</th>
									<th scope="col">직급</th>
									<th scope="col"></th>
								</tr>
							</thead>
							<tbody id="authList">
								<input class="form-control" name="abmName" type="text" placeholder="즐겨찾는 결재선명을 입력해주세요." id="abmName">
								<tr>
									<th scope="row">1</th>
									<td>기안</td>
									<td>${deptName }</td>
									<td>${empName }</td>
									<td>${cdName }</td>
									<td></td>
								</tr>
								<button class="float-end uil-trash-alt btn btn-link" type="button" id="authLineDelete">결재선 비우기</button>
								<input type="hidden" value="${empNo }">
								<!-- 결재선 선택시 들어가는 곳 -->
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-info" type="button" id="bookMarkAuthLine">확인</button>
					<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>
</form>
<!--  즐겨찾는 결재선 지정 모달창-->



</body>
<script type="text/javascript">
$(document).ready(function() {
	/* 체크박스 */
	$("#totalChk").click(function(){
		if($("#totalChk").is(":checked")) $("input[name=abmCd]").prop("checked", true);
		else $("input[name=abmCd]").prop("checked", false);
	});

	$("input[name=abmCd]").click(function(){
		var total = $("input[name=abmCd]").length;
		var checked = $("input[name=abmCd]:checked").length;
		
		if(total != checked) $("#totalChk").prop("checked", false);
		else $("#totalChk").prop("checked", true); 
	});
	
	
	$("#delBtn").on("click", function(){
		var applineArray = [];	//빈 배열
		var approvalLine = $(".approvalLine");	//input 타입 hidden으로 되어있는 즐겨찾는 결재선 코드 클래스 값.
		
		$(".appLineCheckbox").each(function() {	//체크된 결재선코드를 배열에 담음
			if($(this).is(":checked") == true){
				console.log($(this).val());
				applineArray.push($(this).val());
			}
		});
		console.log("applineArray : ", applineArray);
		if(applineArray.length == 0){
			alert("삭제할 결재선을 체크해주세요.");
			return false;
		}else if(applineArray != null){
			approvalLine.val(applineArray);
			console.log("approvalLine : ", approvalLine.val());
		}
		customConfirm("결재선을 삭제하시겠습니까?").then((userConfirmed) => {
          if (userConfirmed) { // yes버튼일떄
         	 $("#delForm").submit();
          } else { // no버튼일때
              return;
          }
    
		});
	});
});





//////////////////결재선 지정 시작 //////////////////
let treeContent;
let modal;
let select; // 선택된 사람들이 객체로 들어있음
let openFlag = false;

let row = 1;

$("#authLineButton").on("click", function(){
	treeContent = $("#tab-tree > p");
	treeContent.jstree({
		"core" : {
			"data" : {
				"url" : "/add/treelist.do",
				"dataType": "json"
		},
		"check_callback" : true // 동적 노드 생성 허용!!!!!
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
	"plugins" : ["search", "types", "state", "changed"]
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
	});

	treeContent.bind("select_node.jstree", function (e, data) {
		console.log("select id : " + data.node.id);
		console.log("select node childeren : " + data.node.children);
	});

	var to = false;
	$('#search_input').keyup(function () {
		if(to) { clearTimeout(to); }
		to = setTimeout(function () {
			var v = $('#search_input').val();
			treeContent.jstree(true).search(v);
		}, 250);
	});

	modal = new window.bootstrap.Modal(authLineModal);
	modal.show();
	
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

//결재선 선택
$("#selectAuth").on("click", function(){
	select = treeContent.jstree('get_selected',true);
	console.log(select); // 선택된 사람들 리스트
	console.log("선택된 사람[0] 아이디 : " + select[0].id);
	console.log("선택된 사람[0] 이름 : " + select[0].text);

	if(row == 4){ // 1) 결재선 4명인 상태에서 추가 선택시
		alert("더 이상 결재선을 추가할 수 없습니다.");
		return;
	}

	if(select[0].original.deptVO == null){ // 2) 팀 선택시
		alert("직원을 선택해주세요.");
		return;
	}

	let addEmpFlag = false;
	$("#authList input").each(function() { // 3) 기 선택한 직원 선택시(본인 포함)
		if(select[0].id == $(this).val()){
			alert("이미 추가된 직원입니다.");
			addEmpFlag = true;
		}
	});
	if(addEmpFlag) return;

	let refEmpFlag = false;
	$("#authRef input").each(function() { // 4) 참조자로 추가된 직원 선택시
		if(select[0].id == $(this).val()){
			alert("참조자로 추가된 직원입니다.");
			refEmpFlag = true;
			}
	});
	if(refEmpFlag) return;

	row += 1;
	$("#authList").append(
		`<tr>
			<th scope="row">` + row + `</th>
			<td>승인</td>
			<td>` + select[0].original.deptVO.text + `</td>
			<td>` + select[0].original.empName + `</td>
			<td>` + select[0].original.codeVO.cdName + `</td>
			<td>
				<button class="btn-close" type="button" aria-label="Close"></button>
				<input type="hidden" name="applEmpno" value="` + select[0].id +"_"+row +`" >
			</td>
		</tr>`
	);
});

//선택된 결재선 삭제
$("#authList").on("click", ".btn-close", function(){
	$(this).closest("tr").remove(); // 현재 버튼의 부모 <tr>을 삭제합니다.
		row -= 1;
	});

$("#authLineDelete").on("click", function(){
	$("#authList tr:gt(0)").remove();
	$("input[name=atrzpEmpno]").remove();
	row = 1;
});

$("#bookMarkAuthLine").on("click", function(){
 	var abmName = $("#abmName");
 	console.log("abmName.val() ", abmName.val() );
 	
 	if(abmName.val() == 0) {
		alert("결재선명을 입력해주세요.");
 	}else{
 		$("#bmForm").submit();
 		modal.hide();
 	}
	
});

//////////////////결재선 지정 끝 //////////////////
</script>
