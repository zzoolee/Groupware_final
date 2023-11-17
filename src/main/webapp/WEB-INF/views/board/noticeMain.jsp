<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<h2>공지사항</h2>

<div class="card mt-7" style="border-radius:20px; padding:50px;">
<!-- 검색창 포함 테이블 -->
<div id="noticeTable" data-list='{"valueNames":["NoticeNo","NoticeTitle","NoticeDate","NoticeWriter","NoticeHit"],"page":8,"pagination":true}'>
	<div class="row align-items-center justify-content-between g-3 mb-4">
		<div class="d-flex justify-content-end">
			<!-- 검색창 -->
			<div class="search-box">	
				<form class="position-relative" data-bs-toggle="search" data-bs-display="static">
					<input class="form-control search-input search" type="search" placeholder="" aria-label="Search" /> 
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
				<th scope="col">게시일</th>
				<th scope="col">조회수</th>
			</tr>
		</thead>
		<tbody class="list" style="cursor: pointer;">
			<!-- 본문 시작 -->
			<c:if test="${empty noticeList}">
				<tr style="text-align: center;"><td colspan="7">게시글이 존재하지 않습니다...</td></tr>
			</c:if>
				<c:if test="${!empty noticeList}">
				    <c:forEach items="${noticeList}" var="notice" varStatus="i">
			        	<c:choose>
			        		<c:when test="${not empty notice.noFix }">
					        <tr class="hover-actions-trigger btn-reveal-trigger position-static trTag table-active" style="text-align: center;" data-nono="${notice.noNo}">
					            <td class="NoticeNo col-1">${notice.noNo}</td>
					            <td class="NoticeTitle col-6" style="text-align: left; padding-left:100px;">${notice.noTitle}</td>
					            <td class="NoticeWriter col-2">${notice.empName}</td>
					            <fmt:formatDate value="${notice.noDate}" pattern="yyyy-MM-dd" var="noticeDate"/>
					            <td class="NoticeDate col-2">${noticeDate}</td>
					            <td class="NoticeHit col-1">${notice.noHit}</td>
					        </tr>
			        		</c:when>
			        		<c:otherwise>
					        <tr class="hover-actions-trigger btn-reveal-trigger position-static trTag" style="text-align: center;" data-nono="${notice.noNo}">
					            <td class="NoticeNo col-1">${notice.noNo}</td>
					            <td class="NoticeTitle col-6" style="text-align: left; padding-left:100px;">${notice.noTitle}</td>
					            <td class="NoticeWriter col-2">${notice.empName}</td>
					            <fmt:formatDate value="${notice.noDate}" pattern="yyyy-MM-dd" var="noticeDate"/>
					            <td class="NoticeDate col-2">${noticeDate}</td>
					            <td class="NoticeHit col-1">${notice.noHit}</td>
					        </tr>
			        		</c:otherwise>
			        	</c:choose>
				    </c:forEach>
				</c:if>
			<!-- 본문 끝 -->
			</tbody>
		</table>
		<sec:authentication property="principal.emp.empNo" var="empNo"/>
		<c:if test="${empNo eq 'admin' }">
			<div class="d-flex justify-content-end">
				<button class="btn btn-info me-1 mb-1" type="button" id="resBtn">글쓰기</button>
			</div>
		</c:if>
	</div>
	<div class="d-flex justify-content-center mt-3">
		<button class="page-link" data-list-pagination="prev"><span class="fas fa-chevron-left"></span></button>
		<ul class="mb-0 pagination"></ul>
		<button class="page-link pe-0" data-list-pagination="next"><span class="fas fa-chevron-right"></span></button>
	</div>
	<br>
</div>
<script>
    $(document).on("click",'.trTag',function(){
       	console.log("NoticeNO 불러오기");
        var noNo = $(this).find(".NoticeNo").text();
        console.log(noNo);
        var newUrl = "/noticedetail.do?noNo=" + noNo;
        
        window.location.href = newUrl;
	});
</script>
</div>
<br>

<script type="text/javascript">
	$(function() {
		var resBtn = $('#resBtn');
		var rowId = $('#rowId');

		rowId.on('click', function() {
			location.href = "/noticedetail.do";
		});

		resBtn.on('click', function() {
			location.href = "/noticewrite.do";
		});
	});
	
// 	$("#`noticeListI").on("click","a",function(event){
// 		var noNo = $(this).val();
// 	});
</script>