<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<style>
.text-button {
	background: none;
	border: none;
	color: inherit; /* 기본 텍스트 색상을 사용 */
	text-decoration: none;
	cursor: pointer;
	padding: 0; /* 선택적으로 내부 여백 제거 */
}
</style>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내업무현황</title>

</head>
<body>
	<!-- 오늘 날짜 -->
	<c:set var="tdate">
		<fmt:formatDate value="${today}" pattern="yyyy-MM-dd" />
	</c:set>
	
	<!-- 완료여부 -->
	<c:set var="ynCnt" value="0" />
	<c:set var="yCnt" value="0" />
	<c:set var="nCnt" value="0" />
	<c:forEach items="${taskdetList }" var="taskdet">
		<c:set var="ynCnt" value="${ynCnt + 1 }" />
		<c:if test="${taskdet.tdStatusse eq 'y'}">
			<c:set var="yCnt" value="${yCnt + 1 }" />
		</c:if>
		<c:if test="${taskdet.tdStatusse eq 'n'}">
			<c:set var="nCnt" value="${nCnt + 1 }" />
		</c:if>
	</c:forEach>

	<div class="container">
		<!-- 	<button class="btn btn-secondary me-1 mb-1 uil-arrow-circle-left fs-1" type="button" onclick="location.href='/task.do'"></button> -->

		<h2 style="margin-bottom: 20px;">
			<c:choose>
				<c:when test="${loginId eq 'admin'}">
					<a href="/adminTask.do">업무현황</a> > 업무상세
				</c:when>
				<c:otherwise>
					<a href="/task.do">내업무현황</a> > 업무상세
				</c:otherwise>
			</c:choose>
		</h2>
<!-- 		<span class="text-danger" data-feather="check"></span> -->
<!-- 	   	업무에 따른 내용과 세부업무, 그리고 세부업무 진행도 파악이 가능합니다. -->
		<br>
<!-- 		<div class="col-12"> -->
			<div class="row g-2">
				<div class="col-12 col-xl-12">
					<div class="card mb-3">
						<div class="card-body">
							<div class="row">
								<div class="col-6">
									<p style="font-size: 20px;">${taskVO.taskTitle }<span style="margin-right: 20px;"></span>
										<c:if test="${yCnt ne 0 }">
											<button class="btn btn-outline-info me-1 mb-1" type="button" style="height: 37px;"
												onclick="location.href='/taskgantt.do?taskCd=${taskVO.taskCd}'">세부업무 진행도</button>
										</c:if>
										<c:if test="${yCnt eq 0 }">
											<button class="btn btn-outline-info me-1 mb-1" type="button"
												style="height: 37px;"
												onclick="location.href='/taskgantt.do?taskCd=${taskVO.taskCd}'"
												disabled>세부업무 진행도</button>
										</c:if>
									</p>
								</div>
								<div class="col-6 text-end">
									<c:if test="${loginId eq taskVO.chargeEmp}">
										<button class="btn btn-outline-info me-1 mb-1" type="button"
											style="height: 37px;"
											onclick="location.href='/updatetask.do?taskCd=${taskVO.taskCd}'">수정</button>
										<button class="btn btn-outline-info me-1 mb-1" type="button"
											style="height: 37px;" id="delBtn">삭제</button>
									</c:if>
								</div>
							</div>



							<%-- 		<c:forEach items="${taskdetList }" var="taskdet"> --%>
							<%-- 			<c:set var="ynCnt" value="${ynCnt + 1 }" /> --%>
							<%-- 			<c:if test="${taskdet.tdStatusse eq 'y'}"> --%>
							<%-- 				<c:set var="yCnt" value="${yCnt + 1 }" /> --%>
							<%-- 			</c:if> --%>
							<%-- 			<c:if test="${taskdet.tdStatusse eq 'n'}"> --%>
							<%-- 				<c:set var="nCnt" value="${nCnt + 1 }" /> --%>
							<%-- 			</c:if> --%>
							<%-- 		</c:forEach> --%>
							<%-- 		<span>ynCnt : ${ynCnt }, </span> <span>yCnt : ${yCnt }, </span> <span>nCnt --%>
							<%-- 			: ${nCnt }</span> --%>

							<div class="float">
								<div class="d-flex">
									<div class="col-4">
										<div class="progress" style="height: 15px; width: 500px;">

											<c:choose>
												<c:when test="${yCnt ne 0}">
													<c:set var="per" value="${yCnt * 100 / ynCnt}"></c:set>
													<fmt:formatNumber var="roundedPer" value="${per}"
														type="number" maxFractionDigits="0" />
													<div class="progress-bar bg-success" role="progressbar"
														style="width: ${roundedPer}%"
														aria-valuenow="${roundedPer}" aria-valuemin="0"
														aria-valuemax="100">${roundedPer}%</div>
												</c:when>

												<c:when test="${yCnt eq 0 }">
													<c:set var="per" value="${0}"></c:set>
													<div class="progress-bar bg-success" role="progressbar"
														style="width: 0%" aria-valuenow="0" aria-valuemin="0"
														aria-valuemax="100">${per }%</div>
												</c:when>
											</c:choose>
										</div>
									</div>

									<!-- 업무 기간 -->
									<div style="margin: 0 auto;">
										<c:set var="startdate" value="${taskVO.taskStartdate}" />
										<c:set var="enddate" value="${taskVO.taskEnddate}" />
										<p>${fn:substring(startdate,0,10)}~${fn:substring(enddate,0,10)}</p>
									</div>
								</div>
							</div>

							<div class="float">
								<div class="d-flex">
									<div >
										<h4>책임자</h4>
									</div>
									<span style="width: 10px;"></span>
