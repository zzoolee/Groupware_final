<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<head>
<meta charset="UTF-8">
<title>참조 문서</title>
</head>
<body>
<h2 class="uil-file-medical-alt"><a href="/auth/refdoc.do">결재함</a> > 참조 문서</h2>
	<br>
	<div>
		<table class="table table-sm" style="vertical-align: middle; height: 70px;">
		    <tr>
		      <th scope="col" style="width: 50px;">* 제목</th>
		      <td colspan="3" >${authDetail.drftTitle }</td>
		    </tr>
		    <tr>
		      <th scope="row">* 기안자</th>
		      <td>${authDetail.empName } ${authDetail.cdName}/${authDetail.deptName }</td>
		      <th>* 기안일</th>
		      <c:set var="drftDate" value="${authDetail.drftDate }"/>
		      <td style=" width: 100px;">${fn:substring(drftDate,0,16) }</td>
		    </tr>
		    <tr> 
		    	<th scope="col">* 시작일</th> 
		    		<c:set var="stdate" value="${authDetail.drftStartdate }"/>
				<td style="width: 150px; margin-right: 10px;">${fn:substring(stdate,0,10) }</td>
				<th style="width: 50px;">* 종료일</th> 
					<c:set var="enddate" value="${authDetail.drftEnddate }"/>
				<td>${fn:substring(enddate,0,10) }</td>
		    </tr>
		   <tr>
		      <th scope="row" >* 참조자</th>
		      <td colspan="3" id="authRef">
		      	<!-- 참조 인원 들어갈 곳 -->
		      	<c:choose>
					<c:when test="${empty refList}">
						<span class="btn btn-sm btn-phoenix-secondary rounded-pill me-1 mb-1">참조자가 없습니다.</span>
					</c:when>
					<c:otherwise>
						<c:forEach items="${refList}" var="ref">
					        <input type="hidden" name="ref" value="${ref.refEmpno }" id="refEmpno">
				      		<span class="btn btn-sm btn-phoenix-secondary rounded-pill me-1 mb-1">${ref.empName} ${ref.cdName }/${ref.deptName}</span>
				      	</c:forEach>
					</c:otherwise>		      	
		      	</c:choose>
		      </td>
		    </tr>
		</table>
	</div>
<br>
<!-- 	<div class="card-body"> -->
<!-- 		<div class="col-md-12"> -->
<!-- 			<textarea id="ckeditor" name="" class="form-control" rows="14" readonly="readonly"> -->
		<div class="card col-12" style="padding-bottom: 50px;">
			<div><br><br>			
				<!-- 결재란 시작 -->
				<div>
					<table border="1" style="width: 450px; margin-right:150px; float: right; text-align: center; border-collapse: collapse; table-layout: fixed;">
						<tbody>
							<tr>
								<td rowspan="4" style="width: 20px; border-style: solid; border-width: 1px; border-color: black;">결재란</td>
							</tr>
							<tr>
								<td style="border: 1px solid black;">${authDetail.empName }</td>
								<!--결재자 이름  -->
								<c:forEach items="${pathList}" var="path">
									<td style="border: 1px solid black;">${path.empName}</td>
								</c:forEach>
							</tr>
							<tr style="height: 60px">
								<!--기안자 사인  -->
								<td style="border: 1px solid black;"><img width="50px;" src="${authDetail.empSign }"></td> 
								
								<c:forEach items="${pathList }" var="path">
									<c:if test="${path.atrzpStatusse == '결재'}"><td style="border: 1px solid black;"><img width="50px;" src="${path.empSign }"></td></c:if>
									<c:if test="${path.atrzpStatusse == '대기'}"><td style="border: 1px solid black;"></td></c:if>
									<c:if test="${path.atrzpStatusse == '반려'}"><td style="border: 1px solid black;"><span style="color: red;">반려</span></td></c:if>
								</c:forEach>
							</tr>
							<tr>
								<!-- 결재한 날짜  -->
								<c:set var="drftdate" value="${authDetail.drftDate }"/>
								<td style="border: 1px solid black;">${fn:substring(drftdate,0,10) }</td>
								
								<c:forEach items="${pathList }" var="path">
									<td style="border: 1px solid black;">${fn:substring(path.atrzpDate,0,10) }</td>
								</c:forEach>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- 결재란 끝 -->
				<br><br><br><br><br><br><br><br>
				${authDetail.drftContent }			
<!-- 			</textarea> -->
		</div>
	</div>
<br>
	<div>
		<table class="table table-sm">
		    <tr>
		      <th scope="col" style="width: 200px;">* 제출사유</th>
			      <c:choose>
				      	<c:when test="${empty authDetail.drftReason }">
					    	<td>미작성되었습니다.</td>
				      	</c:when>
						<c:otherwise>
							<td>${authDetail.drftReason }</td>
						</c:otherwise>
			      </c:choose>
		      <td colspan="2"></td>
		    </tr>
		    <tr>
		      <th scope="col" style="width: 200px;">* 반려사유</th>
				<td>${authDetail.drftMemo }</td>
		      <td colspan="2"></td>
		   </tr>
		</table>
	</div>
	
	<div style="text-align: center;">
		<button class="btn btn-outline-info" type="button" id="refList">목록</button>
	</div>
<br>	
</body>
<script type="text/javascript">
$(function(){
	CKEDITOR.replace("ckeditor");
	CKEDITOR.config.width= "100%";
	CKEDITOR.config.height= "500px";
	
	var refList = $("#refList");
	refList.on("click", function(){
		location.href ="/auth/refdoc.do";
	});
});

</script>
</html>