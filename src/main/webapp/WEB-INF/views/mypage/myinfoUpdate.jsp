<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!-- <div> -->
<!-- 	<div class="row"> -->
<!-- 		<div class="col-12"> -->
<!-- 			<div class="row align-items-center justify-content-between g-3 mb-3"> -->
<!-- 				<div class="col-12 col-md-auto"> -->
					
<!-- 				</div> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->

<h2><a href="/myinfo.do">개인정보</a> > 개인정보 수정</h2>
<div class="row col-12 ms-6 mt-5 justify-content-center">
	<div class="col-7">
		<form class="needs-validation" novalidate="" action="/myinfoUpdate.do" method="post" enctype="multipart/form-data" id="FormUpdate">
		<input type="hidden" name="empNo" value="${empVO.empNo }"/>
			<!-- 프로필 이미지 -->
			<div class="mt-3 g-0 g-md-4 g-xl-6 justify-content-center">
				<div class="row">
					<div class="col-md-4 col-lg-4 col-xl-4">
						<div class="card mb-3">
							<div class="card-body">
								<div class="row align-items-center g-3 text-center text-xxl-start">
									<div class="col-12 col-xxl-auto mb-3">
										<div class="avatar avatar-5xl">
											<c:choose>
												<c:when test="${not empty empVO.empPhoto }">
													<img class="rounded-soft" src="${empVO.empPhoto }" alt="profileImg" id="imgProfile"/>
													<div id="divImgProfile" style="display:none;">${empVO.empPhoto }</div>
												</c:when>
												<c:otherwise>
													<img class="rounded-soft" src="/resources/assets/gw/profile.png" alt="profileImg" id="imgProfile"/>
												</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="col-12 col-sm-auto flex-1">
										<h3 class="fw-bolder mb-2">${empVO.empName }</h3>
										<p class="mb-0">사번 : <span class="fw-bold text-info" id="empNo">${empVO.empNo }</span></p>
										<p class="mb-0">직급 : <span class="fw-bold text-info">${empVO.codeVO.cdName }</span></p>
										<p>소속 : <span class="fw-bold text-info">${empVO.deptVO.deptName }</span></p>
									</div>
								</div>
								<div class="row align-items-center g-3 text-center text-xxl-start">
									<div class="col-12 col-xxl-auto">
										<div class="input-group mb-3">
											<div class="custom-file">
												<label class="form-label" for="customFile" style="font-size:12px; color:black;">프로필 이미지를 선택해주세요</label>
												<input class="form-control" name="imgFile" id="imgFile" type="file"/>
												<div class="imgFileCheck text-danger text-center"></div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
			
					<!-- 개인정보  -->
					<div class="row col-7 justify-content-center">
			<!-- 			<div class="col-md-7 col-lg-7 col-xl-7"> -->
							<div class="card mb-3">
								<div class="card-body">
									<div class="d-flex align-items-center mb-5">
										<h3>내정보 수정</h3>
									</div>
										<div class="mb-4">
											<div class="d-flex align-items-center mb-1">
												<span class="me-2 uil uil-lock"> </span>
												<h5 class="text-1000 mb-0">비밀번호</h5>
											</div>
											<input class="form-control" type="password" id="empPw" name="empPw" placeholder="현재 비밀번호" value="" required=""/>
											<div class="d-flex align-items-center mb-1"></div>
											<input class="form-control" type="password" id="empPwNew" name="empPwNew" placeholder="새로운 비밀번호(비밀번호 수정시 작성해주세요)" value=""/>
											<div class="d-flex align-items-center mb-1"></div>
											<input class="form-control" type="password" id="empPwCheck" name="empPwCheck" placeholder="새로운 비밀번호 재확인" value=""/>
											<div class="pwCheck text-danger text-center"></div>
										</div>
										<div class="mb-4">
											<div class="d-flex align-items-center mb-1">
												<span class="me-2 uil uil-envelope-alt"> </span>
												<h5 class="text-1000 mb-0">메일</h5>
											</div>
											<input class="form-control" type="text" id="empEmail" name="empEmail" placeholder="abc@example.com" value="${empVO.empEmail }" required=""/>
											<c:if test="${empVO.empLoginse eq '0' && empty empVO.empPhoto }">
												<div class="d-grid gap-2">
			    								  <input class="form-control mt-1" type="text" id="authEmailCheck" placeholder="인증번호 입력" value="" required=""/>
												  <button class="btn btn-primary mt-1" type="button" id="authNumberBtn">인증번호 발송</button>
												</div>
											</c:if>
											<div class="emailCheck text-danger text-center"></div>
										</div>
										<div class="mb-4">
											<div class="d-flex align-items-center mb-1">
												<span class="me-2 uil uil-phone"> </span>
												<h5 class="text-1000 mb-0">연락처</h5>
											</div>
											<input class="form-control" type="text" id="empHp" name="empHp" value="${empVO.empHp }" required=""/>
											<div class="empHpCheck text-danger text-center"></div>
										</div>
										<div class="mb-4">
											<div class="d-flex align-items-center mb-1">
												<span class="me-2 uil uil-estate"></span>
												<h5 class="mb-0">주소</h5>&nbsp;&nbsp;
												<span class="input-group-append">
													<button type="button" onclick="DaumPostcode()" class="btn btn-phoenix-secondary me-1 mb-1 btn-sm">우편번호 찾기</button>
												</span>
											</div>
											<input class="form-control" type="text" id="empAdd1" name="empAdd1" placeholder="주소" value="${empVO.empAdd1 }" required=""/>
											<input class="form-control" type="text" id="empAdd2" name="empAdd2" placeholder="상세주소" value="${empVO.empAdd2 }" required=""/>
											<div class="addCheck text-danger text-center"></div>
										</div>
										<div class="mb-4">
											<div class="d-flex align-items-center mb-1">
												<span class="me-2 uil uil-calendar-alt"></span>
												<h5 class="text-1000 mb-0">입사일자</h5>
											</div>
											<p class="mb-0 text-800">
												<fmt:formatDate value="${empVO.empHire }" pattern="yyyy-MM-dd"/>
											</p>
										</div>
										<div class="mb-4">
											<div class="d-flex align-items-center mb-1">
												<span class="me-2 uil uil-nerd"></span>
												<h5 class="text-1000 mb-0">당해연차</h5>
											</div>
											<p class="mb-0 text-800">12</p>
										</div>
										<div class="mb-4">
											<div class="d-flex align-items-center mb-1">
												<span class="me-2 fas fa-file-signature"></span>
												<h5 class="text-1000 mb-0">서명이미지</h5>
											</div>
											<div class="avatar avatar-5xl">
												<c:if test="${not empty empVO.empSign }">
													<img class="rounded-soft" src="${empVO.empSign }" alt="signImg" id="signImg"/>
												</c:if>
												<c:if test="${empty empVO.empSign }">
													<img class="rounded-soft" src="/resources/assets/gw/sign.png" alt="signImg" id="signImg"/>
												</c:if>
											</div>
											<div class="input-group mb-5">
												<div class="custom-file">
													<label class="form-label" for="customFile" style="font-size:12px; color:black;">서명 이미지를 선택해주세요</label>
													<input class="form-control" name="signImgFile" id="signImgFile" type="file" />
													<div class="signCheck text-danger text-center"></div>
												</div>
											</div>
											<div class="mb-3">
												<div class="d-flex justify-content-center align-items-end mb-1">
													<button class="btn btn-info me-1 mb-1" type="button" id ="updateBtn">수정</button>
													<button class="btn btn-outline-info me-1 mb-1" type="button" onclick="history.back()">취소</button>
												</div>
											</div>
										</div>
									</div>
			<!-- 					</div> -->
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>	
			<!-- 아이웍스 사진  -->
			<div class="col-5 mt-8 justify-content-end">
				<div>
					<img alt="" src="${pageContext.request.contextPath }/resources/assets/gw/i-works3.png" style="height: 600px;">
				</div>
			</div>
	</div>
	