<!-- 									<div class="col-2"> -->
										<%-- 					<span>${taskVO.chargeEmp }</span> --%>
										<div class="avatar avatar-xl " data-bs-toggle="tooltip" data-bs-placement="top" title="${taskVO.empName }(${taskVO.chargeEmp })">
											<img class="rounded-circle " src="${pageContext.request.contextPath }${taskVO.empPhoto}" alt="" />
										</div>
<!-- 										<div class="avatar avatar-xl "> -->
<!-- 											<img class="rounded-circle " -->
<%-- 												src="${pageContext.request.contextPath }${taskVO.empPhoto}" --%>
<!-- 												alt="" /> -->
<!-- 										</div> -->
<!-- 									</div> -->
								</div>
							</div>

							<c:set var="keywordArr" value="${fn:split(taskVO.teamempPhotos,', ')}"></c:set>
							<div class="float" style="margin-top:5px;">
								<div class="d-flex">
									<div>
										<h4>팀원</h4>
									</div>
									<span style="width: 10px;"></span>
<%-- 									<c:forEach var="word" items="${keywordArr}"> --%>
										<c:forEach var="teamempList" items="${teamempList}">
										<%-- 					<span>${word }</span> --%>
										<c:choose>
											<c:when test="${empty teamempList}">
												<div>
													<span>팀원이 존재하지 않습니다.</span>
												</div>
											</c:when>
											<c:otherwise>
												<div>
													<div class="addTd avatar avatar-xl " data-bs-toggle="tooltip" style="cursor:pointer" data-bs-placement="top" title="${teamempList.empName }(${teamempList.empNo })">
<!-- 														<button type="button" onclick=""> -->
															<img class="rounded-circle " onclick="" src="${pageContext.request.contextPath }${teamempList.empPhoto}" alt="" onclick="openModal('exampleModal-${teamempList.empNo }')"/>
<!-- 														</button> -->

													</div>
												</div>
												
												
											</c:otherwise>
										</c:choose>
									</c:forEach>
									
								</div>
							</div>
							
							
							
							
							<div class="float" style="margin-top:5px;">
								<div class="d-flex">
									<div>
										<h4>세부업무를 담당하지 않은 팀원</h4>
									</div>
									<span style="width: 10px;"></span>
									<c:forEach var="notworkempList" items="${notworkempList}">
										<c:choose>
											<c:when test="${empty notworkempList}">
												<div>
													<span>팀원이 존재하지 않습니다.</span>
												</div>
											</c:when>
											<c:otherwise>
												<div>
													<div class="avatar avatar-xl" data-bs-toggle="tooltip" data-bs-placement="top" title="${notworkempList.empName }(${notworkempList.tdEmpno })">
														<img class="rounded-circle " src="${pageContext.request.contextPath }${notworkempList.empPhoto}" alt="" />
														
