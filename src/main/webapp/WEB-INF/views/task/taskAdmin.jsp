<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>


<div class="container">

    <h2 style="margin-bottom:10px;">업무현황</h2>
   	<span class="text-danger" data-feather="check"></span>
   	기본 검색은 진행중으로 선택되어 있습니다. 오른쪽 아래의 셀렉트박스에서 대기중, 진행중, 종료를 선택해 해당하는 상태를 검색할 수 있습니다.
    <br><br>
    
    <div class="card col-12">
		<div class="card-body">
<!-- 		<div style="float:right;"> -->
<!-- 	        <button class="btn btn-outline-info me-1 mb-1 " type="button" style="width:130px;height:40px;" onclick="location.href='taskform.do';">업무 등록</button> -->
<!--         </div><br><br> -->
		    <div class="float-end" style="margin-bottom:10px;">
			    <div class="d-flex">
				    <form id="searchForm" action="" method="post">
				        <input type="hidden" id="page" name="page" value="" />
				        <select class="form-select" style="height: 40px;" id="searchType" name="searchType">
				            <option value="allsel" <c:if test="${searchType eq 'allsel'}">selected</c:if>>전체</option>
				            <option value="bef" <c:if test="${searchType eq 'bef'}">selected</c:if>>대기중</option>
				            <option value="ing" <c:if test="${searchType eq 'ing'}">selected</c:if>>진행중</option>
				            <option value="end" <c:if test="${searchType eq 'end'}">selected</c:if>>종료</option>
				        </select>
				<!--         <button class="btn btn-soft-secondary me-1 mb-1" type="submit">검색</button> -->
				    </form>
		        <span style="width:10px;"></span>
			    <button style="height:40px;" class="btn btn-soft-secondary me-1 mb-1" type="button" onclick="submitSearchForm()">검색</button>
			    </div>
			</div>
		    
			
			<c:set value="${pagingVO.dataList }" var="taskList"/>
			<table class="table table-hover">
		        <thead>
		            <tr>
		                <th scope="col">프로젝트명</th>
		                <th scope="col">프로젝트기간</th>
		                <th scope="col">프로젝트유형</th>
		                <th scope="col">책임자</th>
		                <th scope="col">업무진행도</th>
		                <th scope="col">상태</th>
		            </tr>
		        </thead>
		        <tbody style="vertical-align: middle;">
		            <c:choose>
		                <c:when test="${empty taskList}">
		                    <tr>
		                        <td>조회하신 프로젝트가 존재하지 않습니다.</td>
		                    </tr>
		                </c:when>
		                <c:otherwise>
		                    <c:forEach items="${taskList}" var="task">
								<c:set var="startdate" value="${task.taskStartdate}"/> 
								<c:set var="enddate" value="${task.taskEnddate}"/> 
								<c:set var="today" value="<%=new java.util.Date()%>" />
								<c:set var="tdate">
									<fmt:formatDate value="${today}" pattern="yyyy-MM-dd" />
								</c:set> 
		                        <tr>
		                            <td style="font-size:14px;"><a href="taskdetail.do?taskCd=${task.taskCd }">${task.taskTitle}</a></td>
		                            <td style="font-size:14px;">${fn:substring(startdate,0,10)}~ ${fn:substring(enddate,0,10)}</td>
		                            <td style="font-size:14px;">${task.taskType}</td>
		<%--                             <td style="font-size:14px;">${task.empNo}</td> --%>
		                            <td style="font-size:14px;">
		                            	<div class="avatar avatar-xl ">
		            						<img class="rounded-circle " src="${pageContext.request.contextPath }${task.empPhoto}" alt="" />
		<!--             	<img class="rounded-circle " src="assets/img/team/72x72/57.webp" alt="" /> -->
		            					</div>
		           					 </td>
		<%--                             <td>${task.tdTotchk}</td> --%>
		<%--                             <td>${task.tdYchk}</td> --%>
		                            <td>
		                            <div class="progress" style="height:15px; width:100px;">
			                           	<c:choose>
											<c:when test="${task.tdYchk ne 0}">
											    <c:set var="per" value="${task.tdYchk * 100 / task.tdTotchk}"></c:set>
											    <fmt:formatNumber var="roundedPer" value="${per}" type="number" maxFractionDigits="0" />
											    <div class="progress-bar bg-success" role="progressbar" style="width: ${roundedPer}%"
											         aria-valuenow="${roundedPer}" aria-valuemin="0" aria-valuemax="100">${roundedPer}%</div>
											</c:when>
							
											<c:when test="${task.tdYchk eq 0 }">
												<c:set var="per" value="${0}"></c:set>
												<div class="progress-bar bg-success" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">${per }%</div>
											</c:when>
										</c:choose>
		                            </div>
		                            </td>
		                            <!-- 팀원 -->
		                            <%-- <c:choose>
			                            <c:when test="${empty task.teamEmp}">
				                            <td>팀원이 존재하지 않습니다.</td>
			                            </c:when>
			                            <c:otherwise>
				                            <td>${task.teamEmp}</td>
			                            </c:otherwise>
		                            </c:choose> --%>
		                            <c:set value="대기중" var="result"/>
		                            <c:set value="secondary" var="color"/>
		                            <c:choose>
		                            	<c:when test="${(tdate >= fn:substring(startdate,0,10)) and (tdate <= fn:substring(enddate,0,10))}">
		                            		<c:set value="진행중" var="result"/>
		                            		<c:set value="info" var="color"/>
		                            	</c:when>
										<c:when test="${(fn:substring(enddate,0,10)) < tdate}">
											<c:set value="종료" var="result"/>
											<c:set value="success" var="color"/>
		                            	</c:when> 
		                            </c:choose>
		                        	<td><span class="badge badge-phoenix badge-phoenix-${color }">${result }</span></td>
		                        </tr>
		                    </c:forEach>
		                </c:otherwise>
		            </c:choose>
		        </tbody>
		    </table>
		
		    <nav aria-label="Page navigation example" id="pagingArea">
				${pagingVO.pagingHTML }
			</nav>
	    </div>
	</div>
	
	<br>
</div>

<script type="text/javascript">
$(function(){
	var searchForm = $("#searchForm");
	var pagingArea = $("#pagingArea");
	
	pagingArea.on("click", "a", function(event){
		event.preventDefault();
		var pageNo = $(this).data("page");
		searchForm.find("#page").val(pageNo);
		searchForm.submit();
	});
});

function submitSearchForm() {
    document.getElementById("searchForm").submit();
}
</script>
