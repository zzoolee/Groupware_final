<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<script src="https://code.jquery.com/jquery-3.6.4.min.js 
" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
<style>
.fileSelctBox {
    margin-top: 0.25rem !important;
    margin-right: 0.5em !important;
}
</style>
<c:if test="${ not empty folderDup }">
<script>
	alert('${folderDup }');
</script>
</c:if>

<c:if test="${ not empty fileDup }">
<script>
	alert('${fileDup }');
</script>
</c:if>

<c:if test="${ not empty deleteMessage }">
<script>
	alert('${deleteMessage }');
</script>
</c:if>

<c:if test="${ not empty deleteMessageRa }">
<script>
	alert('${deleteMessageRa }');
</script>
</c:if>


<!-- <div class="email-container"> -->

<!-- 	<div class="row"> -->
<!-- 		<div class="col-8"> -->

<h2>업로드요청목록</h2>
<span style="font-weight: bolder;">관리자의 승인을 대기중인<span style="color: blue;"> 업로드 요청 목록</span>입니다.</span>

	<div class="row gx-lg-6 gx-3 z-index-2 position-sticky bg-soft email-header">
			
		<div class="card mt-7" style="padding: 40px; padding-left: 130px; padding-right: 150px;">	
		
		<div class="col-8"></div>
			<div class="row">
			<div class="col-6 px-7 pb-5">
				<div class="d-felx text-start">
					<button class="uil-folder-open btn btn-outline-warning" type="button" id="apprBtn">전사자료실</button>
				</div>
			</div>
			</div>

	<div class="row mb-8">
		<div class="col-lg-auto">
			<div class="phoenix-offcanvas-backdrop d-lg-none"
				data-phoenix-backdrop="data-phoenix-backdrop" style="top: 0;"></div>
		</div>
		<div class="col-lg">
			<div class="px-lg-1">
			
			
				<div class="border-top border-200 py-2 fw-bold">
					<div class="col-auto">
						<div class="form-check d-flex flex-column flex-sm-row justify-align-center">
								<div class="ms-5 col-auto">
								</div>
								<div class="col-auto"></div>
								<div class="" style="width: 660px;"></div>
								<div class="col-2 text-end">파일크기</div>
								<div class="col-3 text-end">업로드 날짜</div>
						</div>
					</div>
				</div>
				
				
				
				<div class="border-top border-200 hover-actions-trigger py-3" id="folderFileDiv">

					<sec:authentication property="principal.Username" var="userName"/>
					<!--  파일위치  -->
					<c:forEach var="file" items="${fileList }">
						<input type="hidden" name="fileCd" value="${file.fileCd }" id="${file.fileCd }">
					<div class="row align-items-sm-center gx-2 <c:if test="${file.fileApprse eq 1 }">bg-light</c:if>">
						<div class="col-auto">
							<div class="d-flex flex-column flex-sm-row justify-align-center">
								<c:if test="${file.fileApprse eq 1 }">
									<button class="btn p-0">
									<span>&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
									</button>
								</c:if>
								<c:if test="${file.fileApprse eq 2 }">
									<input class="form-check-input mb-2 m-sm-0 me-sm-2 fileSelctBox"
									type="checkbox" id="checkbox-1" data-value="${file.fileCd }"
									data-bulk-select-row="data-bulk-select-row"/>
									<button class="btn p-0">
									<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
									</button>
								</c:if>
							</div>
						</div>
						
						
						
						<div class="col-auto">
							<div class="avatar avatar-s  rounded-circle">
								<span class="uil uil-file fs-1"></span>
							</div>
						</div>
						<div class="col-6">
							<span class="text-1100 inbox-link fileSelect" data-value="${file.fileCd }" style="cursor:pointer">${file.fileOrgname }.${file.fileType }
							<c:if test="${file.fileApprse eq 1 }">
								<span class="text-danger fw-bold">&nbsp;&nbsp;(승인대기중)</span>
							</c:if>
							</span>
							<c:if test="${file.fileApprse eq 1}">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button class="uil-circle btn btn-outline-info resYes" type="button" data-value="${file.fileCd }" data-name="${file.empNo }">승인</button>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button class="uil-ban btn btn-outline-danger resNo" type="button" data-value="${file.fileCd }" data-name="${file.empNo }">반려</button>
							</c:if>
						</div>
						<div class="col-2 text-end">
							<span>${file.fileSize }KB</span>
						</div>
						<fmt:formatDate value="${file.fileUploaddt }" var="fileUploaddt" pattern="yyyy-MM-dd HH:mm"/>
						<div class="col-3 text-end">
							<span>${fileUploaddt }</span>
						</div>
					</div>
					
					<div class="row align-items-sm-center gx-2 bg-light">
						<div class="col-auto">
							<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
							<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
							<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
							<span class="text-1100 inbox-link fw-bold">파일 위치 : ${file.fileSavepath }</span>
						</div> 
					</div>
					
					<hr/>
					</c:forEach>
					</div>
				</div>
			</div>
			</div>
		</div>
	</div>
