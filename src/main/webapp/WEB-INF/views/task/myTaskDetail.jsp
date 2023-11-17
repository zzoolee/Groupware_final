<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${not empty message }">
	<script type="text/javascript">
		alert("${message}");
		<c:remove var="message" scope="request"/>
		<c:remove var="message" scope="session"/>
	</script>
</c:if>

<div class="kanban-header">
  <div class="row gx-0 justify-content-between justify-content-md-start">
    <div class="col-auto">
		<h2>세부업무목록</h2>
<!-- 		<span class="fs-1 me-2">세부업무목록</span> -->
<!-- 		<br> -->
		<p>
	    	<span class="text-danger" data-feather="check"></span>
	    	대기중, 진행중인 프로젝트만 확인가능합니다.
	    	<br>
	    	<span class="text-danger" data-feather="check"></span>
	    	책임자인 프로젝트는 빨간색으로, 팀원인 프로젝트는 파란색으로 표시됩니다.
	    </p>
    </div>
  </div>
</div>

<div class="kanban-container scrollbar" data-kanban-container="data-kanban-container">
  <c:choose>
  	<c:when test="${empty myTkDetailList }">
  		<br>
  		<span class="text-info" data-feather="alert-circle" style="height: 30px; width: 30px;"></span>
	 	참여중인 프로젝트가 존재하지 않습니다.
  	</c:when>
  	<c:otherwise>
  		<c:forEach items="${myTkDetailList }" var="task">
		  <!-- 프로젝트 반복 -->
		  <div class="kanban-column scrollbar <c:if test="${fn:length(task.tkDetailList) == 0}">collapsed</c:if>"><!-- collapsed 추가시 닫힘 -->
		    <div class="kanban-column-header px-4 hover-actions-trigger">
		      <div class="d-flex align-items-center border-bottom border-3 py-3 <c:if test="${task.myrole == '책임자'}">border-danger</c:if><c:if test="${task.myrole == '팀원'}">border-info</c:if>">
		        <h5 class="mb-0 kanban-column-title">${task.taskTitle}<!-- 프로젝트명 --><span class="kanban-title-badge">${fn:length(task.tkDetailList)}<!-- 업무 갯수 --></span></h5>
