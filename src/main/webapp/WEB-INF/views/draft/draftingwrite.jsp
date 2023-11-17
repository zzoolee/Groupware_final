<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!-- jstree cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

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

<sec:authentication property='principal.emp.empNo' var="empNo"/>
<sec:authentication property='principal.emp.empName' var="empName"/>
<sec:authentication property='principal.emp.deptVO.deptName' var="deptName"/>
<sec:authentication property='principal.emp.codeVO.cdName' var="cdName"/>

<h2>기안서작성</h2>
<br/>

<form action="/draft/tempsave.do" method="post" id="tempForm">
	<input type="hidden" name="drftCd" value=${draftVO.drftCd }>
	<div>
		<table class="table table-sm" style="vertical-align: middle; height: 70px;">
		    <tr><p style="color: red;">፠ 연차, 출장에 대한 기안일 때 날짜를 꼭 입력해주세요.</p></tr>
		    <tr>
		      <th scope="col" style="width: 100px;">* 제목</th>
		      <td colspan="4"><input class="form-control form-control-sm" type="text" id="drftTitle" name="drftTitle"/></td>
		    </tr>
		    <tr>
		      <th scope="row" style="width: 100px;">* 기안자</th>
		      <td style="text-align: center;">${empName }/${deptName }</td>
		      <th style="width: 100px;">* 기안일</th>
		      <td style="text-align: center; width: 600px;"><script>date = new Date().toLocaleDateString(); document.write(date);</script></td>
		      <td></td>
		    </tr>
		    <tr id="vacationDate" style="display: none;">
		    	<th scope="col" style="width: 100px;">* 시작일</th>
				<td> 
	        		<input class="form-control stDate" type="date" name="drftStartdate" style="width: 150px; margin-right: 10px;"/>
	        	</td>
				<th style="width: 100px;">* 종료일</th>
				<td>
					<input class="form-control endDate" type="date" name="drftEnddate" style="width: 150px; margin-left: 10px;"/>
				</td>
				<td></td>
		    </tr>
		    <tr>
		      <th scope="row">* 참조자</th>
		      <td colspan="3" id="authRef"><!-- 참조 인원 들어갈 곳 --></td>
		      <td style="text-align: right; width:100px;"><button class="btn btn-outline-info me-1 mb-1" type="button" id="treeButton">조직도</button></td>
		    </tr>
		</table>
	</div>
<br>
	<button class="float-end btn btn-outline-info me-1 mb-1" type="button" id="authLineButton">결재선 지정</button>
	<table class="table table-bordered" style="text-align: center;">
	  <thead>
	    <tr class="table-info">
	      <th scope="col">순서</th>
	      <th scope="col">구분</th>
	      <th scope="col">결재부서</th>
	      <th scope="col">결재자</th>
	    </tr>
	  </thead>
	  <tbody id="comfirmAuthList">
	    <tr>
	      <th scope="row">1</th>
	      <td>기안</td>
	      <td>${deptName }</td>
	      <td>${empName } ${cdName }</td>
	    </tr>
	    <input type="hidden" value="${empNo }">
	    <!-- 결재선 선택시 들어가는 곳 -->
	  </tbody>
	</table>
<br>
	<div class="d-flex justify-content-end">
		<button class="btn btn-outline-info mb-1" type="button" data-bs-toggle="modal" data-bs-target="#scrollingLong2">양식 불러오기</button>
	</div>
	<div class="card-body">
		<div class="col-md-12">
			<textarea id="ckeditor" name="drftContent" class="form-control" rows="14"></textarea>
		</div>
	</div>
<br>
	<div>
		<table class="table table-sm">
		    <tr>
		      <th scope="col" style="width: 100px;">* 제출사유</th>
		      <td><textarea class="form-control" rows="5" cols="100" name="drftReason"></textarea></td>
		      <td colspan="2"></td>
		    </tr>
		</table>
	</div>
</form>

