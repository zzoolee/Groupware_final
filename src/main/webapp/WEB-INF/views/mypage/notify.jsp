<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="pb-8">
	<h2 class="mb-4">알림설정</h2>
	<div id="reports">
		<div class="row g-3 list" id="reportsList">
			<div class="col-12 col-xl-6">
				<div class="card h-100">
					<div class="card-header p-2">
						<div class="d-flex justify-content-between">
							<h3 class="text-black mb-0" style="line-height: 1.5;">현재 수신 알림</h3>
						</div>
						<div class="d-flex">
							<span style="margin-right: 10px;"><h5 class="text-warning mb-0">결재</h5></span>
							<span style="margin-right: 10px;"><h5 class="text-primary mb-0">채팅</h5></span>
						</div>
					</div>
					<form action="#" method="post">
						<div class="card-body">
							<div class="d-flex align-items-start justify-content-center mb-1">
								<span class="text-primary" style="margin-right: 15px;">
									<input class="form-check-input" type="checkbox" id="chat" name="chat" checked/>채팅
								</span>
								<span class="text-success" style="margin-right: 15px;">
									<input class="form-check-input" type="checkbox" id="mail" name="mail"/>메일
								</span>
								<span class="text-danger" style="margin-right: 15px;">
									<input class="form-check-input" type="checkbox" id="task" name="task"/>업무
								</span>
								<span class="text-warning" style="margin-right: 15px;">
									<input class="form-check-input" type="checkbox" id="author" name="author"/>결재
								</span>
								<span class="text-info" style="margin-right: 15px;">
									<input class="form-check-input" type="checkbox" id="comment" name="comment"/>댓글
								</span>
								<span class="text-success" style="margin-right: 15px;">
									<input class="form-check-input" type="checkbox" id="schedule" name="schedule"/>회사일정
								</span>
							</div>
						</div>
						<div class="card-footer">
							<div class="d-flex align-items-start justify-content-center mb-1">
								<button class="btn btn-outline-info" type="submit">적용</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>