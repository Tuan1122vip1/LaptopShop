<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Thống kê</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script>
	window.onload = function() {
		var data = [];
		var label = [];
		var dataForDataSets = [];
		var dataMonth = [];
		var labelMonth = [];
		var datasetForMonth = [];
		var dataRemaining = [];
		var labelRemaining = [];
		var datasetForRemaining = [];

		$.ajax({
			async : false,
			type : "GET",
			data : data,
			contentType : "application/json",
			url : "http://localhost:8080/laptopshop/api/don-hang/report",
			success : function(data) {
				for (var i = 0; i < data.length; i++) {
					label.push(data[i][0] + "/" + data[i][1]);
					dataForDataSets.push(data[i][2]/1000000);
				}
			},
			error : function(e) {
				alert("Error: ", e);
				console.log("Error", e);
			}
		});

		$.ajax({
			async: false,
			type: "GET",
			data: dataMonth,
			contentType: "application/json",
			url: "http://localhost:8080/laptopshop/api/don-hang/statistical",
			success: function (data){
				for (var i = 0; i < 5; i++){
					labelMonth.push(data[i][0]);
					datasetForMonth.push(data[i][1]);
				}
			},
			error: function (e){
				alert("Error: ", e);
				console.log("Error", e);
			}
		});

		$.ajax({
			async: false,
			type: "GET",
			data: dataRemaining,
			contentType: "application/json",
			url: "http://localhost:8080/laptopshop/api/don-hang/remaining",
			success: function (data){
				for (var i = 0; i < 6; i++){
					labelRemaining.push(data[i][0]);
					datasetForRemaining.push(data[i][1]);
				}
			},
			error: function (e){
				alert("Error: ", e);
				console.log("Error", e);
			}
		});

		
		$.ajax({
			async: false,
			type: "GET",
			url: "http://localhost:8080/laptopshop/api/don-hang/remaining",
			success: function(data) {
				var tableBody = $("#table-body");
				for (var i = 0; i < data.length; i++) {
				var tr = $("<tr>");
				var productName = $("<td>").text(data[i][0]);
				var remainingQty = $("<td>").text(data[i][1]);
				tr.append(productName);
				tr.append(remainingQty);
				tableBody.append(tr);
				}
			},
			error: function(e) {
				alert("Error: ", e);
				console.log("Error", e);
			}
		});

		$.ajax({
			async: false,
			type: "GET",
			url: "http://localhost:8080/laptopshop/api/don-hang/outofstock",
			success: function(data) {
				var tableBody = $("#table-out");
				for (var i = 0; i < data.length; i++) {
				var tr = $("<tr>");
				var maSanPham = $("<td>").text(data[i].id);
				var tenSanPham = $("<td>").text(data[i].tenSanPham);
				var donGia = $("<td>").text(data[i].donGia);
				var danhMuc = $("<td>").text(data[i].danhMuc.tenDanhMuc);
				var hangSanXuat = $("<td>").text(data[i].hangSanXuat.tenHangSanXuat);
				tr.append(maSanPham);
				tr.append(tenSanPham);
				tr.append(donGia);
				tr.append(danhMuc);
				tr.append(hangSanXuat);
				tableBody.append(tr);
				}
			},
			error: function(e) {
				console.log("Error", e);
			}
		});
		
		var canvas = document.getElementById('myChart');
		var canvas2 = document.getElementById('myChartv2');
		var canvas3 = document.getElementById('myChartv3');

		data = {
			labels : label,
			datasets : [ {
				label : "Tổng giá trị ( Triệu đồng)",
				backgroundColor : "#0000ff",
				borderColor : "#0000ff",
				borderWidth : 2,
				hoverBackgroundColor : "#0043ff",
				hoverBorderColor : "#0043ff",
				data : dataForDataSets,
			} ]
		};
		var option = {
			scales : {
				yAxes : [ {
					stacked : true,
					gridLines : {
						display : true,
						color : "rgba(255,99,132,0.2)"
					}
				} ],
				xAxes : [ {
					barPercentage: 0.5,
					gridLines : {
						display : false
					}
				} ]
			},
			maintainAspectRatio: false,
			legend: {
	            labels: {
	                // This more specific font property overrides the global property
	                fontSize: 20
	            }
			}
		};

		var myBarChart = Chart.Bar(canvas, {
			data : data,
			options : option
		});

		var bgColor = [];
		for (let i = 0; i < datasetForMonth.length; i++) {
			bgColor.push(getRandomColor());
		}

		dataMonth = {
			labels: labelMonth,
			datasets: [{
				data : datasetForMonth,
				backgroundColor: bgColor
			}]
		};
		dataRemaining = {
			labels: labelRemaining,
			datasets: [{
				data : datasetForRemaining,
				backgroundColor: bgColor
			}]
		};
		function getRandomColor(){
			var letters = '0123456789ABCDEF';
			var color = '#';
			for (var i = 0; i < 6; i++) {
				color += letters[Math.floor(Math.random() * 16)]
			}
			return color;
		}

		var myBarChartv2 = new Chart(canvas2, {
			type: 'doughnut',
			data: dataMonth
		})

		var myBarChartv3 = new Chart(canvas3, {
			type: 'doughnut',
			data: dataRemaining
		})
	}
