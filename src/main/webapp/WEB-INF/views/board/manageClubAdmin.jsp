<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<h2>동호회관리</h2>
<br>

<c:if test="${not empty message }">
	<script type="text/javascript">
		alert("${message}");
		<c:remove var="message" scope="request"/>
		<c:remove var="message" scope="session"/>
	</script>
</c:if>

<!-- 검색창 포함 테이블 -->
<div id="clubTable" data-list='{"valueNames":["date","name","head","rank","dept","hp"],"page":8,"pagination":true}'> <!-- 검색, 페이징 설정 -->
	<div class="row align-items-center justify-content-between g-3 mb-4">
	  <div class="d-flex justify-content-end mt-3">
	    <!-- 검색창 -->
	    <div class="search-box">
	      <form class="position-relative" data-bs-toggle="search" data-bs-display="static">
	        <input class="form-control search-input search" type="search" placeholder="" aria-label="Search">
	        <span class="fas fa-search search-box-icon"></span>
	      </form>
	    </div>
	  </div>
	</div>
	
	<div class="table-responsive"> <!-- 클래스 지정 -->
	<table class="table table-hover" style="vertical-align: middle;">
	  <thead>
	    <tr>
	      <th scope="col">개설일자</th>
	      <th scope="col">동호회명</th>
	      <th scope="col">동호회장</th>
	      <th scope="col">직급</th>
	      <th scope="col">부서</th>
	      <th scope="col">연락처</th>
	      <th scope="col">회원수</th>
	      <th scope="col"></th>
	    </tr>
	  </thead>
	  <tbody class="list"> <!-- 클래스 지정, td에 class 지정(valueNames로) -->
	  	<c:choose>
	  		<c:when test="${empty clubList }">
		  		<tr style="text-align: center;">
		  			<td colspan="9">동호회가 존재하지 않습니다.</td>
		  		</tr>
	  		</c:when>
	  		<c:otherwise>
	  			<c:forEach items="${clubList }" var="club">
				    <tr class="hover-actions-trigger btn-reveal-trigger position-static">
				      <td class="date col-1"><fmt:formatDate value="${club.clubDate }" pattern="yyyy-MM-dd"/></td>
				      <td class="name col-3">
				      	${club.clubName }&nbsp;&nbsp;
				      	<button class="btn btn-phoenix-info me-1 mb-1" name="clubDetail" data-photo="${club.clubPhoto }" data-info="${club.clubInfo }">상세보기</button>
				      </td>
				      <td class="head col-1">${club.empName }</td>
				      <td class="rank col-1">${club.cdName }</td>
				      <td class="dept col-2">${club.deptName }</td>
				      <td class="hp col-2">${club.empHp }</td>
				      <td class="cnt col-1">${club.memCount }</td>
				      <td class="col-1">
				      	<c:if test="${club.clubSe == 0}">
					      	<button class="btn btn-info me-1 mb-1" name="approveBtn" data-clubcd="${club.clubCd }" data-empno="${club.clubEmpno }" data-reason="${club.clubReason }">승인관리</button>
				      	</c:if>
				      	<c:if test="${club.clubSe == 1}">
					      	<button class="btn btn-danger me-1 mb-1" name="shutdownBtn" data-clubcd="${club.clubCd }" data-empno="${club.clubEmpno }">폐쇄관리</button>
				      	</c:if>
				      	<c:if test="${club.clubSe == -1}">
					      	폐쇄
				      	</c:if>
				      </td>
				    </tr>
			    </c:forEach>
	  		</c:otherwise>
	  	</c:choose>
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

<!-- 승인관리 모달창 시작 -->
<div class="modal fade" id="approveModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">동호회 승인</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body" style="padding:20px;">
        <span class="text-info" style="font-weight: bold;">개설사유</span>
        <p class="text-700 lh-lg mb-0"><!-- 개설사유 들어가는 곳 --></p><br>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="button" id="createBtn" data-clubcd="">승인</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" id="rejectBtn" data-clubcd="" data-empno="">거절</button>
      </div>
    </div>
  </div>
</div>
<!-- 승인관리 모달창 끝 -->

<!-- 승인거절 모달창 시작 -->
<div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">동호회 승인</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
      <form id="rejectForm" method="post" action="/rejectclub/admin.do">
      	<input type="hidden" name="clubCd" value="">
      	<input type="hidden" name="clubEmpno" value="">
        <p class="text-700 lh-lg mb-0">
			<textarea class="form-control" name="rejectReason" placeholder="거절사유를 입력하세요." style="height: 150px"></textarea>
		</p>
      </form>
      </div>
      <div class="modal-footer">
      	<button class="btn btn-info" type="button" id="rejectConfirmBtn">저장</button>
      	<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 승인거절 모달창 끝 -->

