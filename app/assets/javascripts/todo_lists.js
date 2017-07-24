function set_positions(elements){
    elements.each(function(i){
        $(this).attr('data-pos',i+1);
    });
}

function sort_list(elements){
    set_positions(elements);
    $('.sortable').sortable().bind('sortupdate', function(e, ui) {
        // array to store new order
        updated_order = [];

        _target = $(e.target);
        _target_li = _target.children('li');

        set_positions(_target_li);

        _target_id = _target.data('id');

        // populate the updated_order array with the new task positions
        _target_li.each(function(i){
            updated_order.push({ id: $(this).data('id'), position: i+1 });
        });

        // send the updated order via ajax
        $.ajax({
            type: 'PUT',
            url: '/todo_lists/' + _target_id + '/sort',
            data: { order: updated_order }
        });
    });
}