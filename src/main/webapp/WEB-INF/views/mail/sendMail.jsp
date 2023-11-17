<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<div class="row">
	<div class="col-12">
		<h2>&nbsp;메일보내기&nbsp;&nbsp;&nbsp;<button class="btn btn-info me-1 mb-1" type="button" id="myselfBtn">나에게 메일보내기</button></h2>
	</div>
</div>
<div class="email-container pt-5">
	<div class="row g-lg-6 mb-8">
		<div class="col-12">
			<div class="card">
				<div class="card-body">
					<form class="d-flex flex-column h-100" id="sendMailForm">
						<div class="row g-3 mb-2">
							<div class="col-12">
								<div class="d-flex align-items-center mb-1">
									<span class="me-2 uil uil-user"></span>
									<h5 class="text-1000 mb-0">받는이</h5>
								</div>
								<div class="input-group mb-1">
									<div class="form-control" type="text" id="rcvPlace">
										<!-- 받는 직원 들어가는 곳 -->
									</div>
									<span class="input-group-text" id="rcvBtn" style="cursor: pointer;">조직도검색</span>
								</div>
							</div>
							<div class="col-12">
								<div class="d-flex align-items-center mb-1">
									<span class="me-2 uil uil-user"></span>
									<h5 class="text-1000 mb-0">참조자</h5>
								</div>
								<div class="input-group mb-1">
									<div class="form-control" type="text" id="refPlace">
										<!-- 참조 직원 들어가는 곳 -->
									</div>
									<span class="input-group-text" id="refBtn" style="cursor: pointer;">조직도검색</span>
								</div>
							</div>
							<div class="col-12">
								<input class="form-control form-control" id="mailTitle" name="mailTitle" type="text" placeholder="제목을 입력해주세요." />
							</div>
							<div>
								<textarea class="form-control" id="mailContent" name="mailContent" style="height: 1000px;"></textarea>
							</div>
							<div class="col-12" id="fileNameDiv">
								
							</div>
							<div class="d-flex justify-content-between align-items-center">
								<div class="d-flex">
									<label class="btn btn-link py-0 px-2 text-900 fs--1" for="emailAttachment">
									<span class="fa-solid fa-paperclip"></span></label>
									<input class="d-none" id="emailAttachment" name="fileForm" type="file" multiple="multiple"/>
								</div>
								<div class="d-flex">
									<button class="btn btn-outline-info me-1 mb-1" type="button" id="listBtn">&nbsp;&nbsp;목록&nbsp;&nbsp;</button>
									<button class="btn btn-info me-1 mb-1" type="button" id="mailBtn">메일보내기</button>
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>


<!-- 받는 사람 추가 모달(조직도) 시작 -->
<div class="modal fade" id="rcvModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">조직도</h5>
        <div>
	      	<button class="btn btn-soft-info me-1 mb-1 rcv_setAll" type="button" data-value="openStatus">전체열기/닫기</button>
	      	<button class="btn btn-soft-info me-1 mb-1 rcv_setAll" type="button" data-value="checkStatus">전체선택/해제</button>
<!--         <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" data-fa-i2svg=""><path fill="currentColor" d="M310.6 361.4c12.5 12.5 12.5 32.75 0 45.25C304.4 412.9 296.2 416 288 416s-16.38-3.125-22.62-9.375L160 301.3L54.63 406.6C48.38 412.9 40.19 416 32 416S15.63 412.9 9.375 406.6c-12.5-12.5-12.5-32.75 0-45.25l105.4-105.4L9.375 150.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 210.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0s12.5 32.75 0 45.25l-105.4 105.4L310.6 361.4z"></path></svg><span class="fas fa-times fs--1"></span> Font Awesome fontawesome.com</button> -->
      	</div>
      </div>
      <div class="modal-body">
        <div class="d-flex justify-content-end">
	      	<input class="form-control" style="width:250px;" id="rcv_search_input" type="search" placeholder="Search..." aria-label="Search">
        </div>
        <hr>
        <p class="text-700 lh-lg mb-0">
        	<!-- 조직도 들어가는 곳 -->
        </p>
      </div>
      <div class="modal-footer">
      	<button class="btn btn-info me-1 mb-1" type="button" id="rcv_selectTree">선택</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 받는 사람 추가 모달(조직도) 끝 -->

<!-- 참조 직원 추가 모달(조직도) 시작 -->
<div class="modal fade" id="refModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">조직도</h5>
        <div>
	      	<button class="btn btn-soft-info me-1 mb-1 ref_setAll" type="button" data-value="openStatus">전체열기/닫기</button>
	      	<button class="btn btn-soft-info me-1 mb-1 ref_setAll" type="button" data-value="checkStatus">전체선택/해제</button>
