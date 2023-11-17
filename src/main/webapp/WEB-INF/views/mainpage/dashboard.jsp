<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!-- Find the JS file for the following chart at: src/js/charts/echarts/examples/gauge-ring-chart.js-->
<!-- If you are not using gulp based workflow, you can find the transpiled code at: public/assets/js/echarts-example.js-->

<!--  여기까지 테스트 -->
<div class="mx-lg-n4 mt-3">
	<div class="row g-3">
	<!-- 근태관리창  시작  -->
		<div class="col-12 col-xl-6 col-xxl-6">
			<div class="card h-100">
				<div class="card-header border-bottom-0 pb-0">
					<div class="row justify-content-between align-items-center mb-4">
						<div class="col-auto">
							<h3 class="text-1100">근태현황 <a href="#"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a></h3>
						</div>
					</div>
				</div>
				<div class="card-body">
					<div class="border-top">
						<div class="echart-gauge-ring-chart-example1" style="min-height: 300px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); position: relative;" _echarts_instance_="ec_1696229816064">
							<div style="position: relative; width: 723px; height: 300px; padding: 0px; margin: 0px; border-width: 0px;">
								<canvas data-zr-dom-id="zr_0" width="723" height="300" style="position: absolute; left: 0px; top: 0px; width: 723px; height: 300px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); padding: 0px; margin: 0px; border-width: 0px;"></canvas>
							</div>
							<div class=""></div>
						</div>
						<div>
							<div class="d-flex align-items-center mb-2">
								<h6 class="text-900 fw-semi-bold mb-0">
									<button class="btn btn-soft-success me-1 mb-1" type="button" data-bs-toggle="modal" data-bs-target="#">출근</button>
									<label class="text-danger">출근시간</label>
								</h6>
							</div>
							<div class="d-flex align-items-center mb-2">
								<h6 class="text-900 fw-semi-bold mb-0">
									<button class="btn btn-soft-danger me-1 mb-1" type="button">퇴근</button>
									<label class="text-secondary">퇴근시간</label>
								</h6>
							</div>
							<div class="d-flex align-items-center mb-2">
								<h6 class="text-900 fw-semi-bold mb-0">
									<button class="btn btn-soft-info me-1 mb-1" type="button" data-bs-toggle="modal" data-bs-target="#workState">근무상태 변경</button>
									<span class="badge badge-phoenix fs--2 badge-phoenix-success">
										<span class="badge-label">업무중</span>
										<span class="ms-1" data-feather="check" style="height:12.8px;width:12.8px;"></span>
									</span>
								</h6>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 근태관리창  끝  -->
		<!--게시판 시작-->
		<div class="col-12 col-xl-6 col-xxl-6">
			<div class="card h-100">
			 <div class="card-header border-bottom-0 pb-0">
			   <div class="row justify-content-between align-items-center mb-4">
				 <div class="col-auto">
				   <h3 class="text-1100">게시판 <a href="auth/waitdoc.do"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a></h3>
				   <ul class="nav justify-content-between nav-wizard" role="tablist">
					<li class="nav-item" role="presentation" style="margin-right: 10px;">
						<a class="fw-bold active" href="#bootstrap-wizard-tab1" data-bs-toggle="tab" data-wizard-step="1" aria-selected="false" role="tab" tabindex="-1">
							<div class="text-center d-inline-block">
								<span class="d-none d-md-block mt-1 fs--1">공지사항</span>
							</div>
						</a>
					</li>
					<li class="nav-item" role="presentation">
						<a class="fw-bold" href="#bootstrap-wizard-tab2" data-bs-toggle="tab" data-wizard-step="2" aria-selected="true" role="tab">
							<div class="text-center d-inline-block">
								<span class="d-none d-md-block mt-1 fs--1">경조사</span>
							</div>
						</a>
					</li>
				  </ul>
				 </div>
			   </div>
			 </div>
			 <div class="card-body py-0 scrollbar to-do-list-body"> 
				<div class="tab-content">
					<div class="tab-pane active show" role="tabpanel" aria-labelledby="bootstrap-wizard-tab1" id="bootstrap-wizard-tab1">
					  <table class="table fs--1 mb-0 border-top border-200">
						   <thead>
							 <tr>
							   <th class="align-middle ps-0" scope="col" data-sort="project" style="width:10%;">글번호</th>
							   <th class="align-middle ps-3 text-center" scope="col" data-sort="start" style="width:60%;">글제목</th>
							   <th class="align-middle ps-3 text-center" scope="col" data-sort="deadline" style="width:10%;">작성자</th>
							   <th class="align-middle ps-3 text-center" scope="col" data-sort="deadline" style="width:10%;">등록일</th>
							 </tr>
						   </thead>
						   <tbody class="list" id="project-summary-table-body">
							 <tr class="position-static">
							   <td class="align-middle time white-space-nowrap ps-0 project">ajax로 가져오자</td>
							   <td class="align-middle white-space-nowrap start ps-3 text-center">
								 <p class="mb-0 fs--1 text-900">게시글 제목이 와야 하는데 글이 길거나 짧으어디까지 나오는지 확인해볼까</p>
							   </td>
							   <td class="align-middle white-space-nowrap deadline ps-3 text-center">
								 <p class="mb-0 fs--1 text-900">작성자 이름</p>
							   </td>
							 <td class="align-middle white-space-nowrap ps-3 projectprogress text-center">
								 <p class="text-900 fs--2 mb-0 text-center">2023-10-10</p>
							   </td>
							 </tr>
						   </tbody>
						 </table>
					</div>
					<div class="tab-pane" role="tabpanel" aria-labelledby="bootstrap-wizard-tab2" id="bootstrap-wizard-tab2">
					  <table class="table fs--1 mb-0 border-top border-200">
						   <thead>
							 <tr>
							   <th class="align-middle ps-0" scope="col" data-sort="project" style="width:10%;">글번호</th>
							   <th class="align-middle ps-3 text-center" scope="col" data-sort="start" style="width:60%;">글제목</th>
							   <th class="align-middle ps-3 text-center" scope="col" data-sort="deadline" style="width:10%;">작성자</th>
							   <th class="align-middle ps-3 text-center" scope="col" data-sort="deadline" style="width:10%;">등록일</th>
							 </tr>
						   </thead>
						   <tbody class="list" id="project-summary-table-body">
							 <tr class="position-static">
							   <td class="align-middle time white-space-nowrap ps-0 project">이거 되면</td>
							   <td class="align-middle white-space-nowrap start ps-3 text-center">
								 <p class="mb-0 fs--1 text-900">바뀌나</p>
							   </td>
							   <td class="align-middle white-space-nowrap deadline ps-3 text-center">
								 <p class="mb-0 fs--1 text-900">대박인데</p>
							   </td>
							 <td class="align-middle white-space-nowrap ps-3 projectprogress text-center">
								 <p class="text-900 fs--2 mb-0 text-center">2023-10-10</p>
							   </td>
							 </tr>
						   </tbody>
						 </table>
					</div>
				  </div>
			</div>
		    <div class="card-footer border-0">
		    </div> 
		  </div>
		</div>
		<!-- 게시판 끝 -->
	</div>
