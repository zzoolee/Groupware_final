<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<h2>내동호회</h2>
<br>

<!-- <div class="card-group"> -->
  <c:choose>
  	<c:when test="${empty myClubList }">
  		<span class="text-info" data-feather="alert-circle" style="height: 30px; width: 30px;"></span>
	  	가입한 동호회가 존재하지 않습니다.
  	</c:when>
	<c:otherwise>
	<div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xxl-4 g-3 mb-9">
		<c:forEach items="${myClubList }" var="myClub" varStatus="i">
<%-- 		<c:if test="${i.count % 4 == 1 }"> --%>
<!-- 			<div class="card-group"> -->
<%-- 		</c:if> --%>
			<div class="col">
			<div class="card">
				<img class="card-img-top" src="${myClub.clubPhoto }" style="height:236px;">
			    <div class="card-body">
					<div class="d-flex justify-content-between align-items-center border-0">
						<a href="/clubdetail.do?clubCd=${myClub.clubCd }"><h4 class="card-title">${myClub.clubName }</h4></a>
						<c:if test="${myClub.myClub == 'clubhead' }">
							<span class="card-title badge bg-success">운영</span>
						</c:if>
						<c:if test="${myClub.myClub == 'clubmem' }">
							<span class="card-title badge bg-info">회원</span>
						</c:if>
						<c:if test="${myClub.myClub == 'clubstandby' }">
							<span class="card-title badge bg-warning">가입대기</span>
						</c:if>
					</div>
					<p class="card-text">${myClub.clubInfo }</p>
			    </div>
			</div>
			</div>
<%-- 		<c:if test="${i.count % 4 == 0 or i.count == fn:length(myClubList) }"> --%>
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
		location.href="/clubdetail.do"
	});

});
</script>