t2hui.runtable = {};

t2hui.runtable.build_table = function() {
    var columns = [
        { 'name': 'tools', 'label': 'tools', 'class': 'tools', 'builder': t2hui.runtable.tool_builder },

        { 'name': 'concurrency',  'label': 'C', 'class': 'count', 'builder': t2hui.runtable.build_concurrency },
        { 'name': 'passed',  'label': 'P', 'class': 'count', 'builder': t2hui.runtable.build_pass },
        { 'name': 'failed',  'label': 'F', 'class': 'count', 'builder': t2hui.runtable.build_fail },
        { 'name': 'retried', 'label': 'R', 'class': 'count', 'builder': t2hui.runtable.build_retry },

        { 'name': 'project', 'label': 'project', 'class': 'project'},
        { 'name': 'status',  'label': 'status',  'class': 'status'},
        { 'name': 'duration', 'label': 'duration', 'class': 'duration' },
    ];

    if (show_user || !single_user) {
        columns.push({ 'name': 'user', 'label': 'user', 'class': 'user'});
    }

    var table = new FieldTable({
        'class': 'run_table',
        'id': 'runs',

        'updatable': true,

        'modify_row_hook': t2hui.runtable.modify_row,
        'place_row': t2hui.runtable.place_row,

        'dynamic_field_attribute': 'fields',
        'dynamic_field_fetch': t2hui.runtable.field_fetch,
        'dynamic_field_builder': t2hui.runtable.field_builder,

        'columns': columns,
        'postfix_columns': [
            { 'name': 'added', 'label': 'date+time (' + time_zone + ')', 'class': 'date' },
        ]
    });

    return table;
}

t2hui.runtable.place_row = function(row, item, table, state, existing) {
    if (existing) {
        return false;
    }

    if (!state['biggest']) {
        state['biggest'] = item.run_ord;
        return false;
    }

    if (item.run_ord > state.biggest) {
        state['biggest'] = item.run_ord;
        table.body.prepend(row);
        return true;
    }

    return false;
}

t2hui.runtable.build_concurrency = function(item, col) {
    var val = item.concurrency;
    if (val === null) { return };
    if (val === undefined) { return };
    col.text("-j" + val);
};

t2hui.runtable.build_pass = function(item, col) {
    var val = item.passed;
    if (val === null) { return };
    if (val === undefined) { return };
    col.text(val);
};

t2hui.runtable.build_fail = function(item, col) {
    var val = item.failed;
    if (val === null) { return };
    if (val === undefined) { return };
    if (val == 0) { col.append($('<div class="success_txt">' + val + '</div>')) }
    else { col.append($('<a href="' + base_uri  + 'failed/' + item.run_id + '">' + val + '</a>')) }
};

t2hui.runtable.build_retry = function(item, col) {
    var val = item.retried;
    if (val === null) { return };
    if (val === undefined) { return };
    if (val == 0) { col.append($('<div class="success_txt">' + val + '</div>')) }
    else { col.append($('<div class="iffy_txt">' + val + '</div>')) }
};