<!--         <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" data-fa-i2svg=""><path fill="currentColor" d="M310.6 361.4c12.5 12.5 12.5 32.75 0 45.25C304.4 412.9 296.2 416 288 416s-16.38-3.125-22.62-9.375L160 301.3L54.63 406.6C48.38 412.9 40.19 416 32 416S15.63 412.9 9.375 406.6c-12.5-12.5-12.5-32.75 0-45.25l105.4-105.4L9.375 150.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 210.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0s12.5 32.75 0 45.25l-105.4 105.4L310.6 361.4z"></path></svg><span class="fas fa-times fs--1"></span> Font Awesome fontawesome.com</button> -->
      	</div>
      </div>
      <div class="modal-body">
        <div class="d-flex justify-content-end">
	      	<input class="form-control" style="width:250px;" id="ref_search_input" type="search" placeholder="Search..." aria-label="Search">
        </div>
        <hr>
        <p class="text-700 lh-lg mb-0">
        	<!-- 조직도 들어가는 곳 -->
        </p>
      </div>
      <div class="modal-footer">
      	<button class="btn btn-info me-1 mb-1" type="button" id="ref_selectTree">선택</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 참조 직원 추가 모달(조직도) 끝 -->

<!-- jstree cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<script type="text/javascript">
$(function(){
	CKEDITOR.replace('mailContent', {height: 200});
	
	
});


$(document).on('click', '#myselfBtn', function(){
	location.href="/sendtome.do";
})

// 목록버튼을 눌렀을때 보낸 메일함으로 넘어간다.
$(document).on('click', '#listBtn', function(){
	location.href="/sendedmail.do";
});

//메일 보내기를 눌렀을때 메일을 서브밋한다.
$(document).on('click', '#mailBtn', function(){
	  var files = $('#emailAttachment').prop('files');
	  var formData = new FormData();
	  var fileName = $('.fileName');
	  var mailTitle = $('#mailTitle').val();
	  var mailContent = $('#mailContent').text();
	  if(formData != null || files != null) {
		  for(var i = 0; i < fileName.length; i ++) {
		  	for(var j = 0; j < files.length; j++) {
			  	if(fileName[i].value == files[j].name) {
				  	formData.append("fileList", files[j]);
			  	}
		  	}
	  	}
	  }
	  var mailrEmpnoList = $('input[name="mailrEmpnoList"]');
	  var mailrefEmpnoList = $('input[name="mailrefEmpnoList"]');
	  
	  var mailEmpno = [];
	  var mailRef = [];
	  
	  mailrEmpnoList.each(function() {
		  mailEmpno.push($(this).val());
	  });
	  mailrefEmpnoList.each(function() {
		  mailRef.push($(this).val());
	  });
	  
	  CKEDITOR.replace('editor');
	  
	  var editor = CKEDITOR.instances.mailContent.getData(); // 에디터 인스턴스 가져오기
	  
	  
	  formData.append("mailEmpno", mailEmpno);
	  formData.append("mailRef", mailRef);
	  formData.append("mailTitle", mailTitle);
	  formData.append("mailContent", editor);
	  if(mailTitle == null || mailTitle.trim() == "") {
		  alert('제목을 입력해주세요');
		  return false;
	  }
	  if(editor == null || editor.trim() == "") {
		  alert('내용을 입력해주세요');
		  return false;
	  }
	  if(mailEmpno.length == 0) {
		  alert('받는이를 등록해주세요');
		  return false;
	  }
		
	  // 배열에 저장된 값 출력
	  console.log("메일 제목 : "+mailTitle);
	  console.log("메일 내용 : "+editor);
	  console.log("메일 전송받는 사원 : "+mailEmpno);
	  console.log("메일 참조받는 사원 : "+mailRef);
	 
	  $.ajax({
	        url: '/sendMailForm.do',
	        type: 'POST',
	        data: formData,
	        contentType: false,
	        processData: false,
	        success: function(result) {
	        	console.log("result 확인: ",result);
	        	if(result.includes("메일")){
	        		ws.send(result);
	        	}
	            location.href="/sendedmail.do";
	        },
	        error: function(error) {
	            // 오류 처리
	        }
	    });
});