</div>
<!-- 근태 변경 모달창 시작 -->
<div class="modal fade" id="workState" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true" style="display: none;">
 <div class="modal-dialog modal-dialog-centered modal-sm">
   <div class="modal-content">
     <div class="modal-header">
       <h5 class="modal-title" id="verticallyCenteredModalLabel">근무상태 변경</h5>
       <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
       	<svg class="svg-inline--fa fa-xmark fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" data-fa-i2svg="">
       		<path fill="currentColor" d="M310.6 361.4c12.5 12.5 12.5 32.75 0 45.25C304.4 412.9 296.2 416 288 416s-16.38-3.125-22.62-9.375L160 301.3L54.63 406.6C48.38 412.9 40.19 416 32 416S15.63 412.9 9.375 406.6c-12.5-12.5-12.5-32.75 0-45.25l105.4-105.4L9.375 150.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 210.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0s12.5 32.75 0 45.25l-105.4 105.4L310.6 361.4z"></path>
       	</svg><!-- <span class="fas fa-times fs--1"></span> Font Awesome fontawesome.com -->
       </button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">
	        <div class="form-check">
	          <input class="form-check-input" id="flexRadioDefault1" type="radio" name="flexRadioDefault" checked="">
	          <label class="form-check-label text-success" for="flexRadioDefault1">업무</label>
	        </div>
	        <div class="form-check">
	          <input class="form-check-input" id="flexRadioDefault2" type="radio" name="flexRadioDefault">
	          <label class="form-check-label text-warning" for="flexRadioDefault2"">출장</label>
	        </div>
	        <div class="form-check">
	          <input class="form-check-input" id="flexRadioDefault3" type="radio" name="flexRadioDefault">
	          <label class="form-check-label text-primary" for="flexRadioDefault3">외근</label>
	        </div>
	        <div class="form-check">
	          <input class="form-check-input" id="flexRadioDefault4" type="radio" name="flexRadioDefault">
	          <label class="form-check-label text-danger" for="flexRadioDefault4">자리비움</label>
	        </div>
        </p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" type="button">수정</button>
        <button class="btn btn-outline-primary" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 근태 변경 모달창 끝 -->

