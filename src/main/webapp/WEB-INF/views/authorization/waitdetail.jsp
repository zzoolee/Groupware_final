<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결재대기문서</title>
</head>

<sec:authentication property="principal.emp" var="emp"/>
<h2 class="uil-file-question"><a href="/auth/waitdoc.do">결재함</a> > 결재 대기 문서</h2>
	<br/>	
	<form action="/auth/sign.do" method="post" id="signForm">
		<input type="hidden" name="atrzfCd" value="${waitDetail.atrzfCd }" id="formCd"/>
		<input type="hidden" name="drftCd" value="${waitDetail.drftCd }"/>
		<input type="hidden" name="drftTitle" value="${waitDetail.drftTitle }"/>
		<input type="hidden" name="drftDate" value="${waitDetail.drftDate }"/>
		<input type="hidden" name="drftStartdate" value="${waitDetail.drftStartdate }"/>
		<input type="hidden" name="drftEnddate" value="${waitDetail.drftEnddate }"/>
		<c:forEach items="${pathList }" var="path">
			<c:if test="${path.atrzpEmpno eq emp.empNo }">
				<input type="hidden" name="atrzpOrder" value="${path.atrzpOrder }"/>
			</c:if>
		</c:forEach>
		
		<div>
			<table class="table table-sm" style="vertical-align: middle; height: 70px;">
			    <tr>
			      <th scope="col" style="width: 50px;">* 제목</th>
			      <td colspan="3">${waitDetail.drftTitle }</td>
			    </tr>
			    <tr>
			      <th scope="row">* 기안자</th>
			      <td>${waitDetail.empName } ${waitDetail.cdName}/${waitDetail.deptName }</td>
			      <th>* 기안일</th>
			      	<c:set value="${waitDetail.drftDate }" var="drftDate" />
			      <td style=" width: 100px;">${fn:substring(drftDate,0,16)}</td>
			    </tr>
			    <tr> 
			    	<th scope="col">* 시작일</th>
			    		<c:set var="stdate" value="${waitDetail.drftStartdate }"/>
						<td style="width: 150px; margin-right: 10px;">${fn:substring(stdate,0,10) }</td>
					<th style="width: 50px;">* 종료일</th> 
						<c:set var="enddate" value="${waitDetail.drftEnddate }"/>
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
						        <input type="hidden" name="refEmpno" value="${ref.refEmpno }" id="refEmpno">
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
<!-- 			<textarea id="ckeditor" name="drftContent" class="form-control" rows="14" readonly="readonly"> -->
	<div class="card col-12" style="padding-bottom: 50px;">
		<div><br><br>
			<!-- 결재란 시작 -->
				<div>
					<table border="1" style="width: 450px; margin-right: 150px;  float: right; text-align: center; border-collapse: collapse; table-layout: fixed" >
						<tbody>
							<tr>
								<td rowspan="4" style="width: 20px; border-style: solid; border-width: 1px; border-color: black;">결재란</td>
							</tr>
							<tr>
								<!--기안자 이름  -->
								<td style="border: 1px solid black;">${waitDetail.empName }</td>
								<!-- 결재자 이름 -->
								<c:forEach items="${pathList}" var="path">
									<td style="border: 1px solid black;">${path.empName}</td>
								</c:forEach>
							</tr>
							<!-- 서명사진 -->
							<tr style="height: 60px">
								<td style="border: 1px solid black;"><img width="50px;" src="${waitDetail.empSign }" id="sign1"></td>
								<c:forEach items="${pathList }" var="path">
									<c:if test="${path.atrzpStatusse == '결재'}"><td style="border: 1px solid black;"><img width="50px;" src="${path.empSign }"></td></c:if>
									<c:if test="${path.atrzpStatusse == '대기'}"><td style="border: 1px solid black;"></td></c:if>
									<c:if test="${path.atrzpStatusse == '반려'}"><td style="border: 1px solid black;"><font color="red;">반려</font></td></c:if>
								</c:forEach>
							</tr>
							<tr>
								<!-- 기안올린 날짜 -->
								<c:set var="drftdate" value="${waitDetail.drftDate }"/>
								<td style="border: 1px solid black;">${fn:substring(drftdate,0,10) }</td>
								<!-- 결재한 날짜  -->
								<c:forEach items="${pathList }" var="path">
									<td style="border: 1px solid black;">${fn:substring(path.atrzpDate,0,10) }</td>
								</c:forEach>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- 결재란 끝 -->
				<br><br><br><br><br><br><br><br>
				${waitDetail.drftContent }
<!-- 			</textarea> -->
		</div>
	</div>
<br>
	<div>
		<table class="table table-sm">
		    <tr>
		      <th scope="col" style="width: 200px;">* 제출사유</th>
		      <c:choose>
		      	<c:when test="${empty waitDetail.drftReason }">
			      <td>미작성되었습니다.</td>
		      	</c:when>
				<c:otherwise>
					<td>${waitDetail.drftReason }</td>
				</c:otherwise>
		      </c:choose>
		      <td colspan="2"></td>
		    </tr>
		</table>
	</div>
	<div style="text-align: center;">
		<button class="btn btn-outline-info" type="button" id="waitList">목록</button>
		<button class="uil-redo btn btn-outline-danger" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal">반려</button>
		<button class="uil-check btn btn-info" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal2">승인</button>
	</div>