<!-- 폐쇄관리 모달창 시작 -->
<div class="modal fade" id="shutdownModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">동호회 폐쇄</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
      <form id="shutdownForm" method="post" action="/shutdownclub/admin.do">
      	<input type="hidden" name="clubCd" value="">
      	<input type="hidden" name="clubEmpno" value="">
        <p class="text-700 lh-lg mb-0">
			<textarea class="form-control" name="shutdownReason" placeholder="폐쇄사유를 입력하세요." style="height: 150px"></textarea>
		</p>
      </form>
      </div>
      <div class="modal-footer">
      	<button class="btn btn-info" type="button" id="shutdownConfirmBtn">저장</button>
      	<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 폐쇄관리 모달창 끝 -->

<!-- 상세보기 모달창 시작 -->
<div class="modal fade" id="clubDetailModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">동호회 상세</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
	      <div class="mb-4">
	      	<div class="d-flex flex-wrap mb-2">
				<h4 class="mb-0 text-1000 me-2">대표이미지</h4>
			</div>
	      	<img src="" style="width:700px;">
	      </div>
	      <div class="mb-4">
	        <div class="d-flex flex-wrap mb-2">
				<h4 class="mb-0 text-1000 me-2">소개</h4>
			</div>
	        <p class="text-700 lh-lg mb-0"></p>
	      </div>
      </div>
      <div class="modal-footer">
      	<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 상세보기 모달창 끝 -->


<script type="text/javascript">

let approve_modal;
let shutdown_modal;

let clubCd;
let clubEmpno;

$(function(){
	$("button[name='approveBtn']").on("click",function(){
		clubCd = $(this).data("clubcd");
		clubEmpno = $(this).data("empno");
		var reason = $(this).data("reason");
		
		if(reason == "" || reason == null){
			reason = "개설사유를 작성하지 않았습니다.";
		}
		$("#approveModal .modal-body p").text(reason);
// 		$("#createBtn").attr("data-clubcd", clubCd);
// 		$("#rejectBtn").attr("data-clubcd", clubCd);
		
		approve_modal = new window.bootstrap.Modal(approveModal);
		approve_modal.show();
	});
	
	$("#createBtn").on("click",function(){
// 		var clubCd = $(this).data("clubcd");
		location.href="/approveclub/admin.do?clubCd="+clubCd;
	});
	$("#rejectBtn").on("click",function(){
// 		var clubCd = $(this).data("clubcd");
		$("#rejectModal input[name='clubCd']").val(clubCd);
		$("#rejectModal input[name='clubEmpno']").val(clubEmpno);
		$("#rejectModal textarea[name='rejectReason']").val("");
		
		approve_modal.hide();
		new window.bootstrap.Modal(rejectModal).show();
	});
	$("#rejectConfirmBtn").on("click",function(){
		if($("#rejectModal textarea[name='rejectReason']").val() == "") {
			alert("사유를 입력해주세요");
		}else{
			rejectForm.submit();
		}
	});
	
	$("button[name='shutdownBtn']").on("click",function(){
		clubCd = $(this).data("clubcd");
		clubEmpno = $(this).data("empno");
		
		$("#shutdownModal input[name='clubCd']").val(clubCd);
		$("#shutdownModal input[name='clubEmpno']").val(clubEmpno);
		$("#shutdownModal textarea[name='shutdownReason']").val("");
		
		customConfirm('정말 폐쇄하시겠습니까?').then((userConfirmed) => {
          if (userConfirmed) { 
        	shutdown_modal = new window.bootstrap.Modal(shutdownModal);
        	shutdown_modal.show();
          }
        });
	});
	$("#shutdownConfirmBtn").on("click",function(){
		if($("#shutdownModal textarea[name='shutdownReason']").val() == "") {
			alert("사유를 입력해주세요");
		}else{
			shutdownForm.submit();
		}
	});
	
	$("button[name='clubDetail']").on("click",function(){
		var photo = $(this).data("photo");
		var info = $(this).data("info");
		
		$("#clubDetailModal .modal-body img").attr("src", photo);
		$("#clubDetailModal .modal-body p").text(info);
		
		new window.bootstrap.Modal(clubDetailModal).show();
	});
	
});

</script>