<div class="mx-lg-n4 mt-3">
	<div class="row g-3">
	<!-- todo 리스트 시작  -->
		<div class="col-12 col-xl-6 col-xxl-6">
			<div class="card h-100">
				<!-- todo 바디쓰면 공간 커짐 -->
				<div class="card-header border-bottom-0 pb-0">
					<div class="row justify-content-between align-items-center mb-4">
						<div class="col-auto">
							<h3 class="text-1100">To do list</h3>
							<p class="mb-0 text-700">할 일을 등록해주세요.</p>
						</div>
						<div class="col-auto w-100 w-md-auto">
							<div class="row align-items-center g-0 justify-content-between">
								<div class="col-auto d-flex">
									<p class="mb-0 ms-sm-3 fs--1 text-700 fw-bold">
										<span class="fas fa-filter me-1 fw-extra-bold fs--2"></span>업무 갯수
									</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="card-body py-0 scrollbar to-do-list-body">
					<div class="d-flex hover-actions-trigger py-2 border-top">
						<input class="form-check-input form-check-input-todolist flex-shrink-0 my-1 me-2 form-check-input-undefined" type="checkbox" id="checkbox-todo-0" data-event-propagation-prevent="data-event-propagation-prevent" />
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
							<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">todo 메모 들어갈 곳 확정</label>
								</div>
							</div>
							<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
								<div class="d-flex lh-1 align-items-center">
									<p class="text-700 fs--2 fw-bold mb-md-0 mb-0 ps-md-3 ps-xl-0 ps-xxl-3 border-start-md border-xl-0 border-start-xxl border-300">
										<button class="btn btn-primary btn-sm" type="button" data-bs-toggle="modal" data-bs-target="#todoModal">수정</button>
										<!-- 등록, 수정 모달창 띄우기 -->
									<div class="modal fade" id="todoModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true" style="display: none;">
										<div class="modal-dialog modal-dialog-centered">
											<div class="modal-content border border-info">
												<div class="modal-header">
													<h5 class="modal-title" id="verticallyCenteredModalLabel">TO_DO 수정 이거얌</h5>
													<button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
														<svg class="svg-inline--fa fa-xmark fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" data-fa-i2svg="">
															<path fill="currentColor" d="M310.6 361.4c12.5 12.5 12.5 32.75 0 45.25C304.4 412.9 296.2 416 288 416s-16.38-3.125-22.62-9.375L160 301.3L54.63 406.6C48.38 412.9 40.19 416 32 416S15.63 412.9 9.375 406.6c-12.5-12.5-12.5-32.75 0-45.25l105.4-105.4L9.375 150.6c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 210.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0s12.5 32.75 0 45.25l-105.4 105.4L310.6 361.4z"></path></svg>
														<!-- <span class="fas fa-times fs--1"></span> Font Awesome fontawesome.com -->
													</button>
												</div>
												<div class="modal-body">
													<p class="text-700 lh-lg mb-0">
														<textarea class="form-control" rows="5" cols="40" placeholder="간단한 업무명이나 메모" id="todo" name="todo"></textarea>
													</p>
												</div>
												<div class="modal-footer">
													<button class="btn btn-primary" type="button">수정</button>
													<button class="btn btn-outline-primary" type="button" data-bs-dismiss="modal">취소</button>
												</div>
											</div>
										</div>
									</div>
									</p>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex hover-actions-trigger py-2 border-top">
						<input class="form-check-input form-check-input-todolist flex-shrink-0 my-1 me-2 form-check-input-undefined" type="checkbox" id="checkbox-todo-0" data-event-propagation-prevent="data-event-propagation-prevent" />
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
							<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">todo 메모 들어갈 곳 확정</label>
								</div>
							</div>
							<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
								<div class="d-flex lh-1 align-items-center">
									<p class="text-700 fs--2 fw-bold mb-md-0 mb-0 ps-md-3 ps-xl-0 ps-xxl-3 border-start-md border-xl-0 border-start-xxl border-300">
										<button class="btn btn-primary btn-sm" type="button" data-bs-toggle="modal" data-bs-target="#todoModal">수정</button>
										<!-- 등록, 수정 모달창 띄우기 -->
									</p>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex hover-actions-trigger py-2 border-top">
						<input class="form-check-input form-check-input-todolist flex-shrink-0 my-1 me-2 form-check-input-undefined" type="checkbox" id="checkbox-todo-0" data-event-propagation-prevent="data-event-propagation-prevent" />
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
							<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">todo 메모 들어갈 곳 확정</label>
								</div>
							</div>
							<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
								<div class="d-flex lh-1 align-items-center">
									<p class="text-700 fs--2 fw-bold mb-md-0 mb-0 ps-md-3 ps-xl-0 ps-xxl-3 border-start-md border-xl-0 border-start-xxl border-300">
										<button class="btn btn-primary btn-sm" type="button" data-bs-toggle="modal" data-bs-target="#todoModal">수정</button>
										<!-- 등록, 수정 모달창 띄우기 -->
									</p>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex hover-actions-trigger py-2 border-top">
						<input class="form-check-input form-check-input-todolist flex-shrink-0 my-1 me-2 form-check-input-undefined" type="checkbox" id="checkbox-todo-0" data-event-propagation-prevent="data-event-propagation-prevent" />
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
							<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">todo 메모 들어갈 곳 확정</label>
								</div>
							</div>
							<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
								<div class="d-flex lh-1 align-items-center">
									<p class="text-700 fs--2 fw-bold mb-md-0 mb-0 ps-md-3 ps-xl-0 ps-xxl-3 border-start-md border-xl-0 border-start-xxl border-300">
										<button class="btn btn-primary btn-sm" type="button" data-bs-toggle="modal" data-bs-target="#todoModal">수정</button>
									</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="card-footer border-0">
					<div class="d-flex justify-content-between">
						<a class="fw-bold fs--1 mt-4" href="" data-bs-toggle="modal" data-bs-target="#todoModal"><span class="fas fa-plus me-1"></span>to do-list 추가</a>
						<button class="btn btn-phoenix-secondary btn-icon fs--2 text-danger px-0" data-bs-toggle="modal" data-bs-target="#todoDelete">
							<span class="fas fa-trash"></span>
						</button>
						<div class="modal fade" id="todoDelete" tabindex="-1" aria-hidden="true" style="display: none;">
							<div class="modal-dialog modal-sm">
								<div class="modal-content">
									<div class="modal-header text-center">
										<h5 class="modal-title text-center" id="exampleModalLabel">TO_DO 삭제</h5>
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
										<button class="btn btn-primary" type="button">Delete</button>
										<button class="btn btn-outline-primary" type="button" data-bs-dismiss="modal">Cancel</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- todo 리스트 끝 -->
		<!-- 결재 현황 -->
		<div class="col-12 col-xl-6 col-xxl-6">
			<div class="card h-100">
				<div class="card-header border-bottom-0 pb-0">
					<div class="row justify-content-between align-items-center mb-4">
						<div class="col-auto">
							<h3 class="text-1100">결재현황 <a href="auth/waitdoc.do"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a></h3>
						</div>
					</div>
				</div>
				<div class="card-body py-0 scrollbar">
					<div class="d-flex hover-actions-trigger py-2 border-top">
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
							<div class="col-6 col-md-6 col-xl-6 col-xxl-6">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">결재 문서명</label>
								</div>
							</div>
							<div class="col-3 col-md-3 col-xl-3 col-xxl-3">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">2023-10-10</label>
								</div>
							</div>
							<div class="col-3 col-md-3 col-xl-3 col-xxl-3">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
										<span class="badge badge-phoenix badge-phoenix-success">결재대기중</span>
									</label>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex hover-actions-trigger py-2 border-top">
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
							<div class="col-6 col-md-6 col-xl-6 col-xxl-6">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">결재 문서명</label>
								</div>
							</div>
							<div class="col-3 col-md-3 col-xl-3 col-xxl-3">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">2023-10-10</label>
								</div>
							</div>
							<div class="col-3 col-md-3 col-xl-3 col-xxl-3">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
										<span class="badge badge-phoenix badge-phoenix-info">결재 참조</span>
									</label>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 결재 현황 끝-->
	</div>
