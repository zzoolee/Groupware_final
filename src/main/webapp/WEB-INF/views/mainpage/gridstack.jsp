<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/gridstack.js/9.2.2/gridstack.min.css" integrity="sha512-c0A8wU7VMWZRt4qqDc+AxarWQ2XFsQcrJGABe1eyCNxNfj2AI4+YYTytjGlHdrSk7HxA4jHakbXLzw/O/W5WmA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/gridstack.js/9.2.2/gridstack-extra.min.css" integrity="sha512-287EQpO1sItRDNvuCUARDlhpQs3qLRCMaidpOKp5BFu6EgcX3XxB92jmTvdXWW57Q9ImHcYqIHKx12EATT3sPA==" crossorigin="anonymous" referrerpolicy="no-referrer" /> -->

<script type="module" src="https://unpkg.com/ionicons@4.5.10-0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule="" src="https://unpkg.com/ionicons@4.5.10-0/dist/ionicons/ionicons.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="chart-test.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/gridstack.js/9.2.2/gridstack-all.min.js" integrity="sha512-5HTU6mahI/Gm/8o09h6r4B4mTypnVZnM0VgWqLVKJDgBxqbxt7JTqraIdGINJ3fp/5ek/k73kmAE6UitSWPZhw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<%
   Date now = new Date();
   pageContext.setAttribute("now", now);
%>
<fmt:formatDate value="${now}" pattern="HH:mm" var="formattedDate" />
<sec:authentication property='principal.emp.empName' var="empName"/>

<style type="text/css">
/*   .grid-stack { background: #FAFAD2; } */
/*   .grid-stack-item-content { background-color: #18BC9C; } */
</style>

<div class="row">
   <div class="col-md-12">
      <div class="float-end">
            <a class="btn btn-info me-1 mb-1" href="/setgrid.do">포틀릿 설정</a><br>
      </div>
   </div>
   <div class="col-md-12">
      <div class="grid-stack">
      <c:choose>
      	<c:when test="${empty portletList}">
      		<div class="d-flex justify-content-center align-items-center mt-3" style="padding-top:100px;">
      		<span class="text-info" data-feather="box" style="height: 50px; width: 50px;"></span>&nbsp;&nbsp;&nbsp;&nbsp;
      		<h3 class="mb-0 text-primary position-relative">포틀릿 설정으로 메인대쉬보드 커스텀이 가능합니다.</h3>
      		</div>
      	</c:when>
      	<c:otherwise>
      	
      <c:if test="${!empty portletList}">
         <!-- 포틀릿 -->
         <c:forEach items="${portletList}" var="portlet">
            <!-- 근태 -->
            <c:if test="${portlet.portCatecode == 'attend'}">
              <div class="grid-stack-item" gs-id="${portlet.portCatecode }" gs-x="${portlet.portXcoord }" gs-y="${portlet.portYcoord }" gs-w="${portlet.portWidth }" gs-h="${portlet.portHeight }">
                <div class="grid-stack-item-content">
                   <!-- 근태관리창  시작  -->
                  <div class="card h-100">
                     <div class="card-header border-bottom-1 pb-0">
<!--                         <div class="row justify-content-between align-items-center"> -->
                           <div class="col-auto">
                              <h3 class="text-1100">근무관리 <a href="/attendance.do"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a></h3>
                           	  <p>
						    	<span class="text-danger" data-feather="check"></span>
						    	<span class="text-danger">출근/퇴근시 버튼을 꼭 눌러주세요.</span>
							  </p>
                           </div>
<!--                         </div> -->
                     </div>
                     <div class="card-body">
<!--                         <div class="border-top"> -->
                           <div class="row">
                              <div class="col-6">
                              	<br>
                                 <div class="d-flex justify-content-between align-items-center border-0">
                                    <div class="d-flex align-items-center mb-2 pb-3">
                                    <button class="btn btn-outline-success me-1 mb-1" type="button" id="hiBtn">출근</button>&nbsp;&nbsp;
                                       <h4 class="text-900 fw-semi-bold mb-0" id="attendTime">
                                          <fmt:formatDate value="${portlet.data.attendVO.atStart }" pattern="HH:mm" var="attendStart" />
                                          <label class="fs-1">${attendStart }</label>
                                       </h4>
                                    </div>
                                    
                                    <div class="d-flex align-items-center mb-2 pb-3">
                                    <button class="btn btn-outline-success me-1 mb-1" type="button" id="byeBtn">퇴근</button>&nbsp;&nbsp;
                                       <h4 class="text-900 fw-semi-bold mb-0">
                                          <fmt:formatDate value="${portlet.data.attendVO.atEnd }" pattern="HH:mm" var="attendEnd" />
                                          <label class="fs-1">${attendEnd }</label>
                                       </h4>
                                    </div>
                                 </div>
                                 <div>
                                    <div class="d-flex align-items-center mb-2 pb-3">
                                       <h6 class="text-900 fw-semi-bold mb-0">
                                          <button class="btn btn-outline-warning me-1 mb-1"
                                             type="button" id="attendBtn">근무상태변경</button>&nbsp;&nbsp;
<!--                                           <span class="badge badge-phoenix fs--2 badge-phoenix-success"> -->
                                             <label class="fw-bold fs-1 text-info">${portlet.data.atStatusVO.atStatus }</label>
<!--                                              <span class="fs-1" data-feather="check" style="height: 12.8px; width: 12.8px;"></span> -->
<!--                                           </span> -->
                                       </h6>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-6">
                                 <div class="echart-gauge-ring-chart-example1" style="min-height: 240px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); position: relative;" _echarts_instance_="ec_1696229816064">
                                    <div style="position: relative; width: 723px; height: 240px; padding: 0px; margin: 0px; border-width: 0px;" id="chartContainerRound"></div>
                                 </div>
                              </div>
                           </div>
