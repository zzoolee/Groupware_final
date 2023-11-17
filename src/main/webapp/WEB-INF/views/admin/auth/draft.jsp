<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기안서</title>
</head>
<body>
<h2>완료기안서</h2>
<br>
<div id="tableExample4" data-list='{"valueNames":["drftTitle","empName","dept", "drftDate"],"page":10,"pagination":true,"filter":{"key":"dept"}}'>
<div class="card col-12" style="padding: 20px;">	  
  <div class="row justify-content-end g-0">
    <div class="col-auto px-3">
    	<select class="form-select form-select-sm mb-3" data-list-filter="data-list-filter">
        	<option selected="" value="">-부서를 선택해주세요-</option>
        	<c:forEach items="${deptList }" var="dept">
	        	<option value="${dept.deptName }">${dept.deptName }</option>
        	</c:forEach>
        </select>
    </div>
  </div>
  <div class="table-responsive">
    <table class="table table mb-0" style="text-align: center;">
      <thead>
        <tr class="bg-light">
          <th class="ps-3" data-sort="num" width="100px;">번호</th>
          <th class="sort border-top" data-sort="drftTitle" width="200px;">제목</th>
          <th class="sort border-top" data-sort="empName" width="100px;">기안자</th>
          <th class="sort border-top" data-sort="dept" width="100px;">부서</th>
          <th class="sort border-top" data-sort="drftDate" width="100px;">기안일</th>
          <th class="sort border-top" width="100px;">상태</th>
        </tr>
      </thead>
      <tbody class="list">
        <c:forEach items="${allDraftList }" var="draftList" varStatus="i">
        	<tr>
	          <th class="align-middle num">${allDraftList.size() - i.index }</th>
	          <td class="align-middle drftTitle" style="text-align: left; padding-left:100px;"><a href="/admin/draftdetail.do?drftCd=${draftList.drftCd }">${draftList.drftTitle }</a></td>
	          <td class="align-middle empName">${draftList.empName }</td>
	          <td class="align-middle dept" style="text-align: left; padding-left:100px;">${draftList.deptName }</td>
	          <c:set value="${draftList.drftDate }" var="drftDate"/>
	          <td class="align-middle drftDate">${fn:substring(drftDate,0,16)}</td>
	          <td class="align-middle status">
	          	<c:if test="${draftList.drftAprvse eq '결재' && draftList.drftPrgrsse eq '완료'}">
	          		<span class="badge badge-phoenix badge-phoenix-success">${draftList.drftAprvse}</span>
	          	</c:if>
	          	<c:if test="${draftList.drftAprvse eq '전결' && draftList.drftPrgrsse eq '완료' }">
	         		<span class="badge badge-phoenix badge-phoenix-warning">${draftList.drftAprvse}</span>
	         	</c:if>
	          </td>
	        </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
  <div class="d-flex justify-content-center mt-3">
  	<button class="page-link" data-list-pagination="prev"> <span class="fas fa-chevron-left"></span></button>
    	<ul class="mb-0 pagination"></ul>
    <button class="page-link pe-0" data-list-pagination="next">	<span class="fas fa-chevron-right"></span></button>
  </div>
</div>
</div>	 
	
