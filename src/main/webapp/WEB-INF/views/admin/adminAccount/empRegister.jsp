<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="pb-9">
	<div class="row">
		<div class="col-12">
			<div class="row align-items-center justify-content-between g-3 mb-3">
				<div class="col-12 col-md-auto">
					<h2 class="mb-0">계정생성</h2>
				</div>
			</div>
		</div>
	</div>
	<c:if test="${not empty msg }">
		<script type="text/javascript">
			alert("${msg }");
			<c:remove var="msg" scope="session"/>	
			<c:remove var="msg" scope="request"/>	
		</script>
	</c:if>
<form class="needs-validation" novalidate="" action="/adminEmpRegisterSingle.do" method="post" id="registerForm">
	<div class="row g-0 g-md-4 g-xl-6 justify-content-start">
			<div class="col-md-5 col-lg-5 col-xl-4">
				<div class="card mb-3">
					<div class="card-body">
						<div class="d-flex align-items-center mb-5">
							<h3>사원 등록</h3>
						</div>
						<div class="row align-items-center g-3 text-center text-xxl-start">
							<div class="col-12 col-sm-auto flex-1">
								<p class="mb-0 fw-bold">* 이름<input class="form-control" type="text" id="empName" name="empName" placeholder="계정을 생성할 이름을 입력해주세요" value="" required=""/></p>
								<div class="checkName text-danger text-center"></div>
								<br>
								<p class="mb-0 fw-bold">* 직급
									<select class="form-select" name="empRank" id="empRank">
										<option value="A201">사원</option>
										<option value="A202">대리</option>
										<option value="A203">과장</option>
										<option value="A204">차장</option>
										<option value="A205">부장</option>
										<option value="A206">임원</option>
									</select>
								</p>
								<br>
								<p class="fw-bold">* 부서
									<select class="form-select" name="deptCd" id="deptCd">
										<option value="A011">경영지원팀</option>
										<option value="A012">인사총무팀</option>
										<option value="A013">구매조달팀</option>
										<option value="A014">콜센터</option>
										<option value="B011">시스템영업팀</option>
										<option value="B012">공공영업팀</option>
										<option value="B013">기술지원팀</option>
										<option value="B014">교육운영팀</option>
										<option value="C011">보안개발팀</option>
										<option value="C012">SW개발팀</option>
										<option value="D011">사업기획팀</option>
										<option value="D012">SM영업1팀</option>
										<option value="D013">SM영업2팀</option>
										<option value="D014">서비스센터</option>
										<option value="E011">수도권</option>
										<option value="E012">중부권</option>
										<option value="E013">서부권</option>
										<option value="E014">동부권</option>
										<option value="F01">연구개발본부</option>
									</select>
								</p>
							</div>
						
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 uil uil-phone"> </span>
								<h5 class="text-1000 mb-0">연락처</h5>
							</div>
							<input class="form-control" type="text" id="empHp" name="empHp" placeholder="010-1234-1234" value="" required=""/>
							<div class="checkHp text-danger text-center"></div>
						</div>
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 uil uil-user"></span>
								<h5 class="text-1000 mb-0">주민번호</h5>
							</div>
							<p class="mb-0 text-800"><input class="form-control" type="text" id="empRegno" name="empRegno" placeholder="123456-1234567" value="" required=""/></p>
							<div class="checkRegNo text-danger text-center"></div>
						</div>
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 uil uil-user"></span>
								<h5 class="text-1000 mb-0">성별</h5>
							</div>
							<p class="mb-0 text-800">
								<div class="form-check form-check-inline">
								  <input class="form-check-input" id="empGender1" type="radio" name="empGender" value="남성" />
								  <label class="form-check-label" for="empGender1">남성</label>
								</div>
								<div class="form-check form-check-inline">
								  <input class="form-check-input" id="empGender2" type="radio" name="empGender" value="여성" />
								  <label class="form-check-label" for="empGender2">여성</label>
								</div>
							</p>
						</div>
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 uil uil-user"></span>
								<h5 class="text-1000 mb-0">내/외국인</h5>
							</div>
							<p class="mb-0 text-800">
								<div class="form-check form-check-inline">
								  <input class="form-check-input" id="empForeig1" type="radio" name="empForeig" value="내국인" />
								  <label class="form-check-label" for="empForeig1">내국인</label>
								</div>
								<div class="form-check form-check-inline">
								  <input class="form-check-input" id="empForeig2" type="radio" name="empForeig" value="외국인" />
								  <label class="form-check-label" for="empForeig2">외국인</label>
								</div>
							</p>
						</div>
						<div class="mb-4">
							<div class="d-flex align-items-center mb-1">
								<span class="me-2 uil uil-calendar-alt"></span>
								<h5 class="text-1000 mb-0">입사일자</h5>
							</div>
							<p class="mb-0 text-800"><input class="form-control" type="date" id="empHire" name="empHire" placeholder="입사일자" value="" required=""/></p>
							<div class="checkHire text-danger text-center"></div>
						</div>
						<div class="mb-4">
							<div class="mb-4">
								<div class="d-flex justify-content-center align-items-end mb-1">
									<button class="btn btn-info" type="button" id="btn">등록</button>
								</div>
							</div>
						</div>
							
						</div>
					</div>
				</div>
