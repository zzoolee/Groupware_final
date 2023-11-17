<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>반려 문서</title>
</head>
<body>
<sec:authentication property="principal.emp.empName" var="empName"/>
<h2 class="uil-file-redo-alt fs-3">결재함 > 반려 문서</h2>
<span style="font-weight: bolder;">${empName }님이 <span style="color: red;">반려한</span> 문서입니다.</span>
<br><br>
<div class="card col-12" style="padding: 20px;"> 	
	 <div id="tableExample4" data-list='{"valueNames":["drftTitle","empName"],"page":10,"pagination":true}'>
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
	          <th class="" style="width: 100px;">반려사유</th>
	        </tr>
	      </thead>
	      <tbody class="list" id="retList">    
		     <c:choose >
		      	<c:when test="${empty retList }">
					<tr>
			      		<td colspan="6">반려한 문서가 없습니다.</td>
					</tr>		      	
		      	</c:when>
		      	<c:otherwise>
		      	  	 <c:forEach items="${retList }" var="rList" varStatus="i">
				       <tr>
				          <th class="align-middle ps-8">${retList.size() - i.index }</th>
				          <td class="align-middle drftTitle" style="text-align: left; padding-left:100px;"><a href="/auth/retdetail.do?drftCd=${rList.drftCd }">${rList.drftTitle}</a></td>
				          <td class="align-middle empName ">${rList.empName}</td>
				          	<c:set value="${rList.drftDate}" var="drftDate"/>
				          <td class="align-middle drftDate ">${fn:substring(drftDate,0,16)}</td>
			          	  <td class="align-middle status"> 
				         	<span class="badge badge-phoenix badge-phoenix-danger">	${rList.drftPrgrsse}</span>
				          </td>
				          <td>
				          	 <input type="hidden" name="drftCd" value="${rList.drftCd }" />
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
	
	
      	<!-- 반려 사유 모달 -->	    
	   	<div class="modal fade" id="exampleModal" tabindex="-1" aria-hidden="true">
			<div class="modal-dialog">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title" id="exampleModalLabel">반려 사유</h5>
			        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
			      </div>
			      <div class="modal-body" style="text-align: center;" id="memo"> </div>
			      <div class="modal-footer">
			        <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">확인</button>
			      </div>
			    </div>
			</div>
		</div>
		<!-- 반려 사유 모달 -->	     
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
		contentType : "application/json; charset=utf-8",
		success : function(res){
			console.log("res :", res);
			$("#memo").html("<b>" +res.drftMemo + "<b><br>");
			$("#memo").append("("+ res.empName+" "+res.cdName + "/"+ res.deptName +")");
		}
	}); 
});	
	
/* $.ajax({
	type : "get",
	url : "/auth/retdoc2.do",
	dataType : "json",
	success : function(res){
		console.log("반려 list : ", res);
		
		let tbodyStr = "";
		if(!res.length) {	//리스트가 없으면
			tbodyStr = `
				<tr>
	      			<td colspan="5"> 반려한 문서가 없습니다.</td>
	      		</tr>
			`;
		}else {		// 리스트가 있으면
			for(let i=0; i< res.length; i++ ){
				var draftVO = res[i];
				tbodyStr += `
					<tr>
						<th class="ps-8">\${res.length - i }</th>
						<td class="align-middle" ><a href="/auth/retdetail.do?drftCd=\${draftVO.drftCd }">\${draftVO.drftTitle}</a></td>
						<td class="align-middle">\${draftVO.empName}</td>
						<td class="align-middle">\${draftVO.drftDate.substr(0,16) }</td>
						<td class="align-middle"> 
							<button class="badge badge-phoenix badge-phoenix-danger" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal">
							\${draftVO.drftPrgrsse}</button>
						</td>
					</tr>
				`;
			}
		}
		$("#retList").html(tbodyStr);
	},
	error:function(xhr){
		console.log("xhr",xhr)
	 }
	}); */
	
	
	
});
</script>
</html>