<!-- 														<button class="text-button dropdown-item" type="button" data-bs-toggle="modal" -->
<%-- 																							data-bs-target="#exampleModal-${taskdet.tdCd }" style="margin-top: 5px;"> --%>
													</div>
<!-- 													</div> -->
												</div>
												
												
											</c:otherwise>
										</c:choose>
									</c:forEach>

								</div>
							</div>
							<br>

							<div class="float">
								<div class="d-flex">
									<div>
										<h4>업무 유형</h4>
									</div>
									<span style="width: 10px;"></span>
									<c:choose>
										<c:when test="${empty taskVO.taskType }">
											<p>업무 유형이 존재하지 않습니다.</p>
										</c:when>
										<c:otherwise>
											<p>${taskVO.taskType }</p>
										</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="float">
								<div class="d-flex">
									<div>
										<h4>업무 내용</h4>
									</div>
									<span style="width: 10px;"></span>
									<c:choose>
										<c:when test="${empty taskVO.taskContent }">
											<p>업무 내용이 존재하지 않습니다.</p>
										</c:when>
										<c:otherwise>
											<p>${taskVO.taskContent }</p>
										</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="float">
								<div class="d-flex">
									<div>
										<h4>비고</h4>
									</div>
									<span style="width: 10px;"></span>
									<c:choose>
										<c:when test="${empty taskVO.taskMemo }">
											<p>프로젝트 메모가 존재하지 않습니다.</p>
										</c:when>
										<c:otherwise>
											<p>${taskVO.taskMemo }</p>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
							<br>


							<!-- 세부업무 테이블 -->
							<div class="float">
								<div class="d-flex justify-content-between">
									<div>
										<h4>세부업무</h4>
									</div>
									<div class="ms-auto">
										<c:if test="${loginId eq taskVO.chargeEmp}">
											<button class="align-middle btn btn-outline-info me-1 mb-1"
												type="button" style="height: 37px;" onclick="showform()">추가</button>
										</c:if>
									</div>
								</div>
							</div>
							<!-- 테이블 -->


							<c:choose>
								<c:when test="${empty taskdetList }">
									<span style="width: 100px;">세부업무가 존재하지 않습니다</span>
									<%-- 				<c:if test="${loginId eq taskVO.chargeEmp}"> --%>
									<!-- 					<button class="align-middle btn btn-outline-info me-1 mb-1" -->
									<!-- 						type="button" style="height: 37px;" onclick="showform()">추가</button> -->
									<%-- 				</c:if> --%>
								</c:when>
								<c:otherwise>
									<tbody class="list" id="purchasers-sellers-body tdbody">
										<div class="border-top">
											<div id="purchasersSellersTable"
												data-list='{"valueNames":["deals_name","deal_owner","account_name","stage","amount"],"page":5,"pagination":true}'>
												<div class="table-responsive scrollbar mx-n1 px-1">

													<div class="table-responsive mx-n1 px-1 scrollbar">
														<table class="table fs--1 mb-0 border-top border-200">
															<thead>
																<tr>
																	<th width="14%" class="align-middle">담당자</th>
																	<th width="40%" class="text-start ps-5 align-middle">내용</th>
																	<th width="1%" class="text-start ps-5 align-middle">시작일</th>
																	<th style="min-width: 100px;" width="1%"
																		class="text-start ps-5 align-middle">완료일</th>
																	<th style="min-width: 100px;" width="1%"
																		class="text-start ps-5 align-middle">마감일</th>
																	<th width="20%" class="text-start ps-5 align-middle">비고</th>
																	<th width="8%" class="text-start ps-5 align-middle">상태</th>
																	<th width="8%" class="text-start ps-5 align-middle">-</th>
																</tr>
															</thead>
															<tbody class="list" id="table-latest-review-body">
																<c:set var="ynCnt" value="0" />
																<c:set var="yCnt" value="0" />
																<c:set var="nCnt" value="0" />
																<c:forEach items="${taskdetList }" var="taskdet">

																	<c:set var="ynCnt" value="${ynCnt + 1 }" />
																	<c:if test="${taskdet.tdStatusse eq 'y'}">
																		<c:set var="yCnt" value="${yCnt + 1 }" />
																	</c:if>
																	<c:if test="${taskdet.tdStatusse eq 'n'}">
																		<c:set var="nCnt" value="${nCnt + 1 }" />
																	</c:if>
																	
																	<tr class="hover-actions-trigger btn-reveal-trigger position-static">
																		<td class="align-middle">
																			<div class="d-flex align-items-center position-relative">
																				<div class="avatar avatar-xl ">
																					<img class="rounded-circle " src="${pageContext.request.contextPath }${taskdet.tdEmpphoto}" alt="" />
																				</div>
																				<%-- 															<h6 class="mb-0 ms-3 text-900">${taskdet.tdEmpno }</h6> --%>
																				<h6 class="text-900">${taskdet.tdEmpname }</h6>
																				<script type="text/javascript">
																					<!-- 해당 담당자의 empNo 값을 JavaScript 변수에 저장 -->
																					var selectedEmpNo = ${taskdet.tdEmpno };
																					
																					// 해당 담당자의 empNo를 가진 옵션을 선택하도록 JavaScript로 설정
																					var selectElement = document.getElementById("teamsell");
																					for (var i = 0; i < selectElement.options.length; i++) {
																					    if (selectElement.options[i].value === selectedEmpNo) {
																					        selectElement.selectedIndex = i;
																					        break;
																					    }
																					}
																					</script>
																			</div>
																		</td>
																		<c:set var="tdstartdate"
																			value="${taskdet.tdStartdate}" />
																		<c:set var="tdclosedate"
																			value="${taskdet.tdClosedate}" />
																		<c:set var="tdenddate" value="${taskdet.tdEnddate}" />
																		<td class="account_name align-middle white-space-nowrap ps-4 fw-semi-bold text-900 py-0">
																			${taskdet.tdContent }
																		</td>
																		<td class="account_name align-middle white-space-nowrap ps-4 fw-semi-bold text-900 py-0">
																			${fn:substring(tdstartdate,0,10)}
																		</td>
																		<td class="account_name align-middle white-space-nowrap ps-4 fw-semi-bold text-900 py-0">
																			${fn:substring(tdenddate,0,10)}
																		</td>
																		<td class="account_name align-middle white-space-nowrap ps-4 fw-semi-bold text-900 py-0">
																			${fn:substring(tdclosedate,0,10)}
																		</td>
																		<td class="account_name align-middle white-space-nowrap ps-4 fw-semi-bold text-900 py-0">
																			${taskdet.tdMemo }
																		</td>
																		<td class="align-middle text-start ps-5 status">
																			<c:if test="${taskdet.tdStatusse eq 'y'}">
																				<span class="badge badge-phoenix fs--2 badge-phoenix-success">
																					<span class="badge-label">작업완료</span> <svg
																						xmlns="http://www.w3.org/2000/svg" width="16px"
																						height="16px" viewBox="0 0 24 24" fill="none"
																						stroke="currentColor" stroke-width="2"
																						stroke-linecap="round" stroke-linejoin="round"
																						class="feather feather-check ms-1"
																						style="height: 12.8px; width: 12.8px;">
																	<polyline points="20 6 9 17 4 12"></polyline>
																</svg>
																				</span>
																			</c:if> 
																			<c:if test="${taskdet.tdStatusse eq 'n'}">
																				<span class="badge badge-phoenix fs--2 badge-phoenix-warning">
																					<span class="badge-label">작업중</span> 
																					<svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 24 24" fill="none"
																							stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
																							class="feather feather-clock ms-1" style="height: 12.8px; width: 12.8px;">
																						<circle cx="12" cy="12" r="10"></circle>
																						<polyline points="12 6 12 12 16 14"></polyline>
																					</svg>
																				</span>
																			</c:if>
																		</td>
																		<td class="align-middle white-space-nowrap pe-0">
																			<c:if test="${loginId eq taskdet.tdEmpno or loginId eq taskVO.chargeEmp}">
																				<div
																					class="font-sans-serif btn-reveal-trigger position-static">
																					<button
																						class="btn btn-sm dropdown-toggle dropdown-caret-none transition-none btn-reveal fs--2"
																						type="button" data-bs-toggle="dropdown"
																						data-boundary="window" aria-haspopup="true"
																						aria-expanded="false" data-bs-reference="parent">
																						<svg id="svgfocus-${taskdet.tdCd }"
																							class="svg-inline--fa fa-ellipsis fs--2"
																							aria-hidden="true" focusable="false"
																							data-prefix="fas" data-icon="ellipsis" role="img"
																							xmlns="http://www.w3.org/2000/svg"
																							viewBox="0 0 448 512" data-fa-i2svg="">
																			<path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg>
																						<!-- <span class="fas fa-ellipsis-h fs--2"></span> Font Awesome fontawesome.com -->
																					</button>


																					<div class="dropdown-menu dropdown-menu-end py-2">
																						<form id="completeTaskForm" action="/tkturny.do" method="POST">
																							<input type="hidden" name="tdCd" id="tddcdd" value="${taskdet.tdCd}"> 
																							<input type="hidden" name="taskCd" value="${taskVO.taskCd}">
																							<button class="text-button dropdown-item" type="submit" style="margin-top: 5px;">
																								<span style="margin-left: 20px; font-size: 14px;">작업완료</span>
																							</button>
																						</form>
																						<form id="completeTaskForm" action="/tkturnn.do"
																							method="POST">
																							<input type="hidden" name="tdCd"
																								value="${taskdet.tdCd}"> <input
																								type="hidden" name="taskCd"
																								value="${taskVO.taskCd}">
																							<button class="text-button dropdown-item" type="submit" style="margin-top: 5px;">
																								<span style="margin-left: 20px; font-size: 14px;">작업중</span>
																							</button>
																						</form>
																						<%-- 																		<c:if test="${loginId eq taskVO.chargeEmp }"> --%>
																						<button class="text-button dropdown-item" type="button" data-bs-toggle="modal"
																							data-bs-target="#exampleModal-${taskdet.tdCd }" style="margin-top: 5px;">
																							<span style="margin-left: 20px; font-size: 14px;">수정</span>
																						</button>


																						<div class="dropdown-divider"></div>
																						<form id="completeTaskForm" action="/tkdelete.do" method="POST">
																							<input type="hidden" name="tdCd" value="${taskdet.tdCd}"> 
																							<input type="hidden" name="taskCd" value="${taskVO.taskCd}">
																							<button class="text-button dropdown-item" type="submit">
																								<span style="margin-left: 20px; font-size: 14px;">삭제</span>
																							</button>
																						</form>
																					</div>

																					


																					<!-- 수정모달 -->
																					<div class="modal fade" id="exampleModal-${taskdet.tdCd }" tabindex="0" aria-hidden="true">
																						<div class="modal-dialog">
																							<div class="modal-content">
																								<form class="needs-validation" action="/tkdetailupdate.do" novalidate="" method="post">
																									<div class="col-md-6 input-group has-validation">
																										<input class="form-control" type="hidden" id="validationCustomUsername" name="taskCd" aria-describedby="inputGroupPrepend" required="" value="${taskVO.taskCd }">