</script>

</head>
<body>
	<jsp:include page="template/header.jsp"></jsp:include>
	<jsp:include page="template/sidebar.jsp"></jsp:include>
	<div class="col-md-9 animated bounce" style="height: 100%">
		<h3 class="page-header">Thống kê</h3>

		<ul class="nav nav-tabs" style="margin-bottom: 25px">
			<li class="active"><a data-toggle="tab" href="#tab1">Thống kê doanh thu</a></li>
			<li><a data-toggle="tab" href="#tab2">Sản phẩm bán chạy</a></li>
			<li><a data-toggle="tab" href="#tab3">Thống kê số lượng còn của sản phẩm bán chạy </a></li>
			<li><a data-toggle="tab" href="#tab4">Số lượng còn trong kho </a></li>
			<li><a data-toggle="tab" href="#tab5">Sản phẩm hết hàng </a></li>
		</ul>
	
		<div class="tab-content">
	
			<div class="col-md-9 animated bounce tab-pane fade in active" style="height: 100%" id="tab1">
				<canvas id="myChart" style="width: 200px; height: 200px;"></canvas>
				<h4 style="text-align: center;">Biểu đồ tổng doanh thu hàng theo tháng</h4>
			</div>

			<div class="col-md-9 animated bounce tab-pane fade" style="height: 100%" id="tab2">
				<canvas id="myChartv2" style="width: 200px; height: 200px;"></canvas>
				<h4 style="text-align: center;">Biểu đồ tổng hợp sản phẩm bán chạy</h4>
			</div>

			<div class="col-md-9 animated bounce tab-pane fade" style="height: 100%" id="tab3">
				<canvas id="myChartv3" style="width: 200px; height: 200px;"></canvas>
				<h4 style="text-align: center;">Biểu đồ tổng hợp số lượng còn của mặt hàng bán chạy</h4>
			</div>

			<div class="col-md-9 animated bounce tab-pane fade" style="height: 100%" id="tab4">
				<h3 class="tk">Bảng thống kê sản phẩm trong kho</h3>
				<table id="inventoryTable">
					<thead>
					  <tr>
						<th>Sản phẩm</th>
						<th>Số lượng còn</th>
					  </tr>
					</thead>
					<tbody id="table-body">
					</tbody>
				</table>
			</div>

			<div class="col-md-9 animated bounce tab-pane fade" style="height: 100%" id="tab5">
				<h3 class="tk">Bảng thống kê sản phẩm hết hàng</h3>
				<table id="inventoryTable">
					<thead>
					  <tr>
						<th>Mã sản phẩm</th>
						<th>Tên sản phẩm</th>
						<th>Đơn giá</th>
						<th>Tên danh mục</th>
						<th>Tên nhà sản xuất</th>
					  </tr>
					</thead>
					<tbody id="table-out">
					</tbody>
				</table>
			</div>

		</div>
	</div>

	<jsp:include page="template/footer.jsp"></jsp:include>

	<script type="text/javascript"
		src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.1.3/Chart.min.js"></script>
</body>


</html>
<style>
	.tk{
		text-align: center;
	}
	table {
		border-collapse: collapse;
		width: 100%;
		font-family: Arial, sans-serif;
		color: #444;
		border: 1px solid #f2f2f2;
		text-align: center;
	}
	th, td {
		text-align: center;
		padding: 8px;
	}
	th {
		background-color: #3b8bbc;
		color: white;
	}
	tr:nth-child(even) {
		background-color: #f2f2f2;
	}
	tr:hover {
		background-color: #ddd;
	}
	h1 {
		font-family: Arial, sans-serif;
		color: #3b8bbc;
		text-align: center;
	}
	</style>
</style>