<!--                         </div> -->
                     </div>
                  </div>
                  <!-- 근태관리창  끝  -->
                  <!-- 근태 변경 모달창 시작 -->
                  <input type="hidden" value="${portlet.data.percent }" id="percent"/>
                  
                  <div class="modal fade" id="attendModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
					  <div class="modal-dialog modal-dialog-centered">
					    <div class="modal-content">
					      <div class="modal-header">
					        <h5 class="modal-title" id="verticallyCenteredModalLabel">근무상태변경</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
					      </div>
								<div class="row pt-7 pb-3">
									<div class="col-2"></div>
									<div class="col-10">
										<div class="row">
											<div>
					<!-- 							<h3 class="fw-normal">현재근무상태 :  -->
					<%-- 							<c:choose> --%>
					<%-- 								<c:when test="${status.atStatus eq '업무' }"> --%>
					<!-- 									<span class="text-success">업무</span> -->
					<%-- 								</c:when> --%>
					<%-- 								<c:when test="${status.atStatus eq '출장' }"> --%>
					<!-- 									<span class="text-warning">출장</span> -->
					<%-- 								</c:when> --%>
					<%-- 								<c:when test="${status.atStatus eq '외근' }"> --%>
					<!-- 									<span style="color: #8a5227;">외근</span> -->
					<%-- 								</c:when> --%>
					<%-- 								<c:when test="${status.atStatus eq '자리비움' }"> --%>
					<!-- 									<span class="text-danger">자리비움</span> -->
					<%-- 								</c:when> --%>
					<%-- 							</c:choose> --%>
					<!-- 							</h3> -->
											</div>
											<div class="row pt-3 pb-3">
												<h4 class="fw-normal">변경할 근무상태를 선택하세요</h4>
											</div>
											
											<div class="row pb-1">
												
												<form action="/updateAtStatus2.do" method="POST" id="statusForm">
												<div class="pt-2 pb-1">
													<div class="form-check">
														<input class="form-check-input" id="flexRadioDefault1"
															type="radio" name="atStatus" value="업무"/> <label
															class="form-check-label" for="flexRadioDefault1">
																<h4 class="pt-1 text-success">&nbsp;업무</h4>
															</label>
													</div>
												</div>
												
												
												<div class="pt-2 pb-1">
													<div class="form-check">
														<input class="form-check-input" id="flexRadioDefault1"
															type="radio" name="atStatus" value="출장"/> <label
															class="form-check-label" for="flexRadioDefault1">
																<h4 class="pt-1 text-warning">&nbsp;출장</h4>
															</label>
													</div>
												</div>
												
												
												<div class="pt-2 pb-1">
													<div class="form-check">
														<input class="form-check-input" id="flexRadioDefault1"
															type="radio" name="atStatus" value="외근" /> <label
															class="form-check-label" for="flexRadioDefault1">
																<h4 class="pt-1" style="color:#8a5227;">&nbsp;외근</h4>
															</label>
													</div>
												</div>
												
												
												<div class="pt-2 pb-1">
													<div class="form-check">
														<input class="form-check-input" id="flexRadioDefault1"
															type="radio" name="atStatus" value="자리비움" /> <label
															class="form-check-label" for="flexRadioDefault1">
																<h4 class="pt-1 text-danger">&nbsp;자리비움</h4>
															</label>
													</div>
												</div>
												</form>
											</div>
											
											<div class="row pb-7">
												<div>			
													<div class="form-check">
														<input class="form-check-input"
															type="checkbox" value="" id="checkBx"/> <label class="form-check-label"
															for="flexCheckDefault">현 근무상태와 일치한 근무상태임을 확인했습니다.</label>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
					
								<div class="modal-footer"><button class="btn btn-info" type="button" id="attendOkayBtn">확인</button>
					      </div>
					    </div>
					  </div>
					</div>


                  <!-- 근태 변경 모달창 끝 -->
                </div>
              </div>
              </c:if>
              <!-- 메일-->
            <c:if test="${portlet.portCatecode == 'mail'}">
              <div class="grid-stack-item" gs-id="${portlet.portCatecode }" gs-x="${portlet.portXcoord }" gs-y="${portlet.portYcoord }" gs-w="${portlet.portWidth }" gs-h="${portlet.portHeight }">
                <div class="grid-stack-item-content">
                   <!-- 메일  시작-->
                  <div class="card h-100">
                     <div class="card-header border-bottom-0 pb-0">
                        <div class="row justify-content-between align-items-center mb-4">
                           <div class="col-auto">
                              <h3 class="text-1100">안읽은메일 
                              <span class="text-info">${portlet.data }개<!-- 갯수 --></span>
                              <a href="/receivedmail.do"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a>
                              </h3>
                           </div>
                        </div>
                     </div>
                     <div class="card-body py-0 scrollbar text-center">
                        <div class="d-flex hover-actions-trigger py-2 border-bottom bg-light">
                           <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
                              <div class="col-3 col-md-3 col-xl-3 col-xxl-3">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900 text-secondary" style="line-height: 1.5;">
                                        <a class="a text-secondary" href="#" data-bs-toggle="modal" data-bs-target="#">보낸이</a>
                                     </label>
                                 </div>
                              </div>
                              <div class="col-6 col-md-6 col-xl-6 col-xxl-6">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">제목</label>
                                 </div>
                              </div>
                              <div class="col-3 col-md-3 col-xl-3 col-xxl-3">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">수신날짜</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <c:choose>
                        	<c:when test="${empty portlet.dataList }">
                        	<br>
                        	안읽은 메일이 존재하지 않습니다.
                        	</c:when>
                        	<c:otherwise>
                        		<c:forEach items="${portlet.dataList }" var="unreadMail" varStatus="i">
                        		<div class="d-flex hover-actions-trigger py-2 border-bottom">
		                           <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
		                              <div class="col-3 col-md-3 col-xl-3 col-xxl-3">
		                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
		                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900 text-secondary" style="line-height: 1.5;">
		                                        <a class="a text-secondary" href="#" data-bs-toggle="modal" data-bs-target="#">${unreadMail.mailsEmpname }</a>
		                                     </label>
		                                 </div>
		                              </div>
		                              <div class="col-6 col-md-6 col-xl-6 col-xxl-6">
		                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
		                                    <a href="/receivedMailDetail.do?mailNo=${unreadMail.mailNo }">
			                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
			                                    ${unreadMail.mailTitle }
			                                    </label>
		                                    </a>
		                                 </div>
		                              </div>
		                              <div class="col-3 col-md-3 col-xl-3 col-xxl-3">
		                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
		                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
		                                    <fmt:formatDate value="${unreadMail.mailDate }" pattern="yyyy-MM-dd HH:mm"/></label>
		                                 </div>
		                              </div>
		                           </div>
		                        </div>
		                        </c:forEach>
                        	</c:otherwise>
                        </c:choose>
                     </div>
                  </div>
                  <!-- 메일  끝-->
                </div>
              </div>
              </c:if>
              <!-- 주소록 -->
            <c:if test="${portlet.portCatecode == 'addr'}">
              <div class="grid-stack-item" gs-id="${portlet.portCatecode }" gs-x="${portlet.portXcoord }" gs-y="${portlet.portYcoord }" gs-w="${portlet.portWidth }" gs-h="${portlet.portHeight }">
                <div class="grid-stack-item-content">
                   <!-- 주소록 시작-->
                  <div class="card h-100">
                     <div class="card-header border-bottom-0 pb-0">
                        <div class="row justify-content-between align-items-center mb-4">
                           <div class="col-auto">
                              <h3 class="text-1100">최근 추가 주소록 <a href="/add/myadd.do"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a></h3>
                           </div>
                        </div>
                     </div>
                     <div class="card-body py-0 scrollbar text-center">
                        <div class="d-flex hover-actions-trigger py-2 border-bottom bg-light">
                           <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
                              <div class="col-2 col-md-2 col-xl-2 col-xxl-2">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">이름</label>
                                 </div>
                              </div>
                              <div class="col-2 col-md-2 col-xl-2 col-xxl-2">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">직급</label>
                                 </div>
                              </div>
                              <div class="col-4 col-md-4 col-xl-4 col-xxl-4">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">부서</label>
                                 </div>
                              </div>
                              <div class="col-4 col-md-4 col-xl-4 col-xxl-4">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">연락처</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <c:if test="${empty portlet.dataList }">
                        	<br>
                        	최근 추가된 주소록이 존재하지 않습니다.
                        </c:if>
                        <c:forEach items="${portlet.dataList }" var="group">
                        <div class="d-flex hover-actions-trigger py-2 border-bottom">
                           <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
                              <div class="col-2 col-md-2 col-xl-2 col-xxl-2">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">${group.empVO.empName }</label>
                                 </div>
                              </div>
                              <div class="col-2 col-md-2 col-xl-2 col-xxl-2">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">${group.empVO.codeVO.cdName }</label>
                                 </div>
                              </div>
                              <div class="col-4 col-md-4 col-xl-4 col-xxl-4">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">${group.empVO.deptVO.deptName }</label>
                                 </div>
                              </div>
                              <div class="col-4 col-md-4 col-xl-4 col-xxl-4">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">${group.empVO.empHp }</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                        </c:forEach>
                     </div>
                  </div>
                  <!-- 주소록 끝 -->
                </div>
              </div>
              </c:if>
              <!-- 일정 -->
            <c:if test="${portlet.portCatecode == 'schedule'}">
              <div class="grid-stack-item" gs-id="${portlet.portCatecode }" gs-x="${portlet.portXcoord }" gs-y="${portlet.portYcoord }" gs-w="${portlet.portWidth }" gs-h="${portlet.portHeight }">
                <div class="grid-stack-item-content">
                   <!--  캘린더 시작 -->
                   <div class="card">
                     <div class="card-body d-flex flex-column scroll">
