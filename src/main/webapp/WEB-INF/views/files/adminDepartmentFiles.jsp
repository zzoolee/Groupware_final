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

<!-- <div class="email-container"> -->

<!-- 	<div class="row"> -->
<!-- 		<div class="col-8"> -->
<sec:authentication property="principal.emp" var="emp"/>
<h2>부서자료실</h2>
<span style="font-weight: bolder;">${emp.empName }님의 <span style="color: blue;">부서 자료실</span>입니다.</span>

<!-- 		</div> -->
<!-- 	</div> -->
	
<!-- 	</div> -->
	<div class="row gx-lg-6 gx-3 z-index-2 position-sticky bg-soft email-header">
<!-- 		<div class="col-auto d-lg-none"> -->
<!-- 			<a class="btn btn-primary px-3 px-sm-4" -->
<!-- 				href="../../apps/email/compose.html"> <span -->
<!-- 				class="d-none d-sm-inline-block">Compose</span><span -->
<!-- 				class="d-sm-none fas fa-plus"></span></a> -->
<!-- 		</div> -->
		
		<div class="card mt-7" style="padding: 40px; padding-left: 130px; padding-right: 150px;">
		<div class="d-flex justify-content-center">
			<div class="search-box" style="width: 500px;">
				<form class="position-relative" data-bs-toggle="search"
					data-bs-display="static">
					<input class="form-control search-input search" type="text"
						placeholder="Search ..." aria-label="Search" id="searchBar"/> <span
						class="fas fa-search search-box-icon"></span>
				</form>
			</div>
		</div>
<!-- 		<div class="row"> -->
<!-- 		<div class="col-8"></div> -->
			<div class="d-felx text-end">
				
				<input id="fileInput" type="file" style="display:none"/>
				<button class="uil-folder-plus btn btn-info" type="button" id="resFolderBtn">폴더생성</button>
				<button class="uil-file-upload btn btn-outline-info" type="button" id="resFileBtn">파일업로드</button>
				
				
				
			</div>
			<div class="d-flex justify-content-end pt-3">
				<select class="form-select form-select-sm mb-3" data-list-filter="data-list-filter" style="width:18%" id="deptSelect">
					<option value="부서전체조회">부서를 선택해주세요</option>
					
					<option value="A011" <c:if test="${deptCd eq 'A011'}">selected=""</c:if>>경영지원팀</option>
					<option value="A012" <c:if test="${deptCd eq 'A012'}">selected=""</c:if>>인사총무팀</option>
					<option value="A013" <c:if test="${deptCd eq 'A013'}">selected=""</c:if>>구매조달팀</option>
					<option value="A014" <c:if test="${deptCd eq 'A014'}">selected=""</c:if>>콜센터</option>
					<option value="B011" <c:if test="${deptCd eq 'B011'}">selected=""</c:if>>시스템영업팀</option>
					<option value="B012" <c:if test="${deptCd eq 'B012'}">selected=""</c:if>>공공영업팀</option>
					<option value="B013" <c:if test="${deptCd eq 'B013'}">selected=""</c:if>>기술지원팀</option>
					<option value="B014" <c:if test="${deptCd eq 'B014'}">selected=""</c:if>>교육운영팀</option>
					<option value="C011" <c:if test="${deptCd eq 'C011'}">selected=""</c:if>>보안개발팀</option>
					<option value="C012" <c:if test="${deptCd eq 'C012'}">selected=""</c:if>>SW개발팀</option>
					<option value="D011" <c:if test="${deptCd eq 'D011'}">selected=""</c:if>>사업기획팀</option>
					<option value="D012" <c:if test="${deptCd eq 'D012'}">selected=""</c:if>>SM영업1팀</option>
					<option value="D013" <c:if test="${deptCd eq 'D013'}">selected=""</c:if>>SM영업2팀</option>
					<option value="D014" <c:if test="${deptCd eq 'D014'}">selected=""</c:if>>서비스센터</option>
					<option value="E011" <c:if test="${deptCd eq 'E011'}">selected=""</c:if>>수도권</option>
					<option value="E012" <c:if test="${deptCd eq 'E012'}">selected=""</c:if>>중부권</option>
					<option value="E013" <c:if test="${deptCd eq 'E013'}">selected=""</c:if>>서부권</option>
					<option value="E014" <c:if test="${deptCd eq 'E014'}">selected=""</c:if>>동부권</option>
					<option value="F01" <c:if test="${deptCd eq 'F01'}">selected=""</c:if>>연구개발본부</option>
				</select>
			</div>
