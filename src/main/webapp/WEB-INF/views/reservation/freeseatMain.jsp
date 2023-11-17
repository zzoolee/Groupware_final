<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<canvas id="canvas" width="1100" height="550"></canvas>


<!-- npm으로 설치한 것처럼 사용가능 -->
<script type="importmap">
{
	"imports": {
		"three": "https://unpkg.com/three@0.141.0/build/three.module.js",
		"GLTFLoader" : "https://unpkg.com/three@0.141.0/examples/jsm/loaders/GLTFLoader.js"
	}
}
</script>

<script type="module">
import {GLTFLoader} from 'GLTFLoader';
import * as THREE from 'three';
	
let scene = new THREE.Scene();
let renderer = new THREE.WebGLRenderer({
	canvas : document.querySelector('#canvas'),
	antialias : true
});
// renderer.setSize(window.innerWidth, window.innerHeight);
renderer.outputEncoding = THREE.sRGBEncoding;

scene.background = new THREE.Color('white');
let light = new THREE.DirectionalLight(0xffffff, 1.5);
light.position.set(0, 1, 0);
scene.add(light);
	
let loader = new GLTFLoader();
loader.load('${pageContext.request.contextPath }/resources/assets/gw/rsv/isometric_office/scene.gltf', function(gltf){
    
	// 모델을 원하는 크기로 확대 (예: 2배) ????
//	const scale = 0.2;
//	gltf.scene.scale.set(scale, scale, scale);

	let boundingBox = new THREE.Box3().setFromObject(gltf.scene); // 모델의 바운딩 박스 계산
	let center = boundingBox.getCenter(new THREE.Vector3()); // 모델 중심 계산
	let size = boundingBox.getSize(new THREE.Vector3()); // 모델 크기 계산
	let maxDim = Math.max(size.x, size.y, size.z); // 가장 긴 모델 차원 선택
	let fov = 2 * Math.atan(maxDim / (2 * 5)) * (180 / Math.PI); // 시야 각도 계산

	let camera = new THREE.PerspectiveCamera(50, window.innerWidth / window.innerHeight, 0.1, 1000);
	camera.position.set(center.x + 3, center.y + maxDim * 1, center.z + 3); // 카메라 위치 조정
	camera.lookAt(center); // 카메라가 모델을 향하도록 설정


	scene.add(gltf.scene);
	renderer.render(scene, camera);
//	const controls = new THREE.OrbitControls(camera, renderer.domElement);


function animate(){
	requestAnimationFrame(animate);
	gltf.scene.rotation.y -= 0.01;
	gltf.scene.rotation.x -= 0.01;
//	controls.update();
//	OrbitControl
	renderer.render(scene, camera);
}
	animate();
});


</script>
</body>
</html>