<!--                         <div class="row g-0 mb-4 align-items-center"> -->
<!--                             <h4 class="mb-0 text-1100 fw-bold fs-md-2"> -->
<!--                               <span class="calendar-day d-block d-md-inline mb-1"></span> -->
<!--                               <span class="px-3 fw-thin text-400 d-none d-md-inline">|</span><span class="calendar-date"></span> -->
<!--                             </h4> -->
<!--                          </div> -->
<!--                         <div class="mx-n4 px-4 mx-lg-n6 px-lg-6 border-y border-200"> -->
                           <div class="calendar-outline mt-6 mb-9" id="calendar"></div>
<!--                         </div> -->
                     </div>
                  </div>
                  <!--  캘린더 끝  -->
                </div>
              </div>
              <!-- 상세보기 모달창 시작 -->
               <div class="modal fade" id="eventDetailsModal" tabindex="-1">
                 <div class="modal-dialog modal-dialog-centered">
                   <div class="modal-content border">
                       <div class="modal-header ps-card border-bottom">
                         <h4 class="modal-title text-1000 mb-0"><!-- 데이터 세팅되는 곳 : 제목 --></h4>
                         <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
                       </div>
                       <div class="modal-body px-card pb-card pt-1 fs--1">
                          <div class="mt-3 border-bottom pb-3">
                             <h5 class="mb-0 text-800">내용</h5>
                             <p class="mb-0 mt-2">
                               <!-- 데이터 세팅되는 곳 : 내용 -->
                             </p>
                          </div>
                          <div class="mt-4 ">
                             <h5 class="mb-0 text-800">일자</h5>
                            <p class="mb-1 mt-2">
                              <!-- 데이터 세팅되는 곳 : 시작일자 - 종료일자 -->
                            </p>
                        </div>
                       </div>
                       <div class="modal-footer d-flex justify-content-end px-card pt-0 border-top-0">