</div>


<div class="mx-lg-n4 mt-3">
	<div class="row g-3">
		<!-- 주소록 시작-->
		<div class="col-6 col-md-6">
			<div class="card h-100">
				<div class="card-header border-bottom-0 pb-0">
					<div class="row justify-content-between align-items-center mb-4">
						<div class="col-auto">
							<h3 class="text-1100">주소록 <a href="#"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a></h3>
						</div>
					</div>
				</div>
				<div class="card-body py-0 scrollbar">
					<div class="d-flex hover-actions-trigger py-2 border-top">
						<div
							class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
							<div class="col-3 col-md-3 col-xl-3 col-xxl-3">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">부서명</label>
								</div>
							</div>
							<div class="col-3 col-md-3 col-xl-3 col-xxl-3">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">김나박이종영</label>
								</div>
							</div>
							<div class="col-3 col-md-3 col-xl-3 col-xxl-3">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">010-6573-7893</label>
								</div>
							</div>
							<div class="col-1 col-md-1 col-xl-1 col-xxl-1">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
										<span class="far fa-comment text-secondary fs-5" style="height: 25px; width: 25px;"></span>
									</label>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 주소록 끝 -->
		<!-- 메일  시작-->
		<div class="col-6 col-md-6">
			<div class="card h-100">
				<div class="card-header border-bottom-0 pb-0">
					<div class="row justify-content-between align-items-center mb-4">
						<div class="col-auto">
							<h3 class="text-1100">메일 <a href="receivedmail.do"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a>
							</h3>
						</div>
					</div>
				</div>
				<div class="card-body py-0 scrollbar">
					<div class="d-flex hover-actions-trigger py-2 border-top">
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
							<div class="col-4 col-md-4 col-xl-4 col-xxl-4">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900 text-secondary" style="line-height: 1.5;">
									 	<a class="a text-secondary" href="#" data-bs-toggle="modal" data-bs-target="#">링크로 하려나 모달로 하려나</a>
									 </label>
								</div>
							</div>
							<div class="col-3 col-md-3 col-xl-3 col-xxl-3">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">2023-10-10</label>
								</div>
							</div>
							<div class="col-2 col-md-2 col-xl-2 col-xxl-2">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">보낸사람임</label>
								</div>
							</div>
							<div class="col-1 col-md-1 col-xl-1 col-xxl-1">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-envelope-fill" viewBox="0 0 16 16">
											<path d="M.05 3.555A2 2 0 0 1 2 2h12a2 2 0 0 1 1.95 1.555L8 8.414.05 3.555ZM0 4.697v7.104l5.803-3.558L0 4.697ZM6.761 8.83l-6.57 4.027A2 2 0 0 0 2 14h12a2 2 0 0 0 1.808-1.144l-6.57-4.027L8 9.586l-1.239-.757Zm3.436-.586L16 11.801V4.697l-5.803 3.546Z" />
										</svg>
									</label>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex hover-actions-trigger py-2 border-top">
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-200 gx-0 flex-1">
							<div class="col-4 col-md-4 col-xl-4 col-xxl-4">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">
										<a class="a text-secondary" href="#" data-bs-toggle="modal" data-bs-target="#">링크로 하려나 모달로 하려나</a>
									</label>
								</div>
							</div>
							<div class="col-3 col-md-3 col-xl-3 col-xxl-3">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">2023-10-10</label>
								</div>
							</div>
							<div class="col-2 col-md-2 col-xl-2 col-xxl-2">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-0 me-2 line-clamp-1 text-900" style="line-height: 1.5;">보낸사람임</label>
								</div>
							</div>
							<div class="col-1 col-md-1 col-xl-1 col-xxl-1">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<!-- label 유뮤 차이 확인하기-->
									<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-envelope-open" viewBox="0 0 16 16">
										  <path d="M8.47 1.318a1 1 0 0 0-.94 0l-6 3.2A1 1 0 0 0 1 5.4v.817l5.75 3.45L8 8.917l1.25.75L15 6.217V5.4a1 1 0 0 0-.53-.882l-6-3.2ZM15 7.383l-4.778 2.867L15 13.117V7.383Zm-.035 6.88L8 10.082l-6.965 4.18A1 1 0 0 0 2 15h12a1 1 0 0 0 .965-.738ZM1 13.116l4.778-2.867L1 7.383v5.734ZM7.059.435a2 2 0 0 1 1.882 0l6 3.2A2 2 0 0 1 16 5.4V14a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V5.4a2 2 0 0 1 1.059-1.765l6-3.2Z" />
									</svg>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 메일  끝-->
	</div>