<!-- 		</div> -->
<!-- 	</div> -->
	<div class="row">
<%-- 		<c:if test="${not empty back }"> --%>
<!-- 		<div class="col-2"> -->
		
<!-- 			<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> -->
<!-- 			<button class="btn btn-info me-1 mb-1" type="button" id="backBtn"><</button> -->
<!-- 			<button class="btn btn-info me-1 mb-1" type="button" id="atStartBtn">처음으로</button> -->
		
<!-- 		</div> -->
<!-- 			<div class="col-8"> -->
<%-- 		</c:if> --%>
<%-- 		<c:if test="${empty back }"> --%>
<!-- 			<div class="col-10"> -->
<%-- 		</c:if> --%>
			<h5 class="pt-3 text-500"><c:if test="${empty back }">
			</c:if>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;현재 경로&nbsp;:&nbsp;부서자료실${parentCd.folderOwnPath }</h5>
		
		</div>
	<div style="display: flex;">
			<c:if test="${not empty back }">
				<div class="col-9">
					<button class="uil-arrow-circle-left btn btn-link ms-2 fs-0" type="button" id="backBtn">이전</button>
					<button class="btn btn-link fs-0" type="button" id="atStartBtn">처음으로</button>
				</div>
			</c:if>
			<c:if test="${empty back }">
				<div class="col-9"></div>
			</c:if>
		<div style="display: flex;" class="ms-12">
			<form action="/depSelectChildFileBasicAdmin.do" method="POST" id="folderFileDateBasic">
				<button class="uil-arrow-down btn btn-link fs-0" type="button" id="basicSort">기본순</button>
				<input type="hidden" value="${parentCd.folderCd }" name="folderParent">
			</form>
			<form action="/depSelectChildFileDateAdmin.do" method="POST" id="folderFileDateForm">
				<button class="uil-arrow-up btn btn-link fs-0" type="button" id="DateSort">최신순</button>
				<input type="hidden" value="${parentCd.folderCd }" name="folderParent">
			</form>
		</div>	
	</div>
	
	<div class="row mb-8">
		<div class="col-lg-auto">
			<div class="phoenix-offcanvas-backdrop d-lg-none"
				data-phoenix-backdrop="data-phoenix-backdrop" style="top: 0;"></div>
		</div>
		<div class="col-lg">
			<div class="px-lg-1">