<!--                           <button class="btn btn-phoenix-secondary btn-sm" id="modifyEventButton"> -->
<!--                            <svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com 수정 -->
<!--                          </button> -->
<!--                          <button class="btn btn-phoenix-danger btn-sm" id="deleteEventButton"> -->
<!--                            <svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com 삭제 -->
<!--                          </button> -->
                     </div>
                   </div>
                 </div>
               </div>
               <!-- 상세보기 모달창 끝 -->
              </c:if>
              <!-- 업무 -->
            <c:if test="${portlet.portCatecode == 'task'}">
              <div class="grid-stack-item" gs-id="${portlet.portCatecode }" gs-x="${portlet.portXcoord }" gs-y="${portlet.portYcoord }" gs-w="${portlet.portWidth }" gs-h="${portlet.portHeight }">
                <div class="grid-stack-item-content">
                   <!-- 프로젝트 시작-->
                  <div class="card h-100">
                     <div class="card-body d-flex flex-column scroll">
                        <div class="row align-items-end justify-content-between pb-4 g-3">
                           <div class="col-auto">
                              <h3>
                                 	진행중업무 <a href="/task.do"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a>
                              </h3>
                           </div>
                        </div>
                        <div class="card-body py-0 scrollbar to-do-list-body">
                           <table class="table fs--1 mb-0 border-top border-200">
                              <thead>
                                 <tr>
                                    <th class="align-middle ps-0" scope="col" data-sort="project" style="width: 50%;">프로젝트명</th>
                                    <th class="align-middle ps-3" scope="col" data-sort="start" style="width: 10%;">프로젝트기간</th>
                                    <th class="align-middle ps-3" scope="col" data-sort="deadline" style="width: 15%;">업무진행도</th>
                                 </tr>
                              </thead>
                              <c:if test="${empty portlet.dataList }">
		                      	<tr><td colspan="3" style="text-align:center;">할당된 업무가 존재하지 않습니다.</td></tr>
		                      </c:if>
                        	  <c:forEach items="${portlet.dataList }" var="task">
	                              <tbody class="list" id="project-summary-table-body">
	                                 <tr class="position-static">
	                                    <td class="align-middle time white-space-nowrap ps-3 project" style="font-weight: bold;">
	                                    	<a href="taskdetail.do?taskCd=${task.taskCd }">
	                                    		${task.taskTitle }
	                                    	</a>
	                                    </td>
	                                    <td class="align-middle white-space-nowrap start ps-3">
	                                    	<c:set var="startdate" value="${task.taskStartdate}"/> 
											<c:set var="enddate" value="${task.taskEnddate}"/> 
											<c:set var="today" value="<%=new java.util.Date()%>" />
											<c:set var="tdate">
												<fmt:formatDate value="${today}" pattern="yyyy-MM-dd" />
											</c:set> 
	                                       <p class="mb-0 fs--1 text-900">${fn:substring(startdate,0,10)}~ ${fn:substring(enddate,0,10)}</p>
	                                    </td>
	                                    <td class="align-middle white-space-nowrap ps-3 projectprogress">
	                                       <p class="text-800 fs--2 mb-0 text-center">완료업무/업무총갯수</p>
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
	                                 </tr>
	                              </tbody>
                              </c:forEach>
                           </table>
                        </div>
                     </div>
                  </div>
                  <!-- 프로젝트 끝-->
                </div>
              </div>
              </c:if>
              <!-- 결재 -->
            <c:if test="${portlet.portCatecode == 'auth'}">
              <div class="grid-stack-item" gs-id="${portlet.portCatecode }" gs-x="${portlet.portXcoord }" gs-y="${portlet.portYcoord }" gs-w="${portlet.portWidth }" gs-h="${portlet.portHeight }">
                <div class="grid-stack-item-content">
                   <!-- 결재 현황 -->
                  <div class="card h-100">
                     <div class="card-header border-bottom-0 pb-0">
                        <div class="row justify-content-between align-items-center mb-4">
                           <div class="col-auto">
                              <h3 class="text-1100">결재대기문서 <a href="auth/waitdoc.do"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a></h3>
                           </div>
                        </div>
                        <div class="d-flex hover-actions-trigger py-2 border-bottom bg-light">
                        	 <div class="col-4 col-md-4 col-xl-4 col-xxl-4">
                        		<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1"> 
                        	 		<span style="font-weight: bold;">기안서</span>
                        	 	</div>
                        	 </div>
                        	 <div class="col-3 col-md-3 col-xl-3 col-xxl-3">
                        	 	<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1"> 
                        	 		<span style="font-weight: bold;">기안자</span>
                        	 	</div>
                        	 </div>
                        	 <div class="col-3 col-md-3 col-xl-3 col-xxl-3">
                        	 	<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1"> 
                        	 		<span style="font-weight: bold;">기안일</span>
                        	 	</div>
                        	 </div>
                        	 <div class="col-2 col-md-2 col-xl-2 col-xxl-2">
                        	 	<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1"> 
                        	 		<span style="font-weight: bold;">상태</span>
                        	 	</div>
                        	 </div>
                        </div>
                     </div>
                     <div class="card-body py-0 scrollbar text-center">
                   <c:choose>
                   <c:when test="${empty portlet.dataList }">
                   		<br>
                        	결재대기문서가 존재하지 않습니다.
                   </c:when>
                   <c:otherwise>
                   	 <c:forEach items="${portlet.dataList }" var="waitList">
                        <div class="d-flex hover-actions-trigger py-2 border-bottom">
                           <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
	                              <div class="col-4 col-md-4 col-xl-4 col-xxl-4">
	                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
	                                    <a href="/auth/waitdetail.do?drftCd=${waitList.drftCd }">
	                                    	<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
	                                    	${waitList.drftTitle }
	                                    </label></a>
	                                 </div>
	                              </div>
	                              <div class="col-3 col-md-3 col-xl-3 col-xxl-3">
	                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
	                                   	<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
	                                   	${waitList.empName }</label>
	                                 </div>
	                              </div>
	                              <div class="col-3 col-md-3 col-xl-3 col-xxl-3">
	                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
	                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
	                                    	<c:set value="${waitList.drftDate }" var="draftDate"/>
	                                    	${fn:substring(draftDate, 0, 10)}</label>
	                                 </div>
	                              </div>
	                              <div class="col-2 col-md-2 col-xl-2 col-xxl-2">
	                                 <div class="mb-1 ml-8 mb-md-0 d-flex lh-1" >
	                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
	                                       <span class="badge badge-phoenix badge-phoenix-info" >${waitList.atrzpStatusse }</span>
	                                    </label>
	                                 </div>
	                              </div>
	                           </div>
	                        </div>
                        </c:forEach>
                      </c:otherwise>
                   	  </c:choose>
                     </div>
                  </div>
                  <!-- 결재 현황 끝-->
                </div>
              </div>
              </c:if>
              <!-- 게시판 -->
            <c:if test="${portlet.portCatecode == 'board'}">
              <div class="grid-stack-item" gs-id="${portlet.portCatecode }" gs-x="${portlet.portXcoord }" gs-y="${portlet.portYcoord }" gs-w="${portlet.portWidth }" gs-h="${portlet.portHeight }">
                <div class="grid-stack-item-content">
                   <!--게시판 시작-->
                  <div class="card h-100">
                   <div class="card-header border-bottom-0 pb-0">
                     <div class="row justify-content-between align-items-center mb-3">
                      <div class="col-auto">
                        <h3 class="text-1100">게시판</h3>
                        <ul class="nav justify-content-between nav-wizard" role="tablist">
                        <li class="nav-item" role="presentation" style="margin-right: 10px;">
                           <a class="fw-bold active" href="#bootstrap-wizard-tab1" data-bs-toggle="tab" data-wizard-step="1" aria-selected="false" role="tab" tabindex="-1">
                              <div class="text-center d-inline-block">
                                 <span class="d-none d-md-block mt-1 fs-1">공지사항</span>
                              </div>
                           </a>
                        </li>
                        <li class="nav-item" role="presentation">
                           <a class="fw-bold" href="#bootstrap-wizard-tab2" data-bs-toggle="tab" data-wizard-step="2" aria-selected="true" role="tab">
                              <div class="text-center d-inline-block">
                                 <span class="d-none d-md-block mt-1 fs-1">경조사</span>
                              </div>
                           </a>
                        </li>
                       </ul>
                      </div>
                     </div>
                   </div>
                   <div class="card-body py-0 scrollbar text-center to-do-list-body"> 
                     <div class="tab-content">
                        <div class="tab-pane active show" role="tabpanel" aria-labelledby="bootstrap-wizard-tab1" id="bootstrap-wizard-tab1">
                          <table class="table fs--1 mb-0 border-top border-200">
                              <thead>
                               <tr>
                                 <th class="align-middle ps-0" scope="col" data-sort="project" style="width:10%;">번호</th>
                                 <th class="align-middle ps-3 text-center" scope="col" data-sort="start" style="width:60%;">제목</th>
                                 <th class="align-middle ps-3 text-center" scope="col" data-sort="deadline" style="width:10%;">작성자</th>
                                 <th class="align-middle ps-3 text-center" scope="col" data-sort="deadline" style="width:10%;">작성일</th>
                               </tr>
                              </thead>
                              <tbody class="list" id="project-summary-table-body">
                              <c:choose>
                              	<c:when test="${empty portlet.data.noticeList}">
                              		<tr class="position-static">
	                              		<td colspan="4">
	                        			공지사항 게시글이 존재하지 않습니다.
	                        			</td>
                        			</tr>
                              	</c:when>
                              	<c:otherwise>
				                   <c:forEach items="${portlet.data.noticeList}" var="notice" varStatus="i">
		                               <c:if test="${i.index < 4}">
		                               <tr class="position-static">
		                                 <td class="align-middle time white-space-nowrap ps-0 project">${notice.noNo}</td>
		                                 <td class="align-middle white-space-nowrap start ps-3 text-center">
		                                  <p class="mb-0 fs--1 text-900" style="text-align: left; padding-left:80px;"><a href="/noticedetail.do?noNo=${notice.noNo}">${notice.noTitle}</a></p>
		                                 </td>
		                                 <td class="align-middle white-space-nowrap deadline ps-3 text-center">
		                                  <p class="mb-0 fs--1 text-900">${notice.empName}</p>
		                                 </td>
			                             <td class="align-middle white-space-nowrap ps-3 projectprogress text-center">
			                               <fmt:formatDate value="${notice.noDate }" pattern="yyyy-MM-dd"/>
		                                 </td>
		                               </tr>
		                               </c:if>
				                   </c:forEach>
                              	</c:otherwise>
                              </c:choose>
                              </tbody>
                            </table>
                        </div>
                        <div class="tab-pane" role="tabpanel" aria-labelledby="bootstrap-wizard-tab2" id="bootstrap-wizard-tab2">
                          <table class="table fs--1 mb-0 border-top border-200">
                              <thead>
                               <tr>
                                 <th class="align-middle ps-0" scope="col" data-sort="project" style="width:10%;">번호</th>
                                 <th class="align-middle ps-3 text-center" scope="col" data-sort="start" style="width:60%;">제목</th>
                                 <th class="align-middle ps-3 text-center" scope="col" data-sort="deadline" style="width:10%;">작성자</th>
                                 <th class="align-middle ps-3 text-center" scope="col" data-sort="deadline" style="width:10%;">작성일</th>
                               </tr>
                              </thead>
                              <tbody class="list" id="project-summary-table-body">
                              <c:choose>
                              	<c:when test="${empty portlet.data.feventList}">
                              		<tr class="position-static">
	                              		<td colspan="4">
	                        			경조사 게시글이 존재하지 않습니다.
	                        			</td>
                        			</tr>
                              	</c:when>
                              	<c:otherwise>
				                   <c:forEach items="${portlet.data.feventList}" var="fevent" varStatus="i">
				                   	<c:if test="${i.index < 4}">
		                               <tr class="position-static">
		                                 <td class="align-middle time white-space-nowrap ps-0 project">${fevent.feNo}</td>
		                                 <td class="align-middle white-space-nowrap start ps-3 text-center">
		                                  <p class="mb-0 fs--1 text-900" style="text-align: left; padding-left:80px;"><a href="/feventdetail.do?feNo=${fevent.feNo}">${fevent.feTitle}</a></p>
		                                 </td>
		                                 <td class="align-middle white-space-nowrap deadline ps-3 text-center">
		                                  <p class="mb-0 fs--1 text-900">${fevent.empName }</p>
		                                 </td>
		                               <td class="align-middle white-space-nowrap ps-3 projectprogress text-center">
		                               <fmt:formatDate value="${fevent.feDate}" pattern="yyyy-MM-dd"/>
	<%-- 	                                  <p class="text-900 fs--2 mb-0 text-center">${notice.noDate}</p> --%>
		                                 </td>
		                               </tr>
		                            </c:if>
				                   </c:forEach>
                              	</c:otherwise>
                              </c:choose>
                              </tbody>
                            </table>
                           </div>
                          </div>
                        </div>
                         <div class="card-footer border-0"></div> 
                    </div>
                      <!-- 게시판 끝 -->
                </div>
              </div>
              </c:if>
              <!-- to-do list -->
            <c:if test="${portlet.portCatecode == 'todolist'}">
              <div class="grid-stack-item" gs-id="${portlet.portCatecode }" gs-x="${portlet.portXcoord }" gs-y="${portlet.portYcoord }" gs-w="${portlet.portWidth }" gs-h="${portlet.portHeight }">
                <div class="grid-stack-item-content">
                   <!-- todo 리스트 시작  -->
                  <div class="card h-100">
                     <!-- todo 바디쓰면 공간 커짐 -->
                     <div class="card-header border-bottom-0 pb-0">
                        <div class="row justify-content-between align-items-center mb-4">
                           <div class="col-auto">
                              <h3 class="text-1100">TO-DO LIST</h3>
                              <p class="mb-0 text-700">할 일을 등록해주세요.</p>
                           </div>
                           <div class="col-auto w-100 w-md-auto">
                              <div class="row align-items-center g-0 justify-content-between">
                                 <div class="col-auto d-flex">
                                    <p class="mb-0 ms-sm-3 fs--1 text-700 fw-bold todoCnt">
                                    </p>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                     <div class="card-body py-0 scrollbar to-do-list-body" id="todoBody">
                     <!-- todo 내용 for문  -->
                     <c:forEach items="${portlet.dataList }" var = "todo">
                        <div class="d-flex hover-actions-trigger py-2 border-bottom">
                           <input class="form-check-input form-check-input-todolist flex-shrink-0 my-1 me-2 form-check-input-undefined todoCheck" type="checkbox" data-event-propagation-prevent="data-event-propagation-prevent" <c:if test="${todo.todoCheckse eq 'Y' }">checked</c:if> value="${todo.todoCd }"/>
                           <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
                              <div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
                                 <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
                                    <label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900 todoLabel" style="line-height: 1.5;">${todo.todoContent }</label>
                                 </div>
                              </div>
                              <div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
                                 <div class="d-flex lh-1 align-items-center">
                                    <p class="text-700 fs--2 fw-bold mb-md-0 mb-0 ps-md-3 ps-xl-0 ps-xxl-3 border-start-md border-xl-0 border-start-xxl border-300">
                                       <button class="btn btn-info btn-sm" type="button" id="todoSelectDetail" onclick="clickedModifyBtn('${todo.todoContent }','${todo.todoCd }')">수정</button>
                                    </p>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </c:forEach>
                     </div>
                     <!-- 등록, 수정 모달창 띄우기 -->
                     <div class="modal fade" id="todoModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true" style="display: none;">
                        <div class="modal-dialog modal-dialog-centered">
                           <div class="modal-content">
                              <div class="modal-header">
                                 <h5 class="modal-title" id="verticallyCenteredModalLabel">TO-DO LIST 등록</h5>
                                 <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
                                    <svg class="svg-inline--fa fa-xmark fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" data-fa-i2svg="">
                                       <path fill="currentColor" d="M310.6 361.4c12.5 12.5 12.5 32.75 0 45.25C304.4 412.9 296.2 416 288 416s-16.38-3.125-22.62-9.375L160 301.3L54.63 406.6C48.38 412.9 40.19 416 32 416S15.63 412.9 9.375 406.6c-12.5-12.5-12.5-32.75 0-45.25l105.4-105.4L9.375 150.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 210.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0s12.5 32.75 0 45.25l-105.4 105.4L310.6 361.4z"></path></svg>
                                    <!-- <span class="fas fa-times fs--1"></span> Font Awesome fontawesome.com -->
                                 </button>
                              </div>
                              <div class="modal-body">
                                 <p class="text-700 lh-lg mb-0">
                                    <form action="/registerTodo.do" method = "post" id="registerTodoForm">
                                       <textarea class="form-control" rows="5" cols="40" placeholder="50자 이내로 작성해주세요" id="todoContent" name="todoContent"></textarea>
                                    </form>
                                    <div class="text-success text-center" id="contentCount"></div>
                                 </p>
                              </div>
                              <div class="modal-footer">
                                 <button class="btn btn-info" type="button" id="modalSendBtn" onclick="$('#registerTodoForm').submit()">등록</button>
                                 <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal" id="sendTodoBtn">취소</button>
                              </div>
                           </div>
                        </div>
                     </div>
                     <div class="card-footer border-0">
                        <div class="d-flex justify-content-between">
                           <a class="fw-bold fs--1 mt-4 " onclick="clickAddTodoList()"><span class="fas fa-plus me-1"></span>to do-list 추가</a>
                           <button type="button" class="btn btn-phoenix-secondary btn-icon fs--2 text-danger px-0" id="todoDeleteBtn">
                              <span class="fas fa-trash"></span>
                           </button>
                           <div class="modal fade" id="todoDelete" tabindex="-1" aria-hidden="true" style="display: none;">
                              <div class="modal-dialog modal-dialog-centered modal-sm">
                                 <div class="modal-content">
                                    <div class="modal-header text-center">
                                       <h5 class="modal-title text-center" id="exampleModalLabel">TO-DO LIST 삭제</h5>
                                       <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
                                          <svg class="svg-inline--fa fa-xmark fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" data-fa-i2svg="">
                                             <path fill="currentColor" d="M310.6 361.4c12.5 12.5 12.5 32.75 0 45.25C304.4 412.9 296.2 416 288 416s-16.38-3.125-22.62-9.375L160 301.3L54.63 406.6C48.38 412.9 40.19 416 32 416S15.63 412.9 9.375 406.6c-12.5-12.5-12.5-32.75 0-45.25l105.4-105.4L9.375 150.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 210.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0s12.5 32.75 0 45.25l-105.4 105.4L310.6 361.4z"></path></svg>
                                          <!-- <span class="fas fa-times fs--1"></span> Font Awesome fontawesome.com -->
                                       </button>
                                    </div>
                                    <div class="modal-body text-center">
                                       <p class="text-700 lh-lg mb-0">정말 삭제하시겠습니까?</p>
                                    </div>
                                    <div class="modal-footer justify-content-center">
                                       <button class="btn btn-info" type="button" id="delTodoBtn">삭제</button>
                                       <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
                                    </div>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                  </div>
                  <!-- todo 리스트 끝 -->
                </div>
              </div>
              </c:if>
         </c:forEach>
         <!-- 포틀릿 -->
      </c:if>
      
      </c:otherwise>
      </c:choose>
      </div>
   </div>
