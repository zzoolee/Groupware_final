<%@ page language="java" contentType="text/html; charset=UTF-8"     pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>완료 문서</title>
</head>
<body>
<sec:authentication property="principal.emp.empName" var="empName"/>
<h2 class="uil-check fs-3">결재함 > 완료 문서</h2>
<span style="font-weight: bolder;">${empName }님이 <span style="color: green;">결재 완료한</span> 문서입니다.</span>
<br><br>
<div class="card col-12" style="padding: 20px;"> 
	 <div id="tableExample4"  data-list='{"valueNames":["drftTitle","drftName","drftDate","atrzpDate"],"page":10,"pagination":true,"filter":{"key":"drftDate"}}'>
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
	          <th class="sort border-top ps-8" style="width: 100px;" >번호</th>
	          <th class="sort border-top" style="width: 300px;">제목</th>
	          <th class="sort border-top" style="width: 200px;">기안자</th>
	          <th class="sort border-top" style="width: 200px;">기안일</th>
	          <th class="sort border-top" style="width: 100px;">상태</th>
	          <th class="sort border-top" style="width: 200px;">결재일</th>
	        </tr>
	      </thead>
	      <tbody class="list" id="comList"> 
	      <c:choose>
		      	<c:when test="${empty completeList }">
			      	<tr>
				    	<td colspan="6">결재를 완료한 문서가 없습니다.</td>
			    	</tr>
		      	</c:when>
		      	<c:otherwise>
	      	  	 <c:forEach items="${completeList}" var="comList" varStatus="i">
			        <tr>
			          <th class="align-middle ps-8">${completeList.size() - i.index }</th>
			          <td class="align-middle drftTitle" style="text-align: left; padding-left:100px;"><a href="/auth/comdetail.do?drftCd=${comList.drftCd }">${comList.drftTitle}</a></td>
			          <td class="align-middle drftName">${comList.empName } </td>
			          	<c:set var="drftDate" value="${comList.drftDate}"/>
			          <td class="align-middle drftDate">${fn:substring(drftDate,0,16) }</td>
			          <td class="align-middle status"> 
			          	<c:if test="${comList.drftAprvse eq '결재' && comList.drftPrgrsse eq '완료'}">
			          		<span class="badge badge-phoenix badge-phoenix-success">${comList.drftAprvse}</span>
			          	</c:if>
			          	<c:if test="${comList.drftAprvse eq '전결' && comList.drftPrgrsse eq '완료' }">
			         		<span class="badge badge-phoenix badge-phoenix-warning">${comList.drftAprvse}</span>
			         	</c:if>	
			          	<c:if test="${comList.drftAprvse eq '반려'}">
			         		<span class="badge badge-phoenix badge-phoenix-danger">${comList.drftAprvse}</span>
			         	</c:if>	
			          	<c:if test="${comList.drftPrgrsse eq '진행중'}">
			         		<span class="badge badge-phoenix badge-phoenix-info">${comList.drftPrgrsse}</span>
			         	</c:if>	
			          </td>
			          <td class="align-middle atrzpDate">${comList.atrzpDate } </td>
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
	
<script>
  /*  $(function(){
	   $.ajax({
		 url:"/auth/comdoc2.do",
		 type:"get",
		 dataType:"json",
		 success:function(rslt){
			// alert("여기!");
			console.log("체킁:",rslt);
			
			let tbodyStr = "";
			if(!rslt.length) {   // 리스트가 없으면
				tbodyStr = `
					<tr>
			      		<td colspan="6">결재를 완료한 문서가 없습니다.</td>
			      	</tr>
				`;
			}else {             // 리스트가 있으면
				for(let i=0; i<rslt.length; i++){
					let draftVO = rslt[i];
					tbodyStr += `
						<tr>
							<th class="ps-8">\${rslt.length - i }</th>
							<td><a href="/auth/comdetail.do?drftCd=\${draftVO.drftCd }">\${draftVO.drftTitle}</a></td>
							<td>\${draftVO.empName}</td>
							<td>\${draftVO.drftDate.substr(0,16) }</td>
							<td> 
								<span class="badge badge-phoenix badge-phoenix-success">\${draftVO.drftPrgrsse}</span>
							</td>
							<td>\${draftVO.atrzpDate }</td>
						</tr>
					`;
				}
			}
			$("#comList").html(tbodyStr);
			
		 },
		 error:function(xhr){
			console.log("xhr",xhr)
		 }
	   });
   }) */
</script>
</body>
</html>