<!-- 				<div class="card mb-3"> -->
<!-- 					<div class="card-body"> -->
<!-- 						<div class="d-flex align-items-center mb-5"> -->
<!-- 							<h3>사원 계정 생성</h3> -->
<!-- 						</div> -->
<!-- 						<div class="mb-4"> -->
<!-- 							<div class="d-flex align-items-center mb-1"> -->
<!-- 								<span class="me-2 uil uil-phone"> </span> -->
<!-- 								<h5 class="text-1000 mb-0">연락처</h5> -->
<!-- 							</div> -->
<!-- 							<input class="form-control" type="text" id="empHp" name="empHp" placeholder="010-1234-1234" value="" required=""/> -->
<!-- 							<div class="checkHp text-danger text-center"></div> -->
<!-- 						</div> -->
<!-- 						<div class="mb-4"> -->
<!-- 							<div class="d-flex align-items-center mb-1"> -->
<!-- 								<span class="me-2 uil uil-user"></span> -->
<!-- 								<h5 class="text-1000 mb-0">주민번호</h5> -->
<!-- 							</div> -->
<!-- 							<p class="mb-0 text-800"><input class="form-control" type="text" id="empRegno" name="empRegno" placeholder="123456-1234567" value="" required=""/></p> -->
<!-- 							<div class="checkRegNo text-danger text-center"></div> -->
<!-- 						</div> -->
<!-- 						<div class="mb-4"> -->
<!-- 							<div class="d-flex align-items-center mb-1"> -->
<!-- 								<span class="me-2 uil uil-user"></span> -->
<!-- 								<h5 class="text-1000 mb-0">성별</h5> -->
<!-- 							</div> -->
<!-- 							<p class="mb-0 text-800"> -->
<!-- 								<div class="form-check form-check-inline"> -->
<!-- 								  <input class="form-check-input" id="empGender1" type="radio" name="empGender" value="남성" /> -->
<!-- 								  <label class="form-check-label" for="empGender1">남성</label> -->
<!-- 								</div> -->
<!-- 								<div class="form-check form-check-inline"> -->
<!-- 								  <input class="form-check-input" id="empGender2" type="radio" name="empGender" value="여성" /> -->
<!-- 								  <label class="form-check-label" for="empGender2">여성</label> -->
<!-- 								</div> -->
<!-- 							</p> -->
<!-- 						</div> -->
<!-- 						<div class="mb-4"> -->
<!-- 							<div class="d-flex align-items-center mb-1"> -->
<!-- 								<span class="me-2 uil uil-user"></span> -->
<!-- 								<h5 class="text-1000 mb-0">내/외국인</h5> -->
<!-- 							</div> -->
<!-- 							<p class="mb-0 text-800"> -->
<!-- 								<div class="form-check form-check-inline"> -->
<!-- 								  <input class="form-check-input" id="empForeig1" type="radio" name="empForeig" value="내국인" /> -->
<!-- 								  <label class="form-check-label" for="empForeig1">내국인</label> -->
<!-- 								</div> -->
<!-- 								<div class="form-check form-check-inline"> -->
<!-- 								  <input class="form-check-input" id="empForeig2" type="radio" name="empForeig" value="외국인" /> -->
<!-- 								  <label class="form-check-label" for="empForeig2">외국인</label> -->
<!-- 								</div> -->
<!-- 							</p> -->
<!-- 						</div> -->
<!-- 						<div class="mb-4"> -->
<!-- 							<div class="d-flex align-items-center mb-1"> -->
<!-- 								<span class="me-2 uil uil-user"></span> -->
<!-- 								<h5 class="text-1000 mb-0">입사일자</h5> -->
<!-- 							</div> -->
<!-- 							<p class="mb-0 text-800"><input class="form-control" type="date" id="empHire" name="empHire" placeholder="입사일자" value="" required=""/></p> -->
<!-- 							<div class="checkHire text-danger text-center"></div> -->
<!-- 						</div> -->
<!-- 						<div class="mb-4"> -->
<!-- 							<div class="mb-4"> -->
<!-- 								<div class="d-flex justify-content-center align-items-end mb-1"> -->
<!-- 									<button class="btn btn-primary" type="button" id="btn">등록</button> -->
<!-- 									<button class="btn btn-outline-success" style="margin-left: 10px;" type="button" id="uploadFileBtn">일괄등록</button> -->
<!-- 									<button class="btn btn-outline-warning" style="margin-left: 10px;" type="button" id="downFormBtn">양식 다운로드</button> -->
<!-- 								</div> -->
<!-- 							</div> -->
<!-- 						</div> -->
<!-- 					</div> -->
<!-- 				</div> -->
			</div>
			<div class="col-4">
				<div class="card mb-3">
					<div class="card-body">
						<h3>사원 다수 생성</h3><br>
						<p><svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check text-danger"><polyline points="20 6 9 17 4 12"></polyline></svg>
						양식 다운로드 버튼을 클릭하여 양식을 다운로드해 주세요.</p>
						<p><svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check text-danger"><polyline points="20 6 9 17 4 12"></polyline></svg>
						양식에 맞게 사원들의 정보를 작성해 주세요.</p>
						<p><svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check text-danger"><polyline points="20 6 9 17 4 12"></polyline></svg>
						일괄등록 버튼을 클릭하여 Excel 파일을 첨부해 주세요.</p>
						<div>
							<img alt="" src="${pageContext.request.contextPath }/resources/assets/gw/excelImg.PNG" style="height: 400px; width: 450px;">
						</div>
						<br>
						<div style="text-align: center;">
							<button class="btn btn-success" style="margin-left: 10px;" type="button" id="uploadFileBtn">일괄등록</button>
							<button class="btn btn-outline-success" style="margin-left: 10px;" type="button" id="downFormBtn">양식 다운로드</button>
						</div>
					</div>
				</div>
			</div>
			<!-- 사원 생성 사진  -->
			<div class="row col-4 g-0 g-md-6 g-xl-6 justify-content-end">
				<div>
					<img alt="" src="${pageContext.request.contextPath }/resources/assets/gw/adminEmpInsert.png" style="height: 700px;">
				</div>
			</div>
		</div>
	</form>
