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
        // If the type_race status is pending than keep on reloading page until its status changes.
        if ($("#type_race_status").data("type_race_status") == "pending"){
            setInterval(function () {
                location.reload();
            },3000);
        }
        if ($("#type_race_status").data("type_race_status") == "ongoing"){
            setInterval(fetchProgress,1000);
        }

    }
    $(".text").keyup(function () {
        var user_id = $("field").data('user-id');
        // var other_user_id = user_id == 1 ? 2 : 1;
        var user_1 = $('#type_race_user_1_progress').val();
        var user_2 = $('#type_race_user_2_progress').val();
        var user_1_wpm = $('#checkWpm1').text();
        var user_2_wpm = $('#checkWpm2').text();
        var user_1_accuracy = $('#accuracy1').text();
        var user_2_accuracy = $('#accuracy2').text();
        // Passing data as a object.
        var data= {type_race: {"user_id": user_id,"user_1_progress": user_1,"user_2_progress": user_2,"user_1_wpm": user_1_wpm,
                "user_2_wpm": user_2_wpm,"user_1_accuracy": user_1_accuracy,"user_2_accuracy": user_2_accuracy}};
        giveColorFeedback(getTemplateText(),getText());
        // updateProgressBar("#newBar"+ user_id ,text,template_text);
        updateWPM();

        if (isGameOver() == true){
            handleGameOver();
        }
        // Ajax for update_progress where users data are updated in the database.
        $.ajax({
            url: "/type_races/update_progress/" + text_id,
            type: "PUT",
            dataType: 'json',
            headers: {'X-Requested-With': 'XMLHttpRequest'},
            crossOrigin: true,
            data :  data,
            success: function (data,status,jqXHR) {
            },
            error: function (a,b,c) {
            }
        });

    });

    $(".text").on("input",function(event){
        if (startTime === undefined) {
            startTime = new Date($.now());
        }
        var modifierKeyKeyCodes = [16,17,18,20,27,37,38,39,40,46];
        if (modifierKeyKeyCodes.includes(event.keyCode) == false) {
            userKeyPressCount++;
        }
    });
});

function getTemplateText(){
    return $("#templateText").text();
}
function getText(){
    return $(".text").val();
}

function fetchProgress() {
    // Ajax for fetching progress from the database and displaying it to another player.
    $.ajax({
        url: "/type_races/fetch_progress/" + $('#current_id').val(),
        type: "PUT",
        dataType: "json",
        data: {},
        success:function (data,status,jqXHR) {
            updateProgress(1, data);
            updateProgress(2, data);

        },
        error: function (a,b,c) {
        }
    });
}

function updateProgress(userId, data) {
    var text = data["user_"+ userId +"_progress"];
    if (text == null){
        text = ''
    }
    updateProgressBar("#newBar"+ userId ,getTemplateText(),text);
}

function arrayOfText() {
    var textTemplateCharArray = getTemplateText().split("");
    for(var spanCount=0; spanCount < textTemplateCharArray.length; spanCount++) {
        textTemplateCharArray[spanCount] = '<span id= "'+spanCount +'">' + textTemplateCharArray[spanCount] + '</span>';
    }
    var textTemplateSpanified = textTemplateCharArray.join("");
    $("#templateText").html(textTemplateSpanified);
}

function updateWPM(){
    countCharacters += 1;
    var currentTime=new Date($.now());
    var timeInSecs = (currentTime-startTime)/1000;
    var timeInMins = timeInSecs/60;
    var wordsWritten = countCharacters/5;
    var wpm = wordsWritten/timeInMins;
    wpm = parseInt(wpm,10);
    if ($("field").data('user-id') == 1){
        $('#checkWpm1').text(wpm);
    }else {
        $('#checkWpm2').text(wpm);
    }
}

function updateProgressBar(identifier,templateText,text){
    var percentage = 3 + getProgress(templateText,text);
    var progressBar = $(identifier);
    var currentCharIndex = text.length - 1;
    for(var i = currentCharIndex; i <= templateText.length - 1 ; i++) {
        if (text[currentCharIndex] === templateText[currentCharIndex]) {
            $(progressBar).css("width", percentage + "%" );
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
            // console.log($("span #" + i));
        } else {
            $("span #"  + i).removeClass("match").addClass("unmatch");
        }
    }
}

function isGameOver(){
    return (getTemplateText()===getText());
}

function handleGameOver() {
    displayAccuracy();
    disableInput();
}

function displayAccuracy() {
    var textCharLen= getTemplateText().length;
    var userKeyPressInputCharLen=userKeyPressCount;
    var accuracy = ( textCharLen/userKeyPressInputCharLen )*100;
    accuracy=Math.round( accuracy );
    $('#showAccuracy').removeClass("hidden");
    if ($("field").data('user-id') == 1){
        $(' #accuracy1').text(accuracy);
    }else {
        $(' #accuracy2').text(accuracy);
    }

}
function disableInput() {
    $('.text').prop('disabled', true);
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
