<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- jstree cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- 스타일 cdn -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<h2>거래처주소록</h2>
<p>
	<span class="text-danger" data-feather="check"></span>
	이름을 클릭하면, 해당 관계자의 정보가 복사됩니다.
</p>
<br>

<c:if test="${!empty resultMsg }">
	<script>
		$(document).ready(function(){
			$('#successModal').modal('show');
// 			new window.bootstrap.Modal(successModal).show(); // 둘 다 가능
		});
	</script>
</c:if>

<!-- 검색창 포함 테이블 -->
<div id="addressTable" data-list='{"valueNames":["name","hp","mail","company","rank","tel"],"page":8,"pagination":true,"filter":{"key":"group"}}'> <!-- 검색, 페이징, 셀렉트 설정 -->
	<div class="row align-items-center justify-content-between g-3 mb-4">
	    <div class="d-flex justify-content-between align-items-center border-0">
	    	<button class="btn btn-info me-1 mb-1" id="myDelButton">내 주소록에서 삭제</button>
	    	<!-- 검색창 -->
	    	<div class="search-box">
		      <form class="position-relative" data-bs-toggle="search" data-bs-display="static">
		        <input class="form-control search-input search" type="search" placeholder="Search members" aria-label="Search">
		        <span class="fas fa-search search-box-icon"></span>
		      </form>
	    	</div>
	    	<div class="d-flex justify-content-center">
	    		<button class="btn btn-info me-1 mb-1" type="button" data-bs-toggle="modal" data-bs-target="#addExtModal">외부관계자 등록</button>
	      	</div>
	    </div>
	</div>
	  
	<div class="table-responsive"> <!-- 클래스 지정 -->
	<table class="table table-hover" style="vertical-align: middle;">
	  <thead>
	    <tr>
	      <th scope="col"></th>
	      <th scope="col">이름</th>
	      <th scope="col">연락처</th>
	      <th scope="col">메일</th>
	      <th scope="col">거래처명</th>
	      <th scope="col">직급</th>
	      <th scope="col">업체전화번호</th>
	      <th scope="col"></th>
	    </tr>
	  </thead>
  	  <tbody class="list"> <!-- 클래스 지정, td에 class 지정(valueNames로) -->
  	  	<c:if test="${empty extList}">
	  	  <tr style="text-align: center;"><td colspan="8">추가된 직원이 존재하지 않습니다.</tr>
	  	</c:if>
	  	<c:if test="${!empty extList }">
	  	<c:forEach items="${extList }" var="ext">
		    <tr class="hover-actions-trigger btn-reveal-trigger position-static">
		      <td class="col-1" style="text-align: center;">
		      	<input class="form-check-input" name="extCd" type="checkbox" value="${ext.extCd }" />
		      </td>
		      <td class="name col-1">${ext.extName }</td>
		      <td class="hp col-2">${ext.extHp }</td>
		      <td class="email col-2">${ext.extEmail }</td>
		      <td class="company col-2">${ext.extCompany }</td>
		      <td class="rank col-1">${ext.extRank }</td>
		      <td class="tel col-2">${ext.extTel }</td>
		      <td class="col-1">
		      	<button class="btn btn-phoenix-secondary btn-sm" name="modifyExtButton">
					<svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><!-- <span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com --> 수정
		    	</button>
		      </td>
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

<!-- 등록/수정 성공 모달 시작 -->
<div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">외부관계자 ${resultType }</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">${resultMsg }</p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="button" data-bs-dismiss="modal">확인</button>
      </div>
    </div>
  </div>
</div>
<!-- 등록/수정 성공 모달 끝 -->

<!-- 내 주소록에서 삭제 결과 모달 시작 -->
<div class="modal fade" id="resultModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">내 주소록에서 삭제</h5>
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
<!-- 내 주소록에서 삭제 결과 모달 끝 -->

<!-- 외부관계자 등록 모달 시작 -->
<div class="modal fade" id="addExtModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">외부관계자 등록</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <form class="row g-3 needs-validation" novalidate="" action="/add/addextmem.do" method="post"> <!-- 폼 입력여부 검증 : 클래스 추가, novalidate 추가, input에 required 추가  -->
      <div class="modal-body" style="padding:30px;">
      	<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-user"></span>
				<h5 class="text-1000 mb-0">이름</h5>&nbsp;<span class="text-danger">*</span>
			</div>
			<input class="form-control" type="text" name="extName" placeholder="" value="" required="">
			<div class="invalid-feedback">필수 입력 항목입니다.</div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-phone"> </span>
				<h5 class="text-1000 mb-0">연락처</h5>&nbsp;<span class="text-danger">*</span>
			</div>
			<input class="form-control" type="text" name="extHp" value="" required="">
			<div class="invalid-feedback">필수 입력 항목입니다.</div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span><svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-mail text-900 fs-3"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg></span>&nbsp;&nbsp;
				<h5 class="text-1000 mb-0">이메일</h5>
			</div>
			<input class="form-control" type="email" name="extEmail" value="">
			<div class="invalid-feedback">양식에 맞게 입력해주세요.</div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-bag-alt"></span>
				<h5 class="text-1000 mb-0">거래처명</h5>&nbsp;<span class="text-danger">*</span>
			</div>
			<input class="form-control" type="text" name="extCompany" value="" required="">
			<div class="invalid-feedback">필수 입력 항목입니다.</div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-user-square"></span>
				<h5 class="text-1000 mb-0">직급</h5>
			</div>
			<input class="form-control" type="text" name="extRank" value="">
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-phone"></span>
				<h5 class="text-1000 mb-0">업체전화번호</h5>
			</div>
			<input class="form-control" type="text" name="extTel" value="">
		</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="submit">등록</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-dismiss="modal">취소</button>
      </div>
      </form>
    </div>
  </div>