<!-- 				<div class="d-flex align-items-center flex-wrap position-sticky pb-2 z-index-2 email-toolbar inbox-toolbar"> -->
<!-- 					<div class="d-flex align-items-center flex-1 me-2"></div> -->
<!-- 					<div class="d-flex"> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 				<div class="border-top border-200 py-2 d-flex justify-content-between"> -->
<!-- 					<div class="form-check mb-0 text-1100 fw-bold"> -->
<!-- 						<input class="form-check-input" type="checkbox" -->
<!-- 							data-bulk-select-row="data-bulk-select-row" id="allCheckBox" /> -->
<!-- 						<div class="ms-4"> -->
<!-- 							<button class="btn p-0 me-2 text-500 hover-text-600" -->
<!-- 								data-bs-toggle="tooltip" data-bs-placement="top" -->
<!-- 								data-bs-title="공유" id="shareBtn"> -->
<!-- 								<span class="uil uil-share-alt fs-1 fw-bold"></span> -->
<!-- 							</button> -->
<!-- 							<button class="btn p-0 me-2 text-500 hover-text-600" -->
<!-- 								data-bs-toggle="tooltip" data-bs-placement="top" -->
<!-- 								data-bs-title="다운로드" id="folderFileBtn"> -->
<!-- 								<span class="uil uil-download-alt fs-1 fw-bold"></span> -->
<!-- 							</button> -->
<!-- 							<button class="btn p-0 text-500 hover-text-600" -->
<!-- 								data-bs-toggle="tooltip" data-bs-placement="top" -->
<!-- 								data-bs-title="삭제" id="deleteFileBtn"> -->
<!-- 								<span class="uil uil-trash fs-1 fw-bold"></span> -->
<!-- 							</button> -->
<!-- 						</div> -->
<!-- 					</div> -->
<!-- 				</div> -->
				
				<div class="border-top border-200 py-2 fw-bold">
					<div class="col-auto">
						<div class="form-check d-flex flex-column flex-sm-row justify-align-center">
							<input class="form-check-input" type="checkbox"	
									data-bulk-select-row="data-bulk-select-row" id="allCheckBox"/>
								<div class="ms-5 col-auto">
									<button class="btn p-0 me-2 text-500 hover-text-600"
										data-bs-toggle="tooltip" data-bs-placement="top"
										data-bs-title="다운로드" id="folderFileBtn">
										<span class="uil uil-download-alt fs-1 fw-bold"></span>
									</button>
									<button class="btn p-0 text-500 hover-text-600"
										data-bs-toggle="tooltip" data-bs-placement="top"
										data-bs-title="삭제" id="deleteFileBtn">
										<span class="uil uil-trash fs-1 fw-bold"></span>
									</button>
								</div>
								<div class="col-auto"></div>
								<div class="" style="width: 600px;"></div>
								<div class="col-2 text-end">파일크기</div>
								<div class="col-3 text-end">업로드 날짜</div>
						</div>
					</div>
				</div>
				
				
				<div class="border-top border-200 hover-actions-trigger py-3" id="folderFileDiv">
					<!-- 폴더위치 -->
					<c:forEach var="folder" items="${FolderList }">
					<form action="/adminDepfiles.do" method="POST" id="${folder.folderName }">
					<input type="hidden" value="${folder.folderCd }" name="folderCd">
					<input type="hidden" value="${folder.folderSe }" name="folderSe">
					<input type="hidden" value="${folder.empNo }" name="empNo">
					<input type="hidden" value="${folder.folderName }" name="folderName">
					<input type="hidden" value="${folder.folderParent }" name="folderParent">
					<input type="hidden" value="${folder.folderDelse }" name="folderDelse">			
					<div class="row align-items-sm-center gx-2">
						<div class="col-auto">
							<div class="d-flex flex-column flex-sm-row">
								<input class="form-check-input mb-2 m-sm-0 me-sm-2 folderSelectBox"
									type="checkbox" id="checkbox-1" data-value="${folder.folderCd }"
									data-bulk-select-row="data-bulk-select-row" value="${folder.folderName }"/>
								<button class="btn p-0">
									<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</button>
							</div>
						</div>
						<div class="col-auto">
							<div class="avatar avatar-s  rounded-circle">
								<span class="uil uil-folder fs-1"></span>
							</div>
						</div>
						<div class="col-6">
							<a class="text-1100 inbox-link  folderSelect" id="${folder.folderName }" style="cursor:pointer">${folder.folderName }</a>
						</div>
						<div class="col-2 text-end">
							<span>${folder.folderSize }KB</span>
						</div>
						<fmt:formatDate value="${folder.folderUploaddt }" var="folderUploaddt" pattern="yyyy-MM-dd HH:mm"/>
						<div class="col-3 text-end">
							<span>${folderUploaddt }</span>
						</div>
					</div>
					<hr/>
					</form>
					</c:forEach>


					<!--  파일위치  -->
					<c:forEach var="file" items="${fileList }">
					<input type="hidden" value="${file.fileCd }" id="${file.fileCd }">
					<div class="row align-items-sm-center gx-2">
						<div class="col-auto">
							<div class="d-flex flex-column flex-sm-row justify-align-center">
								<input class="form-check-input mb-2 m-sm-0 me-sm-2 fileSelctBox"
									type="checkbox" id="checkbox-1" data-value="${file.fileCd }"
									data-bulk-select-row="data-bulk-select-row"/>
									<button class="btn p-0">
									<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</button>
							</div>
						</div>
						<div class="col-auto">
							<div class="avatar avatar-s rounded-circle">
								<span class="uil uil-file fs-1"></span>
							</div>
						</div>
						<div class="col-6">
							<span class="text-1100 inbox-link  fileSelect" data-value="${file.fileCd }" style="cursor:pointer">${file.fileOrgname }.${file.fileType }</span>
						</div>
						<div class="col-2 text-end">
							<span>${file.fileSize }KB</span>
						</div>
						<fmt:formatDate value="${file.fileUploaddt }" var="fileUploaddt" pattern="yyyy-MM-dd HH:mm"/>
						<div class="col-3 text-end">
							<span>${fileUploaddt }</span>
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
	