t2hui.runtable.tool_builder = function(item, tools, data) {
    var link = base_uri + 'view/' + item.run_id;
    var downlink = base_uri + 'download/' + item.run_id;

    var params = $('<div class="tool etoggle" title="See Run Parameters"><img src="/img/data.png" /></div>');
    tools.append(params);
    params.click(function() {
        var formatter = new JSONFormatter(item.parameters, 2);
        $('#modal_body').html(formatter.render());
        $('#free_modal').slideDown();
    });

    if (item.log_file_id) {
        var download = $('<a class="tool etoggle" title="Download Log" href="' + downlink + '"><img src="/img/download.png" /></a>');
        tools.append(download);
    }
    else {
        var download = $('<a class="tool etoggle inactive" title="No Log To Download"><img src="/img/download.png" /></a>');
        tools.append(download);
    }

    if (item.status == 'broken') {
        var go = $('<a class="tool etoggle inactive" title="Cannot Open Run"><img src="/img/goto.png" /></a>');
        tools.append(go);
    }
    else {
        var go = $('<a class="tool etoggle" title="Open Run" href="' + link + '"><img src="/img/goto.png" /></a>');
        tools.append(go);
    }

    if (item.coverage_id) {
        var cover_link = base_uri + 'coverage/' + item.coverage_id;
        var cover = $('<a class="tool etoggle" title="Coverage Data" href="' + cover_link + '"><img src="/img/coverage.png" /></a>');
        tools.append(cover);

        if (item.pinned) {
            var cover = $('<a class="tool etoggle inactive" title="Cannot delete locked coverage data"><img src="/img/coveragedel.png" /></a>');
            tools.append(cover);
        }
        else {
            var coverdel = $('<a class="tool etoggle" title="Delete Coverage Data"><img src="/img/coveragedel.png" /></a>');
            tools.append(coverdel);

            coverdel.click(function() {
                var ok = confirm("Are your sure you want to delete this coverage data? This cannot be undone!");
                if (!ok) { return; }

                cover.replaceWith($('<a class="tool etoggle inactive" title="No Coverage Data"><img src="/img/coverage.png" /></a>'));
                coverdel.replaceWith($('<a class="tool etoggle inactive" title="No Coverage Data"><img src="/img/coveragedel.png" /></a>'));

                $.ajax(cover_link + '/delete', {
                    'data': { 'content-type': 'application/json' },
                    'error': function(a, b, c) { alert("Failed to delete coverage") },
                    'success': function() { return },
                });
            });
        }
    }
    else {
        var cover = $('<a class="tool etoggle inactive" title="No Coverage Data"><img src="/img/coverage.png" /></a>');
        tools.append(cover);

        var coverdel = $('<a class="tool etoggle inactive" title="No Coverage Data"><img src="/img/coveragedel.png" /></a>');
        tools.append(coverdel);
    }

    var del = $('<div class="tool etoggle" title="delete"><img src="/img/close.png"/></div>');
    var pin = $('<img />');
    var pintool = $('<a class="tool etoggle"></a>');

    var pinstate;
    if (item.pinned == true) {
        pintool.prop('title', 'unpin');
        pinstate = true;
        pin.attr('src', '/img/locked.png');
        del.addClass('inactive');
    }
    else {
        pintool.prop('title', 'pin');
        pinstate = false;
        pin.attr('src', '/img/unlocked.png');
        del.removeClass('inactive');
    }

    if (item.status == 'running' || item.status == 'pending') {
        var cancel = $('<div class="tool etoggle error" title="cancel"><img src="/img/close.png"/></div>');
        tools.append(cancel);
        cancel.click(function() {
            var ok = confirm("Are you sure you wish to cancel this run? This action cannot be undone!\nNote: This only changes the runs status, it will not stop a running test. This is used to 'fix' an aborted run that is still set to 'running'");
            if (!ok) { return; }

            var url = base_uri + 'run/' + item.run_id + '/cancel';
            $.ajax(url, {
                'data': { 'content-type': 'application/json' },
                'error': function(a, b, c) { alert("Failed to cancel run") },
                'success': function() { return },
            });
        });
    }
    else {
        tools.append(del);

        del.click(function() {
            if (pinstate) {
                alert("Pinned runs cannot be deleted");
                return;
            }

            var ok = confirm("Are you sure you wish to delete this run? This action cannot be undone!");
            if (!ok) { return; }

            var url = base_uri + 'run/' + item.run_id + '/delete';
            $.ajax(url, {
                'data': { 'content-type': 'application/json' },
                'error': function(a, b, c) { alert("Could not delete run") },
                'success': function() {
                    $('tr#' + item.run_id).remove();
                },
            });
        });
    }

    if (item.error) {
        var err = $('<div class="tool etoggle error" title="See Error Message"><img src="/img/error.png"/></div>');
        tools.append(err);
        err.click(function() {
            var pre = $('<pre></pre>');
            pre.text(item.error);
            $('#modal_body').append(pre);
            $('#free_modal').slideDown();
        });
    }

    pintool.append(pin);
    tools.prepend(pintool);

    pintool.click(function() {
        var url = base_uri + 'run/' + item.run_id + '/pin';
        $.ajax(url, {
            'data': { 'content-type': 'application/json' },
            'error': function(a, b, c) { alert("Failed to pin run") },
            'success': function() {
                pinstate = !pinstate;
                pintool.children().remove();

                pin = $('<img />');
                if (pinstate) {
                    pintool.prop('title', 'unpin');
                    pin.attr('src', '/img/locked.png');
                    del.addClass('inactive');
                }
                else {
                    pintool.prop('title', 'pin');
                    pin.attr('src', '/img/unlocked.png');
                    del.removeClass('inactive');
                }

                pintool.append(pin);
            },
        });
    });
};

t2hui.runtable.field_fetch = function(field_data, item) {
    return base_uri + 'run/' + field_data.run_id;
};

t2hui.runtable.field_builder = function(data, name) {
    var it;
    data.fields.forEach(function(field) {
        if (field.name === name) {
            it = field.data;
            return false;
        }
    });

    return it;
};

t2hui.runtable.modify_row = function(row, item) {
    if (item.status == 'canceled') {
        row.addClass('iffy_set');
        return;
    }

    if (item.failed > 0) {
        row.addClass('error_set');
    }
    else if(item.passed > 0) {
        row.addClass('success_set');
    }

    row.addClass(item.status + "_set");
};
