<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기안 양식폼 관리</title>
</head>
<body>
 <h2>기안 양식폼 관리</h2>
 	<br>
 	<br>
 	<div class="card" style="padding: 30px;">
		<div class="card-body">
		 	<table class="table table-hover" style="text-align: center;">
			  <thead>
			    <tr>
			      <th class="bg-light" scope="col">	        		
			      	<input class="form-check-input" id="totalChk" type="checkbox" />
				  </th>
			      <th class="bg-light" scope="col">번호</th>
			      <th class="bg-light" scope="col">양식명</th>
			      <th class="bg-light" scope="col">최종수정날짜</th>
			    </tr>
			  </thead>
			  <tbody>
			  <c:choose>
			  	<c:when test="${empty atrzFormList }">
			  		 <tr>
				      <th scope="row" colspan="2">
						양식이 존재하지 않습니다.
					  </th>
				    </tr>
			  	</c:when>
			  	<c:otherwise>
			  		<c:forEach items="${atrzFormList }" var="atrzForm" varStatus="i">
					    <tr>
					      <th scope="row">
							<input class="form-check-input selectChk" type="checkbox" name="atrzfCd" data-value="${atrzForm.atrzfCd }"/>
						  </th>
					       <td scope="col">${i.index+1 }</td>
						      <td style="text-align: left; padding-left: 500px;"><a href="atrzFormDetail.do?atrzfCd=${atrzForm.atrzfCd }">
						      ${atrzForm.atrzfName }</a></td>
						      <fmt:formatDate value="${atrzForm.atrzfRegdate }" pattern="yyyy-MM-dd" var="atrzfRegdate"/>
					       <td scope="col">${atrzfRegdate }</td>
					    </tr>
			  		</c:forEach>
			  	</c:otherwise>
			  </c:choose>
			  </tbody>
			</table> 
			<br/>
			<div style="text-align: center;">
			<button class="btn btn-outline-info" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal" id="delFormBtn">삭제</button>
			<button class="btn btn-outline-info" type="button" id="registerAtrzfFormBtn">등록</button>
			</div>
		</div>
	</div>
</body>
<br>
<!-- 모달 -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">기안 양식폼 삭제</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body" style="text-align: center;">
        <p class="text-700 lh-lg mb-0">정말 삭제하시겠습니까?</p>
      </div>
      <div class="modal-footer">
      	<button class="btn btn-info" type="button" id="sendDelBtn">확인</button>
      	<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
	/* 체크박스 */
	$("#totalChk").click(function(){
		if($("#totalChk").is(":checked")) $("input[name=atrzfCd]").prop("checked", true);
		else $("input[name=atrzfCd]").prop("checked", false);
		
	});

	$("input[name=chk]").click(function(){
		var total = $("input[name=chk]").length;
		var checked = $("input[name=chk]:checked").length;
		
		if(total != checked) $("#totalChk").prop("checked", false);
		else $("#totalChk").prop("checked", true); 
		
	});
	
	var registerAtrzfFormBtn = $("#registerAtrzfFormBtn");
	registerAtrzfFormBtn.on("click",function(){
		location.href="/admin/createAtrzfForm.do";
	});
	
	// 삭제를 위한 데이터 값 넘기기 
	var sendDelBtn = $("#sendDelBtn");
// 	var formData = new FormData();
	var inputVal=[];
	
	sendDelBtn.click(function(){
		$("input.selectChk:checked").each(function(){
			var val = $(this).data("value");
			console.log(inputVal);
			

			inputVal.push(val);
		});
		var data ={
				atrzfCd : inputVal
		}
		console.log("data value: " + data);
		$.ajax({
			type : "post",
			url : "/admin/deleteAtrzfForm.do",
			data : JSON.stringify(data),
			contentType: "application/json; charset=utf-8",
			dataType : "text",
			success : function(res){
				if(res ==="성공"){
					alert("삭제가 완료되었습니다!");
					location.href ="/admin/draftmanage.do"
				}else{
					alert("삭제를 실패하였습니다!")
				}
			}
			
		})
		
				
		
	});

});
</script>
</html>