</div>
<!--  회원 등록 전 확인 모달 -->
<div class="modal fade" id="verticallyCentered" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true" style="display: none; width:25em;  top: 50%;  left: 50%;
    transform: translate(-50%, -50%);">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header text-center">
				<h5 class="modal-title" id="verticallyCenteredModalLabel">아래의 정보를 확인해주세요</h5>
			</div>
			<div class="modal-body text-center">
				<h5 class="text-700 lh-lg">
					<label class="">* 이름</label>
				</h5>
				<p class="text-1000 lh-lg">
					<label style="font-weight: bold;" id="laName"></label>
				</p>
				<h5 class="text-700 lh-lg">
					<label class="">* 직급</label>
				</h5>
				<p class="text-1000 lh-lg">
					<label style="font-weight: bold;" id="laRank"></label>
				</p>
				<h5 class="text-700 lh-lg">
					<label class="">* 부서</label>
				</h5>
				<p class="text-1000 lh-lg">
					<label style="font-weight: bold;" id="laDept"></label>
				</p>
				<h5 class="text-700 uil uil-phone lh-lg">
					<label class="">연락처</label>
				</h5>
				<p class="text-1000 lh-lg">
					<label style="font-weight: bold;" id="laHp"></label>
				</p>
				<h5 class="text-700 uil uil-user lh-lg">
					<label class="">주민번호</label>
				</h5>
				<p class="text-1000 lh-lg">
					<label style="font-weight: bold;" id="laRegNo"></label>
				</p>
				<h5 class="text-700 uil uil-user  lh-lg">
					<label class="">성별</label>
				</h5>
				<p class="text-1000 lh-lg">
					<label style="font-weight: bold;" id="laGender"></label>
				</p>
				<h5 class="text-700 uil uil-user lh-lg">
					<label class="">내/외국인</label>
				</h5>
				<p class="text-1000 lh-lg">
					<label style="font-weight: bold;" id="laFore"></label>
				</p>
				<h5 class="text-700 uil uil-calendar-alt lh-lg">
					<label class="">입사일자</label>
				</h5>
				<p class="text-1000 lh-lg">
					<label style="font-weight: bold;" id="laHire"></label>
				</p>
			</div>
			<div class="modal-footer">
				<button class="btn btn-info" type="button" id="registerBtn" onclick="$('#registerForm').submit()">확인</button>
				<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>

