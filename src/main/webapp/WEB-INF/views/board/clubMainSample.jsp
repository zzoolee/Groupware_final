<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<h2>동호회</h2>

<div class="pb-5">
	<div class="row g-4">
		<div class="col-12 col-xxl-6"></div>

	</div>
</div>
<div
	class="mx-n4 px-4 mx-lg-n6 px-lg-6 bg-white pt-7 border-y border-300">
	<div data-list='{"valueNames":["product","customer","rating","review","time"],"page":6}'>
		<div class="row">
			<div class="col-4"></div>
			<div class="col-4 text-center">
				<h2>I WORKS 동호회</h2>
			</div>
			<div class="col-4"></div>
		</div>
		<div class="row py-9">
			<div class="col-4"></div>
			<div class="col-4">
				<div class="search-box w-100">
					<form class="position-relative" data-bs-toggle="search"
						data-bs-display="static">
						<input class="form-control search-input search" type="search"
							placeholder="Search ..." aria-label="Search" /> <span
							class="uil uil-search search-box-icon"></span>

					</form>
				</div>
			</div>
			<div class="col-4"></div>
		</div>
		<div class="row">
			<div class="col-1"></div>
			<div class="col-4">
				<div class="row">
				
					<div>
						<h4 class="text-center pb-5 text-center">
							전체동호회
							<div class="d-flex justify-content-end">
								<button class="btn btn-soft-secondary me-1 mb-1" type="button" id="allClub">더보기</button>
							</div>
						</h4>
						
					</div>
					<div class="col-4" style="border:solid 1px black; height:200px">
						<img src="${pageContext.request.contextPath }/resources/assets/img/other404/로아줘.png" style="height:100%; width:100%;">
					</div>
					<div class="col-8" style="border:solid 1px black; height:200px;">
						<h5 class="text-center py-4">한화 이글스 팬 동호회</h5>
						<span>
							한화 이글스 팬들은 모두모두 모여라!!
							야구 관람 같이 가실분! 공원에서 캐치볼 하실분!
							야구 경기잡구 친선전 하실분 모두모두!!
							가입신청 주시면 3일안에 답장드려요.
						</span>
					</div>
					
					<div class="col-4" style="border:solid 1px black; height:200px">
						<img src="${pageContext.request.contextPath }/resources/assets/img/other404/오호오호.png" style="height:100%; width:100%;">
					</div>
					<div class="col-8" style="border:solid 1px black; height:200px;">
						<h5 class="text-center py-4">오호동호회</h5>
						<span>
							오호오호오호오호오호오호오호오호오호오호오호오호오호오호오호오호
							오호오호오호오호오호오호오호오호오호오호오호오호오호오호오호오호
						</span>
					</div>
					
					<div class="col-4" style="border:solid 1px black; height:200px">
						<img src="${pageContext.request.contextPath }/resources/assets/img/other404/얼마나화남.png" style="height:100%; width:100%;">
					</div>
					<div class="col-8" style="border:solid 1px black; height:200px;">
						<h5 class="text-center py-4">코딩 동아리</h5>
						<span>
							어쩔 404<p>
							저쩔 널포인트
						</span>
					</div>
					
				</div>
			</div>
			
			
			<div class="col-2"></div>
			<div class="col-4">
				<div class="row pb-9">
					
					
					<div>
						<h4 class="text-center pb-10">인기동호회</h4>
					</div>
					<div class="col-4" style="border:solid 1px black; height:200px">
						<img src="${pageContext.request.contextPath }/resources/assets/img/other404/로아줘.png" style="height:100%; width:100%;">
					</div>
					<div class="col-8" style="border:solid 1px black; height:200px;">
						<h5 class="text-center py-4">한화 이글스 팬 동호회</h5>
						<span>
							한화 이글스 팬들은 모두모두 모여라!!
							야구 관람 같이 가실분! 공원에서 캐치볼 하실분!
							야구 경기잡구 친선전 하실분 모두모두!!
							가입신청 주시면 3일안에 답장드려요.
						</span>
					</div>
					
					<div class="col-4" style="border:solid 1px black; height:200px">
						<img src="${pageContext.request.contextPath }/resources/assets/img/other404/오호오호.png" style="height:100%; width:100%;">
					</div>
					<div class="col-8" style="border:solid 1px black; height:200px;">
						<h5 class="text-center py-4">오호동호회</h5>
						<span>
							오호오호오호오호오호오호오호오호오호오호오호오호오호오호오호오호
							오호오호오호오호오호오호오호오호오호오호오호오호오호오호오호오호
						</span>
					</div>
					
					<div class="col-4" style="border:solid 1px black; height:200px">
						<img src="${pageContext.request.contextPath }/resources/assets/img/other404/얼마나화남.png" style="height:100%; width:100%;">
					</div>
					<div class="col-8" style="border:solid 1px black; height:200px;">
						<h5 class="text-center py-4">코딩 동아리</h5>
						<span>
							어쩔 404<p>
							저쩔 널포인트
						</span>
					</div>
					
				</div>
			</div>
			<div class="col-1"></div>
		</div>
	</div>
</div>


<script type="text/javascript">
$(function(){
	var allClub = $('#allClub');
	var clubId = $('#clubId');
	
	allClub.on('click', function(){
		location.href="/cluball.do";
	});
	
	clubId.on('click', function(){
		location.href="/clubdetail.do";
	});

});
</script>