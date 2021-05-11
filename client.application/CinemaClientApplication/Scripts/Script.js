$(document).ready(function () {
    $('.seance-button').hover(function () {
        $(this).siblings('.seance-time').css('text-decoration', 'underline');
    }, function () {
        $(this).siblings('.seance-time').css('text-decoration', 'none');
    });
    $('.seat').on("click", function () {

        let seatPlace = $(this).children('img').attr('alt');
        let row = seatPlace.substring(0, 1);
        let seat = seatPlace.substring(2);

        if (lockedSeats.indexOf(row + '-' + seat) != -1) {
            return;
        }
        if (selectedTickets.indexOf(row + '-' + seat) != -1) {
            selectedTickets.splice(selectedTickets.indexOf(row + '-' + seat), 1);

            console.log(selectedTickets);
            $(this).children('img').css({ 'outline': 'none', 'opacity': .5 });
        } else {
            $(this).children('img').css({ 'outline': '3px solid #f6974c', 'opacity': 1 });
            selectedTickets.push(row + '-' + seat);
        }
        drawTicketInfo();
    });
    function drawTicketInfo() {
        if (selectedTickets.length > 0) {
            $('.seats-count').text(selectedTickets.length);
            $('.ticket-cost').text(selectedTickets.length * ticketCost + ' рублей');
        }
        else {
            $('.seats-count').text("");
            $('.ticket-cost').text("");
        }
    }
    $(".seats-handler button").on("click", function () {
        let dataRow = [];
        for (var i = 0; i < selectedTickets.length; i++) {
            console.log(seanceId + '-' + selectedTickets[i] + '-' + ticketCost);
            dataRow.push(seanceId + '-' + selectedTickets[i] + '-' + ticketCost);
            console.log(dataRow);
        }
        let data = JSON.stringify(dataRow);
        console.log(data);
        $.ajax({
            url: "../CreateTickets",
            type: "POST",
            data: { tickets: data },
            success: function () {
                console.log(data);

            }, 
            error: function () {
                console.log(data);
            }
        });
    });
});