<!-- 폴더이름을 저장할 모달. -->
<form action="/insertDepFolderAdmin.do" method="POST" id="folderNameForm">
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
      <div class="modal-footer">
      <button class="btn btn-info" type="button" id="modalOkayBtn">확인</button>
      <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal" id="modalCancleBtn">취소</button></div>
    </div>
  </div>
</div>

<c:if test="${not empty parentCd }">
	<input type="hidden" value="${parentCd.folderCd }" name="folderParent">
</c:if>
</form>

<!-- 파일 넘기기 -->
<form action="/insertDepFileAdmin.do" method="POST" id="fileNameForm" enctype="multipart/form-data">
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
      <div class="modal-footer">
      <button class="btn btn-info" type="button" data-bs-dismiss="modal" id="modalFileOkayBtn">확인</button>
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

<div class="fade" id = "fileFadeDiv">

</div> 


<!-- 파일형식의 미리보기 href로 태그로 문서자체를 보여준다 -->
<div class="modal fade" id="showFileModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered ">
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
  <div class="modal-dialog modal-dialog-centered ">
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
<form action="/depFileDeleteAdmin.do" method="POST" id="selectBoxDelForm">
	<input type="hidden" value="" name="folderArray" class="folderSelectArray"/>
	<input type="hidden" value="" name="fileArray" class="fileSelectArray"/>
	<input type="hidden" value="${parentCd.folderCd }" name="folderParent" id="folderParent">
</form>

<input type="hidden" value="true" id="checkFlag" />
<form action="/depSelectBackAdmin.do" method="post" id="backForm">
	<input type="hidden" value="${parentCd.folderCd }" name="folderParent">
