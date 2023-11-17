<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<div class="row">
	<div class="col-12">
		<h2>&nbsp;나에게 메일보내기&nbsp;&nbsp;&nbsp;<button class="btn btn-info me-1 mb-1" type="button" id="myselfBtn">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;메일보내기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</button></h2>
	</div>
</div>
<div class="email-container pt-5">
	<div class="row g-lg-6 mb-8">
		<div class="col-12">
			<div class="card email-content">
				<div class="card-body">
					<form class="d-flex flex-column h-100" id="sendMailForm">
						<div class="row g-3 mb-2">
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

<!-- jstree cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<script type="text/javascript">
$(function(){
	CKEDITOR.replace('mailContent', {height: 340});
});

$(document).on('click', '#myselfBtn', function(){
	location.href="/sendmail.do";
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

	  CKEDITOR.replace('editor');
	  
	  var editor = CKEDITOR.instances.mailContent.getData(); // 에디터 인스턴스 가져오기
	  
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
		
	  // 배열에 저장된 값 출력
	  console.log("메일 제목 : "+mailTitle);
	  console.log("메일 내용 : "+editor);

	 
	  $.ajax({
	        url: '/sendMailToMeForm.do',
	        type: 'POST',
	        data: formData,
	        contentType: false,
	        processData: false,
	        success: function(result) {
	            location.href="/receivedmyselfmail.do";
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

</script>