<!-- 	</div> -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
	$(function() {
		//button
		var updateBtn = $("#updateBtn");
		var authNumberBtn = $("#authNumberBtn");
		//form 
		var FormUpdate = $("#FormUpdate");
		
		// 신입사원 인지 비밀번호 변경 여부인지 확인을 위한 용도 
		var divImgProfile = $("#divImgProfile");
		var empHp = $("#empHp");
		var empPw = $("#empPw");
		var empPwNew = $("#empPwNew");
		var empPwCheck = $("#empPwCheck");
		var empEmail = $("#empEmail");
		var empAdd1 = $("#empAdd1");
		var empAdd2 = $("#empAdd2");
		var imgFile = $("#imgFile"); // 프로필 파일 선택 Element
		var signImgFile = $("#signImgFile"); // 사인 파일 선택 Element
		var signImg = $("#signImg"); // 사인 이미지 Element
		var imgProfile = $("#imgProfile"); // 프로필 사진 파일 선택 Element
		var empLoginse = ${empVO.empLoginse };
		// 비밀번호 정규식
		var  empPwNewReg = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,}$/;
		// 핸드폰 번호 정규식
		var empHpReg = /^\d{3}-\d{3,4}-\d{4}$/;
		// 이메일 정규식
		var mailReg = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		
		console.log("empLoginse>>",empLoginse);

		// 신규회원 첫 로그인 시 메일 인증
		
		
		var flag = false;	// 이메일 인증 안함
		var empFlag = false;
		var authEmailCheck = $("#authEmailCheck");
		authNumberBtn.on("click", function(){
					var rnd="";
	
					for(var i=0; i<5; i++){
					rnd += Math.floor(Math.random()*10)
					}
					console.log("rnd 확인 : " +rnd);
					var data = {
							rnd : rnd,
							email : empEmail.val()
					};
					$.ajax({
						
						type : "post",
						url : "/authNumberMail.do",
						contentType : "application/json; charset=utf-8",
						data : JSON.stringify(data),
						success: function(res){
							alert("인증번호를 해당 메일로 발송하였습니다.");	
							
						}
						
					});
			authEmailCheck.keyup(function(){
				
				console.log("rnd 값 확인 : "+rnd);
				console.log("val 값 확인 "+authEmailCheck.val());
				
				if(authEmailCheck.val() === rnd){
					console.log("val 값 확인 "+authEmailCheck.val());
					$(".emailCheck").text("인증되었습니다.");
					$(".emailCheck").attr("class","emailCheck text-primary text-center");
					flag = true;
				}else{
					$(".emailCheck").text("인증번호가 일치하지 않습니다.");
					$(".emailCheck").attr("class","emailCheck text-danger text-center");
					
				}
			});					

		});
		
		
		//개인정보 수정
		updateBtn.on("click", function(){
			
			// 비밀번호 찾기나 신규 회원 첫 로그인 시 적용			
			if(empLoginse == '0'){
				
				if(divImgProfile.text() == null || divImgProfile.text() == ""){
					empFlag = true;	
					
					if(imgFile.val() == null || imgFile.val() == ""){
						$(".imgFileCheck").text("프로필 이미지를 선택해주세요!");
						return;
					}
					
				}
				
				if(signImg.attr("src") == null || signImg.attr("src") == ""){
					
					if(signImgFile.val() == null || signImgFile.val() == ""){
						$(".signCheck").text("서명 이미지를 선택해주세요!");
						return;
					}
				}
			
				if(empPwNew.val() == null || empPwNew.val() ==""){
					$(".pwCheck").text("새로운 비밀번호를 입력해주세요!");
					empPwNew.focus();
					return;
				}
				
			}
		
			
			if(empPw.val() == null || empPw.val() == ""){
				$(".pwCheck").text("현재 비밀번호를 입력해주세요!");
				empPw.focus();
				return;
			}
			// 신규 비밀번호 입력 시 
			if((empPwNew.val() != null || empPwNew.val() !="") && empPwNew.val().length > 0){
				
				if(!empPwNewReg.test(empPwNew.val())){
					$(".pwCheck").text("비밀번호는 8자리 이상, 하나 이상의 알파벳, 특수문자, 숫자를 조합하여 주세요!");
					empPwNew.focus();
					return;
				}
				
				if(empPwNew.val() != empPwCheck.val()){
					$(".pwCheck").text("비밀번호 일치여부를 확인 해주세요!");
					empPwCheck.focus();
					return;
				}
			}
			
			if(empEmail.val() == null || empEmail.val() == ""){
				$(".emailCheck").attr("class","emailCheck text-danger text-center");
				$(".emailCheck").text("이메일을 입력해주세요!");
				empEmail.focus();
				return;
			}
			
			if((empEmail.val() != null || empEmail.val() != "") && empEmail.val().length > 0){
				if(!mailReg.test(empEmail.val())){
					$(".emailCheck").text("이메일형식에 맞춰 입력해주세요!");
					empEmail.focus();
					return;
				}
			}
			
			
			if(empAdd1.val() == null || empAdd1.val() == ""){
				$(".addCheck").text("주소를 입력해주세요!");
				empAdd1.focus();
				return;
			}
			
			if(empAdd2.val() == null || empAdd2.val() == ""){
				$(".addCheck").text("상세주소를 입력해주세요!");
				empAdd2.focus();
				return;
			}
			
			
			if((empHp.val() != null || empHp.val() != "") && empHp.val().length > 0){
				if(!empHpReg.test(empHp.val())){
					$(".empHpCheck").text("010-1234-1234 형식에 맞춰 입력해주세요!");
					empHp.focus();
					return;
				}
			}
			
			var data = {
					empNo : $("#empNo").text(),
					empPw : empPw.val()
			}
			console.log(data);
			
			if(empFlag == true && flag == false){
				$(".emailCheck").text("이메일 인증을 진행해주세요!");
				$(".emailCheck").attr("class","emailCheck text-danger text-center");
				return false;
			}
			
			$.ajax({
				type : "post",
				url : "/checkPw.do",
				data : JSON.stringify(data),
				contentType : "application/json; charset=utf-8",
				success : function(res){
					if(res.msg == "비밀번호 불일치"){
						alert(res.msg);
						return;
					}
					FormUpdate.submit();
				},
				error : function(error){
					console.log(error);
				}
			});
			
		});

		imgFile.on("change", function(event) {
			var file = event.target.files[0];
			console.log("선택된 파일 확인  : "+file);
			if (isImageFile(file)) {
				var reader = new FileReader();
				reader.onload = function(e) {
					$("#imgFile").attr("src", e.target.result);
				}
				reader.readAsDataURL(file);
			} else {
				alert("이미지 파일을 선택해주세요");
			}
			
			var formData = new FormData();
			formData.append("file",file);
			
			$.ajax({
				type : "post",
				url : "/thumnail.do",
				data : formData,
				dataType : "text",
				processData : false,
				contentType : false,
				success : function(data){
					console.log("미리보기 동작 ajax 리턴값" + data);
					
					if(checkImageType(data)){
						imgProfile.attr("src","/resources/upload"+data);
					}else{
						alert("이미지 파일만 등록 가능합니다!");
					}
				},
				error : function(err){
					alert("서버에러, 파일 형식을 확인해주세요!");
				}
			});
			
		});
		
		signImgFile.on("change", function(event) {
			
			var file = event.target.files[0];
			console.log("선택된 파일 확인  : "+file);
			
			if (isImageFile(file)) {
				var reader = new FileReader();
				reader.onload = function(e) {
					$("#signImgFile").attr("src", e.target.result);
				}
				reader.readAsDataURL(file);
			} else {
				alert("이미지 파일을 선택해주세요");
			}
			
			var formData = new FormData();
			formData.append("file",file);
			
			$.ajax({
				type : "post",
				url : "/thumnail.do",
				data : formData,
				dataType : "text",
				processData : false,
				contentType : false,
				success : function(data){
					console.log("미리보기 동작 ajax 리턴값" + data);
					
					if(checkImageType(data)){
						$("#signImg").attr("src","/resources/upload"+data);
					}else{
						alert("이미지 파일만 등록 가능합니다!");
					}
				},
				error : function(err){
					alert(err);
				}
			});
			
			
		});
		
	});

	// 이미지 파일인지 체크 
	function isImageFile(file) {
		var ext = file.name.split(".").pop().toLowerCase(); // 파일명에서 확장자를 꺼낸다.
		return ($.inArray(ext, [ "jpg", "jpeg", "gif", "png" ]) === -1 ? false
				: true);
	}
	// 미리 보기 생성 시 이미지 파일인지 확인 
	function checkImageType(fileName){
		var pattern = /jpg|gif|png|jpeg/i;
		return fileName.match(pattern); // 패턴과 일치하면 true
	}
	
	// 다음 주소 API
	function DaumPostcode() {
		new daum.Postcode({
			oncomplete : function(data) {
				// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

				// 각 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var addr = ''; // 주소 변수
				var extraAddr = ''; // 참고항목 변수

				//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					addr = data.roadAddress;
				} else { // 사용자가 지번 주소를 선택했을 경우(J)
					addr = data.jibunAddress;
				}

				// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
				if (data.userSelectedType === 'R') {
					// 법정동명이 있을 경우 추가한다. (법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
						extraAddr += data.bname;
					}
					// 건물명이 있고, 공동주택일 경우 추가한다.
					if (data.buildingName !== '' && data.apartment === 'Y') {
						extraAddr += (extraAddr !== '' ? ', '
								+ data.buildingName : data.buildingName);
					}
					// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
					if (extraAddr !== '') {
						extraAddr = ' (' + extraAddr + ')';
					}
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				document.getElementById('empAdd1').value = data.zonecode +" "+ addr;
				// 커서를 상세주소 필드로 이동한다.
				document.getElementById("empAdd2").focus();
			}
		}).open();
	}
</script>






