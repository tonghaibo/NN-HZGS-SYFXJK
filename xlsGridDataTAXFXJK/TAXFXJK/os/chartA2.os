function TAXFXJK_chartA2(){
//��ʼ���м����
function _init(request) 
{
	var mwobj = new TAXFXJK_chartA2();
	return mwobj;
}

//�������ͼ�ķ���
function getCharts()
{       
        var hello11 = "hello";       
	var chr = "<script>
		    $(function () {
		    
		    $('body').append(\"<div id='div2' style='min-width:800px;height:400px;margin-top:50px;'>\\
		                         <table border='1' cellspacing='0' style='font-size:14px;' align='center'>\\
		                              <caption align='top'>����֧������Դ�ͻ���ͷ�</caption>\\
       <tr>\\
          <th width='30%'>ָ��</th>\\
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
	      <td>RAD����֧������Ԫ��</td>\\
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
	      <td>��ҵ�ʽ�</td>\\
		  <td>12.48</td>\\
		  <td>23.27</td>\\
		  <td>33.83</td>\\
		  <td>34.07</td>\\
		  <td>44.09</td>\\
		  <td>66.77</td>\\
		  <td>76.73</td>\\
		  <td>97.77</td>\\
		  <td>114.52</td>\\
       </tr>\\
<tr>\\
	      <td>�����ʽ�</td>\\
		  <td>34.52</td>\\
		  <td>56.51</td>\\
		  <td>57.89</td>\\
		  <td>80.23</td>\\
		  <td>94.10</td>\\
		  <td>115.23</td>\\
		  <td>131.00</td>\\
		  <td>141.44</td>\\
		  <td>161.83</td>\\
       </tr>\\
<tr>\\
	      <td>����</td>\\
		  <td>4.69</td>\\
		  <td>12.36</td>\\
		  <td>10.87</td>\\
		  <td>5.66</td>\\
		  <td>8.20</td>\\
		  <td>11.11</td>\\
		  <td>12.22</td>\\
		  <td>8.99</td>\\
		  <td>13.14</td>\\
       </tr>\\
		                         </table>\\
                                        </div>\");
		    
		    
		    $('#container').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: '����֧�����ʽ���Դ�ֲ�2012'
        },
        tooltip: {
    	    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    color: '#000000',
                    connectorColor: '#000000',
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                }
            }
        },
        series: [{
            type: 'pie',
            name: '���ʽ���Դ�ֲ�',
            data: [
                ['��ҵ˰��',   39.87],
                ['����',       3.78],               
                ['����˰��',    56.35]
            ]
        }],
        exporting:{
           enabled:false
        }
    });	
		                       
		                       
		                       
		});
		</script>";
	return chr;
}

}