<!-- 조직도 모달창 시작 -->
<div class="modal fade" id="treeModal" tabindex="-1" style="display: none;" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">조직도</h5>
        <div>
	      	<button class="btn btn-soft-info me-1 mb-1 r_setAll" type="button" data-value="openStatus">전체열기/닫기</button>
	      	<button class="btn btn-soft-info me-1 mb-1 r_setAll" type="button" data-value="checkStatus">전체선택/해제</button>
<!--         <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" data-fa-i2svg=""><path fill="currentColor" d="M310.6 361.4c12.5 12.5 12.5 32.75 0 45.25C304.4 412.9 296.2 416 288 416s-16.38-3.125-22.62-9.375L160 301.3L54.63 406.6C48.38 412.9 40.19 416 32 416S15.63 412.9 9.375 406.6c-12.5-12.5-12.5-32.75 0-45.25l105.4-105.4L9.375 150.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 210.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0s12.5 32.75 0 45.25l-105.4 105.4L310.6 361.4z"></path></svg><span class="fas fa-times fs--1"></span> Font Awesome fontawesome.com</button> -->
      	</div>
      </div>
      <div class="modal-body" id="modal-tree">
      	<div class="d-flex justify-content-end">
	      	<input class="form-control" style="width:250px;" id="r_search_input" type="search" placeholder="Search..." aria-label="Search">
        </div>
        <hr>
        <p class="text-700 lh-lg mb-0">
        	<!-- 조직도 들어가는 곳 -->
        </p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="button" id="r_selectTree">선택</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 조직도 모달창 끝 -->

<!-- 결재선 지정 모달창-->
<div class="modal fade modal-xl" id="authLineModal" tabindex="-1" aria-hidden="true" >
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">결재선 지정</h5>
        	<button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
        		<span class="fas fa-times fs--1"></span>
        	</button>
      </div>
	      <div class="second-modal-body">
	      	<p class="text-700 lh-lg mb-0"></p>
	        	<div class="left" >
	        		<ul class="nav nav-underline" id="myTab" role="tablist">
					  <li class="nav-item"><a class="nav-link active" id="home-tab" data-bs-toggle="tab" href="#tab-tree" role="tab" aria-controls="tab-tree" aria-selected="true">조직도</a></li>
					  <li class="nav-item"><a class="nav-link" id="profile-tab" data-bs-toggle="tab" href="#tab-authLike" role="tab" aria-controls="tab-authLike" aria-selected="false">자주 사용하는 결재선</a></li>
					</ul>
					<div class="tab-content mt-3" id="myTabContent">
					  <div class="tab-pane fade show active" id="tab-tree" role="tabpanel" aria-labelledby="tree-tab">
					  	<div class="d-flex justify-content-between align-items-center border-0">
					  		<input class="form-control" style="width:100px;" id="search_input" type="search" placeholder="Search..." aria-label="Search">
					  		<button class="btn btn-soft-info me-1 mb-1 setAll" type="button" data-value="openStatus">전체열기/닫기</button>
					  	</div>
				  		<hr>
					  	<p class="text-700 lh-lg mb-0">
				        	<!-- 조직도 들어가는 곳 -->
				        </p>
					  </div>
					  <div class="tab-pane fade" id="tab-authLike" role="tabpanel" aria-labelledby="authLike-tab">
					  	<!-- 자주 사용하는 결재선 들어가는 곳 -->
					  	<c:forEach items="${abmVO }" var="abmVO">
					  		<button class="btn btn-link btn-sm m-1 bookMarkLine" type="button" data-bs-toggle="tooltip" data-bs-placement="bottom" 
					  			 title="${abmVO.abmLineList[0].empName }, 
					  					${abmVO.abmLineList[1].empName },
					  			 		${abmVO.abmLineList[2].empName }">${abmVO.abmName }</button><br>
					  	</c:forEach>
					  </div>
					</div>
	        	</div>
	        	<div class="buttons">
	        		<button class="btn btn-outline-info" type="button" style="margin-top: 180px" id="selectAuth">선택</button>
				<!--  	<button class="btn btn-outline-info" type="button" style="margin-top: 150px" id="refer">참조</button> -->
	        	</div>
	        	<div class="right">
		        	<sec:authentication property='principal.emp.empName' var="empName"/>
		        	<sec:authentication property='principal.emp.deptVO.deptName' var="deptName"/>
		        	<sec:authentication property='principal.emp.codeVO.cdName' var="cdName"/>
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
					    <tr>
					      <th scope="row">1</th>
					      <td>기안</td>
					      <td>${deptName }</td>
					      <td>${empName }</td>
					      <td>${cdName }</td>
					      <td></td>
					    </tr>
					    <input type="hidden" value="${empNo }">
					    <button class="float-end uil-trash-alt btn btn-link" type="button" id="authLineDelete">결재선 비우기</button>
					    <!-- 결재선 선택시 들어가는 곳 -->
					  </tbody>
					</table>
	        	</div>
	      </div>
	      <div class="modal-footer">
	      	<button class="btn btn-info" type="button" id="comfirmAuthLine">확인</button>
	      	<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
	      </div>
    </div>
  </div>