</div>
<!-- 외부관계자 등록 모달 끝 -->

<!-- 외부관계자 수정 모달 시작 -->
<div class="modal fade" id="modifyExtModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">외부관계자 수정</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <form class="row g-3 needs-validation" novalidate="" action="/add/modifyextmem.do" method="post"> <!-- 폼 입력여부 검증 : 클래스 추가, novalidate 추가, input에 required 추가  -->
      <div class="modal-body" style="padding:30px;">
      	<input type="hidden" name="extCd" value="">
      	<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-user"></span>
				<h5 class="text-1000 mb-0">이름</h5>
			</div>
			<input class="form-control" type="text" name="extName" placeholder="" value="" required="">
			<div class="invalid-feedback">필수 입력 항목입니다.</div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-phone"> </span>
				<h5 class="text-1000 mb-0">연락처</h5>
			</div>
			<input class="form-control" type="text" name="extHp" value="" required="">
			<div class="invalid-feedback">필수 입력 항목입니다.</div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span><svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-mail text-900 fs-3"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg></span>&nbsp;&nbsp;
				<h5 class="text-1000 mb-0">이메일</h5>
			</div>
			<input class="form-control" type="email" name="extEmail" value="">
			<div class="invalid-feedback">양식에 맞게 입력해주세요.</div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-bag-alt"></span>
				<h5 class="text-1000 mb-0">거래처명</h5>
			</div>
			<input class="form-control" type="text" name="extCompany" value="" required="">
			<div class="invalid-feedback">필수 입력 항목입니다.</div>
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-user-square"></span>
				<h5 class="text-1000 mb-0">직급</h5>
			</div>
			<input class="form-control" type="text" name="extRank" value="">
		</div>
		<div class="mb-4">
			<div class="d-flex align-items-center mb-1">
				<span class="me-2 uil uil-phone"></span>
				<h5 class="text-1000 mb-0">업체전화번호</h5>
			</div>
			<input class="form-control" type="text" name="extTel" value="">
		</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-phoenix-info btn-sm" type="submit">저장</button>
		<button class="btn btn-phoenix-secondary btn-sm" type="button" data-bs-dismiss="modal">취소</button>
      </div>
      </form>
    </div>
  </div>
</div>
<!-- 외부관계자 수정 모달 끝 -->

<script type="text/javascript">

$("#myDelButton").on("click", function(){ // '내 주소록에서 삭제' 버튼
	if($('input[type="checkbox"]:checked').length == 0){
		alert("삭제할 직원을 선택해주세요");
		return;
	}
	
	var delData = [];
	$('input[type="checkbox"]:checked').each(function() {
		delData.push($(this).val());
	});
	console.log(delData);
	
	customConfirm('정말 삭제하시겠습니까?').then((userConfirmed) => {
        if (userConfirmed) {
        	$.ajax({
        		type: "post",
        		url: "/add/delextmem.do",
        		data: JSON.stringify(delData),
        		contentType: "application/json; charset=utf-8",
        		success: function(result){
        			console.log(result);
        			if(result == "SUCCESS"){
        				$("#resultSpace").text("정상적으로 삭제되었습니다.");
        				new window.bootstrap.Modal(resultModal).show();
        			}
        		}
        	});
        }
    });

	
});

// 내 주소록에서 삭제 결과 모달 닫힐 때 이벤트 처리
resultModal.addEventListener('hide.bs.modal', function (event) {
	location.href="/add/myextadd.do";
});

// 외부관계자 등록 모달 닫힐 때 이벤트 처리 -> 데이터 남아있어서 새로고침 필요
addExtModal.addEventListener('hide.bs.modal', function (event) {
	location.href="/add/myextadd.do";
});

$("button[name='modifyExtButton']").on("click", function(event){
	$("#modifyExtModal form").attr("class", "row g-3 needs-validation");
	
	var $tr = $(this).closest('tr'); // 클릭한 버튼이 속한 tr 요소를 찾음
    var extCd = $tr.find('input[name="extCd"]').val();
    var name = $tr.find('.name').text(); // 클래스가 name인 td의 텍스트 값을 가져옴
    var hp = $tr.find('.hp').text(); // 클래스가 hp인 td의 텍스트 값을 가져옴
    var email = $tr.find('.email').text(); // 클래스가 email인 td의 텍스트 값을 가져옴
    var company = $tr.find('.company').text(); // 클래스가 company인 td의 텍스트 값을 가져옴
    var rank = $tr.find('.rank').text(); // 클래스가 rank인 td의 텍스트 값을 가져옴
    var tel = $tr.find('.tel').text(); // 클래스가 tel인 td의 텍스트 값을 가져옴
    
    console.log(name, hp, email, company, rank, tel);
    
    $("#modifyExtModal input[name='extCd']").val(extCd);
    $("#modifyExtModal input[name='extName']").val(name);
    $("#modifyExtModal input[name='extHp']").val(hp);
    $("#modifyExtModal input[name='extEmail']").val(email);
    $("#modifyExtModal input[name='extCompany']").val(company);
    $("#modifyExtModal input[name='extRank']").val(rank);
    $("#modifyExtModal input[name='extTel']").val(tel);
    
	new window.bootstrap.Modal(modifyExtModal).show();
});

$("td.name").on("click", function(){
	var $tr = $(this).closest('tr');
	var name = $tr.find('.name').text();
	var hp = $tr.find('.hp').text();
	var company = $tr.find('.company').text();
	
	const textarea = document.createElement('textarea');
	textarea.textContent = name + " / " + hp + " / " + company;
	document.body.append(textarea);
	textarea.select();
	document.execCommand('copy');
	textarea.remove();
	
	alert("이름/연락처/거래처명이 복사되었습니다.");
});

</script>