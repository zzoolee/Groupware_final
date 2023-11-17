<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

.modal-body {
    background-color: #F0F8FF;
    padding: 20px;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
}

</style>

<!-- 결재선 지정 모달창-->
<button class="btn btn-outline-info uil-user-check" type="button" id="authLineButton">결재선 지정</button>
<div class="modal fade modal-xl" id="authLineModal" tabindex="-1" aria-hidden="true" >
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">결재선 지정</h5>
        	<button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
        		<span class="fas fa-times fs--1"></span>
        	</button>
      </div>
	      <div class="modal-body">
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
					  </div>
					</div>
	        	</div>
	        	<div class="buttons">
	        		<button class="btn btn-outline-info" type="button" style="margin-top: 180px" id="selectAuth">선택</button>
<!--         			<button class="btn btn-outline-info" type="button" style="margin-top: 150px" id="refer">참조</button> -->
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

<div id="test"></div>

<script type="text/javascript">
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
	if(select[0].original.deptVO == null){
		alert("결재선으로 추가할 수 없습니다.");
		return;
	}
	if(row == 4){
		alert("더이상 결재선을 추가할 수 없습니다.");
		return;
	}
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
	      	<input type="hidden" name="atrzpEmpno" value="` + (select[0].id + `_` + row) + `">
	      </td>
	    </tr>`
	);
});

// 선택된 결재선 삭제
$("#authList").on("click", ".btn-close", function(){
    $(this).closest("tr").remove(); // 현재 버튼의 부모 <tr>을 삭제합니다.
    row -= 1;
});

$("#comfirmAuthLine").on("click", function(){
	// 모달 데이터 페이지로 옮겨주기
	$("#test").html($("#authLineTable").html());
	modal.hide();
});

</script>