// ajax로 div에 내용추가해주기.
$(document).on('change', '#emailAttachment', function(event){
	var selectFile = event.target.files;
	var formData = new FormData();
	var images = ["jpg","jpeg","jfif","gif","png"]

	// 파일 입력 필드에서 선택한 파일들을 FormData에 추가
	for (var i = 0; i < selectFile.length; i++) {
	    formData.append("selectFileList", selectFile[i]);
	}
	$.ajax({
		type : "POST",
		url : "/sendMailAjax.do",
		data: formData,
        processData: false, // 필수: FormData를 처리하지 않도록 설정
        contentType: false, // 필수: Content-Type 헤더를 설정하지 않도록 설정
		success : function(result){
			if(result != null) {
				console.log(result);
				console.log(result.preFileVO);
				var str = "";
				var addIcon = "";
				$('#fileNameDiv').html('');
				result.preFile.forEach(function(item){
				console.log(result);
				if(images.includes(item.fileType)){
					addIcon = '<span class="text-900 uil uil-file-contract">&nbsp;</span>';
				} else {
					addIcon = '<span class="text-900 uil uil-file">&nbsp;</span>';
				}
					str += '<div class="col-12 fileListDiv">';
		        	str += '<span class="fw-bold cancleSpan" data-value="' + item.fileSavename + '" style="cursor:pointer">' + addIcon + item.fileOrgname + '&nbsp;&nbsp;&nbsp;<span class="cancleFile" style="color:red; cursor:pointer;">x</span></span>';
		        	str += '<input type="hidden" value="' + item.fileMime + '" name="fileMime">';
		        	str += '<input type="hidden" value="' + item.fileSavename + '" name="fileSavename">';
		        	str += '<input type="hidden" value="' + item.fileSavepath + '" name="fileSavepath">';
		        	str += '<input type="hidden" value="' + item.fileSize + '" name="fileSize">';
		        	str += '<input type="hidden" class="fileName" value="' + item.fileOrgname + '" name="fileOrgname">';
		        	str += '<input type="hidden" value="' + item.fileType + '" name="fileType">';
		        	str += '</div>';
				})
				$('#fileNameDiv').html(str);
			} else {
				alert("실패...");
			}
		}
	});
});

$(document).on('click', '.cancleFile', function(){
	console.log($(this));
	$(this).closest('.fileListDiv').remove();
});

$(document).on('click', '.cancleSpan', function(){
	console.log($(this).data('value'));
	
	var images = ["jpg","jpeg","jfif","gif","png"];
});





////////////////// 받는 직원 추가 조직도 시작 //////////////////
let rcv_treeContent;
let rcv_select; // 선택된 사람들이 객체로 들어있음
let rcv_modal;
let rcv_openFlag = false;
let rcv_checkFlag = false;

$("#rcvBtn").on("click", function(){
	rcv_treeContent = $("#rcvModal .modal-body > p");
	rcv_treeContent.jstree({
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
	
	rcv_treeContent.bind("loaded.jstree", function(e, data) {
		console.log("트리 로딩 완료");
		var model = rcv_treeContent.jstree(true)._model.data;
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
							rcv_treeContent.jstree(true).create_node(idata.id, result[i], "last", function(){
								console.log("노드 생성 성공");
							});
						}
					}
				}
			});
		});
	}.bind(this));
	
	// 해당 id의 노드를 open 상태로 바꿉니다.
	rcv_treeContent.on("ready.jstree", function(){
		$(this).jstree("open_node", "#"); // 이 경우 id가 1번인 root노드를 열린 상태로 로드함
	});
	
	rcv_treeContent.on("changed.jstree", function (e, data) {
	    console.log("changed id : " + data.node.id);
	    console.log("changed node childeren : " + data.node.children);
	});
	
	rcv_treeContent.bind("select_node.jstree", function (e, data) {
		console.log("select id : " + data.node.id);
		console.log("select node childeren : " + data.node.children);
	});

	var to = false;
	$('#rcv_search_input').keyup(function () {
	    if(to) { clearTimeout(to); }
	    to = setTimeout(function () {
	      var v = $('#rcv_search_input').val();
	      rcv_treeContent.jstree(true).search(v);
	    }, 250);
	});
	
	rcv_modal = new window.bootstrap.Modal(rcvModal);
	rcv_modal.show();
});

$("#rcv_selectTree").on("click", function(){
	rcv_select = rcv_treeContent.jstree('get_selected',true);
	console.log(rcv_select); // 선택된 사람들 리스트
// 	console.log("선택된 사람[0] 아이디 : " + rcv_select[0].id);
// 	console.log("선택된 사람[0] 이름 : " + rcv_select[0].text);
// 	console.log("선택된 사람[0] 부서 : " + rcv_select[0].original.deptVO);
	
	$("#rcvPlace").text(""); // 페이지의 참조자 지워주고
	
	for(var i = 0; i < rcv_select.length; i++){
		if(rcv_select[i].original.deptVO != null){ // 팀 제외한 직원만 추가
			$("#rcvPlace").append(`<span class="btn btn-sm btn-phoenix-secondary rounded-pill me-1 mb-1">`+rcv_select[i].text+`/`+rcv_select[i].original.deptVO.text+`</span>`);
			$("#rcvPlace").append(`<input type="hidden" name="mailrEmpnoList" value="`+rcv_select[i].id+`">`);
		}
	}
	var mailrEmpnoListInputs = $('input[name="mailrEmpnoList"]');

	// 값을 저장할 배열을 생성
	var values = [];

	// 각 입력 요소에서 값을 가져와 배열에 추가
	mailrEmpnoListInputs.each(function() {
	    values.push($(this).val());
	});

	// 배열에 저장된 값 출력
	console.log(values);

	rcv_modal.hide();
});

