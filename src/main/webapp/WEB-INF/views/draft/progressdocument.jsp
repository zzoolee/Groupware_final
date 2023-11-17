<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>진행중 문서</title>
</head>
<body>
<sec:authentication property="principal.emp.empName" var="empName"/>
<h2 class="uil-file-check">기안함 > 진행중문서</h2>
<span style="font-weight: bolder;">${empName }님의 <span style="color: blue;">결재 진행중</span>인 문서입니다.</span>
<br/><br/>
<div class="card col-12" style="padding: 20px;">	
	<div id="tableExample4" data-list='{"valueNames":["drftTitle","drftDate", "atrzpDate"],"page":10,"pagination":true,"filter":{"key":"drftDate"}}'>
		<!-- 검색창 -->
		<div class="d-flex justify-content-center">
		    <div class="search-box" style="width: 500px;" >
		      <form class="position-relative" data-bs-toggle="search" data-bs-display="static">
		        <input class="form-control search-input search" type="search" placeholder="Search" aria-label="Search">
		        <span class="fas fa-search search-box-icon"></span>
		      </form>
		    </div>
		</div>
		<br>
		
		 <div class="table-responsive">
		    <table class="table table mb-0" style="text-align: center;">
		      <thead>
		        <tr class="bg-light">
		        <th class="sort border-top ps-8" style="width: 100px;" >번호</th>
		          <th class="sort border-top" style="width: 300px;" >제목</th>
		          <th class="sort border-top" style="width: 200px;" >기안일</th>
		          <th class="sort border-top" style="width: 100px;" >상태</th>
		          <th class="sort border-top" style="width: 200px;" >결재일</th>
		        </tr>
		      </thead>
		      <tbody class="list">
					<c:choose >
			      	<c:when test="${empty progressList }">
			      		<tr>
						    <td colspan="5">결재 진행중인 문서가 없습니다.</td>
					    </tr>
			      	</c:when>
			      	<c:otherwise>
		      	  	 <c:forEach items="${progressList}" var="pgList" varStatus="i">
				        <tr>
				          <th class="num ps-8">${progressList.size() - i.index }</th>
				          <td class="align-middle drftTitle" style="text-align: left; padding-left:100px;"><a href="/draft/progdetail.do?drftCd=${pgList.drftCd }">${pgList.drftTitle}</a></td>
				          	<c:set value="${pgList.drftDate}" var="drftDate"/>
				          <td class="align-middle drftDate">${fn:substring(drftDate,0,16)}</td>
				          <td class="align-middle status"> 
				          	<span class="badge badge-phoenix badge-phoenix-info">${pgList.drftPrgrsse}</span>
				          </td>
				          <c:choose>
					          <c:when test="${empty pgList.atrzpDate}">
					          	  <td><span class="badge badge-phoenix badge-phoenix-secondary">결재 대기중</span></td>
					          </c:when>
					          <c:otherwise>
					          		<c:set value="${pgList.atrzpDate}" var="atrzpDate"/>
						          <td class="align-middle atrzpDate">${fn:substring(atrzpDate,0,10)}</td>
					          </c:otherwise>
				          </c:choose>
				        </tr>
			      	 </c:forEach>
		      	  </c:otherwise>
		      	</c:choose>
		      </tbody>
		    </table>
		 </div>
		  <div class="d-flex justify-content-center mt-3">
		  	<button class="page-link" data-list-pagination="prev">
		  		<span class="fas fa-chevron-left"></span>
		  	</button>
		    	<ul class="mb-0 pagination"></ul>
		    <button class="page-link pe-0" data-list-pagination="next">
		    	<span class="fas fa-chevron-right"></span>
		    </button>
		  </div>
		</div>
	</div>
<br/>
	
