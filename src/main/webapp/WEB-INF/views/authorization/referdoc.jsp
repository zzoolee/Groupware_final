<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>참조 문서</title>
</head>
<body>
<sec:authentication property="principal.emp.empName" var="empName"/>
<h2 class= "uil-file-medical-alt">결재함 > 참조 문서</h2>
<span style="font-weight: bolder;">${empName }님이 <span style="color: blue;">참조자로 지정</span>된 문서입니다.</span>
<br><br>
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
		          <th class="ps-8" style="width: 100px;">번호</th>
		          <th class="" style="width: 300px;">제목</th>
		          <th class="" style="width: 200px;">기안자</th>
		          <th class="" style="width: 200px;">기안일</th>
		          <th class="" style="width: 100px;">상태</th>
		        </tr>
		      </thead>
		      <tbody class="list">
				<c:choose>
			      	<c:when test="${empty referenceList }">
			      		<tr>
				      		<td colspan="5">참조자로 지정된 문서가 없습니다.</td>
			      		</tr>
			      	</c:when>
		      		<c:otherwise>
	      	  	 	<c:forEach items="${referenceList }" var="refList" varStatus="i">
				        <tr>
				          <th class="ps-8 chkBox">${referenceList.size() - i.index }</th> 
				          <td class="drftTitle" style="text-align: left; padding-left:100px;"><a href="/auth/refdetail.do?drftCd=${refList.drftCd }">${refList.drftTitle}</a></td>
				          <td class="empName">${refList.empName}</td>
				           		<c:set value="${refList.drftDate}" var="drftDate"/>
				          <td>${fn:substring(drftDate,0,16)}</td>
				           <td class="align-middle status"> 
				          	<c:if test="${refList.drftAprvse eq '결재' && refList.drftPrgrsse eq '완료'}">
				          		<span class="badge badge-phoenix badge-phoenix-success">${refList.drftAprvse}</span>
				          	</c:if>
				          	<c:if test="${refList.drftAprvse eq '전결' && refList.drftPrgrsse eq '완료' }">
				         		<span class="badge badge-phoenix badge-phoenix-warning">${refList.drftAprvse}</span>
				         	</c:if>	
				          	<c:if test="${refList.drftAprvse eq '반려'}">
				         		<span class="badge badge-phoenix badge-phoenix-danger">${refList.drftAprvse}</span>
				         	</c:if>	
				          	<c:if test="${refList.drftPrgrsse eq '진행중'}">
				         		<span class="badge badge-phoenix badge-phoenix-info">${refList.drftPrgrsse}</span>
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
	
