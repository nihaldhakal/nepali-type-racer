var countCharacters=0;
var startTime;
var userKeyPressCount=0;

$(document).on("turbolinks:load", function () {
    arrayOfText();
    var text_id = $("#text_id").val();
    $("button").on("click",function () {
        $('.text').focus();
        $('.text').val("");
    });
    // The controller must be type_race and its action must be show do take following action. (Using data-attributes)
    if (((($("body").data("controller")) == "type_races") && ($("body").data("action")) == "show" ) )
    {
        if ($("#type_race_status").data("type_race_status") == "countdown_is_set") {
            displayTime();
        }
        // If the type_race status is pending than keep on reloading page until its status changes.
        if ($("#type_race_status").data("type_race_status") == "pending"){
            setInterval(function () {
                $.ajax({
                    url: "/type_races/" + text_id,
                    type: "GET",
                    dataType: 'json',
                    headers: {'X-Requested-With': 'XMLHttpRequest'},
                    crossOrigin: true,
                    data: {},
                    success: function (data, status, jqXHR) {
                        if (data.status == "countdown_is_set") {
                            location.reload();
                        }
                    },
                    error: function (a, b, c) {
                    }
                });
            }, 1000);
        }
        if ($("#type_race_status").data("type_race_status") == "countdown_is_set") {
             setInterval(function () {
                $.ajax({
                    url: "/type_races/" + text_id,
                    type: "GET",
                    dataType: 'json',
                    headers: {'X-Requested-With': 'XMLHttpRequest'},
                    crossOrigin: true,
                    data: {},
                    success: function (data, status, jqXHR) {
                        if (data.status == "ongoing") {
                            $("#type_race_status").attr("data-type_race_status", data.status);
                            hideTime();
                            fetchProgress();
                        }
                    },
                    error: function (a, b, c) {
                    }
                });
            }, 1000);
        }
        // if ($("#type_race_status").data("type_race_status") == "ongoing") {
        //     hideTime();
        //     setInterval(fetchProgress, 1000);
        // }
    }

    $(".text").keyup(function () {
        if (startTime === undefined) {
            startTime = new Date($.now());
        }
        var modifierKeyKeyCodes = [16, 17, 18, 20, 27, 37, 38, 39, 40, 46];
        if (modifierKeyKeyCodes.includes(event.keyCode) == false) {
            userKeyPressCount++;
        }
        countCharacters += 1;
        var user_id = $("field").data('user-id');
        // var other_user_id = user_id == 1 ? 2 : 1;
        var user_progress = $('#type_race_stat_progress').val();
        // Passing data as a object.
        var data = {
            type_race_stat: {
                "user_id": user_id, "progress": user_progress, "wpm": updateWPM(),
                "accuracy": updateAccuracy()
            }
        };
        giveColorFeedback(getTemplateText(), getText());
        if (isGameOver() == true) {
            handleGameOver(updateWPM());
        }

        // Ajax for update_progress where users data are updated in the database.
        $.ajax({
            url: "/type_races/" + text_id + "/update_progress",
            type: "PUT",
            dataType: 'json',
            headers: {'X-Requested-With': 'XMLHttpRequest'},
            crossOrigin: true,
            data: data,
            success: function (data, status, jqXHR) {
            },
            error: function (a, b, c) {
            }
        });
    });
});

function displayTime() {
    var start = 10;
    var killInterval = setInterval(function () {
        $('.timer').find('span').text("Race starts at:" + start);
        start-=1;
        if(start < 1){
            clearInterval(killInterval);
        }
    },1000);
}

function hideTime() {
    $(".timer").hide();
}

function getTemplateText(){
    return $("#templateText").text();
}

function getText(){
    return $(".text").val();
}

function fetchProgress() {
    // var user_id = $("field").data('user-id');
    // var total_user = $('#user_count').data('user-count');
    // Ajax for fetching progress from the database and displaying it to another player.
    $.ajax({
        url: "/type_races/fetch_progress/" + $('#current_id').val(),
        type: "PUT",
        dataType: "json",
        data: {},
        success:function (data,status,jqXHR) {
            $.each(data,function(index,stat) {
                updateProgress(stat);
                displayWpm(stat);
            });
        },
        error: function (a,b,c) {
        }
    });
}