</div>
<!-- 결재선 지정 모달창-->

<!-- 양식 불러오기 모달 버튼 -->
	<div class="modal fade" id="scrollingLong2" tabindex="-1" aria-labelledby="scrollingLongModalLabel2" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-scrollable">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="scrollingLongModalLabel2">기안서 양식 목록</h5>
	        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
	        	<span class="fas fa-times fs--1"></span>
	        </button>
	      </div>
	      <div class="modal-body" style="text-align: center;">
	        <p class="text-700 lh-lg mb-0"></p> 
	        	<div class="row g-2 gy-3" >
					<div class="col-auto" style="margin-left: 40px;">
						<div class="search-box">
							<form class="position-relative" data-bs-toggle="search" data-bs-display="static">
								<!-- 검색 위치 -->
								<input class="form-control search-input search form-control-sm" type="search" placeholder="Search" aria-label="Search"> 
								<svg class="svg-inline--fa fa-magnifying-glass search-box-icon" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="magnifying-glass" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg="">
									<path fill="currentColor" d="M500.3 443.7l-119.7-119.7c27.22-40.41 40.65-90.9 33.46-144.7C401.8 87.79 326.8 13.32 235.2 1.723C99.01-15.51-15.51 99.01 1.724 235.2c11.6 91.64 86.08 166.7 177.6 178.9c53.8 7.189 104.3-6.236 144.7-33.46l119.7 119.7c15.62 15.62 40.95 15.62 56.57 0C515.9 484.7 515.9 459.3 500.3 443.7zM79.1 208c0-70.58 57.42-128 128-128s128 57.42 128 128c0 70.58-57.42 128-128 128S79.1 278.6 79.1 208z"></path>
								</svg><!-- <span class="fas fa-search search-box-icon"></span> Font Awesome fontawesome.com -->
							</form>
						</div>
					</div>
					<div class="col-auto">
						<button class="btn btn-sm btn-phoenix-secondary bg-white hover-bg-100 me-2" type="button">검색</button>
					</div>
				<hr/>
				</div>
	        	<b>기안서 양식을 선택해주세요</b><br>
	        		<c:forEach items="${docList }" var="doc">
	        			<div style="display: flex; margin-left: 28%;">
	        				<input class="form-check-input" name="atrzfName" type="radio" value="${doc.atrzfCd }" />
	        				&nbsp;&nbsp;${doc.atrzfName }<br>
	        			</div>
	        		</c:forEach>
	      </div>
	      <div class="modal-footer">
     		<button class="btn btn-info" type="button" id="okBtn">확인</button>
      		<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
	      </div>
	    </div>
	  </div>
	</div>
<!-- 양식 불러오기 모달 버튼 끝-->
	
	<div style="text-align: center;">
		<button class="uil-save btn btn-outline-info me-1 mb-1" type="button" id="tempBtn">임시저장</button>
		<button class="uil-check btn btn-info me-1 mb-1" type="button" id="appCheck">결재 상신</button>
	</div>



