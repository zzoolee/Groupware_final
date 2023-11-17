<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
<h2>증명서 신청내역</h2>
<span class="text-danger" data-feather="check"></span>
<label style="font-size:15px;">발급된 증명서는 발급일로부터 7일 이후 사라집니다.</label>
<br>
<br>
	<div class="card">
		<div class="card-body">
			<button class="btn btn-info me-1 mb-1" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal" style="float: right;">증명서 신청</button>
			<br/>
			<table class="table table-hover" style="margin:0 auto; text-align: center;">
			  <thead>
			    <tr>
			      <th scope="col">&nbsp;&nbsp;&nbsp;번호</th>
			      <th scope="col">신청일자</th>
			      <th scope="col">증명서명</th>
			      <th scope="col">다운로드</th>
			    </tr>
			  </thead>
			  <tbody id="tbody">
			  <c:choose>
			  	<c:when test="${empty docList }">
			  		<tr>
				      <th scope="row" colspan="4">증명서를 신청해주세요</th>
				    </tr>
			  	</c:when>
			  	<c:otherwise>
			  		<c:forEach items="${docList }" var="doc" varStatus="i">
					    <tr>
					      <th scope="row">${i.index+1 }</th>
					      <fmt:formatDate value="${doc.docDate }" pattern="yyyy-MM-dd" var="date"/>
					      <td>${date }</td>
					      <td>
					      	${doc.docName }
						      <c:if test="${doc.docSe eq 'N' }">
						      		<span class="badge badge-phoenix badge-phoenix-info">new</span>
						      </c:if>
					      </td>
					      <td class="updateDocSeTd">
					      	<span data-cd="${doc.docCd }" data-text="${doc.docName }"><button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-target="showRegno">증명서 다운로드</button></span>
					      </td>
					    </tr>
			  		</c:forEach>
			  	</c:otherwise>
			  </c:choose>
			  </tbody>
			</table>
			</div>
		</div>
		<br>
		<!--  모달창 -->
		<div class="modal fade" id="exampleModal" tabindex="-1" aria-hidden="true">
		  <div class="modal-dialog">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLabel">증명서 신청하기</h5>
		        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
		      </div>
		      <form action="/appDoc.do" method = "post">
			      <div class="modal-body" style="text-align: center;">
			        <p class="text-700 lh-lg mb-0">
			        	<b style="color: red;" >신청 전 내정보를 확인해주세요</b><br><br>
			        	<select class="form-select" aria-label="Default select example" name="docName">
						  <option selected="">-증명서를 선택해주세요-</option>
						  <option value="경력증명서">경력증명서</option>
						  <option value="재직증명서">재직증명서</option>
						</select>
			        	<br>
			        	사번: ${empVO.empNo }<br>
			        	이름: ${empVO.empName }<br>
			        	부서: ${empVO.deptVO.deptName }<br>
			        	직위: ${empVO.codeVO.cdName }<br>
			        	<fmt:formatDate value="<%=new Date() %>" pattern="yyyy-MM-dd" var="today"/>
			        	신청날짜: ${today }<br>
			        </p>
			      </div>
		      <div class="modal-footer">
		     	<button class="btn btn-info" type="submit">신청</button>
		      </form>
		      	<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
		      </div>
		    </div>
		  </div>
		</div> 
		
		<br>
		<hr>
		<br>
		<h2>급여 명세서</h2>
		<br>
		<div class="card">
			<div class="card-body">
				<table class="table table-hover" style="margin:0 auto; text-align: center;">
				  <thead>
				    <tr>
				      <th scope="col">귀속월</th>
				      <th scope="col">지급일자</th>
				      <th scope="col">증명서명</th>
				      <th scope="col">다운로드</th>
				    </tr>
				  </thead>
				  <tbody id="tbody2">
				  <c:choose>
				  	<c:when test="${empty salList }">
				  		<tr>
					      <th scope="row" colspan="4">급여 지급 내역이 존재하지 않습니다.</th>
					    </tr>
				  	</c:when>
				  	<c:otherwise>
				  		<c:forEach items="${salList }" var="sal">
						    <tr>
						      <th scope="row">${sal.salBelongmonth}</th>
						      <fmt:formatDate value="${sal.salActrsfdate }" pattern="yyyy-MM-dd" var="date"/>
						      <td>${date }</td>
						      <td>
							      	급여명세서
						      </td>
						      <td class="text-primary salDoc">
							      	<span data-cd="${sal.salNo }"><button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-target="showRegno">명세서 다운로드</button></span>
						      </td>
						    </tr>
				  		</c:forEach>
				  	</c:otherwise>
				  </c:choose>
				  </tbody>
				</table>
			</div>
		</div>
		<br>
				<!-- ------------------------------------------------------------------------- -->
				<div class="modal fade" id="showRegno" tabindex="-1" aria-hidden="true">
				  <div class="modal-dialog modal-dialog-centered">
				    <div class="modal-content">
				      <div class="modal-header">
				        <h5 class="modal-title">주민번호 표시 여부</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
				      </div>
				      <div class="modal-body">
				        <p class="text-700 lh-lg mb-0">
				        	<select class="form-select" aria-label="Default select example" name="regNo">
							  <option selected="">-주민번호 출력 여부-</option>
							  <option value="all">전체 출력</option>
							  <option value="secret">뒷자리 가리기</option>
							</select>
						</p>
				      </div>
				      <div class="modal-footer"><button class="btn btn-info" type="button" id="showDocBtn">확인</button>
				      <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button></div>
				    </div>
				  </div>
				</div>
