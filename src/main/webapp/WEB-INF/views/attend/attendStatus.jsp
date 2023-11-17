<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set value="${status }" var="status"/>
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
						<div class="row pb-7">
							<div class="col-1" style=""></div>
							<div class="col-8">
								<h2 style="margin: 40px 0px 0px 0px">근무상태변경</h2>
							</div>
						</div>
						
						<div class="row pt-7 pb-3">
							<div class="col-1"></div>
							<div class="col-5">
								<div class="row">
									<div class="col-4">
										<h4 class="fw-normal">현재근무상태&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </h4>
									</div>
									<div class="col-3" id="statusBody">
										<c:choose>
											<c:when test="${status.atStatus eq '업무' }">
												<h4 class="text-success">업무</h4>
											</c:when>
											<c:when test="${status.atStatus eq '출장' }">
												<h4 class="text-warning">출장</h4>
											</c:when>
											<c:when test="${status.atStatus eq '외근' }">
												<h4 style="color:#8a5227;">외근</h4>
											</c:when>
											<c:when test="${status.atStatus eq '자리비움' }">
												<h4 class="text-danger">자리비움</h4>
											</c:when>
										</c:choose>										
									</div>
								</div>
							</div>
						</div>
						
						<div class="row pt-3 pb-3">
							<div class="col-1"></div>
							<div class="col-5">
								<h4 class="fw-normal">변경할 근무상태를 선택하세요</h4>
							</div>
						</div>
						
						<div class="row pb-3">
							<div class="col-2"></div>
							
							
							<div class="col-2 pt-2 pb-3">
								<div class="form-check">
									<input class="form-check-input" id="flexRadioDefault1"
										type="radio" name="atStatus" value="업무"/> <label
										class="form-check-label" for="flexRadioDefault1">
											<h4 class="pt-1 text-success">&nbsp;업무</h4>
										</label>
								</div>
							</div>
							
							
							<div class="col-2">
								<div class="form-check">
									<input class="form-check-input" id="flexRadioDefault1"
										type="radio" name="atStatus" value="출장"/> <label
										class="form-check-label" for="flexRadioDefault1">
											<h4 class="pt-1 text-warning">&nbsp;출장</h4>
										</label>
								</div>
							</div>
							
							
							<div class="col-2">
								<div class="form-check">
									<input class="form-check-input" id="flexRadioDefault1"
										type="radio" name="atStatus" value="외근" /> <label
										class="form-check-label" for="flexRadioDefault1">
											<h4 class="pt-1" style="color:#8a5227;">&nbsp;외근</h4>
										</label>
								</div>
							</div>
							
							
							<div class="col-2">
								<div class="form-check">
									<input class="form-check-input" id="flexRadioDefault1"
										type="radio" name="atStatus" value="자리비움" /> <label
										class="form-check-label" for="flexRadioDefault1">
											<h4 class="pt-1 text-danger">&nbsp;자리비움</h4>
										</label>
								</div>
							</div>
						</div>
						
						<div class="row pb-7 pt-1">
							<div class="col-2"></div>
							<div class="col-8">
							
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
			<div class="row align-items-center py-1">
				<div class="pagination d-none"></div>
				<div class="col d-flex fs--1">
					<!-- 하단부 -->

				</div>
			</div>
			<div class="row" style="margin: 15px 0px 20px 0px;">
				<div class="col-9"></div>
				<div class="col-3 text-end">
					<button class="btn btn-primary me-1 mb-7" type="button" id="saveBtn">저장</button>
				</div>
			</div>
		</div>
	</div>

<!-- 체크처리 확인 모달 -->
<div class="modal fade" id="checkModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">근무상태 변경 확인에 동의해주세요.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-primary" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>

<div class="modal fade" id="checkOkayModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">아이웍스</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">근무상태 변경이 완료되었습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-primary" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>


<script type="text/javascript">
$(function(){
	var saveBtn = $('#saveBtn');
	var checkModal = $('#checkModal');
	var checkBx = $('#checkBx');
	var checkOkayModal = $('#checkOkayModal');
	
	saveBtn.on('click', function(){
		var atStatus = $('input[name="atStatus"]:checked').val();
		console.log(atStatus);
		var str = "";
		var statusBody = $('#statusBody');
		
		var weekObject = {
				atStatus : atStatus
			};
		
		if(!checkBx.prop('checked')) {
			checkModal.modal('show');
			return false;
		} else {
			checkOkayModal.modal('show');
			
			$.ajax({										
				type:"POST",
	            url:"/atStatusAjax.do",
	            data : JSON.stringify(weekObject),
	            contentType : "application/json; charset=utf-8",
	            success:function(result){
	            	statusBody.html('');
	            	console.log(result.atStatus);
	             	if(result.atStatus == '업무'){
	             		str += '<h4 class="text-success">업무</h4>';
	             	} else if(result.atStatus == '출장') {
	             		str += '<h4 class="text-warning">출장</h4>';
	             	} else if(result.atStatus == '외근') {
	             		str += '<h4 style="color:#8a5227;">외근</h4>'
	             	} else if(result.atStatus == '자리비움') {
	             		str += '<h4 class="text-danger">자리비움</h4>';
	             	}	             		
	             	statusBody.html(str)
	            }
			});
		}
	});
	
	CKEDITOR.replace('exampleTextarea'
            , {height: 500                                                  
            });
	
	
});
</script>