<script type="text/javascript">
$(function(){
	CKEDITOR.replace("ckeditor");
	CKEDITOR.config.width = "100%";
	CKEDITOR.config.height = "600px";

	$('document').ready(function() {
		var authFormCd ="";		
		var okBtn = $("#okBtn");
		var tempBtn = $("#tempBtn");
		var tempForm =$("#tempForm");
		var appCheck = $("#appCheck");
		
		//오늘 이후 선택가능
		var date = new Date;
		var blockBeforeday = date.toISOString().split('T')[0];
		console.log("오늘날짜 : ", blockBeforeday);
		$(".stDate").prop("min", blockBeforeday);
		$(".endDate").prop("min", blockBeforeday);
		
		//엔터키 submit이벤트 방지
		$('input[type="text"]').keydown(function() {
			  if (event.keyCode === 13) {
			    event.preventDefault();
		  	}
		});
		
		okBtn.on("click", function(){
			var atrzfCd = $("input[name=atrzfName]:checked").val();
			var scrollingLong2 = $("#scrollingLong2");
			
			var data = {
				atrzfCd : atrzfCd
			} 
			
			authFormCd = atrzfCd;
			
			//console.log(authFormCd);
			// AJAX 요청을 보내는 부분 (서버로 데이터 전송)
	         $.ajax({
	             type: "post", 				 // 또는 "GET" 등 HTTP 요청 메서드 설정
	             url: "/draft/write.do", 	 // 요청을 보낼 서버의 URL
	             data: JSON.stringify(data), // 선택된 데이터를 JSON 형태로 전송
	             contentType: "application/json; charset=utf-8", // 요청 본문 데이터 타입
	           	 success: function(res) {
	               CKEDITOR.instances.ckeditor.setData(res);
	               //console.log("결재문서양식 : "+res); 
	            }
	         });
			
			 //연차신청서일 때 시작일-종료일 tr 생성
			 if(authFormCd == "af001"){
				 $("#vacationDate").attr('style', "display:'';");
			 }else {
				 $("#vacationDate").css("display", "none");
				 // 다른 기안서일 때 날짜 속성 지우기 
			     $("input[type=date]").removeAttr("value");
			 }
	         $("input").remove("#formCd"); //양식을 다른 걸 선택할 시(중복 insert되는 걸 막음) 
	         $("#tempForm").append(`<input type="hidden" name="atrzfCd" value="`+authFormCd+`" id="formCd">`);
	         scrollingLong2.modal("hide"); 
		});
		
		
		tempBtn.on("click", function(){
			var drftTitle = $("#drftTitle").val();
			var contents= CKEDITOR.instances.ckeditor.getData();
			if(drftTitle == ""){
				alert("제목을 입력해주세요.");
				return false;
			} else if(contents == "" || authFormCd == ""){
				alert("기안서 양식을 선택해주세요.");
				return false;
			}else if($("#formCd").val() == "af001" && $("input[type=date]").val() == ''){
				alert("연차 날짜를 지정해주세요.");
				return false;
			}
			tempForm.submit();
		});
		
		
		// 결재상신 -> 진행중 문서로 이동.
		appCheck.on("click", function(){
			//현재 결재선에 있는 사람(주석처리하면 안돼요)
			var now = ($("#comfirmAuthList tr:gt(0)").length);
			console.log(now);
			
			var drftTitle = $("#drftTitle").val();
			var contents= CKEDITOR.instances.ckeditor.getData();
			if(drftTitle == ""){
				alert("제목을 입력해주세요.");
				return false;
			} else if(contents == "" || authFormCd == ""){
				alert("기안서 양식을 선택해주세요.");
				return false;
			}  
			
			if(authFormCd == "af001" && $("input[type=date]").val() == '') {
				alert("연차 날짜를 지정해주세요!");
			}else if (now !== 3) {
				alert("결재선 3명을 지정해주세요!");
			}else {
				customConfirm("결재를 올리시겠습니까?").then((userConfirmed) => {
		        	if (userConfirmed) { // yes버튼일떄
		        	  tempForm.attr("action", "/draft/dfapproval.do");
					  tempForm.submit();
		        	} else { // no버튼일때
			            return;
			    	}
				});
			}
		});
		
		
		$("#tab-authLike").on("dblclick",".bookMarkLine", function(){
			var clickText = $(this).text();
			//console.log(clickText);
			$.ajax({
				url :"/draft/bookMarkAppline.do",
				type: "get",
				dataType :"json",
				success : function(res){
					// abmVO가 리턴되어서 결과값으로 넘어옴.
// 						console.log("결과 >> ", res);
					
						var tbodyStr = "";
						for(let i=0; i < res.length; i++){
							console.log(res[i].abmName);
							if(res[i].abmName == clickText){
								var lineVO = res[i];
								
								for(let j=0; j < lineVO.abmLineList.length; j++){
									let bookMark = lineVO.abmLineList[j];
									console.log("결재선[", j ,"]: ", bookMark);
								
									tbodyStr += `
					 					<tr class="appline">
						 			      <th scope="row">\${bookMark.applOrder}</th>
										  <td>승인</td>
										  <td>\${bookMark.deptName}</td>
										  <td>\${bookMark.empName}</td>
										  <td>\${bookMark.cdName}</td>
										  <td>
									      	<input type="hidden" name="atrzpEmpno" value=\${bookMark.applEmpno}>
									      </td>
									    </tr>
									`;
								}
							}
						}
					$("tr").remove(".appline");
					$("#authList").append(tbodyStr);
				}
			});
		});
	});

});


