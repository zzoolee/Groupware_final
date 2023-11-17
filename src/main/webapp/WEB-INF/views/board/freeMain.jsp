<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<h2>자유게시판</h2>

<div class="card mt-7" style="border-radius:20px; padding:50px;">
<!-- 검색창 포함 테이블 -->
<div id="freeTable" data-list='{"valueNames":["FreeNo","FreeTitle","FreeDate","FreeWriter","FreeHit"],"page":8,"pagination":true}'> <!-- 검색, 페이징 설정 -->
	<div class="row align-items-center justify-content-between g-3 mb-4">
	  <div class="d-flex justify-content-end">
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
	    <tr style="text-align: center;">
	      <th scope="col">번호</th>
	      <th scope="col">제목</th>
	      <th scope="col">작성자</th>
	      <th scope="col">작성일</th>
	      <th scope="col">조회수</th>
	      <th scope="col">좋아요</th>
	    </tr>
	  </thead>
	  <tbody class="list"  style="cursor: pointer;">
	  	<!-- 본문 시작 -->
	  	<c:if test="${empty freeList}">
			<tr style="text-align: center;"><td colspan="7">게시글이 존재하지 않습니다...</td></tr>
		</c:if>
	  	<c:if test="${!empty freeList }">
		  	<c:forEach items="${freeList }" var="free">
			    <tr class="hover-actions-trigger btn-reveal-trigger position-static trTag" style="text-align: center;" data-frno="${free.frNo}">
			      <td class="FreeNo col-1">${free.frNo}</td>
			      <td class="FreeTitle col-5" style="text-align: left; padding-left:100px;">${free.frTitle}</td>
			      <c:choose>
				    <c:when test="${free.frAnonySe eq 'Y'}">
				        <td class="FreeWriter col-2">익명</td>
				    </c:when>
				    <c:otherwise>
				        <td class="FreeWriter col-2">${free.empName}</td>
				    </c:otherwise>
				  </c:choose>
			      <fmt:formatDate value="${free.frDate}" pattern="yyyy-MM-dd" var="freeDate"/>
			      <td class="FreeDate col-2">${freeDate}</td>	
			      <td class="FreeHit col-1">${free.frHit}</td>
			      <td class="FreeLike col-1">${free.frLike }</td>
			    </tr>
		    </c:forEach>
	  	</c:if>
	  	<!-- 본문 끝 -->
	  </tbody>
	</table>
		<div class="d-flex justify-content-end">
		    <button class="btn btn-info me-1 mb-1" type="button" id="resBtn">글쓰기</button>
		</div>
	</div>
    <div class="d-flex justify-content-center mt-3">
      <button class="page-link" data-list-pagination="prev"><span class="fas fa-chevron-left"></span></button>
      <ul class="mb-0 pagination"></ul>
      <button class="page-link pe-0" data-list-pagination="next"><span class="fas fa-chevron-right"></span></button>
    </div>
    <br>
</div>

</div>
<br>

<script>
	$(document).on("click",".trTag",function(){
		console.log("freeNO 불러오기");
		var frNo = $(this).find(".FreeNo").text();
        console.log(frNo);
        var newUrl = "/freedetail.do?frNo=" + frNo;
        
        window.location.href = newUrl;
	});
</script>

<script type="text/javascript">
	$(function(){
		var resBtn = $('#resBtn');
		var rowId = $('#rowId');
		
		rowId.on('click', function(){
			location.href="/freedetail.do";
		});
		
		resBtn.on('click', function(){
			location.href="/freewrite.do";
		});
	});
</script>