</div>	
	

<!-- 반려 모달. -->
<form action="/refuseFile.do" method="POST" id="refuseFileForm">
<div class="modal fade" id="refuseModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">I-WORKS</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0 pb-2 px-1">반려사유를 입력해주세요</p>
        <div>
        	<input class="form-control" id="refuseContent" placeholder="사유 등록" name="refuseContent"/>
        	<input type="hidden" name="fileCdForm" value="" id="fileCdForm" />
        	<input type="hidden" name="empNoForm" value="" id="empNoForm" />
        	<input type="hidden" value="appr" name="appr">
        </div>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" id="refuseOkayBtn">확인</button>
      <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal" id="refuseCancleBtn">취소</button></div>
    </div>
  </div>
</div>

<c:if test="${not empty parentCd }">
	<input type="hidden" value="${parentCd.folderCd }" name="folderParent">
</c:if>
</form>

<!-- 폴더이름을 저장할 모달. -->
<form action="/insertComFolderAdmin.do" method="POST" id="folderNameForm">
<div class="modal fade" id="folderModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">I-WORKS</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0 pb-2 px-1">원하시는 폴더명을 입력하세요</p>
        <div>
        	<input class="form-control" id="folderName" placeholder="폴더명 입력" name="folderName"/>
        </div>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" id="modalOkayBtn">확인</button>
      <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal" id="modalCancleBtn">취소</button></div>
    </div>
  </div>
</div>

<c:if test="${not empty parentCd }">
	<input type="hidden" value="${parentCd.folderCd }" name="folderParent">
</c:if>
</form>

<!-- 파일 넘기기 -->
<form action="/insertComFileAdmin.do" method="POST" id="fileNameForm" enctype="multipart/form-data">
<div class="modal fade" id="fileModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">I-WORKS</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0 pb-2 px-1">첨부할 파일을 선택해주세요</p>
        <div class="mb-3">
  			<input class="form-control form-control-sm" id="customFileSm" type="file" name="foFile" multiple="multiple"/>
		</div>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal" id="modalFileOkayBtn">확인</button>
      <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal" id="modalFileCancleBtn">취소</button></div>
    </div>
  </div>
</div>

<!-- 미리보기를 띄워줄 모달 -->
<div class="modal fade" id="showPictureModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">이미지 미리보기</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body d-flex justify-content-center align-items-center">
        <div class="mb-3 imgDiv" id="imgDiv">
  			
		</div>
      </div>
      <div class="modal-footer">
      <button class="btn btn-info downloadFileBtn" type="button" id="downloadFileBtn">다운로드</button>
      <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal" id="modalFileCancleBtn">취소</button></div>
    </div>
  </div>
</div>


<!-- 파일형식의 미리보기 href로 태그로 문서자체를 보여준다 -->
<div class="modal fade" id="showFileModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">파일 미리보기</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body d-flex justify-content-center align-items-center">
        <div class="mb-3 imgDiv" id="imgDiv">
        	
		</div>
      </div>
      <div class="modal-footer">
      <button class="btn btn-info downloadFileBtn" type="button" id="downloadFileBtn">다운로드</button>
      <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal" id="modalFileCancleBtn">취소</button></div>
    </div>
  </div>
