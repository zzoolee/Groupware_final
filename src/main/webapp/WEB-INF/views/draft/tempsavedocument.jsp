<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
<sec:authentication property="principal.emp.empName" var="empName"/>
<h2 class="uil-save">기안함 > 임시저장문서</h2>
<span style="font-weight: bolder;">${empName }님이 <span style="color: blue;">임시저장한</span> 문서입니다.</span>
<br/><br/>
<div class="card col-12" style="padding: 20px;">
	<div style="margin-left: 94%;">
		<button class="me-1 mb-1 btn btn-phoenix-danger" style="width: 93px;" id="delBtn">삭제   
		<svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg>
		</button>
	</div>
<form action="/draft/tempsavedelete.do" method="post" id="delForm">
<input type="hidden" value="" class="tsDocList">
	<div id="tableExample4" data-list='{"valueNames":["chkBox","drftTitle","drftDate"],"page":10,"pagination":true,"filter":{"key":"writeDate"}}'>
		 <div class="table-responsive">
		    <table class="table table mb-0" style="text-align: center;">
		      <thead>
		        <tr class="bg-light">
		          <th class="ps-8" style="width: 100px;"><input class="form-check-input" id="totalChk" type="checkbox" /></th>
		          <th class="" style="width: 300px;">제목</th>
		          <th class="" style="width: 200px;">작성일</th>
		        </tr>
		      </thead>
		      <tbody class="list">
			      <c:choose >
			      	<c:when test="${empty tempSaveList }">
				    	<tr>
					    	<td colspan="3">임시저장 문서가 없습니다.</td>
				    	</tr>
				    </c:when>
			      	<c:otherwise>
			      	  	 <c:forEach items="${tempSaveList}" var="tsList">
					        <tr>
					          <td class="ps-8 chkBox">
					          	<input class="form-check-input tsCheckbox" type="checkbox" name="drftCd" value="${tsList.drftCd }"/>
					          </td>
					          <td style="text-align: left; padding-left:100px;"><a href="/draft/tempsavedetail.do?drftCd=${tsList.drftCd }">${tsList.drftTitle}</a></td>
					          		<c:set value="${tsList.drftDate}" var="drftDate"/>
					          <td class=""> ${fn:substring(drftDate,0,16) }</td>
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
</form>
</div>		
<br/>

<script type="text/javascript">
$(document).ready(function() {
	/* 체크박스 */
	$("#totalChk").click(function(){
		if($("#totalChk").is(":checked")) $("input[name=drftCd]").prop("checked", true);
		else $("input[name=drftCd]").prop("checked", false);
	});

	$("input[name=drftCd]").click(function(){
		var total = $("input[name=drftCd]").length;
		var checked = $("input[name=drftCd]:checked").length;
		
		if(total != checked) $("#totalChk").prop("checked", false);
		else $("#totalChk").prop("checked", true); 
	});
});


$("#delBtn").on("click", function(){
	var tempSaveArray = [];	//삭제할 임시저장 문서를 담을 빈 배열
	var tsDocList = $(".tsDocList");
	
	$(".tsCheckbox").each(function(){
		if($(this).is(":checked") == true){	//체크했다면
			tempSaveArray.push($(this).val()); //value값을 배열에 넣음 
		}
	});
	console.log("tempSaveArray : ", tempSaveArray);
	if(tempSaveArray.length == 0){
		alert("삭제할 임시저장 문서를 체크해주세요.");
		return false;
	}else if(tempSaveArray != null){
		tsDocList.val(tempSaveArray);
		console.log("tsDocList.val() ", tsDocList.val());
	}
	customConfirm("정말 삭제하시겠습니까?").then((userConfirmed) => {
        if (userConfirmed) { // yes버튼일떄
            $("#delForm").submit();
        } else { // no버튼일때
        	return;
        }
    });
		
}); 
</script>
</html>