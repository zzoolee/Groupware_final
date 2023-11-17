<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


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
				<div class="container-fluid pb-7">
					<div class="card mt-7" style="border-radius:20px">
						<div class="row pb-11">
							<div class="col-1" style=""></div>
							<div class="col-8">
								<h2 style="margin: 40px 0px 0px 0px">연차사용</h2>
							</div>
						</div>
						
						<div class="row pb-3">
							<div class="col-1"></div>
							<div class="col-10">
								<h4 class="fw-normal">잔여연차조회</h4>
							</div>
						</div>
						
						<div class="row">
							<div class="col-1"></div>
							<div class="col-10 ">
								<div class="row align-items-center bg-primary bg-gradient" style="border-radius:10px; height:40px;">
									<div class="col-4">
										<h4 class="text-white text-center">총연차개수</h4>
									</div>
									<div class="col-4">
										<h4 class="text-white text-center">사용연차개수</h4>
									</div>
									<div class="col-4">
										<h4 class="text-white text-center">잔여연차개수</h4>
									</div>
								</div>
							</div>
						</div>
						
						<div class="row pb-3">
							<div class="col-1"></div>
							<div class="col-10">
								<div class="row align-items-center" style="border-radius:10px; height:40px;">
									<div class="col-4">
										<h4 class="text-center">15개</h4>
									</div>
									<div class="col-4">
										<h4 class="text-center">2개</h4>
									</div>
									<div class="col-4">
										<h4 class="text-center">13개</h4>
									</div>
								</div>
							</div>
						</div>
						
						<div class="row pb-7">
							<div class="col-7"></div>
							<div class="col-4 d-flex justify-content-end">
								<span>잔여 연차는 해당 12월 31일전까지 사용을 권장합니다.</span>
							</div>
						</div>
						
						<div class="row pb-7">
							<div class="col-9"></div>
							<div class="col-2 d-flex justify-content-end">
								<button class="btn btn-phoenix-secondary me-1 mb-1" type="button">연차 신청하기</button>
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
			</div>
		</div>
	</div>

<!-- 출근처리 확인 모달 -->
<div class="modal fade" id="hiModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">출근등록</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">박성민님 08:30분 출근처리가 완료되었습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-primary" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>

<!-- 퇴근처리 확인 모달 -->
<div class="modal fade" id="byeModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">퇴근등록</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0">박성민님 18:02분 퇴근처리가 완료되었습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-primary" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>

<script type="text/javascript">
$(function(){
	var hiBtn = $('#hiBtn');
	var byeBtn = $('#byeBtn');
	var hiModal = $('#hiModal');
	var byeModal = $('#byeModal');
	
	hiBtn.on('click', function(){
		hiModal.show();
	});
	
	byeBtn.on('click', function(){
		byeModal.show();
	});
	
	CKEDITOR.replace('exampleTextarea'
            , {height: 500                                                  
            });
	
	
});
</script>