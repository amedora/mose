/* vim:set ts=4 sw=4: */
var tableData;
var tableLaptime;
var opt_graph;
$(function () {
    opt_graph = {
        laptime : {
            chart : {
                renderTo : 'render_laptime', defaultSeriesType : 'line'
            }
            , title : {
                text : 'Lap Time'
            }
            , tooltip : {
				formatter : function () {
					var mil = this.point.y;
					var min = Math.round(mil / 60000);
					mil -= (min * 60000);
					var sec = mil / 1000;
					return '<b>' + this.series.name + '</b><br/>'
						+ 'Lap: ' + this.point.x + '<br/>'
						+ 'Time: ' + min + ':' + sec;
				}
			}
            , xAxis : {
				title : {
					text : 'lap'
				}
			}
            , yAxis : {
                title : {
                    text : 'time'
                }
				, labels : {
					formatter : function () {
						var mil = this.value;
						var min = Math.round(mil / 60000);
						mil -= (min * 60000);
						var sec = mil / 1000;
						return min + ':' + sec;
					}
				}
				, minorTickInterval: 'auto'
            }
            , series : []
        }
    };
}
);

function render_laptime(car) {
    $.ajax({
		type : 'GET',
		dataType : 'json',
		cache : false,
		async : false,
        url : '/render/laptime/' + car + '?' + $('#form_fileselect').serialize(),
		success : function (json) {
			$('#analysis-tab a[href="#tab-laptime"]').tab('show');
            opt_graph['laptime'].series = json.series;
			graph_laptime = new Highcharts.Chart(opt_graph['laptime']); 
        }
    });
}

function render(graph_type, car) {
    $.ajax({
        url : '/render/graph/' + graph_type + '/' + car + '?' + $('#form_fileselect').serialize(),
		success : function (json) {
            opt_graph[graph_type].series = json.series;
			this["graph_" + graph_type] = new Highcharts.Chart(opt_graph[graph_type]); 
        }
    });
}

function get_data() {
    tableData.fnDestroy();
    $.ajax({
		type : 'GET',
        url : '/analysis/datatable?' + $('#form_fileselect').serialize(),
		success : function (html) {
            $('#tabledata').replaceWith(html);
			tableData = $('#tabledata').dataTable({
				"iDisplayLength" : 150,
				"aaSorting" : [],
				"sDom": "<'row'<'col-md-4'l><'col-md-4'T><'col-md-4'f>r><'row'<'col-md-12't>><'row'<'col-md-5'i><'col-md-7'p>>",
				"oTableTools": {
					"sSwfPath": '/swf/copy_csv_xls_pdf.swf',
					"aButtons": ['copy', 'csv', 'pdf', 'print']
				},
				/*
                "sDom" : "<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-6'i><'col-md-6'p>>",
				*/
				"sPaginationType" : "bootstrap", "oLanguage" : {
                    "sLengthMenu" : "_MENU_ components per page"
                }
            }); 
        }
    });
}

function listlaptime() {
	if (!!tableLaptime) {
		tableLaptime.fnDestroy();
	}
    $.ajax({
        url : '/laptime/list?' + $('#form_fileselect').serialize(),
		success : function (html) {
            $('#laptime-list').replaceWith('<div id="laptime-list">' + html + '</div>');
			tableLaptime = $('#tablelaptime').dataTable({
                "sDom" : "<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-6'i><'col-md-6'p>>",
				"sPaginationType" : "bootstrap", "oLanguage" : {
                    "sLengthMenu" : "_MENU_ records per page"
                }
            }); 
        }
    });
}

function savemark() {
    $.ajax({
		type : 'GET',
        url : '/laptime/savemark?' + $('#form_recordselect').serialize(),
		success : function () {
			alert("Done!");
		}
	});
}