</div>


<!-- 출근등록버튼을 눌렀을때 활용되는 모달(근태) -->
<div class="modal fade" id="hiModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
      <fmt:formatDate value="${now }" pattern="HH24:mm" var="now"/>
        <p class="text-700 lh-lg mb-0">${empName }님 <c:out value="${formattedDate}"/>에 출근처리 되었습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>

<!-- 퇴근등록버튼을 눌렀을때 활용되는 모달(근태) -->
<div class="modal fade" id="byeModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">${empName }님 <c:out value="${formattedDate}"/>에 퇴근처리 되었습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>

<!-- 해당 내용이 출근임을 명시해줄 form (근태) -->
<form action="/attendanceMain.do" method="post" id="attendHForm">
   <input type="hidden" value="출근" name="atResult"/>
</form>

<!-- 해당 내용이 퇴근임을 명시해줄 form (근태) -->
<form action="/attendanceMain.do" method="post" id="attendBForm">
   <input type="hidden" value="퇴근" name="atResult"/>
</form>

<!-- 출근버튼을 중복해서 눌렀을때 출근처리를 방지해줄 모달(근태) -->
<div class="modal fade" id="dupModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">이미 출근처리 되었습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal">확인</button>
      </div>
    </div>
  </div>
</div>

<!-- 출근버튼을 누르지 않고 퇴근버튼을 눌렀을때 퇴근처리를 방지해줄 모달(근태) -->
<div class="modal fade" id="notStartModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">출근 등록을 하지 않았습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal">확인</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
window.onload = function(){
   let grid = GridStack.init({
     minRow: 1, // don't let it collapse when empty
     cellHeight: 70,
//      sizeToContent: true, // default to make them all fit
     acceptWidgets: true,
     removable: '#trash', // drag-out delete class
     disableOneColumnMode: true,
   });
   
//    let gridList = document.querySelectorAll('.grid-stack-item');
   
//    for(let i=0; i<gridList.length; i++){
//        let menu = gridList[i].getAttribute('gs-id');
//        fetchHtmlAsText("/grid/" + menu).then(function (htmlText) {
//           console.log(htmlText);
   
//           gridList[i].innerHTML = `<div class="grid-stack-item-content">` + htmlText + `</div>`;
//          });
//    }
   
   grid.setStatic(true);
}