</body>
<script type="text/javascript">
// var updateDocSeTd = $(".updateDocSeTd");

// updateDocSeTd.each(function(){
// 	$(this).on("click",function(){
// 		var docName = $(this).text();
// 		var docCd = $(this).find(".docCd").val();
// 		console.log("docCd : "+docCd);
// 		console.log("docName : "+docName);
// 		// 상태값 없데이트 ajax
// 		var data ={
// 				docCd : docCd
// 		}
// 		$.ajax({
// 			type : "post",
// 			url : "/updateDocSe.do",
// 			data : JSON.stringify(data),
// 			contentType : "application/json; charset=utf-8",
// 			success : function(res){
// 				console.log("res : "+res)
				
// 			}
// 		});
// 		// 상태값 없데이트 ajax 끝
		
		
// 		openPopup(docName)
// 	});
// });
// 주민번호 출력 여부 모달창
var showRegno = $("#showRegno");

$("#tbody").on("click", ".updateDocSeTd", function(){
	console.log();
	var docText = $(this).find("span").data("text");
	var docCd = $(this).find("span").data("cd");
	console.log("docText  : "+ docText);
	showRegno.modal("show");
	
	$("#showDocBtn").on("click", function(){
		
		var regNo = $("select[name='regNo']").val();
		
		console.log("selected ",regNo);
		
		openPopup(docText,docCd,regNo);
	});
	
	var data ={
		docCd : docCd
	}
	// 증명서 상태값 변경
	$.ajax({
		type : "post",
		url : "/updateDocSe.do",
		data : JSON.stringify(data),
		contentType : "application/json; charset=utf-8",
		success : function(res){
			console.log("res : "+res)
		}
	});
});

$("#tbody2").on("click",".salDoc", function(){
	
	
	var docText = "급여명세서";
	var salNo = $(this).find("span").data("cd");
	console.log("docText  : "+ docText);
	console.log("salNo  : "+ salNo);
	showRegno.modal("show");
	
	$("#showDocBtn").on("click", function(){
		var regNo = $("select[name='regNo']").val();
		console.log("selected ",regNo);
		openPopup(docText,salNo,regNo);
	});
	
});


function openPopup(docName,docCd,regNo){
	
	console.log("팝업창에 들어오는 값 docCd  : "+docCd);
	console.log("팝업창에 들어오는 값 확인  : "+docName);
	if(docName === "재직증명서"){
		 window.open('${pageContext.request.contextPath}/historydetail.do?docCd='+docCd+"&regNo="+regNo, 'document', 'left=600, width=815, height=800, scrollbars=yes');
	}else if(docName === "경력증명서"){
		 window.open('${pageContext.request.contextPath}/proofEmp.do?docCd='+docCd+"&regNo="+regNo, 'document', 'left=600, width=815, height=800, scrollbars=yes');
	}else if(docName ==="급여명세서"){
		 window.open('${pageContext.request.contextPath}/paystub.do?docCd='+docCd+"&regNo="+regNo, 'document', 'left=600, width=815, height=800, scrollbars=yes');
	}
	
}
</script>
</html>