function updateProgress(stat) {
    var text = stat.progress;
    if (text == null){
        text = ''
    }
    var $userRow = $('.user_row[data-id='+ stat.user_id + ']');
    updateProgressBar($userRow.find('.bar'),getTemplateText(),text);
}

function updateProgressBar($progressBar,templateText,text){
    var percentage = 3 + getProgress(templateText,text);
    var currentCharIndex = text.length - 1;
    for(var i = currentCharIndex; i <= templateText.length - 1 ; i++) {
        if (text[currentCharIndex] === templateText[currentCharIndex]) {
            $progressBar.css("width", percentage + "%" );
            // $("#newBar").animate({left: "+=500"}, 2000);
        }
    }
}

function getProgress(templateText,text){
    var text_length = text.length;
    var quote_length = templateText.length;
    return ((text_length / quote_length) * 100);
}

function giveColorFeedback(templateText,text){
    let currentCharIndex = 0 ;
    for(let i = currentCharIndex; i < templateText.length  ; i++){
        $("span #" + i).removeClass("match unmatch");
    }
    for (let i= currentCharIndex; i<text.length; i++){
        if (text[i] == templateText[i]){
            $("span #" + i).addClass("match").removeClass("unmatch");
        } else {
            $("span #"  + i).removeClass("match").addClass("unmatch");
        }
    }
}

function updateWPM(){
    var currentTime=new Date($.now());
    if (isNaN(startTime) == true){
        startTime = new Date($.now());
    }
    var timeInSecs = (currentTime-startTime)/1000;
    var timeInMins = timeInSecs/60;
    var wordsWritten = countCharacters/5;
    var wpm = wordsWritten/timeInMins;
    wpm = parseInt(wpm,10);
    return wpm
    // $('#checkWpm'+ stat.user_id +'').text(wpm);
}

function displayWpm(stat) {
    var user_id = $("field").data('user-id');
    $('.user_row[data-id = '+ stat.user_id +']').find('.wpm span').text(stat.wpm);
}

function updateAccuracy() {
    var textCharLen= getTemplateText().length;
    var userKeyPressInputCharLen=userKeyPressCount;
    var accuracy = ( textCharLen/userKeyPressInputCharLen )*100;
    accuracy=Math.round( accuracy );
    return accuracy
}

function displayAccuracy() {


}

function isGameOver(){
    return (getTemplateText()===getText());
}

function displayEndStats(wpm){
    $('#showData').removeClass("hidden");
    $('#showData').find("p").text($("p").data('user-name') + " your speed of the race is " + wpm);
    $('#accuracy').text(updateAccuracy());
}


function handleGameOver(wpm) {
    displayEndStats(wpm);
    disableInput();
}

function disableInput() {
    $('.text').prop('disabled', true);
}

function arrayOfText() {
    var textTemplateCharArray = getTemplateText().split("");
    for(var spanCount=0; spanCount < textTemplateCharArray.length; spanCount++) {
        textTemplateCharArray[spanCount] = '<span id= "'+spanCount +'">' + textTemplateCharArray[spanCount] + '</span>';
    }
    var textTemplateSpanified = textTemplateCharArray.join("");
    $("#templateText").html(textTemplateSpanified);
}

var quotes = ["Hello there", "Genius is one percent inspiration and ninety-nine percent perspiration.", "You can observe a lot just by watching.",
    "A house divided against itself cannot stand.",
    "Difficulties increase the nearer we get to the goal.","Fate is in your hands and no one elses",
    "Be the chief but never the lord.","Nothing happens unless first we dream.","Well begun is half done.", "Life is a learning experience," +
    " only if you learn."
    ,"Self-complacency is fatal to progress.","Peace comes from within. Do not seek it without.","What you give is what you get.",
    "We can only learn to love by loving.","Life is change. Growth is optional. Choose wisely.","You'll see it when you believe it."
    ,"Today is the tomorrow we worried about yesterday.","It's easier to see the mistakes on someone else's paper."
    , "Every man dies. Not every man really lives.","To lead people walk behind them.","Having nothing, nothing can he lose."]