$(".rcv_setAll").on("click", function(){
	var value = $(this).data("value"); // data-value 값을 가져옵니다.
	console.log(value);
	if(value == "openStatus"){
		if(!rcv_openFlag){
			rcv_openFlag = true;
			rcv_treeContent.jstree("open_all");
		}else{
			rcv_openFlag = false;
			rcv_treeContent.jstree("close_all");
		}
	}
	if(value == "checkStatus"){
		if(!rcv_checkFlag){
			rcv_checkFlag = true;
			rcv_treeContent.jstree("check_all");
		}else{
			rcv_checkFlag = false;
			rcv_treeContent.jstree("uncheck_all");
		}
	}	
});

////////////////// 받는 직원 추가 조직도 끝 ////////////////////

////////////////// 참조 직원 추가 조직도 시작 //////////////////
let ref_treeContent;
let ref_select; // 선택된 사람들이 객체로 들어있음
let ref_modal;
let ref_openFlag = false;
let ref_checkFlag = false;

$("#refBtn").on("click", function(){
	ref_treeContent = $("#refModal .modal-body > p");
	ref_treeContent.jstree({
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
	
	ref_treeContent.bind("loaded.jstree", function(e, data) {
		console.log("트리 로딩 완료");
		var model = ref_treeContent.jstree(true)._model.data;
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
							ref_treeContent.jstree(true).create_node(idata.id, result[i], "last", function(){
								console.log("노드 생성 성공");
							});
						}
					}
				}
			});
		});
	}.bind(this));
	
	// 해당 id의 노드를 open 상태로 바꿉니다.
	ref_treeContent.on("ready.jstree", function(){
		$(this).jstree("open_node", "#"); // 이 경우 id가 1번인 root노드를 열린 상태로 로드함
	});
	
	ref_treeContent.on("changed.jstree", function (e, data) {
	    console.log("changed id : " + data.node.id);
	    console.log("changed node childeren : " + data.node.children);
	});
	
	ref_treeContent.bind("select_node.jstree", function (e, data) {
		console.log("select id : " + data.node.id);
		console.log("select node childeren : " + data.node.children);
	});

	var to = false;
	$('#ref_search_input').keyup(function () {
	    if(to) { clearTimeout(to); }
	    to = setTimeout(function () {
	      var v = $('#ref_search_input').val();
	      ref_treeContent.jstree(true).search(v);
	    }, 250);
	});
	
	ref_modal = new window.bootstrap.Modal(refModal);
	ref_modal.show();
});

$("#ref_selectTree").on("click", function(){
	ref_select = ref_treeContent.jstree('get_selected',true);
	console.log(ref_select); // 선택된 사람들 리스트
// 	console.log("선택된 사람[0] 아이디 : " + ref_select[0].id);
// 	console.log("선택된 사람[0] 이름 : " + ref_select[0].text);
// 	console.log("선택된 사람[0] 부서 : " + ref_select[0].original.deptVO);
	
	$("#refPlace").text(""); // 페이지의 참조자 지워주고
	
	for(var i = 0; i < ref_select.length; i++){
		if(ref_select[i].original.deptVO != null){ // 팀 제외한 직원만 추가
			$("#refPlace").append(`<span class="btn btn-sm btn-phoenix-secondary rounded-pill me-1 mb-1">`+ref_select[i].text+`/`+ref_select[i].original.deptVO.text+`</span>`);
			$("#refPlace").append(`<input type="hidden" name="mailrefEmpnoList" value="`+ref_select[i].id+`">`);
		}
	}

	ref_modal.hide();
});

$(".ref_setAll").on("click", function(){
	var value = $(this).data("value"); // data-value 값을 가져옵니다.
	console.log(value);
	if(value == "openStatus"){
		if(!ref_openFlag){
			ref_openFlag = true;
			ref_treeContent.jstree("open_all");
		}else{
			ref_openFlag = false;
			ref_treeContent.jstree("close_all");
		}
	}
	if(value == "checkStatus"){
		if(!ref_checkFlag){
			ref_checkFlag = true;
			ref_treeContent.jstree("check_all");
		}else{
			ref_checkFlag = false;
			ref_treeContent.jstree("uncheck_all");
		}
	}	
});

////////////////// 참조 직원 추가 조직도 끝 ////////////////////

</script>