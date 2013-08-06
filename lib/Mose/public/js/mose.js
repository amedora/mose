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
        , front_rideheight : {
            chart : {
                renderTo : 'render_front_rideheight', defaultSeriesType : 'line'
            }
            , title : {
                text : 'Front Ride Height'
            }
            , xAxis : {
                categories : ['LF', 'RF']
            }
            , yAxis : {
                title : {
                    text : 'inch'
                }
                
            }
            , series : []
        }
        , rear_rideheight : {
            chart : {
                renderTo : 'render_rear_rideheight', defaultSeriesType : 'line'
            }
            , title : {
                text : 'Rear Ride Height'
            }
            , xAxis : {
                categories : ['LR', 'RR']
            }
            , yAxis : {
                title : {
                    text : 'inch'
                }
                
            }
            , series : []
        }
        , rideheight_relation : {
            chart : {
                renderTo : 'render_rideheight_relation', defaultSeriesType : 'line'
            }
            , title : {
                text : 'Front Ride Height Avg. vs Rear Ride Height Avg.'
            }
            , xAxis : {
                categories : ['Front', 'Rear']
            }
            , yAxis : {
                title : {
                    text : 'inch'
                }
                
            }
            , series : []
        }
        , trackbar_height : {
            chart : {
                renderTo : 'render_trackbar_height', defaultSeriesType : 'line'
            }
            , title : {
                text : 'Trackbar Height'
            }
            , xAxis : {
                categories : ['LR', 'RR']
            }
            , yAxis : {
                title : {
                    text : 'inch'
                }
                
            }
            , series : []
        }
        , front_tiretemp : {
            chart : {
                renderTo : 'render_front_tiretemp', defaultSeriesType : 'column'
            }
            , title : {
                text : 'Front Tire Temp'
            }
            , xAxis : {
                categories : ['LF(O)', 'LF(M)', 'LF(I)', 'RF(I)', 'RF(M)', 'RF(O)']
            }
            , yAxis : {
                title : {
                    text : 'F'
                },
				min : 100,
				max : 300,
				minorTickInterval : 10
            }
            , series : []
        }
        , rear_tiretemp : {
            chart : {
                renderTo : 'render_rear_tiretemp', defaultSeriesType : 'column'
            }
            , title : {
                text : 'Rear Tire Temp'
            }
            , xAxis : {
                categories : ['LR(O)', 'LR(M)', 'LR(I)', 'RR(I)', 'RR(M)', 'RR(O)']
            }
            , yAxis : {
                title : {
                    text : 'F'
                },
				min : 100,
				max : 300,
				minorTickInterval : 10
            }
            , series : []
        }
        , front_tread : {
            chart : {
                renderTo : 'render_front_tread', defaultSeriesType : 'column'
            }
            , title : {
                text : 'Front Tire Tread'
            }
            , xAxis : {
                categories : ['LF(O)', 'LF(M)', 'LF(I)', 'RF(I)', 'RF(M)', 'RF(O)']
            }
            , yAxis : {
                title : {
                    text : '%'
                },
				max : 100,
				min : 50
            }
            , series : []
        }
        , rear_tread : {
            chart : {
                renderTo : 'render_rear_tread', defaultSeriesType : 'column'
            }
            , title : {
                text : 'Rear Tire Tread'
            }
            , xAxis : {
                categories : ['LR(O)', 'LR(M)', 'LR(I)', 'RR(I)', 'RR(M)', 'RR(O)']
            }
            , yAxis : {
                title : {
                    text : '%'
                },
				max : 100,
				min : 50
            }
            , series : []
        }
        , left_tiretemp_avg : {
            chart : {
                renderTo : 'render_left_tiretemp_avg', defaultSeriesType : 'bar'
            }
            , title : {
                text : 'Tire Temp Avg. (Left Side)'
            }
            , xAxis : {
                categories : ['Front', 'Rear', 'Front & Rear'],
				opposite: true
            }
            , yAxis : {
                title : {
                    text : 'F'
                },
				min : 100,
				max : 300,
				minorTickInterval : 10,
				reversed: true
            }
            , series : []
        }
        , right_tiretemp_avg : {
            chart : {
                renderTo : 'render_right_tiretemp_avg', defaultSeriesType : 'bar'
            }
            , title : {
                text : 'Tire Temp Avg. (Right Side)'
            }
            , xAxis : {
                categories : ['Front', 'Rear', 'Front & Rear'],
            }
            , yAxis : {
                title : {
                    text : 'F'
                },
				min : 100,
				max : 300,
				minorTickInterval : 10,
            }
            , series : []
        }
        , left_weight_dist : {
            chart : {
                renderTo : 'render_left_weight_dist', defaultSeriesType : 'bar'
            }
            , title : {
                text : 'Left Side Weight'
            }
            , xAxis : {
                categories : ['Front', 'Rear'],
				opposite: true
            }
            , yAxis : {
                title : {
                    text : 'lbs.'
                },
				minorTickInterval : 50,
				reversed: true
            }
            , series : []
        }
        , right_weight_dist : {
            chart : {
                renderTo : 'render_right_weight_dist', defaultSeriesType : 'bar'
            }
            , title : {
                text : 'Right Side Weight'
            }
            , xAxis : {
                categories : ['Front', 'Rear']
            }
            , yAxis : {
                title : {
                    text : 'lbs.'
                },
				minorTickInterval : 50,
            }
            , series : []
		}
        , ballast : {
            chart : {
                renderTo : 'render_ballast', defaultSeriesType : 'scatter'
            }
            , title : {
                text : 'Ballast Forward'
            }
            , xAxis : {
            }
            , yAxis : {
                title : {
                    text : 'inch'
                },
				min : -20,
				max : 20,
				tickInterval : 5,
				minorTickInterval : 1
            }
            , series : []
		}
        , left_spring_package : {
            chart : {
                renderTo : 'render_left_spring_package', defaultSeriesType : 'bar'
            }
            , title : {
                text : 'Spring Rate (Left Side)'
            }
            , xAxis : {
                categories : ['Front', 'Rear'],
				opposite: true
            }
            , yAxis : {
                title : {
                    text : 'lbs/in'
                },
				min : 100,
				max : 500,
				minorTickInterval : 25,
				reversed: true
            }
            , series : []
        }
        , right_spring_package : {
            chart : {
                renderTo : 'render_right_spring_package', defaultSeriesType : 'bar'
            }
            , title : {
                text : 'Spring Rate (Right Side)'
            }
            , xAxis : {
                categories : ['Front', 'Rear']
            }
            , yAxis : {
                title : {
                    text : 'lbs/in'
                },
				min : 100,
				max : 500,
				minorTickInterval : 25,
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
				"sDom": "<'row-fluid'<'span4'l><'span4'T><'span4'f>r><'row-fluid'<'span12't>><'row-fluid'<'span5'i><'span7'p>>",
				"oTableTools": {
					"sSwfPath": '/swf/copy_csv_xls_pdf.swf',
					"aButtons": ['copy', 'csv', 'pdf', 'print']
				},
				/*
                "sDom" : "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
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
                "sDom" : "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
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