</div>


<!-- 미리보기도안되고, href로도 안되는 애들 -->
<div class="modal fade" id="noShowFileModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">파일 미리보기</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body d-flex justify-content-center align-items-center">
        <div class="mb-3" id="imgDiv">
        	<span>해당파일은 미리보기가 불가능합니다.</span>
		</div>
      </div>
      <div class="modal-footer">
      <button class="btn btn-info downloadFileBtn" type="button" id="downloadFileBtn">다운로드</button>
      <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal" id="modalFileCancleBtn">취소</button></div>
    </div>
  </div>
</div>



<c:if test="${not empty parentCd }">
	<input type="hidden" value="${parentCd.folderCd }" name="folderParent">
</c:if>
</form>

<!-- 체크박스 선택된 애들의 알집 다운로드 -->
<form action="fileAlzip.do" method="POST" id="selectBoxForm">
	<input type="hidden" value="" name="folderArray" class="folderSelectArray"/>
	<input type="hidden" value="" name="fileArray" class="fileSelectArray"/>
</form>

<!-- 체크박스 선택된 애들의 삭제 폼 -->
<form action="/comFileDeleteAdmin.do" method="POST" id="selectBoxDelForm">
	<input type="hidden" value="" name="folderArray" class="folderSelectArray"/>
	<input type="hidden" value="" name="fileArray" class="fileSelectArray"/>
	<input type="hidden" value="${parentCd.folderCd }" name="folderParent" id="folderParent">
</form>

<input type="hidden" value="true" id="checkFlag" />
<form action="/comSelectBackAdmin.do" method="post" id="backForm">
	<input type="hidden" value="${parentCd.folderCd }" name="folderParent">
</form>

<!-- 승인처리 -->
<form action="/comFileResYes.do" method="POST" id="comFileResYesForm">
	<input type="hidden" value="" name="fileCd" id="comFileResYesFileCd">
	<input type="hidden" value="" name="empNo" id="comFileResYesEmpNo">
	<input type="hidden" value="appr" name="appr">
</form>

