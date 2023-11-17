<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<h2>동호회</h2>
<br>

<h3>인기동호회</h3><br>
<div class="card-group">
  <c:choose>
  	<c:when test="${empty popClubList }">
  		<span class="text-info" data-feather="alert-circle" style="height: 30px; width: 30px;"></span>
	  	동호회가 존재하지 않습니다.
  	</c:when>
	<c:otherwise>
	<div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xxl-4 g-3 mb-9">
		<c:forEach items="${popClubList }" var="popClub" varStatus="i">
			<div class="col">
			<div class="card">
				<img class="card-img-top" src="${popClub.clubPhoto }" style="height:236px;">
			    <div class="card-body">
					<div class="d-flex justify-content-between align-items-center border-0">
						<a href="/clubdetail.do?clubCd=${popClub.clubCd }"><h4 class="card-title">${popClub.clubName }</h4></a>
						<span class="card-title badge bg-secondary">${popClub.memCount }명</span>
					</div>
					<p class="card-text">${popClub.clubInfo }</p>
			    </div>
			</div>
			</div>
		</c:forEach>
	</div>
	</c:otherwise>
  </c:choose>
</div>

<hr>
<br>

<h3>전체동호회</h3><br>
<!-- <div class="card-group"> -->
  <c:choose>
  	<c:when test="${empty clubList }">
  		<span class="text-info" data-feather="alert-circle" style="height: 30px; width: 30px;"></span>
	  	동호회가 존재하지 않습니다.
  	</c:when>
	<c:otherwise>
	<div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xxl-4 g-3 mb-9">
		<c:forEach items="${clubList }" var="club" varStatus="i">
<%-- 		<c:if test="${i.count % 4 == 1 }"> --%>
<!-- 			<div class="card-group"> -->
<%-- 		</c:if> --%>
			<div class="col">
			<div class="card">
				<img class="card-img-top" src="${club.clubPhoto }" style="height:236px;">
			    <div class="card-body">
					<div class="d-flex justify-content-between align-items-center border-0">
						<a href="/clubdetail.do?clubCd=${club.clubCd }"><h4 class="card-title">${club.clubName }</h4></a>
					</div>
					<p class="card-text">${club.clubInfo }</p>
			    </div>
			</div>
			</div>
<%-- 		<c:if test="${i.count % 4 == 0 or i.count == fn:length(clubList) }"> --%>
<!-- 			</div> -->
<%-- 		</c:if> --%>
		</c:forEach>
	</div>
	</c:otherwise>
  </c:choose>
<!-- </div> -->

<br>
                  
<script type="text/javascript">
$(function(){
	var clubId = $('#clubId');
	
	clubId.on('click', function(){
		location.href="/clubdetail.do";
	});
});
</script>