</div>

<!-- 프로젝트 -->
<div class="mx-lg-n4 mt-3">
<!-- 프로젝트 시작-->
	<div class="col-12 col-md-12">
		<div class="card h-100">
			<div class="card-body d-flex flex-column scroll">
				<div class="row align-items-end justify-content-between pb-4 g-3">
					<div class="col-auto">
						<h3>
							Projects <a href="#"><span class="fas fa-plus me-1" style="font-size: 16px; color: black"></span></a>
						</h3>
					</div>
				</div>
				<div class="card-body py-0 scrollbar to-do-list-body">
					<table class="table fs--1 mb-0 border-top border-200">
						<thead>
							<tr>
								<th class="align-middle ps-0" scope="col" data-sort="project" style="width: 50%;">PROJECT NAME</th>
								<th class="align-middle ps-3" scope="col" data-sort="start" style="width: 10%;">START DATE</th>
								<th class="align-middle ps-3" scope="col" data-sort="deadline" style="width: 15%;">DEADLINE</th>
								<th class="align-middle ps-3" scope="col" data-sort="deadline" style="width: 15%;">PROGRESS</th>
							</tr>
						</thead>
						<tbody class="list" id="project-summary-table-body">
							<tr class="position-static">
								<td class="align-middle time white-space-nowrap ps-3 project" style="font-weight: bold;">프로젝트 이름
								</td>
								<td class="align-middle white-space-nowrap start ps-3">
									<p class="mb-0 fs--1 text-900">시작 날짜</p>
								</td>
								<td class="align-middle white-space-nowrap deadline ps-3">
									<p class="mb-0 fs--1 text-900">데드라인</p>
								</td>
								<td class="align-middle white-space-nowrap ps-3 projectprogress">
									<p class="text-800 fs--2 mb-0 text-center">완료업무/업무총갯수</p>
									<div class="progress" style="height: 15px;">
										<div class="progress-bar bg-success" style="width: 80%" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100" role="progressbar">80%</div>
									</div>
								</td>
							</tr>
							<tr class="position-static">
								<td class="align-middle time white-space-nowrap ps-3 project" style="font-weight: bold;">Making the Butterflies shoot each other dead
								</td>
								<td class="align-middle white-space-nowrap start ps-3">
									<p class="mb-0 fs--1 text-900">2023-10-10</p>
								</td>
								<td class="align-middle white-space-nowrap deadline ps-3">
									<p class="mb-0 fs--1 text-900">2023-10-20</p>
								</td>
								<td class="align-middle white-space-nowrap ps-3 projectprogress">
									<p class="text-800 fs--2 mb-0 text-center">완료업무/업무총갯수</p>
									<div class="progress" style="height: 15px;">
										<div class="progress-bar bg-success" style="width: 100%" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100" role="progressbar">width%</div>
									</div>
								</td>
							</tr>
							<tr class="position-static">
								<td class="align-middle time white-space-nowrap ps-3 project" style="font-weight: bold;">Making the Butterflies shoot each other dead
								</td>
								<td class="align-middle white-space-nowrap start ps-3">
									<p class="mb-0 fs--1 text-900">시작 날짜</p>
								</td>
								<td class="align-middle white-space-nowrap deadline ps-3">
									<p class="mb-0 fs--1 text-900">데드라인</p>
								</td>
								<td class="align-middle white-space-nowrap ps-3 projectprogress">
									<p class="text-800 fs--2 mb-0 text-center">완료업무/업무총갯수</p>
									<div class="progress" style="height: 15px;">
										<div class="progress-bar bg-success" style="width: 100%" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100" role="progressbar">width%</div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<!-- 프로젝트 끝-->