<script>
$(function(){
	
// 	$(document).on("click","#test",function(){
// 	})
	var resFolderBtn = $('#resFolderBtn');
	var resFileBtn = $('#resFileBtn');
	var folderModal = $('#folderModal');
	var fileModal = $('#fileModal');
	var folderName = $('#folderName');
	var modalOkayBtn = $('#modalOkayBtn');
	var modalCancleBtn = $('#modalCancleBtn');
	var folderNameForm = $('#folderNameForm');	
	var folderSelect = $('.folderSelect');
	var fileSelect = $('.fileSelect');
	var modalFileOkayBtn = $('#modalFileOkayBtn');
	var fileNameForm = $('#fileNameForm');
	var reg = /[\{\}\[\]\/?.,;:|\)*~`!^\-+<>@\#$%&\\\=\(\'\"]/g;
	var blank_pattern = /[\s]/g;
	var fileCd = $('#fileCd');
	
	$(document).on("click","#atStartBtn", function(){
		location.href="/adminComfiles.do";
	})
	
	$(document).on('click', '#backBtn', function(){
		$('#backForm').submit();
	});
	
	
	
	$(document).on("click","#basicSort",function(){
// 	basicSort.on('click', function(){
		 $('#folderFileDateBasic').submit();
	});
	
	$(document).on("click","#DateSort",function(){
// 	DateSort.on('click'. function({
		$('#folderFileDateForm').submit();
	});
	
	var searchBar = $('#searchBar');
	var folderFileDiv = $('#folderFileDiv');
	
	var submitFileCd = "";
	var allCheckBox = $('#allCheckBox');
	var checkBoxFlag = true;
	
	var folderSelectBox = $('.folderSelectBox');
	var fileSelctBox = $('.fileSelctBox');
	

	
	var showPictureModal = $('#showPictureModal');
	var showFileModal = $('#showFileModal');
	var noShowFileModal = $('#noShowFileModal');
	
	$(document).on("click",'.fileSelect',function(){
// 	fileSelect.on('click', function(){
		// 이미지를 넣어줄 Div공간을 미리 선택자로 변수선언.
		var imgDiv = $('.imgDiv');
		var images = ["jpg","jpeg","jfif","gif","png"]
		var canViewFile = ["pdf"]
		console.log($(this).data('value'));
		// 사진파일을 다운로드할 수 있게 해주는 로직
		// 정확히는 다운로드가 아니고 전역변수에 value값을 미리 저장해준다.
		submitFileCd = $(this).data('value');
		console.log(submitFileCd);
		// 선택자로 변수에 넣은 submitFileCd값을 보내줄 변수
		var fileItem = {
				"submitFileCd" : submitFileCd
		}
		contentType : "application/json; charset=utf-8",
		
		$.ajax({
			type : "POST",
			url : "imageFileInfoAjax.do",
			data : JSON.stringify(fileItem),
			// 컨텐트타입엔 제이슨을 선언해주고, utf-8인코딩 형식을 선언.
			contentType : "application/json; charset=utf-8",
			success : function(result) {
				if(images.includes(result.imageVO.fileType)){
					console.log("이미지입니다.")
					imgDiv.html('');
					imgDiv.html('<img src="'+result.imageVO.fileSavepath
								+result.imageVO.fileSavename+'" style="max-width: 100%;">');
					showPictureModal.modal('show');
					
				} else if (canViewFile.includes(result.imageVO.fileType)) {
					console.log("a태그를 통해 볼수있는 파일입니다.")
					imgDiv.html('');
					imgDiv.html('<a class="uil-monitor btn btn-outline-info" href="'+result.imageVO.fileSavepath
								+result.imageVO.fileSavename+'" target="_blank" id="fileViewBtn">파일 미리보기</a>');
					showFileModal.modal('show');
				} else {
					console.log("아무고토모타는 파일입니다.")
					noShowFileModal.modal('show');
				}
			}
		})
		
	});
	
	var downloadFileBtn = $('.downloadFileBtn');
	
	$(document).on("click",'#downloadFileBtn',function(){
// 	downloadFileBtn.on('click', function(){
		location.href="/comFileDownload.do?submitFileCd="+submitFileCd;
	});
	
	
	$(document).on("click",'#resFolderBtn',function(){
// 	resFolderBtn.on('click', function(){
		folderModal.modal('show');		
	});
	
	var empNoData = "";
	var fileCdData = "";
	$(document).on('click', '.resYes', function(){
		empNoData = $(this).data('name');
		fileCdData = $(this).data('value');
		customConfirm('해당파일을 승인처리 하시겠습니까?').then((userConfirmed) => {
	          if (userConfirmed) {
	        	$('#comFileResYesFileCd').val(fileCdData);
	        	$('#comFileResYesEmpNo').val(empNoData);
				$('#comFileResYesForm').submit();
	          }else {
	        	return false;  
	          }
		})
	})
	
	$(document).on('click', '.resNo', function(){
		empNoData = $(this).data('name');
		fileCdData = $(this).data('value');		
		customConfirm('해당파일을 반려처리 하시겠습니까?').then((userConfirmed) => {
	          if (userConfirmed) {
	        	  $('#refuseModal').modal('show');
	          }else {
	        	return false;
	          }
		})
	})
	
	$(document).on('click', '#refuseOkayBtn', function(){
		$('#empNoForm').val(empNoData);
		$('#fileCdForm').val(fileCdData);
		$('#refuseFileForm').submit();
	});
	
	$(document).on('keydown', '#refuseContent', function(key){	
		if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
			$('#empNoForm').val(empNoData);
			$('#fileCdForm').val(fileCdData);
			$('#refuseFileForm').submit();
	        }
	});
	
	$(document).on('click', '#apprBtn', function(){
		location.href="/adminComfiles.do"
	});
});
</script>


