<br>
	
	<!-- 반려 모달 -->
	<div class="modal fade" id="exampleModal" tabindex="-1" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">반려 사유</h5>
	        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
	      </div>
	      <div class="modal-body">
	        <p class="text-700 lh-lg mb-0">
				<textarea class="form-control" id="memo" name="drftMemo" placeholder="반려 사유를 입력하세요." style="height: 150px"></textarea>
			</p>
	      </div>
	      <div class="modal-footer">
	      	<button class="btn btn-info" type="button" id="returnBtn">확인</button>
	      	<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
	      </div>
	    </div>
	  </div>
	</div>
	<!-- 반려 모달 -->
	
	<!-- 승인 모달 -->
	<div class="modal fade" id="exampleModal2" tabindex="-1" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">승인</h5>
	        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
	      </div>
	      <div class="modal-body" style="padding: 30px;">
	        <p class="text-700 lh-lg mb-0" style="text-align: left;">
	        <sec:authentication property="principal.emp" var="emp"/> 
	       		<!-- 내가 우선순위 2일 때 -->
	       		<c:if test="${pathList[0].atrzpEmpno eq emp.empNo }">
	       			<c:if test="${pathList[0].atrzpStatusse eq '대기' }">
	       				<input class="form-check-input"  type="radio" name="drftAprvse" value="결재"/>
	       				<strong>결재</strong><span style="background: linear-gradient(to top, #FDFA38 40%, transparent 40%);"> [해당 기안이 승인되고 다음 결재자에게 전달됩니다.]</span> 
						<br><br>
	       				<input class="form-check-input"  type="radio" name="drftAprvse" value="전결" />
	       				<b>전결</b><span style="background: linear-gradient(to top, #FDFA38 40%, transparent 40%); "> [해당 기안이 완료로 처리됩니다.]</span>
	       			</c:if> 
	       		</c:if>
	       		
	       		<!-- 내가 우선순위 3일 때 -->
	       		<c:if test="${pathList[1].atrzpEmpno eq emp.empNo }">
	       			<c:if test="${pathList[1].atrzpStatusse eq '대기' && pathList[0].atrzpStatusse eq '결재' }">
	       				<input class="form-check-input"  type="radio" name="drftAprvse" value="결재">
	       				<b>결재</b><span style="background: linear-gradient(to top, #FDFA38 40%, transparent 40%);"> [해당 기안이 승인되고 다음 결재자에게 전달됩니다.]</span> 
						<br><br>
	       				<input class="form-check-input"  type="radio" name="drftAprvse" value="전결"/>
	       				<b>전결</b><span style="background: linear-gradient(to top, #FDFA38 40%, transparent 40%); "> [해당 기안이 완료로 처리됩니다.]</span>
	       			</c:if> 
	       			<c:if test="${pathList[1].atrzpStatusse eq '대기' && pathList[0].atrzpStatusse eq '대기' }">
	       				<input class="form-check-input"  type="radio" name="drftAprvse" value="전결"/>
						<b>전결</b><span style="background: linear-gradient(to top, #FDFA38 40%, transparent 40%); "> [해당 기안이 완료로 처리됩니다.]</span>
	       			</c:if> 
	       		</c:if>
	       		
	       		<!-- 내가 우선순위 4일 때 -->
	       		<c:if test="${pathList[2].atrzpEmpno eq emp.empNo }">
	       			<c:if test="${pathList[1].atrzpStatusse eq '결재' }">
	       				<input class="form-check-input"  type="radio" name="drftAprvse" value="결재"/>
	       				<b>결재</b><span style="background: linear-gradient(to top, #FDFA38 40%, transparent 40%);"> [해당 기안이 완료로 처리됩니다.]</span> 
	       			</c:if> 
	       			<c:if test="${pathList[1].atrzpStatusse eq '대기' }">
	       				<input class="form-check-input"  type="radio" name="drftAprvse" value="전결"/> 
	       				<b>전결</b><span style="background: linear-gradient(to top, #FDFA38 40%, transparent 40%); "> [해당 기안이 완료로 처리됩니다.]</span>
	       			</c:if> 
	       		</c:if>
		   </p>
	      </div>
	      <div class="modal-footer">
	      	<button class="btn btn-info" type="button" id="signBtn">확인</button>
	      	<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
	      </div>
	    </div>
	  </div>
	</div>
</form>


<script type="text/javascript">
$(function(){
	CKEDITOR.replace("ckeditor");
	CKEDITOR.config.width= "100%";
	CKEDITOR.config.height= "500px";
	
	var waitList = $("#waitList");
	var signBtn = $("#signBtn");
	var signForm = $("#signForm");
	var returnBtn = $("#returnBtn");
	var memo = $("#memo");
	
	waitList.on("click", function(){
		location.href ="/auth/waitdoc.do";
	});
	
	
	signBtn.on("click", function(){
		if ($("input[name=drftAprvse]:checked").length == 0) {
	        alert("승인을 선택해주세요.");
	        return false;
	    } else {
	        signForm.submit();
	    }
	});
	
	returnBtn.on("click", function(){
		//console.log(memo.val());
		if(memo.val() == 0 ) {
			alert("사유를 입력해주세요.");
		}else{
			signForm.attr("action", "/auth/retrun.do");
			signForm.submit();
		}
	});
	
	
	
});

</script>