<!-- 																										<div class="invalid-feedback">Please choose a username.</div> -->
																									</div>
																									<input type="hidden" name="tdCd" value="${taskdet.tdCd }">
																									<div class="modal-header">
																										<h5 class="modal-title" id="exampleModalLabel">세부업무 수정</h5>
																										<button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
																											<span class="fas fa-times fs--1"></span>
																										</button>
																									</div>
																									<div class="modal-body">

																										<div>
																											<label for="validationCustom03">*내용</label> 
																											<input class="form-control" name="tdContent" id="validationCustom03" type="text" required="" value="${taskdet.tdContent }">
																											<div class="invalid-feedback">내용을 입력해주세요.</div>
																										</div>
																										<br>

																										<div>
																											<label for="validationCustom03">비고</label> 
																											<input class="form-control" type="text" name="tdMemo" value="${taskdet.tdMemo }" />
																										</div>
																										<br>

																										<div>
																											<label for="validationCustom03">*마감일</label>
																											<c:set var="tdClosedate" value="${taskdet.tdClosedate}" />
																											<input class="form-control" id="UpdateTdClosedate" min="${fn:substring(startdate,0,10)}" max="${fn:substring(enddate,0,10)}" style="width: 250px;"
																												name="tdClosedate" id="validationCustom03" type="date" name="tdClosedate" required="" value="${fn:substring(tdClosedate,0,10)}">
																											<div class="invalid-feedback">마감일을 입력해주세요.</div>
																										</div>
																										<br>
																										<!-- 해당 세부업무 담당자를 선택된 채로... -->
																										<div>
																											<label for="validationCustom03">*담당자</label> 
																											<select id="teamsell" class="form-select form-select-sm" aria-label=".form-select-sm example" style="width: 250px;" name="tdEmpno">
																											    <option value="${taskVO.chargeEmp }" ${taskVO.chargeEmp eq taskdet.tdEmpno ? 'selected' : ''}>${taskVO.chargeEmp }</option>
																											    <c:forEach items="${teamempList }" var="teamEmp">
																											        <option value="${teamEmp.empNo }" ${teamEmp.empNo eq taskdet.tdEmpno ? 'selected' : ''}>${teamEmp.empName }(${teamEmp.empNo })</option>
																											    </c:forEach>
																											</select>

																										</div>
																									</div>
																									<div class="modal-footer">
																										<button class="btn btn-primary" type="submit">수정</button>
																										<button class="btn btn-outline-primary" type="button" data-bs-dismiss="modal">취소</button>
																									</div>
																								</form>
																							</div>
																						</div>
																					</div>
																					<!-- 수정모달 -->
																				</div>
																			</c:if>
																		</td>
																	</tr>
																</c:forEach>
															</tbody>
														</table>
													</div>

												</div>
												<!-- 페이징 -->
											</div>
										</div>
									</tbody>

								</c:otherwise>
							</c:choose>




							<!-- 세부업무 추가 테이블 -->
							<div id="tkdetailform" style="display: none;">
								<form class="needs-validation" id="taskform" method="post" name="testForm" novalidate=""
									action="/taskdetinsert.do">
									<input type="hidden" name="taskCd" value="${taskVO.taskCd }">
									<table class="table table-sm fs--1 leads-table">
										<thead>
											<%-- 											<tr>${teamempList.taskCd }</tr> --%>
											<tr>
												<td style="width: 20px;">*담당자 지정</td>
												<td>*내용</td>
												<td>비고</td>
												<td>*마감일</td>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>
													<select id="teamsel"  class="form-select form-select-sm" aria-label=".form-select-sm example" style="width: 150px;" name="tdEmpno">
															<option>팀원</option>
															<option value="${taskVO.chargeEmp }">${taskVO.chargeEmp }</option>
															<c:forEach items="${teamempList }" var="teamEmp">
																<option value="${teamEmp.empNo }">${teamEmp.empName }(${teamEmp.empNo })</option>
															</c:forEach>
													</select>
												</td>
												<td>
													<input class="form-control mb-xl-3" id="validationCustom03" required="" type="text" placeholder="내용" name="tdContent" value="${taskVO.tdContent }" />
													<div class="invalid-feedback">내용을 입력해주세요.</div>
												</td>
												<td>
													<input class="form-control mb-xl-3" type="text" placeholder="비고" name="tdMemo" value="${taskVO.tdMemo }" />
												</td>

												<td width="10px">	
													<input class="form-control mb-xl-3" type="date" id="tdClosedate" required="" name="tdClosedate" min="${fn:substring(startdate,0,10)}" max="${fn:substring(enddate,0,10)}" value="${tdate }"/>
													<div class="invalid-feedback">마감일을 선택해주세요.</div>
												</td>
												<%-- 							<c:if test="${taskVO.tdClosedate > taskVO.taskEnddate  }"> --%>

												<%-- 							</c:if> --%>
											</tr>
										</tbody>
									</table>
									<div class="float-end">
										<button class="btn btn-outline-info me-1 mb-1 container-small" type="button" style="width: 70px;" onclick="hideform()">취소</button>
										<button class="btn btn-outline-info me-1 mb-1 container-small" id="subBtn" type="submit" style="width: 70px;">등록</button>
										<br><br><br><br>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
