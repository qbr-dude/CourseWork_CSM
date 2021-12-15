$(document).ready(function () {
    $('.seance-button').hover(function () {
        $(this).siblings('.seance-time').css('text-decoration', 'underline');
    }, function () {
        $(this).siblings('.seance-time').css('text-decoration', 'none');
    });
    $('.seat').on("click", function () {

        let seatPlace = $(this).children('img').attr('alt');
        let row = seatPlace.split('-')[0];
        let seat = seatPlace.split('-')[1];

        if (lockedSeats.indexOf(row + '-' + seat) != -1) {
            return;
        }
        if (selectedTickets.indexOf(row + '-' + seat) != -1) {
            selectedTickets.splice(selectedTickets.indexOf(row + '-' + seat), 1);

            $(this).children('img').css({ 'outline': 'none', 'opacity': .4 });
        } else {
            $(this).children('img').css({ 'outline': '3px solid #5c6b7f', 'opacity': 1 });
            selectedTickets.push(row + '-' + seat);
        }
        drawTicketInfo();
    });
    function drawTicketInfo() {
        if (selectedTickets.length > 0) {
            $('.seats-count').text(selectedTickets.length);
            $('.ticket-cost').text(selectedTickets.length * ticketCost + ' рублей');
            $('.seats-handler > div > button').prop('disabled', false);
            $('.seats-handler > div > button').css({ 'opacity': 1, 'cursor': 'pointer' });
        }
        else {
            $('.seats-count').text("");
            $('.ticket-cost').text("");
            $('.seats-handler > div > button').prop('disabled', true);
            $('.seats-handler > div > button').css({ 'opacity': .5, 'cursor': 'default' });
        }
    }
    $(".seats-handler button").on("click", ticketOrdered = function () {
        let dataRow = [];
        for (var i = 0; i < selectedTickets.length; i++) {
            dataRow.push(seanceId + '-' + selectedTickets[i] + '-' + ticketCost);
        }
        let data = JSON.stringify(dataRow);
        $.ajax({
            url: "../CreateTickets",
            type: "POST",
            data: { tickets: data },
            success: function () {
                ShowOrdered();
                //window.location = "../Index";
            },
            error: function () {
                console.log(data);
            }
        });
    });
    function ShowOrdered() {
        $('.wrapper').css('z-index', -1);
        $('.ordered-active').css('visibility', 'visible');
    }
    let removeActive = false;
    $('.remove-toggle').click(function (event) {
        event.preventDefault();
        $('.wrapper').toggleClass('remove-active');
        $('.remove-ticket-form').toggleClass('remove-active');
        removeActive = !removeActive;
    });
    $('#remove-film').on('change', function (e) {
        e.preventDefault();
        let film = $(this).val();
        $.ajax({
            url: 'Home/_SeancesSearch',
            type: 'GET',
            data: { film: film },
            success: function (partialView) {
                $('#remove-film-seances').html(partialView);
                $('#remove-film-seances').show();
            }
        })
    })
    $('.remove-notice-close').click(function () {
        $('.remove-notice').remove();
    })
});