<!--  파일 업로드 모달 -->
<div class="modal fade" id="FileUploadModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="verticallyCenteredModalLabel">파일 업로드</h5>
			</div>
			<div class="modal-body">
				<form class="needs-validation" novalidate="" action="/uploadExcel.do" method="post" enctype="multipart/form-data" id="FormUploadFile">
					<p class="text-700 lh-lg mb-0"> 업로드할 엑셀파일을 선택해주세요
					<input class="form-control" name="empExcel" id="empExcel" type="file" accept=".xlsx, .xls" required=""/>
					<div class="checkExcelFile text-danger text-center"></div>
					</p>
				</form>
			</div>
			<div class="modal-footer">
				<button class="btn btn-success" type="button" id="excelUploadBtn">확인</button>
				<button class="btn btn-outline-success" type="button" data-bs-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	//양식 다운 버튼
	var downFormBtn = $("#downFormBtn");
	//등록 버튼
	var btn = $("#btn");
	//모달 내부 폼 전송 버튼
	var registerBtn = $("#registerBtn");
	//일괄등록 버튼
	var uploadFileBtn = $("#uploadFileBtn");
	// 엑셀파일 전송 버튼
	var excelUploadBtn = $("#excelUploadBtn");
	// 라벨 요소 아이디
	var laName = $("#laName");
	var laRank = $("#laRank");
	var laDept = $("#laDept");
	var laHp = $("#laHp");
	var laRegNo = $("#laRegNo");
	var laGender = $("#laGender");
	var laFore = $("#laFore");
	var laHire = $("#laHire");

	// input 요소 아이디
	var empName = $("#empName");
	var empRank = $("#empRank");
	var deptCd = $("#deptCd");
	var empHp = $("#empHp");
	var empRegno = $("#empRegno");
	var empHire = $("#empHire");

	// 선택된 성별과 내/외국인 value를 저장할 변수 
	var empGender;
	var empForeign;
	
	// 핸드폰 번호 정규식
	var empHpReg = /^\d{3}-\d{3,4}-\d{4}$/;
	// 주민번호 정규식
	var empRegnoReg = /^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$/;
	
	// submit 전 모달창에서 데이터 확인
	btn.on("click", function() {
		// 이름 입력확인
		if (empName.val() == null || empName.val() == "") {
			$(".checkName").text("이름을 입력해주세요!");
			empName.focus();
			return;
		}
		// 연락처 입력확인
		if (empHp.val() == null || empHp.val() == "") {
			$(".checkHp").text("연락처를 입력해주세요!");
			empHp.focus();
			return;
		}
		// 연락처 정규식 확인 
		if ((empHp.val() != null || empHp.val() != "") && empHp.val().length > 0){
			if(!empHpReg.test(empHp.val())){
				$(".checkHp").text("연락처 형식을 확인해주세요!");
				empHp.focus();
				return;
			}
		}
		// 주민번호 입력 확인
		if (empRegno.val() == null || empRegno.val() == "") {
			$(".checkRegNo").text("주민번호를 입력해주세요!");
			empRegno.focus();
			return;
		}
		// 주민번호 정규식 확인 
		if((empRegno.val() != null || empRegno.val() != "") && empRegno.val().length > 0){
			if(!empRegnoReg.test(empRegno.val())){
				$(".checkRegNo").text("주민번호를 확인해주세요!");
				empRegno.focus();
				return;
			}
		}
		// 입사일자 입력 확인
		if (empHire.val() == null || empHire.val() == "") {
			$(".checkHire").text("입사일자를 입력해주세요!");
			empHire.focus();
			return;
		}

		laName.text(empName.val());

		var empRankText = $("select[name=empRank] option:selected").text();
		laRank.text(empRankText);

		var deptCdText = $("select[name=deptCd] option:selected").text();
		laDept.text(deptCdText);

		laHp.text(empHp.val());
		laRegNo.text(empRegno.val());

		if ($("#empGender1").prop("checked")) {
			empGender = $("#empGender1").val()
		} else {
			empGender = $("#empGender2").val()
		}
		laGender.text(empGender);

		if ($("#empForeig1").prop("checked")) {
			empForeign = $("#empForeig1").val()
		} else {
			empForeign = $("#empForeig2").val()
		}
		laFore.text(empForeign);

		laHire.text(empHire.val());

		$("#verticallyCentered").modal("show");

	});
	// 일광등록 모달창 열기
	uploadFileBtn.on("click", function() {
		$("#FileUploadModal").modal("show");
	});
	
	// 엑셀파일 업로드
	excelUploadBtn.on("click", function(){
		if($("#empExcel").val() == null || $("#empExcel").val() =="" ){
			$(".checkExcelFile").text("업로드 할 파일을 등록해주세요!");
			return;
		}
		$('#FormUploadFile').submit();
	});
	
	downFormBtn.on("click", function(){
		location.href="/regiserFormDown.do";
// 		$.ajax({
// 			type : "post",
// 			url : "/regiserFormDown.do",
// 			success : function(res){
// 				if(res === "ok"){
// 					alert("양식 다운로드 성공 \n D: > temp");
// 				}else{
// 					alert("양식 다운로드 실패...");
// 				}
// 			}
// 		});
	});

</script>