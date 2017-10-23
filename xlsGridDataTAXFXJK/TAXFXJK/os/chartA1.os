function TAXFXJK_chartA1(){
//初始化中间件类
function _init(request) 
{
	var mwobj = new TAXFXJK_chartA1();
	return mwobj;
}

//输出分析图的方法
function getCharts()
{       
        var hello11 = "hello";       
	var chr = "<script>
		    $(function () {
		    
		    $('body').append(\"<div id='div2' style='min-width:800px;height:400px;margin-top:50px;'>\\
		                         <table border='1' cellspacing='0' style='font-size:14px;' align='center'>\\
		                              <caption align='top'>图形演示</caption>\\
       <tr>\\
          <th width='30%'>指标</th>\\
		  <th>2001</th>\\
		  <th>2005</th>\\
		  <th>2006</th>\\
		  <th>2007</th>\\
		  <th>2008</th>\\
		  <th>2009</th>\\
		  <th>2010</th>\\
		  <th>2011</th>\\
		  <th>2012</th>\\
       </tr>\\
       <tr>\\
	      <td>RAD经费支出（亿元）</td>\\
		  <td>51.69</td>\\
		  <td>92.15</td>\\
		  <td>101.36</td>\\
		  <td>121.80</td>\\
		  <td>145.18</td>\\
		  <td>189.51</td>\\
		  <td>217.50</td>\\
		  <td>249.35</td>\\
		  <td>287.20</td>\\
       </tr>\\
       <tr>\\
	      <td>占GDP比重（%）</td>\\
		  <td>2.80</td>\\
		  <td>2.51</td>\\
		  <td>2.24</td>\\
		  <td>2.23</td>\\
		  <td>2.12</td>\\
		  <td>2.32</td>\\
		  <td>2.15</td>\\
		  <td>1.99</td>\\
		  <td>1.99</td>\\
       </tr>\\
<tr>\\
	      <td>全省地方财政拨款（亿元）</td>\\
		  <td>3.97</td>\\
		  <td>6.78</td>\\
		  <td>10.26</td>\\
		  <td>13.30</td>\\
		  <td>17.14</td>\\
		  <td>20.84</td>\\
		  <td>25.25</td>\\
		  <td>29.01</td>\\
		  <td>34.94</td>\\
       </tr>\\
<tr>\\
	      <td>占全省地方财政支出比重（%）</td>\\
		  <td>1.13</td>\\
		  <td>1.06</td>\\
		  <td>1.25</td>\\
		  <td>1.26</td>\\
		  <td>1.20</td>\\
		  <td>1.13</td>\\
		  <td>1.14</td>\\
		  <td>1.78</td>\\
		  <td>1.04</td>\\
       </tr>\\
<tr>\\
	      <td>全省地方财政拨款（亿元）</td>\\
		  <td>3.97</td>\\
		  <td>6.78</td>\\
		  <td>10.26</td>\\
		  <td>13.30</td>\\
		  <td>17.14</td>\\
		  <td>20.84</td>\\
		  <td>25.25</td>\\
		  <td>29.01</td>\\
		  <td>34.94</td>\\
       </tr>\\
<tr>\\
	      <td>占全省地方财政支出比重（%）</td>\\
		  <td>1.13</td>\\
		  <td>1.06</td>\\
		  <td>1.25</td>\\
		  <td>1.26</td>\\
		  <td>1.20</td>\\
		  <td>1.13</td>\\
		  <td>1.14</td>\\
		  <td>1.78</td>\\
		  <td>1.04</td>\\
       </tr>\\
		                         </table>\\
                                        </div>\");
		    
		    
		    $('#container').highcharts({
		        chart: {
		            zoomType: 'xy'
		        },
		        title: {
		            text: null
		        },
		        subtitle: {
		            text: null
		        },
		        xAxis: [{
		            categories: ['2001', '2005', '2006', '2007', '2008', '2009',
		                '2010', '2011', '2012']
		        }],
		        yAxis: [{
		            
		            title: {
		                text: null
		            },
					opposite: true,
					min:0,
					tickInterval: 0.3
		        }, {
		            title: {
		                text: null
		                
		            },
			    tickInterval: 20
					
		        }],
		
		        series: [{
		            name: '全省地方财政拨款（亿元）',
		            color: '#4572A7',
		            type: 'column',
		            yAxis: 1,
		            data: [3.97, 6.78, 10.26, 13.30, 17.14, 20.84, 25.25, 27.94, 34.94],
					dataLabels: {
					   enabled: true,

		                           color: '#FFFFFF',
		                           align: 'center',
		                            x: 4,
		                            y: -1
					}
		            
		        }, {
		            name: '占全省财政支出比重（%）',
		            color: '#FF0000',
					yAxis: 0,
		            data: [1.13,1.06,1.25,1.26,1.28,1.13,1.14,0.95,1.05],
					dataLabels: {
					   enabled: true,
		               align: 'center',
		               x: 4,
		               y: -10
					}
		        }],
			credits: {
		                enabled: false
		          },
		        exporting: {
		                enabled: true
		        },
		        title: {
		               text:'活动经费分析'
		        }
				
		    });
		    
		                       
		                       
		                       
		});
		</script>";
	return chr;
}
}