</div>
<!--  캘린더 -->
<div class="mx-lg-n4 mt-3">
	<!--  캘린더 시작 -->
	<div class="col-12 col-md-12">
		<div class="card h-100">
			<div class="card-body d-flex flex-column scroll">
				<div class="p-4 code-to-copy">
					<div data-calendar='{"events":[{"title":"Bootcamp","start":"2023-06-19"}]}'></div>
				</div>
			</div>
		</div>
	</div>
	<!--  캘린더 끝  -->
</div>
<script type="text/javascript">
var chartDom = document.getElementsByClassName('echart-gauge-ring-chart-example1');
var myChart = echarts.init(chartDom[0]);
var option;

const gaugeData = [
  {
    value: 10,
//     name: 'Perfect',
    title: {
      offsetCenter: ['0%', '-30%']
    },
    detail: {
      valueAnimation: true,
      offsetCenter: ['0%', '-20%']
    }
  }
];
option = {
  series: [
    {
      type: 'gauge',
      startAngle: 90,
      endAngle: -270,
      pointer: {
        show: false
      },
      progress: {
        show: true,
        overlap: false,
        roundCap: true,
        clip: false,
        itemStyle: {
          borderWidth: 1,
          borderColor: '#464646'
        }
      },
      axisLine: {
        lineStyle: {
          width: 20
        }
      },
      splitLine: {
        show: false,
        distance: 0,
        length: 10
      },
      axisTick: {
        show: false
      },
      axisLabel: {
        show: false,
        distance: 50
      },
      data: gaugeData,
      title: {
        fontSize: 14
      },
      detail: {
        width: 50,
        height: 14,
        fontSize: 14,
        color: 'inherit',
        borderColor: 'inherit',
        borderRadius: 0,
        borderWidth: 0,
        formatter: '{value}%'
      }
    }
  ]
};
// setInterval(function () {
//   gaugeData[0].value = +(Math.random() * 100).toFixed(2);
//   myChart.setOption({
//     series: [
//       {
//         data: gaugeData,
//         pointer: {
//           show: false
//         }
//       }
//     ]
//   });
// }, 2000);

option && myChart.setOption(option);
</script>
