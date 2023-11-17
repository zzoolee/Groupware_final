<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<h2><a href="/admin/draftmanage.do">기안 양식폼 관리</a> > ${atrzFormVO.atrzfName } 양식 <c:if test="${status eq 'u' }">수정</c:if></h2>
<br/>
<br>
<br>
<form action="/admin/updateAtrzFormDetail.do" method ="get" id="updateForm">
	<input type="hidden" name="atrzfCd" value="${atrzFormVO.atrzfCd }">
	<c:if test="${status eq 'u' }">
		<div>
			<table class="table table-sm" style="vertical-align: middle; height: 70px;">
			    <tr>
			      <th scope="col" style="width: 100px;">* 제목</th>
			      <td colspan="4">
			      	<input class="form-control form-control-sm" type="text" id="atrzfName" name="atrzfName" value="${atrzFormVO.atrzfName }" style="width:30%;"/>
			      </td>
			    </tr>
			</table>
		</div>
	</c:if>
	<div class="card-body">
		<div class="col-md-12">
			<textarea id="ckeditor" name="atrzfContent" class="form-control" rows="14" <c:if test="${status ne 'u' }">disabled</c:if>>${atrzFormVO.atrzfContent }</textarea>
		</div>
	</div>
	<br>
	<div style="text-align: center;">
		<c:choose>
			<c:when test="${status eq 'u' }">
				<button class="btn btn-info me-1 mb-1" type="button" id="updateFormBtn">수정 반영</button>
			</c:when>
			<c:otherwise>
				<button class="btn btn-info me-1 mb-1" type="button" id="updateBtn" onclick="$('#updateForm').submit()">양식 수정</button>
			</c:otherwise>
		</c:choose>
	</div>
</form>	
<script type="text/javascript">
$(function(){
	CKEDITOR.replace("ckeditor");
	CKEDITOR.config.width = "100%";
	CKEDITOR.config.height = "700px";

	var ckeditor = $("#ckeditor");
	var updateFormBtn = $("#updateFormBtn");
	updateFormBtn.on("click", function(){
		$("#updateForm").attr("action","/admin/updateupdateAtrzForm.do");
		$("#updateForm").attr("method","post");
		$("#updateForm").submit();
	});
	
	
	

});




</script>