////////////////// 조직도 시작 //////////////////
let r_treeContent;
let r_select; // 선택된 사람들이 객체로 들어있음
let r_modal;
let r_openFlag = false;
let r_checkFlag = false;

$("#treeButton").on("click", function(){
	r_treeContent = $("#modal-tree > p");
	r_treeContent.jstree({
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
	
	r_treeContent.bind("loaded.jstree", function(e, data) {
		console.log("트리 로딩 완료");
		var model = r_treeContent.jstree(true)._model.data;
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
							r_treeContent.jstree(true).create_node(idata.id, result[i], "last", function(){
								console.log("노드 생성 성공");
							});
						}
					}
				}
			});
		});
	}.bind(this));
	
	// 해당 id의 노드를 open 상태로 바꿉니다.
	r_treeContent.on("ready.jstree", function(){
		$(this).jstree("open_node", "#"); // 이 경우 id가 1번인 root노드를 열린 상태로 로드함
	});
	
	r_treeContent.on("changed.jstree", function (e, data) {
	    console.log("changed id : " + data.node.id);
	    console.log("changed node childeren : " + data.node.children);
	});
	
	r_treeContent.bind("select_node.jstree", function (e, data) {
		console.log("select id : " + data.node.id);
		console.log("select node childeren : " + data.node.children);
	});

	var to = false;
	$('#r_search_input').keyup(function () {
	    if(to) { clearTimeout(to); }
	    to = setTimeout(function () {
	      var v = $('#r_search_input').val();
	      r_treeContent.jstree(true).search(v);
	    }, 250);
	});
	
	r_modal = new window.bootstrap.Modal(treeModal);
	r_modal.show();
});

