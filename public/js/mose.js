/* vim:set ts=4 sw=4: */
var tableValue;
var opt_graph;
$(function () {
    opt_graph = {
        front_rideheight : {
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
                text : 'Trackbar Height.'
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
                }
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
				max : 20
            }
            , series : []
		}
        , left_spring_package : {
            chart : {
                renderTo : 'render_left_spring_package', defaultSeriesType : 'bar'
            }
            , title : {
                text : 'Spring Package (Left Side)'
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
				max : 1200,
				minorTickInterval : 50,
				reversed: true
            }
            , series : []
        }
        , right_spring_package : {
            chart : {
                renderTo : 'render_right_spring_package', defaultSeriesType : 'bar'
            }
            , title : {
                text : 'Spring Package (Right Side)'
            }
            , xAxis : {
                categories : ['Front', 'Rear']
            }
            , yAxis : {
                title : {
                    text : 'lbs/in'
                },
				min : 100,
				max : 1200,
				minorTickInterval : 50,
            }
            , series : []
        }
    };
}
);

function render(graph_type) {
    $.ajax({
        url : '/render/' + graph_type + '?' + $('#form_fileselect').serialize(),
		success : function (json) {
            opt_graph[graph_type].series = json.series;
			this["graph_" + graph_type] = new Highcharts.Chart(opt_graph[graph_type]); 
        }
    });
}

function get_value() {
    tableValue.fnDestroy();
    $.ajax({
        url : '/value?' + $('#form_fileselect').serialize(),
		success : function (html) {
            $('#tablevalue').replaceWith('<table cellpadding="0" cellspacing="0" border="0" class="table table-striped table-bordered" id="tablevalue">' + html + '</table>');
			tableValue = $('#tablevalue').dataTable({
                "sDom" : "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>", "sPaginationType" : "bootstrap", "oLanguage" : {
                    "sLengthMenu" : "_MENU_ records per page"
                }
            }); 
        }
    });
}