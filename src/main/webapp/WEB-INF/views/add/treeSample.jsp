<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- jstree cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<body>
<div class="float-end">
	<button class="btn btn-info me-1 mb-1" type="button" id="treeButton">조직도</button>
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
	      	<button class="btn btn-soft-info me-1 mb-1 setAll" type="button" data-value="checkStatus">전체선택/해제</button>
        </div>
        <hr>
        <p class="text-700 lh-lg mb-0">
        	<!-- 조직도 들어가는 곳 -->
        </p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="button" id="selectTree">선택</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 조직도 모달창 끝 -->

<script type="text/javascript">
let treeContent;
let select; // 선택된 사람들이 객체로 들어있음
let modal;
let openFlag = false;
let checkFlag = false;

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
		"plugins" : ["checkbox", "search", "types", "state", "changed"]
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
	
	treeContent.on("changed.jstree", function (e, data) { // 없으면 새로고침해도 선택이 그대로 남아있음...?
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
	
	treeContent.bind("select_node.jstree", function (e, data) { // 없으면 새로고침해도 선택이 그대로 남아있음...?
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

</script>