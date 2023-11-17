<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<body>
<sec:authentication property="principal.emp.empName" var="empName"/>
<h2 class="uil-file-redo-alt fs-3">기안함 > 반려문서</h2>
<span style="font-weight: bolder;">${empName }님의 <span style="color: red;">반려된</span> 문서입니다.</span>
<br/><br/>
<div class="card col-12" style="padding: 20px;">		
	<div id="tableExample4" data-list='{"valueNames":["drftTitle","drtfDate","reason"],"page":10,"pagination":true,"filter":{"key":"drftDate"}}'>
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
		          <th class="sort border-top" style="width: 300px;">제목</th>
		          <th class="sort border-top" style="width: 200px;">기안일</th>
		          <th class="sort border-top" style="width: 100px;">상태</th>
		          <th class="sort border-top" style="width: 100px;">반려사유</th>
		        </tr>
		      </thead>
			  <tbody class="list">
			  	<c:choose>
			      	<c:when test="${empty returnList }">
				      	<tr>
					    	<td colspan="5">반려된 문서가 없습니다.</td>
				    	</tr>
			      	</c:when>
			      	<c:otherwise>
		      	  	 <c:forEach items="${returnList}" var="retList" varStatus="i">
				        <tr>
				          <th class="align-middle ps-8">${returnList.size() - i.index }</th>
				          <td class="align-middle drftTitle" style="text-align: left; padding-left:100px;"><a href="/draft/retdetail.do?drftCd=${retList.drftCd }">${retList.drftTitle}</a></td>
				          	<c:set var="drftDate" value="${retList.drftDate}"/>
				          <td class="align-middle drftDate">${fn:substring(drftDate,0,16) }</td>
				          <td class="align-middle status"> 
				         	<span class="badge badge-phoenix badge-phoenix-danger">	${retList.drftPrgrsse}</span>
				          </td>
				          <td>
				          	 <input type="hidden" name="drftCd" value="${retList.drftCd }">
				          	<button class="uil-check btn btn-phoenix-secondary" type="button" name="reason" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal">사유</button>
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
		
	<!-- 반려사유 모달 -->
	   <div class="modal fade" id="exampleModal" tabindex="-1" aria-hidden="true">
		  <div class="modal-dialog">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLabel">반려 사유</h5>
		        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
		      </div>
		      <div class="modal-body" style="text-align: center;" id="memo"> </div>
		      <div class="modal-footer">
		        <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
		      </div>
		    </div>
		  </div>
		</div>
	<!-- 반려사유 모달 -->	
		
<script>
$(function(){
	$("button[name='reason']").on("click", function(){
		var $td = $(this).closest('td'); // 클릭한 버튼이 속한 td 요소를 찾음
		var drftCd = $td.find('input[name="drftCd"]').val();
		
		console.log("drftCd : ", drftCd);
		
		var data = {
			drftCd	: drftCd
		}
		console.log("data : ", data);

		$.ajax({
			type : "post",
			url : "/draft/retdoc2.do",
			data : JSON.stringify(data),
			contentType : "application/json; charset=UTF-8",
			success: function(res){
				console.log("res: ", res);
				$("#memo").html("<b>" +res.drftMemo + "<b><br>");
				$("#memo").append("("+ res.empName+" "+res.cdName + "/"+ res.deptName +")");
			}
		});
	});
});

</script>