</form>
<form action="/depChange.do" method="POST" id="depChangeForm">
	<input type="hidden" value="" name="deptCd" id="dept">
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
		location.href="/adminDepfiles.do";
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
	
	$(document).on("keyup","#searchBar",function(){
// 	searchBar.on('keyup', function(){
		var searchText = searchBar.val();
		var folderParent = $("#folderParent").val();
		console.log(searchText);
		var str = "";
		var searchData = {
				"searchText" : searchText,
				"folderParent" : folderParent
		}
		 $.ajax({
			type : "POST",
			url : "/searchAjax.do",
			data : JSON.stringify(searchData),
			contentType : "application/json; charset=utf-8",
			success:function(result) {
				console.log('에이잭스 결과값 반환되었음.')
				folderFileDiv.html('');
				result.folderList.forEach(function(item){
					str +='<form action="/depfiles.do" method="POST" id="'+item.folderName+'">';
					str +='<input type="hidden" value="'+item.folderCd+'" name="folderCd">';
					str +='<input type="hidden" value="'+item.folderSe+'" name="folderSe">';
					str +='<input type="hidden" value="'+item.empNo+'" name="empNo">';
					str +='<input type="hidden" value="'+item.folderName+'" name="folderName">';
					str +='<input type="hidden" value="'+item.folderParent+'" name="folderParent">';
					str +='<input type="hidden" value="'+item.folderDelse+'" name="folderDelse">';
					str +='<div class="row align-items-sm-center gx-2">';
					str +='<div class="col-auto">';
					str +='<div class="d-flex flex-column flex-sm-row">';
					str +='<input class="form-check-input mb-2 m-sm-0 me-sm-2 folderSelectBox"';
					str +='type="checkbox" id="checkbox-1" data-value="'+item.folderCd+'"';
					str +='data-bulk-select-row="data-bulk-select-row" value="'+item.folderName+'"/>';
					str +='<button class="btn p-0">';
					str +='<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>';
					str +='</button>';
					str +='</button>';
					str +='</div>';
					str +='</div>';
					str +='<div class="col-auto">';
					str +='<div class="avatar avatar-s  rounded-circle">';
					str +='<span class="uil uil-folder fs-1"></span>';
					str +='</div>';
					str +='</div>';
					str +='<div class="col-auto">';
					str +='<a class="text-1100 inbox-link folderSelect" id="'+item.folderName+'" style="cursor:pointer">'+item.folderName+'</a>';
					str +='</div>';
					str +='</div>';
					str +='<hr/>';
					str +='</form>';
				})
				result.fileList.forEach(function(item){
					str +='<input type="hidden" value="'+item.fileCd+'" id="'+item.fileCd+'">';
					str +='<div class="row align-items-sm-center gx-2">';
					str +='<div class="col-auto">';
					str +='<div class="d-flex flex-column flex-sm-row justify-align-center">';
					str +='<input class="form-check-input mb-2 m-sm-0 me-sm-2 fileSelctBox"';
					str +='type="checkbox" id="checkbox-1" data-value="'+item.fileCd+'"';
					str +='data-bulk-select-row="data-bulk-select-row"/>';
					str += '<button class="btn p-0">';
					str += '<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>';
					str += '</button>';
					str +='</div>';
					str +='</div>';
					str +='<div class="col-auto">';
					str +='<div class="avatar avatar-s  rounded-circle">';
					str +='<span class="uil uil-file fs-1"></span>';
					str +='</div>';
					str +='</div>';
					str +='<div class="col-auto">';
					str +='<span class="text-1100 inbox-link fileSelect" data-value="'+item.fileCd+'" style="cursor:pointer">'+item.fileOrgname+'.'+item.fileType+'</span>';
					str +='</div>';
					str +='</div>';
					str +='<hr/>';
				})
				folderFileDiv.html(str);
			}
		 });
	});
	
	
	var submitFileCd = "";
	var allCheckBox = $('#allCheckBox');
	var checkBoxFlag = true;
	
	var folderSelectBox = $('.folderSelectBox');
	var fileSelctBox = $('.fileSelctBox');
	
	// 전체체크박스 처리
	$(document).on("click",'#allCheckBox',function(){
// 	allCheckBox.on('change', function() {
		  if ($('#checkFlag').val() == "true") {
		    console.log("트루");
		    $('.folderSelectBox').prop('checked', true);
		    $('.fileSelctBox').prop('checked', true);
		    $('#checkFlag').val('false');
		    fileSelctBox.prop('checked', true);
// 		    checkBoxFlag = false;
		  } else {
		    console.log("펄스");
		    $('.folderSelectBox').prop('checked', false);
		    $('#checkFlag').val('true');
		    $('.fileSelctBox').prop('checked', false);
// 		    fileSelctBox.prop('checked', true);
// 		    checkBoxFlag = true;
		  }
		});
	
	
	var folderFileBtn = $('#folderFileBtn');
	
	
	// 셀렉트박스로 클릭된 애들을 압축파일로 압축하도록 넘기는 로직.
	$(document).on("click",'#folderFileBtn',function(){
// 	folderFileBtn.on('click', function(){
		console.log('dd');
		var folderList = [];
		var fileList = [];
		var folderSelectArray = $('.folderSelectArray');
		var fileSelectArray = $('.fileSelectArray');
		var selectBoxForm = $('#selectBoxForm');
		
		// 체크박스 체크된 폴더코드 어레이에 넣기.
		$('.folderSelectBox').each(function () {
// 		folderSelectBox.each(function () {
	        if($(this).is(":checked")==true){
	            console.log($(this).data('value'));
	            folderList.push($(this).data('value'));
	        }
	    })
	    console.log(folderList);

		// 체크박스 체크된 파일코드 어레이에 넣기.
		$('.fileSelctBox').each(function () {
// 		fileSelctBox.each(function () {
	        if($(this).is(":checked")==true){
	            console.log($(this).data('value'));
	            fileList.push($(this).data('value'));
	        }
	    })
	    console.log(fileList)
	    
	    console.log('랭쓰 : '+folderList.length);
	    console.log('랭쓰2 : '+fileSelect.length);
	    if(folderList.length == 0 && fileList.length == 0) {
	    	alert('폴더나 파일을 선택해주세요');
	    	return false;
	    }
	    
	    if(folderList != null) {
	    	folderSelectArray.val(folderList);
	    }
		if(fileList != null) {
			fileSelectArray.val(fileList);
		}
		customConfirm('해당 폴더 및 파일을 압축파일로 다운로드 하시겠습니까?').then((userConfirmed) => {
	          if (userConfirmed) {
	        	  selectBoxForm.submit();
	          } else {
	        	  return false;
	          }
		})
	})
	
	
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
		location.href="/depFileDownload.do?submitFileCd="+submitFileCd;
	});
	
	
	$(document).on("click",'#resFolderBtn',function(){
// 	resFolderBtn.on('click', function(){
		folderModal.modal('show');		
	});
	
	$(document).on("click",'#modalOkayBtn',function(){
// 	modalOkayBtn.on('click', function(){
		if( blank_pattern.test(folderName.val()) == true){
    		alert('폴더명에 공백을 포함할 수 없습니다.');
    		return false;
		}
		if(folderName.val()==null || folderName.val()=="" ) {
			alert('폴더명을 입력해주세요.');
			return false;
		} else if (reg.test(folderName.val())){
			alert('폴더명에 특수문자를 포함할 수 없습니다.');
			return false;
		} else {
			folderNameForm.submit();
		}
		
	});
	
	$(document).on('keydown', '#folderName', function(key){	
		if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
			if( blank_pattern.test(folderName.val()) == true){
	    		alert('폴더명에 공백을 포함할 수 없습니다.');
	    		return false;
			}		
			if(folderName.val()==null || folderName.val()=="" ) {
				alert('폴더명을 입력해주세요.');
				return false;
			} else if (reg.test(folderName.val())){
				$('#folderName').val('');		
				alert('폴더명에 특수문자를 포함할 수 없습니다.');
				return false;
			} else {
				folderNameForm.submit();
			}
        }
	});
	
	$(document).on("click",'.folderSelect',function(){
// 	folderSelect.on('click', function(){
		var submitForm = this.textContent;
		console.log(this.textContent);
		
		var form = $('#'+submitForm);
		form.submit();
	});
	
	$(document).on("click",'#resFileBtn',function(){
// 	resFileBtn.on('click', function(){
		fileModal.modal('show');
	});
	
	
	$(document).on("click",'#modalFileOkayBtn',function(){
// 	modalFileOkayBtn.on('click', function(){
		fileNameForm.submit();
	});
	
	

	
	// 파일 삭제기능 (버튼)
	var deleteFileBtn = $('#deleteFileBtn');
	
	$(document).on("click",'#deleteFileBtn',function(){
// 	deleteFileBtn.on('click', function(){
		
	        	 
	        	console.log('dd');
	      		var folderList = [];
	      		var fileList = [];
	      		var folderSelectArray = $('.folderSelectArray');
	      		var fileSelectArray = $('.fileSelectArray');
	      		var selectBoxDelForm = $('#selectBoxDelForm');
	      		
	      		// 체크박스 체크된 폴더코드 어레이에 넣기.
	      		folderSelectBox.each(function () {
	      	        if($(this).is(":checked")==true){
	      	            console.log($(this).data('value'));
	      	            folderList.push($(this).data('value'));
	      	        }
	      	    })
	      	    console.log(folderList);

	      		// 체크박스 체크된 파일코드 어레이에 넣기.
	      		fileSelctBox.each(function () {
	      	        if($(this).is(":checked")==true){
	      	            console.log($(this).data('value'));
	      	            fileList.push($(this).data('value'));
	      	        }
	      	    })
	      	    console.log(fileList)
	      	    
	      	    console.log('랭쓰 : '+folderList.length);
	    		console.log('랭쓰2 : '+fileList.length);
	    		if(folderList.length == 0 && fileList.length == 0) {
	    			alert('폴더나 파일을 선택해주세요');
	    			return false;
	   			}
	    		
	    		customConfirm('한번 삭제처리가 된 파일 및 폴더는 복구가 불가능합니다. 정말 삭제하시겠습니까?').then((userConfirmed) => {
	  	          if (userConfirmed) { // yes버튼일떄
	      	    
	      	    if(folderList != null) {
	      	    	folderSelectArray.val(folderList);
	      	    }
	      		if(fileList != null) {
	      			fileSelectArray.val(fileList);
	      		}
	      		selectBoxDelForm.submit();
	        	// 위에서 사용했던 셀렉트 박스를 선택했던 요소를 보내는 폼을 보낸다.
	        	// 목록을 Array로 보냄.
	        	  selectBoxDelForm.submit();
	          } else {
	              return false;
	          }
	      })
	});
	
	$(document).on('change', '#deptSelect', function(){
		var deptCd = $(this).val();
		if(deptCd == "부서전체조회") {
			alert('부서를 선택해주세요');
			return false;
		}
		$('#dept').val(deptCd);
		$('#depChangeForm').submit();
	});
});
</script>


















