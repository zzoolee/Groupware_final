<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결재 대기 문서</title>
</head>
<body>
<sec:authentication property="principal.emp.empName" var="empName"/>
<h2 class="uil-file-question">결재함 > 결재 대기 문서</h2>
<span style="font-weight: bolder;">${empName }님이 <span style="color: blue;">결재자로 지정</span>된 문서입니다.</span>
<br/><br/>
<div class="card col-12" style="padding: 20px;">	
	<div id="tableExample4" data-list='{"valueNames":["drftTitle","empName"],"page":10,"pagination":true,"filter":{"key":"drtfDate"}}'>
		<!-- 검색창 -->
		<div class="d-flex justify-content-between align-items-center border-0 d-flex" style="margin-left: 530px;">
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
		          <th class="sort border-top ps-8" style="width: 100px;">번호</th>
		          <th class="sort border-top" style="width: 300px;">제목</th>
		          <th class="sort border-top" style="width: 200px;">기안자</th>
		          <th class="sort border-top" style="width: 200px;">기안일</th>
		          <th class="sort border-top" style="width: 100px;">상태</th>
		        </tr>
		      </thead>
		      <tbody class="list">
			  <c:choose >
		      	<c:when test="${empty waitList }">
					<tr>
			      		<td colspan="5">결재 대기중인 문서가 없습니다.</td>
					</tr>		      	
		      	</c:when>
		      	<c:otherwise>
		      	  	 <c:forEach items="${waitList }" var="wList" varStatus="i">
				        <tr>
				          <th class= "ps-8">${waitList.size() - i.index }</th>
				          <td class= "drftTitle" style="text-align: left; padding-left:100px;"><a href="/auth/waitdetail.do?drftCd=${wList.drftCd }">${wList.drftTitle}</a></td>
				          <td class="empName">${wList.empName}</td>
				          	<c:set value="${wList.drftDate}" var="drftDate"/>
				          <td>${fn:substring(drftDate,0,16)}</td>
				          <td class="status"> 
				          	<span class="badge badge-phoenix badge-phoenix-info">${wList.atrzpStatusse}</span>
				          </td>
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
		
