<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="col-sm-10 col-md-8 col-lg-5 col-xl-5 col-xxl-3">
  <div class="d-flex flex-center text-decoration-none mb-4">
    <div class="d-flex align-items-center fw-bolder fs-5 d-inline-block">
    <img src="${pageContext.request.contextPath }/resources/assets/gw/IW_Logo.png" alt="i-works" width="58" />
    </div>
  </div>
  <div class="text-center mb-7">
    <h3 class="text-1000">환영합니다!</h3>
<!--     <p class="text-700">Get access to your account</p> -->
  </div>
<!--   <button class="btn btn-phoenix-secondary w-100 mb-3"><span class="fab fa-google text-danger me-2 fs--1"></span>Sign in with google</button> -->
<!--   <button class="btn btn-phoenix-secondary w-100"><span class="fab fa-facebook text-primary me-2 fs--1"></span>Sign in with facebook</button> -->
<!--   <div class="position-relative"> -->
<!--     <hr class="bg-200 mt-5 mb-4" /> -->
<!--     <div class="divider-content-center">or use email</div> -->
<!--   </div> -->
<form action="/login" method="post">
  <div class="mb-3 text-start">
    <span class="fs--4" for="email">아이디</span>
    <div class="form-icon-container">
      <input class="form-control form-icon-input" name="username" placeholder="아이디(사번)을 입력해주세요" /><span class="fas fa-user text-900 fs--1 form-icon"></span>
    </div>
  </div>
  <div class="mb-3 text-start">
    <span class="fs--4" for="password">비밀번호</span>
    <div class="form-icon-container">
      <input class="form-control form-icon-input" name="password" type="password" placeholder="비밀번호를 입력해주세요" /><span class="fas fa-key text-900 fs--1 form-icon"></span>
    </div>
  </div>
  <div class="row flex-between-center mb-7">
    <div class="col-auto">
      <div class="form-check mb-0">
        <input class="form-check-input" id="basic-checkbox" type="checkbox" checked="checked" name="remember-me"/>
        <label class="form-check-label mb-0" for="basic-checkbox">로그인 상태 유지</label>
      </div>
    </div>
    <div class="col-auto"><a class="fs--1 fw-semi-bold" href="/findpw.do">비밀번호 찾기</a></div>
  </div>
  <input class="btn btn-primary w-100 mb-3" type="submit" value="로그인">
</form>
</div>