// async function fetchHtmlAsText(url) {
//    console.log("요청 url : " + url);
//    const response = await fetch(url);
//     return await response.text();
// }

/////////////////// 근태 ///////////////////
var attendModal = $('#attendModal');
var attendOkayBtn = $('#attendOkayBtn');
var checkOkayBtn = $('#checkOkayBtn');
var attendBtn = $('#attendBtn');
var checkBx = $('#checkBx');
var hiBtn = $('#hiBtn');
var byeBtn = $('#byeBtn');
var hiModal = $('#hiModal');
var byeModal = $('#byeModal');
var attendHForm = $('#attendHForm');
var attendBForm = $('#attendBForm');
var hiOkBtn = $('#hiOkBtn');
var attendTime = $('#attendTime');
var dupModal = $('#dupModal');
var notStartModal = $('#notStartModal');

attendBtn.on('click', function(){
   attendModal.modal('show');
});

attendOkayBtn.on('click', function(){
   if(!checkBx.prop('checked')) {
      alert('상태변경 확인에 동의해주세요');
   }else {
      attendModal.modal('hide');
      statusForm.submit();
   }
});

checkOkayBtn.on('click', function(){
   if(!checkBtn.prop('checked')) {
      alert('안내사항을 읽고 체크해주세요.')
   }else {
      mainModal.modal('hide');
      typeSubmit.submit();
   }
});

