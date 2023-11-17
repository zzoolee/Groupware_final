<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:if test="${not empty message }">
<script>
$(document).ready(function(){
	var messageModal = $('#messageModal');
	messageModal.modal('show');
});
</script>
</c:if>
	<div class="pb-5">
		<div class="row g-4">
			<div class="col-12 col-xxl-6">
				<div></div>
			</div>

		</div>
	</div>
	<div
		class="mx-n4 px-4 mx-lg-n6 px-lg-6 bg-white pt-7  border-300">
		<div
			data-list='{"valueNames":["product","customer","rating","review","time"],"page":6}'>


			<div>
				<div class="container-fluid">
					<div class="card mt-7" style="border-radius:20px">
						<div class="row">
							<div class="col-1" style=""></div>
							<div class="col-10">
								<h2 style="margin: 40px 0px 0px 0px">근무일정 변경</h2>
							</div>
						</div>
						<div class="row pt-10">
							<div class="col-1"></div>
							<div class="col-10">
								<h4 class="fw-normal" style="margin: 40px 0px 0px 0px">근무일정 변경</h4>
							</div>
						</div>
						<form action="/attendmain.do" method="POST" id="typeSubmit">
						<div class="row pt-3">
							<div class="col-1"></div>
							<div class="col-10">	
								<select class="form-select form-select-lg mb-3 text-center" 
								name="atType" aria-label=".form-select-lg example">
									<option selected="" >근무유형을 선택하세요</option>
									<option value="기본">기본근무 (09:00 ~ 18:00)</option>
									<option value="유연A">유연근무 A유형 (08:00 ~ 17:00)</option>
									<option value="유연B">유연근무 B유형 (10:00 ~ 19:00)</option>
									<option value="재택">재택근무 (09:00 ~ 18:00)</option>
								</select>
							</div>
						</div>
						</form>
						<div class="row pt-0 pb-10">
							<div class="col-1"></div>
							<div class="col-10">
								<div class="form-check">
  									<input class="form-check-input" id="checkBtn" type="checkbox" value="" />
 									<label class="form-check-label" for="flexCheckChecked">근무일정은 익일 출근부터 변경되며, 근무 변경으로 인한 책임은 본인에게 있음에 동의합니다.</label>
								</div>
							</div>
						</div>
					</div>
				</div>


			</div>
			<div class="row align-items-center py-1">
				<div class="pagination d-none"></div>
				<div class="col d-flex fs--1">
					<!-- 하단부 -->

				</div>
			</div>
			<div class="row" style="margin: 15px 0px 20px 0px;">
				<div class="col-9"></div>
				<div class="col-3 text-end">
					<button class="btn btn-primary me-1 mb-7" type="button" id="submitBtn">저장</button>
				</div>
			</div>
		</div>
	</div>
	
<!-- 체크버튼이 활성화되지 않은 상태로 서브밋 이벤트를 진행하면 나올 모달창 -->
<div class="modal fade" id="checkModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">안내사항을 읽고 체크해주세요.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-primary" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>



<div class="modal fade" id="messageModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">${message }</p>
      </div>
      <div class="modal-footer"><button class="btn btn-primary" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>

<script type="text/javascript">
$(function(){
	var submitBtn = $('#submitBtn');
	var checkBtn = $('#checkBtn');
	var checkModal = $('#checkModal');
	var typeSubmit = $('#typeSubmit');
	
	submitBtn.on('click', function(){		
		if(!checkBtn.prop('checked')) {
			checkModal.modal('show');
			return;
		}
	typeSubmit.submit();
	});
	
});
</script>