<!-- 		</div> -->
	</div>



<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
// 이미지에 모달 연결하기
function openModal(modalId) {
    var modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = 'block';
    }
}

$("#delBtn").on("click",function(){
 	customConfirm('정말 삭제하시겠습니까?').then((userConfirmed) => {
         if (userConfirmed) { 
         	location.href='/taskdelete.do?taskCd=${taskVO.taskCd}';
         }
     });
});

var inputElement = document.getElementById("tdClosedate");

inputElement.addEventListener("change", function() {
    var selectedDate = new Date(this.value);
    var today = new Date();
    
    if (selectedDate < today) {
        alert("오늘 이전의 날짜를 선택할 수 없습니다.");
        this.value = ""; // 변경된 날짜를 취소하고
        this.valueAsDate = today; // 오늘 날짜로 설정
    }
});

var UpdateClosedate = document.getElementById("UpdateTdClosedate");

UpdateClosedate.addEventListener("change", function() {
    var TdClosedate = new Date(this.value);
    var today = new Date();
    
    if (TdClosedate < today) {
        alert("오늘 이전의 날짜를 선택할 수 없습니다.");
        this.value = ""; // 변경된 날짜를 취소하고
        this.valueAsDate = today; // 오늘 날짜로 설정
    }
});

document.getElementById("subBtn").addEventListener("click", function (event) {
    var selectedValue = document.getElementById("teamsel").value;
    
    if (selectedValue === "팀원") {
        alert("팀원을 선택해주세요.");
        event.preventDefault(); // 등록을 중지합니다.
    }
});