hiBtn.on('click', function(){
   console.log(attendTime.text());
   if(attendTime.text().trim()!=null && attendTime.text().trim()!="") {
      console.log('1');
      dupModal.modal('show');
      return false;
   }
   hiModal.modal('show');
   // 모달이 다시 hide 상태가되었을때
   hiModal.on('hidden.bs.modal', function(){
      console.log('2');
      attendHForm.submit();
   })
});

byeBtn.on('click', function(){
   console.log(attendTime.text().trim());
   if(attendTime.text().trim()==null || attendTime.text().trim()=="") {
      notStartModal.modal('show');
      return false;
   }
   byeModal.modal('show');
   byeModal.on('hidden.bs.modal', function(){
      attendBForm.submit();
   })
});

var id = $('#id').val();
var chartContainerRound = $('#chartContainerRound');
var attendChartRound = $('#attendChartRound');
var percent = $('#percent').val();
chartContainerRound.html('');
chartContainerRound.html('<canvas id="attendChartRound" style="width:100%; height:200px;"></canvas>');
const data = {
        labels: [
          '수행근무시간',
          '남은근무시간'
        ],
        datasets: [{
          label: ['근무시간(단위 : %) '],
          data: [percent, 100-percent],
          backgroundColor: [
            'rgb(255, 99, 132)',
            'rgb(54, 162, 235)'
          ],
          hoverOffset: 4
        }]
   };
   
   const config = {
    type: 'doughnut',
      data: data,
      };
   
   
   $(function(){
       let ctx = document.getElementById('attendChartRound').getContext('2d');
       let chart = new Chart(ctx, config);
   });
/////////////////// 근태 ///////////////////

/////////////////// 일정 ///////////////////
// 상세보기 데이터 //
let scCd;
let scSe;
let scTitle;
let scContent;
let scStartdate;
let scEnddate;
// 상세보기 데이터 //

let eventDetailM; // 상세보기 모달