<!-- 		        <div class="hover-actions-trigger"> -->
<!-- 		          <button class="btn btn-sm btn-phoenix-default kanban-header-dropdown-btn hover-actions" type="button" data-boundary="viewport" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><svg class="svg-inline--fa fa-ellipsis" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg=""><path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com</button> -->
<!-- 		          <div class="dropdown-menu dropdown-menu-end py-2" style="width: 15rem;"><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Sort tasks</span><svg class="svg-inline--fa fa-angle-right fs--2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="angle-right" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 512" data-fa-i2svg=""><path fill="currentColor" d="M64 448c-8.188 0-16.38-3.125-22.62-9.375c-12.5-12.5-12.5-32.75 0-45.25L178.8 256L41.38 118.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0l160 160c12.5 12.5 12.5 32.75 0 45.25l-160 160C80.38 444.9 72.19 448 64 448z"></path></svg><span class="fas fa-angle-right fs--2"></span> Font Awesome fontawesome.com</a><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Sort all tasks</span></a><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Move all tasks</span><svg class="svg-inline--fa fa-angle-right fs--2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="angle-right" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 512" data-fa-i2svg=""><path fill="currentColor" d="M64 448c-8.188 0-16.38-3.125-22.62-9.375c-12.5-12.5-12.5-32.75 0-45.25L178.8 256L41.38 118.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0l160 160c12.5 12.5 12.5 32.75 0 45.25l-160 160C80.38 444.9 72.19 448 64 448z"></path></svg><span class="fas fa-angle-right fs--2"></span> Font Awesome fontawesome.com</a><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Remove all tasks</span></a> -->
<!-- 		            <hr class="my-2"><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Import</span></a><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Export</span><svg class="svg-inline--fa fa-angle-right fs--2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="angle-right" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 512" data-fa-i2svg=""><path fill="currentColor" d="M64 448c-8.188 0-16.38-3.125-22.62-9.375c-12.5-12.5-12.5-32.75 0-45.25L178.8 256L41.38 118.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0l160 160c12.5 12.5 12.5 32.75 0 45.25l-160 160C80.38 444.9 72.19 448 64 448z"></path></svg><span class="fas fa-angle-right fs--2"></span> Font Awesome fontawesome.com</a> -->
<!-- 		            <hr class="my-2"><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Move column</span><svg class="svg-inline--fa fa-angle-right fs--2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="angle-right" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 512" data-fa-i2svg=""><path fill="currentColor" d="M64 448c-8.188 0-16.38-3.125-22.62-9.375c-12.5-12.5-12.5-32.75 0-45.25L178.8 256L41.38 118.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0l160 160c12.5 12.5 12.5 32.75 0 45.25l-160 160C80.38 444.9 72.19 448 64 448z"></path></svg><span class="fas fa-angle-right fs--2"></span> Font Awesome fontawesome.com</a><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Duplicate column</span></a><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Delete column</span></a><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Archive column</span></a> -->
<!-- 		            <hr class="my-2"><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Edit title &amp; description</span></a><a class="dropdown-item d-flex flex-between-center border-1 undefined" href="#!"><span>Edit colour</span><svg class="svg-inline--fa fa-angle-right fs--2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="angle-right" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 512" data-fa-i2svg=""><path fill="currentColor" d="M64 448c-8.188 0-16.38-3.125-22.62-9.375c-12.5-12.5-12.5-32.75 0-45.25L178.8 256L41.38 118.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0l160 160c12.5 12.5 12.5 32.75 0 45.25l-160 160C80.38 444.9 72.19 448 64 448z"></path></svg><span class="fas fa-angle-right fs--2"></span> Font Awesome fontawesome.com</a> -->
<!-- 		          </div> -->
<!-- 		        </div> -->
		        <span class="uil uil-left-arrow-to-left fs-0 ms-auto kanban-collapse-icon" data-kanban-collapse="data-kanban-collapse"></span><span class="uil uil-arrow-from-right fs-0 ms-auto kanban-collapse-icon" data-kanban-collapse="data-kanban-collapse"></span>
		      </div>
		    </div>
		    <div class="kanban-items-container" data-sortable="data-sortable">
		      <c:if test="${fn:length(task.tkDetailList) == 0 }">
		      	<div class="d-flex justify-content-center mt-3">
		      	<span class="text-info" data-feather="alert-circle"></span>
	 			담당하는 세부업무가 존재하지 않습니다.
	 			</div>
		      </c:if>
		      <c:forEach items="${task.tkDetailList }" var="tkDetail">
		      <!-- 세부업무 반복 -->
		      <div class="sortable-item-wrapper border-bottom px-2 py-2">
		        <div class="card sortable-item hover-actions-trigger">
		          <div class="card-body py-3 px-3">
		            <div class="kanban-status mb-1 position-relative lh-1">
		<!--             <svg class="svg-inline--fa fa-circle me-2 d-inline-block text-primary" style="min-width: 1rem;transform-origin: 0.5em 0.6875em;" data-fa-transform="shrink-1 down-3" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="circle" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><g transform="translate(256 256)"><g transform="translate(0, 96)  scale(0.9375, 0.9375)  rotate(0 0 0)"><path fill="currentColor" d="M512 256C512 397.4 397.4 512 256 512C114.6 512 0 397.4 0 256C0 114.6 114.6 0 256 0C397.4 0 512 114.6 512 256z" transform="translate(-256 -256)"></path></g></g></svg><span class="fa fa-circle me-2 d-inline-block text-primary" style="min-width:1rem" data-fa-transform="shrink-1 down-3"></span> Font Awesome fontawesome.com -->
		            <c:if test="${tkDetail.tdStatusse == 'n' }">
			            <span class="badge badge-phoenix fs--2 badge-phoenix-warning">
			            	<span class="badge-label">작업중</span> <svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-clock ms-1" style="height: 12.8px; width: 12.8px;"><circle cx="12" cy="12" r="10"></circle>
								<polyline points="12 6 12 12 16 14"></polyline>
							</svg>
						</span>
		            </c:if>
		            <c:if test="${tkDetail.tdStatusse == 'y' }">
			            <span class="badge badge-phoenix fs--2 badge-phoenix-success">
							<span class="badge-label">작업완료</span><svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check ms-1" style="height: 12.8px; width: 12.8px;">
								<polyline points="20 6 9 17 4 12"></polyline>
							</svg>
						</span>
						<span class="fs--1" style="font-weight:bold;">완료일자 : ${fn:substring(tkDetail.tdEnddate,0,10) }</span>
		            </c:if>
		              <div class="font-sans-serif">
		                <button class="btn btn-sm btn-phoenix-default kanban-item-dropdown-btn hover-actions" type="button" data-boundary="viewport" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><svg class="svg-inline--fa fa-ellipsis fa-rotate-90" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fas fa-ellipsis-h fa-rotate-90" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --></button>
						<!-- 드롭다운 메뉴 시작 -->
						<div class="dropdown-menu dropdown-menu-end py-2" style="position: absolute; inset: auto 0px 0px auto; margin: 0px; transform: translate3d(-16px, -63.5px, 0px);" data-popper-placement="top-end">
							<form action="/tkturny.do?tkdflag=true" method="POST">
								<input type="hidden" name="tdCd" value="${tkDetail.tdCd }"> <input type="hidden" name="taskCd" value="${task.taskCd }">
								<button class="text-button dropdown-item" type="submit" style="margin-top: 5px;">
									<span style="margin-left: 20px; font-size: 14px;">작업완료</span>
								</button>
							</form>
							<form action="/tkturnn.do?tkdflag=true" method="POST">
								<input type="hidden" name="tdCd" value="${tkDetail.tdCd }"> <input type="hidden" name="taskCd" value="${task.taskCd }">
								<button class="text-button dropdown-item" type="submit" style="margin-top: 5px;">
									<span style="margin-left: 20px; font-size: 14px;">작업중</span>
								</button>
							</form>
							<button class="text-button dropdown-item" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal-${tkDetail.tdCd }" style="margin-top: 5px;">
								<span style="margin-left: 20px; font-size: 14px;">수정</span>
							</button>
							<div class="dropdown-divider"></div>
							<form action="/tkdelete.do?tkdflag=true" method="POST">
								<input type="hidden" name="tdCd" value="${tkDetail.tdCd }"> <input type="hidden" name="taskCd" value="${task.taskCd }">
								<button class="text-button dropdown-item" type="submit">
									<span style="margin-left: 20px; font-size: 14px;">삭제</span>
								</button>
							</form>
						</div>
						<!-- 드롭다운 메뉴 끝 -->
		              </div>
		            </div>
		            <p class="mb-0 stretched-link">${tkDetail.tdContent }</p>
		            <div class="d-flex mt-2 align-items-center">
		              <p class="mb-0 text-600 fs--1 lh-1 me-3 white-space-nowrap"><svg class="svg-inline--fa fa-calendar-xmark fs--1 me-2 d-inline-block" style="min-width: 1rem;" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="calendar-xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg=""><path fill="currentColor" d="M160 32V64H288V32C288 14.33 302.3 0 320 0C337.7 0 352 14.33 352 32V64H400C426.5 64 448 85.49 448 112V160H0V112C0 85.49 21.49 64 48 64H96V32C96 14.33 110.3 0 128 0C145.7 0 160 14.33 160 32zM0 192H448V464C448 490.5 426.5 512 400 512H48C21.49 512 0 490.5 0 464V192zM304.1 304.1C314.3 295.6 314.3 280.4 304.1 271C295.6 261.7 280.4 261.7 271 271L224 318.1L176.1 271C167.6 261.7 152.4 261.7 143 271C133.7 280.4 133.7 295.6 143 304.1L190.1 352L143 399C133.7 408.4 133.7 423.6 143 432.1C152.4 442.3 167.6 442.3 176.1 432.1L224 385.9L271 432.1C280.4 442.3 295.6 442.3 304.1 432.1C314.3 423.6 314.3 408.4 304.1 399L257.9 352L304.1 304.1z"></path></svg>
		              ${fn:substring(tkDetail.tdStartdate,0,10)}</p>
		              ~&nbsp;&nbsp;&nbsp;
		              <p class="mb-0 text-600 fs--1 lh-1 me-3 white-space-nowrap"><svg class="svg-inline--fa fa-calendar-xmark fs--1 me-2 d-inline-block" style="min-width: 1rem;" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="calendar-xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg=""><path fill="currentColor" d="M160 32V64H288V32C288 14.33 302.3 0 320 0C337.7 0 352 14.33 352 32V64H400C426.5 64 448 85.49 448 112V160H0V112C0 85.49 21.49 64 48 64H96V32C96 14.33 110.3 0 128 0C145.7 0 160 14.33 160 32zM0 192H448V464C448 490.5 426.5 512 400 512H48C21.49 512 0 490.5 0 464V192zM304.1 304.1C314.3 295.6 314.3 280.4 304.1 271C295.6 261.7 280.4 261.7 271 271L224 318.1L176.1 271C167.6 261.7 152.4 261.7 143 271C133.7 280.4 133.7 295.6 143 304.1L190.1 352L143 399C133.7 408.4 133.7 423.6 143 432.1C152.4 442.3 167.6 442.3 176.1 432.1L224 385.9L271 432.1C280.4 442.3 295.6 442.3 304.1 432.1C314.3 423.6 314.3 408.4 304.1 399L257.9 352L304.1 304.1z"></path></svg>
		              ${fn:substring(tkDetail.tdClosedate,0,10)}</p>
		            </div>
		          </div>
		        </div>
		      </div>
		      <!-- 세부업무 반복 -->
				<!-- 수정모달 시작 -->
				<div class="modal fade" id="exampleModal-${tkDetail.tdCd }" tabindex="0" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<form class="needs-validation" action="/tkdetailupdate.do?tkdflag=true" novalidate="" method="post">
								<div class="col-md-6 input-group has-validation">
									<input class="form-control" type="hidden" id="validationCustomUsername" name="taskCd" aria-describedby="inputGroupPrepend" required="" value="${task.taskCd }">
								</div>
								<input type="hidden" name="tdCd" value="${tkDetail.tdCd }">
								<div class="modal-header">
									<h5 class="modal-title" id="exampleModalLabel">세부업무 수정</h5>
									<button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
										<span class="fas fa-times fs--1"></span>
									</button>
								</div>
								<div class="modal-body">
				<!-- 					<div class="col-md-6"> -->
				<!--                          <label class="form-label" for="validationCustom03">City</label> -->
				<%--                          <input class="form-control" id="validationCustom03" type="text" required=""  value="${taskVO.taskCd }"> --%>
				<!--                          <div class="invalid-feedback">Please provide a valid city.</div> -->
				<!--                     </div> -->
				
									<div>
				                         <label for="validationCustom03">내용</label>
				                         <input class="form-control" name="tdContent" id="validationCustom03" type="text" required=""  value="${tkDetail.tdContent }">
				                         <div class="invalid-feedback">내용을 입력해주세요.</div>
				                    </div>
				
									<div style="display:none;">
										<label for="validationCustom03">비고</label>
										<input class="form-control" type="hidden" name="tdMemo" value="${tkDetail.tdMemo }" />
									</div>
									
									<div>
				                         <label for="validationCustom03">마감일</label>
				                         <c:set var="tdClosedate" value="${tkDetail.tdClosedate}" />
				                         <input class="form-control" name="tdClosedate" id="validationCustom03" type="date" name="tdClosedate" required=""  value="${fn:substring(tdClosedate,0,10)}">
				                         <div class="invalid-feedback">마감일을 입력해주세요.</div>
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
				<!-- 수정모달 끝 -->
		      <!-- 세부업무 반복 -->
		      </c:forEach>
		    </div>
		  </div>
		  <!-- 프로젝트 반복 -->
  		</c:forEach>
  	</c:otherwise>
  </c:choose>
</div>