$("#r_selectTree").on("click", function(){
	r_select = r_treeContent.jstree('get_selected',true);
	console.log(r_select); // 선택된 사람들 리스트
// 	console.log("선택된 사람[0] 아이디 : " + r_select[0].id);
// 	console.log("선택된 사람[0] 이름 : " + r_select[0].text);
// 	console.log("선택된 사람[0] 부서 : " + r_select[0].original.deptVO);
	
	$("#authRef").text(""); // 페이지의 참조자 지워주고
	
	let cnt = 0;
	for(var i = 0; i < r_select.length; i++){
		var isDuplicate = false;
		$("#comfirmAuthList input").each(function(){
			console.log($(this).val());
			if($(this).val().substr(0,10) == r_select[i].id){
				isDuplicate = true;
			}
		});
		if(isDuplicate){
			cnt++;
			continue;
		}
		if(r_select[i].original.deptVO != null){ // 팀 제외한 직원만 추가
			$("#authRef").append(`<span class="btn btn-sm btn-phoenix-secondary rounded-pill me-1 mb-1">`+r_select[i].text+`/`+r_select[i].original.deptVO.text+`</span>`);
			$("#authRef").append(`<input type="hidden" name="refEmpno" value="`+r_select[i].id+`">`);
		}
	}
	if(cnt != 0){
// 		console.log(cnt + "번 추가되지 않음");
		alert("결재자를 참조자로 등록할 수 없어 제외하고 추가합니다.");
	}

	r_modal.hide();
});

$(".r_setAll").on("click", function(){
	var value = $(this).data("value"); // data-value 값을 가져옵니다.
	console.log(value);
	if(value == "openStatus"){
		if(!r_openFlag){
			r_openFlag = true;
			r_treeContent.jstree("open_all");
		}else{
			r_openFlag = false;
			r_treeContent.jstree("close_all");
		}
	}
	if(value == "checkStatus"){
		if(!r_checkFlag){
			r_checkFlag = true;
			r_treeContent.jstree("check_all");
		}else{
			r_checkFlag = false;
			r_treeContent.jstree("uncheck_all");
		}
	}	
});

////////////////// 조직도 끝////////////////////


////////////////// 결재선 지정 시작 //////////////////
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

// 결재선 선택
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
	      	<input type="hidden" name="atrzpEmpno" value="` + select[0].id + `">
	      </td>
	    </tr>`
	);
	//결재선 추가할때마다
	console.log("결재선 추가할때", $("input[name=atrzpEmpno]").length);
});

//:gt(0)는 두 번째 행(인덱스 1)부터 그 이후 비우기
$("#authLineDelete").on("click", function(){
	$("#authList tr:gt(0)").remove();
	row = 1;
	//결재선 비우기
	console.log("결재선 비우기", $("input[name=atrzpEmpno]").length);
});


// 선택된 결재선 삭제
$("#authList").on("click", ".btn-close", function(){
    $(this).closest("tr").remove(); // 현재 버튼의 부모 <tr>을 삭제합니다.
    row -= 1;
  	//삭제될때마다
    console.log("삭제될때마다 ", $("input[name=atrzpEmpno]").length);
});

$("#comfirmAuthLine").on("click", function(){
	// 모달 데이터 페이지로 옮겨주기(첫번째 tr 요소 제외한 모든 tr 요소)
	$("#comfirmAuthList tr:gt(0)").each(function() { // 페이지의 tr 지워주고
		$(this).next().remove(); // input 삭제
		$(this).remove(); // tr 삭제
	});
	$("#authList tr:gt(0)").each(function() { // 모달의 tr 새로 추가
		var row = $(this);
        var order = row.find("th").text(); // 순서
        var se = row.find("td:eq(0)").text(); // 구분
        var dept = row.find("td:eq(1)").text(); // 부서명
        var name = row.find("td:eq(2)").text(); // 이름
        var rank = row.find("td:eq(3)").text(); // 직급
        var id = row.find("input").val(); // 아이디
		
        var confirmRow =
			`<tr>
		        <th scope="row">`+order+`</th>
		        <td>`+se+`</td>
		        <td>`+dept+`</td>
		        <td>`+name+" "+rank+`</td>
	   		 </tr>
		     <input type="hidden" name="atrzpEmpno" value=`+id+`_`+order+`>`;
	   		
		$("#comfirmAuthList").append(confirmRow);
	});	
	
	modal.hide();
});

//////////////////결재선 지정 끝 //////////////////
</script>