document.addEventListener('DOMContentLoaded', function() {
   var request = $.ajax({
      url : "/schedule.do",
      method : "POST",
      data : JSON.stringify({comSelect : true, deptSelect : true, empSelect : true}),
      contentType : 'application/json',
      dataType : "json"
   });
   request.done(function(data){
      console.log("캘린더 데이터 : " + JSON.stringify(data));
      var calendarEl = document.getElementById('calendar');
      var calendar = new FullCalendar.Calendar(calendarEl, {
         // FullCalendar 설정
          headerToolbar :{
            left : 'today',
            center : 'title',
            right : 'prev,next'
         },
          selectable : true,
//          droppable : true,
//          editable : true, // 드래그로 일정 늘리거나 줄일 수 있음 -> eventResize
         events: data,
         dateClick : function(info) {
            // 클릭한 날짜 정보
            console.log('클릭한 날짜 정보:', info.date);
         },
         eventClick : function(info) {
            // 클릭한 일정 정보
            console.log('클릭한 일정 정보:', info.event);
            console.log('클릭한 일정 정보(일정 코드):', info.event.extendedProps.scCd);
            console.log('클릭한 일정 정보(일정 유형):', info.event.classNames[0]);
            
            // 데이터 전역변수에 세팅
            scCd = info.event.extendedProps.scCd;
            scSe = info.event.extendedProps.scSe;
            scTitle = info.event.title;
            scContent = info.event.extendedProps.content;
            scStartDate = toStringByFormatting(info.event.start);
            let end = new Date(info.event.end - (1000 * 60 * 60 * 24));
            scEndDate = toStringByFormatting(end);
            
            document.querySelector("#eventDetailsModal .modal-title").innerText = scTitle;
            document.querySelector("#eventDetailsModal .modal-body > .mt-3 > p").innerText = scContent;
            document.querySelector("#eventDetailsModal .modal-body > .mt-4 > p").innerText = scStartDate + " ~ " + scEndDate;
            
            eventDetailM = new window.bootstrap.Modal(eventDetailsModal);
            eventDetailM.show();
         }
      });
   
      calendar.render();
   });
});

function leftPad(value) {
    if (value >= 10) {
        return value;
    }

//     return `0${value}`;
    return `0` + value;
}


function toStringByFormatting(source, delimiter = '-') {
    const year = source.getFullYear();
    const month = leftPad(source.getMonth() + 1);
    const day = leftPad(source.getDate());

    return [year, month, day].join(delimiter);
}

/////////////////// 일정 ///////////////////

/////////////////// to-do list ///////////////////
// todoContent 넘기는 폼
var registerTodoForm=$("#registerTodoForm");
//todolist 업무 총 갯수 가져오기 
$.ajax({
	type : "post",
	url : "/selectTodoCnt.do",
	success : function(res){
		$(".todoCnt").html("<span class='fas fa-filter me-1 fw-extra-bold fs--2'></span>"+res+" tasks");
	}
})


// todolist 내용 입력 시 Enter 입력 방지
$("#todoContent").on("click",function(){
	$(document).keypress(function(e) {
        if (e.keyCode == 13)
            e.preventDefault();
	});
});


// todoContent 50자 이상 입력 방지
$("#todoContent").keyup(function(){
   
   var content = $(this).val();
   var contentLength = content.length;
   $("#contentCount").text(contentLength+"/50");
   
    if (contentLength > 50) {
           $("#contentCount").addClass("text-danger"); // 50자 초과 시 텍스트 색상 변경
           	alert("50자 이내로 작성하여주세요!")
           
           let temp = $("#todoContent").val();
           temp = temp.substring(0,49);
           $("#todoContent").val(temp);
           
           $("#contentCount").text(temp.length+"/50");
       } else {
           $("#contentCount").removeClass("text-danger");
       }
});


// 등록 모달창 띄우기, 등록 진행
function clickAddTodoList(){
   $("#verticallyCenteredModalLabel").text("TO_DO 등록");
   $("#modalSendBtn").text("등록");
   $("#todoContent").val("");
   $("#contentCount").text("/50");
      
   
   $("#todoModal").modal("show");
   
    if ($("input[name=todoCd]").length > 0) {
           $("input[name=todoCd]").remove();
       }
    
   registerTodoForm.attr("action","/registerTodo.do");
   $("#modalSendBtn").attr("onclick","registerTodoForm.submit()");
}
// 수정 모달창 띄우기, 수정 진행
function clickedModifyBtn(todoContent, todoCd){
   
   
   var hiddenInput = document.createElement("input");
   
   hiddenInput.type = "hidden"
   hiddenInput.name = "todoCd"
   hiddenInput.value = todoCd;
   
   
   $("#verticallyCenteredModalLabel").text("TO_DO 수정");
   $("#todoContent").val(todoContent);
   var content = $("#todoContent").val();
   var contentLength = content.length;
   $("#contentCount").text(contentLength+"/50");
   
   $("#modalSendBtn").text("수정");
   $("#todoModal").modal("show");
   registerTodoForm.append(hiddenInput);
   registerTodoForm.attr("action","/updateTodo.do");
   $("#modalSendBtn").attr("onclick","registerTodoForm.submit()");
   
}
// todolist checkse 상태값 변경
$(".todoCheck").change(function(){
   
   var flag = false;
   
   flag = $(this).is(":checked");
   console.log("flag",flag);
   var todoCd = $(this).val();
   console.log("input 에서 todoCd : ",todoCd);
   
   var data ={
         checkse : flag,
         todoCd : todoCd
   }
   
   $.ajax({
      type : "post",
      url : "updateTodoCheckse.do",
      data : JSON.stringify(data),
      contentType : "application/json; charset=utf-8",
      success : function(res){
         console.log(res);
      }
      
   });
});
//todolist 삭제
var array = [];

$("#todoDeleteBtn").on("click", function(){
	if($("#todoBody").find(".todoCheck").is(":checked")){
		$("#todoDelete").modal("show");
	}else{
		alert("todo를 체크 후 삭제 가능합니다!");		
	}
});

$("#delTodoBtn").on("click",function(){

   //<form></form>
   let formData = new FormData();
   
   $("input.todoCheck:checked").each(function(){
      var todoCd = $(this).val();
//       array.push(todoCd);
//       console.log("todoCd : " + todoCd);
      //<input type="text" name="todoCdArr" value="값.." />
      //<input type="text" name="todoCdArr" value="값.." />
      //<input type="text" name="todoCdArr" value="값.." />
      formData.append("todoCdArr",todoCd);
   });
   
//    var data = {
//          "array":array
//    }
   
//    console.log("checked : "+ JSON.stringify(array));
   
   $.ajax({
      url:"/deleteTodoList.do",
      processData:false,
      contentType:false,
      cache:false,
      data:formData,
      type:"post",
      dataType : "text",
      success : function(res){
         
         if(res ==="삭제 완료!"){
            location.href="/";
         }else{
            alert(res.msg);
            $("#todoDelete").modal("hide");
            
         }
      }      
   });
});
//todolist 삭제 끝



/////////////////// to-do list ///////////////////


</script>
