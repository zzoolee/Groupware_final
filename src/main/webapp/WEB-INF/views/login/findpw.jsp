<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="col-sm-10 col-md-8 col-lg-5 col-xxl-4"><a class="d-flex flex-center text-decoration-none mb-4" href="/" data-bs-toggle="tooltip" data-bs-placement="top" title="메인으로 돌아가기">
    <div class="d-flex align-items-center fw-bolder fs-5 d-inline-block">
    	<img src="${pageContext.request.contextPath }/resources/assets/gw/IW_Logo.png" alt="i-works" width="58" />
    </div>
  </a>
  <div class="px-xxl-5">
  <!--  디자인 만들기 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -->
    <div class="text-center mb-6">
      <h4 class="text-1000">비밀번호를 잊으셨나요?</h4>
      <p class="text-700 mb-5">이메일을 입력해주세요. 임시 비밀번호를 발송해 드립니다.</p>
      <div class="d-flex align-items-center mb-5">
        <input class="form-control flex-1" id="empEmail" name="empEmail" type="email" placeholder="등록 된 이메일을 입력해주세요" />
      </div>
      <div class="d-flex align-items-center mb-5">
        <input class="form-control flex-1" id="empNo" name="empNo" type="text" placeholder="사번을 입력해주세요" />
       </div>
       <div class="col-12 align-items-center mb-5">
        <button class="btn btn-outline-primary ms-2" id="findPwBtn" type="button">임시 비밀번호 발송<span class="fas fa-chevron-right ms-2"></span></button>
        </div>
    </div>
  </div>
</div>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script type="text/javascript">
$(function(){

	var findPwBtn = $("#findPwBtn");
	var empEmail = $("#empEmail");
	var empNo = $("#empNo");
	//헤더에 있는 알러트를 표시하는 div 영역
	var showAlert = $("#showAlert");
	
	findPwBtn.on("click", function(){
		var data = {
				empNo : empNo.val(),
				empEmail : empEmail.val()
		};
		
		var html="";
		var loading = "";
		$.ajax({
			type : "post",
			data : JSON.stringify(data),
			url : "/findPwSendEmail.do",
			contentType : "application/json; charset=utf-8",
			beforeSend : function(){
				loading += 
					`
					<div class='d-flex align-items-center text-center mt-3' role='alert' style="width:25%; position: fixed; top: 3%; left: 62%; transform: translate(-50%, -50%); z-index: 9999;">
						<div class="spinner-border text-danger" role="status">
			 		 		<span class="visually-hidden">Loading...</span>
						</div>	
					</div>
					`
					showAlert.html(loading);
			},
			success : function(res){
				if(res === "ok"){
					 html += `
					 <div class='alert alert-outline-success d-flex align-items-center text-center mt-3' role='alert' style="width:25%; position: fixed; top: 3%; left: 50%; transform: translate(-50%, -50%); z-index: 9999;">
					 	<span class='fas fa-check-circle text-success fs-3 me-3'></span>
					 	<p class='mb-0 flex-1'>등록된 이메일로 임시 비밀번호를 발송했습니다.</p>
					 	<button class='btn-close' type='button' data-bs-dismiss='alert' aria-label='Close'></button>
					 </div>
					 `
				}else{
					 html += `
					 	<div class='alert alert-outline-danger d-flex align-items-center text-center mt-3' role='alert' style="width:25%; position: fixed; top: 3%; left: 50%; transform: translate(-50%, -50%); z-index: 9999;">
							<span class='fas fa-check-circle text-danger fs-3 me-3'></span>
							<p class='mb-0 flex-1'>회원 정보가 존재하지 않습니다.</p>
							<button class='btn-close' type='button' data-bs-dismiss='alert' aria-label='Close'></button>
						</div>
						 `
				}
					
				showAlert.html(html);
			}
		});
	});
	
})
</script>