function showform() {
	$('#tkdetailform').show();
	document.getElementById("teamsel").focus();
}
function hideform() {
    $('#tkdetailform').hide();
}

$.ajax({
    url: '/tasklistajax.do?taskCd=${taskVO.taskCd}',
    method: 'GET',
    dataType: 'json',
    success: function (taskVO) {
// 	   console.log("업무 제목 : ", taskVO.taskTitle);
	   var std = taskVO.taskStartdate;
	   var edd = taskVO.taskEnddatesubstr(0, 10);
// 	   var endd = str.substr(0, 10);
	
	   console.log("마감일 : ", edd);
	   
	   // 현재 날짜 가져오기
	   var today = new Date();
	   var dd = String(today.getDate()).padStart(2, '0');
	   var mm = String(today.getMonth() + 1).padStart(2, '0');
	   var yyyy = today.getFullYear();

	   today = yyyy + '-' + mm + '-' + dd;

	   // tdClosedate 입력 필드 가져오기
// 	   var tdClosedateInput = document.querySelector('input[name="tdClosedate"]');
	   
// 	   tdClosedateInput.max = edd;
	}
});

function setMinimumTaskEndDate() {
  // 현재 날짜 가져오기
  var today = new Date();
  var dd = String(today.getDate()).padStart(2, '0');
  var mm = String(today.getMonth() + 1).padStart(2, '0');
  var yyyy = today.getFullYear();

  today = yyyy + '-' + mm + '-' + dd;

  // taskenddate 입력 필드 가져오기
  var taskEnddateInput = document.querySelector('input[name="taskEnddate"]');

  // taskenddate 입력 필드의 최소 날짜를 오늘로 설정
  taskEnddateInput.min = today;
}


</script>
</html>
